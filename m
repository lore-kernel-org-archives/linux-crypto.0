Return-Path: <SRS0=CUlN=CA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F12AEC433DF
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Aug 2020 13:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6EE920738
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Aug 2020 13:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598101464;
	bh=IAETXI5TJu5PFa9rkP0KtaMf0vS/k0B1qj+XHHdps0I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=F0y9vOLFZsxJD1kga075vxkBdm3O7NbY6JojUx8D6FKq39Z2vkH6r/ppg20vVz1/V
	 ST4cXAOTHoSIUgFbDIocbcP9RuIn8YJrn9yUjYoj/YqfSeJUDSOp0I8XMe2nKz3LLL
	 cV9z2Dtb+W4TRTDBS2vLER1ohtRw2/3NjFRBPm4Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgHVNEX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Aug 2020 09:04:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727864AbgHVNEW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Aug 2020 09:04:22 -0400
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A990F207DF
        for <linux-crypto@vger.kernel.org>; Sat, 22 Aug 2020 13:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598101461;
        bh=IAETXI5TJu5PFa9rkP0KtaMf0vS/k0B1qj+XHHdps0I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MAg7CvS+YLgaLfOhXflEmZpIsQYCbPNn2DkUJBYm82p4oJDeEfLF5dG70FkavubHj
         0p+pN533moPCpjV7BP2UDo8eh7BrSgDg5ZMzug/SPVGMgW+2le408XbdmZ5pfgVgbf
         +ZEN176uU8gM3OEBUzfcaDNWqzSilhywz+CDnnQQ=
Received: by mail-ot1-f43.google.com with SMTP id u16so249576otj.10
        for <linux-crypto@vger.kernel.org>; Sat, 22 Aug 2020 06:04:21 -0700 (PDT)
X-Gm-Message-State: AOAM5334McZOulaoN3TVlOk5mldQC5HOAvpGpHoOwMKeIm2XpYarjUiE
        773j/SXj+WZboMudYG5vuat+xRa2Gtl7rujPQJs=
X-Google-Smtp-Source: ABdhPJz2QrylPxMh4mlG/3NG9yh9HqJ8hUTKYb05TDrxG10xyXp7gU+1NQ0JKeDF3hSZCDxLHc5WA1qop6k2RCIZ/C8=
X-Received: by 2002:a9d:774d:: with SMTP id t13mr5090428otl.108.1598101461017;
 Sat, 22 Aug 2020 06:04:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200822072934.4394-1-giovanni.cabiddu@intel.com>
In-Reply-To: <20200822072934.4394-1-giovanni.cabiddu@intel.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 22 Aug 2020 15:04:10 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFTCtRz99BzDsbmb8cPbMEM8Bi73nfp-ru4Zr2SECB9CA@mail.gmail.com>
Message-ID: <CAMj1kXFTCtRz99BzDsbmb8cPbMEM8Bi73nfp-ru4Zr2SECB9CA@mail.gmail.com>
Subject: Re: [PATCH] crypto: qat - aead cipher length should be block multiple
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        qat-linux@intel.com,
        Dominik Przychodni <dominik.przychodni@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 22 Aug 2020 at 09:29, Giovanni Cabiddu
<giovanni.cabiddu@intel.com> wrote:
>
> From: Dominik Przychodni <dominik.przychodni@intel.com>
>
> Include an additional check on the cipher length to prevent undefined
> behaviour from occurring upon submitting requests which are not a
> multiple of AES_BLOCK_SIZE.
>
> Fixes: d370cec32194 ("crypto: qat - Intel(R) QAT crypto interface")
> Signed-off-by: Dominik Przychodni <dominik.przychodni@intel.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

I only looked at the patch, and not at the entire file, but could you
explain which AES based AEAD implementations require the input length
to be a multiple of the block size? CCM and GCM are both CTR based,
and so any input length should be supported for at least those modes.



> ---
>  drivers/crypto/qat/qat_common/qat_algs.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
> index 72753b84dc95..d552dbcfe0a0 100644
> --- a/drivers/crypto/qat/qat_common/qat_algs.c
> +++ b/drivers/crypto/qat/qat_common/qat_algs.c
> @@ -828,6 +828,11 @@ static int qat_alg_aead_dec(struct aead_request *areq)
>         struct icp_qat_fw_la_bulk_req *msg;
>         int digst_size = crypto_aead_authsize(aead_tfm);
>         int ret, ctr = 0;
> +       u32 cipher_len;
> +
> +       cipher_len = areq->cryptlen - digst_size;
> +       if (cipher_len % AES_BLOCK_SIZE != 0)
> +               return -EINVAL;
>
>         ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
>         if (unlikely(ret))
> @@ -842,7 +847,7 @@ static int qat_alg_aead_dec(struct aead_request *areq)
>         qat_req->req.comn_mid.src_data_addr = qat_req->buf.blp;
>         qat_req->req.comn_mid.dest_data_addr = qat_req->buf.bloutp;
>         cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
> -       cipher_param->cipher_length = areq->cryptlen - digst_size;
> +       cipher_param->cipher_length = cipher_len;
>         cipher_param->cipher_offset = areq->assoclen;
>         memcpy(cipher_param->u.cipher_IV_array, areq->iv, AES_BLOCK_SIZE);
>         auth_param = (void *)((u8 *)cipher_param + sizeof(*cipher_param));
> @@ -871,6 +876,9 @@ static int qat_alg_aead_enc(struct aead_request *areq)
>         u8 *iv = areq->iv;
>         int ret, ctr = 0;
>
> +       if (areq->cryptlen % AES_BLOCK_SIZE != 0)
> +               return -EINVAL;
> +
>         ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
>         if (unlikely(ret))
>                 return ret;
> --
> 2.26.2
>
