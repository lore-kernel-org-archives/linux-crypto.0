Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CFEDC001C7
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F3B864F8F
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbhCDAHh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444146AbhCCPBU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Mar 2021 10:01:20 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33C6C061225
        for <linux-crypto@vger.kernel.org>; Wed,  3 Mar 2021 06:34:58 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id h98so23906120wrh.11
        for <linux-crypto@vger.kernel.org>; Wed, 03 Mar 2021 06:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=erPTjshbhLchKwQuh0XQUk+wc12RIGoz2km1xclT6d4=;
        b=EZo0F/vKAXWlIQpH9PKqPP4VUz1vgWxjmgaL0A6IOrX4Zm0mz5zh/eOsJsT7Ux1gDE
         0axE6MsOpRohAXChk1J5cnJWf7/gDUt2CVNwx30l8yc5VjW7th/ct4aaoqAZEwEtvDG+
         mmbx22dFlouq+ky0S9Htp2vFGaRw08CdjsDXm82grykQNcw2DJYMK40jMC0GZYNEFFYa
         +aiNEQak2YYfkMoanJIjD2hCSRejCvGH9cRrD576TpYHImXZG3w6yXlcW/wwB1/u2zau
         bHCjf0S9B7APGQqDcwzzwqG7ISsbitDdvaVbBwBxHIvZf7+pn7rSxVtQr1cyf6h2rNVg
         Kb8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=erPTjshbhLchKwQuh0XQUk+wc12RIGoz2km1xclT6d4=;
        b=k5o3DYnwu2pL//uJSWeOwFVz8565VVXGK/q1F4556tU4dJMi22HnrEQ7Z7tAbjZMh7
         jbVfyL2iKt2/LVy2l17Gbtpe4TMormKt65S7HlK+PQh0QZjuz4/s0EbIopjVu8Zqms6S
         QWHMkHCsi2Lcw00k9197rdfnweMNwMh6w3xEP71BFlqdgef4DxhHI8kabxVrvx334tlA
         qY7ZVLd6E9hrgQfEcIc7Uf4lE9pAA7QVoCIwaitELcIC/59wsXzPpBPJSNebLHxq7TMa
         bSfMWvTrTvB4PdMYowpfDa0yHo3l+EFYEkPps55mbbdJwBHszxQxm7FF3EUNpi/SKyDv
         LCXw==
X-Gm-Message-State: AOAM533Av3U44Un6MlWUw2mispmeWV4/E5De0QBPU9zU7ZnI2jz9wADV
        uIUAcH1J07ZU50We9iBD+W6tsA==
X-Google-Smtp-Source: ABdhPJysfJFi1Ht/iBLsCA6KO+d9zXB1Q5jZOY/aNyGPlLgX2TCgqkySNK0y6vBlm2Yqk6SIU3NEPQ==
X-Received: by 2002:adf:fbce:: with SMTP id d14mr26519347wrs.44.1614782097568;
        Wed, 03 Mar 2021 06:34:57 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id f16sm31475923wrt.21.2021.03.03.06.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:34:56 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Rice <rob.rice@broadcom.com>, linux-crypto@vger.kernel.org
