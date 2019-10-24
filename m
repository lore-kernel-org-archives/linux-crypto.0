Return-Path: <SRS0=tzqc=YR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92988CA9EAF
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 13:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6500720679
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 13:42:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="UxRR5VC2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393694AbfJXNmo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Oct 2019 09:42:44 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:37591 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393693AbfJXNmn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Oct 2019 09:42:43 -0400
Received: by mail-vs1-f65.google.com with SMTP id e12so4695438vsr.4
        for <linux-crypto@vger.kernel.org>; Thu, 24 Oct 2019 06:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WeaV+gKFOMSix3DPscO9aSkp7iK/hD0Ls8seYHbmi40=;
        b=UxRR5VC2FYc9UjBYOxrWsz5SOqrcLrvSutCl+ZqbiZfjtoEH0qYjKx5Q050ENwvK0V
         ydPxywxMp0PVdb45MLPkN1uJjkcNL6OSenYYfxVSvxm+0GNIExUkaddXfv5n3bqRRzUX
         5VtnXW/uJ3nH+yAbCfhcxBbCigp+5GsiXn8BPchQ/qeWTmDG/6aVAIDgPm6nz1+Kd+oK
         C1E7jSQvGYQqrtH++bQE3X4/UwA8KrTznBTojS+NcI2W8+5AmFZ7+HAxl9972GrOAkit
         b4gB2i76CmYZZfmUmxYV0XS0p8ZcgP12Ys9NnT9m8EvyAck4QhSsxU/dYuZHurmByWQa
         JfPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WeaV+gKFOMSix3DPscO9aSkp7iK/hD0Ls8seYHbmi40=;
        b=hOAPiezrbBjmLVGogWYguvhWGPqpQRe1Hx9TV/YAp1zelcq/G6F58/TaG2sAdecYhw
         OcdANG+fn8rYu0hHPclNHRuME0Fwl6ede80NHESG0R+hsv/yLE0MsBu8eee4t+3/x5Gx
         /WkG+/oa3ZD0xRogWbTJ9rig15Yhhv7gw3CsY5Ju6uiqc5lXAfvSQGClLlKfm1/hMVuQ
         M4VrxY+JRHgzurc4WhobwulItmU6Gv0cAoaLkiSMyNVhgfMgE3J2g92QUNHAAzXXdf+M
         ooAyPz9+z4v3gk52vmBDnU89bxhb60wkSTgosqfuwtVTfIG13wqT8y5huQ46it2m+2v9
         i79A==
X-Gm-Message-State: APjAAAUBrHYbXkuoaQuvyY5LeUa585H6xSUD6r7X7WXPDYPZN7BP2FUk
        l0N5LWyzlh7PqxoqRMkj3Vg2pAW4yqCxsL0SLkIUXg==
X-Google-Smtp-Source: APXvYqxXcwF9zOJPpvwHAK7ZQwfzsKXchxjRTueoZZMdj58cC6SP+LXKc2OVDV37cV3DNOzyB1yZhp+k/bnRMZekj/8=
X-Received: by 2002:a67:f744:: with SMTP id w4mr1733953vso.117.1571924562636;
 Thu, 24 Oct 2019 06:42:42 -0700 (PDT)
MIME-Version: 1.0
References: <1571445697-33824-1-git-send-email-tiantao6@huawei.com>
In-Reply-To: <1571445697-33824-1-git-send-email-tiantao6@huawei.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Thu, 24 Oct 2019 16:42:26 +0300
Message-ID: <CAOtvUMdw=N3ky-z2T4gJDM6YeGp2ir6d=ZtTrpLoK7g89-x+1g@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: fix comparison of unsigned expression warning
To:     Tian Tao <tiantao6@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Oct 19, 2019 at 3:44 AM Tian Tao <tiantao6@huawei.com> wrote:
>
> This patch fixes the following warnings:
> drivers/crypto/ccree/cc_aead.c:630:5-12: WARNING: Unsigned expression
> compared with zero: seq_len > 0
>
> Signed-off-by: Tian Tao <tiantao6@huawei.com>


Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thanks,
Gilad

>
> v2:
> change hmac_setkey() return type to unsigned int to fix the warning.
> ---
>  drivers/crypto/ccree/cc_aead.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aea=
d.c
> index d3e8faa..64d318d 100644
> --- a/drivers/crypto/ccree/cc_aead.c
> +++ b/drivers/crypto/ccree/cc_aead.c
> @@ -293,7 +293,8 @@ static unsigned int xcbc_setkey(struct cc_hw_desc *de=
sc,
>         return 4;
>  }
>
> -static int hmac_setkey(struct cc_hw_desc *desc, struct cc_aead_ctx *ctx)
> +static unsigned int hmac_setkey(struct cc_hw_desc *desc,
> +                               struct cc_aead_ctx *ctx)
>  {
>         unsigned int hmac_pad_const[2] =3D { HMAC_IPAD_CONST, HMAC_OPAD_C=
ONST };
>         unsigned int digest_ofs =3D 0;
> --
> 2.7.4
>


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
