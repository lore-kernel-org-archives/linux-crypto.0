Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 047FEC49EA5
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jun 2021 15:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2B23613E3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jun 2021 15:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhFXPrA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jun 2021 11:47:00 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.22]:11205 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhFXPq7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jun 2021 11:46:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1624549477;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=E8N2YNo+ZbMOAm98Ym3FHyNM/XNFhaYkgKqJoQZAKz4=;
    b=rOxWWpq+m3Uht37UNO27KSrS2Lo5SegahzBDwbJZ6LEKRnwerkQf4umuR8ZjR+VA6b
    WRm6Y8JDoTU70nwiHHcXSCXmNEwW+OL7ewvH5zCLVmz0vrIL9DHKh813f34E+wsREW/Q
    qrUTlzfsWvE2Jcy5JxkgcGmpKXOWxff7jP6chBqDo/uefw5yxPMSKGhR1FyQGPLlsoEe
    gTj6VWKCYKvBaqPfDFYjpCRVolLQEtO1z7Q7CkClZYKDKlv5EvFOXV6DKqP085VI/Ith
    Ux9QwGh2VLAxNp2pPhJd0JfRLm1dJHG6SuEqdOLO4gz4j1MpvhRNHs0H5AV5g9qVNdML
    PfAQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbJfScDuy6"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.27.5 DYNA|AUTH)
    with ESMTPSA id L04113x5OFia6PD
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 24 Jun 2021 17:44:36 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, Vlad Dronov <vdronov@redhat.com>
Subject: [PATCH] crypto: DRBG - self test for HMAC(SHA-512)
Date:   Thu, 24 Jun 2021 17:44:35 +0200
Message-ID: <11782290.ZbvtA0Mc7t@positron.chronox.de>
In-Reply-To: <20210624143019.GA20222@gondor.apana.org.au>
References: <3171520.o5pSzXOnS6@positron.chronox.de> <20210624143019.GA20222@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Considering that the HMAC(SHA-512) DRBG is the default DRBG now, a self
test is to be provided.

The test vector is obtained from a successful NIST ACVP test run.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/testmgr.c |  5 ++++-
 crypto/testmgr.h | 49 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 1f7f63e836ae..c978e41f11a1 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4686,8 +4686,11 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_null,
 	}, {
 		.alg = "drbg_nopr_hmac_sha512",
-		.test = alg_test_null,
+		.test = alg_test_drbg,
 		.fips_allowed = 1,
+		.suite = {
+			.drbg = __VECS(drbg_nopr_hmac_sha512_tv_template)
+		}
 	}, {
 		.alg = "drbg_nopr_sha1",
 		.fips_allowed = 1,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 96eb7ce9f81b..3ed6ab34ab51 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -21984,6 +21984,55 @@ static const struct drbg_testvec drbg_nopr_hmac_sha256_tv_template[] = {
 	},
 };
 
+/* Test vector obtained during NIST ACVP testing */
+static const struct drbg_testvec drbg_nopr_hmac_sha512_tv_template[] = {
+	{
+		.entropy = (unsigned char *)
+			"\xDF\xB0\xF2\x18\xF0\x78\x07\x01\x29\xA4\x29\x26"
+			"\x2F\x8A\x34\xCB\x37\xEF\xEE\x41\xE6\x96\xF7\xFF"
+			"\x61\x47\xD3\xED\x41\x97\xEF\x64\x0C\x48\x56\x5A"
+			"\xE6\x40\x6E\x4A\x3B\x9E\x7F\xAC\x08\xEC\x25\xAE"
+			"\x0B\x51\x0E\x2C\x44\x2E\xBD\xDB\x57\xD0\x4A\x6D"
+			"\x80\x3E\x37\x0F",
+		.entropylen = 64,
+		.expected = (unsigned char *)
+			"\x48\xc6\xa8\xdb\x09\xae\xde\x5d\x8c\x77\xf3\x52"
+			"\x92\x71\xa7\xb9\x6d\x53\x6d\xa3\x73\xe3\x55\xb8"
+			"\x39\xd6\x44\x2b\xee\xcb\xe1\x32\x15\x30\xbe\x4e"
+			"\x9b\x1e\x06\xd1\x6b\xbf\xd5\x3e\xea\x7c\xf5\xaa"
+			"\x4b\x05\xb5\xd3\xa7\xb2\xc4\xfe\xe7\x1b\xda\x11"
+			"\x43\x98\x03\x70\x90\xbf\x6e\x43\x9b\xe4\x14\xef"
+			"\x71\xa3\x2a\xef\x9f\x0d\xb9\xe3\x52\xf2\x89\xc9"
+			"\x66\x9a\x60\x60\x99\x60\x62\x4c\xd6\x45\x52\x54"
+			"\xe6\x32\xb2\x1b\xd4\x48\xb5\xa6\xf9\xba\xd3\xff"
+			"\x29\xc5\x21\xe0\x91\x31\xe0\x38\x8c\x93\x0f\x3c"
+			"\x30\x7b\x53\xa3\xc0\x7f\x2d\xc1\x39\xec\x69\x0e"
+			"\xf2\x4a\x3c\x65\xcc\xed\x07\x2a\xf2\x33\x83\xdb"
+			"\x10\x74\x96\x40\xa7\xc5\x1b\xde\x81\xca\x0b\x8f"
+			"\x1e\x0a\x1a\x7a\xbf\x3c\x4a\xb8\x8c\xaf\x7b\x80"
+			"\xb7\xdc\x5d\x0f\xef\x1b\x97\x6e\x3d\x17\x23\x5a"
+			"\x31\xb9\x19\xcf\x5a\xc5\x00\x2a\xb6\xf3\x99\x34"
+			"\x65\xee\xe9\x1c\x55\xa0\x3b\x07\x60\xc9\xc4\xe4"
+			"\xf7\x57\x5c\x34\x9f\xc6\x31\x30\x3f\x23\xb2\x89"
+			"\xc0\xe7\x50\xf3\xde\x59\xd1\x0e\xb3\x0f\x78\xcc"
+			"\x7e\x54\x5e\x61\xf6\x86\x3d\xb3\x11\x94\x36\x3e"
+			"\x61\x5c\x48\x99\xf6\x7b\x02\x9a\xdc\x6a\x28\xe6"
+			"\xd1\xa7\xd1\xa3",
+		.expectedlen = 256,
+		.addtla = (unsigned char *)
+			"\x6B\x0F\x4A\x48\x0B\x12\x85\xE4\x72\x23\x7F\x7F"
+			"\x94\x7C\x24\x69\x14\x9F\xDC\x72\xA6\x33\xAD\x3C"
+			"\x8C\x72\xC1\x88\x49\x59\x82\xC5",
+		.addtlb = (unsigned char *)
+			"\xC4\xAF\x36\x3D\xB8\x5D\x9D\xFA\x92\xF5\xC3\x3C"
+			"\x2D\x1E\x22\x2A\xBD\x8B\x05\x6F\xA3\xFC\xBF\x16"
+			"\xED\xAA\x75\x8D\x73\x9A\xF6\xEC",
+		.addtllen = 32,
+		.pers = NULL,
+		.perslen = 0,
+	}
+};
+
 static const struct drbg_testvec drbg_nopr_ctr_aes192_tv_template[] = {
 	{
 		.entropy = (unsigned char *)
-- 
2.31.1