Subject: [PATCH 02/10] crypto: bcm: Fix a whole host of kernel-doc misdemeanours
Date:   Wed,  3 Mar 2021 14:34:41 +0000
Message-Id: <20210303143449.3170813-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303143449.3170813-1-lee.jones@linaro.org>
References: <20210303143449.3170813-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/crypto/bcm/util.c:136: warning: Function parameter or member 'from_nents' not described in 'spu_msg_sg_add'
 drivers/crypto/bcm/util.c:136: warning: Function parameter or member 'length' not described in 'spu_msg_sg_add'
 drivers/crypto/bcm/spu.c:464: warning: Excess function parameter 'Return' description in 'spum_gcm_ccm_pad_len'
 drivers/crypto/bcm/spu.c:524: warning: Function parameter or member 'iv_len' not described in 'spum_aead_ivlen'
 drivers/crypto/bcm/spu.c:524: warning: expecting prototype for spu_aead_ivlen(). Prototype was for spum_aead_ivlen() instead
 drivers/crypto/bcm/spu.c:556: warning: Function parameter or member 'alg_digest_size' not described in 'spum_digest_size'
 drivers/crypto/bcm/spu.c:556: warning: Function parameter or member 'alg' not described in 'spum_digest_size'
 drivers/crypto/bcm/spu.c:556: warning: Function parameter or member 'htype' not described in 'spum_digest_size'
 drivers/crypto/bcm/spu.c:583: warning: bad line:
 drivers/crypto/bcm/spu.c:927: warning: Function parameter or member 'is_inbound' not described in 'spum_cipher_req_finish'
 drivers/crypto/bcm/spu.c:927: warning: Excess function parameter 'isInbound' description in 'spum_cipher_req_finish'
 drivers/crypto/bcm/spu2.c:557: warning: Function parameter or member 'fmd' not described in 'spu2_fmd_init'
 drivers/crypto/bcm/spu2.c:557: warning: Function parameter or member 'spu2_type' not described in 'spu2_fmd_init'
 drivers/crypto/bcm/spu2.c:557: warning: Excess function parameter 'spu2_cipher_type' description in 'spu2_fmd_init'
 drivers/crypto/bcm/spu2.c:615: warning: Function parameter or member 'auth_first' not described in 'spu2_fmd_ctrl0_write'
 drivers/crypto/bcm/spu2.c:615: warning: Excess function parameter 'authFirst' description in 'spu2_fmd_ctrl0_write'
 drivers/crypto/bcm/spu2.c:666: warning: Function parameter or member 'is_inbound' not described in 'spu2_fmd_ctrl1_write'
 drivers/crypto/bcm/spu2.c:803: warning: expecting prototype for spu_payload_length(). Prototype was for spu2_payload_length() instead
 drivers/crypto/bcm/spu2.c:825: warning: Function parameter or member 'is_hash' not described in 'spu2_response_hdr_len'
 drivers/crypto/bcm/spu2.c:825: warning: expecting prototype for spu_response_hdr_len(). Prototype was for spu2_response_hdr_len() instead
 drivers/crypto/bcm/spu2.c:843: warning: expecting prototype for spu_hash_pad_len(). Prototype was for spu2_hash_pad_len() instead
 drivers/crypto/bcm/spu2.c:855: warning: Function parameter or member 'cipher_mode' not described in 'spu2_gcm_ccm_pad_len'
 drivers/crypto/bcm/spu2.c:855: warning: Function parameter or member 'data_size' not described in 'spu2_gcm_ccm_pad_len'
 drivers/crypto/bcm/spu2.c:855: warning: expecting prototype for spu2_gcm_ccm_padlen(). Prototype was for spu2_gcm_ccm_pad_len() instead
 drivers/crypto/bcm/spu2.c:872: warning: expecting prototype for spu_assoc_resp_len(). Prototype was for spu2_assoc_resp_len() instead
 drivers/crypto/bcm/spu2.c:919: warning: Function parameter or member 'alg_digest_size' not described in 'spu2_digest_size'
 drivers/crypto/bcm/spu2.c:919: warning: Function parameter or member 'alg' not described in 'spu2_digest_size'
 drivers/crypto/bcm/spu2.c:919: warning: Function parameter or member 'htype' not described in 'spu2_digest_size'
 drivers/crypto/bcm/spu2.c:945: warning: expecting prototype for spu_create_request(). Prototype was for spu2_create_request() instead
 drivers/crypto/bcm/spu2.c:1122: warning: expecting prototype for spu_cipher_req_init(). Prototype was for spu2_cipher_req_init() instead
 drivers/crypto/bcm/spu2.c:1182: warning: Function parameter or member 'is_inbound' not described in 'spu2_cipher_req_finish'
 drivers/crypto/bcm/spu2.c:1182: warning: expecting prototype for spu_cipher_req_finish(). Prototype was for spu2_cipher_req_finish() instead
 drivers/crypto/bcm/spu2.c:1243: warning: expecting prototype for spu_request_pad(). Prototype was for spu2_request_pad() instead
 drivers/crypto/bcm/spu2.c:1321: warning: expecting prototype for spu_status_process(). Prototype was for spu2_status_process() instead
 drivers/crypto/bcm/cipher.c:1048: warning: Function parameter or member 'req' not described in 'spu_aead_rx_sg_create'
 drivers/crypto/bcm/cipher.c:2966: warning: Function parameter or member 'cipher' not described in 'rfc4543_gcm_esp_setkey'
 drivers/crypto/bcm/cipher.c:2966: warning: Function parameter or member 'key' not described in 'rfc4543_gcm_esp_setkey'
 drivers/crypto/bcm/cipher.c:2966: warning: Function parameter or member 'keylen' not described in 'rfc4543_gcm_esp_setkey'

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Rob Rice <rob.rice@broadcom.com>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/bcm/cipher.c |  7 +++---
 drivers/crypto/bcm/spu.c    | 16 +++++++-------
 drivers/crypto/bcm/spu2.c   | 43 +++++++++++++++++++++----------------
 drivers/crypto/bcm/util.c   |  4 ++--
 4 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 851b149f71701..053315e260c22 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -1019,6 +1019,7 @@ static void handle_ahash_resp(struct iproc_reqctx_s *rctx)
  * a SPU response message for an AEAD request. Includes buffers to catch SPU
  * message headers and the response data.
  * @mssg:	mailbox message containing the receive sg
