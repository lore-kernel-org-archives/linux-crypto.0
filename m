Return-Path: <SRS0=l+Io=37=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6732AC35242
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 19:21:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46C28206DB
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 19:21:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A2TzVFOW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730852AbgBKTVW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Feb 2020 14:21:22 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:32943 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729800AbgBKTVW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Feb 2020 14:21:22 -0500
Received: by mail-wr1-f67.google.com with SMTP id u6so13947816wrt.0;
        Tue, 11 Feb 2020 11:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AEGWYfFX9245MukYgsGUL84+IjZfZx4XP83WQpnQkHw=;
        b=A2TzVFOW6F10JBsePK3zu458Q3Vas14sw10YF6Uo0daSQJAYxApnG0/CppNxgLNFkC
         62caMBdepV56f3CUUlOGU1KMLPNHRoueumUKE2HrBlFOmST6YIO4peQ2p09gyEwJmj45
         5blcd8z3oTfYeXi546h4IE/QNiwSLqbjbYFZVKoWrNvWW0WeybSkyQY1qjOuCk6lwS8M
         146Tc1XPAJNAS2SJg0O/FbFcT2NnuCqFGrRnMU6Bm9SAQOAOsLY81z3wjRg7l0fxhw/P
         Ag1ghXSk0KrokGHYloHR6z3m78+C13HNldnl1QEKCm6GXf9PpRXqqhzs1e6y0eITbChv
         jfHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AEGWYfFX9245MukYgsGUL84+IjZfZx4XP83WQpnQkHw=;
        b=Y5Yz3woum8OPo0SeENOeGLCqv4o3WhKjZaVXWzKnoWrHrKN/6McoDpJTHGYF568QeR
         7Agl3KK1LfpSIEwKO7EG8cq9C+WBbC3083dWtHLiTVzNF/oCb6FZ9Sl19ylMJ1M7A+wu
         wMmHJMh5J/gxgMb356WB1Ve0pm/slZiA+qBFnW5qzFy8jDjr1Lmx2lCvZ/CLJzhH/KuS
         EwPAHokT2zGNN/GFpTmQYHMHNuIPWK2NU9QTyo0wrjNsWA6YZStq3iT1X09nt153VewS
         dU6pMtJ9WebRFV/AXZnulLMYIzpH3vb3YrYwAIqSzOa1e03xaSxrlYJisx8cvJlU8DHk
         pg+w==
X-Gm-Message-State: APjAAAWEFxXD6uWqrZHxCUHAf4N20Yw1B7u7zGbVsSDMK3DhSeuS6Oip
        2F7KTIAP1QfW++ijoIDohO8=
X-Google-Smtp-Source: APXvYqwMsryykfh9h+LtceOZt3ZKFIXxSljklwP6UXWA+eNQZ2lUmaSyqT7uS6SmQh98ZjvSee7Rwg==
X-Received: by 2002:a5d:6082:: with SMTP id w2mr10143766wrt.300.1581448880361;
        Tue, 11 Feb 2020 11:21:20 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id q10sm4941740wme.16.2020.02.11.11.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 11:21:19 -0800 (PST)
Date:   Tue, 11 Feb 2020 20:21:18 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] crypto: export() overran state buffer on test vector
Message-ID: <20200211192118.GA24059@Red>
References: <20200206085442.GA5585@Red>
 <20200207065719.GA8284@sol.localdomain>
 <20200207104659.GA10979@Red>
 <20200208085713.ftuqxhatk6iioz7e@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200208085713.ftuqxhatk6iioz7e@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Feb 08, 2020 at 04:57:13PM +0800, Herbert Xu wrote:
> On Fri, Feb 07, 2020 at 11:46:59AM +0100, Corentin Labbe wrote:
> >
> > My goal is to do like n2-crypto/rk3288crypto/etc..., fallback for init/update/final/finup and only do stuff with digest().
> > So I have just exactly copied what they do.
> 
> n2 at least is totally broken wrt import/export.  The other ones
> would work provided that the fallback have the same statesize as
> the generic sha implementations.
> 

This behavour happen only on arm64, so it is why probably nobody (rockchip/n2) found it.

> Are you not using the standard state sizes?

I use the standard size (statesize = sizeof(struct shaxxx_state))

As a quick workaround, By simply adding (+ 8), all test pass.

> 
> This should probably be switched over to lib/crypto or at least
> shash.
> 

Do you mean that I should abandon ahash as a fallback ?
