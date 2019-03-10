Return-Path: <SRS0=xGgh=RN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B727FC10F0D
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Mar 2019 19:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85B442087F
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Mar 2019 19:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552244532;
	bh=C6zx/gF4vIXF28sfcfsxIKBGW0KqLDXNdShm1EaSfsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=pcF6bmQFNdnlVKWLKhvlQq0wRLITabxjvJSzg0iX3ojC1UFjSDj7b9wnn3c6fBV0A
	 96N1PKA7hleIWjva9H2BAdn28hoLFp5tPupqG0RlP5kO5PTMJSYfS0G4vRlT3Ply2f
	 TKK9vkeWcmJTIyfFsnFJd+/k5Vt5NTwYwaosGb3s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfCJTCL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 10 Mar 2019 15:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbfCJTCL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 10 Mar 2019 15:02:11 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B04832084F;
        Sun, 10 Mar 2019 19:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552244529;
        bh=C6zx/gF4vIXF28sfcfsxIKBGW0KqLDXNdShm1EaSfsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ym6kmoWwwfaraH0mmVDEVpLK//2n4iP8XzMQW/2LJVdYyTW2oJ+rR+ItM6/Q4uD59
         CTaW6YuyFYJnVKfF359wiR1U+aJN5bUtC/adnsaxnnKSEUYtOqrjYrHxsv55EiAY9y
         YWore1OXjUWdEVsnoOJuJkt4U5mXRKsrGXMnTTUs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 2/9] crypto: x86/aesni - convert to use skcipher SIMD bulk registration
Date:   Sun, 10 Mar 2019 12:00:51 -0700
Message-Id: <20190310190058.4912-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190310190058.4912-1-ebiggers@kernel.org>
References: <20190310190058.4912-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Convert the AES-NI glue code to use simd_register_skciphers_compat() to
create SIMD wrappers for all the internal skcipher algorithms at once,
rather than wrapping each one individually.  This simplifies the code.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 43 +++++-------------------------
 1 file changed, 7 insertions(+), 36 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 1e3d2102033a..451918cc5f73 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1253,23 +1253,9 @@ static const struct x86_cpu_id aesni_cpu_id[] = {
 };
 MODULE_DEVICE_TABLE(x86cpu, aesni_cpu_id);
 
-static void aesni_free_simds(void)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(aesni_simd_skciphers) &&
-		    aesni_simd_skciphers[i]; i++)
-		simd_skcipher_free(aesni_simd_skciphers[i]);
-}
-
 static int __init aesni_init(void)
 {
-	struct simd_skcipher_alg *simd;
-	const char *basename;
-	const char *algname;
-	const char *drvname;
 	int err;
-	int i;
 
 	if (!x86_match_cpu(aesni_cpu_id))
 		return -ENODEV;
@@ -1304,8 +1290,9 @@ static int __init aesni_init(void)
 	if (err)
 		return err;
 
-	err = crypto_register_skciphers(aesni_skciphers,
-					ARRAY_SIZE(aesni_skciphers));
+	err = simd_register_skciphers_compat(aesni_skciphers,
+					     ARRAY_SIZE(aesni_skciphers),
+					     aesni_simd_skciphers);
 	if (err)
 		goto unregister_algs;
 
@@ -1314,26 +1301,11 @@ static int __init aesni_init(void)
 	if (err)
 		goto unregister_skciphers;
 
-	for (i = 0; i < ARRAY_SIZE(aesni_skciphers); i++) {
-		algname = aesni_skciphers[i].base.cra_name + 2;
-		drvname = aesni_skciphers[i].base.cra_driver_name + 2;
-		basename = aesni_skciphers[i].base.cra_driver_name;
-		simd = simd_skcipher_create_compat(algname, drvname, basename);
-		err = PTR_ERR(simd);
-		if (IS_ERR(simd))
-			goto unregister_simds;
-
-		aesni_simd_skciphers[i] = simd;
-	}
-
 	return 0;
 
-unregister_simds:
-	aesni_free_simds();
-	crypto_unregister_aeads(aesni_aead_algs, ARRAY_SIZE(aesni_aead_algs));
 unregister_skciphers:
-	crypto_unregister_skciphers(aesni_skciphers,
-				    ARRAY_SIZE(aesni_skciphers));
+	simd_unregister_skciphers(aesni_skciphers, ARRAY_SIZE(aesni_skciphers),
+				  aesni_simd_skciphers);
 unregister_algs:
 	crypto_unregister_algs(aesni_algs, ARRAY_SIZE(aesni_algs));
 	return err;
@@ -1341,10 +1313,9 @@ static int __init aesni_init(void)
 
 static void __exit aesni_exit(void)
 {
-	aesni_free_simds();
 	crypto_unregister_aeads(aesni_aead_algs, ARRAY_SIZE(aesni_aead_algs));
-	crypto_unregister_skciphers(aesni_skciphers,
-				    ARRAY_SIZE(aesni_skciphers));
+	simd_unregister_skciphers(aesni_skciphers, ARRAY_SIZE(aesni_skciphers),
+				  aesni_simd_skciphers);
 	crypto_unregister_algs(aesni_algs, ARRAY_SIZE(aesni_algs));
 }
 
-- 
2.21.0

