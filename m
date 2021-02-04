Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E1DC433E6
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C39564F5C
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235675AbhBDLM0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:12:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235660AbhBDLLr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 06:11:47 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4F8C061351
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 03:10:13 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id u14so3030878wri.3
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 03:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YOJ+0stIceIdJi6gdHHRkXSCGMt50djacvzyyNbvVcw=;
        b=OkprnsvGh/4iCVbft5YmnR2Jb6HJNl6FUvgyi0ohzPlkDoyujE+PV5tWOq5p7rXNKl
         rP4BL5KekdTmr/3Ac3WvbUdHnG2gkp8ufWZCbv82f2YBnhSuCzurxhyE/1x/ENxBydTq
         rWv2ylS0JpMRPOkNLVcHpE4ifph9eOOgdJ/2LfFE066u9neRaRKJezY7RgQIFBosG4as
         S9QOX49y5XkhJAhuxvgZGZa5VCHaM9UQ4Lsgsu9jF1kzx+COOOIxm1MJ9UVP9i2kdN+t
         RGXwGtGmPIpM845VkU5T5EFqYaJpnIWN9LTh1I6I7iSndZNea1aEe5Fy/nDvEILOOAC4
         CikA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YOJ+0stIceIdJi6gdHHRkXSCGMt50djacvzyyNbvVcw=;
        b=q77HdJgv4QFq90aLTKFlj/I0og2aYID27jwBlEfdIR8cwJIx4MqujiaB4aOLUf903q
         jWG/LRoAygrowFFHataSV3MvZHJpo0Tsu1X9mDQ4y935ifzbXUxzbwtaRr//r1eTJMKx
         2JeInX6PpmUads2JKcGVyh6ZVO0xGc3osY98TtpkPrr39QV7JnUZpsLGhiKNmjDqLPrE
         GX+z/i9mDLBrsPEJ4FZMo8Qa9faFWV6eP1l/tJ78sPz7/YUpTwAfo0ksVAu2N/rrr4bS
         NcRTfIztLctCvtnoH6YOUw413s+BOvOXXVjXnEJZ3c2kj4pDrPAR/AX+0zDNPrqJ/ubY
         FOrQ==
X-Gm-Message-State: AOAM532bShoBi8bQ8yUFc1clWvrtqMozI3TDrX1cnDAhHVcp3mDm9q3/
        YYCnMDOTdzQB1B01203Sm8/U2Q==
X-Google-Smtp-Source: ABdhPJxsnmj8WFYBbrPuL737dyiQwIOcvHYZDrCiZ0g8tQ+Jk0OwlAxkU1M4333vGD76oNv/VA5yAA==
X-Received: by 2002:a5d:68c4:: with SMTP id p4mr2686890wrw.62.1612437012061;
        Thu, 04 Feb 2021 03:10:12 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id y18sm7696218wrt.19.2021.02.04.03.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 03:10:11 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 07/20] crypto: bcm: spu2: Fix a whole host of kernel-doc misdemeanours
Date:   Thu,  4 Feb 2021 11:09:47 +0000
Message-Id: <20210204111000.2800436-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204111000.2800436-1-lee.jones@linaro.org>
References: <20210204111000.2800436-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

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

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/bcm/spu2.c | 43 ++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 19 deletions(-)

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
-- 
2.25.1

