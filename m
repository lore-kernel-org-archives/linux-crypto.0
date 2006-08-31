From: Rik Snel <rsnel@cube.dyndns.org>
Subject: [PATCH 6/6] crypto: a simple way of storing and checking test vectors, LRW vectors included
Date: Thu, 31 Aug 2006 14:39:36 +0200
Message-ID: <11570279812796-git-send-email-rsnel@cube.dyndns.org>
References: <11570279761772-git-send-email-rsnel@cube.dyndns.org>
Reply-To: Rik Snel <rsnel@cube.dyndns.org>
Cc: linux-crypto@vger.kernel.org, Rik Snel <rsnel@cube.dyndns.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:62472 "EHLO
	smtp-vbr4.xs4all.nl") by vger.kernel.org with ESMTP id S932164AbWHaMkM
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Aug 2006 08:40:12 -0400
To: herbert@gondor.apana.org.au
In-Reply-To: <11570279761772-git-send-email-rsnel@cube.dyndns.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Test vectors for LRW and a simple way of checking them. For your convenience
and/or for real inclusion.

Signed-off-by: Rik Snel <rsnel@cube.dyndns.org>
---
 Documentation/crypto/README.testvector |    7 ++
 Documentation/crypto/lrw-32-aes        |  113 ++++++++++++++++++++++++++++++++
 Documentation/crypto/testvector.fun    |   57 ++++++++++++++++
 3 files changed, 177 insertions(+), 0 deletions(-)

