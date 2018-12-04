Return-Path: <SRS0=wDfx=ON=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8473C04EB8
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Dec 2018 23:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98AAA206B6
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Dec 2018 23:45:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="rD6MxdnJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98AAA206B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbeLDXpJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Dec 2018 18:45:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbeLDXpJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Dec 2018 18:45:09 -0500
Received: from gmail.com (unknown [104.132.1.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB1CD206B6;
        Tue,  4 Dec 2018 23:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1543967108;
        bh=d4SxL0JSbjSaH2lWJM7qnIzpMidnCOP5TOHZHmRPfEQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rD6MxdnJukbVM8ZVLNIs7f2myNBqhgMaFfMo+UEVJdnxAT51pt5eFzC8Kr3F3nGSQ
         wAXgQoUEliy2q2ncunC8f4irD2p+FEQGVfOdNmOvRkHjSs7l95gM2EZUCz0TJZcges
         x/XeACPLMyS4eMjESi7d2fr08SApK+mNstr74cog=
Date:   Tue, 4 Dec 2018 15:45:07 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>, linux-fscrypt@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] fscrypt: remove CRYPTO_CTR dependency
Message-ID: <20181204234506.GD70682@gmail.com>
References: <20180905192400.71160-1-ebiggers@kernel.org>
 <CAKv+Gu8=dDk+bes8O7oOQ3zTgPHyVi49-gwH1btwdys-vgfyqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8=dDk+bes8O7oOQ3zTgPHyVi49-gwH1btwdys-vgfyqg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181204234507.RCMzFAq8A28CwXiTN4MPyM1qk_m_B4I7jYVGRDfi4hw@z>

On Thu, Sep 06, 2018 at 12:43:41PM +0200, Ard Biesheuvel wrote:
> On 5 September 2018 at 21:24, Eric Biggers <ebiggers@kernel.org> wrote:
> > From: Eric Biggers <ebiggers@google.com>
> >
> > fscrypt doesn't use the CTR mode of operation for anything, so there's
> > no need to select CRYPTO_CTR.  It was added by commit 71dea01ea2ed
> > ("ext4 crypto: require CONFIG_CRYPTO_CTR if ext4 encryption is
> > enabled").  But, I've been unable to identify the arm64 crypto bug it
> > was supposedly working around.
> >
> > I suspect the issue was seen only on some old Android device kernel
> > (circa 3.10?).  So if the fix wasn't mistaken, the real bug is probably
> > already fixed.  Or maybe it was actually a bug in a non-upstream crypto
> > driver.
> >
> > So, remove the dependency.  If it turns out there's actually still a
> > bug, we'll fix it properly.
> >
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> This may be related to
> 
> 11e3b725cfc2 crypto: arm64/aes-blk - honour iv_out requirement in CBC
> and CTR modes
> 
> given that the commit in question mentions CTS. How it actually works
> around the issue is unclear to me, though.
> 
> 
> 
> 
> > ---
> >  fs/crypto/Kconfig | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
> > index 02b7d91c92310..284b589b4774d 100644
> > --- a/fs/crypto/Kconfig
> > +++ b/fs/crypto/Kconfig
> > @@ -6,7 +6,6 @@ config FS_ENCRYPTION
> >         select CRYPTO_ECB
> >         select CRYPTO_XTS
> >         select CRYPTO_CTS
> > -       select CRYPTO_CTR
> >         select CRYPTO_SHA256
> >         select KEYS
> >         help
> > --
> > 2.19.0.rc2.392.g5ba43deb5a-goog
> >

Ping.  Ted, can you consider applying this to the fscrypt tree for 4.21?

Thanks,

- Eric
