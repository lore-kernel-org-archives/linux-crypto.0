Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BDFFC3F6B0
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 14:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235744AbiHPOD2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 10:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbiHPODW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 10:03:22 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3742A3ECDF
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:17 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id z25so15067561lfr.2
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=nAlowoVFY0LcXDiOUlU807XVFbbZNi0DFVp+JS034i0=;
        b=ykNHTA7elg26WsKl+wkQtE1lPFJbx0ZIxDFD/Vn+L0LWG3K0P5rECp0f4ZmSrLWazp
         /2id6tjVZVx8zv2SOJpZ3vc3+kMlHdWvEvtEWv/CMcGttuiL+FXR9mpwJyOO+glP5D2p
         /Ngv8LzramGa6QdcDkC/uG69MCjw6bmtcPOl+4azMQlhD8foywMrNilYTklXEnx6te0/
         OzdHVpm2UkPo7IrMBY4hq5MC7xS0SJqz+77BaQpSNMnD0oJJ2c5ElyUYZxVRP0aZ3Y85
         ldzC4cS1OTAlXUnJc6OjyzfKHuxtZuWuPFpnJXAu0PBOloG1ELjHpG0kkfdSIlQtVnXp
         ihnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=nAlowoVFY0LcXDiOUlU807XVFbbZNi0DFVp+JS034i0=;
        b=G1GWq455F6DL5+OlL/aTdXR7v+C9hTq4u5C5swLThm/rhRS54YPvyVnW8c0RAQoQoO
         kYzlnDdXUzPYpeRG11xwjyGh10IPTGmj+nNCFSq6i1ORDAFfPH5HnWaJvOy1dIWbXQxW
         d4BSHxSdTkvf9QQLN+7/gMHgNa1pifLhQi4s/BdxuFfdHHokINxiWxQm6TpPJ+IohSrW
         c0pF5mLnz16lvbssTfIhAZtb99uE7UdPJRFIIvWu7IdzoUUJ8PkLs0gdZTEL7DsY7Upz
         hu6Cp+xW2eP3raLvTJ5GSo0U1juG6Rt/mS8shklW0xntcpPPtW0sNdMTqVAEd8D13Law
         96KA==
X-Gm-Message-State: ACgBeo2B7h/+bNF+CZ9QQL2TTlMfrrc0gK/6XLSMd01U+P23Y5DU9DwX
        2MKM5gLVlZO6FGoLOH/sRCiIh1SDHyuJhg==
X-Google-Smtp-Source: AA6agR7KwaC5Otr26WZl/PeY9RCVB23kXI3MI1GQ3pp8ux4dKz9wK/PPQSp3+5IoThcFatUi/L2JpA==
X-Received: by 2002:a05:6512:230a:b0:48c:2e06:6c74 with SMTP id o10-20020a056512230a00b0048c2e066c74mr7497057lfu.358.1660658595434;
        Tue, 16 Aug 2022 07:03:15 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r27-20020a2eb61b000000b0025e739cd9a7sm1747902ljn.101.2022.08.16.07.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 07:03:15 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 03/16] crypto: ux500/hash: Pass context to zero message digest
Date:   Tue, 16 Aug 2022 16:00:36 +0200
Message-Id: <20220816140049.102306-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220816140049.102306-1-linus.walleij@linaro.org>
References: <20220816140049.102306-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This function obtains the current context from the device state
pointer, which is fragile. Pass the context explicitly instead.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Rebased on v6.0-rc1
ChangeLog v1->v2:
- No changes
---
 drivers/crypto/ux500/hash/hash_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 5c2da6d42121..aa6bbae107cd 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -183,11 +183,10 @@ static int hash_dma_write(struct hash_ctx *ctx,
  * @zero_digest:	True if zero_digest returned.
  */
 static int get_empty_message_digest(
-		struct hash_device_data *device_data,
+		struct hash_device_data *device_data, struct hash_ctx *ctx,
 		u8 *zero_hash, u32 *zero_hash_size, bool *zero_digest)
 {
 	int ret = 0;
-	struct hash_ctx *ctx = device_data->current_ctx;
 	*zero_digest = false;
 
 	/**
@@ -889,7 +888,7 @@ static int hash_hw_final(struct ahash_request *req)
 		 * Use a pre-calculated empty message digest
 		 * (workaround since hw return zeroes, hw bug!?)
 		 */
-		ret = get_empty_message_digest(device_data, &zero_hash[0],
+		ret = get_empty_message_digest(device_data, ctx, &zero_hash[0],
 				&zero_hash_size, &zero_digest);
 		if (!ret && likely(zero_hash_size == ctx->digestsize) &&
 		    zero_digest) {
-- 
2.37.2

