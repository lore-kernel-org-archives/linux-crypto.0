Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7F2ECE587
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 684F02089C
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:35:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YXI1tLEZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730619AbfJNMfh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 08:35:37 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54996 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfJNMfh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 08:35:37 -0400
Received: by mail-wm1-f65.google.com with SMTP id p7so17102123wmp.4
        for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2019 05:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pb1wudvtkVBoqcuP+Ug/DMQ02lyAyBVX0wV7Uq6bxNg=;
        b=YXI1tLEZIcB3EYRi/5Gd9UGiExZ6nGKi+5lL9+iq3zJtTDTWBwbnK8hj7BPIOfrIEm
         HY3PlLSKbpUxx/m+CvsDD2Bfctws2OAJSnKspqZSEOMvR7gBI+RSeAuGhXqq91I+4bb6
         ChKCKYYEcrtwnytnRC2Zq4pR4WTAzKkc1uCiMlVr5rLUR7cR6GtDO0O4nDsKDkilSNkZ
         HqUGKlZv7YUfKPme/dCjcH2MQwHh0KCyqkRvaLhDCSEFHGgQ4lELEmb+hoNhoKv8GAAH
         hvFY0Jrm6lal8LRRLRNDJc8PVIa1JxC1X2f90wtOJpfIEV5TEkBi8vmZyXvms8AuMYwL
         UN/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pb1wudvtkVBoqcuP+Ug/DMQ02lyAyBVX0wV7Uq6bxNg=;
        b=fkAHsp1UYMKMJPxr0FeK7Q+dXnDGEIka+rB/AzV0Gvn3NXz0VuGxRGYo9CNFHVMbAN
         JMDi0tlhvRJ+gCOWG4b7ody/h8qETCX3K0c0YGVusHGp+t+gAB7jOF0h5rySGik1aHBB
         Jri3R9km0AqZgEUr/i2wT/LvuByj9AKOMirOp6A/JDNERk0BMLIptHz+LSHhDeZH3z/x
         MAU2NMTMtUEJZnHmxq+gPwIK1KEJW+rivprGKgpPAbgX4N5D2pZ8OuhJtmmTLLdLbKIq
         PGpISNDUdzM2UIeqthp6dp5GRYpzbcNxcnLK/l/R6kh85Nm5Rn7i0ksnkL2myrNXaJdG
         LLrw==
X-Gm-Message-State: APjAAAUIXKAIG7G/gvlR0qL+qkrrwc5u+euT4NsBwOX9TgwxaCMuflt0
        f9vfHiRVk7uRE48Ew7fpr2ts3/MakUqsJ2Baqw53MiuFQyiP3Q==
X-Google-Smtp-Source: APXvYqyfaiNqhCSkojlaUuWjXIrU4jtR/eqnKwC2wLCSgxhnDwPPVc3/tZCgV0oo5wfKICGX71Z2zvCIZkhnyLSB1ac=
X-Received: by 2002:a7b:ce01:: with SMTP id m1mr13975783wmc.136.1571056533948;
 Mon, 14 Oct 2019 05:35:33 -0700 (PDT)
