Return-Path: <SRS0=RX8q=B4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57256C433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 08:06:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C1E320786
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 08:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHRIGJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Aug 2020 04:06:09 -0400
Received: from smtp23.cstnet.cn ([159.226.251.23]:60258 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726203AbgHRIGI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Aug 2020 04:06:08 -0400
Received: from localhost (unknown [159.226.5.99])
        by APP-03 (Coremail) with SMTP id rQCowABXXxviiztfqBYkAw--.19991S2;
        Tue, 18 Aug 2020 16:05:54 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>
Subject: [PATCH] Remove unneeded variable t1
Date:   Tue, 18 Aug 2020 08:05:53 +0000
Message-Id: <20200818080553.12064-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: rQCowABXXxviiztfqBYkAw--.19991S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKrWkKrWkAF4rGFy7ArW8WFg_yoWDGFg_Aa
        yrWFn7WFn5A39Yvw45Xan8XasF9as2vrZ7GF10vFWUXayrAr4rWF92kF93A3yruw42qry7
        W39xKr47GrsFvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbfAYjsxI4VWDJwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26rWY6Fy7McIj6I8E87Iv67AKxVWxJr0_Gc
        WlOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0Y40E4IxF1VCIxcxG6Fyj
        6r4UJwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r43MxAIw28IcxkI7VAKI4
        8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
        wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjx
        v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20E
        Y4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
        0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IUUT7K5UUUUU==
X-Originating-IP: [159.226.5.99]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCQUMA102Zgh+7AAAsU
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove unneeded variable t1 seed_encrypt() and
seed_decrypt().

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 crypto/seed.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/seed.c b/crypto/seed.c
index 5e3bef3a617d..69b3058d6a32 100644
--- a/crypto/seed.c
+++ b/crypto/seed.c
@@ -366,7 +366,7 @@ static void seed_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	const struct seed_ctx *ctx = crypto_tfm_ctx(tfm);
 	const __be32 *src = (const __be32 *)in;
 	__be32 *dst = (__be32 *)out;
-	u32 x1, x2, x3, x4, t0, t1;
+	u32 x1, x2, x3, x4, t0;
 	const u32 *ks = ctx->keysched;
 
 	x1 = be32_to_cpu(src[0]);
@@ -404,7 +404,7 @@ static void seed_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	const struct seed_ctx *ctx = crypto_tfm_ctx(tfm);
 	const __be32 *src = (const __be32 *)in;
 	__be32 *dst = (__be32 *)out;
-	u32 x1, x2, x3, x4, t0, t1;
+	u32 x1, x2, x3, x4, t0;
 	const u32 *ks = ctx->keysched;
 
 	x1 = be32_to_cpu(src[0]);
-- 
2.17.1

