Return-Path: <SRS0=tj8v=AO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0311BC433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 08:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C19AA2084C
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 08:36:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DincemqM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgGCIgz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Jul 2020 04:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgGCIgy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Jul 2020 04:36:54 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8B9C08C5C1;
        Fri,  3 Jul 2020 01:36:54 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id v6so18024759iob.4;
        Fri, 03 Jul 2020 01:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=xOHCU2+2Hl3oR9DNasCEydEOombBF0/71/PXB/IcwFo=;
        b=DincemqMChQXOxUDF7+r9Fy4lXi9OPo+ePkk+72oe+3DtZA3I6m5QsTqaim7w/1KK7
         3nB0v3mAAK3QxZ6bsg9tJavJTwPcpn8AsZ14VtCQXxk6odPSQfQb3qn2m4zUzxrZrlfp
         zk0e19f3r+gQKfsWF1HlzV+s6fXaMCSllJdZh9EqQZ2/xFXAAci9RbRXtWyItIrs2/Z+
         Q/MgfC1gvMkwpJ7dJJ/sR1uvDZ4xvq3Y0yrsqhGqyO5Y/W1PVMuTnSXf3p1Ct1kLQHzR
         oDQj3RjcJ2MLbBjp7k4WEBQR/uzQFc+xxKtJjt9HBXrh7XZqjbbagrmRBI9m8vNIRB6/
         Z3VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=xOHCU2+2Hl3oR9DNasCEydEOombBF0/71/PXB/IcwFo=;
        b=KGsd9asyRBdAbtppgvlGupN5sUiCfMzwrsyrQSca2BzclfnrxBTf38FVc75dfTaK3L
         X1VlMhqW1KxbBpv6yHsxVdBrvAZ+8aGunsA6wvCekCJip4VSP4830efuJVBLFRFB1OLH
         dwivWD20x6mrg5kugfJccHWFe+wxN4hb+sf5ndwv0S3Gh31gln4vP29h3ziIQSiofoQs
         R4LDtW0WVmwEXjw+fDUyQORWuJoMAqodg0XBQyLLuV8yLK6WCIMHe+2UtymkMkFaYDwo
         WyKpBp4pSCN6zGnwXEIDxbN49WFccx9VhFmJ6gaTRNKK07ldiwSn22xx/8LaUimuLgBD
         JKnQ==
X-Gm-Message-State: AOAM531ifkZJP5uiI1Ct6ZkgbntGAaCARcHxfgKlMqgS6DGOwT7FpsCo
        fAVou6RF3jGvmra/m6iF6v8RJxQ25gDlyHQbBvA=
X-Google-Smtp-Source: ABdhPJyK4+2ZWwxG1nidUIgEwwFwqlypgmG1fs4QgihqE9v+l2O+ktcPUYhMHnB54IgZpWPDLiBDnvfLHQSOyla2Zsc=
X-Received: by 2002:a02:c785:: with SMTP id n5mr38854511jao.75.1593765414282;
 Fri, 03 Jul 2020 01:36:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200622232434.162730-1-caij2003@gmail.com> <20200703044832.GD23200@gondor.apana.org.au>
In-Reply-To: <20200703044832.GD23200@gondor.apana.org.au>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Fri, 3 Jul 2020 10:36:43 +0200
Message-ID: <CA+icZUWwpY9rnfgyy81-78fH+PH4wmAS-+yZFBDCjBbARabQfg@mail.gmail.com>
Subject: Re: [PATCH] crypto, x86: aesni: add compatibility with IAS
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Jian Cai <caij2003@gmail.com>, jiancai@google.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        manojgupta@google.com, maskray@google.com,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 3, 2020 at 6:49 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Jun 22, 2020 at 04:24:33PM -0700, Jian Cai wrote:
> > Clang's integrated assembler complains "invalid reassignment of
> > non-absolute variable 'var_ddq_add'" while assembling
> > arch/x86/crypto/aes_ctrby8_avx-x86_64.S. It was because var_ddq_add was
> > reassigned with non-absolute values several times, which IAS did not
> > support. We can avoid the reassignment by replacing the uses of
> > var_ddq_add with its definitions accordingly to have compatilibility
> > with IAS.
> >
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1008
> > Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> > Reported-by: Fangrui Song <maskray@google.com>
> > Tested-by: Sedat Dilek <sedat.dilek@gmail.com> # build+boot Linux v5.7.5; clang v11.0.0-git
> > Signed-off-by: Jian Cai <caij2003@gmail.com>
> > ---
> >  arch/x86/crypto/aes_ctrby8_avx-x86_64.S | 14 +++-----------
> >  1 file changed, 3 insertions(+), 11 deletions(-)
>
> Patch applied.  Thanks.

Hi Herbert,

Can you please apply my patch, too?

For being able to compile/assemble with LLVM_IAS=1 *both* patches are
needed with CONFIG_CRYPTO_AES_NI_INTEL={m,y}.

If you do pick this up, please add a...

   Link: https://bugs.llvm.org/show_bug.cgi?id=24494

Thanks.

Regards,
- Sedat -

[0] https://lore.kernel.org/patchwork/patch/1263102/
[1] https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=44069737ac9625a0f02f0f7f5ab96aae4cd819bc
[2] https://bugs.llvm.org/show_bug.cgi?id=24494


> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
