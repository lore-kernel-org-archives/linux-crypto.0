Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C38C433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Jan 2022 19:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbiAGTZf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Jan 2022 14:25:35 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:33109 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbiAGTZf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jan 2022 14:25:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1641583525;
    s=strato-dkim-0002; d=chronox.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=M+SQmxgMc1/X10GDeOfuJA3s+keJz9LooGbHQ2pfnnQ=;
    b=l2z/Dix8zcgNMbBGZV1p3Dhthskv7s7Ef8Umnf4jDDaWQ81qOeRQC0OHNsYHB1xn1u
    MtWmDJXwBN0CKRlyDIB9+KfWo0MaP6lQWuoeRRgn2E5UuAZz9/MQn1RHFtbDDlVxNLhu
    IyfnHsP7J/jcpmtIg8X1Gua6oaGozhHhusSTMWH8ghvq6uPqPYL1MKpO1dF4U2jcvnoH
    BN/4mLQq3ucx2p6zV0U5D7Ih+NDT6WiSY4H1ZYcVHT0XzczFSI17CR2W5R1ClF0qC8DS
    /DusAknHtPMmuTWy+nXY/ey03lDvLWf35Z+J0He81gJXKJeV8xc4aEkJCxsOHZJaJq86
    BD/Q==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaL/ScjzBA"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.37.6 DYNA|AUTH)
    with ESMTPSA id t60e2cy07JPO3os
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 7 Jan 2022 20:25:24 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, Niolai Stange <nstange@suse.com>,
        Simo Sorce <simo@redhat.com>
Subject: [PATCH] crypto: HMAC - disallow keys < 112 bits in FIPS mode
Date:   Fri, 07 Jan 2022 20:25:24 +0100
Message-ID: <2075651.9o76ZdvQCi@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

FIPS 140 requires a minimum security strength of 112 bits. This implies
that the HMAC key must not be smaller than 112 in FIPS mode.

This restriction implies that the test vectors for HMAC that have a key
that is smaller than 112 bits must be disabled when FIPS support is
compiled.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/hmac.c    |  4 ++++
 crypto/testmgr.h | 18 ++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index 25856aa7ccbf..3610ff0b6739 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -15,6 +15,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
+#include <linux/fips.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -51,6 +52,9 @@ static int hmac_setkey(struct crypto_shash *parent,
 	SHASH_DESC_ON_STACK(shash, hash);
 	unsigned int i;
 
