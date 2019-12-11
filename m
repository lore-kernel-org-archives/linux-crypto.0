Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33FB6C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 16:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE6D0214D8
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 16:36:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ri0hMh6r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730109AbfLKQgD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 11:36:03 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36536 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730107AbfLKQgD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 11:36:03 -0500
Received: by mail-wr1-f65.google.com with SMTP id z3so24783175wru.3
        for <linux-crypto@vger.kernel.org>; Wed, 11 Dec 2019 08:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kFVOPX/JnBhC5kLhgD7A99rzIZzze7qaq5NMsZ7rttc=;
        b=Ri0hMh6rHTC1X0JZaHRfAKSlQCHyZiPZKRQJnj1AypMvOWBu3jrcfiGoksLNc2RKvl
         8+yvCiF6orm7VYTs6EbyheUmornqVt7t8VR9upwa8tGoLCQxkl70NTH4GtwVmaekws5o
         daiLpTWwclJylpHHMFbeAM+aXSrsqaJo5MdMHUWSAfnv2jwFnTZ/0MkjErhgQOcaaaZX
         /n/VmwiUGGh7Eu5ONio7UkdbSGBerL8MjxbWqVtzHy3j+zyITkkQ0k39VOmWkYj3oYlu
         qWLixCDbXBb+C/U5BsuL2e+oT68ZLSYDRB/uS3uRHjfIGOw2pRBk9OS9ZB5jB+fuLSYB
         OWOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kFVOPX/JnBhC5kLhgD7A99rzIZzze7qaq5NMsZ7rttc=;
        b=FwSInCI/PAXCCsZ05zUQXpJ8sJ0ieIT+YDnioM+JiZ0cFsouNxTPKLhFmsHmXkFdl6
         CIQZ5QxwIbwZWOiH4IJ2A9yYt3jRItJ1ovhGjfDs45DLTXQdEcgl358pQrUbahZcmmNY
         EJfrdfSTjUOYlnlI7q9uXMDmj7E1cRdK1kUi/C8PtiCVCHZl8Xwt+zJIW9LP23Cch04W
         08RKnFV74zGVA/9MsRJkrARe3mzmxMTRd5m+rfrL+FMl4yyT8oGKFNO4LRAIu3AnEPUh
         BOoyrrQCr/+nRPtHg7nFdhuvLrpCB3hDH4gkQyTBY0O8f7ixB8Lvxl5dExBD9ubfgvhw
         AWmA==
X-Gm-Message-State: APjAAAWlYNXSti4I9k6a1CMleiGvcVDs7qQn8EQuy6nWdNo7FBaSsaJ+
        VNCxWQS9pJp6d4MEexK/JlOYC22OTrIGhg==
X-Google-Smtp-Source: APXvYqxKwdlmAe49jnVN9Y603cYJl1SJ0Ev2jfHw5k8hMTmuLJc5ra5e8sBAfusFnb4Q5iuM9kwMVg==
X-Received: by 2002:a5d:4392:: with SMTP id i18mr736752wrq.199.1576082157422;
        Wed, 11 Dec 2019 08:35:57 -0800 (PST)
Received: from localhost.localdomain.com ([31.149.181.161])
        by smtp.gmail.com with ESMTPSA id o19sm2162405wmc.18.2019.12.11.08.35.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Dec 2019 08:35:56 -0800 (PST)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@rambus.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, Pascal van Leeuwen <pvanleeuwen@rambus.com>
Subject: [PATCH 1/3] crypto: inside-secure - Fix Unable to fit even 1 command desc error w/ EIP97
Date:   Wed, 11 Dec 2019 17:32:35 +0100
Message-Id: <1576081957-5971-2-git-send-email-pvanleeuwen@rambus.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1576081957-5971-1-git-send-email-pvanleeuwen@rambus.com>
References: <1576081957-5971-1-git-send-email-pvanleeuwen@rambus.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Due to the additions of support for modes like AES-CCM and AES-GCM, which
require large command tokens, the size of the descriptor has grown such that
it now does not fit into the descriptor cache of a standard EIP97 anymore.
This means that the driver no longer works on the Marvell Armada 3700LP chip
(as used on e.g. Espressobin) that it has always supported.
Additionally, performance on EIP197's like Marvell A8K may also degrade
due to being able to fit less descriptors in the on-chip cache.
Putting these tokens into the descriptor was really a hack and not how the
design was supposed to be used - resource allocation did not account for it.

So what this patch does, is move the command token out of the descriptor.
To avoid having to allocate buffers on the fly for these command tokens,
they are stuffed in a "shadow ring", which is a circular buffer of fixed
size blocks that runs in lock-step with the descriptor ring. i.e. there is
one token block per descriptor. The descriptor ring itself is then pre-
populated with the pointers to these token blocks so these do not need to
be filled in when building the descriptors later.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@rambus.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  12 +-
 drivers/crypto/inside-secure/safexcel.h        |  34 +-
 drivers/crypto/inside-secure/safexcel_cipher.c | 508 +++++++++++++++----------
 drivers/crypto/inside-secure/safexcel_hash.c   |  11 +-
 drivers/crypto/inside-secure/safexcel_ring.c   | 130 +++++--
 5 files changed, 446 insertions(+), 249 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 64894d8..2cb53fb 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -501,8 +501,8 @@ static int safexcel_hw_setup_cdesc_rings(struct safexcel_crypto_priv *priv)
 		writel(upper_32_bits(priv->ring[i].cdr.base_dma),
 		       EIP197_HIA_CDR(priv, i) + EIP197_HIA_xDR_RING_BASE_ADDR_HI);

