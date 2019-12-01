Return-Path: <SRS0=52Dc=ZX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4DBC33CBB
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Dec 2019 21:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 174BD20865
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Dec 2019 21:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575237263;
	bh=NMjnmjGfUURojIaOCoQJrKQBPswnVn38duinqOTrrlA=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=iNWwF51HG8S6fEEvzZfSzNWFXiF2VbMIsbKkmM+1VYv8bJOsIxykld3Mh6EPWcSnQ
	 pVw1ecCriitbBrdmcKpVT6XSVlVhWM4ddAdSKA+QaXOR8cjHVucETtDyT2tH1/6i+C
	 0OE5nAZtMTWacvyjWrNzE7gIN6uztyWVVzHM4/GI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfLAVyW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Dec 2019 16:54:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727167AbfLAVyU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Dec 2019 16:54:20 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82B71218AC
        for <linux-crypto@vger.kernel.org>; Sun,  1 Dec 2019 21:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575237260;
        bh=NMjnmjGfUURojIaOCoQJrKQBPswnVn38duinqOTrrlA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=xm6t9MozATTM6w4w+lu0rgJczpdzxpl2Kq2urhBI1sx41NiL9Bu6ZYtpZWZ9bBdvK
         u7tSfKxnru2xtmOMwlaBHVhf6+DP2bM5corrhVFAgz86wLzbwLR22F7nhP4aCOjv5F
         +60TVxXvJYNXdyDeRnhIRMLTR8Qnt3XJyd+cOAZc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 4/7] crypto: testmgr - check skcipher min_keysize
Date:   Sun,  1 Dec 2019 13:53:27 -0800
Message-Id: <20191201215330.171990-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191201215330.171990-1-ebiggers@kernel.org>
References: <20191201215330.171990-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When checking two implementations of the same skcipher algorithm for
consistency, require that the minimum key size be the same, not just the
maximum key size.  There's no good reason to allow different minimum key
sizes.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index a8940415512f..3d7c1c1529cf 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2764,6 +2764,15 @@ static int test_skcipher_vs_generic_impl(const char *driver,
 
 	/* Check the algorithm properties for consistency. */
 
+	if (crypto_skcipher_min_keysize(tfm) !=
+	    crypto_skcipher_min_keysize(generic_tfm)) {
+		pr_err("alg: skcipher: min keysize for %s (%u) doesn't match generic impl (%u)\n",
+		       driver, crypto_skcipher_min_keysize(tfm),
+		       crypto_skcipher_min_keysize(generic_tfm));
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (maxkeysize != crypto_skcipher_max_keysize(generic_tfm)) {
 		pr_err("alg: skcipher: max keysize for %s (%u) doesn't match generic impl (%u)\n",
 		       driver, maxkeysize,
-- 
2.24.0

