Return-Path: <SRS0=me0G=UN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE83C31E4B
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 09:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A3492084E
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 09:42:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zBXs+2W3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfFNJm5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jun 2019 05:42:57 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35871 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfFNJm5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jun 2019 05:42:57 -0400
Received: by mail-wr1-f65.google.com with SMTP id n4so1820997wrs.3
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jun 2019 02:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1tGskau943T386kyJZ4GTkvXE83xs6wkbIyb/EV2Rpk=;
        b=zBXs+2W3UpOSNa9yIXR5X5C5PcdW90YRk8Xk9269IPzzdpM8TE+9iwWo5jDl1c7kci
         AZaep9/v4N4zUEnNrGWNN37lVGPWtPR7EOK1ZfxjgUh+zPidqS8LivsyBx3wVdxFEemt
         VjvWkfqx9Myp9n1FlZXxOxIfqMAgf6hvM8dVACwchgf+CkuBRLIiI07KVj922iYSNCo6
         QB0vpfWtjDnEETJk2AcQ2S8hXnhjVTVrnZL5N84OJFZLr69PQB6aGLDmmLjtKRPw+ErB
         y/P6YHCIqlWHJUhlI4GNs5/3jbDocHbZAoh+MrXEL6MO+jlapfEpk3Vnl3RaqnxwNpvL
         OezQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1tGskau943T386kyJZ4GTkvXE83xs6wkbIyb/EV2Rpk=;
        b=IzsPAX+iNQDtxceGbR8i486JC2OmOmTr/yT+jWKTufESQ16QGSoTvTEkEwPl/ugf0h
         O4ROiaROdPtFjVWf/cidhgvNtG8IH/bXtUbs55aHiBw479SQgvHpYsUMkTV6yfLp7t2H
         f0qimKtj+noKZNRyNqUMEniNUQNYnZwxSgJpV7qSJJn27D6X+6jQqO9zoi0s4m/DwjhZ
         qhpV7mfItT6XbU2fCTMfVhIDIRrZtEj218JX3kYukyWWIHxgZa6Uf9CfHFLYlvMJJmQX
         eFTA0RpdJ1iXhquRRKOT+BsRi2Onf3GZcemmK2kHfp7Unun4tjVnU/qfXJtndzkXlfxE
         VaVA==
X-Gm-Message-State: APjAAAUk1bjMfc86Mhdrg7gnSMHXIq2U3RmxpZAEIQDzU3nI4EtjipgT
        XYBdOAiUFqjmtJFXpmh0opqtVA==
X-Google-Smtp-Source: APXvYqx0Db3o3ZFAEBSbPaDuezp3pPOGT2TknFdYmxY96lSJbhl/a9mWkPJqEcokRvgXBp2rPlJIuQ==
X-Received: by 2002:adf:ef8d:: with SMTP id d13mr47605958wro.60.1560505373986;
        Fri, 14 Jun 2019 02:42:53 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:8d0e:a5b1:c005:e3b5])
        by smtp.gmail.com with ESMTPSA id d10sm3502267wrp.74.2019.06.14.02.42.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 02:42:53 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-usb@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        ebiggers@kernel.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] wireless: airo: switch to skcipher interface
Date:   Fri, 14 Jun 2019 11:42:50 +0200
Message-Id: <20190614094250.22997-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The AIRO driver applies a ctr(aes) on a buffer of considerable size
(2400 bytes), and instead of invoking the crypto API to handle this
in its entirety, it open codes the counter manipulation and invokes
the AES block cipher directly.

Let's fix this, by switching to the sync skcipher API instead.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
NOTE: build tested only, since I don't have the hardware

 drivers/net/wireless/cisco/airo.c | 57 ++++++++++----------
 1 file changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 3f5a14112c6b..2d29ad10505b 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -49,6 +49,9 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
+#include <crypto/aes.h>
+#include <crypto/skcipher.h>
+
 #include <net/cfg80211.h>
 #include <net/iw_handler.h>
 
