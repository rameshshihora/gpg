sign()
{
	echo "Processing..$1"
	echo "gpg2 --ask-cert-level --sign-key $1"
	echo "gpg2 --armor --export $2 | gpg2 --encrypt -r $2 --armor --output $$2_$1.asc"
	flag=0
}

for key in `cat keys`
#for key in $1
do
	echo "Importing $key..."
	echo "====================="
	gpg2 --recv-keys $key
	echo "====================="
	echo
	echo
	echo
	echo "====================="
	echo "Verifying Fingerprints..."
	gpg2 --fingerprint $key
	echo "====================="
	echo
	echo
	echo
	echo
	echo
	echo "Processing..$key.."
	email=$(gpg2 --fingerprint $key | grep uid | awk '{ print $NF }' | tr -d '<>')
	count=$(gpg2 --fingerprint $key | grep uid -c)
	if [ $count -gt 1 ]
	then
		for mail in $email
		do
			echo "Processing.. $mail"
			gpg2 --recv-keys $key
			gpg2 --fingerprint $key
			gpg2 --ask-cert-level --sign-key $mail
			gpg2 --armor --export $key | gpg2 --encrypt -r $key --armor --output "$key"_"$mail".asc
			echo
			echo
			echo
			echo "Deleting the key..$key - $mail"
			gpg2 --delete-key $key
		done
	else
	        echo "Processing.. $key"
                gpg2 --recv-keys $key
                gpg2 --fingerprint $key
                gpg2 --ask-cert-level --sign-key $key
                gpg2 --armor --export $key | gpg2 --encrypt -r $key --armor --output "$key"_"$email".asc
		gpg2 --delete-key $key
	fi
done