-		writel(EIP197_xDR_DESC_MODE_64BIT | (priv->config.cd_offset << 14) |
-		       priv->config.cd_size,
+		writel(EIP197_xDR_DESC_MODE_64BIT | EIP197_CDR_DESC_MODE_ADCP |
+		       (priv->config.cd_offset << 14) | priv->config.cd_size,
 		       EIP197_HIA_CDR(priv, i) + EIP197_HIA_xDR_DESC_SIZE);
 		writel(((cd_fetch_cnt *
 			 (cd_size_rnd << priv->hwconfig.hwdataw)) << 16) |
@@ -974,16 +974,18 @@ int safexcel_invalidate_cache(struct crypto_async_request *async,
 {
 	struct safexcel_command_desc *cdesc;
 	struct safexcel_result_desc *rdesc;
+	struct safexcel_token  *dmmy;
 	int ret = 0;

 	/* Prepare command descriptor */
-	cdesc = safexcel_add_cdesc(priv, ring, true, true, 0, 0, 0, ctxr_dma);
+	cdesc = safexcel_add_cdesc(priv, ring, true, true, 0, 0, 0, ctxr_dma,
+				   &dmmy);
 	if (IS_ERR(cdesc))
 		return PTR_ERR(cdesc);

 	cdesc->control_data.type = EIP197_TYPE_EXTENDED;
 	cdesc->control_data.options = 0;
-	cdesc->control_data.refresh = 0;
+	cdesc->control_data.context_lo &= ~EIP197_CONTEXT_SIZE_MASK;
 	cdesc->control_data.control0 = CONTEXT_CONTROL_INV_TR;

 	/* Prepare result descriptor */
@@ -1331,6 +1333,7 @@ static void safexcel_configure(struct safexcel_crypto_priv *priv)

 	priv->config.cd_size = EIP197_CD64_FETCH_SIZE;
 	priv->config.cd_offset = (priv->config.cd_size + mask) & ~mask;
+	priv->config.cdsh_offset = (EIP197_MAX_TOKENS + mask) & ~mask;

 	/* res token is behind the descr, but ofs must be rounded to buswdth */
 	priv->config.res_offset = (EIP197_RD64_FETCH_SIZE + mask) & ~mask;
@@ -1341,6 +1344,7 @@ static void safexcel_configure(struct safexcel_crypto_priv *priv)

 	/* convert dwords to bytes */
 	priv->config.cd_offset *= sizeof(u32);
+	priv->config.cdsh_offset *= sizeof(u32);
 	priv->config.rd_offset *= sizeof(u32);
 	priv->config.res_offset *= sizeof(u32);
 }
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index b4624b5..94016c5 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -40,7 +40,8 @@

 /* Static configuration */
 #define EIP197_DEFAULT_RING_SIZE		400
-#define EIP197_MAX_TOKENS			19
+#define EIP197_EMB_TOKENS			4 /* Pad CD to 16 dwords */
+#define EIP197_MAX_TOKENS			16
 #define EIP197_MAX_RINGS			4
 #define EIP197_FETCH_DEPTH			2
 #define EIP197_MAX_BATCH_SZ			64
@@ -207,6 +208,7 @@

 /* EIP197_HIA_xDR_DESC_SIZE */
 #define EIP197_xDR_DESC_MODE_64BIT		BIT(31)
+#define EIP197_CDR_DESC_MODE_ADCP		BIT(30)

 /* EIP197_HIA_xDR_DMA_CFG */
 #define EIP197_HIA_xDR_WR_RES_BUF		BIT(22)
@@ -277,9 +279,9 @@
 #define EIP197_HIA_DxE_CFG_MIN_CTRL_SIZE(n)	((n) << 16)
 #define EIP197_HIA_DxE_CFG_CTRL_CACHE_CTRL(n)	(((n) & 0x7) << 20)
 #define EIP197_HIA_DxE_CFG_MAX_CTRL_SIZE(n)	((n) << 24)
-#define EIP197_HIA_DFE_CFG_DIS_DEBUG		(BIT(31) | BIT(29))
+#define EIP197_HIA_DFE_CFG_DIS_DEBUG		GENMASK(31, 29)
 #define EIP197_HIA_DSE_CFG_EN_SINGLE_WR		BIT(29)
-#define EIP197_HIA_DSE_CFG_DIS_DEBUG		BIT(31)
+#define EIP197_HIA_DSE_CFG_DIS_DEBUG		GENMASK(31, 30)

 /* EIP197_HIA_DFE/DSE_THR_CTRL */
 #define EIP197_DxE_THR_CTRL_EN			BIT(30)
@@ -553,6 +555,8 @@ static inline void eip197_noop_token(struct safexcel_token *token)
 {
 	token->opcode = EIP197_TOKEN_OPCODE_NOOP;
 	token->packet_length = BIT(2);
+	token->stat = 0;
+	token->instructions = 0;
 }

 /* Instructions */
@@ -574,14 +578,13 @@ struct safexcel_control_data_desc {
 	u16 application_id;
 	u16 rsvd;

-	u8 refresh:2;
-	u32 context_lo:30;
+	u32 context_lo;
 	u32 context_hi;

 	u32 control0;
 	u32 control1;

-	u32 token[EIP197_MAX_TOKENS];
+	u32 token[EIP197_EMB_TOKENS];
 } __packed;

 #define EIP197_OPTION_MAGIC_VALUE	BIT(0)
@@ -591,7 +594,10 @@ struct safexcel_control_data_desc {
 #define EIP197_OPTION_2_TOKEN_IV_CMD	GENMASK(11, 10)
 #define EIP197_OPTION_4_TOKEN_IV_CMD	GENMASK(11, 9)

+#define EIP197_TYPE_BCLA		0x0
 #define EIP197_TYPE_EXTENDED		0x3
+#define EIP197_CONTEXT_SMALL		0x2
+#define EIP197_CONTEXT_SIZE_MASK	0x3

 /* Basic Command Descriptor format */
 struct safexcel_command_desc {
@@ -599,13 +605,16 @@ struct safexcel_command_desc {
 	u8 rsvd0:5;
 	u8 last_seg:1;
 	u8 first_seg:1;
-	u16 additional_cdata_size:8;
+	u8 additional_cdata_size:8;

 	u32 rsvd1;

 	u32 data_lo;
 	u32 data_hi;

+	u32 atok_lo;
+	u32 atok_hi;
+
 	struct safexcel_control_data_desc control_data;
 } __packed;

@@ -629,15 +638,20 @@ enum eip197_fw {

 struct safexcel_desc_ring {
 	void *base;
+	void *shbase;
 	void *base_end;
+	void *shbase_end;
 	dma_addr_t base_dma;
+	dma_addr_t shbase_dma;

 	/* write and read pointers */
 	void *write;
+	void *shwrite;
 	void *read;

 	/* descriptor element offset */
-	unsigned offset;
+	unsigned int offset;
+	unsigned int shoffset;
 };

 enum safexcel_alg_type {
@@ -652,6 +666,7 @@ struct safexcel_config {

 	u32 cd_size;
 	u32 cd_offset;
+	u32 cdsh_offset;

 	u32 rd_size;
 	u32 rd_offset;
@@ -862,7 +877,8 @@ struct safexcel_command_desc *safexcel_add_cdesc(struct safexcel_crypto_priv *pr
 						 bool first, bool last,
 						 dma_addr_t data, u32 len,
 						 u32 full_data_len,
-						 dma_addr_t context);
+						 dma_addr_t context,
+						 struct safexcel_token **atoken);
 struct safexcel_result_desc *safexcel_add_rdesc(struct safexcel_crypto_priv *priv,
 						 int ring_id,
 						bool first, bool last,
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index c029956..b76f5ab 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -47,8 +47,12 @@ struct safexcel_cipher_ctx {

 	u32 mode;
 	enum safexcel_cipher_alg alg;
-	char aead; /* !=0=AEAD, 2=IPSec ESP AEAD, 3=IPsec ESP GMAC */
-	char xcm;  /* 0=authenc, 1=GCM, 2 reserved for CCM */
+	u8 aead; /* !=0=AEAD, 2=IPSec ESP AEAD, 3=IPsec ESP GMAC */
+	u8 xcm;  /* 0=authenc, 1=GCM, 2 reserved for CCM */
+	u8 aadskip;
+	u8 blocksz;
+	u32 ivmask;
+	u32 ctrinit;

 	__le32 key[16];
 	u32 nonce;
@@ -72,251 +76,298 @@ struct safexcel_cipher_req {
 	int  nr_src, nr_dst;
 };

-static void safexcel_cipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
-				  struct safexcel_command_desc *cdesc)
+static int safexcel_skcipher_iv(struct safexcel_cipher_ctx *ctx, u8 *iv,
+				struct safexcel_command_desc *cdesc)
 {
-	u32 block_sz = 0;
-
-	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD ||
-	    ctx->aead & EIP197_AEAD_TYPE_IPSEC_ESP) { /* _ESP and _ESP_GMAC */
+	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD) {
 		cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
-
 		/* 32 bit nonce */
 		cdesc->control_data.token[0] = ctx->nonce;
 		/* 64 bit IV part */
 		memcpy(&cdesc->control_data.token[1], iv, 8);
-
-		if (ctx->alg == SAFEXCEL_CHACHA20 ||
-		    ctx->xcm == EIP197_XCM_MODE_CCM) {
-			/* 32 bit counter, starting at 0 */
-			cdesc->control_data.token[3] = 0;
-		} else {
-			/* 32 bit counter, start at 1 (big endian!) */
-			cdesc->control_data.token[3] =
-				(__force u32)cpu_to_be32(1);
-		}
-
-		return;
-	} else if (ctx->xcm == EIP197_XCM_MODE_GCM ||
-		   (ctx->aead && ctx->alg == SAFEXCEL_CHACHA20)) {
-		cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
-
-		/* 96 bit IV part */
-		memcpy(&cdesc->control_data.token[0], iv, 12);
-
-		if (ctx->alg == SAFEXCEL_CHACHA20) {
-			/* 32 bit counter, starting at 0 */
-			cdesc->control_data.token[3] = 0;
-		} else {
-			/* 32 bit counter, start at 1 (big endian!) */
-			*(__be32 *)&cdesc->control_data.token[3] =
-				cpu_to_be32(1);
-		}
-
-		return;
-	} else if (ctx->alg == SAFEXCEL_CHACHA20) {
+		/* 32 bit counter, start at 0 or 1 (big endian!) */
+		cdesc->control_data.token[3] =
+			(__force u32)cpu_to_be32(ctx->ctrinit);
+		return 4;
+	}
+	if (ctx->alg == SAFEXCEL_CHACHA20) {
 		cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
-
 		/* 96 bit nonce part */
 		memcpy(&cdesc->control_data.token[0], &iv[4], 12);
 		/* 32 bit counter */
 		cdesc->control_data.token[3] = *(u32 *)iv;
-
-		return;
-	} else if (ctx->xcm == EIP197_XCM_MODE_CCM) {
-		cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
-
-		/* Variable length IV part */
-		memcpy(&cdesc->control_data.token[0], iv, 15 - iv[0]);
-		/* Start variable length counter at 0 */
-		memset((u8 *)&cdesc->control_data.token[0] + 15 - iv[0],
-		       0, iv[0] + 1);
-
-		return;
+		return 4;
 	}

-	if (ctx->mode != CONTEXT_CONTROL_CRYPTO_MODE_ECB) {
-		switch (ctx->alg) {
-		case SAFEXCEL_DES:
-			block_sz = DES_BLOCK_SIZE;
-			cdesc->control_data.options |= EIP197_OPTION_2_TOKEN_IV_CMD;
-			break;
-		case SAFEXCEL_3DES:
-			block_sz = DES3_EDE_BLOCK_SIZE;
-			cdesc->control_data.options |= EIP197_OPTION_2_TOKEN_IV_CMD;
-			break;
-		case SAFEXCEL_SM4:
-			block_sz = SM4_BLOCK_SIZE;
-			cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
-			break;
-		case SAFEXCEL_AES:
-			block_sz = AES_BLOCK_SIZE;
-			cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
-			break;
-		default:
-			break;
-		}
-		memcpy(cdesc->control_data.token, iv, block_sz);
-	}
+	cdesc->control_data.options |= ctx->ivmask;
+	memcpy(cdesc->control_data.token, iv, ctx->blocksz);
+	return ctx->blocksz / sizeof(u32);
 }

 static void safexcel_skcipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 				    struct safexcel_command_desc *cdesc,
+				    struct safexcel_token *atoken,
 				    u32 length)
 {
 	struct safexcel_token *token;
+	int ivlen;

-	safexcel_cipher_token(ctx, iv, cdesc);
+	ivlen = safexcel_skcipher_iv(ctx, iv, cdesc);
+	if (ivlen == 4) {
+		/* No space in cdesc, instruction moves to atoken */
+		cdesc->additional_cdata_size = 1;
+		token = atoken;
+	} else {
+		/* Everything fits in cdesc */
+		token = (struct safexcel_token *)(cdesc->control_data.token + 2);
+		/* Need to pad with NOP */
+		eip197_noop_token(&token[1]);
+	}

-	/* skip over worst case IV of 4 dwords, no need to be exact */
-	token = (struct safexcel_token *)(cdesc->control_data.token + 4);
+	token->opcode = EIP197_TOKEN_OPCODE_DIRECTION;
+	token->packet_length = length;
+	token->stat = EIP197_TOKEN_STAT_LAST_PACKET |
+		      EIP197_TOKEN_STAT_LAST_HASH;
+	token->instructions = EIP197_TOKEN_INS_LAST |
+			      EIP197_TOKEN_INS_TYPE_CRYPTO |
+			      EIP197_TOKEN_INS_TYPE_OUTPUT;
+}

-	token[0].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
-	token[0].packet_length = length;
-	token[0].stat = EIP197_TOKEN_STAT_LAST_PACKET |
-			EIP197_TOKEN_STAT_LAST_HASH;
-	token[0].instructions = EIP197_TOKEN_INS_LAST |
-				EIP197_TOKEN_INS_TYPE_CRYPTO |
-				EIP197_TOKEN_INS_TYPE_OUTPUT;
+static void safexcel_aead_iv(struct safexcel_cipher_ctx *ctx, u8 *iv,
+			     struct safexcel_command_desc *cdesc)
+{
+	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD ||
+	    ctx->aead & EIP197_AEAD_TYPE_IPSEC_ESP) { /* _ESP and _ESP_GMAC */
+		/* 32 bit nonce */
+		cdesc->control_data.token[0] = ctx->nonce;
+		/* 64 bit IV part */
+		memcpy(&cdesc->control_data.token[1], iv, 8);
+		/* 32 bit counter, start at 0 or 1 (big endian!) */
+		cdesc->control_data.token[3] =
+			(__force u32)cpu_to_be32(ctx->ctrinit);
+		return;
+	}
+	if (ctx->xcm == EIP197_XCM_MODE_GCM || ctx->alg == SAFEXCEL_CHACHA20) {
+		/* 96 bit IV part */
+		memcpy(&cdesc->control_data.token[0], iv, 12);
+		/* 32 bit counter, start at 0 or 1 (big endian!) */
+		cdesc->control_data.token[3] =
+			(__force u32)cpu_to_be32(ctx->ctrinit);
+		return;
+	}
+	/* CBC */
+	memcpy(cdesc->control_data.token, iv, ctx->blocksz);
 }

 static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 				struct safexcel_command_desc *cdesc,
+				struct safexcel_token *atoken,
 				enum safexcel_cipher_direction direction,
 				u32 cryptlen, u32 assoclen, u32 digestsize)
 {
-	struct safexcel_token *token;
+	struct safexcel_token *aadref;
+	int atoksize = 2; /* Start with minimum size */
+	int assocadj = assoclen - ctx->aadskip, aadalign;

-	safexcel_cipher_token(ctx, iv, cdesc);
+	/* Always 4 dwords of embedded IV  for AEAD modes */
+	cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;

-	if (direction == SAFEXCEL_ENCRYPT) {
-		/* align end of instruction sequence to end of token */
-		token = (struct safexcel_token *)(cdesc->control_data.token +
-			 EIP197_MAX_TOKENS - 14);
-
-		token[13].opcode = EIP197_TOKEN_OPCODE_INSERT;
-		token[13].packet_length = digestsize;
-		token[13].stat = EIP197_TOKEN_STAT_LAST_HASH |
-				 EIP197_TOKEN_STAT_LAST_PACKET;
-		token[13].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT |
-					 EIP197_TOKEN_INS_INSERT_HASH_DIGEST;
-	} else {
+	if (direction == SAFEXCEL_DECRYPT)
 		cryptlen -= digestsize;

-		/* align end of instruction sequence to end of token */
-		token = (struct safexcel_token *)(cdesc->control_data.token +
-			 EIP197_MAX_TOKENS - 15);
-
-		token[13].opcode = EIP197_TOKEN_OPCODE_RETRIEVE;
-		token[13].packet_length = digestsize;
-		token[13].stat = EIP197_TOKEN_STAT_LAST_HASH |
-				 EIP197_TOKEN_STAT_LAST_PACKET;
-		token[13].instructions = EIP197_TOKEN_INS_INSERT_HASH_DIGEST;
-
-		token[14].opcode = EIP197_TOKEN_OPCODE_VERIFY;
-		token[14].packet_length = digestsize |
-					  EIP197_TOKEN_HASH_RESULT_VERIFY;
-		token[14].stat = EIP197_TOKEN_STAT_LAST_HASH |
-				 EIP197_TOKEN_STAT_LAST_PACKET;
-		token[14].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT;
-	}
-
-	if (ctx->aead == EIP197_AEAD_TYPE_IPSEC_ESP) {
-		/* For ESP mode (and not GMAC), skip over the IV */
-		token[8].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
-		token[8].packet_length = EIP197_AEAD_IPSEC_IV_SIZE;
-
-		assoclen -= EIP197_AEAD_IPSEC_IV_SIZE;
-	}
+	if (unlikely(ctx->xcm == EIP197_XCM_MODE_CCM)) {
+		/* Construct IV block B0 for the CBC-MAC */
+		u8 *final_iv = (u8 *)cdesc->control_data.token;
+		u8 *cbcmaciv = (u8 *)&atoken[1];
+		__le32 *aadlen = (__le32 *)&atoken[5];
+
+		if (ctx->aead == EIP197_AEAD_TYPE_IPSEC_ESP) {
+			/* Length + nonce */
+			cdesc->control_data.token[0] = ctx->nonce;
+			/* Fixup flags byte */
+			*(__le32 *)cbcmaciv =
+				cpu_to_le32(ctx->nonce |
+					    ((assocadj > 0) << 6) |
+					    ((digestsize - 2) << 2));
+			/* 64 bit IV part */
+			memcpy(&cdesc->control_data.token[1], iv, 8);
+			memcpy(cbcmaciv + 4, iv, 8);
+			/* Start counter at 0 */
+			cdesc->control_data.token[3] = 0;
+			/* Message length */
+			*(__be32 *)(cbcmaciv + 12) = cpu_to_be32(cryptlen);
+		} else {
+			/* Variable length IV part */
+			memcpy(final_iv, iv, 15 - iv[0]);
+			memcpy(cbcmaciv, iv, 15 - iv[0]);
+			/* Start variable length counter at 0 */
+			memset(final_iv + 15 - iv[0], 0, iv[0] + 1);
+			memset(cbcmaciv + 15 - iv[0], 0, iv[0] - 1);
+			/* fixup flags byte */
+			cbcmaciv[0] |= ((assocadj > 0) << 6) |
+				       ((digestsize - 2) << 2);
+			/* insert lower 2 bytes of message length */
+			cbcmaciv[14] = cryptlen >> 8;
+			cbcmaciv[15] = cryptlen & 255;
+		}

-	token[6].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
-	token[6].packet_length = assoclen;
-	token[6].instructions = EIP197_TOKEN_INS_LAST |
-				EIP197_TOKEN_INS_TYPE_HASH;
+		atoken->opcode = EIP197_TOKEN_OPCODE_INSERT;
+		atoken->packet_length = AES_BLOCK_SIZE +
+					((assocadj > 0) << 1);
+		atoken->stat = 0;
+		atoken->instructions = EIP197_TOKEN_INS_ORIGIN_TOKEN |
+				       EIP197_TOKEN_INS_TYPE_HASH;
+
+		if (likely(assocadj)) {
+			*aadlen = cpu_to_le32((assocadj >> 8) |
+					      (assocadj & 255) << 8);
+			atoken += 6;
+			atoksize += 7;
+		} else {
+			atoken += 5;
+			atoksize += 6;
+		}

-	if (likely(cryptlen || ctx->alg == SAFEXCEL_CHACHA20)) {
-		token[11].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
-		token[11].packet_length = cryptlen;
-		token[11].stat = EIP197_TOKEN_STAT_LAST_HASH;
-		if (unlikely(ctx->aead == EIP197_AEAD_TYPE_IPSEC_ESP_GMAC)) {
-			token[6].instructions = EIP197_TOKEN_INS_TYPE_HASH;
-			/* Do not send to crypt engine in case of GMAC */
-			token[11].instructions = EIP197_TOKEN_INS_LAST |
-						 EIP197_TOKEN_INS_TYPE_HASH |
-						 EIP197_TOKEN_INS_TYPE_OUTPUT;
+		/* Process AAD data */
+		aadref = atoken;
+		atoken->opcode = EIP197_TOKEN_OPCODE_DIRECTION;
+		atoken->packet_length = assocadj;
+		atoken->stat = 0;
+		atoken->instructions = EIP197_TOKEN_INS_TYPE_HASH;
+		atoken++;
+
+		/* For CCM only, align AAD data towards hash engine */
+		atoken->opcode = EIP197_TOKEN_OPCODE_INSERT;
+		aadalign = (assocadj + 2) & 15;
+		atoken->packet_length = assocadj && aadalign ?
+						16 - aadalign :
+						0;
+		if (likely(cryptlen)) {
+			atoken->stat = 0;
+			atoken->instructions = EIP197_TOKEN_INS_TYPE_HASH;
 		} else {
-			token[11].instructions = EIP197_TOKEN_INS_LAST |
-						 EIP197_TOKEN_INS_TYPE_CRYPTO |
-						 EIP197_TOKEN_INS_TYPE_HASH |
-						 EIP197_TOKEN_INS_TYPE_OUTPUT;
+			atoken->stat = EIP197_TOKEN_STAT_LAST_HASH;
+			atoken->instructions = EIP197_TOKEN_INS_LAST |
+					       EIP197_TOKEN_INS_TYPE_HASH;
 		}
-	} else if (ctx->xcm != EIP197_XCM_MODE_CCM) {
-		token[6].stat = EIP197_TOKEN_STAT_LAST_HASH;
+	} else {
+		safexcel_aead_iv(ctx, iv, cdesc);
+
+		/* Process AAD data */
+		aadref = atoken;
+		atoken->opcode = EIP197_TOKEN_OPCODE_DIRECTION;
+		atoken->packet_length = assocadj;
+		atoken->stat = EIP197_TOKEN_STAT_LAST_HASH;
+		atoken->instructions = EIP197_TOKEN_INS_LAST |
+				       EIP197_TOKEN_INS_TYPE_HASH;
 	}
+	atoken++;

-	if (!ctx->xcm)
-		return;
+	if (ctx->aead == EIP197_AEAD_TYPE_IPSEC_ESP) {
+		/* For ESP mode (and not GMAC), skip over the IV */
+		atoken->opcode = EIP197_TOKEN_OPCODE_DIRECTION;
+		atoken->packet_length = EIP197_AEAD_IPSEC_IV_SIZE;
+		atoken->stat = 0;
+		atoken->instructions = 0;
+		atoken++;
+		atoksize++;
+	} else if (unlikely(ctx->alg == SAFEXCEL_CHACHA20 &&
+			    direction == SAFEXCEL_DECRYPT)) {
+		/* Poly-chacha decryption needs a dummy NOP here ... */
+		atoken->opcode = EIP197_TOKEN_OPCODE_INSERT;
+		atoken->packet_length = 16; /* According to Op Manual */
+		atoken->stat = 0;
+		atoken->instructions = 0;
+		atoken++;
+		atoksize++;
+	}

-	token[9].opcode = EIP197_TOKEN_OPCODE_INSERT_REMRES;
-	token[9].packet_length = 0;
-	token[9].instructions = AES_BLOCK_SIZE;
+	if  (ctx->xcm) {
+		/* For GCM and CCM, obtain enc(Y0) */
+		atoken->opcode = EIP197_TOKEN_OPCODE_INSERT_REMRES;
+		atoken->packet_length = 0;
+		atoken->stat = 0;
+		atoken->instructions = AES_BLOCK_SIZE;
+		atoken++;
+
+		atoken->opcode = EIP197_TOKEN_OPCODE_INSERT;
+		atoken->packet_length = AES_BLOCK_SIZE;
+		atoken->stat = 0;
+		atoken->instructions = EIP197_TOKEN_INS_TYPE_OUTPUT |
+				       EIP197_TOKEN_INS_TYPE_CRYPTO;
+		atoken++;
+		atoksize += 2;
+	}

-	token[10].opcode = EIP197_TOKEN_OPCODE_INSERT;
-	token[10].packet_length = AES_BLOCK_SIZE;
-	token[10].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT |
-				 EIP197_TOKEN_INS_TYPE_CRYPTO;
+	if (likely(cryptlen || ctx->alg == SAFEXCEL_CHACHA20)) {
+		/* Fixup stat field for AAD direction instruction */
+		aadref->stat = 0;

-	if (ctx->xcm != EIP197_XCM_MODE_GCM) {
-		u8 *final_iv = (u8 *)cdesc->control_data.token;
-		u8 *cbcmaciv = (u8 *)&token[1];
-		__le32 *aadlen = (__le32 *)&token[5];
+		/* Process crypto data */
+		atoken->opcode = EIP197_TOKEN_OPCODE_DIRECTION;
+		atoken->packet_length = cryptlen;

-		/* Construct IV block B0 for the CBC-MAC */
-		token[0].opcode = EIP197_TOKEN_OPCODE_INSERT;
-		token[0].packet_length = AES_BLOCK_SIZE +
-					 ((assoclen > 0) << 1);
-		token[0].instructions = EIP197_TOKEN_INS_ORIGIN_TOKEN |
-					EIP197_TOKEN_INS_TYPE_HASH;
-		/* Variable length IV part */
-		memcpy(cbcmaciv, final_iv, 15 - final_iv[0]);
-		/* fixup flags byte */
-		cbcmaciv[0] |= ((assoclen > 0) << 6) | ((digestsize - 2) << 2);
-		/* Clear upper bytes of variable message length to 0 */
-		memset(cbcmaciv + 15 - final_iv[0], 0, final_iv[0] - 1);
-		/* insert lower 2 bytes of message length */
-		cbcmaciv[14] = cryptlen >> 8;
-		cbcmaciv[15] = cryptlen & 255;
+		if (unlikely(ctx->aead == EIP197_AEAD_TYPE_IPSEC_ESP_GMAC)) {
+			/* Fixup instruction field for AAD dir instruction */
+			aadref->instructions = EIP197_TOKEN_INS_TYPE_HASH;

-		if (assoclen) {
-			*aadlen = cpu_to_le32((assoclen >> 8) |
-					      ((assoclen & 0xff) << 8));
-			assoclen += 2;
+			/* Do not send to crypt engine in case of GMAC */
+			atoken->instructions = EIP197_TOKEN_INS_LAST |
+					       EIP197_TOKEN_INS_TYPE_HASH |
+					       EIP197_TOKEN_INS_TYPE_OUTPUT;
+		} else {
+			atoken->instructions = EIP197_TOKEN_INS_LAST |
+					       EIP197_TOKEN_INS_TYPE_CRYPTO |
+					       EIP197_TOKEN_INS_TYPE_HASH |
+					       EIP197_TOKEN_INS_TYPE_OUTPUT;
 		}

-		token[6].instructions = EIP197_TOKEN_INS_TYPE_HASH;
-
-		/* Align AAD data towards hash engine */
-		token[7].opcode = EIP197_TOKEN_OPCODE_INSERT;
-		assoclen &= 15;
-		token[7].packet_length = assoclen ? 16 - assoclen : 0;
-
-		if (likely(cryptlen)) {
-			token[7].instructions = EIP197_TOKEN_INS_TYPE_HASH;
-
-			/* Align crypto data towards hash engine */
-			token[11].stat = 0;
-
-			token[12].opcode = EIP197_TOKEN_OPCODE_INSERT;
-			cryptlen &= 15;
-			token[12].packet_length = cryptlen ? 16 - cryptlen : 0;
-			token[12].stat = EIP197_TOKEN_STAT_LAST_HASH;
-			token[12].instructions = EIP197_TOKEN_INS_TYPE_HASH;
+		cryptlen &= 15;
+		if (unlikely(ctx->xcm == EIP197_XCM_MODE_CCM && cryptlen)) {
+			atoken->stat = 0;
+			/* For CCM only, pad crypto data to the hash engine */
+			atoken++;
+			atoksize++;
+			atoken->opcode = EIP197_TOKEN_OPCODE_INSERT;
+			atoken->packet_length = 16 - cryptlen;
+			atoken->stat = EIP197_TOKEN_STAT_LAST_HASH;
+			atoken->instructions = EIP197_TOKEN_INS_TYPE_HASH;
 		} else {
-			token[7].stat = EIP197_TOKEN_STAT_LAST_HASH;
-			token[7].instructions = EIP197_TOKEN_INS_LAST |
-						EIP197_TOKEN_INS_TYPE_HASH;
+			atoken->stat = EIP197_TOKEN_STAT_LAST_HASH;
 		}
+		atoken++;
+		atoksize++;
+	}
+
+	if (direction == SAFEXCEL_ENCRYPT) {
+		/* Append ICV */
+		atoken->opcode = EIP197_TOKEN_OPCODE_INSERT;
+		atoken->packet_length = digestsize;
+		atoken->stat = EIP197_TOKEN_STAT_LAST_HASH |
+			       EIP197_TOKEN_STAT_LAST_PACKET;
+		atoken->instructions = EIP197_TOKEN_INS_TYPE_OUTPUT |
+				       EIP197_TOKEN_INS_INSERT_HASH_DIGEST;
+	} else {
+		/* Extract ICV */
+		atoken->opcode = EIP197_TOKEN_OPCODE_RETRIEVE;
+		atoken->packet_length = digestsize;
+		atoken->stat = EIP197_TOKEN_STAT_LAST_HASH |
+			       EIP197_TOKEN_STAT_LAST_PACKET;
+		atoken->instructions = EIP197_TOKEN_INS_INSERT_HASH_DIGEST;
+		atoken++;
+		atoksize++;
+
+		/* Verify ICV */
+		atoken->opcode = EIP197_TOKEN_OPCODE_VERIFY;
+		atoken->packet_length = digestsize |
+					EIP197_TOKEN_HASH_RESULT_VERIFY;
+		atoken->stat = EIP197_TOKEN_STAT_LAST_HASH |
+			       EIP197_TOKEN_STAT_LAST_PACKET;
+		atoken->instructions = EIP197_TOKEN_INS_TYPE_OUTPUT;
 	}
+
+	/* Fixup length of the token in the command descriptor */
+	cdesc->additional_cdata_size = atoksize;
 }

 static int safexcel_skcipher_aes_setkey(struct crypto_skcipher *ctfm,
@@ -656,6 +707,7 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 	unsigned int totlen;
 	unsigned int totlen_src = cryptlen + assoclen;
 	unsigned int totlen_dst = totlen_src;
+	struct safexcel_token *atoken;
 	int n_cdesc = 0, n_rdesc = 0;
 	int queued, i, ret = 0;
 	bool first = true;
@@ -745,7 +797,7 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 		cdesc = safexcel_add_cdesc(priv, ring, !n_cdesc,
 					   !(queued - len),
 					   sg_dma_address(sg), len, totlen,
-					   ctx->base.ctxr_dma);
+					   ctx->base.ctxr_dma, &atoken);
 		if (IS_ERR(cdesc)) {
 			/* No space left in the command descriptor ring */
 			ret = PTR_ERR(cdesc);
@@ -768,18 +820,18 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 		 * The engine always needs the 1st command descriptor, however!
 		 */
 		first_cdesc = safexcel_add_cdesc(priv, ring, 1, 1, 0, 0, totlen,
-						 ctx->base.ctxr_dma);
+						 ctx->base.ctxr_dma, &atoken);
 		n_cdesc = 1;
 	}

 	/* Add context control words and token to first command descriptor */
 	safexcel_context_control(ctx, base, sreq, first_cdesc);
 	if (ctx->aead)
-		safexcel_aead_token(ctx, iv, first_cdesc,
+		safexcel_aead_token(ctx, iv, first_cdesc, atoken,
 				    sreq->direction, cryptlen,
 				    assoclen, digestsize);
 	else
-		safexcel_skcipher_token(ctx, iv, first_cdesc,
+		safexcel_skcipher_token(ctx, iv, first_cdesc, atoken,
 					cryptlen);

 	/* result descriptors */
@@ -1166,6 +1218,8 @@ static int safexcel_skcipher_cra_init(struct crypto_tfm *tfm)

 	ctx->base.send = safexcel_skcipher_send;
 	ctx->base.handle_result = safexcel_skcipher_handle_result;
+	ctx->ivmask = EIP197_OPTION_4_TOKEN_IV_CMD;
+	ctx->ctrinit = 1;
 	return 0;
 }

@@ -1230,6 +1284,8 @@ static int safexcel_skcipher_aes_ecb_cra_init(struct crypto_tfm *tfm)
 	safexcel_skcipher_cra_init(tfm);
 	ctx->alg  = SAFEXCEL_AES;
 	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_ECB;
+	ctx->blocksz = 0;
+	ctx->ivmask = EIP197_OPTION_2_TOKEN_IV_CMD;
 	return 0;
 }

@@ -1264,6 +1320,7 @@ static int safexcel_skcipher_aes_cbc_cra_init(struct crypto_tfm *tfm)

 	safexcel_skcipher_cra_init(tfm);
 	ctx->alg  = SAFEXCEL_AES;
+	ctx->blocksz = AES_BLOCK_SIZE;
 	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CBC;
 	return 0;
 }
@@ -1300,6 +1357,7 @@ static int safexcel_skcipher_aes_cfb_cra_init(struct crypto_tfm *tfm)

 	safexcel_skcipher_cra_init(tfm);
 	ctx->alg  = SAFEXCEL_AES;
+	ctx->blocksz = AES_BLOCK_SIZE;
 	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CFB;
 	return 0;
 }
@@ -1336,6 +1394,7 @@ static int safexcel_skcipher_aes_ofb_cra_init(struct crypto_tfm *tfm)

 	safexcel_skcipher_cra_init(tfm);
 	ctx->alg  = SAFEXCEL_AES;
+	ctx->blocksz = AES_BLOCK_SIZE;
 	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_OFB;
 	return 0;
 }
@@ -1410,6 +1469,7 @@ static int safexcel_skcipher_aes_ctr_cra_init(struct crypto_tfm *tfm)

 	safexcel_skcipher_cra_init(tfm);
 	ctx->alg  = SAFEXCEL_AES;
+	ctx->blocksz = AES_BLOCK_SIZE;
 	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD;
 	return 0;
 }
@@ -1468,6 +1528,8 @@ static int safexcel_skcipher_des_cbc_cra_init(struct crypto_tfm *tfm)

 	safexcel_skcipher_cra_init(tfm);
 	ctx->alg  = SAFEXCEL_DES;
+	ctx->blocksz = DES_BLOCK_SIZE;
+	ctx->ivmask = EIP197_OPTION_2_TOKEN_IV_CMD;
 	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CBC;
 	return 0;
 }
@@ -1505,6 +1567,8 @@ static int safexcel_skcipher_des_ecb_cra_init(struct crypto_tfm *tfm)
 	safexcel_skcipher_cra_init(tfm);
 	ctx->alg  = SAFEXCEL_DES;
 	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_ECB;
+	ctx->blocksz = 0;
+	ctx->ivmask = EIP197_OPTION_2_TOKEN_IV_CMD;
 	return 0;
 }

@@ -1560,6 +1624,8 @@ static int safexcel_skcipher_des3_cbc_cra_init(struct crypto_tfm *tfm)

 	safexcel_skcipher_cra_init(tfm);
 	ctx->alg  = SAFEXCEL_3DES;
+	ctx->blocksz = DES3_EDE_BLOCK_SIZE;
+	ctx->ivmask = EIP197_OPTION_2_TOKEN_IV_CMD;
 	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CBC;
 	return 0;
 }
@@ -1597,6 +1663,8 @@ static int safexcel_skcipher_des3_ecb_cra_init(struct crypto_tfm *tfm)
 	safexcel_skcipher_cra_init(tfm);
 	ctx->alg  = SAFEXCEL_3DES;
 	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_ECB;
+	ctx->blocksz = 0;
+	ctx->ivmask = EIP197_OPTION_2_TOKEN_IV_CMD;
 	return 0;
 }