MIME-Version: 1.0
References: <20191013043918.337113-1-ebiggers@kernel.org> <20191013043918.337113-2-ebiggers@kernel.org>
In-Reply-To: <20191013043918.337113-2-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 14 Oct 2019 14:35:22 +0200
Message-ID: <CAKv+Gu9ocFEULWMcE9_NzQ9uhw3KPCaUFbY1ATr+3mHJQKAHDg@mail.gmail.com>
Subject: Re: [PATCH 1/4] crypto: nx - don't abuse blkcipher_desc to pass iv around
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        =?UTF-8?Q?Breno_Leit=C3=A3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 13 Oct 2019 at 06:40, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> The NX crypto driver is using 'struct blkcipher_desc' to pass the IV
> around, even for AEADs (for which it creates the struct on the stack).
> This is not appropriate since this structure is part of the "blkcipher"
> API, which is deprecated and will be removed.
>
> Just pass around the IV directly instead.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  drivers/crypto/nx/nx-aes-cbc.c |  5 +++--
>  drivers/crypto/nx/nx-aes-ccm.c | 40 ++++++++++++----------------------
>  drivers/crypto/nx/nx-aes-ctr.c |  5 +++--
>  drivers/crypto/nx/nx-aes-ecb.c |  4 ++--
>  drivers/crypto/nx/nx-aes-gcm.c | 24 +++++++++-----------
>  drivers/crypto/nx/nx.c         | 16 +++++++-------
>  drivers/crypto/nx/nx.h         |  6 ++---
>  7 files changed, 43 insertions(+), 57 deletions(-)
>
> diff --git a/drivers/crypto/nx/nx-aes-cbc.c b/drivers/crypto/nx/nx-aes-cbc.c
> index e631f9979127..482a203a9260 100644
> --- a/drivers/crypto/nx/nx-aes-cbc.c
> +++ b/drivers/crypto/nx/nx-aes-cbc.c
> @@ -72,8 +72,9 @@ static int cbc_aes_nx_crypt(struct blkcipher_desc *desc,
>         do {
>                 to_process = nbytes - processed;
>
> -               rc = nx_build_sg_lists(nx_ctx, desc, dst, src, &to_process,
> -                                      processed, csbcpb->cpb.aes_cbc.iv);
> +               rc = nx_build_sg_lists(nx_ctx, desc->info, dst, src,
> +                                      &to_process, processed,
> +                                      csbcpb->cpb.aes_cbc.iv);
>                 if (rc)
>                         goto out;
>
> diff --git a/drivers/crypto/nx/nx-aes-ccm.c b/drivers/crypto/nx/nx-aes-ccm.c
> index 5be8f01c5da8..84fed736ed2e 100644
> --- a/drivers/crypto/nx/nx-aes-ccm.c
> +++ b/drivers/crypto/nx/nx-aes-ccm.c
> @@ -327,7 +327,7 @@ static int generate_pat(u8                   *iv,
>  }
>
>  static int ccm_nx_decrypt(struct aead_request   *req,
> -                         struct blkcipher_desc *desc,
> +                         u8                    *iv,
>                           unsigned int assoclen)
>  {
>         struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(req->base.tfm);
> @@ -348,7 +348,7 @@ static int ccm_nx_decrypt(struct aead_request   *req,
>                                  req->src, nbytes + req->assoclen, authsize,
>                                  SCATTERWALK_FROM_SG);
>
> -       rc = generate_pat(desc->info, req, nx_ctx, authsize, nbytes, assoclen,
> +       rc = generate_pat(iv, req, nx_ctx, authsize, nbytes, assoclen,
>                           csbcpb->cpb.aes_ccm.in_pat_or_b0);
>         if (rc)
>                 goto out;
> @@ -367,7 +367,7 @@ static int ccm_nx_decrypt(struct aead_request   *req,
>
>                 NX_CPB_FDM(nx_ctx->csbcpb) &= ~NX_FDM_ENDE_ENCRYPT;
>
> -               rc = nx_build_sg_lists(nx_ctx, desc, req->dst, req->src,
> +               rc = nx_build_sg_lists(nx_ctx, iv, req->dst, req->src,
>                                        &to_process, processed + req->assoclen,
>                                        csbcpb->cpb.aes_ccm.iv_or_ctr);
>                 if (rc)
> @@ -381,7 +381,7 @@ static int ccm_nx_decrypt(struct aead_request   *req,
>                 /* for partial completion, copy following for next
>                  * entry into loop...
>                  */
> -               memcpy(desc->info, csbcpb->cpb.aes_ccm.out_ctr, AES_BLOCK_SIZE);
> +               memcpy(iv, csbcpb->cpb.aes_ccm.out_ctr, AES_BLOCK_SIZE);
>                 memcpy(csbcpb->cpb.aes_ccm.in_pat_or_b0,
>                         csbcpb->cpb.aes_ccm.out_pat_or_mac, AES_BLOCK_SIZE);
>                 memcpy(csbcpb->cpb.aes_ccm.in_s0,
> @@ -405,7 +405,7 @@ static int ccm_nx_decrypt(struct aead_request   *req,
>  }
>
>  static int ccm_nx_encrypt(struct aead_request   *req,
> -                         struct blkcipher_desc *desc,
> +                         u8                    *iv,
>                           unsigned int assoclen)
>  {
>         struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(req->base.tfm);
> @@ -418,7 +418,7 @@ static int ccm_nx_encrypt(struct aead_request   *req,
>
>         spin_lock_irqsave(&nx_ctx->lock, irq_flags);
>
> -       rc = generate_pat(desc->info, req, nx_ctx, authsize, nbytes, assoclen,
> +       rc = generate_pat(iv, req, nx_ctx, authsize, nbytes, assoclen,
>                           csbcpb->cpb.aes_ccm.in_pat_or_b0);
>         if (rc)
>                 goto out;
> @@ -436,7 +436,7 @@ static int ccm_nx_encrypt(struct aead_request   *req,
>
>                 NX_CPB_FDM(csbcpb) |= NX_FDM_ENDE_ENCRYPT;
>
> -               rc = nx_build_sg_lists(nx_ctx, desc, req->dst, req->src,
> +               rc = nx_build_sg_lists(nx_ctx, iv, req->dst, req->src,
>                                        &to_process, processed + req->assoclen,
>                                        csbcpb->cpb.aes_ccm.iv_or_ctr);
>                 if (rc)
> @@ -450,7 +450,7 @@ static int ccm_nx_encrypt(struct aead_request   *req,
>                 /* for partial completion, copy following for next
>                  * entry into loop...
>                  */
> -               memcpy(desc->info, csbcpb->cpb.aes_ccm.out_ctr, AES_BLOCK_SIZE);
> +               memcpy(iv, csbcpb->cpb.aes_ccm.out_ctr, AES_BLOCK_SIZE);
>                 memcpy(csbcpb->cpb.aes_ccm.in_pat_or_b0,
>                         csbcpb->cpb.aes_ccm.out_pat_or_mac, AES_BLOCK_SIZE);
>                 memcpy(csbcpb->cpb.aes_ccm.in_s0,
> @@ -481,60 +481,48 @@ static int ccm4309_aes_nx_encrypt(struct aead_request *req)
>  {
>         struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(req->base.tfm);
>         struct nx_gcm_rctx *rctx = aead_request_ctx(req);
> -       struct blkcipher_desc desc;
>         u8 *iv = rctx->iv;
>
>         iv[0] = 3;
>         memcpy(iv + 1, nx_ctx->priv.ccm.nonce, 3);
>         memcpy(iv + 4, req->iv, 8);
>
> -       desc.info = iv;
> -
> -       return ccm_nx_encrypt(req, &desc, req->assoclen - 8);
> +       return ccm_nx_encrypt(req, iv, req->assoclen - 8);
>  }
>
>  static int ccm_aes_nx_encrypt(struct aead_request *req)
>  {
> -       struct blkcipher_desc desc;
>         int rc;
>
> -       desc.info = req->iv;
> -
> -       rc = crypto_ccm_check_iv(desc.info);
> +       rc = crypto_ccm_check_iv(req->iv);
>         if (rc)
>                 return rc;
>
> -       return ccm_nx_encrypt(req, &desc, req->assoclen);
> +       return ccm_nx_encrypt(req, req->iv, req->assoclen);
>  }
>
>  static int ccm4309_aes_nx_decrypt(struct aead_request *req)
>  {
>         struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(req->base.tfm);
>         struct nx_gcm_rctx *rctx = aead_request_ctx(req);
> -       struct blkcipher_desc desc;
>         u8 *iv = rctx->iv;
>
>         iv[0] = 3;
>         memcpy(iv + 1, nx_ctx->priv.ccm.nonce, 3);
>         memcpy(iv + 4, req->iv, 8);
>
> -       desc.info = iv;
> -
> -       return ccm_nx_decrypt(req, &desc, req->assoclen - 8);
> +       return ccm_nx_decrypt(req, iv, req->assoclen - 8);
>  }
>
>  static int ccm_aes_nx_decrypt(struct aead_request *req)
>  {
> -       struct blkcipher_desc desc;
>         int rc;
>
> -       desc.info = req->iv;
> -
> -       rc = crypto_ccm_check_iv(desc.info);
> +       rc = crypto_ccm_check_iv(req->iv);
>         if (rc)
>                 return rc;
>
> -       return ccm_nx_decrypt(req, &desc, req->assoclen);
> +       return ccm_nx_decrypt(req, req->iv, req->assoclen);
>  }
>
>  /* tell the block cipher walk routines that this is a stream cipher by
> diff --git a/drivers/crypto/nx/nx-aes-ctr.c b/drivers/crypto/nx/nx-aes-ctr.c
> index 191e226a11a1..05e558cefe94 100644
> --- a/drivers/crypto/nx/nx-aes-ctr.c
> +++ b/drivers/crypto/nx/nx-aes-ctr.c
> @@ -85,8 +85,9 @@ static int ctr_aes_nx_crypt(struct blkcipher_desc *desc,
>         do {
>                 to_process = nbytes - processed;
>
> -               rc = nx_build_sg_lists(nx_ctx, desc, dst, src, &to_process,
> -                                      processed, csbcpb->cpb.aes_ctr.iv);
> +               rc = nx_build_sg_lists(nx_ctx, desc->info, dst, src,
> +                                      &to_process, processed,
> +                                      csbcpb->cpb.aes_ctr.iv);
>                 if (rc)
>                         goto out;
>
> diff --git a/drivers/crypto/nx/nx-aes-ecb.c b/drivers/crypto/nx/nx-aes-ecb.c
> index c67570470c9d..87183890d1ab 100644
> --- a/drivers/crypto/nx/nx-aes-ecb.c
> +++ b/drivers/crypto/nx/nx-aes-ecb.c
> @@ -72,8 +72,8 @@ static int ecb_aes_nx_crypt(struct blkcipher_desc *desc,
>         do {
>                 to_process = nbytes - processed;
>
> -               rc = nx_build_sg_lists(nx_ctx, desc, dst, src, &to_process,
> -                               processed, NULL);
> +               rc = nx_build_sg_lists(nx_ctx, NULL, dst, src, &to_process,
> +                                      processed, NULL);
>                 if (rc)
>                         goto out;
>
> diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-gcm.c
> index 7d3d67871270..898220e159d3 100644
> --- a/drivers/crypto/nx/nx-aes-gcm.c
> +++ b/drivers/crypto/nx/nx-aes-gcm.c
> @@ -166,8 +166,7 @@ static int nx_gca(struct nx_crypto_ctx  *nx_ctx,
>         return rc;
>  }
>
> -static int gmac(struct aead_request *req, struct blkcipher_desc *desc,
> -               unsigned int assoclen)
> +static int gmac(struct aead_request *req, const u8 *iv, unsigned int assoclen)
>  {
>         int rc;
>         struct nx_crypto_ctx *nx_ctx =
> @@ -190,7 +189,7 @@ static int gmac(struct aead_request *req, struct blkcipher_desc *desc,
>                            nx_ctx->ap->databytelen/NX_PAGE_SIZE);
>
>         /* Copy IV */
> -       memcpy(csbcpb->cpb.aes_gcm.iv_or_cnt, desc->info, AES_BLOCK_SIZE);
> +       memcpy(csbcpb->cpb.aes_gcm.iv_or_cnt, iv, AES_BLOCK_SIZE);
>
>         do {
>                 /*
> @@ -240,8 +239,7 @@ static int gmac(struct aead_request *req, struct blkcipher_desc *desc,
>         return rc;
>  }
>
> -static int gcm_empty(struct aead_request *req, struct blkcipher_desc *desc,
> -                    int enc)
> +static int gcm_empty(struct aead_request *req, const u8 *iv, int enc)
>  {
>         int rc;
>         struct nx_crypto_ctx *nx_ctx =
> @@ -268,7 +266,7 @@ static int gcm_empty(struct aead_request *req, struct blkcipher_desc *desc,
>         len = AES_BLOCK_SIZE;
>
>         /* Encrypt the counter/IV */
> -       in_sg = nx_build_sg_list(nx_ctx->in_sg, (u8 *) desc->info,
> +       in_sg = nx_build_sg_list(nx_ctx->in_sg, (u8 *) iv,
>                                  &len, nx_ctx->ap->sglen);
>
>         if (len != AES_BLOCK_SIZE)
> @@ -285,7 +283,7 @@ static int gcm_empty(struct aead_request *req, struct blkcipher_desc *desc,
>         nx_ctx->op.outlen = (nx_ctx->out_sg - out_sg) * sizeof(struct nx_sg);
>
>         rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
> -                          desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
> +                          req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
>         if (rc)
>                 goto out;
>         atomic_inc(&(nx_ctx->stats->aes_ops));
> @@ -313,7 +311,6 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc,
>                 crypto_aead_ctx(crypto_aead_reqtfm(req));
>         struct nx_gcm_rctx *rctx = aead_request_ctx(req);
>         struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
> -       struct blkcipher_desc desc;
>         unsigned int nbytes = req->cryptlen;
>         unsigned int processed = 0, to_process;
>         unsigned long irq_flags;
> @@ -321,15 +318,14 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc,
>
>         spin_lock_irqsave(&nx_ctx->lock, irq_flags);
>
> -       desc.info = rctx->iv;
>         /* initialize the counter */
> -       *(u32 *)(desc.info + NX_GCM_CTR_OFFSET) = 1;
> +       *(u32 *)&rctx->iv[NX_GCM_CTR_OFFSET] = 1;
>
>         if (nbytes == 0) {
>                 if (assoclen == 0)
> -                       rc = gcm_empty(req, &desc, enc);
> +                       rc = gcm_empty(req, rctx->iv, enc);
>                 else
> -                       rc = gmac(req, &desc, assoclen);
> +                       rc = gmac(req, rctx->iv, assoclen);
>                 if (rc)
>                         goto out;
>                 else
> @@ -358,7 +354,7 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc,
>                 to_process = nbytes - processed;
>
>                 csbcpb->cpb.aes_gcm.bit_length_data = nbytes * 8;
> -               rc = nx_build_sg_lists(nx_ctx, &desc, req->dst,
> +               rc = nx_build_sg_lists(nx_ctx, rctx->iv, req->dst,
>                                        req->src, &to_process,
>                                        processed + req->assoclen,
>                                        csbcpb->cpb.aes_gcm.iv_or_cnt);
> @@ -377,7 +373,7 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc,
>                 if (rc)
>                         goto out;
>
> -               memcpy(desc.info, csbcpb->cpb.aes_gcm.out_cnt, AES_BLOCK_SIZE);
> +               memcpy(rctx->iv, csbcpb->cpb.aes_gcm.out_cnt, AES_BLOCK_SIZE);
>                 memcpy(csbcpb->cpb.aes_gcm.in_pat_or_aad,
>                         csbcpb->cpb.aes_gcm.out_pat_or_mac, AES_BLOCK_SIZE);
>                 memcpy(csbcpb->cpb.aes_gcm.in_s0,
> diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
> index 28817880c76d..1202a00715ac 100644
> --- a/drivers/crypto/nx/nx.c
> +++ b/drivers/crypto/nx/nx.c
> @@ -243,25 +243,25 @@ static long int trim_sg_list(struct nx_sg *sg,
>   *                     scatterlists based on them.
>   *
>   * @nx_ctx: NX crypto context for the lists we're building
> - * @desc: the block cipher descriptor for the operation
> + * @iv: iv data, if the algorithm requires it
>   * @dst: destination scatterlist
>   * @src: source scatterlist
>   * @nbytes: length of data described in the scatterlists
>   * @offset: number of bytes to fast-forward past at the beginning of
>   *          scatterlists.
> - * @iv: destination for the iv data, if the algorithm requires it
> + * @oiv: destination for the iv data, if the algorithm requires it
>   *
> - * This is common code shared by all the AES algorithms. It uses the block
> - * cipher walk routines to traverse input and output scatterlists, building
> + * This is common code shared by all the AES algorithms. It uses the crypto
> + * scatterlist walk routines to traverse input and output scatterlists, building
>   * corresponding NX scatterlists
>   */
>  int nx_build_sg_lists(struct nx_crypto_ctx  *nx_ctx,
> -                     struct blkcipher_desc *desc,
> +                     const u8              *iv,
>                       struct scatterlist    *dst,
>                       struct scatterlist    *src,
>                       unsigned int          *nbytes,
>                       unsigned int           offset,
> -                     u8                    *iv)
> +                     u8                    *oiv)
>  {
>         unsigned int delta = 0;
>         unsigned int total = *nbytes;
> @@ -274,8 +274,8 @@ int nx_build_sg_lists(struct nx_crypto_ctx  *nx_ctx,
>         max_sg_len = min_t(u64, max_sg_len,
>                         nx_ctx->ap->databytelen/NX_PAGE_SIZE);
>
> -       if (iv)
> -               memcpy(iv, desc->info, AES_BLOCK_SIZE);
> +       if (oiv)
> +               memcpy(oiv, iv, AES_BLOCK_SIZE);
>
>         *nbytes = min_t(u64, *nbytes, nx_ctx->ap->databytelen);
>
> diff --git a/drivers/crypto/nx/nx.h b/drivers/crypto/nx/nx.h
> index 7ecca168f8c4..768ebae9731e 100644
> --- a/drivers/crypto/nx/nx.h
> +++ b/drivers/crypto/nx/nx.h
> @@ -155,9 +155,9 @@ void nx_ctx_init(struct nx_crypto_ctx *nx_ctx, unsigned int function);
>  int nx_hcall_sync(struct nx_crypto_ctx *ctx, struct vio_pfo_op *op,
>                   u32 may_sleep);
>  struct nx_sg *nx_build_sg_list(struct nx_sg *, u8 *, unsigned int *, u32);
> -int nx_build_sg_lists(struct nx_crypto_ctx *, struct blkcipher_desc *,
> -                     struct scatterlist *, struct scatterlist *, unsigned int *,
> -                     unsigned int, u8 *);
> +int nx_build_sg_lists(struct nx_crypto_ctx *nx_ctx, const u8 *iv,
> +                     struct scatterlist *dst, struct scatterlist *src,
> +                     unsigned int *nbytes, unsigned int offset, u8 *oiv);
>  struct nx_sg *nx_walk_and_build(struct nx_sg *, unsigned int,
>                                 struct scatterlist *, unsigned int,
>                                 unsigned int *);
> --
> 2.23.0
>
