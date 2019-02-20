Return-Path: <SRS0=bqmp=Q3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49133C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 15:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18E1A2084F
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 15:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbfBTPer (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Feb 2019 10:34:47 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46195 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfBTPer (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Feb 2019 10:34:47 -0500
Received: by mail-qt1-f193.google.com with SMTP id z25so5883115qti.13;
        Wed, 20 Feb 2019 07:34:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9EBq4JRz7bdiLuqe3QS9uVYQ8DPfo7SPAM1FvArFzkw=;
        b=I5D47Ht1NxgIe3z4raP7wtEr0l1UoU/bYXnMlba+QIk20xWgQpCB5EpPLPrn72Iuub
         6nZcoQfcx+br39+51bcxgs25d2QLrTmQWtn+hR+QCsFpMghcImTP+ygFxltVNEGlPtUy
         oC52MDjQ9l5Je1l+qHW9gFkuyqAlPlLyepoA/hdnqYiUR/TpNIJeiFBT6t7x69MZonUa
         2ANzTwnoKd7y7wnEkaXQo4VD59pgQ4u5AcMtiqOMp1Rz8DSqtcpmZrIza5TMQbljRWG9
         qdIIfefG0X+liziTE/97zVTyeLfcDsDWO6p4fZ6f4qM13WbqnaenTN5dxE4++wnEJGlC
         Kk2Q==
X-Gm-Message-State: AHQUAuZejSUnYop9ZXNEe22Eamz/t8nJT/qgdJIOTBOn0jLXx8HkabXJ
        GeE50x9SrT0NB+JH+pywXx65+0UgpLlooYEDtfs=
X-Google-Smtp-Source: AHgI3Ia/JD2uHbcCDrj2gzYp3HMsdzUK1ePilME1EeFq/vO0w5fyXTFs1q/gmCCs/r0U2+wI+8+vU1M9SgtMYrCTcPA=
X-Received: by 2002:a0c:e98f:: with SMTP id z15mr26568991qvn.115.1550676885895;
 Wed, 20 Feb 2019 07:34:45 -0800 (PST)
MIME-Version: 1.0
References: <20190220093458.159208-1-weiyongjun1@huawei.com>
 <CAFA6WYODEymSPh6gQjUL3wRmoPy=zoMv-Z1Q1TbKtWFH=UUgMw@mail.gmail.com>
 <CAKv+Gu9yWEVvvoh8KOX1waZUrM1hy+P99Rxh3U2nPYE_sgyJzQ@mail.gmail.com>
 <8a3ff7ae-9257-82f1-70e2-91cc77aa7377@canonical.com> <CAFA6WYMU0GwYaOgyoCAKSUat0kHOGRnV6UWG0Co0EfHrpO4ryA@mail.gmail.com>
In-Reply-To: <CAFA6WYMU0GwYaOgyoCAKSUat0kHOGRnV6UWG0Co0EfHrpO4ryA@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 20 Feb 2019 16:34:29 +0100
Message-ID: <CAK8P3a3FMa9tpw4rj+8Aue2EYxxKSD4nxdwRFrzac_87Kzio5g@mail.gmail.com>
Subject: Re: [PATCH -next] hwrng: make symbol 'optee_rng_id_table' static
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     Colin Ian King <colin.king@canonical.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 20, 2019 at 12:17 PM Sumit Garg <sumit.garg@linaro.org> wrote:
>
> On Wed, 20 Feb 2019 at 16:19, Colin Ian King <colin.king@canonical.com> wrote:
> >
> > On 20/02/2019 10:37, Ard Biesheuvel wrote:
> > > On Wed, 20 Feb 2019 at 11:34, Sumit Garg <sumit.garg@linaro.org> wrote:
> > >>
> > >> On Wed, 20 Feb 2019 at 14:51, Wei Yongjun <weiyongjun1@huawei.com> wrote:
> > >>>
> > >>> Fixes the following sparse warning:
> > >>>
> > >>> drivers/char/hw_random/optee-rng.c:265:35: warning:
> > >>>  symbol 'optee_rng_id_table' was not declared. Should it be static?
> > >>>
> > >>
> > >> I haven't observed this warning during my normal Linux build using
> > >> gcc. Is there any specific configuration you are using?
> > >>
> > >
> > > This is a sparse warning, not GCC. You need to install it separately
> > > and build with C=1 (iirc)
> > >
>
> TBH, I wasn't aware about this sparse tool. I did install sparse and
> build with C=1 option. But I could only get following such
> errors/warnings for drivers/char/hw_random/optee-rng.c:
>
> ./arch/arm64/include/asm/lse.h:18:37: warning: Unknown escape 'l'
> ./arch/arm64/include/asm/alternative.h:213:28: warning: Unknown escape 'o'
> ./include/linux/compiler.h:194:8: error: attribute '__gnu_inline__':
> unknown attribute
>
> But not the one mentioned in this patch.

Not sure what went wrong, I see the same warning as the others.
Maybe you have an outdated version of sparse that runs into unrelated
issues?

> > It's useful to may these symbols static just to reduce the scope and
> > there is on-going work to fix these symbols up across the entire kernel
> >
>
> Agree with this patch to make optee_rng_id_table symbol static.
> Actually I was curious to know the approach used to get these type of
> warnings so that they could be fixed beforehand.

If you provide an 'Acked-by' or 'Reviewed-by' tag, I can apply this one
on top of the other two fixes I already took.

I also recommend building with 'make W=1', which enables additional
warnings and found this bug in your driver:

drivers/char/hw_random/optee-rng.c: In function 'get_optee_rng_data':
drivers/char/hw_random/optee-rng.c:94:11: error: comparison of
unsigned expression < 0 is always false [-Werror=type-limits]
  if ((ret < 0) || (inv_arg.ret != 0)) {
           ^
drivers/char/hw_random/optee-rng.c: In function 'get_optee_rng_info':
drivers/char/hw_random/optee-rng.c:188:11: error: comparison of
unsigned expression < 0 is always false [-Werror=type-limits]
  if ((ret < 0) || (inv_arg.ret != 0)) {
           ^

Here, you probably need to make 'ret' an 'int', and you should drop
the extraneous zero-initialization for a couple of variables like that one,
so gcc is able to do its job of warning about uninitialized variable

      Arnd