@@ -1652,6 +1720,9 @@ static int safexcel_aead_cra_init(struct crypto_tfm *tfm)
 	ctx->priv = tmpl->priv;

 	ctx->alg  = SAFEXCEL_AES; /* default */
+	ctx->blocksz = AES_BLOCK_SIZE;
+	ctx->ivmask = EIP197_OPTION_4_TOKEN_IV_CMD;
+	ctx->ctrinit = 1;
 	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CBC; /* default */
 	ctx->aead = true;
 	ctx->base.send = safexcel_aead_send;
@@ -1840,6 +1911,8 @@ static int safexcel_aead_sha1_des3_cra_init(struct crypto_tfm *tfm)

 	safexcel_aead_sha1_cra_init(tfm);
 	ctx->alg = SAFEXCEL_3DES; /* override default */
+	ctx->blocksz = DES3_EDE_BLOCK_SIZE;
+	ctx->ivmask = EIP197_OPTION_2_TOKEN_IV_CMD;
 	return 0;
 }

@@ -1874,6 +1947,8 @@ static int safexcel_aead_sha256_des3_cra_init(struct crypto_tfm *tfm)

 	safexcel_aead_sha256_cra_init(tfm);
 	ctx->alg = SAFEXCEL_3DES; /* override default */
+	ctx->blocksz = DES3_EDE_BLOCK_SIZE;
+	ctx->ivmask = EIP197_OPTION_2_TOKEN_IV_CMD;
 	return 0;
 }

