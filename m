Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6884CCA473
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 14:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbiGYOHd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 10:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235222AbiGYOHb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 10:07:31 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83157167C9
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:30 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id z13so12858048ljj.6
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XhDve6JLJ3Kju6H4o7eHpk5rJCSDlgoSXIzWMLgqIdY=;
        b=BrQmM4z6wseWqWYrUpGMUcwzzFz459jFZoxL8QfLFrHozJDEqLZxKcA2crq9qmCSHi
         1PrXTJu9w3s7nvBMGm4t7tJOaE0t3l0djy9NZAMnslMJXdCwtjgeeg7i8FB3emO6965t
         bi36OxcGi4JodTJMNsyen0iGY289Wh51BNkZ9qDOHEyBA/LuUvla/LTeQ1cyQp5Ci8h5
         I/BluA8Z+vWhILMH6p2s+DW+M29YFuE/bMoJv0lEdCHxEAe7JzpydrXMsMsrS03DMm7l
         ixiMIfs7pjPm/YWiruw8JIF9eyFW9ePtoFJd6ro8fH0if0dciGmWcz3/1pGwFAb+kOjC
         es5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XhDve6JLJ3Kju6H4o7eHpk5rJCSDlgoSXIzWMLgqIdY=;
        b=EBI/WwuSqKthOGiaAvvK1utkipQd+ZWgQbXGydmbsBqqy70N8YYxciJFOOpv9+oijc
         3/R6kMR1EOhkNfnNc4NaqBkrNEImpPsBABGB+8gG8LKxwkT8pT4H6WNgkkc2+4Ki3p5L
         y5JyXoS9HYBoL6Q+sFJkH0LGDm5bFsDdoeXyC3DS8xVMRQa5sv5MkiWcS1POETackEv9
         0fy+hcmzSe3qgcYDH3M1i9I0C5Gfm2o/+UtJHsXmSASDzbsNfRJvYDTff8CkIpSv8zQM
         PxQQadypJRKFC72lx117AkqsHN1H80tKoaTj3Tqq1jjH7lMoxV81TbXwHhW54LIxFe+v
         D3mA==
X-Gm-Message-State: AJIora/zuGw3yTT0126C6FRlyafQDM3ljnlKFLfR8oIPdjZ5BcL9sdWA
        sL3waVZkb3PFhEEtz1lwFakZ8popd1dF+Q==
X-Google-Smtp-Source: AGRyM1vHMG4ei9iEs7o1abwOd/CPQsfJvXKmO7hj4znQHZHTukk3pyN/f7P0bAWe7I49adkyagEO0w==
X-Received: by 2002:a05:651c:160a:b0:25a:62a4:9085 with SMTP id f10-20020a05651c160a00b0025a62a49085mr4575036ljq.214.1658758048757;
        Mon, 25 Jul 2022 07:07:28 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o7-20020a05651205c700b0047f7419de4asm901127lfo.180.2022.07.25.07.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 07:07:28 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 06/15 v2] crypto: ux500/hash: Break while/do instead of if/else
Date:   Mon, 25 Jul 2022 16:04:55 +0200
Message-Id: <20220725140504.2398965-7-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220725140504.2398965-1-linus.walleij@linaro.org>
References: <20220725140504.2398965-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of a deeply nested if/else inside the while/do loop,
just break the loop as we know the termination requirement
was just established (msg_length == 0).

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- No changes
---
 drivers/crypto/ux500/hash/hash_core.c | 115 +++++++++++++-------------
 1 file changed, 58 insertions(+), 57 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index e9962c8a29bd..c9ceaa0b1778 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -671,69 +671,70 @@ static int hash_process_data(struct hash_device_data *device_data,
 			}
 			*index += msg_length;
 			msg_length = 0;
