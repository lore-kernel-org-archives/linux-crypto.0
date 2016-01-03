From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Subject: next-20151231 - aes crypto algorithm went missing?
Date: Sun, 03 Jan 2016 00:34:13 -0500
Message-ID: <4632.1451799253@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1451799253_2742P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--==_Exmh_1451799253_2742P
Content-Type: text/plain; charset=us-ascii

So booting into a next-20151222 kernel, I can mount an external drive
that uses cryptLuks.  I try -1231, and I get this failure:

Failed to setup dm-crypt key mapping for device /dev/sdb2.
Check that kernel supports aes-cbc-essiv:sha256 cipher (check syslog for more info).

Tracked it down to this difference in /proc/crypto between the 12/22 and 12/31:

diff -u crypto.1222 crypto.1231
--- crypto.1222 2016-01-03 00:16:28.912507156 -0500
+++ crypto.1231 2016-01-03 00:09:14.243081574 -0500
@@ -1,37 +1,8 @@
-name         : ecb(aes)
-driver       : ecb(aes-asm)
-module       : kernel
-priority     : 200
-refcnt       : 1
-selftest     : passed
-internal     : no
-type         : blkcipher
-blocksize    : 16
-min keysize  : 16
-max keysize  : 32
-ivsize       : 0
-geniv        : <default>
-
-name         : cbc(aes)
-driver       : cbc(aes-asm)
-module       : kernel
-priority     : 200
-refcnt       : 2
-selftest     : passed
-internal     : no
-type         : givcipher
-async        : no
-blocksize    : 16
-min keysize  : 16
-max keysize  : 32
-ivsize       : 16
-geniv        : eseqiv
-
 name         : ccm(aes)
 driver       : ccm_base(ctr(aes-asm),aes-asm)
 module       : kernel
 priority     : 200

Not seeing any obvious error messages about failed self-tests in dmesg output.

Not seeing a difference in .config that would explain it:

grep AES /boot/config-4.4.0-rc[67]*
/boot/config-4.4.0-rc6-next-20151222-dirty:CONFIG_CRYPTO_AES=y
/boot/config-4.4.0-rc6-next-20151222-dirty:CONFIG_CRYPTO_AES_X86_64=y
/boot/config-4.4.0-rc6-next-20151222-dirty:# CONFIG_CRYPTO_AES_NI_INTEL is not set
/boot/config-4.4.0-rc6-next-20151222-dirty:CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
/boot/config-4.4.0-rc6-next-20151222-dirty:CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
/boot/config-4.4.0-rc7-next-20151231-00006-gc66c8c42ba97:CONFIG_CRYPTO_AES=y
/boot/config-4.4.0-rc7-next-20151231-00006-gc66c8c42ba97:CONFIG_CRYPTO_AES_X86_64=y
/boot/config-4.4.0-rc7-next-20151231-00006-gc66c8c42ba97:# CONFIG_CRYPTO_AES_NI_INTEL is not set
/boot/config-4.4.0-rc7-next-20151231-00006-gc66c8c42ba97:CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
/boot/config-4.4.0-rc7-next-20151231-00006-gc66c8c42ba97:CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m

The module was built, and nothing's touched that source in a while:

[/usr/src/linux-next] find crypto/ -name '*aes*' -ls
  2104235     12 -rw-r--r--   1  source   source      11000 Jan  2 03:44 crypto/aes_generic.dwo
  2104241     32 -rw-r--r--   1  source   source      32645 Jan  2 03:44 crypto/.aes_generic.o.cmd
  2111768     64 -rw-r--r--   1  source   source      63440 Jan 20  2015 crypto/aes_generic.c
  2104179     56 -rw-r--r--   1  source   source      54664 Jan  2 03:44 crypto/aes_generic.o

This ringing any bells, before I start the New Year with a bisect? :)


--==_Exmh_1451799253_2742P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVoiy1QdmEQWDXROgAQJS0w//Ryk/CGnsRVECGHMQMuVzfHZ3d2oySIHw
kOuqipbx5JughDbDqg1h9EZgN1V/IFyXPc6tIb7OKd350KAX3lVKrgR3fK7zxyjf
nb7XHg4uveraspAzqGJpbyfG5dXKtO8Y2HiUacq7vqQBrEjctC690rYfYofM/kTL
Hq318aRQV4gfUwJL7BsTOEdGfI25Rvil5jnj0IK/XYlOOVQi3mqOenEGnOnz5QSN
cguiCKF/4uvUoX30Up/Wsm+kkm8XLyY2fHJ9V7ZLXnIyc1TyKVfYfQ7CF/rzlTeq
xO0L9OLOn3z+Ock9LIttY+CTuWbRe/ct3lXHSHzfONyURWV4wTbnVJxgkD0OLU/G
mWSvekSHjZ/7jgbHLTqiO9c3220wtYreoiqeaqPqvpOOR94zteta3fw8hVd3iSMJ
keqFAapOmPJ6KD1cMSRiND+JBweXDCSMYfzXLJtuf2ZCvN0C+sR6yYPWCahVScvT
vWwGpQvit5bpLx+/WKIpEZzSAv/wfJYKBH9GD9LunOYBSG5iC8qzfnEDRBga9LW3
mPULepMharOa0p6fdN0R35ZL+o8z/t+4RVOr6GCE5WriTyTtNTY/iEcZzP+YeIGC
a40ua2T+3/yjHwmRqLpkSuP2TbndP7SGROIeaFLOn42m0fU7fyQbxqdW0M2Y+p5R
siTlX3X/a4c=
=S+yT
-----END PGP SIGNATURE-----

--==_Exmh_1451799253_2742P--