@@ -1908,6 +1983,8 @@ static int safexcel_aead_sha224_des3_cra_init(struct crypto_tfm *tfm)

 	safexcel_aead_sha224_cra_init(tfm);
 	ctx->alg = SAFEXCEL_3DES; /* override default */
+	ctx->blocksz = DES3_EDE_BLOCK_SIZE;
+	ctx->ivmask = EIP197_OPTION_2_TOKEN_IV_CMD;
 	return 0;
 }

@@ -1942,6 +2019,8 @@ static int safexcel_aead_sha512_des3_cra_init(struct crypto_tfm *tfm)

 	safexcel_aead_sha512_cra_init(tfm);
 	ctx->alg = SAFEXCEL_3DES; /* override default */
+	ctx->blocksz = DES3_EDE_BLOCK_SIZE;
+	ctx->ivmask = EIP197_OPTION_2_TOKEN_IV_CMD;
 	return 0;
 }

@@ -1976,6 +2055,8 @@ static int safexcel_aead_sha384_des3_cra_init(struct crypto_tfm *tfm)

 	safexcel_aead_sha384_cra_init(tfm);
 	ctx->alg = SAFEXCEL_3DES; /* override default */
+	ctx->blocksz = DES3_EDE_BLOCK_SIZE;
+	ctx->ivmask = EIP197_OPTION_2_TOKEN_IV_CMD;
 	return 0;
 }