+ * @req:	Crypto API request
  * @rctx:	crypto request context
  * @rx_frag_num: number of scatterlist elements required to hold the
  *		SPU response message
@@ -2952,9 +2953,9 @@ static int aead_gcm_esp_setkey(struct crypto_aead *cipher,
 
 /**
  * rfc4543_gcm_esp_setkey() - setkey operation for RFC4543 variant of GCM/GMAC.
- * cipher: AEAD structure
- * key:    Key followed by 4 bytes of salt
- * keylen: Length of key plus salt, in bytes
+ * @cipher: AEAD structure
+ * @key:    Key followed by 4 bytes of salt
+ * @keylen: Length of key plus salt, in bytes
  *
  * Extracts salt from key and stores it to be prepended to IV on each request.
  * Digest is always 16 bytes
diff --git a/drivers/crypto/bcm/spu.c b/drivers/crypto/bcm/spu.c
index 007abf92cc05b..6283e8c6d51d3 100644
--- a/drivers/crypto/bcm/spu.c
+++ b/drivers/crypto/bcm/spu.c
@@ -457,7 +457,7 @@ u16 spum_hash_pad_len(enum hash_alg hash_alg, enum hash_mode hash_mode,
  * @cipher_mode:	Algo type
  * @data_size:		Length of plaintext (bytes)
  *
- * @Return: Length of padding, in bytes
+ * Return: Length of padding, in bytes
  */
 u32 spum_gcm_ccm_pad_len(enum spu_cipher_mode cipher_mode,
 			 unsigned int data_size)
@@ -510,10 +510,10 @@ u32 spum_assoc_resp_len(enum spu_cipher_mode cipher_mode,
 }
 
 /**
- * spu_aead_ivlen() - Calculate the length of the AEAD IV to be included
+ * spum_aead_ivlen() - Calculate the length of the AEAD IV to be included
  * in a SPU request after the AAD and before the payload.
  * @cipher_mode:  cipher mode
- * @iv_ctr_len:   initialization vector length in bytes
+ * @iv_len:   initialization vector length in bytes
  *
  * In Linux ~4.2 and later, the assoc_data sg includes the IV. So no need
  * to include the IV as a separate field in the SPU request msg.
@@ -543,9 +543,9 @@ enum hash_type spum_hash_type(u32 src_sent)
 /**
  * spum_digest_size() - Determine the size of a hash digest to expect the SPU to
  * return.
- * alg_digest_size: Number of bytes in the final digest for the given algo
- * alg:             The hash algorithm
- * htype:           Type of hash operation (init, update, full, etc)
+ * @alg_digest_size: Number of bytes in the final digest for the given algo
+ * @alg:             The hash algorithm
+ * @htype:           Type of hash operation (init, update, full, etc)
  *
  * When doing incremental hashing for an algorithm with a truncated hash
  * (e.g., SHA224), the SPU returns the full digest so that it can be fed back as
@@ -580,7 +580,7 @@ u32 spum_digest_size(u32 alg_digest_size, enum hash_alg alg,
  * @aead_parms:   Parameters related to AEAD operation
  * @data_size:    Length of data to be encrypted or authenticated. If AEAD, does
  *		  not include length of AAD.
-
+ *
  * Return: the length of the SPU header in bytes. 0 if an error occurs.
  */
 u32 spum_create_request(u8 *spu_hdr,
@@ -911,7 +911,7 @@ u16 spum_cipher_req_init(u8 *spu_hdr, struct spu_cipher_parms *cipher_parms)
  * setkey() time in spu_cipher_req_init().
  * @spu_hdr:         Start of the request message header (MH field)
  * @spu_req_hdr_len: Length in bytes of the SPU request header
- * @isInbound:       0 encrypt, 1 decrypt
+ * @is_inbound:      0 encrypt, 1 decrypt
  * @cipher_parms:    Parameters describing cipher operation to be performed
  * @data_size:       Length of the data in the BD field
  *
diff --git a/drivers/crypto/bcm/spu2.c b/drivers/crypto/bcm/spu2.c
index 2db35b5ccaa24..07989bb8c220a 100644
--- a/drivers/crypto/bcm/spu2.c
+++ b/drivers/crypto/bcm/spu2.c
@@ -543,7 +543,8 @@ void spu2_dump_msg_hdr(u8 *buf, unsigned int buf_len)
 /**
  * spu2_fmd_init() - At setkey time, initialize the fixed meta data for
  * subsequent skcipher requests for this context.
- * @spu2_cipher_type:  Cipher algorithm
+ * @fmd:               Start of FMD field to be written
+ * @spu2_type:         Cipher algorithm
  * @spu2_mode:         Cipher mode
  * @cipher_key_len:    Length of cipher key, in bytes
  * @cipher_iv_len:     Length of cipher initialization vector, in bytes
@@ -598,7 +599,7 @@ static int spu2_fmd_init(struct SPU2_FMD *fmd,
  * SPU request packet.
  * @fmd:            Start of FMD field to be written
  * @is_inbound:     true if decrypting. false if encrypting.
- * @authFirst:      true if alg authenticates before encrypting
+ * @auth_first:     true if alg authenticates before encrypting
  * @protocol:       protocol selector
  * @cipher_type:    cipher algorithm
  * @cipher_mode:    cipher mode
@@ -640,6 +641,7 @@ static void spu2_fmd_ctrl0_write(struct SPU2_FMD *fmd,
  * spu2_fmd_ctrl1_write() - Write ctrl1 field in fixed metadata (FMD) field of
  * SPU request packet.
  * @fmd:            Start of FMD field to be written
+ * @is_inbound:     true if decrypting. false if encrypting.
  * @assoc_size:     Length of additional associated data, in bytes
  * @auth_key_len:   Length of authentication key, in bytes
  * @cipher_key_len: Length of cipher key, in bytes
@@ -793,7 +795,7 @@ u32 spu2_ctx_max_payload(enum spu_cipher_alg cipher_alg,
 }
 
 /**
- * spu_payload_length() -  Given a SPU2 message header, extract the payload
+ * spu2_payload_length() -  Given a SPU2 message header, extract the payload
  * length.
  * @spu_hdr:  Start of SPU message header (FMD)
  *
@@ -812,10 +814,11 @@ u32 spu2_payload_length(u8 *spu_hdr)
 }
 
 /**
- * spu_response_hdr_len() - Determine the expected length of a SPU response
+ * spu2_response_hdr_len() - Determine the expected length of a SPU response
  * header.
  * @auth_key_len:  Length of authentication key, in bytes
  * @enc_key_len:   Length of encryption key, in bytes
+ * @is_hash:       Unused
  *
  * For SPU2, includes just FMD. OMD is never requested.
  *
@@ -827,7 +830,7 @@ u16 spu2_response_hdr_len(u16 auth_key_len, u16 enc_key_len, bool is_hash)
 }
 
 /**
- * spu_hash_pad_len() - Calculate the length of hash padding required to extend
+ * spu2_hash_pad_len() - Calculate the length of hash padding required to extend
  * data to a full block size.
  * @hash_alg:        hash algorithm
  * @hash_mode:       hash mode
@@ -845,8 +848,10 @@ u16 spu2_hash_pad_len(enum hash_alg hash_alg, enum hash_mode hash_mode,
 }
 
 /**
- * spu2_gcm_ccm_padlen() -  Determine the length of GCM/CCM padding for either
+ * spu2_gcm_ccm_pad_len() -  Determine the length of GCM/CCM padding for either
  * the AAD field or the data.
+ * @cipher_mode:  Unused
+ * @data_size:    Unused
  *
  * Return:  0. Unlike SPU-M, SPU2 hardware does any GCM/CCM padding required.
  */
@@ -857,7 +862,7 @@ u32 spu2_gcm_ccm_pad_len(enum spu_cipher_mode cipher_mode,
 }
 
 /**
- * spu_assoc_resp_len() - Determine the size of the AAD2 buffer needed to catch
+ * spu2_assoc_resp_len() - Determine the size of the AAD2 buffer needed to catch
  * associated data in a SPU2 output packet.
  * @cipher_mode:   cipher mode
  * @assoc_len:     length of additional associated data, in bytes
@@ -878,11 +883,11 @@ u32 spu2_assoc_resp_len(enum spu_cipher_mode cipher_mode,
 	return resp_len;
 }
 
-/*
- * spu_aead_ivlen() - Calculate the length of the AEAD IV to be included
+/**
+ * spu2_aead_ivlen() - Calculate the length of the AEAD IV to be included
  * in a SPU request after the AAD and before the payload.
  * @cipher_mode:  cipher mode
- * @iv_ctr_len:   initialization vector length in bytes
+ * @iv_len:   initialization vector length in bytes
  *
  * For SPU2, AEAD IV is included in OMD and does not need to be repeated
  * prior to the payload.
@@ -909,9 +914,9 @@ enum hash_type spu2_hash_type(u32 src_sent)
 /**
  * spu2_digest_size() - Determine the size of a hash digest to expect the SPU to
  * return.
- * alg_digest_size: Number of bytes in the final digest for the given algo
- * alg:             The hash algorithm
- * htype:           Type of hash operation (init, update, full, etc)
+ * @alg_digest_size: Number of bytes in the final digest for the given algo
+ * @alg:             The hash algorithm
+ * @htype:           Type of hash operation (init, update, full, etc)
  *
  */
 u32 spu2_digest_size(u32 alg_digest_size, enum hash_alg alg,
@@ -921,7 +926,7 @@ u32 spu2_digest_size(u32 alg_digest_size, enum hash_alg alg,
 }
 
 /**
- * spu_create_request() - Build a SPU2 request message header, includint FMD and
+ * spu2_create_request() - Build a SPU2 request message header, includint FMD and
  * OMD.
  * @spu_hdr: Start of buffer where SPU request header is to be written
  * @req_opts: SPU request message options
@@ -1105,7 +1110,7 @@ u32 spu2_create_request(u8 *spu_hdr,
 }
 
 /**
- * spu_cipher_req_init() - Build an skcipher SPU2 request message header,
+ * spu2_cipher_req_init() - Build an skcipher SPU2 request message header,
  * including FMD and OMD.
  * @spu_hdr:       Location of start of SPU request (FMD field)
  * @cipher_parms:  Parameters describing cipher request
@@ -1162,11 +1167,11 @@ u16 spu2_cipher_req_init(u8 *spu_hdr, struct spu_cipher_parms *cipher_parms)
 }
 
 /**
- * spu_cipher_req_finish() - Finish building a SPU request message header for a
+ * spu2_cipher_req_finish() - Finish building a SPU request message header for a
  * block cipher request.
  * @spu_hdr:         Start of the request message header (MH field)
  * @spu_req_hdr_len: Length in bytes of the SPU request header
- * @isInbound:       0 encrypt, 1 decrypt
+ * @is_inbound:      0 encrypt, 1 decrypt
  * @cipher_parms:    Parameters describing cipher operation to be performed
  * @data_size:       Length of the data in the BD field
  *
@@ -1222,7 +1227,7 @@ void spu2_cipher_req_finish(u8 *spu_hdr,
 }
 
 /**
- * spu_request_pad() - Create pad bytes at the end of the data.
+ * spu2_request_pad() - Create pad bytes at the end of the data.
  * @pad_start:      Start of buffer where pad bytes are to be written
  * @gcm_padding:    Length of GCM padding, in bytes
  * @hash_pad_len:   Number of bytes of padding extend data to full block
@@ -1311,7 +1316,7 @@ u8 spu2_rx_status_len(void)
 }
 
 /**
- * spu_status_process() - Process the status from a SPU response message.
+ * spu2_status_process() - Process the status from a SPU response message.
  * @statp:  start of STATUS word
  *
  * Return:  0 - if status is good and response should be processed
diff --git a/drivers/crypto/bcm/util.c b/drivers/crypto/bcm/util.c
index c4669a96eaecf..d5d9cabea55aa 100644
--- a/drivers/crypto/bcm/util.c
+++ b/drivers/crypto/bcm/util.c
@@ -119,8 +119,8 @@ int spu_sg_count(struct scatterlist *sg_list, unsigned int skip, int nbytes)
  * @from_skip:   number of bytes to skip in from_sg. Non-zero when previous
  *		 request included part of the buffer in entry in from_sg.
  *		 Assumes from_skip < from_sg->length.
- * @from_nents   number of entries in from_sg
- * @length       number of bytes to copy. may reach this limit before exhausting
+ * @from_nents:  number of entries in from_sg
+ * @length:      number of bytes to copy. may reach this limit before exhausting
  *		 from_sg.
  *
  * Copies the entries themselves, not the data in the entries. Assumes to_sg has
-- 
2.27.0

