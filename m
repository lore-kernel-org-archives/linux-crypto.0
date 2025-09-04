Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8322D8376;
	Thu,  4 Sep 2025 16:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001717; cv=none; b=qUziCfJE/zGxkNYc28acVaTKzZ2QB0BoM2RXj81eZu6HbJpUlYGGlp6y3Y7MrMPLtBjQsBiAGwtsToEnHpmZosC2Sbk/aAwo8RdbkN4rwDWlfN4zisOLJ619x256tEFS03I1nZBy+gqlTcCflgyS3qayQp5EBHjCGvdZZKQjvlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001717; c=relaxed/simple;
	bh=qJqxJafSqszq4eVBPXF6UcdqCmSFZWH2v+Pyme8CxXA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YCmcZe1sKoTmdI9FntfqWBmdx6Zbpzuytp2RK1cWJYCph5bWekRCp/AG14AZcv224xIhQqWCAz/Hy/SKT5+S9hW061gRB6k5p1cZSWdvRCxdPKSRCoR2dU6c9LNqiFSo4UpgsnahkKAWUI5Ivje5IUW/dd4gHwonIXpI9dtlyaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R1QSXjRp; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R1QSXjRp"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ftrbh010582;
	Thu, 4 Sep 2025 16:01:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lLbKi5t743ux8r0G7R/8Hfrk5MPGHeOs5B+z21tndgQ=; b=
	R1QSXjRpnGOO3Z115Fou2CZ+t5wCE2JA+xm6v4Yg93CODLDXztYdvy7AZZ8TJTqi
	D1fz6vlXOYyv6c+RvfJ17O5kMxQ7+wQIU5EhcjSGmba+IU84WhQLGO6NkxFuU0AH
	1AZAf45r8OgwWlYdoADM1OmcJD0FDVidqLed2SyT7a6SszCKJqcxuJhR7CJiuCNS
	Lg9cxco4RqBC8UpCpNqoAcD0WGhg9iOtH5seLIpdqlNOhyyfaHarFHEcJlDmN/NC
	Aw3ZVb6srPDEDQ+XfritQu5eKGhEZ5PkZY678ocPFWVaZIObV4pSnMJ7OwfJUvbO
	l+Ym03bFqy7CXLZSPPmErg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydacr346-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FTLT0040133;
	Thu, 4 Sep 2025 16:01:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtu18-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:33 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx88000707;
	Thu, 4 Sep 2025 16:01:33 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-101;
	Thu, 04 Sep 2025 16:01:32 +0000
From: Vegard Nossum <vegard.nossum@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
        Daniel Gomez <da.gomez@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
        Vladis Dronov <vdronov@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Sami Tolvanen <samitolvanen@google.com>, linux-modules@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH RFC 100/104] crypto: fips140: add standalone FIPS 140 module
Date: Thu,  4 Sep 2025 17:52:12 +0200
Message-Id: <20250904155216.460962-101-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250904155216.460962-1-vegard.nossum@oracle.com>
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040157
X-Proofpoint-GUID: pBtv_R3sqLi01dN0Tqvlfw9zJmzAY3fJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MCBTYWx0ZWRfX+0QATIGRzfSI
 TyUiV9Zw96Jg//Mk3bR4g2U5eXt+4+q3f87w6/WdvyDbAcbSYXR1NcCO9w+DBNfa/6Y+aQILyhi
 pgCPQh5YhTKfdzGa/O0EVCDqVRU0XmH5MLPpdot0gvKTlDBVSoAh2REbA6ChAoJ7Nk2KA5oXm6I
 1V7IkKInys5Cg2YIkTDvPlwRBGTigQefCNDypwlabxifAmsFe+oZDKpD873QWiRSy/TOrLMLxYQ
 CqSvz19DpVHGQeLfQ+8GN7TBlxsbACLWKgvbfGL0+yY//PRlgO2GVNyyvkY/Ncm1v0O9DTg8etL
 o1yvmlCjX3ohJbgXpdeHXhE7a54TYkD0YogqrHEVh4L0IHnxwuokHdowI+t1jYKs9iAqjXx1s0i
 x/BJXp4O2o1aRwJprvVYvgSsZXSJgQ==
