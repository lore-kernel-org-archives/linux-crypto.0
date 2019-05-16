Return-Path: <SRS0=FyHQ=TQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF8F0C04E84
	for <linux-crypto@archiver.kernel.org>; Thu, 16 May 2019 02:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7E7320873
	for <linux-crypto@archiver.kernel.org>; Thu, 16 May 2019 02:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557975368;
	bh=TQQOh+GWzjppP/yoefvWnQUIY57aNXLvaCVcxSM4Cos=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Z74mj5Dl3gSzi1jy20Zqdw1s51/acp1jFLBEf/tGdBz8QwRZWCVvOkDYa0GfYK/z6
	 PHgCPcNoKv9+8Bv1iXQnjDvSXEo997/QvIai387PSiZcJk3eUg9gzO5mX+3fk+gmJ+
	 +rHkiDR4DG9lpbFdzN7mHFNwsyjGk20ClghjNYLU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfEPC4H (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 22:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfEPC4H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 22:56:07 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6762520848;
        Thu, 16 May 2019 02:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557975366;
        bh=TQQOh+GWzjppP/yoefvWnQUIY57aNXLvaCVcxSM4Cos=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f8xAWetoxViGqcLLrXE1ZBoxuj5LXHi+Y3NQ0zuqiKCzm80F58a3w5bUE5CJx6LM/
         Y0mtyMb19YeFXtRsO8JaRBMX63pIyDl1Lel6Lft9oy7jwqcEVmsn3Gqe5+33Bx0APv
         3NOCsjwtmxfPokAtzdTUsHHw+nKK0TIV0YFF5nc8=
Date:   Wed, 15 May 2019 19:56:04 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Daniel Axtens <dja@axtens.net>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nayna <nayna@linux.vnet.ibm.com>, leo.barbosa@canonical.com,
        Stephan Mueller <smueller@chronox.de>, nayna@linux.ibm.com,
        omosnacek@gmail.com, leitao@debian.org, pfsmorigo@gmail.com,
        linux-crypto@vger.kernel.org, marcelo.cerri@canonical.com,
        George Wilson <gcwilson@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] crypto: vmx - fix copy-paste error in CTR mode
Message-ID: <20190516025603.GB23200@sol.localdomain>
References: <87imvkwqdh.fsf@dja-thinkpad.axtens.net>
 <2c8b042f-c7df-cb8b-3fcd-15d6bb274d08@linux.vnet.ibm.com>
 <8736mmvafj.fsf@concordia.ellerman.id.au>
 <20190506155315.GA661@sol.localdomain>
 <20190513005901.tsop4lz26vusr6o4@gondor.apana.org.au>
 <87pnomtwgh.fsf@concordia.ellerman.id.au>
 <877eat0wi0.fsf@dja-thinkpad.axtens.net>
 <20190515035336.y42wzhs3wzqdpwzn@gondor.apana.org.au>
 <874l5w1axv.fsf@dja-thinkpad.axtens.net>
 <871s0z171b.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871s0z171b.fsf@dja-thinkpad.axtens.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 16, 2019 at 12:12:48PM +1000, Daniel Axtens wrote:
> 
> I'm also seeing issues with ghash with the extended tests:
> 
> [    7.582926] alg: hash: p8_ghash test failed (wrong result) on test vector 0, cfg="random: use_final src_divs=[<reimport>9.72%@+39832, <reimport>18.2%@+65504, <reimport,nosimd>45.57%@alignmask+18, <reimport,nosimd>15.6%@+65496, 6.83%@+65514, <reimport,nosimd>1.2%@+25, <reim"
> 
> It seems to happen when one of the source divisions has nosimd and the
> final result uses the simd finaliser, so that's interesting.
> 

The bug is that p8_ghash uses different shash_descs for the SIMD and no-SIMD
cases.  So if you start out doing the hash in SIMD context but then switch to
no-SIMD context or vice versa, the digest will be wrong.  Note that there can be
an ->export() and ->import() in between, so it's not quite as obscure a case as
one might think.

To fix it I think you'll need to make p8_ghash use 'struct ghash_desc_ctx' just
like ghash-generic so that the two code paths can share the same shash_desc.
That's similar to what the various SHA hash algorithms do.

- Eric
