Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A6CC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 23:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19CB1223DB
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 23:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbhATXnM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 18:43:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:41222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731815AbhATWYs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 17:24:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7AA42368A;
        Wed, 20 Jan 2021 22:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611181441;
        bh=1VvtVQTaDItje67ZPJMqpNuHYllKHOc4mP1hp8eY9Hk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ccyDBRkpNo/Nza5F4xVedTfJYNLUi+zL4MmkXjaGv9iCgPQWKD5Gr+D2SMSa9Ofvu
         t98SSv0tvKZCqlSqpIKObg4OcdZON+rVftXw18Pil7nNPYBek+KJKdxV0GcKDc4P8I
         s3zaQOfsX60IeV9g0nyVgOA+oMKDej9cddwOPDUiXKrL0lN+nR+ARLvzniK3N/VP2V
         /wCTLK5+AjgsyJnTWsk800dxQ86Ni55FTLW2k5YJp2UiIiBIt7OI24WycAQA6YDOle
         tqSTH7fDTAL+fU32Atv6lw+ajpDW43j2TTP5fFTR3irp2oMxJDRxdfn5Fg5rPPyaeU
         m/PNC+DCThyyQ==
Received: by mail-oi1-f173.google.com with SMTP id p5so14310oif.7;
        Wed, 20 Jan 2021 14:24:01 -0800 (PST)
X-Gm-Message-State: AOAM531JID88FR0Aj7JBNDXa+1sDSKsj/090F6wNLH37IMZeH8eNPrIR
        x+5uJn1Vileu/BJz0d7xvEVvHWIj3uN5N+MTc+E=
X-Google-Smtp-Source: ABdhPJzOM8ODvnNmPGwAC41UTe7I3U8vD07x2N6RSlHx1auVSv75z4R8dM0Rw4QATfv+jEGtcNOtslJjFVGJT3Ofyo4=
X-Received: by 2002:aca:d98a:: with SMTP id q132mr4258848oig.33.1611181440883;
 Wed, 20 Jan 2021 14:24:00 -0800 (PST)
MIME-Version: 1.0
References: <4b7a870573f485b9fea496b13c9b02d86dd97314.1611169001.git.christophe.leroy@csgroup.eu>
In-Reply-To: <4b7a870573f485b9fea496b13c9b02d86dd97314.1611169001.git.christophe.leroy@csgroup.eu>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 20 Jan 2021 23:23:49 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE7B05eAnR7KoDCym09Cw5qnzrV8KfNT2zJrko+mFic+w@mail.gmail.com>
Message-ID: <CAMj1kXE7B05eAnR7KoDCym09Cw5qnzrV8KfNT2zJrko+mFic+w@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: talitos - Work around SEC6 ERRATA (AES-CTR
 mode data size error)
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" 
        <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 20 Jan 2021 at 19:59, Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
>
> Talitos Security Engine AESU considers any input
> data size that is not a multiple of 16 bytes to be an error.
> This is not a problem in general, except for Counter mode
> that is a stream cipher and can have an input of any size.
>
> Test Manager for ctr(aes) fails on 4th test vector which has
> a length of 499 while all previous vectors which have a 16 bytes
> multiple length succeed.
>
> As suggested by Freescale, round up the input data length to the
> nearest 16 bytes.
>
> Fixes: 5e75ae1b3cef ("crypto: talitos - add new crypto modes")
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>

Doesn't this cause the hardware to write outside the given buffer?