X-Proofpoint-ORIG-GUID: pBtv_R3sqLi01dN0Tqvlfw9zJmzAY3fJ
X-Authority-Analysis: v=2.4 cv=TuTmhCXh c=1 sm=1 tr=0 ts=68b9b7e0 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=Oh2cFVv5AAAA:8 a=vggBfdFIAAAA:8
 a=yPCof4ZbAAAA:8 a=KKAkSRfTAAAA:8 a=vmLDa1wCAAAA:8 a=qKekVHhgCHTwKNaUuhgA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=7KeoIwV6GZqOttXkcoxL:22
 a=cvBusfyB2V15izCimMoJ:22 a=h8Bt5HTj68qkN2fS7gvA:22 cc=ntf awl=host:12068

This code is partly based on the existing crypto/fips.c code and partly on
the Android FIPS 140 module [1]; __fips_initcalls/run_initcalls() based
loosely on code by Jay Wang <wanjay@amazon.com>.

[1]: https://android.googlesource.com/kernel/common/+/1ca1130ec62d/crypto/fips140-module.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/Kconfig         |  16 +--
 fips140/Kconfig        | 174 +++++++++++++++++++++++++++++++++
 fips140/Makefile       | 183 ++++++++++++++++++++++++++++++++++
 fips140/fips140-glue.c | 216 +++++++++++++++++++++++++++++++++++++++++
 fips140/fips140.lds    |   9 ++
 5 files changed, 583 insertions(+), 15 deletions(-)
 create mode 100644 fips140/Kconfig
 create mode 100644 fips140/Makefile
 create mode 100644 fips140/fips140-glue.c
 create mode 100644 fips140/fips140.lds

diff --git a/crypto/Kconfig b/crypto/Kconfig
index a2696ea30bde..f9b2f87ad04b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -54,21 +54,7 @@ config CRYPTO_FIPS_VERSION
 	  This option provides the ability to override the FIPS Module Version.
 	  By default the KERNELRELEASE value is used.
 
-config CRYPTO_FIPS140_EXTMOD
-	bool "FIPS 140-3 external module"
-	depends on CRYPTO_FIPS
-	help
-	  Support loading a prebuilt FIPS 140-3 cryptographic module.
-
-config CRYPTO_FIPS140_HMAC_KEY
-	string "FIPS 140-3 external module HMAC key"
-	depends on CRYPTO_FIPS140_EXTMOD
-	default "Sphinx of black quartz, judge my vow"
-	help
-	  This is the HMAC key used to build and verify the integrity of
-	  the FIPS module.
-
-	  Must be at least 14 characters.
+source "fips140/Kconfig"
 
 config CRYPTO_ALGAPI
 	tristate
