Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F310BC43334
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 02:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbiGUCh0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jul 2022 22:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbiGUChV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jul 2022 22:37:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D714A77547
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jul 2022 19:37:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 450E86006F
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 02:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FF7C341C7;
        Thu, 21 Jul 2022 02:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658371039;
        bh=nio2uohUp0eR0gZ5g5Bj68K5/J7oe6DZYxXrqFzgJZg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MAWGi15WSQCw328cz1F6HitqqRXhgAEvgeVHA40gRrvwnjx/eFIimYwgjpjSj9guD
         YOQychJedPvP4Y7hFaXZzR3XDhijeHzQ44KJ09veFsFWJB2h5kxCD1p13xQb5XxoT3
         CTouDfREJ0tuhrli7SOcM3r7KMnlNhjcVAXjdkC+Cj3I6fKydtAxC6e3CDZxc6TILu
         JnYw9Rg7FRUhEC9XGKaPNXQthOySWaOz2fiVRa5QIFcUF7jdb/y3AcXdb28LR9JsNv
         qHPAwIN7zzS7vWtiTowKMGhCUh0Xyo316JnIPxy9yk7vd16QlnDNr1eJG9WKHA/ut9
         2ZMrejdMWp3Fg==
Date:   Wed, 20 Jul 2022 19:37:17 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Guozihua (Scott)" <guozihua@huawei.com>
Cc:     Will Deacon <will@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, catalin.marinas@arm.com
Subject: Re: [PATCH v2] arm64/crypto: poly1305 fix a read out-of-bound
Message-ID: <Yti73XyFb8l7n2gU@sol.localdomain>
References: <20220712075031.29061-1-guozihua@huawei.com>
 <20220720094116.GC15752@willie-the-truck>
 <a29cb083-0305-3467-976c-e541daefc5e8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a29cb083-0305-3467-976c-e541daefc5e8@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 20, 2022 at 05:57:30PM +0800, Guozihua (Scott) wrote:
> On 2022/7/20 17:41, Will Deacon wrote:
> > On Tue, Jul 12, 2022 at 03:50:31PM +0800, GUO Zihua wrote:
> > > A kasan error was reported during fuzzing:
> > 
> > [...]
> > 
> > > This patch fixes the issue by calling poly1305_init_arm64() instead of
> > > poly1305_init_arch(). This is also the implementation for the same
> > > algorithm on arm platform.
> > > 
> > > Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: GUO Zihua <guozihua@huawei.com>
> > > ---
> > >   arch/arm64/crypto/poly1305-glue.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > I'm not a crypto guy by any stretch of the imagination, but Ard is out
> > at the moment and this looks like an important fix so I had a crack at
> > reviewing it.
> > 
> > > diff --git a/arch/arm64/crypto/poly1305-glue.c b/arch/arm64/crypto/poly1305-glue.c
> > > index 9c3d86e397bf..1fae18ba11ed 100644
> > > --- a/arch/arm64/crypto/poly1305-glue.c
> > > +++ b/arch/arm64/crypto/poly1305-glue.c
> > > @@ -52,7 +52,7 @@ static void neon_poly1305_blocks(struct poly1305_desc_ctx *dctx, const u8 *src,
> > >   {
> > >   	if (unlikely(!dctx->sset)) {
> > >   		if (!dctx->rset) {
> > > -			poly1305_init_arch(dctx, src);
> > > +			poly1305_init_arm64(&dctx->h, src);
> > >   			src += POLY1305_BLOCK_SIZE;
> > >   			len -= POLY1305_BLOCK_SIZE;
> > >   			dctx->rset = 1;
> > 
> > With this change, we no longer initialise dctx->buflen to 0 as part of the
> > initialisation. Looking at neon_poly1305_do_update(), I'm a bit worried
> > that we could land in the 'if (likely(len >= POLY1305_BLOCK_SIZE))' block,
> > end up with len == 0 and fail to set dctx->buflen. Is this a problem, or is
> > my ignorance showing?
> > 
> > Will
> > .
> 
> Thanks Will.
> 
> I noticed this as well, but I leaved it out so that the behavior is the same
> as the implementation for arm. The buflen here seems to be used for
> maintaining any excessive data after the last block, and is zeroed during
> init. I am not sure why it should be zeroed again during key initialization.
> Maybe the thought was that the very first block of the data is always used
> for initializing rset and that is also considered to be the "initialization"
> process for the algorithm, thus the zeroing of buflen. I could be completely
> wrong though.
> 

buflen is initialized by neon_poly1305_init(), so there's no issue here.

- Eric
