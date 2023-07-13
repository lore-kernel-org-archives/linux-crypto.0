Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD4AEB64DD
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jul 2023 08:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbjGMI7V (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Jul 2023 04:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbjGMI7U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jul 2023 04:59:20 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE69D12E
        for <linux-crypto@vger.kernel.org>; Thu, 13 Jul 2023 01:59:18 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R1pSh1R1JzBRRLl
        for <linux-crypto@vger.kernel.org>; Thu, 13 Jul 2023 16:59:16 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689238756; x=1691830757; bh=DM6p6Pwx/AqL6NEMfpivdDxc+8P
        TOaK9hs3yovJiDmY=; b=M92cRi6UJV1brNSVIXEaYUhmT/aL3Qfb6jED6mZnqhb
        OAff45ooadK29fiAMX3p2/oubm2SnyJPZAasR0+x1wzXkrXLO1MtyaTttbtLfYGn
        uy93/kuTxFgxnzteRus/YzX/xf+bSn4Z0hcvJxoY/ICDzlFCO88kvPUEwjJq9FHP
        TTi1keUtBHHLWJd82tR//WexY0xr7vnR3wELL2/qKPnYlMSyP4wmBQ+dN0y7aqHw
        26ziL70aolI5mk7C42I23B9dp+cuvISpeZL3U4mgsnaSWx7Xmu0uDKFCEyMZ0Mcb
        3FmY/h96V2fjT+hYarzKVve30X+p+QpLEmmS2ycjwTQ==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 8L_x7UKqCu95 for <linux-crypto@vger.kernel.org>;
        Thu, 13 Jul 2023 16:59:16 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R1pSg5pQZzBJTFd;
        Thu, 13 Jul 2023 16:59:15 +0800 (CST)
MIME-Version: 1.0
Date:   Thu, 13 Jul 2023 16:59:15 +0800
From:   chenqingyun001@208suo.com
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        catalin.marinas@arm.com, will@kernel.org
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto:space required before the open brace '{'
In-Reply-To: <tencent_0DF4FE9D6A06DCE7069F936CA2A8154EC105@qq.com>
References: <tencent_0DF4FE9D6A06DCE7069F936CA2A8154EC105@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <e6744137bd60578811fa763b39f50cf0@208suo.com>
X-Sender: chenqingyun001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Maintain code readability and style consistency

Signed-off-by: Qingyun Chen <chenqingyun001@208suo.com>
---
  arch/arm64/crypto/ghash-ce-glue.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/ghash-ce-glue.c 
b/arch/arm64/crypto/ghash-ce-glue.c
index 97331b454ea8..cb1cd161c022 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -241,7 +241,7 @@ static int gcm_aes_setkey(struct crypto_aead *tfm, 
const u8 *inkey,
      if (ret)
          return -EINVAL;

-    aes_encrypt(&ctx->aes_key, key, (u8[AES_BLOCK_SIZE]){});
+    aes_encrypt(&ctx->aes_key, key, (u8[AES_BLOCK_SIZE]) {});

      /* needed for the fallback */
      memcpy(&ctx->ghash_key.k, key, GHASH_BLOCK_SIZE);