@@ -951,7 +954,7 @@ typedef struct {
 } mic_statistics;
 
 typedef struct {
-	u32 coeff[((EMMH32_MSGLEN_MAX)+3)>>2];
+	__be32 coeff[((EMMH32_MSGLEN_MAX)+3)>>2];
 	u64 accum;	// accumulated mic, reduced to u32 in final()
 	int position;	// current position (byte offset) in message
 	union {
@@ -1216,7 +1219,7 @@ struct airo_info {
 	struct iw_spy_data	spy_data;
 	struct iw_public_data	wireless_data;
 	/* MIC stuff */
-	struct crypto_cipher	*tfm;
+	struct crypto_sync_skcipher	*tfm;
 	mic_module		mod[2];
 	mic_statistics		micstats;
 	HostRxDesc rxfids[MPI_MAX_FIDS]; // rx/tx/config MPI350 descriptors
@@ -1291,14 +1294,14 @@ static int flashrestart(struct airo_info *ai,struct net_device *dev);
 static int RxSeqValid (struct airo_info *ai,miccntx *context,int mcast,u32 micSeq);
 static void MoveWindow(miccntx *context, u32 micSeq);
 static void emmh32_setseed(emmh32_context *context, u8 *pkey, int keylen,
-			   struct crypto_cipher *tfm);
+			   struct crypto_sync_skcipher *tfm);
 static void emmh32_init(emmh32_context *context);
 static void emmh32_update(emmh32_context *context, u8 *pOctets, int len);
 static void emmh32_final(emmh32_context *context, u8 digest[4]);
 static int flashpchar(struct airo_info *ai,int byte,int dwelltime);
 
 static void age_mic_context(miccntx *cur, miccntx *old, u8 *key, int key_len,
-			    struct crypto_cipher *tfm)
+			    struct crypto_sync_skcipher *tfm)
 {
 	/* If the current MIC context is valid and its key is the same as
 	 * the MIC register, there's nothing to do.
@@ -1359,7 +1362,7 @@ static int micsetup(struct airo_info *ai) {
 	int i;
 
 	if (ai->tfm == NULL)
-		ai->tfm = crypto_alloc_cipher("aes", 0, 0);
+		ai->tfm = crypto_alloc_sync_skcipher("ctr(aes)", 0, 0);
 
         if (IS_ERR(ai->tfm)) {
                 airo_print_err(ai->dev->name, "failed to load transform for AES");
@@ -1624,37 +1627,31 @@ static void MoveWindow(miccntx *context, u32 micSeq)
 
 /* mic accumulate */
 #define MIC_ACCUM(val)	\
-	context->accum += (u64)(val) * context->coeff[coeff_position++];
-
-static unsigned char aes_counter[16];
+	context->accum += (u64)(val) * be32_to_cpu(context->coeff[coeff_position++]);
 
 /* expand the key to fill the MMH coefficient array */
 static void emmh32_setseed(emmh32_context *context, u8 *pkey, int keylen,
-			   struct crypto_cipher *tfm)
+			   struct crypto_sync_skcipher *tfm)
 {
   /* take the keying material, expand if necessary, truncate at 16-bytes */
   /* run through AES counter mode to generate context->coeff[] */
   
-	int i,j;
-	u32 counter;
-	u8 *cipher, plain[16];
-
-	crypto_cipher_setkey(tfm, pkey, 16);
-	counter = 0;
-	for (i = 0; i < ARRAY_SIZE(context->coeff); ) {
-		aes_counter[15] = (u8)(counter >> 0);
-		aes_counter[14] = (u8)(counter >> 8);
-		aes_counter[13] = (u8)(counter >> 16);
-		aes_counter[12] = (u8)(counter >> 24);
-		counter++;
-		memcpy (plain, aes_counter, 16);
-		crypto_cipher_encrypt_one(tfm, plain, plain);
-		cipher = plain;
-		for (j = 0; (j < 16) && (i < ARRAY_SIZE(context->coeff)); ) {
-			context->coeff[i++] = ntohl(*(__be32 *)&cipher[j]);
-			j += 4;
-		}
-	}
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, tfm);
+	struct scatterlist dst, src;
+	u8 iv[AES_BLOCK_SIZE] = {};
+	int ret;
+
+	crypto_sync_skcipher_setkey(tfm, pkey, 16);
+
+	sg_init_one(&dst, context->coeff, sizeof(context->coeff));
+	sg_init_one(&src, page_address(ZERO_PAGE(0)), sizeof(context->coeff));
+
+	skcipher_request_set_sync_tfm(req, tfm);
+	skcipher_request_set_callback(req, 0, NULL, NULL);
+	skcipher_request_set_crypt(req, &src, &dst, sizeof(context->coeff), iv);
+
+	ret = crypto_skcipher_encrypt(req);
+	WARN_ON_ONCE(ret);
 }
 
 /* prepare for calculation of a new mic */
@@ -2415,7 +2412,7 @@ void stop_airo_card( struct net_device *dev, int freeres )
 				ai->shared, ai->shared_dma);
 		}
         }
-	crypto_free_cipher(ai->tfm);
+	crypto_free_sync_skcipher(ai->tfm);
 	del_airo_dev(ai);
 	free_netdev( dev );
 }
-- 
2.20.1

