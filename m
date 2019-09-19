Return-Path: <SRS0=4UkV=XO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8126FC3A5A6
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 09:43:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D69221907
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 09:43:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388196AbfISJn3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Sep 2019 05:43:29 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:34742 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388084AbfISJn3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Sep 2019 05:43:29 -0400
Received: by mail-oi1-f194.google.com with SMTP id 83so2210590oii.1;
        Thu, 19 Sep 2019 02:43:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gRm9/s8K0UzkfKz6WaUpao0Wf54lt1wu17pv2IO02pI=;
        b=B3C1iTTDj1vde56UaoZi5rKuS1PIDa7XUCgMq1Zm0jMcexRSf3X4QDrrpjiLruR0Dz
         ueH6piBTZZ7zjFXwTyqF0w0nMGVRB4CIPPpK9/pVChtGF7p4rdajhXgsguCL4h5Sbzpj
         sUacN8/KgKFByjtLcQLkFvgvs0ATma9TI1lRug43TXStLRBDMrQXqZ2Etd9U1cQ3geeU
         FptcjrUvbL0Uu3TwsIhdU40JjlxFi1dFFY3V6VcXloP+Tw+UAWB5+yarmYTuYk3GsEvd
         VPdjNfOQEstPglr2JKhh3+siRCAJsbrlMF2BDLtKYCmHQaxkGpdVMkJZpR3wmBKPyh9l
         knDg==
X-Gm-Message-State: APjAAAXD53oYhgiWFM7zYjxvQ6qutpBxIrfbbp4gITUNg1zUrr2NJfPA
        o/LEm7qStw+pZPSOn9zoOLlism0ByjIMHnuunb72Ug==
X-Google-Smtp-Source: APXvYqxsGkHOmxSgv4qXNeKLP6aGX+CSbQLSX/g0iW0g19zxtuQSwQGkcWpDpfz6P0RVeqGO5OvhiOcbdwlWSEseBDo=
X-Received: by 2002:aca:3908:: with SMTP id g8mr1555233oia.54.1568886206621;
 Thu, 19 Sep 2019 02:43:26 -0700 (PDT)
MIME-Version: 1.0
References: <git-mailbomb-linux-master-724ecd3c0eb7040d423b22332a60d097e2666820@kernel.org>
In-Reply-To: <git-mailbomb-linux-master-724ecd3c0eb7040d423b22332a60d097e2666820@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 19 Sep 2019 11:43:15 +0200
Message-ID: <CAMuHMdW-n73yuP3V6CCmc8igHcP25KsgZj9eMBCJRowXV5AWVg@mail.gmail.com>
Subject: Re: crypto: aes - rename local routines to prevent future clashes
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

On Wed, Sep 18, 2019 at 9:59 PM Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Commit:     724ecd3c0eb7040d423b22332a60d097e2666820
> Parent:     20bb4ef038a97b8bb5c07d2a1125019a93f618b3
> Refname:    refs/heads/master
> Web:        https://git.kernel.org/torvalds/c/724ecd3c0eb7040d423b22332a60d097e2666820
> Author:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
> AuthorDate: Tue Jul 2 21:41:20 2019 +0200
> Committer:  Herbert Xu <herbert@gondor.apana.org.au>
> CommitDate: Fri Jul 26 14:52:03 2019 +1000
>
>     crypto: aes - rename local routines to prevent future clashes
>
>     Rename some local AES encrypt/decrypt routines so they don't clash with
>     the names we are about to introduce for the routines exposed by the
>     generic AES library.
>
>     Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

> --- a/crypto/aes_generic.c
> +++ b/crypto/aes_generic.c
> @@ -1332,7 +1332,7 @@ EXPORT_SYMBOL_GPL(crypto_aes_set_key);
>         f_rl(bo, bi, 3, k);     \
>  } while (0)
>
> -static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> +static void crypto_aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>         const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);

Looking ay the bloat-o-meter output:

crypto_aes_encrypt                             -    3158   +3158
crypto_aes_decrypt                             -    3154   +3154
aes_decrypt                                 3154    1276   -1878
aes_encrypt                                 3158    1270   -1888

Can't this just call aes_encrypt() now?
CONFIG_CRYPTO_AES already selects CRYPTO_LIB_AES?
Or does the latter has less features (it's smaller, too)?

>         u32 b0[4], b1[4];
> @@ -1402,7 +1402,7 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>         i_rl(bo, bi, 3, k);     \
>  } while (0)
>
> -static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> +static void crypto_aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>         const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);

aes_decrypt()?

>         u32 b0[4], b1[4];

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
