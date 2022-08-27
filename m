Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2662BC0502C
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Aug 2022 06:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiH0Gfy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Aug 2022 02:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiH0Gfw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Aug 2022 02:35:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8416312A82
        for <linux-crypto@vger.kernel.org>; Fri, 26 Aug 2022 23:35:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3161DB82851
        for <linux-crypto@vger.kernel.org>; Sat, 27 Aug 2022 06:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971A7C433D6;
        Sat, 27 Aug 2022 06:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661582149;
        bh=4ukL5nKui8A7SJAeu5ss3ychNHHjE0c/XrF0g3q8WJk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PuLwE6NgYbidKuHHrK8J3+e3zImwIdwKsfkouYq86/zYFGupOWJqQ0g6RLORjvjub
         o2HgojGT2glqUGBY97R6l1yi5IMWLmMgZVTudNrwTjO6o7KUAoqq50wAXYOjoGJK3+
         ajiqCNVGMrSEEIIuRdmz50Z09O/feOaXD0nH17C8jHq1uzhVzHH9BMV3VK2SFEVUek
         6Y9uPG1IVSy0aseVHjKZ42q6w7ZYm/ybFhno5i0zaBELU2lacV/QAplU+QSmri1iMp
         MWhiv0Q4j95iIONGab4YiLg4dN832gjBdctn1Yh/I8n/ZD8zlRDyBvxwsbUEp5j1ds
         WvAxDIyTvS4IQ==
Date:   Fri, 26 Aug 2022 23:35:46 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, elliott@hpe.com
Subject: Re: [PATCH v2 2/3] crypto: aria-avx: add AES-NI/AVX/x86_64 assembler
 implementation of aria cipher
Message-ID: <Ywm7QrJqsil3XoKY@sol.localdomain>
References: <20220826053131.24792-1-ap420073@gmail.com>
 <20220826053131.24792-3-ap420073@gmail.com>
 <YwmFouIyIlOMqKb4@sol.localdomain>
 <d19470f9-7aa7-e4e2-5a45-bd8e2839e109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d19470f9-7aa7-e4e2-5a45-bd8e2839e109@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Aug 27, 2022 at 03:30:55PM +0900, Taehee Yoo wrote:
> Hi Eric,
> Thanks for your review!
> 
> 2022. 8. 27. 오전 11:46에 Eric Biggers 이(가) 쓴 글:
> > On Fri, Aug 26, 2022 at 05:31:30AM +0000, Taehee Yoo wrote:
> >> +static struct skcipher_alg aria_algs[] = {
> >> +	{
> >> +		.base.cra_name		= "__ecb(aria)",
> >> +		.base.cra_driver_name	= "__ecb-aria-avx",
> >> +		.base.cra_priority	= 400,
> >> +		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
> >> +		.base.cra_blocksize	= ARIA_BLOCK_SIZE,
> >> +		.base.cra_ctxsize	= sizeof(struct aria_ctx),
> >> +		.base.cra_module	= THIS_MODULE,
> >> +		.min_keysize		= ARIA_MIN_KEY_SIZE,
> >> +		.max_keysize		= ARIA_MAX_KEY_SIZE,
> >> +		.setkey			= aria_avx_set_key,
> >> +		.encrypt		= aria_avx_ecb_encrypt,
> >> +		.decrypt		= aria_avx_ecb_decrypt,
> >> +	}
> >> +};
> >
> > Why do you want ECB mode and nothing else?  At
> > https://lore.kernel.org/r/51ce6519-9f03-81b6-78b0-43c313705e74@gmail.com
> > you claimed that the use case for ARIA support in the kernel is kTLS.
> >
> > So you are using ECB mode in TLS?
> >
> 
> aria-ktls only uses GCM mode.
> So, ECB will not be used by ktls.
> 
> My plan is to implement the GCM aria-avx eventually.
> ECB implementation will be a basic block of aria-avx.
> I think it can be used by gcm(aria).
> So, I will implement gcm mode of aria with this implementation.
> 
> If this plan is not good, please let me know.
> If so, I will change my plan :)

GCM uses CTR mode, not ECB mode.

- Eric
