Return-Path: <SRS0=TFX5=DJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 799EDC4363D
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 12:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37CFC20719
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 12:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgJBMvP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Oct 2020 08:51:15 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:22834 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBMvO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Oct 2020 08:51:14 -0400
X-Greylist: delayed 656 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Oct 2020 08:50:59 EDT
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4C2qMN1hd7z9v3j4;
        Fri,  2 Oct 2020 14:40:00 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id lETy4g-5TmBz; Fri,  2 Oct 2020 14:40:00 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4C2qMN0ZZcz9v3j3;
        Fri,  2 Oct 2020 14:40:00 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 8BFEB8BB21;
        Fri,  2 Oct 2020 14:40:01 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id w_iSLfoI4iQU; Fri,  2 Oct 2020 14:40:01 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 7E8D38B9FF;
        Fri,  2 Oct 2020 14:40:00 +0200 (CEST)
Subject: Re: [PATCH] crypto: talitos - Fix sparse warnings
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
References: <20201002115236.GA14707@gondor.apana.org.au>
Cc:     Kim Phillips <kim.phillips@arm.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <be222fed-425b-d55c-3efc-9c4e873ccf8e@csgroup.eu>
Date:   Fri, 2 Oct 2020 14:40:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201002115236.GA14707@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

[to Kim: Are you the initial writer of this driver, or is that someone else with your name working 
at NXP ? ]

Le 02/10/2020 à 13:52, Herbert Xu a écrit :
> The talitos driver has a large number of sparse warnings.  It appears
> to have only been tested on big-endian and where cpu_to_be32 is a
> no-op.  This patch tries to sort out the confusion around the __be32
> descriptors and removes bogus cpu_to_be32 conversions on the constants.

You are probably right that it has not been taken enough care of it recently, probably my fault.

However I guess the initial intention was to avoid conversion as much as possible. Most tests and 
bit wise operations can be done regardless of the endianess, that's the reason why the endianness 
conversion was applied to constants, in order to apply them at build time and avoid converting vars 
back and forth during runtime.

I have not looked at your patch in details but I have the feeling you are defeating this initial 
purpose.

Christophe

> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index 66773892f665..fc134aa534af 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -350,13 +350,13 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
>   
>   	tail = priv->chan[ch].tail;
>   	while (priv->chan[ch].fifo[tail].desc) {
> -		__be32 hdr;
> +		u32 hdr;
>   
>   		request = &priv->chan[ch].fifo[tail];
>   
>   		/* descriptors with their done bits set don't get the error */
>   		rmb();
> -		hdr = get_request_hdr(request, is_sec1);
> +		hdr = be32_to_cpu(get_request_hdr(request, is_sec1));
>   
>   		if ((hdr & DESC_HDR_DONE) == DESC_HDR_DONE)
>   			status = 0;
> @@ -465,6 +465,7 @@ static u32 current_desc_hdr(struct device *dev, int ch)
>   	struct talitos_private *priv = dev_get_drvdata(dev);
>   	int tail, iter;
>   	dma_addr_t cur_desc;
> +	__be32 hdr;
>   
>   	cur_desc = ((u64)in_be32(priv->chan[ch].reg + TALITOS_CDPR)) << 32;
>   	cur_desc |= in_be32(priv->chan[ch].reg + TALITOS_CDPR_LO);
> @@ -478,7 +479,8 @@ static u32 current_desc_hdr(struct device *dev, int ch)
>   
>   	iter = tail;
>   	while (priv->chan[ch].fifo[iter].dma_desc != cur_desc &&
> -	       priv->chan[ch].fifo[iter].desc->next_desc != cur_desc) {
> +	       priv->chan[ch].fifo[iter].desc->next_desc !=
> +	       cpu_to_be32(cur_desc)) {
>   		iter = (iter + 1) & (priv->fifo_len - 1);
>   		if (iter == tail) {
>   			dev_err(dev, "couldn't locate current descriptor\n");
> @@ -486,16 +488,18 @@ static u32 current_desc_hdr(struct device *dev, int ch)
>   		}
>   	}
>   
> -	if (priv->chan[ch].fifo[iter].desc->next_desc == cur_desc) {
> +	if (priv->chan[ch].fifo[iter].desc->next_desc ==
> +	    cpu_to_be32(cur_desc)) {
>   		struct talitos_edesc *edesc;
>   
>   		edesc = container_of(priv->chan[ch].fifo[iter].desc,
>   				     struct talitos_edesc, desc);
> -		return ((struct talitos_desc *)
> -			(edesc->buf + edesc->dma_len))->hdr;
> -	}
> +		hdr = ((struct talitos_desc *)
> +		       (edesc->buf + edesc->dma_len))->hdr;
> +	} else
> +		hdr = priv->chan[ch].fifo[iter].desc->hdr;
>   
> -	return priv->chan[ch].fifo[iter].desc->hdr;
> +	return be32_to_cpu(hdr);
>   }
>   
>   /*
> @@ -849,7 +853,7 @@ static void talitos_unregister_rng(struct device *dev)
>   struct talitos_ctx {
>   	struct device *dev;
>   	int ch;
> -	__be32 desc_hdr_template;
> +	u32 desc_hdr_template;
>   	u8 key[TALITOS_MAX_KEY_SIZE];
>   	u8 iv[TALITOS_MAX_IV_LENGTH];
>   	dma_addr_t dma_key;
> @@ -992,7 +996,8 @@ static void ipsec_esp_unmap(struct device *dev,
>   	unsigned int ivsize = crypto_aead_ivsize(aead);
>   	unsigned int authsize = crypto_aead_authsize(aead);
>   	unsigned int cryptlen = areq->cryptlen - (encrypt ? 0 : authsize);
> -	bool is_ipsec_esp = edesc->desc.hdr & DESC_HDR_TYPE_IPSEC_ESP;
> +	bool is_ipsec_esp = be32_to_cpu(edesc->desc.hdr) &
> +			    DESC_HDR_TYPE_IPSEC_ESP;
>   	struct talitos_ptr *civ_ptr = &edesc->desc.ptr[is_ipsec_esp ? 2 : 3];
>   
>   	if (is_ipsec_esp)
> @@ -1077,7 +1082,7 @@ static void ipsec_esp_decrypt_hwauth_done(struct device *dev,
>   	ipsec_esp_unmap(dev, edesc, req, false);
>   
>   	/* check ICV auth status */
> -	if (!err && ((desc->hdr_lo & DESC_HDR_LO_ICCR1_MASK) !=
> +	if (!err && ((be32_to_cpu(desc->hdr_lo) & DESC_HDR_LO_ICCR1_MASK) !=
>   		     DESC_HDR_LO_ICCR1_PASS))
>   		err = -EBADMSG;
>   
> @@ -1206,7 +1211,8 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
>   	bool sync_needed = false;
>   	struct talitos_private *priv = dev_get_drvdata(dev);
>   	bool is_sec1 = has_ftr_sec1(priv);
> -	bool is_ipsec_esp = desc->hdr & DESC_HDR_TYPE_IPSEC_ESP;
> +	u32 desc_hdr = be32_to_cpu(desc->hdr);
> +	bool is_ipsec_esp = desc_hdr & DESC_HDR_TYPE_IPSEC_ESP;
>   	struct talitos_ptr *civ_ptr = &desc->ptr[is_ipsec_esp ? 2 : 3];
>   	struct talitos_ptr *ckey_ptr = &desc->ptr[is_ipsec_esp ? 3 : 2];
>   	dma_addr_t dma_icv = edesc->dma_link_tbl + edesc->dma_len - authsize;
> @@ -1245,7 +1251,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
>   	 * extent is bytes of HMAC postpended to ciphertext,
>   	 * typically 12 for ipsec
>   	 */
> -	if (is_ipsec_esp && (desc->hdr & DESC_HDR_MODE1_MDEU_CICV))
> +	if (is_ipsec_esp && (desc_hdr & DESC_HDR_MODE1_MDEU_CICV))
>   		elen = authsize;
>   
>   	ret = talitos_sg_map_ext(dev, areq->src, cryptlen, edesc, &desc->ptr[4],
> @@ -1438,7 +1444,8 @@ static int aead_encrypt(struct aead_request *req)
>   		return PTR_ERR(edesc);
>   
>   	/* set encrypt */
> -	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
> +	edesc->desc.hdr = cpu_to_be32(ctx->desc_hdr_template |
> +				      DESC_HDR_MODE0_ENCRYPT);
>   
>   	return ipsec_esp(edesc, req, true, ipsec_esp_encrypt_done);
>   }
> @@ -1457,15 +1464,15 @@ static int aead_decrypt(struct aead_request *req)
>   	if (IS_ERR(edesc))
>   		return PTR_ERR(edesc);
>   
> -	if ((edesc->desc.hdr & DESC_HDR_TYPE_IPSEC_ESP) &&
> +	if ((be32_to_cpu(edesc->desc.hdr) & DESC_HDR_TYPE_IPSEC_ESP) &&
>   	    (priv->features & TALITOS_FTR_HW_AUTH_CHECK) &&
>   	    ((!edesc->src_nents && !edesc->dst_nents) ||
>   	     priv->features & TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT)) {
>   
>   		/* decrypt and check the ICV */
> -		edesc->desc.hdr = ctx->desc_hdr_template |
> -				  DESC_HDR_DIR_INBOUND |
> -				  DESC_HDR_MODE1_MDEU_CICV;
> +		edesc->desc.hdr = cpu_to_be32(ctx->desc_hdr_template |
> +					      DESC_HDR_DIR_INBOUND |
> +					      DESC_HDR_MODE1_MDEU_CICV);
>   
>   		/* reset integrity check result bits */
>   
> @@ -1474,7 +1481,8 @@ static int aead_decrypt(struct aead_request *req)
>   	}
>   
>   	/* Have to check the ICV with software */
> -	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
> +	edesc->desc.hdr = cpu_to_be32(ctx->desc_hdr_template |
> +				      DESC_HDR_DIR_INBOUND);
>   
>   	/* stash incoming ICV for later cmp with ICV generated by the h/w */
>   	icvdata = edesc->buf + edesc->dma_len;
> @@ -1663,7 +1671,8 @@ static int skcipher_encrypt(struct skcipher_request *areq)
>   		return PTR_ERR(edesc);
>   
>   	/* set encrypt */
> -	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
> +	edesc->desc.hdr = cpu_to_be32(ctx->desc_hdr_template |
> +				      DESC_HDR_MODE0_ENCRYPT);
>   
>   	return common_nonsnoop(edesc, areq, skcipher_done);
>   }
> @@ -1687,7 +1696,8 @@ static int skcipher_decrypt(struct skcipher_request *areq)
>   	if (IS_ERR(edesc))
>   		return PTR_ERR(edesc);
>   
> -	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
> +	edesc->desc.hdr = cpu_to_be32(ctx->desc_hdr_template |
> +				      DESC_HDR_DIR_INBOUND);
>   
>   	return common_nonsnoop(edesc, areq, skcipher_done);
>   }
> @@ -1773,7 +1783,7 @@ static void talitos_handle_buggy_hash(struct talitos_ctx *ctx,
>   	};
>   
>   	pr_err_once("Bug in SEC1, padding ourself\n");
> -	edesc->desc.hdr &= ~DESC_HDR_MODE0_MDEU_PAD;
> +	edesc->desc.hdr &= cpu_to_be32(~DESC_HDR_MODE0_MDEU_PAD);
>   	map_single_talitos_ptr(ctx->dev, ptr, sizeof(padded_hash),
>   			       (char *)padded_hash, DMA_TO_DEVICE);
>   }
> @@ -1861,11 +1871,11 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
>   
>   		memset(desc2, 0, sizeof(*desc2));
>   		desc2->hdr = desc->hdr;
> -		desc2->hdr &= ~DESC_HDR_MODE0_MDEU_INIT;
> +		desc2->hdr &= cpu_to_be32(~DESC_HDR_MODE0_MDEU_INIT);
>   		desc2->hdr1 = desc2->hdr;
> -		desc->hdr &= ~DESC_HDR_MODE0_MDEU_PAD;
> -		desc->hdr |= DESC_HDR_MODE0_MDEU_CONT;
> -		desc->hdr &= ~DESC_HDR_DONE_NOTIFY;
> +		desc->hdr &= cpu_to_be32(~DESC_HDR_MODE0_MDEU_PAD);
> +		desc->hdr |= cpu_to_be32(DESC_HDR_MODE0_MDEU_CONT);
> +		desc->hdr &= cpu_to_be32(~DESC_HDR_DONE_NOTIFY);
>   
>   		if (desc->ptr[1].ptr)
>   			copy_talitos_ptr(&desc2->ptr[1], &desc->ptr[1],
> @@ -1989,6 +1999,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
>   	struct talitos_private *priv = dev_get_drvdata(dev);
>   	bool is_sec1 = has_ftr_sec1(priv);
>   	u8 *ctx_buf = req_ctx->buf[req_ctx->buf_idx];
> +	u32 desc_hdr;
>   
>   	if (!req_ctx->last && (nbytes + req_ctx->nbuf <= blocksize)) {
>   		/* Buffer up to one whole block */
> @@ -2064,23 +2075,25 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
>   	if (IS_ERR(edesc))
>   		return PTR_ERR(edesc);
>   
> -	edesc->desc.hdr = ctx->desc_hdr_template;
> +	desc_hdr = ctx->desc_hdr_template;
>   
>   	/* On last one, request SEC to pad; otherwise continue */
>   	if (req_ctx->last)
> -		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_PAD;
> +		desc_hdr |= DESC_HDR_MODE0_MDEU_PAD;
>   	else
> -		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_CONT;
> +		desc_hdr |= DESC_HDR_MODE0_MDEU_CONT;
>   
>   	/* request SEC to INIT hash. */
>   	if (req_ctx->first && !req_ctx->swinit)
> -		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_INIT;
> +		desc_hdr |= DESC_HDR_MODE0_MDEU_INIT;
>   
>   	/* When the tfm context has a keylen, it's an HMAC.
>   	 * A first or last (ie. not middle) descriptor must request HMAC.
>   	 */
>   	if (ctx->keylen && (req_ctx->first || req_ctx->last))
> -		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
> +		desc_hdr |= DESC_HDR_MODE0_MDEU_HMAC;
> +
> +	edesc->desc.hdr = cpu_to_be32(desc_hdr);
>   
>   	return common_nonsnoop_hash(edesc, areq, nbytes_to_hash, ahash_done);
>   }
> @@ -2252,7 +2265,7 @@ struct talitos_alg_template {
>   		struct ahash_alg hash;
>   		struct aead_alg aead;
>   	} alg;
> -	__be32 desc_hdr_template;
> +	u32 desc_hdr_template;
>   };
>   
>   static struct talitos_alg_template driver_algs[] = {
> @@ -3100,7 +3113,7 @@ static void talitos_cra_exit(struct crypto_tfm *tfm)
>    * type and primary/secondary execution units required match the hw
>    * capabilities description provided in the device tree node.
>    */
> -static int hw_supports(struct device *dev, __be32 desc_hdr_template)
> +static int hw_supports(struct device *dev, u32 desc_hdr_template)
>   {
>   	struct talitos_private *priv = dev_get_drvdata(dev);
>   	int ret;
> diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
> index 1469b956948a..d9b3e20234c3 100644
> --- a/drivers/crypto/talitos.h
> +++ b/drivers/crypto/talitos.h
> @@ -9,9 +9,9 @@
>   #define TALITOS1_MAX_DATA_LEN 32768
>   #define TALITOS2_MAX_DATA_LEN 65535
>   
> -#define DESC_TYPE(desc_hdr) ((be32_to_cpu(desc_hdr) >> 3) & 0x1f)
> -#define PRIMARY_EU(desc_hdr) ((be32_to_cpu(desc_hdr) >> 28) & 0xf)
> -#define SECONDARY_EU(desc_hdr) ((be32_to_cpu(desc_hdr) >> 16) & 0xf)
> +#define DESC_TYPE(desc_hdr) (((desc_hdr) >> 3) & 0x1f)
> +#define PRIMARY_EU(desc_hdr) (((desc_hdr) >> 28) & 0xf)
> +#define SECONDARY_EU(desc_hdr) (((desc_hdr) >> 16) & 0xf)
>   
>   /* descriptor pointer entry */
>   struct talitos_ptr {
> @@ -325,39 +325,39 @@ static inline bool has_ftr_sec1(struct talitos_private *priv)
>    */
>   
>   /* written back when done */
> -#define DESC_HDR_DONE			cpu_to_be32(0xff000000)
> -#define DESC_HDR_LO_ICCR1_MASK		cpu_to_be32(0x00180000)
> -#define DESC_HDR_LO_ICCR1_PASS		cpu_to_be32(0x00080000)
> -#define DESC_HDR_LO_ICCR1_FAIL		cpu_to_be32(0x00100000)
> +#define DESC_HDR_DONE			0xff000000
> +#define DESC_HDR_LO_ICCR1_MASK		0x00180000
> +#define DESC_HDR_LO_ICCR1_PASS		0x00080000
> +#define DESC_HDR_LO_ICCR1_FAIL		0x00100000
>   
>   /* primary execution unit select */
> -#define	DESC_HDR_SEL0_MASK		cpu_to_be32(0xf0000000)
> -#define	DESC_HDR_SEL0_AFEU		cpu_to_be32(0x10000000)
> -#define	DESC_HDR_SEL0_DEU		cpu_to_be32(0x20000000)
> -#define	DESC_HDR_SEL0_MDEUA		cpu_to_be32(0x30000000)
> -#define	DESC_HDR_SEL0_MDEUB		cpu_to_be32(0xb0000000)
> -#define	DESC_HDR_SEL0_RNG		cpu_to_be32(0x40000000)
> -#define	DESC_HDR_SEL0_PKEU		cpu_to_be32(0x50000000)
> -#define	DESC_HDR_SEL0_AESU		cpu_to_be32(0x60000000)
> -#define	DESC_HDR_SEL0_KEU		cpu_to_be32(0x70000000)
> -#define	DESC_HDR_SEL0_CRCU		cpu_to_be32(0x80000000)
> +#define	DESC_HDR_SEL0_MASK		0xf0000000
> +#define	DESC_HDR_SEL0_AFEU		0x10000000
> +#define	DESC_HDR_SEL0_DEU		0x20000000
> +#define	DESC_HDR_SEL0_MDEUA		0x30000000
> +#define	DESC_HDR_SEL0_MDEUB		0xb0000000
> +#define	DESC_HDR_SEL0_RNG		0x40000000
> +#define	DESC_HDR_SEL0_PKEU		0x50000000
> +#define	DESC_HDR_SEL0_AESU		0x60000000
> +#define	DESC_HDR_SEL0_KEU		0x70000000
> +#define	DESC_HDR_SEL0_CRCU		0x80000000
>   
>   /* primary execution unit mode (MODE0) and derivatives */
> -#define	DESC_HDR_MODE0_ENCRYPT		cpu_to_be32(0x00100000)
> -#define	DESC_HDR_MODE0_AESU_CBC		cpu_to_be32(0x00200000)
> -#define	DESC_HDR_MODE0_AESU_CTR		cpu_to_be32(0x00600000)
> -#define	DESC_HDR_MODE0_DEU_CBC		cpu_to_be32(0x00400000)
> -#define	DESC_HDR_MODE0_DEU_3DES		cpu_to_be32(0x00200000)
> -#define	DESC_HDR_MODE0_MDEU_CONT	cpu_to_be32(0x08000000)
> -#define	DESC_HDR_MODE0_MDEU_INIT	cpu_to_be32(0x01000000)
> -#define	DESC_HDR_MODE0_MDEU_HMAC	cpu_to_be32(0x00800000)
> -#define	DESC_HDR_MODE0_MDEU_PAD		cpu_to_be32(0x00400000)
> -#define	DESC_HDR_MODE0_MDEU_SHA224	cpu_to_be32(0x00300000)
> -#define	DESC_HDR_MODE0_MDEU_MD5		cpu_to_be32(0x00200000)
> -#define	DESC_HDR_MODE0_MDEU_SHA256	cpu_to_be32(0x00100000)
> -#define	DESC_HDR_MODE0_MDEU_SHA1	cpu_to_be32(0x00000000)
> -#define	DESC_HDR_MODE0_MDEUB_SHA384	cpu_to_be32(0x00000000)
> -#define	DESC_HDR_MODE0_MDEUB_SHA512	cpu_to_be32(0x00200000)
> +#define	DESC_HDR_MODE0_ENCRYPT		0x00100000
> +#define	DESC_HDR_MODE0_AESU_CBC		0x00200000
> +#define	DESC_HDR_MODE0_AESU_CTR		0x00600000
> +#define	DESC_HDR_MODE0_DEU_CBC		0x00400000
> +#define	DESC_HDR_MODE0_DEU_3DES		0x00200000
> +#define	DESC_HDR_MODE0_MDEU_CONT	0x08000000
> +#define	DESC_HDR_MODE0_MDEU_INIT	0x01000000
> +#define	DESC_HDR_MODE0_MDEU_HMAC	0x00800000
> +#define	DESC_HDR_MODE0_MDEU_PAD		0x00400000
> +#define	DESC_HDR_MODE0_MDEU_SHA224	0x00300000
> +#define	DESC_HDR_MODE0_MDEU_MD5		0x00200000
> +#define	DESC_HDR_MODE0_MDEU_SHA256	0x00100000
> +#define	DESC_HDR_MODE0_MDEU_SHA1	0x00000000
> +#define	DESC_HDR_MODE0_MDEUB_SHA384	0x00000000
> +#define	DESC_HDR_MODE0_MDEUB_SHA512	0x00200000
>   #define	DESC_HDR_MODE0_MDEU_MD5_HMAC	(DESC_HDR_MODE0_MDEU_MD5 | \
>   					 DESC_HDR_MODE0_MDEU_HMAC)
>   #define	DESC_HDR_MODE0_MDEU_SHA256_HMAC	(DESC_HDR_MODE0_MDEU_SHA256 | \
> @@ -366,22 +366,22 @@ static inline bool has_ftr_sec1(struct talitos_private *priv)
>   					 DESC_HDR_MODE0_MDEU_HMAC)
>   
>   /* secondary execution unit select (SEL1) */
> -#define	DESC_HDR_SEL1_MASK		cpu_to_be32(0x000f0000)
> -#define	DESC_HDR_SEL1_MDEUA		cpu_to_be32(0x00030000)
> -#define	DESC_HDR_SEL1_MDEUB		cpu_to_be32(0x000b0000)
> -#define	DESC_HDR_SEL1_CRCU		cpu_to_be32(0x00080000)
> +#define	DESC_HDR_SEL1_MASK		0x000f0000
> +#define	DESC_HDR_SEL1_MDEUA		0x00030000
> +#define	DESC_HDR_SEL1_MDEUB		0x000b0000
> +#define	DESC_HDR_SEL1_CRCU		0x00080000
>   
>   /* secondary execution unit mode (MODE1) and derivatives */
> -#define	DESC_HDR_MODE1_MDEU_CICV	cpu_to_be32(0x00004000)
> -#define	DESC_HDR_MODE1_MDEU_INIT	cpu_to_be32(0x00001000)
> -#define	DESC_HDR_MODE1_MDEU_HMAC	cpu_to_be32(0x00000800)
> -#define	DESC_HDR_MODE1_MDEU_PAD		cpu_to_be32(0x00000400)
> -#define	DESC_HDR_MODE1_MDEU_SHA224	cpu_to_be32(0x00000300)
> -#define	DESC_HDR_MODE1_MDEU_MD5		cpu_to_be32(0x00000200)
> -#define	DESC_HDR_MODE1_MDEU_SHA256	cpu_to_be32(0x00000100)
> -#define	DESC_HDR_MODE1_MDEU_SHA1	cpu_to_be32(0x00000000)
> -#define	DESC_HDR_MODE1_MDEUB_SHA384	cpu_to_be32(0x00000000)
> -#define	DESC_HDR_MODE1_MDEUB_SHA512	cpu_to_be32(0x00000200)
> +#define	DESC_HDR_MODE1_MDEU_CICV	0x00004000
> +#define	DESC_HDR_MODE1_MDEU_INIT	0x00001000
> +#define	DESC_HDR_MODE1_MDEU_HMAC	0x00000800
> +#define	DESC_HDR_MODE1_MDEU_PAD		0x00000400
> +#define	DESC_HDR_MODE1_MDEU_SHA224	0x00000300
> +#define	DESC_HDR_MODE1_MDEU_MD5		0x00000200
> +#define	DESC_HDR_MODE1_MDEU_SHA256	0x00000100
> +#define	DESC_HDR_MODE1_MDEU_SHA1	0x00000000
> +#define	DESC_HDR_MODE1_MDEUB_SHA384	0x00000000
> +#define	DESC_HDR_MODE1_MDEUB_SHA512	0x00000200
>   #define	DESC_HDR_MODE1_MDEU_MD5_HMAC	(DESC_HDR_MODE1_MDEU_MD5 | \
>   					 DESC_HDR_MODE1_MDEU_HMAC)
>   #define	DESC_HDR_MODE1_MDEU_SHA256_HMAC	(DESC_HDR_MODE1_MDEU_SHA256 | \
> @@ -396,16 +396,16 @@ static inline bool has_ftr_sec1(struct talitos_private *priv)
>   						 DESC_HDR_MODE1_MDEU_HMAC)
>   
>   /* direction of overall data flow (DIR) */
> -#define	DESC_HDR_DIR_INBOUND		cpu_to_be32(0x00000002)
> +#define	DESC_HDR_DIR_INBOUND		0x00000002
>   
>   /* request done notification (DN) */
> -#define	DESC_HDR_DONE_NOTIFY		cpu_to_be32(0x00000001)
> +#define	DESC_HDR_DONE_NOTIFY		0x00000001
>   
>   /* descriptor types */
> -#define DESC_HDR_TYPE_AESU_CTR_NONSNOOP		cpu_to_be32(0 << 3)
> -#define DESC_HDR_TYPE_IPSEC_ESP			cpu_to_be32(1 << 3)
> -#define DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU	cpu_to_be32(2 << 3)
> -#define DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU	cpu_to_be32(4 << 3)
> +#define DESC_HDR_TYPE_AESU_CTR_NONSNOOP		(0 << 3)
> +#define DESC_HDR_TYPE_IPSEC_ESP			(1 << 3)
> +#define DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU	(2 << 3)
> +#define DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU	(4 << 3)
>   
>   /* link table extent field bits */
>   #define DESC_PTR_LNKTBL_JUMP			0x80
> 