@@ -2010,6 +2091,8 @@ static int safexcel_aead_sha1_des_cra_init(struct crypto_tfm *tfm)

 	safexcel_aead_sha1_cra_init(tfm);
 	ctx->alg = SAFEXCEL_DES; /* override default */
+	ctx->blocksz = DES_BLOCK_SIZE;
+	ctx->ivmask = EIP197_OPTION_2_TOKEN_IV_CMD;
 	return 0;
 }

@@ -2044,6 +2127,8 @@ static int safexcel_aead_sha256_des_cra_init(struct crypto_tfm *tfm)

 	safexcel_aead_sha256_cra_init(tfm);
 	ctx->alg = SAFEXCEL_DES; /* override default */
+	ctx->blocksz = DES_BLOCK_SIZE;
+	ctx->ivmask = EIP197_OPTION_2_TOKEN_IV_CMD;
 	return 0;
 }

@@ -2078,6 +2163,8 @@ static int safexcel_aead_sha224_des_cra_init(struct crypto_tfm *tfm)

 	safexcel_aead_sha224_cra_init(tfm);
 	ctx->alg = SAFEXCEL_DES; /* override default */
+	ctx->blocksz = DES_BLOCK_SIZE;
+	ctx->ivmask = EIP197_OPTION_2_TOKEN_IV_CMD;
 	return 0;
 }

