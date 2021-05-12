Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B5AC41515
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 22:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F9B561420
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 22:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhELWYS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 18:24:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1391355AbhELV0h (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 17:26:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A87C2613E6
        for <linux-crypto@vger.kernel.org>; Wed, 12 May 2021 21:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620854728;
        bh=IGcdttm/efsi9wyuzy8aRbmONo4WCnKnqQbbyC7kjaU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uTjfLKWUa0yKz/BoDY+6MEKYa8MAjfW8CdM3jM8KJ+PNrHRjvCKvCuVAm9qkBdd34
         vV6Mv+Cc8qqFZ/AFd3aF9KEqkiLlfz6IenV9ervJ9tszynZkK+NZHlu0RnW/qxXP32
         SbLFYQybCBZ2ktQweH/vHO+vI0iRfuh1SabM/CA8IVJslicYTj0IAGAUoMLhmyPUi8
         PiTnudhGP4oZTrBULrDcNzxLHPAW+CXLCgdkiJsK0NbFCEyZzwD0hAymATwIprwHaZ
         ISn0zfWRJCWYFeNvsKFZ0tIGFclPzl4L530iTFHdbJWf1ZzqlW+HMetvdRBFZN9r59
         JBOob8Ou35jkw==
Received: by mail-ot1-f50.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso21825744otb.13
        for <linux-crypto@vger.kernel.org>; Wed, 12 May 2021 14:25:28 -0700 (PDT)
X-Gm-Message-State: AOAM530rK5Bh4+Qu07pX6FQ2pVhV5bXgvlyIrGTq5ONa8yDFtMb+Td1B
        9onfJRpRunv2Nx9uXRv9/n3TGfTZh11N9+KIL8E=
X-Google-Smtp-Source: ABdhPJz27EoyMK1A8vlNtsnpAJAWPLNjT66+j88vDFe9UUwDafPfWjTVqfB4HkS1YA4OWIDfzC1xoX1xR4OaZYmt/sA=
X-Received: by 2002:aca:4056:: with SMTP id n83mr387700oia.47.1620854727957;
 Wed, 12 May 2021 14:25:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210512184439.8778-1-ardb@kernel.org> <20210512184439.8778-6-ardb@kernel.org>
 <YJw1zrPQMqKDVeih@gmail.com>
In-Reply-To: <YJw1zrPQMqKDVeih@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 12 May 2021 23:25:16 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHN6f03=BQXAx0A84yiE7-YbGdg12GRfoF-fnRyT9xnpg@mail.gmail.com>
Message-ID: <CAMj1kXHN6f03=BQXAx0A84yiE7-YbGdg12GRfoF-fnRyT9xnpg@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] crypto: arm64/aes-neonbs - stop using SIMD helper
 for skciphers
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Will Deacon <will@kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 12 May 2021 at 22:08, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, May 12, 2021 at 08:44:37PM +0200, Ard Biesheuvel wrote:
> > Calls into the skcipher API can only occur from contexts where the SIMD
> > unit is available, so there is no need for the SIMD helper.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>
> It would be helpful if the commit message made it clear that "Calls into the
> skcipher API can only occur from contexts where the SIMD unit is available" is
> something that is now the case but wasn't the case previously.  Otherwise I
> could see people backporting this patch without its prerequisites.
>
> Likewise for some of the other patches in this patchset.
>

OK
