From: Phil Sutter <phil.sutter@viprinet.com>
Subject: Re: Problem with mv_cesa
Date: Wed, 14 Mar 2012 13:01:34 +0100
Message-ID: <20120314120133.GA588@philter.vipri.net>
References: <1CDBBA650F262248B116B3A10E4E3C108AC6CB41@EXMBX08.netplexity.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	Chris Boscolo <chrisb@symform.com>,
	Bassam Tabbara <bassam@symform.com>,
	linux-crypto@vger.kernel.org
To: Michael Goff <michael@symform.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:40988 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758660Ab2CNMBr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Mar 2012 08:01:47 -0400
Content-Disposition: inline
In-Reply-To: <1CDBBA650F262248B116B3A10E4E3C108AC6CB41@EXMBX08.netplexity.local>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dear Mr. Goff,

(Adding linux-crypto in Cc, please always do so for this kind of
correspondence.)

On Tue, Mar 13, 2012 at 06:29:31PM +0000, Michael Goff wrote:
> I am running into an issue with mv_cesa.  We are working with QNAP ne=
twork attached storage devices that run a marvell arm chip that has cry=
pto support via the mv_cesa module that you maintain.  We are using the=
 cryptodev module to run cryptography through the kernel from userspace=
=2E  QNAP is running the linux kernel version 2.6.33.2.  This version o=
f mv_cesa seems to have a problem when hashing blocks larger than 1920 =
bytes.  I noticed a commit (274252862f386b7868f35bf5ceaa5391a8ccfdf3) t=
hat says it fixes a 1920 byte limit and we also want to use the hardwar=
e offloading of sha1 provided by newer mv_cesa code.  What we did is gr=
ab mv_cesa.c and mv_cesa.h (from 274252862f386b7868f35bf5ceaa5391a8ccfd=
f3) and built the mv_cesa module in the 2.6.33.2 tree.  This seemed to =
have successfully added sha1 hardware offloading but rather than fixing=
 the 1920 byte limit it made things worse.

I don't fully understand your description here. With vanilla 2.6.33.2
you say there is a problem with hashing blocks larger than 1920 bytes
although in vanilla 2.6.33.2 there was no support for sha1 in mv_cesa.c
yet?

> I am going to attach a simple c program that runs aes128 cbc through =
cryptodev and dumps the unencrypted and encrypted data in files.  Then =
I run the unencrypted file through openssl to verify the results.  With=
out the mv_cesa module insmoded the results of cryptodev and openssl ar=
e the same.  With the mv_cesa module from 2.6.33.2, the results are the=
 same up until after the 1920 byte limit.  With the mv_cesa module buil=