@@ -2112,6 +2199,8 @@ static int safexcel_aead_sha512_des_cra_init(struct crypto_tfm *tfm)

 	safexcel_aead_sha512_cra_init(tfm);
 	ctx->alg = SAFEXCEL_DES; /* override default */
+	ctx->blocksz = DES_BLOCK_SIZE;
+	ctx->ivmask = EIP197_OPTION_2_TOKEN_IV_CMD;
 	return 0;
 }

@@ -2146,6 +2235,8 @@ static int safexcel_aead_sha384_des_cra_init(struct crypto_tfm *tfm)

 	safexcel_aead_sha384_cra_init(tfm);
 	ctx->alg = SAFEXCEL_DES; /* override default */
+	ctx->blocksz = DES_BLOCK_SIZE;
+	ctx->ivmask = EIP197_OPTION_2_TOKEN_IV_CMD;
 	return 0;
 }

@@ -2412,6 +2503,7 @@ static int safexcel_skcipher_aes_xts_cra_init(struct crypto_tfm *tfm)

 	safexcel_skcipher_cra_init(tfm);
 	ctx->alg  = SAFEXCEL_AES;
+	ctx->blocksz = AES_BLOCK_SIZE;
 	ctx->xts  = 1;
 	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_XTS;
 	return 0;
@@ -2632,6 +2724,7 @@ static int safexcel_aead_ccm_cra_init(struct crypto_tfm *tfm)
 	ctx->state_sz = 3 * AES_BLOCK_SIZE;
 	ctx->xcm = EIP197_XCM_MODE_CCM;
 	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_XCM; /* override default */
+	ctx->ctrinit = 0;
 	return 0;
 }

@@ -2734,6 +2827,7 @@ static int safexcel_skcipher_chacha20_cra_init(struct crypto_tfm *tfm)

 	safexcel_skcipher_cra_init(tfm);
 	ctx->alg  = SAFEXCEL_CHACHA20;
+	ctx->ctrinit = 0;
 	ctx->mode = CONTEXT_CONTROL_CHACHA20_MODE_256_32;
 	return 0;
 }
