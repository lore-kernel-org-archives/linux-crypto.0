Return-Path: <SRS0=C5lZ=DN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEFD3C4363D
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Oct 2020 12:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ACFF20789
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Oct 2020 12:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgJFMdz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Oct 2020 08:33:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgJFMdz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Oct 2020 08:33:55 -0400
Received: from gaia (unknown [95.149.105.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93ACA206F7;
        Tue,  6 Oct 2020 12:33:53 +0000 (UTC)
Date:   Tue, 6 Oct 2020 13:33:51 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Dave Martin <Dave.Martin@arm.com>
Cc:     herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
        Jeremy Linton <jeremy.linton@arm.com>, davem@davemloft.net,
        broonie@kernel.org, linux-crypto@vger.kernel.org,
        Will Deacon <will@kernel.org>, ardb@kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [BUG][PATCH] crypto: arm64: Avoid indirect branch to bti_c
Message-ID: <20201006123350.GB19213@gaia>
References: <20201006034854.2277538-1-jeremy.linton@arm.com>
 <20201006082748.GB25305@willie-the-truck>
 <20201006100121.GW6642@arm.com>
 <20201006102507.GA19213@gaia>
 <20201006104313.GX6642@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006104313.GX6642@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 06, 2020 at 11:43:14AM +0100, Dave P Martin wrote:
> On Tue, Oct 06, 2020 at 11:25:11AM +0100, Catalin Marinas wrote:
> > On Tue, Oct 06, 2020 at 11:01:21AM +0100, Dave P Martin wrote:
> > > On Tue, Oct 06, 2020 at 09:27:48AM +0100, Will Deacon wrote:
> > > > On Mon, Oct 05, 2020 at 10:48:54PM -0500, Jeremy Linton wrote:
> > > > > The AES code uses a 'br x7' as part of a function called by
> > > > > a macro. That branch needs a bti_j as a target. This results
> > > > > in a panic as seen below. Instead of trying to replace the branch
> > > > > target with a bti_jc, lets replace the indirect branch with a
> > > > > bl/ret, bl sequence that can target the existing bti_c.
> > > > > 
> > > > >   Bad mode in Synchronous Abort handler detected on CPU1, code 0x34000003 -- BTI
> > > > >   CPU: 1 PID: 265 Comm: cryptomgr_test Not tainted 5.8.11-300.fc33.aarch64 #1
> > > > >   pstate: 20400c05 (nzCv daif +PAN -UAO BTYPE=j-)
> > > > >   pc : aesbs_encrypt8+0x0/0x5f0 [aes_neon_bs]
> > > > >   lr : aesbs_xts_encrypt+0x48/0xe0 [aes_neon_bs]
> > > > >   sp : ffff80001052b730
> > > > > 
> > > > >   aesbs_encrypt8+0x0/0x5f0 [aes_neon_bs]
> > > > >    __xts_crypt+0xb0/0x2dc [aes_neon_bs]
> > > > >    xts_encrypt+0x28/0x3c [aes_neon_bs]
> > > > >   crypto_skcipher_encrypt+0x50/0x84
> > > > >   simd_skcipher_encrypt+0xc8/0xe0
> > > > >   crypto_skcipher_encrypt+0x50/0x84
> > > > >   test_skcipher_vec_cfg+0x224/0x5f0
> > > > >   test_skcipher+0xbc/0x120
> > > > >   alg_test_skcipher+0xa0/0x1b0
> > > > >   alg_test+0x3dc/0x47c
> > > > >   cryptomgr_test+0x38/0x60
> > > > > 
> > > > > Fixes: commit 0e89640b640d ("crypto: arm64 - Use modern annotations for assembly functions")
> > > > 
> > > > nit: the "commit" string shouldn't be here, and I think the linux-next
> > > > scripts will yell at us if we don't remove it.
> > > > 
> > > > > Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> > > > > ---
> > > > >  arch/arm64/crypto/aes-neonbs-core.S | 6 +++---
> > > > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > > > 
> > > > > diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
> > > > > index b357164379f6..32f53ebe5e2c 100644
> > > > > --- a/arch/arm64/crypto/aes-neonbs-core.S
> > > > > +++ b/arch/arm64/crypto/aes-neonbs-core.S
> > > > > @@ -788,7 +788,7 @@ SYM_FUNC_START_LOCAL(__xts_crypt8)
> > > > >  
> > > > >  0:	mov		bskey, x21
> > > > >  	mov		rounds, x22
> > > > > -	br		x7
> > > > > +	ret
> > > 
> > > Dang, replied on an old version.
> > 
> > Which I ignored (by default, when the kbuild test robot complains ;)).
> > 
> > > Since this is logically a tail call, could we simply be using br x16 or
> > > br x17 for this?
> > > 
> > > The architecture makes special provision for that so that the compiler
> > > can generate tail-calls.
> > 
> > So a "br x16" is compatible with a bti_c landing pad. I think it makes
> > more sense to keep it as a tail call.
> 
> Just to be clear, I'm happy either way, but I thought it would make
> sense to point this out.

I'd prefer the replacement with a br x16/17, it keeps the code pretty
much unchanged.

Jeremy, could you please respin this patch and give it a try?

Thanks.

-- 
Catalin
