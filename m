Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1442C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Jan 2021 06:27:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A329023120
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Jan 2021 06:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbhAMG1o (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Jan 2021 01:27:44 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:37498 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbhAMG1n (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Jan 2021 01:27:43 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kzZcK-0008CB-GL; Wed, 13 Jan 2021 17:26:53 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 13 Jan 2021 17:26:52 +1100
Date:   Wed, 13 Jan 2021 17:26:52 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] crypto: reduce minimum alignment of on-stack
 structures
Message-ID: <20210113062652.GA12495@gondor.apana.org.au>
References: <20210108171706.10306-1-ardb@kernel.org>
 <X/jLtI1m96DD+QLO@sol.localdomain>
 <CAMj1kXE8SPE+2HazN6whvYr5anZWJJ8n4UAVyotPV1XySkk0Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXE8SPE+2HazN6whvYr5anZWJJ8n4UAVyotPV1XySkk0Rg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 08, 2021 at 11:49:32PM +0100, Ard Biesheuvel wrote:
>
> The assumption is that ARCH_SLAB_MINALIGN should be sufficient for any
> POD type, But I guess that in order to be fully correct, the actual
> alignment of the struct type should be ARCH_SLAB_MINALIGN, and __ctx
> should just be padded out so it appears at an offset that is a
> multiple of ARCH_KMALLOC_ALIGN.

How about just leaving the skcpiher alone for now and change shash
only?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
