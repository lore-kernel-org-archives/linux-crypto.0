Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82CE1C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Apr 2022 07:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbiDNHPH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Apr 2022 03:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239697AbiDNHPF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Apr 2022 03:15:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66A655BCB
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 00:12:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60EABB82885
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 07:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA511C385A1;
        Thu, 14 Apr 2022 07:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649920358;
        bh=mHsm/KVIiiqXAvfxFBibENJBp14StG55eEmV6KtUU7o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VOZnuUFhKPSG33bI3VShr4M7GGUXjhPtFcKaX6fdpUM0+pbESSV0nv79FmYd9II0+
         LxxOvtdEbvd5azyjv+nlzHf/H09ZyHWKloKyWfhUt9ZSW3bkHYdI0/vJH6zSBT5CXO
         CHyMP0BMz/pnE8mnb08mGRnkn4eMURGFCmGn8+WU9VBCsQp5BzLfyMcu3bl5K+1Wdq
         QFABvBtrL1nBgS/bfJ+Jto2HclppSzw3FAXVqcw+vOOj1bgcZ0dXTwd1cjRGRfQG3K
         +88O9MJjcB0NNxBcY87iTY0ZD093f2hub2jCycHl+y+vECZ8ECyrflr3nCNuDCxcyN
         K4Lm0+EaTUBGg==
Date:   Thu, 14 Apr 2022 00:12:35 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v4 8/8] fscrypt: Add HCTR2 support for filename encryption
Message-ID: <YlfJYwwCukoGuLek@sol.localdomain>
References: <20220412172816.917723-1-nhuck@google.com>
 <20220412172816.917723-9-nhuck@google.com>
 <YlZpUijo/1nJp0Bw@sol.localdomain>
 <CAMj1kXH1C8W6Cxa7jTZ8_h3L4_Xefwv2=r1JRNva101CvWWsjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXH1C8W6Cxa7jTZ8_h3L4_Xefwv2=r1JRNva101CvWWsjw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 13, 2022 at 08:16:25AM +0200, Ard Biesheuvel wrote:
> > > diff --git a/tools/include/uapi/linux/fscrypt.h b/tools/include/uapi/linux/fscrypt.h
> > > index 9f4428be3e36..a756b29afcc2 100644
> > > --- a/tools/include/uapi/linux/fscrypt.h
> > > +++ b/tools/include/uapi/linux/fscrypt.h
> > > @@ -27,7 +27,8 @@
> > >  #define FSCRYPT_MODE_AES_128_CBC             5
> > >  #define FSCRYPT_MODE_AES_128_CTS             6
> > >  #define FSCRYPT_MODE_ADIANTUM                        9
> > > -/* If adding a mode number > 9, update FSCRYPT_MODE_MAX in fscrypt_private.h */
> > > +#define FSCRYPT_MODE_AES_256_HCTR2           10
> > > +/* If adding a mode number > 10, update FSCRYPT_MODE_MAX in fscrypt_private.h */
> > >
> >
> > As far as I know, you don't actually need to update the copy of UAPI headers in
> > tools/.  The people who maintain those files handle that.  It doesn't make sense
> > to have copies of files in the source tree anyway.
> >
> 
> Doesn't the x86 build emit a warning if these go out of sync?

The warning is emitted when building tools/perf/, not the kernel itself.

According to https://lore.kernel.org/r/20191001185741.GD13904@kernel.org, the
perf maintainers actually prefer that their files are *not* updated for them.
And I'd like to push back against having duplicate source files in the tree
anyway, for obvious reasons.  So I think we shouldn't update this file.

- Eric
