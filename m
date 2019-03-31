Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FBDC10F06
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B28F20872
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554062768;
	bh=q9coeuUWGr3APnxfiFL9/oqIIbF7yb+DDzgC7R03WEI=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=VJ+mw+mYPWbzMk1sXfv5acB4rffpi19FZxtYPyNvPpNznwF5bfnbGfRaQgNz6Oyuc
	 SsZa3AVx0qFfDe1sWYRwsvOKyZ2jrFCm/GQj9szEbd5TatxMLKYLrKnUkQhuWY/C3V
	 48Is77lG0cOmYjwdZvMeZXW5ySEY9Lf0KfL7K4Ho=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731499AbfCaUGG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 Mar 2019 16:06:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731353AbfCaUF7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Mar 2019 16:05:59 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD74F218E2
        for <linux-crypto@vger.kernel.org>; Sun, 31 Mar 2019 20:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554062758;
        bh=q9coeuUWGr3APnxfiFL9/oqIIbF7yb+DDzgC7R03WEI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=T4QYDFX4vJK9HabERVopdZS+5fkjEMSTtDkNBfArZqpNE82BRbZhy6qEZVzgV9kcn
         4MCnBDV67dflCAhnjAx0AKSPnV+Vf9S8mcyHi6iEFF6yR5JG1ghNc9bmlc1ZhV15oc
         7hA4fZfz67ONmUurJrt2eKvwY8lVkvLFJsAEMTn4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [RFC/RFT PATCH 11/18] crypto: arm64/cbcmac - handle empty messages in same way as template
Date:   Sun, 31 Mar 2019 13:04:21 -0700
Message-Id: <20190331200428.26597-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190331200428.26597-1-ebiggers@kernel.org>
References: <20190331200428.26597-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

My patches to make testmgr fuzz algorithms against their generic
implementation detected that the arm64 implementations of "cbcmac(aes)"
handle empty messages differently from the cbcmac template.  Namely, the
arm64 implementations return the encrypted initial value, but the cbcmac
template returns the initial value directly.

This isn't actually a meaningful case because any user of cbcmac needs
to prepend the message length, as CCM does; otherwise it's insecure.
However, we should keep the behavior consistent; at the very least this
makes testing easier.

Do it the easy way, which is to change the arm64 implementations to have
the same behavior as the cbcmac template.

For what it's worth, ghash does things essentially the same way: it
returns its initial value when given an empty message, even though in
practice ghash is never passed an empty message.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/aes-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 692cb75f2ca2f..f0ceb545bd1ee 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -707,7 +707,7 @@ static int cbcmac_final(struct shash_desc *desc, u8 *out)
 	struct mac_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
 	struct mac_desc_ctx *ctx = shash_desc_ctx(desc);
 
-	mac_do_update(&tctx->key, NULL, 0, ctx->dg, 1, 0);
+	mac_do_update(&tctx->key, NULL, 0, ctx->dg, (ctx->len != 0), 0);
 
 	memcpy(out, ctx->dg, AES_BLOCK_SIZE);
 
-- 
2.21.0

