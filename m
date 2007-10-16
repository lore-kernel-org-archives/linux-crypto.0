From: Krzysztof Oledzki <olel@ans.pl>
Subject: Truncated(?) /proc/crypto on x86_64 on 2.6.22
Date: Tue, 16 Oct 2007 19:56:33 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710161949410.21430@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1869916427-1192557393=:21430"
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:59504 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759111AbXJPR4j (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Oct 2007 13:56:39 -0400
Received: from bizon.gios.gov.pl (olel@localhost6 [IPv6:::1])
	by bizon.gios.gov.pl (8.14.1/8.14.1) with ESMTP id l9GHuYWJ006138
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-crypto@vger.kernel.org>; Tue, 16 Oct 2007 19:56:36 +0200
Received: from localhost (olel@localhost)
	by bizon.gios.gov.pl (8.14.1/8.14.1/Submit) with ESMTP id l9GHuXVT006135
	for <linux-crypto@vger.kernel.org>; Tue, 16 Oct 2007 19:56:34 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1869916427-1192557393=:21430
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

After switching from i386 to x86_64 I noticed that /proc/crypto is much=20
shorter:

#  wc -l /proc/crypto crypto-64
  482 /proc/crypto
  349 crypto-64

# diff -Nur /proc/crypto crypto-64
--- /proc/crypto        2007-10-16 19:49:45.110694374 +0200
+++ crypto-64   2007-10-16 19:48:10.000000000 +0200
@@ -1,136 +1,3 @@
-name         : cbc(twofish)
-driver       : cbc(twofish-i586)
-module       : kernel
-priority     : 200
-refcnt       : 1
-type         : blkcipher
-blocksize    : 16
-min keysize  : 16
-max keysize  : 32
-ivsize       : 16
-
-name         : cbc(camellia)
-driver       : cbc(camellia-generic)
-module       : kernel
-priority     : 100
-refcnt       : 1
-type         : blkcipher
-blocksize    : 16
-min keysize  : 16
-max keysize  : 32
-ivsize       : 16
-
-name         : cbc(serpent)
-driver       : cbc(serpent-generic)
-module       : kernel
-priority     : 0
-refcnt       : 1
-type         : blkcipher
-blocksize    : 16
-min keysize  : 0
-max keysize  : 32
-ivsize       : 16
-
-name         : cbc(aes)
-driver       : cbc(aes-i586)
-module       : kernel
-priority     : 200
-refcnt       : 2467
-type         : blkcipher
-blocksize    : 16
-min keysize  : 16
-max keysize  : 32
-ivsize       : 16
-
-name         : cbc(blowfish)
-driver       : cbc(blowfish-generic)
-module       : kernel
-priority     : 0
-refcnt       : 1
-type         : blkcipher
-blocksize    : 8
-min keysize  : 4
-max keysize  : 56
-ivsize       : 8
-
-name         : cbc(des3_ede)
-driver       : cbc(des3_ede-generic)
-module       : kernel
-priority     : 0
-refcnt       : 1147
-type         : blkcipher
-blocksize    : 8
-min keysize  : 24
-max keysize  : 24
-ivsize       : 8
-
-name         : cbc(des)
-driver       : cbc(des-generic)
-module       : kernel
-priority     : 0
-refcnt       : 1
-type         : blkcipher
-blocksize    : 8
-min keysize  : 8
-max keysize  : 8
-ivsize       : 8
-
-name         : ecb(cipher_null)
-driver       : ecb(cipher_null-generic)
-module       : kernel
-priority     : 0
-refcnt       : 1
-type         : blkcipher
-blocksize    : 1
-min keysize  : 0
-max keysize  : 0
-ivsize       : 0
-
-name         : xcbc(aes)
-driver       : xcbc(aes-i586)
-module       : kernel
-priority     : 200
-refcnt       : 1
-type         : hash
-blocksize    : 16
-digestsize   : 16
-
-name         : hmac(sha256)
-driver       : hmac(sha256-generic)
-module       : kernel
-priority     : 0
-refcnt       : 1
-type         : hash
-blocksize    : 64
-digestsize   : 32
-
-name         : hmac(sha1)
-driver       : hmac(sha1-generic)
-module       : kernel
-priority     : 0
-refcnt       : 3613
-type         : hash
-blocksize    : 64
-digestsize   : 20
-
-name         : hmac(md5)
-driver       : hmac(md5-generic)
-module       : kernel
-priority     : 0
-refcnt       : 1
-type         : hash
-blocksize    : 64
-digestsize   : 16
-
-name         : hmac(digest_null)
-driver       : hmac(digest_null-generic)
-module       : kernel
-priority     : 0
-refcnt       : 1
-type         : hash
-blocksize    : 1
-digestsize   : 0
-
  name         : crc32c
  driver       : crc32c-generic
  module       : kernel
@@ -310,7 +177,7 @@
  driver       : des3_ede-generic
  module       : kernel
  priority     : 0
-refcnt       : 1147
+refcnt       : 1
  type         : cipher
  blocksize    : 8
  min keysize  : 24
@@ -411,7 +278,7 @@
  driver       : sha1-generic
  module       : kernel
  priority     : 0
-refcnt       : 3613
+refcnt       : 1
  type         : digest
  blocksize    : 64
  digestsize   : 20
@@ -461,7 +328,7 @@
  max keysize  : 0

  name         : twofish
-driver       : twofish-i586
+driver       : twofish-x86_64
  module       : kernel
  priority     : 200
  refcnt       : 1
@@ -471,10 +338,10 @@
  max keysize  : 32

  name         : aes
-driver       : aes-i586
+driver       : aes-x86_64
  module       : kernel
  priority     : 200
-refcnt       : 2467
+refcnt       : 1
  type         : cipher
  blocksize    : 16
  min keysize  : 16


# grep CRYPT  .config
CONFIG_BLK_DEV_CRYPTOLOOP=3Dy
CONFIG_DM_CRYPT=3Dy
CONFIG_CRYPTO=3Dy
CONFIG_CRYPTO_ALGAPI=3Dy
CONFIG_CRYPTO_ABLKCIPHER=3Dy
CONFIG_CRYPTO_BLKCIPHER=3Dy
CONFIG_CRYPTO_HASH=3Dy
CONFIG_CRYPTO_MANAGER=3Dy
CONFIG_CRYPTO_HMAC=3Dy
CONFIG_CRYPTO_XCBC=3Dy
CONFIG_CRYPTO_NULL=3Dy
CONFIG_CRYPTO_MD4=3Dy
CONFIG_CRYPTO_MD5=3Dy
CONFIG_CRYPTO_SHA1=3Dy
CONFIG_CRYPTO_SHA256=3Dy
CONFIG_CRYPTO_SHA512=3Dy
CONFIG_CRYPTO_WP512=3Dy
CONFIG_CRYPTO_TGR192=3Dy
CONFIG_CRYPTO_GF128MUL=3Dy
CONFIG_CRYPTO_ECB=3Dy
CONFIG_CRYPTO_CBC=3Dy
CONFIG_CRYPTO_PCBC=3Dy
CONFIG_CRYPTO_LRW=3Dy
CONFIG_CRYPTO_CRYPTD=3Dy
CONFIG_CRYPTO_DES=3Dy
CONFIG_CRYPTO_FCRYPT=3Dy
CONFIG_CRYPTO_BLOWFISH=3Dy
CONFIG_CRYPTO_TWOFISH=3Dy
CONFIG_CRYPTO_TWOFISH_COMMON=3Dy
CONFIG_CRYPTO_TWOFISH_X86_64=3Dy
CONFIG_CRYPTO_SERPENT=3Dy
CONFIG_CRYPTO_AES=3Dy
CONFIG_CRYPTO_AES_X86_64=3Dy
CONFIG_CRYPTO_CAST5=3Dy
CONFIG_CRYPTO_CAST6=3Dy
CONFIG_CRYPTO_TEA=3Dy
CONFIG_CRYPTO_ARC4=3Dy
CONFIG_CRYPTO_KHAZAD=3Dy
CONFIG_CRYPTO_ANUBIS=3Dy
CONFIG_CRYPTO_DEFLATE=3Dy
CONFIG_CRYPTO_MICHAEL_MIC=3Dy
CONFIG_CRYPTO_CRC32C=3Dy
CONFIG_CRYPTO_CAMELLIA=3Dy

Is it normall?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1869916427-1192557393=:21430--
