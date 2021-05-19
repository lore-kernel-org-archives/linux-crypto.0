Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53DE2C433B4
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 11:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39DF46139A
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 11:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350363AbhESLYM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 May 2021 07:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241088AbhESLYG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 May 2021 07:24:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B7B36135C;
        Wed, 19 May 2021 11:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621423366;
        bh=CK0UATbAPMGBHgoaDVlRXBZQWLHrCBzSLKEOlHdqK3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pR9EMifBdNm9VnjqseEQeyy7e7khDLujLSGYj3BEK7SJkZzal89ucJD79BFNPZ9fp
         mphW7fmgsPvK/4hxDyX+9Q4DlSiJAbAFfS65rAnJ3MmZpAFSmNLx3xrH7iRR5axCRh
         JcNaDRQ9Na30tdBacaP13rZKZ5FOWOZ1ry+y4293Ht87bRBHsi2OsByD7alJ+lxGrr
         5OxqJlpY2wqdcRJQ1m5cMIlyQdpk7H3NjzLAZrvzg+OBrM0Jupj1m2hrhdqjst3O/4
         pMamzajDD/dbExpcEFjDKFfT9ElzHvIA1vdkAQkH5uD0D8KA/LR+2senmfJhZp77FP
         cb9RpXZ2CXQkw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v4 1/7] crypto: skcipher - handle zero sized inputs correctly
Date:   Wed, 19 May 2021 13:22:33 +0200
Message-Id: <20210519112239.33664-2-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210519112239.33664-1-ardb@kernel.org>
References: <20210519112239.33664-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There are corner cases where skcipher_walk_aead_encrypt() may be
invoked with a zero sized input, which is not rejected by the walker
code, but results in the skcipher_walk structure to not be fully
initialized. This will leave stale values in its page and buffer
members, which will be subsequently passed to kfree() or free_page() by
skcipher_walk_done(), resulting in a crash if those routines fail to
identify them as in valid inputs.

Fix this by setting page and buffer to NULL even if the size of the
input is zero. Note that for AEAD encryption in particular, a zero sized
input could be a valid and meaningful use of the API, given the support
for associated authenticated data (AAD), which gets reflected in the
authentication tag as well.

For symmetry, apply the same fix to the plain skcipher walker code, even
though in that case, no meaningful usage scenarios are known for zero
sized inputs.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/skcipher.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index a15376245416..ed2deb031742 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -455,6 +455,8 @@ static int skcipher_walk_skcipher(struct skcipher_walk *walk,
 	walk->nbytes = 0;
 	walk->iv = req->iv;
 	walk->oiv = req->iv;
+	walk->buffer = NULL;
+	walk->page = NULL;
 
 	if (unlikely(!walk->total))
 		return 0;
@@ -511,6 +513,8 @@ static int skcipher_walk_aead_common(struct skcipher_walk *walk,
 	walk->nbytes = 0;
 	walk->iv = req->iv;
 	walk->oiv = req->iv;
+	walk->buffer = NULL;
+	walk->page = NULL;
 
 	if (unlikely(!walk->total))
 		return 0;
-- 
2.20.1