diff --git a/Documentation/crypto/README.testvector b/Documentation/crypto/README.testvector
new file mode 100644
index 0000000..2d4a0f0
--- /dev/null
+++ b/Documentation/crypto/README.testvector
@@ -0,0 +1,7 @@
+How to check the testvectors included in ./lrw-32-aes?
+
+Simply execute them; lrw-32-aes is a bash script that calls some functions
+in testvector.fun. Tools like dm-setup and some hex utitities will be used 
+to check them through the usual kernel interface. You can add testvectors of
+other modes in an analogous manner.
+
diff --git a/Documentation/crypto/lrw-32-aes b/Documentation/crypto/lrw-32-aes
new file mode 100644
index 0000000..35de311
--- /dev/null
+++ b/Documentation/crypto/lrw-32-aes
@@ -0,0 +1,113 @@
+#!/bin/bash
+# you need losetup, dmsetup, xxd, bc
+
+# change this if you need
+LOOP=/dev/loop0
+MAPPER=crypt0
+
+# we need to import some important functions
+. testvector.fun
+
+#lrw specific options, some need to be calculated for each vector
+function special { 
+	MODE=aes-lrw-benbi
+	KEY=$AESKEY$TWEAKKEY
+	IV_OFFSET=$(echo "ibase=16; ($TWEAKLOCATION-1)/20" | bc)
+	BOFFSET=$(echo "ibase=16; ($TWEAKLOCATION-1)%20" | bc)
+}
+
+NAME="LRW-32-AES 1"
+AESKEY=4562ac25f828176d4c268414b5680185
+TWEAKKEY=258e2a05e73e9d03ee5a830ccc094c87
+PLAINTEXT=30313233343536373839414243444546
+TWEAKLOCATION=00000000000000000000000000000001
+CIPHERTEXT=f1b273cd65a3df5fe95d489254634eb8
+check
+
+NAME="LRW-32-AES 2"
+AESKEY=59704714f557478cd779e80f54887944
+TWEAKKEY=0d48f0b7b15a53ea1caa6b29c2cafbaf
+PLAINTEXT=30313233343536373839414243444546
+TWEAKLOCATION=00000000000000000000000000000002
+CIPHERTEXT=00c82bae95bbcde5274f0769b260e136
+check
+
+NAME="LRW-32-AES 3"
+AESKEY=d82a9134b26a565030fe69e2377f9847
+TWEAKKEY=cdf90b160c648fb6b00d0d1bae85871f
+PLAINTEXT=30313233343536373839414243444546
+TWEAKLOCATION=00000000000000000000000200000000
+CIPHERTEXT=76322183ed8ff182f9596203690e5e01
+check
+
+NAME="LRW-32-AES 4"
+AESKEY=0f6aeff8d3d2bb152583f73c1f012874cac6bc354d4a6554
+TWEAKKEY=90ae61cf7baebdccade494c54a29ae70
+PLAINTEXT=30313233343536373839414243444546
+TWEAKLOCATION=00000000000000000000000000000001
+CIPHERTEXT=9c0f152f55a2d8f0d67b8f9e2822bc41
+check
+
+NAME="LRW-32-AES 5"
+AESKEY=8ad4ee102fbd81fff886ceac93c5adc6a01907c09df7bbdd
+TWEAKKEY=5213b2b7f0ff11d8d608d0cd2eb1176f
+PLAINTEXT=30313233343536373839414243444546
+TWEAKLOCATION=00000000000000000000000200000000
+CIPHERTEXT=d4276a7f14913d65c860480287e33406
+check
+
+NAME="LRW-32-AES 6"
+AESKEY=f8d476ffd646ee6c2384cb1c77d6195dfef1a9f37bbc8d21a79c21f8cb900289
+TWEAKKEY=a845348ec8c5b5f126f50e76fefd1b1e
+PLAINTEXT=30313233343536373839414243444546
+TWEAKLOCATION=00000000000000000000000000000001
+CIPHERTEXT=bd06b8e1db98899ec498e491cf1c702b
+check
+
+NAME="LRW-32-AES 7"
+AESKEY=fb7615b23d80891dd470980bc79584c8b2fb64ce6097878d17fce45a49e830b7
+TWEAKKEY=6e7817e72d5e12d46064047af12f9e0c
+PLAINTEXT=30313233343536373839414243444546
+TWEAKLOCATION=00000000000000000000000200000000
+CIPHERTEXT=5b908ec1abdd675f3d698a9553c89ce5
+check
+
+NAME="Ken Buchanan"
+AESKEY=f8d476ffd646ee6c2384cb1c77d6195dfef1a9f37bbc8d21a79c21f8cb900289
+TWEAKKEY=a845348ec8c5b5f126f50e76fefd1b1e
+TWEAKLOCATION=00000000000000000000000000000001
+PLAINTEXT=\
+0511b718abc62dac705df62294cde56c176bf61cf0f36ef850381f7149b657d6\
+8fcb8d6be3a62990fe2a6282ae6d8bf6ad1e9e205f38be04da108eeda2a487ab\
+da6bb40c75bad37cc9ac4231957cc904ebd56e32698adba615d73f4f2f666903\
+9c1f540fde1ff3654c9612ed7c9203016fbc3593acf127f1b496825a5fb0a050\
+89a48e664485ccfd331470e396b2c3d3bb545a1af974a2c52d6475ddb454e674\
+8cd39d9e86ab5153b7933e6fd04e2c40f6a82e3e9df466a5761273441a56d772\
+88cd218c4c0ffeda95e03aa6a58446cdd53e9d3ae267e6601ae2708558c21b09\
+e1d72ccaada88ff9acb30edbca2ee2b85171d93c6cf156f8ea9cf1fb0ce6b710\
+1cf8a97ce85335c1903e764a74a4212cf62c4e0f943a882e41096a337df6dd3f\
+8d23317484eb886eccb9bc2283190722a52ddfa5f380857884396a6d6a994fa5\
+15fe46b0e46ca5413cce8f426071a7750840658a82bff5437196a94d448a20be\
+fa4dbbc07d319665e775e53efd923bc955bb167ef7c28ca4401de5ef0edfe49a\
+627365fd4663253d2bafe564fea55ccf24f3b4ac64badf4bc6967d812d8d97f7\
+c5687784322bcc857496f0127761b9eb71aa82cb1cdb89c8c6b5e35c7d390724\
+da398745c02bbb01acbc2a5c7ffce8ce6d9c6fedd3c1a1d6c555a9662fe1c832\
+a65da43a9873e845a4c7a8b4f61303f6e92ec4290f84dbc421c4c2756789370a
+CIPHERTEXT=\
+1a1da930adf92f9bb61daeeff02ff85a393cbf2ab245b2231b633ccfaabecf4e\
+fae829c220682b3c2e8bf76e25bde33d6627d6afd6643ee3e8584697395107de\
+cb37bca9c05f75c30e84231d16d41c599c1a0255ab3a971ddfddc70651d770ae\
+23c68cf51ea0e582b8b2bf04a0328e68ebaf6e2d94222fce4cb559e2a22fa098\
+1a97c6d4b50059f2841472b19a6ea37fea20e7cb65773adfc8976715c22a27cc\
+1855a1240b2424af5bec68b8c8f5ba63ffed89ced53d88f325ef057c3aefebd8\
+7a320dd11e5859999025b526b0e32b6c4ca98b844f5e0150413058c56274521d\
+45246a42644f971ca866b56d79d40d48c55ff39032dddde1e4a99ffcc3525a46\
+e481849536597a6baab360adce9f9f28e0017522c44ea9625c620d00cb13e843\
+72d42d5346b5d1162218df3433f5d61cb879789794ff72134c27fccbbf0153a6\
+b4506ededfb543a459df52f97ce0116f2d148e24612ce117ccce510c198a8230\
+94d53d6a53065ebdb7ebfafd2751de851e865311539400ee2b8c082abfddae11\
+cb1ea2079a80cf629b09dc953c968eb109bde4ebdbca707a9efa3118453c2133\
+b0b32beaf3712de103ad1b48d46727f062e43dfb9b0876e7dd2b0139045a587a\
+f71190ecbd515c326bd73539026bf2a6d00d07e106c45b7de46ad7ee151f83b4\
+a3a75ec390b7efd3b74ff8924cb73c29cd7e2b5d43ea42e7743f7d588875de3e
+check
diff --git a/Documentation/crypto/testvector.fun b/Documentation/crypto/testvector.fun
new file mode 100644
index 0000000..34af646
--- /dev/null
+++ b/Documentation/crypto/testvector.fun
@@ -0,0 +1,57 @@
+function sig_handler_EXIT {
+	if [ -b /dev/mapper/$MAPPER ]; then dmsetup remove $MAPPER; fi
+	losetup -d $LOOP
+	rm $IMAGE
+	exit $1 
+}
+
+function setup {
+	set -e
+	IMAGE=`mktemp`
+	trap sig_handler_EXIT EXIT TERM INT QUIT
+	dd if=/dev/zero of=$IMAGE count=1 bs=512 2> /dev/null
+	losetup $LOOP $IMAGE
+}
+
+function check_encrypt {
+	echo $PLAINTEXT | xxd -r -p | dd of=/dev/mapper/$MAPPER seek=$BOFFSET \
+		bs=$LEN count=1 2> /dev/null
+
+	C=`dd if=$IMAGE skip=$BOFFSET bs=$LEN count=1 2> \
+		/dev/null | xxd -p | tr -d '\n'`
+
+	if [ "$C" = "$CIPHERTEXT" ]; then ENC="--ENCRYPT OK--"
+	else ENC="--ENCRYPT FAILED--"; fi
+}
+
+function check_decrypt {
+	echo $CIPHERTEXT | xxd -r -p | dd of=$LOOP seek=$BOFFSET \
+		bs=$LEN count=1 2> /dev/null
+
+	P=`dd if=/dev/mapper/$MAPPER skip=$BOFFSET bs=$LEN count=1 2> \
+		/dev/null | xxd -p | tr -d '\n'`
+
+	if [ "$P" = "$PLAINTEXT" ]; then DEC="--DECRYPT OK--"
+	else DEC="--DECRYPT FAILED--"; fi
+}
+
+function check {
+	special
+
+	LEN=$((`echo $PLAINTEXT | wc -c`/2))
+
+	# setup mode
+	TABLE=`echo "0 1 crypt $MODE $KEY $IV_OFFSET $LOOP 0"`
+
+	echo $TABLE | dmsetup create $MAPPER
+	
+	check_encrypt
+	check_decrypt
+
+	dmsetup remove $MAPPER
+
+	echo "$NAME: $ENC $DEC"
+}
+
+setup 
+
-- 
1.4.1.1

