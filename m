Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D51C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 06:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236921AbiA0Gll (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 01:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236915AbiA0Gle (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 01:41:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05710C061714
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jan 2022 22:41:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 940B261922
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 06:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D04C340E4;
        Thu, 27 Jan 2022 06:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643265693;
        bh=lzDQMFtkVMDafmie07laIN0lN6oP7zl0X8fnYkvNQFY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U6QNH45/yC6nbNc8SibffGI61BMM8w/QOXzTGQEi3QmSBHDted7mupgwtgVH60A/+
         b9eh21zctwW4cpE7G4XIaNtY0W6IuvDzBHiYublj5I3UvO6LFPZI0irImcZ22rLKiM
         9ArZfYKMJPsg/cV4x8PRmLm2JXRxcZqwx9VThVBGDcG0C5c64yxMPeUi5zrGPTfdpO
         pUeEWZ1TiCajf8E+O1O0RLP2AwjQrwstN/1D3Nht67wNtF/v/8P03M6JZ8VUWyH+iZ
         hMNuq4NL4EGZab9n7oTHgds94vYhpYJox3ns+o0ZjTMJ/8R6J8d38L87YOoh9P5ELf
         f3cjTOQjSpJ0Q==
Date:   Wed, 26 Jan 2022 22:41:31 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Nathan Huckleberry <nhuck@google.com>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [RFC PATCH 3/7] crypto: hctr2 - Add HCTR2 support
Message-ID: <YfI+m9tqj/B4fEzj@sol.localdomain>
References: <20220125014422.80552-1-nhuck@google.com>
 <20220125014422.80552-4-nhuck@google.com>
 <YfIo1pL69+GRsSzp@sol.localdomain>
 <YfIrr8MagPw9scLr@gondor.apana.org.au>
 <YfIvSXgnUMoPglCt@sol.localdomain>
 <YfIwQFAqSW68VQ62@gondor.apana.org.au>
 <YfIxUPc1KsSMTMLq@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfIxUPc1KsSMTMLq@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 27, 2022 at 04:44:48PM +1100, Herbert Xu wrote:
> On Thu, Jan 27, 2022 at 04:40:16PM +1100, Herbert Xu wrote:
> >
> > The question is is it performance-critical? Including it as a
> > parameter would be worthwhile if it is.  But if its cost is dwarfed
> > by that of the accompanying operations then it might not be worth
> > the complexity.
> 
> It looks like this is similar to the situation in XTS where I chose
> not to make it a full parameter during the skcipher conversion:
> 
> commit f1c131b45410a202eb45cc55980a7a9e4e4b4f40
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Tue Nov 22 20:08:19 2016 +0800
> 
>     crypto: xts - Convert to skcipher
> 
> Cheers,

Sure, that makes sense.

Note that if the meaning of the first parameter to the template will differ
(blockcipher_name vs. xctr_name), the full syntax probably should be supported
by a separate template called "hctr2_base" rather than by "hctr2", to avoid
having the meaning of the first parameter be context-dependent.  This would be
like gcm and gcm_base.  So we'd have e.g.:

	hctr2(aes)
	hctr2_base(xctr-aes-aesni,polyval-pclmulqdqni)

cra_name would be set to the former, while cra_driver_name would be set to the
latter.

- Eric
