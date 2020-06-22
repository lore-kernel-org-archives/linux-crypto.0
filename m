Return-Path: <SRS0=/YgZ=AD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE4DC433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 16:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33DC220707
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 16:52:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NZt31C1u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbgFVQwc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jun 2020 12:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729533AbgFVQwb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jun 2020 12:52:31 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D58C061573;
        Mon, 22 Jun 2020 09:52:31 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id p5so16566762ile.6;
        Mon, 22 Jun 2020 09:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=ml4K+H93SeXCIMnxVi3/6PCWqKGjDCE1p4VhTbgYGy0=;
        b=NZt31C1ubnTF4OHvh/tYbT9DAEszGbXCpPS27shTbFzq/9UjRbQBgm/geZnGY6uywq
         K6UUDNAWwo0inGf8MSPYWkmP7rsvs8noBfCvWHbeg62HHX/i6eMoBcrvP8BkkziZ7BQA
         hzqMPDR8+03CVLvIB2JtweMn/UeoUkE6rq+IjJszEhSrOxPrVDqtW+E0vPQ0MSYVgYEF
         kzy7ooi2q4prVEombNb/sFWlHttwFB3fT/ad3WP6BBboOB+Bs27PpVIbnOcEY8L7Ji6s
         0ZXDf4fdEh9SpXYrSNalArM6JT9Rb+jn+JeVoUMsqimnRNqPZoCtLpRyhoy/xrayx122
         IZnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=ml4K+H93SeXCIMnxVi3/6PCWqKGjDCE1p4VhTbgYGy0=;
        b=gS0ERg3CCIF2ncr26ngzn00TGTt833BhJWA8v4S081rSH5rJ/PrHiwPC/k7QOAbeek
         olCP8ZvfXWNPSU6tNIGpvsjQQC/n9YHX69wj2097rmhtowpeDGBezJqe6z73St+dEfhg
         XhfpiAIMoSmt1+SAZAfLBNXpeiJ4nIOr/szoliKMcxH84j60KJAjFLl8/OOb9LIp/Mhp
         av8sjXQd6hkbgc2VhMoeN+s7mGO0KUS0Tkx85Eibi3YFZ5Ju+ARbWXyYHR9UgLPhyze3
         GA9iktEHGF8KOTIXdxtHUB/MNNiUsJ6l9zYwDgvqlymQLoLcvCugsNzzDQobuGv0kvs3
         /Wbg==
X-Gm-Message-State: AOAM530J5E/Y76Zmr9lXelwO73NVf2/AUCLnVRhQlLKLe6I0TSRci4eR
        EBv890ObDs3FI0t12O3cHTan6k/rpqG6+sHJ5jc=
X-Google-Smtp-Source: ABdhPJwdjC49IgldtmuqtkC47LHpTDI7DHSNwH7tRMpaXAH1EPNzfRXpd2NbYWgbRKaMkFq0rEYvZ7JsWdVpGKaobTY=
X-Received: by 2002:a92:c0c8:: with SMTP id t8mr19085670ilf.176.1592844750896;
 Mon, 22 Jun 2020 09:52:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200622155018.6043-1-sedat.dilek@gmail.com>
In-Reply-To: <20200622155018.6043-1-sedat.dilek@gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 22 Jun 2020 18:52:23 +0200
Message-ID: <CA+icZUVGve+zN59_OOsW-G732uXmBGHha-+3dwE13OK338tH7g@mail.gmail.com>
Subject: Re: [PATCH 5.7] x86/crypto: aesni: Fix build with LLVM_IAS=1
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Cc:     Craig Topper <craig.topper@intel.com>,
        Craig Topper <craig.topper@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 22, 2020 at 5:50 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:

> Craig Topper suggested me in ClangBuiltLinux issue #1050:
>
> > I think the "too many positional arguments" is because the parser isn't able
> > to handle the trailing commas.
> >
> > The "unknown use of instruction mnemonic" is because the macro was named
> > GHASH_4_ENCRYPT_4_PARALLEL_DEC but its being instantiated with
> > GHASH_4_ENCRYPT_4_PARALLEL_dec I guess gas ignores case on the
> > macro instantiation, but llvm doesn't.
>

> Cc: Craig Topper <craig.topper@intel.com>
> Cc: Craig Topper <craig.topper@gmail.com>

That should be a s/Cc/Suggested-by/.

- Sedat -