@@ -2885,6 +2979,7 @@ static int safexcel_aead_chachapoly_cra_init(struct crypto_tfm *tfm)
 	ctx->alg  = SAFEXCEL_CHACHA20;
 	ctx->mode = CONTEXT_CONTROL_CHACHA20_MODE_256_32 |
 		    CONTEXT_CONTROL_CHACHA20_MODE_CALC_OTK;
+	ctx->ctrinit = 0;
 	ctx->hash_alg = CONTEXT_CONTROL_CRYPTO_ALG_POLY1305;
 	ctx->state_sz = 0; /* Precomputed by HW */
 	return 0;
@@ -2933,6 +3028,7 @@ static int safexcel_aead_chachapolyesp_cra_init(struct crypto_tfm *tfm)

 	ret = safexcel_aead_chachapoly_cra_init(tfm);
 	ctx->aead  = EIP197_AEAD_TYPE_IPSEC_ESP;
+	ctx->aadskip = EIP197_AEAD_IPSEC_IV_SIZE;
 	return ret;
 }

@@ -3013,6 +3109,8 @@ static int safexcel_skcipher_sm4_ecb_cra_init(struct crypto_tfm *tfm)
 	safexcel_skcipher_cra_init(tfm);
 	ctx->alg  = SAFEXCEL_SM4;
 	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_ECB;
+	ctx->blocksz = 0;
+	ctx->ivmask = EIP197_OPTION_2_TOKEN_IV_CMD;
 	return 0;
 }

@@ -3047,6 +3145,7 @@ static int safexcel_skcipher_sm4_cbc_cra_init(struct crypto_tfm *tfm)

 	safexcel_skcipher_cra_init(tfm);
 	ctx->alg  = SAFEXCEL_SM4;
+	ctx->blocksz = SM4_BLOCK_SIZE;
 	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CBC;
 	return 0;
 }
@@ -3083,6 +3182,7 @@ static int safexcel_skcipher_sm4_ofb_cra_init(struct crypto_tfm *tfm)

 	safexcel_skcipher_cra_init(tfm);
 	ctx->alg  = SAFEXCEL_SM4;
+	ctx->blocksz = SM4_BLOCK_SIZE;
 	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_OFB;
 	return 0;
 }
@@ -3119,6 +3219,7 @@ static int safexcel_skcipher_sm4_cfb_cra_init(struct crypto_tfm *tfm)

 	safexcel_skcipher_cra_init(tfm);
 	ctx->alg  = SAFEXCEL_SM4;
+	ctx->blocksz = SM4_BLOCK_SIZE;
 	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CFB;
 	return 0;
 }
@@ -3169,6 +3270,7 @@ static int safexcel_skcipher_sm4_ctr_cra_init(struct crypto_tfm *tfm)

 	safexcel_skcipher_cra_init(tfm);
 	ctx->alg  = SAFEXCEL_SM4;
+	ctx->blocksz = SM4_BLOCK_SIZE;
 	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD;
 	return 0;
 }
@@ -3228,6 +3330,7 @@ static int safexcel_aead_sm4cbc_sha1_cra_init(struct crypto_tfm *tfm)

 	safexcel_aead_cra_init(tfm);
 	ctx->alg = SAFEXCEL_SM4;
+	ctx->blocksz = SM4_BLOCK_SIZE;
 	ctx->hash_alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA1;
 	ctx->state_sz = SHA1_DIGEST_SIZE;
 	return 0;
@@ -3335,6 +3438,7 @@ static int safexcel_aead_sm4cbc_sm3_cra_init(struct crypto_tfm *tfm)

 	safexcel_aead_fallback_cra_init(tfm);
 	ctx->alg = SAFEXCEL_SM4;
+	ctx->blocksz = SM4_BLOCK_SIZE;
 	ctx->hash_alg = CONTEXT_CONTROL_CRYPTO_ALG_SM3;
 	ctx->state_sz = SM3_DIGEST_SIZE;
 	return 0;
@@ -3473,6 +3577,7 @@ static int safexcel_rfc4106_gcm_cra_init(struct crypto_tfm *tfm)

 	ret = safexcel_aead_gcm_cra_init(tfm);
 	ctx->aead  = EIP197_AEAD_TYPE_IPSEC_ESP;
+	ctx->aadskip = EIP197_AEAD_IPSEC_IV_SIZE;
 	return ret;
 }

@@ -3607,6 +3712,7 @@ static int safexcel_rfc4309_ccm_cra_init(struct crypto_tfm *tfm)

 	ret = safexcel_aead_ccm_cra_init(tfm);
 	ctx->aead  = EIP197_AEAD_TYPE_IPSEC_ESP;