t from 274252862f386b7868f35bf5ceaa5391a8ccfdf3 if the source data is a=
ll zeros the results are the same up until 1920, however if input data =
is anything other than all zeros (random or all 1's for instance) they =
differ completely.

Can you reproduce this with a current kernel? Just to make sure this is
not a heisenbug resulting from the combination of current mv_cesa.c wit=
h
your kernel version.

What hardware are you running this on exactly? Which implementation of
cryptodev are you using?

> The program I'm attaching to test this takes 3 parameters: the name o=
f a file to place the data that will be encrypted, the name of a file t=
o put the resulting encrypted data, the number of bytes of data to gene=
rate/encrypt.  Here is a sample use of the program and comparing it to =
openssl:
> > gcc repro.c
> > ./a.out toencrypt cryptoenc 2000
> > openssl enc -in toencrypt -iv 0 -K 0 -out opensslenc -nopad -aes-12=
8-cbc
> > hexdump -x cryptoenc > cryptoenc.hex
> > hexdump -x opensslenc > opensslenc.hex
> > diff cryptoenc.hex opensslenc.hex
>=20
> Here are the results of my tests again for reference:
> Setup
>=20
> Result
>=20
> Plain cryptodev without mv_cesa
>=20
> Works: same as openssl for tested values
>=20
> Mv_cesa from 2.6.33.2
>=20
> Works up to 1920 but after that different than openssl
>=20
> Mv_cesa from 274252862f386b7868f35bf5ceaa5391a8ccfdf3
>=20
> Works for all zeros input until 1920 then different but for all other=
 input values differs from openssl output completely.
>=20
>=20
>=20
> Thank you for your help,
> Michael Goff
> Symform Inc.
> http://symform.com
>=20

> #include <stdio.h>
> #include <fcntl.h>
> #include <cryptodev.h>
> #include <string.h>
> #include <sys/ioctl.h>
>=20
> #define KEY_SIZE        16
> #define BLOCK_SIZE      16
>=20
> static int test_crypto(int fd, char *to_encrypt_file, char *encrypted=
_file, int data_size)
> {
>         struct {
>                 char    in[data_size],
>                         encrypted[data_size],
>                         iv[BLOCK_SIZE],
>                         key[KEY_SIZE];
>         } data;
>=20
>         struct session_op sess;
>         struct crypt_op cryp;
>=20
>         /* Set iv and key to 0's */
>         memset(data.iv, 0, BLOCK_SIZE);
>         memset(data.key, 0, KEY_SIZE);
>=20
>         /* We'll leave data.in alone to pick up junk from the stack f=
or "random" data */
>=20
>         /* Get crypto session for AES128 */
>         sess.cipher =3D CRYPTO_AES_CBC;
>         sess.keylen =3D KEY_SIZE;
>         sess.key =3D data.key;
>         if (ioctl(fd, CIOCGSESSION, &sess)) {
>                 perror("ioctl(CIOCGSESSION)");
>                 return 1;
>         }
>=20
>         /* Encrypt data.in to data.encrypted */
>         cryp.ses =3D sess.ses;
>         cryp.len =3D sizeof(data.in);
>         cryp.src =3D data.in;
>         cryp.dst =3D data.encrypted;
>         cryp.iv =3D data.iv;
>         cryp.op =3D COP_ENCRYPT;
>         if (ioctl(fd, CIOCCRYPT, &cryp)) {
>                 perror("ioctl(CIOCCRYPT)");
>                 return 1;
>         }
>=20
>         /* Output input and output of encryption */
>         FILE *file =3D fopen(to_encrypt_file, "w+");
>         fwrite(data.in, sizeof(char), data_size, file);
>         fclose(file);
>=20
>         file =3D fopen(encrypted_file, "w+");
>         fwrite(data.encrypted, sizeof(char), data_size, file);
>         fclose(file);
>=20
>         /* Finish crypto session */
>         if (ioctl(fd, CIOCFSESSION, &sess.ses)) {
>                 perror("ioctl(CIOCFSESSION)");
>                 return 1;
>         }
>=20
>         return 0;
> }
>=20
> int main(int argc, char *argv[])
> {
>         if (argc !=3D 4) {
>                 printf("Usage: %s UNENCRYPTED_FILE ENCRYPTED_FILE NUM=
BER_OF_BYTES", argv[0]);
>                 printf("\n\tUNENCRYPTED_FILE: Filename to write the i=
nput data used to");
>                 printf("\n\tENCRYPTED_FILE: File to write the encrypt=
ed input data to");
>                 printf("\n\tNUMBER_OF_BYTES: The number of bytes of d=
ata to encrypt");
>                 printf("\n\n\tThis program will take some data from s=
tack garbage and encrypte it\n");
>                 printf("\n\toutputting the unencrypted and encrypted =
data to files.\n");
>                 printf("\n\tThen invoke openssl like the follow to ve=
rify:\n");
>                 printf("\n\topenssl enc -in UNENCRYPTED_FILE -iv 0 -K=
 0 \\\n");
>                 printf("\t\t-out OPENSSL_ENCRYPTED_FILE -nopad -aes-1=
28-cbc\n");
>                 return 1;
>         }
>=20
>         int number_of_bytes =3D atoi(argv[3]);
>=20
>         int fd =3D -1;
>         fd =3D open("/dev/crypto", O_RDWR, 0);
>         if (fd < 0)
>         {
>                 perror("open(/dev/crypto)");
>                 return 1;
>         }
>=20
>         /* Set close-on-exec (not really neede here) */
>         if (fcntl(fd, F_SETFD, 1) =3D=3D -1) {
>                 perror("fcntl(F_SETFD)");
>                 return 1;
>         }
>=20
>         test_crypto(fd, argv[1], argv[2], number_of_bytes);
>=20
>         if(close(fd))
>         {
>                 perror("close(fd)");
>                 return 1;
>         }
>=20
>         return 0;
> }



Phil Sutter
Software Engineer

--=20
Viprinet =E2=80=93 Never be offline again!

************************************************
Viprinet auf der CeBIT 2012 =E2=80=93 6.-10. M=C3=A4rz:
Besuchen Sie uns in Halle 13, Stand D27!
Alle gezeigten Produkte im Livebetrieb,
zahlreiche Beispielapplikationen. Gerne
schicken wir Ihnen kostenlose Eintrittskarten.
************************************************
Viprinet at CeBIT 2012, March 6 to 10
in Hannover, Germany. Come and visit us
at Hall 13, Booth D27! All exhibits shown
live, many sample applications. We=E2=80=99ll be
happy to send you free admission tickets.
************************************************


Viprinet GmbH
Mainzer Str. 43
55411 Bingen am Rhein
Germany

Phone/Zentrale:         +49-6721-49030-0
Direct line/Durchwahl:  +49-6721-49030-134
=46ax:                    +49-6721-49030-209

phil.sutter@viprinet.com
http://www.viprinet.com

Registered office/Sitz der Gesellschaft: Bingen am Rhein
Commercial register/Handelsregister: Amtsgericht Mainz HRB40380
CEO/Gesch=C3=A4ftsf=C3=BChrer: Simon Kissel