diff --git a/fips140/Kconfig b/fips140/Kconfig
new file mode 100644
index 000000000000..188c5f360eab
--- /dev/null
+++ b/fips140/Kconfig
@@ -0,0 +1,174 @@
+# NOTE: the structure of this file mirrors that of crypto/Kconfig
+# and crypto/asymmetric/keys/Kconfig
+
+config CRYPTO_FIPS140_EXTMOD
+	bool "FIPS 140-3 external module"
+	depends on MODULES
+	depends on CRYPTO_FIPS
+	help
+	  Support loading a prebuilt FIPS 140-3 cryptographic module.
+
+if CRYPTO_FIPS140_EXTMOD
+
+config CRYPTO_FIPS140_HMAC_KEY
+	string "FIPS 140-3 external module HMAC key"
+	default "Sphinx of black quartz, judge my vow"
+	help
+	  This is the HMAC key used to build and verify the integrity of
+	  the FIPS module.
+
+	  Must be at least 14 characters.
+
+config CRYPTO_FIPS140_PCRYPT
+	bool
+	default CRYPTO_PCRYPT
+
+menu "FIPS 140 external module algorithms"
+	depends on CRYPTO_FIPS140_EXTMOD
+
+#
+# Public-key cryptography
+#
+
+config CRYPTO_FIPS140_RSA
+	bool "RSA (Rivest-Shamir-Adleman)"
+	default CRYPTO_RSA
+
+config CRYPTO_FIPS140_DH
+	bool "DH (Diffie-Hellman)"
+	default CRYPTO_DH
+
+config CRYPTO_FIPS140_ECC
+	bool
+	default CRYPTO_ECC
+
+config CRYPTO_FIPS140_ECDH
+	bool "ECDH (Elliptic Curve Diffie-Hellman)"
+	select CRYPTO_FIPS140_ECC
+	default CRYPTO_ECDH
+
+config CRYPTO_FIPS140_ECDSA
+	bool "ECDSA (Elliptic Curve Digital Signature Algorithm)"
+	default CRYPTO_ECDSA
+
+#
+# Block ciphers
+#
+
+config CRYPTO_FIPS140_AES
+	bool "AES (Advanced Encryption Standard)"
+	default CRYPTO_AES
+
+#
+# Length-preserving ciphers and modes
+#
+
+config CRYPTO_FIPS140_CBC
+	bool "CBC (Cipher Block Chaining)"
+	default CRYPTO_CBC
+
+config CRYPTO_FIPS140_CTR
+	bool "CTR (Counter)"
+	default CRYPTO_CTR
+
+config CRYPTO_FIPS140_ECB
+	bool "ECB (Electronic Codebook)"
+	default CRYPTO_ECB
+
+config CRYPTO_FIPS140_XTS
+	bool "XTS (XOR Encrypt XOR with ciphertext stealing)"
+	default CRYPTO_XTS
+
+#
+# AEAD (authenticated encryption with associated data) ciphers
+#
+
+config CRYPTO_FIPS140_CCM
+	bool "CCM (Counter with Cipher Block Chaining-MAC)"
+	default CRYPTO_CCM
+
+config CRYPTO_FIPS140_GCM
+	bool "GCM (Galois/Counter Mode) and GMAC (GCM MAC)"
+	default CRYPTO_GCM
+
+config CRYPTO_FIPS140_GENIV
+	bool
+	default CRYPTO_GENIV
+
+config CRYPTO_FIPS140_SEQIV
+	bool "Sequence Number IV Generator"
+	select CRYPTO_FIPS140_GENIV
+	default CRYPTO_SEQIV
+
+config CRYPTO_FIPS140_ECHAINIV
+	bool "Encrypted Chain IV Generator"
+	select CRYPTO_FIPS140_GENIV
+	default CRYPTO_ECHAINIV
+
+config CRYPTO_FIPS140_ESSIV
+	bool "Encrypted Salt-Sector IV Generator"
+	default CRYPTO_ESSIV
+
+#
+# Hashes, digests, and MACs
+#
+
+config CRYPTO_FIPS140_CMAC
+	bool "CMAC (Cipher-based MAC)"
+	default CRYPTO_CMAC
+
+config CRYPTO_FIPS140_HMAC
+	bool "HMAC (Keyed-Hash MAC)"
+	default CRYPTO_HMAC
+
+config CRYPTO_FIPS140_SHA256
+	bool "SHA-244 and SHA-256"
+	default CRYPTO_SHA256
+
+config CRYPTO_FIPS140_SHA512
+	bool "SHA-384 and SHA-512"
+	default CRYPTO_SHA512
+
+config CRYPTO_FIPS140_SHA3
+	bool "SHA-3"
+	default CRYPTO_SHA3
+
+#
+# Random number generation
+#
+
+config CRYPTO_FIPS140_JITTERENTROPY
+	bool "CPU Jitter Non-Deterministic RNG (Random Number Generator)"
+	select CRYPTO_FIPS140_SHA3
+
+#
+# Asymmetric keys
+#
+
+config FIPS140_ASYMMETRIC_KEY_TYPE
+	bool "Asymmetric (public-key cryptographic) key type"
+	default ASYMMETRIC_KEY_TYPE
+
+if FIPS140_ASYMMETRIC_KEY_TYPE
+
+config FIPS140_ASYMMETRIC_PUBLIC_KEY_SUBTYPE
+	bool "Asymmetric public-key crypto algorithm subtype"
+	default ASYMMETRIC_PUBLIC_KEY_SUBTYPE
+
+config FIPS140_X509_CERTIFICATE_PARSER
+	bool "X.509 certificate parser"
+	default X509_CERTIFICATE_PARSER
+
+config FIPS140_PKCS8_PRIVATE_KEY_PARSER
+	bool "PKCS#8 private key parser"
+	default PKCS8_PRIVATE_KEY_PARSER
+
+config FIPS140_PKCS7_MESSAGE_PARSER
+	bool "PKCS#7 message parser"
+	default PKCS7_MESSAGE_PARSER
+
+endif
+
+endmenu
+
+endif # if CRYPTO_FIPS140_EXTMOD
diff --git a/fips140/Makefile b/fips140/Makefile
new file mode 100644
index 000000000000..47365f1b3e27
--- /dev/null
+++ b/fips140/Makefile
@@ -0,0 +1,183 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Copyright (C) 2014 Linaro Ltd <ard.biesheuvel@linaro.org>
+# Copyright © 2025, Oracle and/or its affiliates.
+#
+
+#
+# Global options
+#
+
+# make sure both .c and .S files see this
+subdir-ccflags-y += -DFIPS_MODULE=1
+subdir-asflags-y += -DFIPS_MODULE=1
+
+#
+# Glue
+#
+
+fips140-y := fips140-glue.o
+
+#
+# crypto/Makefile
+#
+
+fips140-y += crypto/algapi.o
+fips140-y += crypto/api.o
+fips140-y += crypto/ahash.o
+fips140-y += crypto/cryptd.o
+fips140-y += crypto/shash.o
+fips140-y += crypto/proc.o
+
+# cryptomgr.ko
+fips140-y += crypto/algboss.o crypto/testmgr.o
+
+fips140-$(CONFIG_CRYPTO_FIPS140_SHA3) += crypto/sha3_generic.o
+
+# jitterentropy_rng.ko
+CFLAGS_crypto/jitterentropy.o = -O0
+KASAN_SANITIZE_crypto/jitterentropy.o = n
+UBSAN_SANITIZE_crypto/jitterentropy.o = n
+fips140-$(CONFIG_CRYPTO_FIPS140_JITTERENTROPY) += crypto/jitterentropy.o crypto/jitterentropy-kcapi.o
+
+fips140-$(CONFIG_CRYPTO_FIPS140_SHA512) += crypto/sha512.o
+
+fips140-$(CONFIG_CRYPTO_FIPS140_PCRYPT) += crypto/pcrypt.o
+fips140-y += crypto/ghash-generic.o
+
+# crypto_simd.ko
+fips140-y += crypto/simd.o
+
+fips140-$(CONFIG_CRYPTO_FIPS140_HMAC) += crypto/hmac.o
+fips140-y += crypto/authenc.o
+fips140-y += crypto/authencesn.o
+
+# rsa_generic.ko
+fips140-$(CONFIG_CRYPTO_FIPS140_RSA) += $(addprefix crypto/, \
+	rsapubkey.asn1.o \
+	rsaprivkey.asn1.o \
+	rsa.o \
+	rsa_helper.o \
+	rsa-pkcs1pad.o \
+	rsassa-pkcs1.o \
+)
+
+fips140-$(CONFIG_CRYPTO_FIPS140_SHA256) += crypto/sha256.o
+
+fips140-$(CONFIG_CRYPTO_FIPS140_CMAC) += crypto/cmac.o
+fips140-$(CONFIG_CRYPTO_FIPS140_AES) += crypto/aes_generic.o
+fips140-$(CONFIG_CRYPTO_FIPS140_CBC) += crypto/cbc.o
+fips140-$(CONFIG_CRYPTO_FIPS140_CCM) += crypto/ccm.o
+fips140-$(CONFIG_CRYPTO_FIPS140_ECB) += crypto/ecb.o
+fips140-$(CONFIG_CRYPTO_FIPS140_CTR) += crypto/ctr.o
+fips140-$(CONFIG_CRYPTO_FIPS140_ECC) += crypto/ecc.o
+fips140-y += crypto/drbg.o
+
+fips140-$(CONFIG_CRYPTO_FIPS140_ECDH) += $(addprefix crypto/, \
+	ecdh.o \
+	ecdh_helper.o \
+)
+
+# ecdsa_generic.ko
+$(obj)/crypto/ecdsasignature.asn1.o: $(obj)/crypto/ecdsasignature.asn1.c $(obj)/crypto/ecdsasignature.asn1.h
+$(obj)/crypto/ecdsa.o: $(obj)/crypto/ecdsasignature.asn1.h
+fips140-$(CONFIG_CRYPTO_FIPS140_ECDSA) += $(addprefix crypto/, \
+	ecdsa.o \
+	ecdsa-x962.o \
+	ecdsa-p1363.o \
+	ecdsasignature.asn1.o \
+)
+
+# dh_generic.ko
+fips140-$(CONFIG_CRYPTO_FIPS140_DH) += $(addprefix crypto/, \
+	dh.o \
+	dh_helper.o \
+)
+
+fips140-$(CONFIG_CRYPTO_FIPS140_GCM) += crypto/gcm.o
+fips140-$(CRYPTO_FIPS140_XTS) += crypto/xts.o
+fips140-y += crypto/tcrypt.o
+
+fips140-y += crypto/aead.o
+fips140-y += crypto/kpp.o
+fips140-y += crypto/cipher.o
+fips140-y += crypto/akcipher.o
+fips140-y += crypto/skcipher.o
+fips140-y += crypto/lskcipher.o
+fips140-y += crypto/rng.o
+fips140-y += crypto/sig.o
+fips140-$(CONFIG_CRYPTO_FIPS140_GENIV) += crypto/geniv.o
+fips140-$(CONFIG_CRYPTO_FIPS140_SEQIV) += crypto/seqiv.o
+fips140-$(CONFIG_CRYPTO_FIPS140_ECHAINIV) += crypto/echainiv.o
+fips140-$(CONFIG_CRYPTO_FIPS140_ESSIV) += crypto/essiv.o
+
+#
+# crypto/asymmetric_keys/Makefile
+#
+
+fips140-$(CONFIG_FIPS140_ASYMMETRIC_KEY_TYPE) += \
+	$(addprefix crypto/asymmetric_keys/, \
+		asymmetric_type.o restrict.o signature.o)
+
+fips140-$(CONFIG_FIPS140_ASYMMETRIC_PUBLIC_KEY_SUBTYPE) += crypto/asymmetric_keys/public_key.o
+
+$(obj)/crypto/asymmetric_keys/x509_cert_parser.o: \
+	$(addprefix $(obj)/crypto/asymmetric_keys/, \
+		x509.asn1.h x509_akid.asn1.h)
+$(obj)/crypto/asymmetric_keys/x509.asn1.o: \
+	$(addprefix $(obj)/crypto/asymmetric_keys/, \
+		x509.asn1.c x509.asn1.h)
+$(obj)/crypto/asymmetric_keys/x509_akid.asn1.o: \
+	$(addprefix $(obj)/crypto/asymmetric_keys/, \
+		x509_akid.asn1.c x509_akid.asn1.h)
+
+fips140-$(CONFIG_FIPS140_X509_CERTIFICATE_PARSER) += \
+	$(addprefix crypto/asymmetric_keys/, \
+		x509_cert_parser.o \
+		x509_loader.o \
+		x509_akid.asn1.o \
+		x509.asn1.o \
+		x509_public_key.o \
+	)
+
+$(obj)/crypto/asymmetric_keys/pkcs8_parser.o: $(obj)/crypto/asymmetric_keys/pkcs8.asn1.h
+$(obj)/crypto/asymmetric_keys/pkcs8-asn1.o: \
+	$(addprefix $(obj)/crypto/asymmetric_keys/, \
+		pkcs8.asn1.c pkcs8.asn1.h)
+
+fips140-$(CONFIG_FIPS140_PKCS8_PRIVATE_KEY_PARSER) += \
+	$(addprefix crypto/asymmetric_keys/, \
+		pkcs8_parser.o \
+		pkcs8.asn1.o \
+	)
+
+fips140-$(CONFIG_FIPS140_PKCS7_MESSAGE_PARSER) += \
+	$(addprefix crypto/asymmetric_keys/, \
+		pkcs7_parser.o \
+		pkcs7_trust.o \
+		pkcs7_verify.o \
+		pkcs7_key_type.o \
+		pkcs7.asn1.o \
+	)
+
+$(obj)/crypto/asymmetric_keys/pkcs7_parser.o: $(obj)/crypto/asymmetric_keys/pkcs7.asn1.h
+$(obj)/crypto/asymmetric_keys/pkcs7.asn1.o: \
+	$(addprefix $(obj)/crypto/asymmetric_keys/, \
+		pkcs7.asn1.c pkcs7.asn1.h)
+
+#
+# lib/crypto/Makefile
+#
+
+fips140-y += lib/crypto/aes.o
+fips140-y += lib/crypto/aesgcm.o
+fips140-y += lib/crypto/sha256.o
+fips140-y += lib/crypto/sha512.o
+fips140-y += lib/crypto/gf128mul.o
+fips140-y += lib/crypto/memneq.o
+fips140-y += lib/crypto/utils.o
+
+# Use custom linker script to collect initcalls
+LDFLAGS_fips140.o += -T $(src)/fips140.lds
+
+obj-m += fips140.o
diff --git a/fips140/fips140-glue.c b/fips140/fips140-glue.c
new file mode 100644
index 000000000000..69db638c68d1
--- /dev/null
+++ b/fips140/fips140-glue.c
@@ -0,0 +1,216 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * FIPS 140-3 and FIPS 200 support.
+ *
+ * Copyright (c) 2008 Neil Horman <nhorman@tuxdriver.com>
+ * Copyright 2021 Google LLC
+ * Copyright (c) 2025, Oracle and/or its affiliates.
+ */
+
+#include <generated/utsrelease.h>
+
+#include <linux/export.h>
+#include <linux/fips.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/sysctl.h>
+
+#include <crypto/api.h>
+#include <crypto/hash.h>
+
+#include "crypto/internal.h"
+
+#define FIPS_MODULE_NAME CONFIG_CRYPTO_FIPS_NAME
+#ifdef CONFIG_CRYPTO_FIPS_CUSTOM_VERSION
+#define FIPS_MODULE_VERSION CONFIG_CRYPTO_FIPS_VERSION
+#else
+#define FIPS_MODULE_VERSION UTS_RELEASE
+#endif
+
+static char fips_name[] = FIPS_MODULE_NAME;
+static char fips_version[] = FIPS_MODULE_VERSION;
+
+/*
+ * FIPS 140-2 prefers the use of HMAC with a public key over a plain hash.
+ */
+static const u8 fips140_integ_hmac_key[] = CONFIG_CRYPTO_FIPS140_HMAC_KEY;
+
+int fips_operational = 0;
+
+static int verify_integrity(void)
+{
+	int err;
+
+	struct crypto_shash *tfm = NULL;
+	SHASH_DESC_ON_STACK(desc, dontcare);
+	u8 digest[SHA256_DIGEST_SIZE];
+
+	/*
+	 * Verify integrity
+	 */
+
+	tfm = crypto_alloc_shash("hmac(sha256)", 0, 0);
+	if (IS_ERR(tfm))
+		panic("FIPS 140: failed to allocate hmac tfm (%ld)\n", PTR_ERR(tfm));
+
+	desc->tfm = tfm;
+	pr_info("FIPS 140: using '%s' for integrity check\n",
+		crypto_shash_driver_name(tfm));
+
+	err = crypto_shash_setkey(tfm, fips140_integ_hmac_key, strlen(fips140_integ_hmac_key));
+	if (err)
+		panic("FIPS 140: crypto_shash_setkey() failed: %d\n", err);
+
+	err = crypto_shash_init(desc);
+	if (err)
+		panic("FIPS 140: crypto_shash_init() failed: %d\n", err);
+
+	/* Compute HMAC over the module's source memory */
+	//err = crypto_shash_update(desc, THIS_MODULE->source_ptr, THIS_MODULE->source_len);
+	err = crypto_shash_update(desc, _binary_fips140_ko_start, _binary_fips140_ko_end - _binary_fips140_ko_start);
+	if (err)
+		panic("FIPS 140: crypto_shash_update() failed: %d\n", err);
+
+	err = crypto_shash_final(desc, digest);
+	if (err)
+		panic("FIPS 140: crypto_shash_final() failed: %d\n", err);
+
+	/* Zeroizing this is important; see the comment below. */
+	shash_desc_zero(desc);
+
+	if (err)
+		panic("FIPS 140: failed to calculate hmac shash (%d)\n", err);
+
+	pr_info("FIPS 140: expected digest: %*phN\n", (int)sizeof(digest), _binary_fips140_hmac_start);
+	pr_info("FIPS 140: computed digest: %*phN\n", (int)sizeof(digest), digest);
+
+	if (memcmp(digest, _binary_fips140_hmac_start, sizeof(digest)))
+		panic("FIPS 140: failed integrity check\n");
+
+	/*
+	 * FIPS 140-3 requires that all "temporary value(s) generated during the
+	 * integrity test" be zeroized (ref: FIPS 140-3 IG 9.7.B).  There is no
+	 * technical reason to do this given that these values are public
+	 * information, but this is the requirement so we follow it.
+	 */
+	crypto_free_shash(tfm);
+	memzero_explicit(digest, sizeof(digest));
+
+	return 0;
+}
+
+/* This technically is never supposed to change. */
+static int fips_standalone = 1;
+
+static struct ctl_table crypto_sysctl_table[] = {
+	{
+		.procname	= "fips_enabled",
+		/*
+		 * Note: we use fips_operational instead of fips_enabled,
+		 * since fips_enabled is more like "FIPS was requested",
+		 * and is nonzero before self testing and integrity testing
+		 * has finished. However, the difference is theoretical
+		 * since this file will not even be created until the
+		 * testing has completed.
+		 */
+		.data		= &fips_operational,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "fips_name",
+		.data		= &fips_name,
+		.maxlen		= sizeof(fips_name),
+		.mode		= 0444,
+		.proc_handler	= proc_dostring,
+	},
+	{
+		.procname	= "fips_version",
+		.data		= &fips_version,
+		.maxlen		= sizeof(fips_version),
+		.mode		= 0444,
+		.proc_handler	= proc_dostring,
+	},
+	/*
+	 * Helper file for dracut that always returns "1" to indicate
+	 * that no userspace help is needed to get the FIPS module
+	 * operational.
+	 */
+	{
+		.procname	= "fips_standalone",
+		.data		= &fips_standalone,
+		.maxlen		= sizeof(fips_standalone),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
+};
+
+static struct ctl_table_header *crypto_sysctls;
+
+static int __init check_nonfips_alg_list(void)
+{
+	extern struct list_head nonfips_crypto_alg_list;
+
+	struct crypto_alg *q;
+	int err = 0;
+
+	list_for_each_entry(q, &nonfips_crypto_alg_list, cra_list) {
+		pr_err("FIPS 140: found registered non-FIPS algorithm %s (%s)\n", q->cra_name, q->cra_driver_name);
+		err = 1;
+	}
+
+	return err;
+}
+
+static int __init run_initcalls(void)
+{
+	extern unsigned long __fips_initcalls_start[];
+	extern unsigned long __fips_initcalls_end[];
+
+	for (unsigned long *initcall = __fips_initcalls_start;
+		initcall != __fips_initcalls_end; ++initcall)
+	{
+		int ret;
+		initcall_t fn;
+
+		fn = (initcall_t) *initcall;
+		pr_info("FIPS 140: calling %pS\n", fn);
+
+		ret = fn();
+		if (!ret || ret == -ENODEV)
+			continue;
+
+		panic("FIPS 140: initcall %pS failed: %d\n", fn, ret);
+	}
+
+	return 0;
+}
+
+static int __init fips140_init(void)
+{
+	pr_info("FIPS 140: %s version %s\n", fips_name, fips_version);
+
+	if (check_nonfips_alg_list())
+		panic("FIPS 140: found registered non-FIPS algorithms\n");
+
+	run_initcalls();
+
+	if (verify_integrity())
+		panic("FIPS 140: integrity check failed\n");
+
+	crypto_sysctls = register_sysctl("crypto", crypto_sysctl_table);
+	if (!crypto_sysctls)
+		panic("FIPS 140: failed to register sysctls");
+
+	fips_operational = 1;
+
+	pr_info("FIPS 140: operational\n");
+	return 0;
+}
+module_init(fips140_init);
+
+MODULE_DESCRIPTION("FIPS 140 Cryptographic Module");
+MODULE_LICENSE("GPL");
diff --git a/fips140/fips140.lds b/fips140/fips140.lds
new file mode 100644
index 000000000000..78ac3fa7a7db
--- /dev/null
+++ b/fips140/fips140.lds
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+SECTIONS {
+	.init.data : {
+		__fips_initcalls_start = .;
+		*(.fips_initcall)
+		__fips_initcalls_end = .;
+       }
+}
-- 
2.39.3