+	if (fips_enabled && (keylen < 112 / 8))
+		return -EINVAL;
+
 	shash->tfm = hash;
 
 	if (keylen > bs) {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index a253d66ba1c1..1c39d294b9ba 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -5706,6 +5706,7 @@ static const struct hash_testvec hmac_sha1_tv_template[] = {
 		.digest	= "\xb6\x17\x31\x86\x55\x05\x72\x64"
 			  "\xe2\x8b\xc0\xb6\xfb\x37\x8c\x8e\xf1"
 			  "\x46\xbe",
+#ifndef CONFIG_CRYPTO_FIPS
 	}, {
 		.key	= "Jefe",
 		.ksize	= 4,
@@ -5713,6 +5714,7 @@ static const struct hash_testvec hmac_sha1_tv_template[] = {
 		.psize	= 28,
 		.digest	= "\xef\xfc\xdf\x6a\xe5\xeb\x2f\xa2\xd2\x74"
 			  "\x16\xd5\xf1\x84\xdf\x9c\x25\x9a\x7c\x79",
+#endif
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa",
 		.ksize	= 20,
@@ -5789,6 +5791,7 @@ static const struct hash_testvec hmac_sha224_tv_template[] = {
 			"\x68\x32\x10\x7c\xd4\x9d\xf3\x3f"
 			"\x47\xb4\xb1\x16\x99\x12\xba\x4f"
 			"\x53\x68\x4b\x22",
+#ifndef CONFIG_CRYPTO_FIPS
 	}, {
 		.key    = "Jefe",
 		.ksize  = 4,
@@ -5802,6 +5805,7 @@ static const struct hash_testvec hmac_sha224_tv_template[] = {
 			"\x45\x69\x0f\x3a\x7e\x9e\x6d\x0f"
 			"\x8b\xbe\xa2\xa3\x9e\x61\x48\x00"
 			"\x8f\xd0\x5e\x44",
+#endif
 	}, {
 		.key    = "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -5936,6 +5940,7 @@ static const struct hash_testvec hmac_sha256_tv_template[] = {
 			  "\x99\x03\xa0\xf1\xcf\x2b\xbd\xc5"
 			  "\xba\x0a\xa3\xf3\xd9\xae\x3c\x1c"
 			  "\x7a\x3b\x16\x96\xa0\xb6\x8c\xf7",
+#ifndef CONFIG_CRYPTO_FIPS
 	}, {
 		.key	= "Jefe",
 		.ksize	= 4,
@@ -5945,6 +5950,7 @@ static const struct hash_testvec hmac_sha256_tv_template[] = {
 			  "\x6a\x04\x24\x26\x08\x95\x75\xc7"
 			  "\x5a\x00\x3f\x08\x9d\x27\x39\x83"
 			  "\x9d\xec\x58\xb9\x64\xec\x38\x43",
+#endif
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -6432,6 +6438,7 @@ static const struct hash_testvec hmac_sha384_tv_template[] = {
 			  "\x82\xaa\x03\x4c\x7c\xeb\xc5\x9c"
 			  "\xfa\xea\x9e\xa9\x07\x6e\xde\x7f"
 			  "\x4a\xf1\x52\xe8\xb2\xfa\x9c\xb6",
+#ifndef CONFIG_CRYPTO_FIPS
 	}, {
 		.key	= "Jefe",
 		.ksize	= 4,
@@ -6443,6 +6450,7 @@ static const struct hash_testvec hmac_sha384_tv_template[] = {
 			  "\xe4\x2e\xc3\x73\x63\x22\x44\x5e"
 			  "\x8e\x22\x40\xca\x5e\x69\xe2\xc7"
 			  "\x8b\x32\x39\xec\xfa\xb2\x16\x49",
+#endif
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			  "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -6530,6 +6538,7 @@ static const struct hash_testvec hmac_sha512_tv_template[] = {
 			  "\x03\x8b\x27\x4e\xae\xa3\xf4\xe4"
 			  "\xbe\x9d\x91\x4e\xeb\x61\xf1\x70"
 			  "\x2e\x69\x6c\x20\x3a\x12\x68\x54",
+#ifndef CONFIG_CRYPTO_FIPS
 	}, {
 		.key	= "Jefe",
 		.ksize	= 4,
@@ -6543,6 +6552,7 @@ static const struct hash_testvec hmac_sha512_tv_template[] = {
 			  "\x6d\x03\x4f\x65\xf8\xf0\xe6\xfd"
 			  "\xca\xea\xb1\xa3\x4d\x4a\x6b\x4b"
 			  "\x63\x6e\x07\x0a\x38\xbc\xe7\x37",
+#endif
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			  "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -6629,6 +6639,7 @@ static const struct hash_testvec hmac_sha3_224_tv_template[] = {
 			  "\x6a\x03\x1d\xca\xfd\x56\x37\x3d"
 			  "\x98\x84\x36\x76\x41\xd8\xc5\x9a"
 			  "\xf3\xc8\x60\xf7",
+#ifndef CONFIG_CRYPTO_FIPS
 	}, {
 		.key	= "Jefe",
 		.ksize	= 4,
@@ -6638,6 +6649,7 @@ static const struct hash_testvec hmac_sha3_224_tv_template[] = {
 			  "\x1b\x79\x86\x34\xad\x38\x68\x11"
 			  "\xc2\xcf\xc8\x5b\xfa\xf5\xd5\x2b"
 			  "\xba\xce\x5e\x66",
+#endif
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			  "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -6716,6 +6728,7 @@ static const struct hash_testvec hmac_sha3_256_tv_template[] = {
 			  "\xe2\xa3\xa4\x0e\x69\x77\x43\x51"
 			  "\x14\x0b\xb7\x18\x5e\x12\x02\xcd"
 			  "\xcc\x91\x75\x89\xf9\x5e\x16\xbb",
+#ifndef CONFIG_CRYPTO_FIPS
 	}, {
 		.key	= "Jefe",
 		.ksize	= 4,
@@ -6725,6 +6738,7 @@ static const struct hash_testvec hmac_sha3_256_tv_template[] = {
 			  "\x35\x96\xbb\xb0\xda\x73\xb8\x87"
 			  "\xc9\x17\x1f\x93\x09\x5b\x29\x4a"
 			  "\xe8\x57\xfb\xe2\x64\x5e\x1b\xa5",
+#endif
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			  "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -6805,6 +6819,7 @@ static const struct hash_testvec hmac_sha3_384_tv_template[] = {
 			  "\x1b\xc2\x7d\xc1\x0a\x2e\x72\x3a"
 			  "\x20\xd3\x70\xb4\x77\x43\x13\x0e"
 			  "\x26\xac\x7e\x3d\x53\x28\x86\xbd",
+#ifndef CONFIG_CRYPTO_FIPS
 	}, {
 		.key	= "Jefe",
 		.ksize	= 4,
@@ -6816,6 +6831,7 @@ static const struct hash_testvec hmac_sha3_384_tv_template[] = {
 			  "\x3c\xa1\x35\x08\xa9\x32\x43\xce"
 			  "\x48\xc0\x45\xdc\x00\x7f\x26\xa2"
 			  "\x1b\x3f\x5e\x0e\x9d\xf4\xc2\x0a",
+#endif
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			  "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -6902,6 +6918,7 @@ static const struct hash_testvec hmac_sha3_512_tv_template[] = {
 			  "\x88\xd2\x2b\x6d\xc6\x13\x80\xf2"
 			  "\x3a\x66\x8f\xd3\x88\x8b\xb8\x05"
 			  "\x37\xc0\xa0\xb8\x64\x07\x68\x9e",
+#ifndef CONFIG_CRYPTO_FIPS
 	}, {
 		.key	= "Jefe",
 		.ksize	= 4,
@@ -6915,6 +6932,7 @@ static const struct hash_testvec hmac_sha3_512_tv_template[] = {
 			  "\xee\x7a\x0c\x31\xd0\x22\xa9\x5e"
 			  "\x1f\xc9\x2b\xa9\xd7\x7d\xf8\x83"
 			  "\x96\x02\x75\xbe\xb4\xe6\x20\x24",
+#endif
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			  "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
-- 
2.33.1




