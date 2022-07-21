Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDC5C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 09:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbiGUJ3O (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 05:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbiGUJ3K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 05:29:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7995A77A44
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 02:29:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2491A61F43
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 09:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09568C3411E;
        Thu, 21 Jul 2022 09:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658395744;
        bh=KEw8DJskb+PpDSC3YoCIg+9N695Dji/DNPBN8KYVkdc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eUaFp8AFW8YXdERoEetTOLC2u7uiXq+CUrIREd5VD4Nboma6aOESnnLdhd1VMD8+7
         xEyfmrqCCHDadu+ZfzNwj5zT9BK6wGHkDm+/wymgvf1LTuBzJn6oXSWJSF/VQcax/z
         rsSqQrVIYroUuzub1cDHflSRnc52TpbB4A10b+E6cWM0L10rftBYegVqgWQdaRdziB
         tJKaJGX6Zepam4sCaU0lD+W4uKubmdkccYwnD8EumgdBbHg9qR/hxlYIhGmgGuSWQ+
         9ZhUn3svn5MT635ySRz44gUe3XfyvA72NXYtYdYApAHki24Gi3N7NlzDFhsumrhaWX
         1Ouy/OC8thbLw==
Date:   Thu, 21 Jul 2022 10:28:58 +0100
From:   Will Deacon <will@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Guozihua (Scott)" <guozihua@huawei.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        catalin.marinas@arm.com
Subject: Re: [PATCH v2] arm64/crypto: poly1305 fix a read out-of-bound
Message-ID: <20220721092858.GA17088@willie-the-truck>
References: <20220712075031.29061-1-guozihua@huawei.com>
 <20220720094116.GC15752@willie-the-truck>
 <a29cb083-0305-3467-976c-e541daefc5e8@huawei.com>
 <Yti73XyFb8l7n2gU@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yti73XyFb8l7n2gU@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 20, 2022 at 07:37:17PM -0700, Eric Biggers wrote:
> On Wed, Jul 20, 2022 at 05:57:30PM +0800, Guozihua (Scott) wrote:
> > On 2022/7/20 17:41, Will Deacon wrote:
> > > On Tue, Jul 12, 2022 at 03:50:31PM +0800, GUO Zihua wrote:
> > > > A kasan error was reported during fuzzing:
> > > 
> > > [...]
> > > 
> > > > This patch fixes the issue by calling poly1305_init_arm64() instead of
> > > > poly1305_init_arch(). This is also the implementation for the same
> > > > algorithm on arm platform.
> > > > 
> > > > Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: GUO Zihua <guozihua@huawei.com>
> > > > ---
> > > >   arch/arm64/crypto/poly1305-glue.c | 2 +-
> > > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > I'm not a crypto guy by any stretch of the imagination, but Ard is out
> > > at the moment and this looks like an important fix so I had a crack at
> > > reviewing it.
> > > 
> > > > diff --git a/arch/arm64/crypto/poly1305-glue.c b/arch/arm64/crypto/poly1305-glue.c
> > > > index 9c3d86e397bf..1fae18ba11ed 100644
> > > > --- a/arch/arm64/crypto/poly1305-glue.c
> > > > +++ b/arch/arm64/crypto/poly1305-glue.c
> > > > @@ -52,7 +52,7 @@ static void neon_poly1305_blocks(struct poly1305_desc_ctx *dctx, const u8 *src,
> > > >   {
> > > >   	if (unlikely(!dctx->sset)) {
> > > >   		if (!dctx->rset) {
> > > > -			poly1305_init_arch(dctx, src);
> > > > +			poly1305_init_arm64(&dctx->h, src);
> > > >   			src += POLY1305_BLOCK_SIZE;
> > > >   			len -= POLY1305_BLOCK_SIZE;
> > > >   			dctx->rset = 1;
> > > 
> > > With this change, we no longer initialise dctx->buflen to 0 as part of the
> > > initialisation. Looking at neon_poly1305_do_update(), I'm a bit worried
> > > that we could land in the 'if (likely(len >= POLY1305_BLOCK_SIZE))' block,
> > > end up with len == 0 and fail to set dctx->buflen. Is this a problem, or is
> > > my ignorance showing?
> > > 
> > > Will
> > > .
> > 
> > Thanks Will.
> > 
> > I noticed this as well, but I leaved it out so that the behavior is the same
> > as the implementation for arm. The buflen here seems to be used for
> > maintaining any excessive data after the last block, and is zeroed during
> > init. I am not sure why it should be zeroed again during key initialization.
> > Maybe the thought was that the very first block of the data is always used
> > for initializing rset and that is also considered to be the "initialization"
> > process for the algorithm, thus the zeroing of buflen. I could be completely
> > wrong though.
> > 
> 
> buflen is initialized by neon_poly1305_init(), so there's no issue here.

Ah yes, thanks. I missed that. In which case, for the very little it's
worth:

Acked-by: Will Deacon <will@kernel.org>

Herbert, please can you pick this up?

Will
