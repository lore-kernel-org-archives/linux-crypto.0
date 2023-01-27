Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB73C61DA4
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Jan 2023 11:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbjA0LKA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Jan 2023 06:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbjA0LJ4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Jan 2023 06:09:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40C6126FD;
        Fri, 27 Jan 2023 03:09:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F40061B03;
        Fri, 27 Jan 2023 11:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6515C433EF;
        Fri, 27 Jan 2023 11:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674817794;
        bh=Rvc7pjf+AN6/eCdtwoY/n3UBsgh8HAsQA3tHglV1ekI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cFh4QDBIcXCeNBMEtG5/Yha1H7jwRuc8oVG77lBtYjCVXsGu9HTAC12kWSteg9mHJ
         yZQj2/XzkTtyZWNezDvPAcv1O2ph0juzWs12NEnC+rgOi9E8NrlSaaRPLHQ9MhQ+Iv
         TsyqxmiOayXl8rv+SyXpyRoAybUvYhPGUel2zL4ybhLriUpqP9TEcpLnB1DdwCelor
         m9bid/udwZKi7pU/Z0r/IvPxoVSNPO/NV4O4NOkk2aV/ndw5ti9c95ObFFNumQbY/R
         LMNbwF8E0u6KCix2nkuTJxT6kisK7/nTxVBM1Z4w2D1yE8llZtVCIxuXgaagPZo2cn
         EWzyFNlfPmYvw==
Received: by mail-lf1-f45.google.com with SMTP id x40so7559181lfu.12;
        Fri, 27 Jan 2023 03:09:54 -0800 (PST)
X-Gm-Message-State: AFqh2koxZFEOqT6DbDTJ4i33nEwWePKCYIDG/BgAxKEwV1TEc4cX9s1I
        N/r+BhzjmzC3lM1V7VZ3RkniD663O0eU6+Myf74=
X-Google-Smtp-Source: AMrXdXsze0x4tj3RhFk2kYwD2OXo5wp6M26DhtTwjztVd6iuZ0v3TKG4yj9EDtSjFuROVRAwiLS3m9OM4YPN0OoAga8=
X-Received: by 2002:a19:8c19:0:b0:4ca:f3c2:2670 with SMTP id
 o25-20020a198c19000000b004caf3c22670mr3651560lfd.166.1674817792807; Fri, 27
 Jan 2023 03:09:52 -0800 (PST)
MIME-Version: 1.0
References: <CAMj1kXE3v1_pUVT4HSCoVZO512cGMxjBNcDEhLpf22v9iFmoSA@mail.gmail.com>
 <Y9OtDvgp3SsxuVf4@gondor.apana.org.au>
In-Reply-To: <Y9OtDvgp3SsxuVf4@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 27 Jan 2023 12:09:41 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGQGEwe7Ea3mu7VKCNd22hzE4cnHPXP4WzxYKcqwYzLzA@mail.gmail.com>
Message-ID: <CAMj1kXGQGEwe7Ea3mu7VKCNd22hzE4cnHPXP4WzxYKcqwYzLzA@mail.gmail.com>
Subject: Re: [PATCH] crypto: x86 - exit fpu context earlier in ECB/CBC macros
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     conor.dooley@microchip.com, peter@n8pjl.ca,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 27 Jan 2023 at 11:53, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > I am still receiving encrypted messages, and given that I am a direct
> > recipient, the mailing list server does not cc me then unencrypted
> > copies.
> >
> > I am not going to reply to the patch until it lands in my inbox in
> > plaintext, sorry ...
>
> As Ard needs to review this patch, until this is resolved I won't
> be applying this.
>

I've received the plaintext version in the mean time, it's on another thread.

So we can close this one.
