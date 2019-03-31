Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F79C43381
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1D3620866
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554062768;
	bh=I3HUyuHMv+D+/kjAhwQaXM3lrs+hw5AnhkLy70wfJUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=beZ/V3n01HYJEBRdUWXB2Y4+zAod8pzl2iKusQifJ3YieadE/JAjVT5OixtA0beSj
	 LDOnQxXkf7kt0zoxEmhtwSQ8KhGeysvwV75A05mB9YiLmWuZt96grZZcSjVK8hhrP9
	 J/aU/8+G8AV6majbH4aRrXQJI5bHEuUHRYk026c4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731353AbfCaUGG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 Mar 2019 16:06:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731432AbfCaUF6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Mar 2019 16:05:58 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FD0320882;
        Sun, 31 Mar 2019 20:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554062757;
        bh=I3HUyuHMv+D+/kjAhwQaXM3lrs+hw5AnhkLy70wfJUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mIhKMqqY/ssjUpZ80rsahTRPUszzt6xXIk1hbIVDPwiiLLB6jNABq6mPEHtr+CPmW
         G/1DAs3jXPt2Bn7xetHDPfLFn/r2Q9yQ5BxzG3PL24719S0ZtPcCmQEW2gQB+vLSN2
         cwkzBAzu+yf6Baq87pcQx/xEiFDVENfM70kgUynk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org, Martin Willi <martin@strongswan.org>
Subject: [RFC/RFT PATCH 06/18] crypto: chacha20poly1305 - set cra_name correctly
Date:   Sun, 31 Mar 2019 13:04:16 -0700
Message-Id: <20190331200428.26597-7-ebiggers@kernel.org>
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

If the rfc7539 template is instantiated with specific implementations,
e.g. "rfc7539(chacha20-generic,poly1305-generic)" rather than
"rfc7539(chacha20,poly1305)", then the implementation names end up
included in the instance's cra_name.  This is incorrect because it then
prevents all users from allocating "rfc7539(chacha20,poly1305)", if the
highest priority implementations of chacha20 and poly1305 were selected.
Also, the self-tests aren't run on an instance allocated in this way.

Fix it by setting the instance's cra_name from the underlying
algorithms' actual cra_names, rather than from the requested names.
This matches what other templates do.

Fixes: 71ebc4d1b27d ("crypto: chacha20poly1305 - Add a ChaCha20-Poly1305 AEAD construction, RFC7539")
Cc: <stable@vger.kernel.org> # v4.2+
Cc: Martin Willi <martin@strongswan.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/chacha20poly1305.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index ed2e12e26dd80..279d816ab51dd 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -645,8 +645,8 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
-		     "%s(%s,%s)", name, chacha_name,
-		     poly_name) >= CRYPTO_MAX_ALG_NAME)
+		     "%s(%s,%s)", name, chacha->base.cra_name,
+		     poly->cra_name) >= CRYPTO_MAX_ALG_NAME)
 		goto out_drop_chacha;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "%s(%s,%s)", name, chacha->base.cra_driver_name,
-- 
2.21.0

