Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 124CDC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 13:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiGUNoy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 09:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiGUNnn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 09:43:43 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F21D84EDF
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:06 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id e11so1876418ljl.4
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m7UqmZ0Jv14B5vRscyamwS43czlrxOV9Csm1EJ3FYWU=;
        b=C66TCTDJ7sKyxBua7YeGhp0UufcNjmOLPVT+lKUSM3PfJVXUtTSyz0z9fFTx6a0DMc
         6E7A5v7nDyMulMGb82MwytsLJ3sjTbkz+pj8gAszy7aL6fd5FcXjKxsQ7PHiIireySfA
         9uDpe5hENNACo3v4ynkAnKMKN0C+s7CbAKJS/+VFUr/nkBi4wMf+4fQzEAnPdKcaejH2
         vEIhqDC68m4fcZ30CiZtFOClyLyppFcKapIyNnkl8jY/i72Ct/jzXUITY21TWfRnbsoJ
         X2pV5iONDWXYY0uJHPSZ6KYu1OyBltt8KOGAoj8nWtFC4Qli3v62CSWQo1IDlU8Uazsv
         Bcqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m7UqmZ0Jv14B5vRscyamwS43czlrxOV9Csm1EJ3FYWU=;
        b=6O7QbFAs0kkm3C1leUlVkIsIQdu2mA78CvoeHeQ52coBuOr5ywBeD9mEw/ia03KfsU
         GzK+D6O8mfpamGK8elxXUDjFH4DF/Ygfs8QRPeC/lHNUGPgUEz7HbZTsq0DxOUK3S5l1
         1ZA4lNOzGSeCJ02NZJu/pm/9V/FIXGxU+bpQirVJdMuF/cTkTW0LMmcZkXv1Qdkw5GJO
         cZlIuKf0qMwRs6uMzBK21+1K9YV1Yc0WnkbI4UQnqKmbn+Vnn1lvevlRPo8LPnN6EmaZ
         teUAX8iwGjVk1s+Y4Q25Ioj2+yiWbyX45iel+XhfZ5T/rROrSWWmN6q8Gq+dBq+Vg6Vp
         o/Qw==
X-Gm-Message-State: AJIora/nLOROd33X9H1XQa/FG7ptEAcqjWSUlq6JrL0X6fWj2ca0avqK
        +7rhDqqbY67H6hkiyuIZJrbYgveFch5OZg==
X-Google-Smtp-Source: AGRyM1v5HtaWUCdRjprp+311OVnYsxtYnVkgdBxadGqmDdj6hWN0pPmoSSmDorNJUwM3k8uLiu9WiA==
X-Received: by 2002:a2e:a608:0:b0:25d:5363:35a4 with SMTP id v8-20020a2ea608000000b0025d536335a4mr19906611ljp.132.1658410984484;
        Thu, 21 Jul 2022 06:43:04 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o23-20020ac24e97000000b004867a427026sm458568lfr.40.2022.07.21.06.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:43:04 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 06/15] crypto: ux500/hash: Break while/do instead of if/else
Date:   Thu, 21 Jul 2022 15:40:41 +0200
Message-Id: <20220721134050.1047866-7-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721134050.1047866-1-linus.walleij@linaro.org>
References: <20220721134050.1047866-1-linus.walleij@linaro.org>
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