> ---
>  drivers/crypto/talitos.c | 28 ++++++++++++++++------------
>  drivers/crypto/talitos.h |  1 +
>  2 files changed, 17 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index 4fd85f31630a..b656983c1ef4 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -1093,11 +1093,12 @@ static void ipsec_esp_decrypt_hwauth_done(struct device *dev,
>   */
>  static int sg_to_link_tbl_offset(struct scatterlist *sg, int sg_count,
>                                  unsigned int offset, int datalen, int elen,
> -                                struct talitos_ptr *link_tbl_ptr)
> +                                struct talitos_ptr *link_tbl_ptr, int align)
>  {
>         int n_sg = elen ? sg_count + 1 : sg_count;
>         int count = 0;
>         int cryptlen = datalen + elen;
> +       int padding = ALIGN(cryptlen, align) - cryptlen;
>
>         while (cryptlen && sg && n_sg--) {
>                 unsigned int len = sg_dma_len(sg);
> @@ -1121,7 +1122,7 @@ static int sg_to_link_tbl_offset(struct scatterlist *sg, int sg_count,
>                         offset += datalen;
>                 }
>                 to_talitos_ptr(link_tbl_ptr + count,
> -                              sg_dma_address(sg) + offset, len, 0);
> +                              sg_dma_address(sg) + offset, sg_next(sg) ? len : len + padding, 0);
>                 to_talitos_ptr_ext_set(link_tbl_ptr + count, 0, 0);
>                 count++;
>                 cryptlen -= len;
> @@ -1144,10 +1145,11 @@ static int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
>                               unsigned int len, struct talitos_edesc *edesc,
>                               struct talitos_ptr *ptr, int sg_count,
>                               unsigned int offset, int tbl_off, int elen,
> -                             bool force)
> +                             bool force, int align)
>  {
>         struct talitos_private *priv = dev_get_drvdata(dev);
>         bool is_sec1 = has_ftr_sec1(priv);
> +       int aligned_len = ALIGN(len, align);
>
>         if (!src) {
>                 to_talitos_ptr(ptr, 0, 0, is_sec1);
> @@ -1155,22 +1157,22 @@ static int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
>         }
>         to_talitos_ptr_ext_set(ptr, elen, is_sec1);
>         if (sg_count == 1 && !force) {
> -               to_talitos_ptr(ptr, sg_dma_address(src) + offset, len, is_sec1);
> +               to_talitos_ptr(ptr, sg_dma_address(src) + offset, aligned_len, is_sec1);
>                 return sg_count;
>         }
>         if (is_sec1) {
> -               to_talitos_ptr(ptr, edesc->dma_link_tbl + offset, len, is_sec1);
> +               to_talitos_ptr(ptr, edesc->dma_link_tbl + offset, aligned_len, is_sec1);
>                 return sg_count;
>         }
>         sg_count = sg_to_link_tbl_offset(src, sg_count, offset, len, elen,
> -                                        &edesc->link_tbl[tbl_off]);
> +                                        &edesc->link_tbl[tbl_off], align);
>         if (sg_count == 1 && !force) {
>                 /* Only one segment now, so no link tbl needed*/
>                 copy_talitos_ptr(ptr, &edesc->link_tbl[tbl_off], is_sec1);
>                 return sg_count;
>         }
>         to_talitos_ptr(ptr, edesc->dma_link_tbl +
> -                           tbl_off * sizeof(struct talitos_ptr), len, is_sec1);
> +                           tbl_off * sizeof(struct talitos_ptr), aligned_len, is_sec1);
>         to_talitos_ptr_ext_or(ptr, DESC_PTR_LNKTBL_JUMP, is_sec1);
>
>         return sg_count;
> @@ -1182,7 +1184,7 @@ static int talitos_sg_map(struct device *dev, struct scatterlist *src,
>                           unsigned int offset, int tbl_off)
>  {
>         return talitos_sg_map_ext(dev, src, len, edesc, ptr, sg_count, offset,
> -                                 tbl_off, 0, false);
> +                                 tbl_off, 0, false, 1);
>  }
>
>  /*
> @@ -1251,7 +1253,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
>
>         ret = talitos_sg_map_ext(dev, areq->src, cryptlen, edesc, &desc->ptr[4],
>                                  sg_count, areq->assoclen, tbl_off, elen,
> -                                false);
> +                                false, 1);
>
>         if (ret > 1) {
>                 tbl_off += ret;
> @@ -1271,7 +1273,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
>                 elen = 0;
>         ret = talitos_sg_map_ext(dev, areq->dst, cryptlen, edesc, &desc->ptr[5],
>                                  sg_count, areq->assoclen, tbl_off, elen,
> -                                is_ipsec_esp && !encrypt);
> +                                is_ipsec_esp && !encrypt, 1);
>         tbl_off += ret;
>
>         if (!encrypt && is_ipsec_esp) {
> @@ -1577,6 +1579,8 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
>         bool sync_needed = false;
>         struct talitos_private *priv = dev_get_drvdata(dev);
>         bool is_sec1 = has_ftr_sec1(priv);
> +       bool is_ctr = (desc->hdr & DESC_HDR_SEL0_MASK) == DESC_HDR_SEL0_AESU &&
> +                     (desc->hdr & DESC_HDR_MODE0_AESU_MASK) == DESC_HDR_MODE0_AESU_CTR;
>
>         /* first DWORD empty */
>
> @@ -1597,8 +1601,8 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
>         /*
>          * cipher in
>          */
> -       sg_count = talitos_sg_map(dev, areq->src, cryptlen, edesc,
> -                                 &desc->ptr[3], sg_count, 0, 0);
> +       sg_count = talitos_sg_map_ext(dev, areq->src, cryptlen, edesc, &desc->ptr[3],
> +                                     sg_count, 0, 0, 0, false, is_ctr ? 16 : 1);
>         if (sg_count > 1)
>                 sync_needed = true;
>
> diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
> index 1469b956948a..32825119e880 100644
> --- a/drivers/crypto/talitos.h
> +++ b/drivers/crypto/talitos.h
> @@ -344,6 +344,7 @@ static inline bool has_ftr_sec1(struct talitos_private *priv)
>
>  /* primary execution unit mode (MODE0) and derivatives */
>  #define        DESC_HDR_MODE0_ENCRYPT          cpu_to_be32(0x00100000)
> +#define        DESC_HDR_MODE0_AESU_MASK        cpu_to_be32(0x00600000)
>  #define        DESC_HDR_MODE0_AESU_CBC         cpu_to_be32(0x00200000)
>  #define        DESC_HDR_MODE0_AESU_CTR         cpu_to_be32(0x00600000)
>  #define        DESC_HDR_MODE0_DEU_CBC          cpu_to_be32(0x00400000)
> --
> 2.25.0
>
