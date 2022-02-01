Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 248B5C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Feb 2022 08:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235571AbiBAImP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Feb 2022 03:42:15 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.24]:40445 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbiBAImO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Feb 2022 03:42:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1643704925;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=umL7/7M8PKPS10nEN4wTl9xQHWEq8qbSqviM0UlZA8c=;
    b=rC73LZRq9nJmajhz5BTzdqch25MLgFVH/io6Q9wu/58BACxykm2mHGYIYcT2s3SiZn
    kn96GdgjGcwrfFsnot78qSa+TUG2XPLLCfawjxZ7Kn9ZPlJwnZ1ydE6WlVq8B3N+PAvF
    yvi6m26rEL4DdDYQeTI3oR1c5puXUnUbppGM8If0FgX+KB/LZ/GQiZdY3J1bmJecg7Wa
    uTC9VzHaoiI/EUcQL4nLiLzFRRyYHUl8S1mC6i1YJ/zTG1caMFJbzpY1PJiiplKzYlg4
    1NRBIaFWOA+bDVVv2ODTzaq70R0S2lcAJXF2T2WBzshwL9QXC57hSYdWBluGs3frEQ0B
    tSbg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9zW8BKRp5UFiyGZZ4jof7Xg=="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.39.0 AUTH)
    with ESMTPSA id z28df7y118g43Jo
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 1 Feb 2022 09:42:04 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, Niolai Stange <nstange@suse.com>,
        Simo Sorce <simo@redhat.com>
Subject: [PATCH v2 2/2] crypto: HMAC - disallow keys < 112 bits in FIPS mode
Date:   Tue, 01 Feb 2022 09:41:32 +0100
Message-ID: <25394269.1r3eYUQgxm@positron.chronox.de>
In-Reply-To: <4609802.vXUDI8C0e8@positron.chronox.de>
References: <2075651.9o76ZdvQCi@positron.chronox.de> <YfN1HKqL9GT9R25Z@gondor.apana.org.au> <4609802.vXUDI8C0e8@positron.chronox.de>
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
 crypto/hmac.c    | 4 ++++
 crypto/testmgr.h | 9 +++++++++
 2 files changed, 13 insertions(+)

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
index 17b37525f289..85ccf811f5e7 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -5715,6 +5715,7 @@ static const struct hash_testvec hmac_sha1_tv_template[] = {
 		.psize	= 28,
 		.digest	= "\xef\xfc\xdf\x6a\xe5\xeb\x2f\xa2\xd2\x74"
 			  "\x16\xd5\xf1\x84\xdf\x9c\x25\x9a\x7c\x79",
+		.fips_skip = 1,
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa",
 		.ksize	= 20,
@@ -5804,6 +5805,7 @@ static const struct hash_testvec hmac_sha224_tv_template[] = {
 			"\x45\x69\x0f\x3a\x7e\x9e\x6d\x0f"
 			"\x8b\xbe\xa2\xa3\x9e\x61\x48\x00"
 			"\x8f\xd0\x5e\x44",
+		.fips_skip = 1,
 	}, {
 		.key    = "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -5947,6 +5949,7 @@ static const struct hash_testvec hmac_sha256_tv_template[] = {
 			  "\x6a\x04\x24\x26\x08\x95\x75\xc7"
 			  "\x5a\x00\x3f\x08\x9d\x27\x39\x83"
 			  "\x9d\xec\x58\xb9\x64\xec\x38\x43",
+		.fips_skip = 1,
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -6445,6 +6448,7 @@ static const struct hash_testvec hmac_sha384_tv_template[] = {
 			  "\xe4\x2e\xc3\x73\x63\x22\x44\x5e"
 			  "\x8e\x22\x40\xca\x5e\x69\xe2\xc7"
 			  "\x8b\x32\x39\xec\xfa\xb2\x16\x49",
+		.fips_skip = 1,
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			  "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -6545,6 +6549,7 @@ static const struct hash_testvec hmac_sha512_tv_template[] = {
 			  "\x6d\x03\x4f\x65\xf8\xf0\xe6\xfd"
 			  "\xca\xea\xb1\xa3\x4d\x4a\x6b\x4b"
 			  "\x63\x6e\x07\x0a\x38\xbc\xe7\x37",
+		.fips_skip = 1,
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			  "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -6640,6 +6645,7 @@ static const struct hash_testvec hmac_sha3_224_tv_template[] = {
 			  "\x1b\x79\x86\x34\xad\x38\x68\x11"
 			  "\xc2\xcf\xc8\x5b\xfa\xf5\xd5\x2b"
 			  "\xba\xce\x5e\x66",
+		.fips_skip = 1,
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			  "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -6727,6 +6733,7 @@ static const struct hash_testvec hmac_sha3_256_tv_template[] = {
 			  "\x35\x96\xbb\xb0\xda\x73\xb8\x87"
 			  "\xc9\x17\x1f\x93\x09\x5b\x29\x4a"
 			  "\xe8\x57\xfb\xe2\x64\x5e\x1b\xa5",
+		.fips_skip = 1,
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			  "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -6818,6 +6825,7 @@ static const struct hash_testvec hmac_sha3_384_tv_template[] = {
 			  "\x3c\xa1\x35\x08\xa9\x32\x43\xce"
 			  "\x48\xc0\x45\xdc\x00\x7f\x26\xa2"
 			  "\x1b\x3f\x5e\x0e\x9d\xf4\xc2\x0a",
+		.fips_skip = 1,
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			  "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -6917,6 +6925,7 @@ static const struct hash_testvec hmac_sha3_512_tv_template[] = {
 			  "\xee\x7a\x0c\x31\xd0\x22\xa9\x5e"
 			  "\x1f\xc9\x2b\xa9\xd7\x7d\xf8\x83"
 			  "\x96\x02\x75\xbe\xb4\xe6\x20\x24",
+		.fips_skip = 1,
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			  "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
-- 
2.33.1




