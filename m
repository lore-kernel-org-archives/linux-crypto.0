Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF907C25B0E
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 14:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235885AbiHPODm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 10:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235852AbiHPOD0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 10:03:26 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD2E2ED7A
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:21 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id x10so10628290ljq.4
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=bNKl0WqaDu3QbRj292AtPq5phFFaJ1mJK+ISPGQQtjg=;
        b=NWxN02FM48jW+daL9f2AZliag0Jn6d1w+rXbGPDPXcwvM1cXkH7dVdqPiMHQ8Og/tm
         EFX9SBKfPv3OhSvG9gBy3a+VfSbZeorLUX7I3n5ToARHj56DWJ3lhBNqAEwqT7XJgKyF
         Rvxy51yWlTBMB3R9Ey+nqKGqzof/01x+iXss8pGkIG0UdHgVE7V0eh4zMo1HMEVQoEVD
         YB2fyOx22dbPK2eCTEqZB1iD9NO2R3K5ptkwDw1PqEONYPlXR/6uLghYfoAmiiZX09BS
         OwEDEmB2FXQT/wSFlCOPXTHQEfjzICZJWyyRmOzH6pkExWnXBJoXgMNAQF18nXu13UPL
         lP8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=bNKl0WqaDu3QbRj292AtPq5phFFaJ1mJK+ISPGQQtjg=;
        b=3A0cVBHQWdpbjqwL21HM0ZbO73u8Rryy+Hzs+ga3ybnybfKNBSmM3QnWFwwSEwbofe
         1Mep7+0Js4OhnN/FzBOf2t4SZbeMOWY9WWvKWvpiB/gUAmzAAFlSa6ql2HtGDnlYFqgC
         0cgwaf4ezpY2YpAuMZevxYbuxLZdkRDArgVaQ+FPHFkUx23W9l9ZP8scEnL74B6LsJWK
         3Fkakw3Ugao3RvbjUcIqce9oLxGnFRqVW3vLKOOHqcFp/ih3PIzg1tVTn6nODp4Wm856
         fzWO7JzY7tyS/LMQ9kDH31DaYa+qrUqSZ7pv6QdwJ9E+9s/iPQRK6xuFkORaPP8QGQju
         Hu6g==
X-Gm-Message-State: ACgBeo3FknCt0cRa68LQrV7ikApT5IVRbzmwceORLcuvmx5qoIZuS9jK
        h9eWHgXUMf96z4a4LBIWd1ZGsb5fPqxVIA==
X-Google-Smtp-Source: AA6agR7XT4TMfhW9QRr8BZRSDjpQjQZXMR5qB9I0CYLSIsxKaSQUwPV7DIP9leLWIiEZRHNulNlixw==
X-Received: by 2002:a2e:a236:0:b0:260:8ac:9182 with SMTP id i22-20020a2ea236000000b0026008ac9182mr6429203ljm.71.1660658599337;
        Tue, 16 Aug 2022 07:03:19 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r27-20020a2eb61b000000b0025e739cd9a7sm1747902ljn.101.2022.08.16.07.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 07:03:18 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 06/16] crypto: ux500/hash: Break while/do instead of if/else
Date:   Tue, 16 Aug 2022 16:00:39 +0200
Message-Id: <20220816140049.102306-7-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220816140049.102306-1-linus.walleij@linaro.org>
References: <20220816140049.102306-1-linus.walleij@linaro.org>
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
ChangeLog v2->v3:
- Rebased on v6.0-rc1
ChangeLog v1->v2:
- No changes
---
 drivers/crypto/ux500/hash/hash_core.c | 115 +++++++++++++-------------
 1 file changed, 58 insertions(+), 57 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 65d328d438d2..b559c53dc703 100644
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
2.37.2

