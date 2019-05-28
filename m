Return-Path: <SRS0=c5Ty=T4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_MED,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD870C072B1
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 12:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6D7420883
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 12:42:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UKtCdcbp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbfE1Mmo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 May 2019 08:42:44 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:46421 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbfE1Mmo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 May 2019 08:42:44 -0400
Received: by mail-qk1-f202.google.com with SMTP id 18so17593047qkl.13
        for <linux-crypto@vger.kernel.org>; Tue, 28 May 2019 05:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ucsJU2RQj5Jr+B5f+dPr47NtIreJR1DFJaQ5vCUwD8U=;
        b=UKtCdcbpzS06owZhQOx3kelGMFAA43Dv8TGAW1GJJBg2Qw2pibkdYVtufrqXn0GzV/
         jD8tBphl8MIuhIr91GDdtnY6OQ/H9p0Ojt2FrTUPCsARHBa1+ouRuSz2CXxTjazydbI7
         kZbZ5TAvfKX/6/YKjNV8v33g/3DnHzrqVjuRmNBSF8Jcj+h4qLxwyyHdkNg14KpFUMC2
         SnbkTixSImnlboEzEfJtw6/rWFvvXVUL3D/CSMMigfmZ3n6vjESMc4Lxi4ea5T2Eyfgp
         n59g38UdoLV5CknSgXHwL8Ccpn/C4yNj/BVWWuuxM0u313sXalM7es0c9VGoyL4c3Int
         xPfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ucsJU2RQj5Jr+B5f+dPr47NtIreJR1DFJaQ5vCUwD8U=;
        b=h9I5PsIc5hTEvizMAu0qFVbPRHhWKTb90TWzt1hzwmt/YQRoKJBNm0rcCHIvPiU4jh
         NsgVIDSJrMdVK7ufkJmn00Q7HxUSro6+uyiZPslSz2XejL7sNYV2TuPUwCdb84fWPHdE
         rA+ILWV8AyR+2g9U8zYpa7wrOSJ9zZheUGmswOEatNeW6urqe22ajCulp67VTVJDtYSp
         g2c/B3oCrszPjo5eqOqZrD3GftkkJ573H87lDi9Ic263AgSt33B98X+ZtF9S8NQfDgbf
         jYIY09Pw1EB8lRfTrzv8N2Zomnndv4hIk0U1j9p+Nj6e6M1hcDSDv1k5yBzc8JbFrCC4
         ni1Q==
X-Gm-Message-State: APjAAAXV7fwkn+jF7k5GDIaeNpm5OBYDUZkTRdbQAI8v/3DbVTbjl5ZR
        QSBV8/27n9saJzX+UbeRUPlA06FBnDOk15eD5m2o3IWDm5wYQ2JkDVBNI24Fv6LSYgqHm1w6ou7
        xdmX2LvEiNI55W2Y200tdLLikT3kYnzCGjNFzwq+ZjCUp1PBmJJOdoLk0liDHtxMzdLKfbNH5
X-Google-Smtp-Source: APXvYqw8TpnhllV+/ul++qIitFY8+oWUgnh3WBiNMci8pLjrHtEiS5OzQJWwiDLUSx8OHT2SVZwJV1hNmnGP
X-Received: by 2002:a37:9481:: with SMTP id w123mr90890881qkd.319.1559047363388;
 Tue, 28 May 2019 05:42:43 -0700 (PDT)
Date:   Tue, 28 May 2019 13:41:52 +0100
Message-Id: <20190528124152.191773-1-lenaptr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH] arm64 sha1-ce finup: correct digest for empty data
From:   Elena Petrova <lenaptr@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     Elena Petrova <lenaptr@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The sha1-ce finup implementation for ARM64 produces wrong digest
for empty input (len=0). Expected: da39a3ee..., result: 67452301...
(initial value of SHA internal state). The error is in sha1_ce_finup:
for empty data `finalize` will be 1, so the code is relying on
sha1_ce_transform to make the final round. However, in
sha1_base_do_update, the block function will not be called when
len == 0.

Fix it by setting finalize to 0 if data is empty.

Fixes: 07eb54d306f4 ("crypto: arm64/sha1-ce - move SHA-1 ARMv8 implementation to base layer")
Cc: stable@vger.kernel.org
Signed-off-by: Elena Petrova <lenaptr@google.com>
---
 arch/arm64/crypto/sha1-ce-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
index eaa7a8258f1c..0652f5f07ed1 100644
--- a/arch/arm64/crypto/sha1-ce-glue.c
+++ b/arch/arm64/crypto/sha1-ce-glue.c
@@ -55,7 +55,7 @@ static int sha1_ce_finup(struct shash_desc *desc, const u8 *data,
 			 unsigned int len, u8 *out)
 {
 	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
-	bool finalize = !sctx->sst.count && !(len % SHA1_BLOCK_SIZE);
+	bool finalize = !sctx->sst.count && !(len % SHA1_BLOCK_SIZE) && len;
 
 	if (!crypto_simd_usable())
 		return crypto_sha1_finup(desc, data, len, out);
-- 
2.22.0.rc1.257.g3120a18244-goog