-		} else {
-			if (req_ctx->updated) {
-				ret = hash_resume_state(device_data,
-						&device_data->state);
-				memmove(req_ctx->state.buffer,
-					device_data->state.buffer,
-					HASH_BLOCK_SIZE);
-				if (ret) {
-					dev_err(device_data->dev,
-						"%s: hash_resume_state() failed!\n",
-						__func__);
-					goto out;
-				}
-			} else {
-				ret = init_hash_hw(device_data, ctx);
-				if (ret) {
-					dev_err(device_data->dev,
-						"%s: init_hash_hw() failed!\n",
-						__func__);
-					goto out;
-				}
-				req_ctx->updated = 1;
-			}
-			/*
-			 * If 'data_buffer' is four byte aligned and
-			 * local buffer does not have any data, we can
-			 * write data directly from 'data_buffer' to
-			 * HW peripheral, otherwise we first copy data
-			 * to a local buffer
-			 */
-			if (IS_ALIGNED((unsigned long)data_buffer, 4) &&
-			    (0 == *index))
-				hash_processblock(device_data,
-						  (const u32 *)data_buffer,
-						  HASH_BLOCK_SIZE);
-			else {
-				for (count = 0;
-				     count < (u32)(HASH_BLOCK_SIZE - *index);
-				     count++) {
-					buffer[*index + count] =
-						*(data_buffer + count);
-				}
-				hash_processblock(device_data,
-						  (const u32 *)buffer,
-						  HASH_BLOCK_SIZE);
-			}
-			hash_incrementlength(req_ctx, HASH_BLOCK_SIZE);
-			data_buffer += (HASH_BLOCK_SIZE - *index);
-
-			msg_length -= (HASH_BLOCK_SIZE - *index);
-			*index = 0;
-
-			ret = hash_save_state(device_data,
-					&device_data->state);
+			break;
+		}
 
-			memmove(device_data->state.buffer,
-				req_ctx->state.buffer,
+		if (req_ctx->updated) {
+			ret = hash_resume_state(device_data,
+						&device_data->state);
+			memmove(req_ctx->state.buffer,
+				device_data->state.buffer,
 				HASH_BLOCK_SIZE);
 			if (ret) {
-				dev_err(device_data->dev, "%s: hash_save_state() failed!\n",
+				dev_err(device_data->dev,
+					"%s: hash_resume_state() failed!\n",
 					__func__);
 				goto out;
 			}
+		} else {
+			ret = init_hash_hw(device_data, ctx);
+			if (ret) {
+				dev_err(device_data->dev,
+					"%s: init_hash_hw() failed!\n",
+					__func__);
+				goto out;
+			}
+			req_ctx->updated = 1;
+		}
+		/*
+		 * If 'data_buffer' is four byte aligned and
+		 * local buffer does not have any data, we can
+		 * write data directly from 'data_buffer' to
+		 * HW peripheral, otherwise we first copy data
+		 * to a local buffer
+		 */
+		if (IS_ALIGNED((unsigned long)data_buffer, 4) &&
+		    (*index == 0))
+			hash_processblock(device_data,
+					  (const u32 *)data_buffer,
+					  HASH_BLOCK_SIZE);
+		else {
+			for (count = 0;
+			     count < (u32)(HASH_BLOCK_SIZE - *index);
+			     count++) {
+				buffer[*index + count] =
+					*(data_buffer + count);
+			}
+			hash_processblock(device_data,
+					  (const u32 *)buffer,
+					  HASH_BLOCK_SIZE);
+		}
+		hash_incrementlength(req_ctx, HASH_BLOCK_SIZE);
+		data_buffer += (HASH_BLOCK_SIZE - *index);
+
+		msg_length -= (HASH_BLOCK_SIZE - *index);
+		*index = 0;
+
+		ret = hash_save_state(device_data,
+				      &device_data->state);
+
+		memmove(device_data->state.buffer,
+			req_ctx->state.buffer,
+			HASH_BLOCK_SIZE);
+		if (ret) {
+			dev_err(device_data->dev, "%s: hash_save_state() failed!\n",
+				__func__);
+			goto out;
 		}
 	} while (msg_length != 0);
 out:
-- 
2.36.1