+	ctx->aadskip = EIP197_AEAD_IPSEC_IV_SIZE;
 	return ret;
 }

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 2134dae..ef3a489 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -87,12 +87,14 @@ static void safexcel_hash_token(struct safexcel_command_desc *cdesc,

 	input_length &= 15;
 	if (unlikely(cbcmac && input_length)) {
+		token[0].stat =  0;
 		token[1].opcode = EIP197_TOKEN_OPCODE_INSERT;
 		token[1].packet_length = 16 - input_length;
 		token[1].stat = EIP197_TOKEN_STAT_LAST_HASH;
 		token[1].instructions = EIP197_TOKEN_INS_TYPE_HASH;
 	} else {
 		token[0].stat = EIP197_TOKEN_STAT_LAST_HASH;
+		eip197_noop_token(&token[1]);
 	}

 	token[2].opcode = EIP197_TOKEN_OPCODE_INSERT;
@@ -101,6 +103,8 @@ static void safexcel_hash_token(struct safexcel_command_desc *cdesc,
 	token[2].packet_length = result_length;
 	token[2].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT |
 				EIP197_TOKEN_INS_INSERT_HASH_DIGEST;
+
+	eip197_noop_token(&token[3]);
 }

 static void safexcel_context_control(struct safexcel_ahash_ctx *ctx,
@@ -111,6 +115,7 @@ static void safexcel_context_control(struct safexcel_ahash_ctx *ctx,
 	u64 count = 0;

 	cdesc->control_data.control0 = ctx->alg;
+	cdesc->control_data.control1 = 0;

 	/*
 	 * Copy the input digest if needed, and setup the context
@@ -314,6 +319,7 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 	struct safexcel_command_desc *cdesc, *first_cdesc = NULL;
 	struct safexcel_result_desc *rdesc;
 	struct scatterlist *sg;
+	struct safexcel_token *dmmy;
 	int i, extra = 0, n_cdesc = 0, ret = 0, cache_len, skip = 0;
 	u64 queued, len;

@@ -397,7 +403,8 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 		first_cdesc = safexcel_add_cdesc(priv, ring, 1,
 						 (cache_len == len),
 						 req->cache_dma, cache_len,
-						 len, ctx->base.ctxr_dma);
+						 len, ctx->base.ctxr_dma,
+						 &dmmy);
 		if (IS_ERR(first_cdesc)) {
 			ret = PTR_ERR(first_cdesc);
 			goto unmap_cache;
@@ -436,7 +443,7 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 		cdesc = safexcel_add_cdesc(priv, ring, !n_cdesc,
 					   !(queued - sglen),
 					   sg_dma_address(sg) + skip, sglen,
-					   len, ctx->base.ctxr_dma);
+					   len, ctx->base.ctxr_dma, &dmmy);
 		if (IS_ERR(cdesc)) {
 			ret = PTR_ERR(cdesc);
 			goto unmap_sg;
diff --git a/drivers/crypto/inside-secure/safexcel_ring.c b/drivers/crypto/inside-secure/safexcel_ring.c
index 9237ba7..e454c3d 100644
--- a/drivers/crypto/inside-secure/safexcel_ring.c
+++ b/drivers/crypto/inside-secure/safexcel_ring.c
@@ -14,6 +14,11 @@ int safexcel_init_ring_descriptors(struct safexcel_crypto_priv *priv,
 				   struct safexcel_desc_ring *cdr,
 				   struct safexcel_desc_ring *rdr)
 {
+	int i;
+	struct safexcel_command_desc *cdesc;
+	dma_addr_t atok;
+
+	/* Actual command descriptor ring */
 	cdr->offset = priv->config.cd_offset;
 	cdr->base = dmam_alloc_coherent(priv->dev,
 					cdr->offset * EIP197_DEFAULT_RING_SIZE,
@@ -24,7 +29,34 @@ int safexcel_init_ring_descriptors(struct safexcel_crypto_priv *priv,
 	cdr->base_end = cdr->base + cdr->offset * (EIP197_DEFAULT_RING_SIZE - 1);
 	cdr->read = cdr->base;

+	/* Command descriptor shadow ring for storing additional token data */
+	cdr->shoffset = priv->config.cdsh_offset;
+	cdr->shbase = dmam_alloc_coherent(priv->dev,
+					  cdr->shoffset *
+					  EIP197_DEFAULT_RING_SIZE,
+					  &cdr->shbase_dma, GFP_KERNEL);
+	if (!cdr->shbase)
+		return -ENOMEM;
+	cdr->shwrite = cdr->shbase;
+	cdr->shbase_end = cdr->shbase + cdr->shoffset *
+					(EIP197_DEFAULT_RING_SIZE - 1);
+
+	/*
+	 * Populate command descriptors with physical pointers to shadow descs.
+	 * Note that we only need to do this once if we don't overwrite them.
+	 */
+	cdesc = cdr->base;
+	atok = cdr->shbase_dma;
+	for (i = 0; i < EIP197_DEFAULT_RING_SIZE; i++) {
+		cdesc->atok_lo = lower_32_bits(atok);
+		cdesc->atok_hi = upper_32_bits(atok);
+		cdesc = (void *)cdesc + cdr->offset;
+		atok += cdr->shoffset;
+	}
+
 	rdr->offset = priv->config.rd_offset;
+	/* Use shoffset for result token offset here */
+	rdr->shoffset = priv->config.res_offset;
 	rdr->base = dmam_alloc_coherent(priv->dev,
 					rdr->offset * EIP197_DEFAULT_RING_SIZE,
 					&rdr->base_dma, GFP_KERNEL);
@@ -42,11 +74,40 @@ inline int safexcel_select_ring(struct safexcel_crypto_priv *priv)
 	return (atomic_inc_return(&priv->ring_used) % priv->config.rings);
 }

-static void *safexcel_ring_next_wptr(struct safexcel_crypto_priv *priv,
-				     struct safexcel_desc_ring *ring)
+static void *safexcel_ring_next_cwptr(struct safexcel_crypto_priv *priv,
+				     struct safexcel_desc_ring *ring,
+				     bool first,
+				     struct safexcel_token **atoken)
 {
 	void *ptr = ring->write;

+	if (first)
+		*atoken = ring->shwrite;
+
+	if ((ring->write == ring->read - ring->offset) ||
+	    (ring->read == ring->base && ring->write == ring->base_end))
+		return ERR_PTR(-ENOMEM);
+
+	if (ring->write == ring->base_end) {
+		ring->write = ring->base;
+		ring->shwrite = ring->shbase;
+	} else {
+		ring->write += ring->offset;
+		ring->shwrite += ring->shoffset;
+	}
+
+	return ptr;
+}
+
+static void *safexcel_ring_next_rwptr(struct safexcel_crypto_priv *priv,
+				     struct safexcel_desc_ring *ring,
+				     struct result_data_desc **rtoken)
+{
+	void *ptr = ring->write;
+
+	/* Result token at relative offset shoffset */
+	*rtoken = ring->write + ring->shoffset;
+
 	if ((ring->write == ring->read - ring->offset) ||
 	    (ring->read == ring->base && ring->write == ring->base_end))
 		return ERR_PTR(-ENOMEM);
@@ -106,10 +167,13 @@ void safexcel_ring_rollback_wptr(struct safexcel_crypto_priv *priv,
 	if (ring->write == ring->read)
 		return;

-	if (ring->write == ring->base)
+	if (ring->write == ring->base) {
 		ring->write = ring->base_end;
-	else
+		ring->shwrite = ring->shbase_end;
+	} else {
 		ring->write -= ring->offset;
+		ring->shwrite -= ring->shoffset;
+	}
 }

 struct safexcel_command_desc *safexcel_add_cdesc(struct safexcel_crypto_priv *priv,
@@ -117,26 +181,26 @@ struct safexcel_command_desc *safexcel_add_cdesc(struct safexcel_crypto_priv *pr
 						 bool first, bool last,
 						 dma_addr_t data, u32 data_len,
 						 u32 full_data_len,
-						 dma_addr_t context) {
+						 dma_addr_t context,
+						 struct safexcel_token **atoken)
+{
 	struct safexcel_command_desc *cdesc;
-	int i;

-	cdesc = safexcel_ring_next_wptr(priv, &priv->ring[ring_id].cdr);
+	cdesc = safexcel_ring_next_cwptr(priv, &priv->ring[ring_id].cdr,
+					 first, atoken);
 	if (IS_ERR(cdesc))
 		return cdesc;

-	memset(cdesc, 0, sizeof(struct safexcel_command_desc));
-
-	cdesc->first_seg = first;
-	cdesc->last_seg = last;
 	cdesc->particle_size = data_len;
+	cdesc->rsvd0 = 0;
+	cdesc->last_seg = last;
+	cdesc->first_seg = first;
+	cdesc->additional_cdata_size = 0;
+	cdesc->rsvd1 = 0;
 	cdesc->data_lo = lower_32_bits(data);
 	cdesc->data_hi = upper_32_bits(data);

-	if (first && context) {
-		struct safexcel_token *token =
-			(struct safexcel_token *)cdesc->control_data.token;
-
+	if (first) {
 		/*
 		 * Note that the length here MUST be >0 or else the EIP(1)97
 		 * may hang. Newer EIP197 firmware actually incorporates this
@@ -146,20 +210,12 @@ struct safexcel_command_desc *safexcel_add_cdesc(struct safexcel_crypto_priv *pr
 		cdesc->control_data.packet_length = full_data_len ?: 1;
 		cdesc->control_data.options = EIP197_OPTION_MAGIC_VALUE |
 					      EIP197_OPTION_64BIT_CTX |
-					      EIP197_OPTION_CTX_CTRL_IN_CMD;
-		cdesc->control_data.context_lo =
-			(lower_32_bits(context) & GENMASK(31, 2)) >> 2;
+					      EIP197_OPTION_CTX_CTRL_IN_CMD |
+					      EIP197_OPTION_RC_AUTO;
+		cdesc->control_data.type = EIP197_TYPE_BCLA;
+		cdesc->control_data.context_lo = lower_32_bits(context) |
+						 EIP197_CONTEXT_SMALL;
 		cdesc->control_data.context_hi = upper_32_bits(context);
-
-		if (priv->version == EIP197B_MRVL ||
-		    priv->version == EIP197D_MRVL)
-			cdesc->control_data.options |= EIP197_OPTION_RC_AUTO;
-
-		/* TODO: large xform HMAC with SHA-384/512 uses refresh = 3 */
-		cdesc->control_data.refresh = 2;
-
-		for (i = 0; i < EIP197_MAX_TOKENS; i++)
-			eip197_noop_token(&token[i]);
 	}

 	return cdesc;
@@ -171,19 +227,27 @@ struct safexcel_result_desc *safexcel_add_rdesc(struct safexcel_crypto_priv *pri
 						dma_addr_t data, u32 len)
 {
 	struct safexcel_result_desc *rdesc;
+	struct result_data_desc *rtoken;

-	rdesc = safexcel_ring_next_wptr(priv, &priv->ring[ring_id].rdr);
+	rdesc = safexcel_ring_next_rwptr(priv, &priv->ring[ring_id].rdr,
+					 &rtoken);
 	if (IS_ERR(rdesc))
 		return rdesc;

-	memset(rdesc, 0, sizeof(struct safexcel_result_desc));
-
-	rdesc->first_seg = first;
+	rdesc->particle_size = len;
+	rdesc->rsvd0 = 0;
+	rdesc->descriptor_overflow = 0;
+	rdesc->buffer_overflow = 0;
 	rdesc->last_seg = last;
+	rdesc->first_seg = first;
 	rdesc->result_size = EIP197_RD64_RESULT_SIZE;
-	rdesc->particle_size = len;
+	rdesc->rsvd1 = 0;
 	rdesc->data_lo = lower_32_bits(data);
 	rdesc->data_hi = upper_32_bits(data);

+	/* Clear length & error code in result token */
+	rtoken->packet_length = 0;
+	rtoken->error_code = 0;
+
 	return rdesc;
 }
--
1.8.3.1
