Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69EABCCA473
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 14:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235190AbiGYOHb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 10:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235261AbiGYOH2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 10:07:28 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B0814D3A
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:26 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id r14so13248040ljp.2
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZWLYEfxygMjqNcWPZGRXzAM2CEyKrpm8S5gQVU/gLlY=;
        b=ZIJv2oWwotCmwAqMhW3UumXcWXz5Gf2FFNn99IZMcNXGKMEENS8ISwkLKbHtw+NNsU
         UxZvvFl5Cbow9Pg19p5jKwZP8QGQ01+v7yYbWDP2nwxfjOH9XqtJrfwUwGflH2IoAAGW
         hNMG7gvXa5V4OIiAL7jlIkpx58oCFV4rNcFXAgO4ZmZeDqfl+YcBfbdaAHUXZ6mJRo6i
         miAiz1LCG+y85CgLUgtTIbEaDXLAupMBoaV5Vv4Q9zR4jn9kJjKiEzafa4gqQJydMCfB
         kLTnqZLJEYfO427Pyy+AIZczkk5MRyPPDc/uK88AgFpuDZXxpRxthihwORbDwiP3JrKG
         nBHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZWLYEfxygMjqNcWPZGRXzAM2CEyKrpm8S5gQVU/gLlY=;
        b=yPw4Er15ORoREP53Kj2vMA7VPyu1AP1j2e1Rn3VZTmlnkM0mlErGQC6W4OyjWZ+gTD
         FBjbbaqq3v2bebkfzbt3adQSPmVLe77zY+O/tPcxXqujXtGNBVUizljkw2PwVkjLj7TO
         J2w+aacyuFuw5h98cCR0ZpPJsm9e7/+0H+OeWmndYhiMNnQJC918iOBO8vcHoJYAx575
         vHFHTgQ0djk1K0xraBjKfa35SFSjJL7Lk06+FW92wV/hekJFYiYJDC5qLpiVCeJ3Kvdf
         GV2A0IdnZUGubhyLKqEcRK6ehG0HazSX2EX0NWsu0CDtsnmTtC1cVAivQZYST23FRNQu
         NEPg==
X-Gm-Message-State: AJIora8lVGgYh52n4K8uuwoV5TrGRcF30IYvny9zAL3aIOnpW4rSVwaY
        Nq0eWGBbwJ5O0rHzjh84cRJSmoJnPOQ4kw==
X-Google-Smtp-Source: AGRyM1tQhbDtPEcMYb6kyTXB8hWFpZ0eFYmkrvzPyDeuZ0/r51E7PrQz0wwVQLzZYZnpNvpoDLq94Q==
X-Received: by 2002:a2e:8ec7:0:b0:25e:92f:c330 with SMTP id e7-20020a2e8ec7000000b0025e092fc330mr1496341ljl.56.1658758044351;
        Mon, 25 Jul 2022 07:07:24 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o7-20020a05651205c700b0047f7419de4asm901127lfo.180.2022.07.25.07.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 07:07:23 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 03/15 v2] crypto: ux500/hash: Pass context to zero message digest
Date:   Mon, 25 Jul 2022 16:04:52 +0200
Message-Id: <20220725140504.2398965-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220725140504.2398965-1-linus.walleij@linaro.org>
References: <20220725140504.2398965-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This function obtains the current context from the device state
pointer, which is fragile. Pass the context explicitly instead.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- No changes
---
 drivers/crypto/ux500/hash/hash_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index fd7a862244ac..884046e87262 100644
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
2.36.1

