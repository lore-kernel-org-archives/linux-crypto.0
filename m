Return-Path: <SRS0=SwA+=7B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25872C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 16:21:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF3A6207FB
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 16:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589905275;
	bh=v27vEe2JM1UncKn/5D03sqG7NqFVE9XFsHfr2tHsF7g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=MGnGgSyeoTFiGCDD9aWJ7DrrpWwImMaRD5eJiweNBASjsvFJJ1IT91PdeYKvgchob
	 H/Yz7jrnIlDfYxBK3fow9PfNjJm9/S3oy8XylqBM7eUBXh1G4qH1HsLUudBG1CHP8Y
	 5iLA22w6iaB3c6GNM53rKui3md5DAHbYTBPU30uw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgESQVO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 May 2020 12:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728775AbgESQVO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 May 2020 12:21:14 -0400
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 396A42081A
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2020 16:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589905273;
        bh=v27vEe2JM1UncKn/5D03sqG7NqFVE9XFsHfr2tHsF7g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GtcSE9sWz3GJxIMoJ+DCdOuUqw3eKLXAhoOr1BVnXBRSNBTomFW5yXPUYA1rJSo2I
         Zxm5TFYl84Zb1vPezktWScnO+RI5SHHAQp/fhJudze0Auodk7rZW1ViBBV2dCNU8sq
         IvsIExiENn78SNoNlpiY5gM5/SUtjI6T2FzTvGWw=
Received: by mail-il1-f175.google.com with SMTP id n11so14014091ilj.4
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2020 09:21:13 -0700 (PDT)
X-Gm-Message-State: AOAM533n5BySQfoj2BfNET34LeVy5l+pnNGiHog4P8PFsNThky4x9UjX
        yqgydN8r1OjzGleSmP7tLHRpoaPo2TLb/G/zdV8=
X-Google-Smtp-Source: ABdhPJydmxHf69KbeX0vEyoztloRwO6wq2NKeXG/xHSTbshuMSwAcahtWy8qqskK35WwyAt3+CGyni3KCVzyuueVuQA=
X-Received: by 2002:a92:3556:: with SMTP id c83mr19980414ila.218.1589905272662;
 Tue, 19 May 2020 09:21:12 -0700 (PDT)
MIME-Version: 1.0
References: <4311723.JCXmkh6OgN@tauon.chronox.de>
In-Reply-To: <4311723.JCXmkh6OgN@tauon.chronox.de>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 19 May 2020 18:21:01 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHscmtLq=tA7zUgiNqZYgTFjfREL5EK6ZnoDCFp52GWGw@mail.gmail.com>
Message-ID: <CAMj1kXHscmtLq=tA7zUgiNqZYgTFjfREL5EK6ZnoDCFp52GWGw@mail.gmail.com>
Subject: Re: ARM CE: CTS IV handling
To:     Stephan Mueller <smueller@chronox.de>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(+ Eric)

Hi Stephan,

On Tue, 19 May 2020 at 17:31, Stephan Mueller <smueller@chronox.de> wrote:
>
> Hi Ard,
>
> The following report applies to kernel 5.3 as I am currently unable to test
> the latest upstream version.
>
> The CTS IV handling for cts-cbc-aes-ce and cts-cbc-aes-neon is not consistent
> with the C implementation for CTS such as cts(cbc-aes-ce) and cts(cbc-aes-
> neon).
>
> For example, assume encryption operation with the following data:
>
> iv "6CDD928D19C56A2255D1EC16CAA2CCCB"
> pt
> "2D6BFE335F45EED1C3C404CAA5CA4D41FF2B8C6DE94C706B10F1D207972DE6599C92E117E3CBF61F"
> key "930E9D4E65DB121E05F11A16E408AE82"
>
> When you perform one encryption operation, all 4 ciphes return:
>
> 022edfa38975b09b295e1958efde2104be1e8e70c81340adfbdf431d5c80e77b89df5997aa96af72
>
> Now, when you leave the TFM untouched (i.e. retain the IV state) and simply
> set the following new pt:
>
> 6cdd928d19c56a2255d1ec16caa2cccb022edfa38975b09b295e1958efde2104be1e8e70c81340ad
>
> the C CTS implementations return
>
> 35d54eb425afe7438c5e96b61b061f04df85a322942210568c20a5e78856c79c0af021f3e0650863
>
> But the cts-cbc-aes-ce and cts-cbc-aes-neon return
>
> a62f57efbe9d815aaf1b6c62f78a31da8ef46e5d401eaf48c261bcf889e6910abbc65c2bf26add9f
>
>
> My hunch is that the internal IV handling is different. I am aware that CTS
> does not exactly specify how the IV should look like after the encryption
> operation, but using the NIST reference implementation of ACVP, the C CTS
> implementation is considered to be OK whereas the ARM CE assembler
> implementation is considered to be not OK.
>
> Bottom line, feeding plaintext in chunks into the ARM CE assembler
> implementation will yield a different output than the C implementation.
>

To be honest, this looks like the API is being used incorrectly. Is
this a similar issue to the one Herbert spotted recently with the CTR
code?

When you say 'leaving the TFM untouched' do you mean the skcipher
request? The TFM should not retain any per-request state in the first
place.

The skcipher request struct is not meant to retain any state either -
the API simply does not support incremental encryption if the input is
not a multiple of the chunksize.

Could you give some sample code on how you are using the API in this case?
