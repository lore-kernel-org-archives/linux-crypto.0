Return-Path: <SRS0=PdDN=R6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D52C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Mar 2019 18:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D199205C9
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Mar 2019 18:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553712244;
	bh=kvkCwcHxhjJCvdDnaatwvmnKYzQOI7wCcLz8mpqrU+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=boxqIdgRqMLIY/4P2B8J+UiUUXt36F04XrV0+A9m3Ky8Rn1MBz6TtsA3ImVCRtsSg
	 GvtKXKaMkuimIaJVYUIvf2yB1fso0iJfZJkOLWtfWy9cTtDERU+k9LS6KvqMWl3cW9
	 9ze7BPzN2FNz2WusDsZl+kKGEuOKxXDF355qeDXE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390855AbfC0SV1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:21:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391159AbfC0SVY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Mar 2019 14:21:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A76D20651;
        Wed, 27 Mar 2019 18:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710883;
        bh=kvkCwcHxhjJCvdDnaatwvmnKYzQOI7wCcLz8mpqrU+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VHH1qpO7H6GY9XoKrQRy3MXEPTvaoIf9lqTQ/y0fsJJtD9qwGpPHLDjaEIggw5AhI
         at7rCULtFYdRXy8l435jImqejpJTZseU+5MNVukfDj1VjcAEtZ1jgrij/mDYBngmNJ
         uQ/bG+2BxXzdMvHtOj8L1dfLEY8kdN6ljuZx/s+E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julia Lawall <Julia.Lawall@lip6.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 25/87] crypto: crypto4xx - add missing of_node_put after of_device_is_available
Date:   Wed, 27 Mar 2019 14:19:38 -0400
Message-Id: <20190327182040.17444-25-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327182040.17444-1-sashal@kernel.org>
References: <20190327182040.17444-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

[ Upstream commit 8c2b43d2d85b48a97d2f8279278a4aac5b45f925 ]

Add an of_node_put when a tested device node is not available.

The semantic patch that fixes this problem is as follows
(http://coccinelle.lip6.fr):

// <smpl>
@@
identifier f;
local idexpression e;
expression x;
@@

e = f(...);
... when != of_node_put(e)
    when != x = e
    when != e = x
    when any
if (<+...of_device_is_available(e)...+>) {
  ... when != of_node_put(e)
(
  return e;
|
+ of_node_put(e);
  return ...;
)
}
// </smpl>

Fixes: 5343e674f32fb ("crypto4xx: integrate ppc4xx-rng into crypto4xx")
Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/amcc/crypto4xx_trng.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/amcc/crypto4xx_trng.c b/drivers/crypto/amcc/crypto4xx_trng.c
index 677ca17fd223..368c5599515e 100644
--- a/drivers/crypto/amcc/crypto4xx_trng.c
+++ b/drivers/crypto/amcc/crypto4xx_trng.c
@@ -80,8 +80,10 @@ void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev)
 
 	/* Find the TRNG device node and map it */
 	trng = of_find_matching_node(NULL, ppc4xx_trng_match);
-	if (!trng || !of_device_is_available(trng))
+	if (!trng || !of_device_is_available(trng)) {
+		of_node_put(trng);
 		return;
+	}
 
 	dev->trng_base = of_iomap(trng, 0);
 	of_node_put(trng);
-- 
2.19.1

