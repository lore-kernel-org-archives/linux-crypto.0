Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9D4C7EE2E
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Jun 2023 09:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbjFHJFn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Jun 2023 05:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235746AbjFHJFk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Jun 2023 05:05:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02AEE50;
        Thu,  8 Jun 2023 02:05:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 392FA64B1C;
        Thu,  8 Jun 2023 09:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BEAC433EF;
        Thu,  8 Jun 2023 09:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1686215133;
        bh=b/HhhLn8tA5xrBrydV1Af1DGSHM7acWjZVlMLxM9uro=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wx+Ytz28FmOSrtoOj0sYpKdPCfHo7/V7si2xru3lCENMHSox1yvRNu2+3HF8SW7Om
         bRGeeMjINHGIaDXuxAVasZ5j4vUmfITRq6dXuCl6wII8GPZKZTP0taIa5G/KbnCc7P
         R7oZ76z31qQc0r5gniCFz7Dr70yDEgifTkSfWe/A=
Date:   Thu, 8 Jun 2023 11:05:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Richard Fontana <rfontana@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Franziska Naepelt <franziska.naepelt@googlemail.com>,
        Linux SPDX Licenses <linux-spdx@vger.kernel.org>,
        Linux Kernel Janitors <kernel-janitors@vger.kernel.org>,
        Linux Crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Alexander Kjeldaas <astor@fast.no>,
        Herbert Valerio Riedel <hvr@hvrlab.org>,
        Kyle McMartin <kyle@debian.org>,
        "Adam J . Richter" <adam@yggdrasil.com>,
        Dr Brian Gladman <brg@gladman.me.uk>,
        Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 1/8] crypto: Convert dual BSD 3-Clause/GPL 2.0
 boilerplate to SPDX identifier
Message-ID: <2023060850-shakable-dynamite-c4ff@gregkh>
References: <20230607053940.39078-10-bagasdotme@gmail.com>
 <20230607053940.39078-11-bagasdotme@gmail.com>
 <CAC1cPGxD6xOLksyMHCcreFyEv5Yoo50LY=xM9BmOEP=oECoNww@mail.gmail.com>
 <CAMj1kXGnzphm5Wyz7RfZdWVxPnEihR0NGy5mFs4neQM+7EfEGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMj1kXGnzphm5Wyz7RfZdWVxPnEihR0NGy5mFs4neQM+7EfEGQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 08, 2023 at 10:37:33AM +0200, Ard Biesheuvel wrote:
> On Wed, 7 Jun 2023 at 16:38, Richard Fontana <rfontana@redhat.com> wrote:
> >
> > On Wed, Jun 7, 2023 at 1:42 AM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
> > >
> > > Replace license boilerplate for dual BSD-3-Clause/GPL 2.0 (only or
> > > later) with corresponding SPDX license identifier.
> >
> > This is at least the fourth or fifth time (I'm losing track) where you
> > have incorrectly assumed a particular non-GPL license text matches a
> > particular SPDX identifier without (apparently) checking.
> >
> 
> What exactly does 'checking' entail here? There is no guidance in
> Documentation/process/license-rules.rst on how to perform this
> comparison.
> 
> Also, checkpatch now complains about missing SPDX identifiers, which
> is what triggered this effort. Should it stop doing that?
> 
> > Bagas, I urge that you learn more about the nature of SPDX identifiers
> > before submitting any further patches at least involving replacement
> > of non-GPL notices with SPDX identifiers. For this unprecedented
> > license notice replacement initiative to have any legitimacy it must
> > attempt to apply SPDX identifiers correctly.
> >
> 
> Since we're in language pedantic mode: it must do more than attempt,
> it must apply them correctly, period.
> 
> Arguably, this is an 'attempt to apply SPDX identifiers correctly' on
> Bagas's part, which apparently falls short (and I may be guilty of the
> same for some arch crypto code)
> 
> So what is the ambition here: do we just leave the ambiguous ones as-is?

I recommend yes, leave them as-is until the legal people who actually
care about having SPDX lines in all of the files take the time to do the
work to resolve these issues.

Remember, they are the ones asking for it, no need for us to do their
work for them :)

thanks,

greg k-h
