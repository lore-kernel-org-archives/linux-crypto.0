Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB04FC4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Nov 2022 09:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiKYJDW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Nov 2022 04:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiKYJDV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Nov 2022 04:03:21 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8548F31F98;
        Fri, 25 Nov 2022 01:03:18 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oyUbu-000hD4-Kt; Fri, 25 Nov 2022 17:03:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Nov 2022 17:03:02 +0800
Date:   Fri, 25 Nov 2022 17:03:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Robert Elliott <elliott@hpe.com>, davem@davemloft.net,
        tim.c.chen@linux.intel.com, ap420073@gmail.com,
        David.Laight@aculab.com, ebiggers@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 10/24] crypto: x86/poly - limit FPU preemption
Message-ID: <Y4CExnFX46mk4/1+@gondor.apana.org.au>
References: <20221103042740.6556-1-elliott@hpe.com>
 <20221116041342.3841-1-elliott@hpe.com>
 <20221116041342.3841-11-elliott@hpe.com>
 <Y3TF7/+DejcnN0eV@zx2c4.com>
 <Y4B/kjS0lgzdUJHG@gondor.apana.org.au>
 <CAMj1kXHHm+L=qE5opDXhjoWZt+1eKXFeGVS=OdvyF0VNFZivCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHHm+L=qE5opDXhjoWZt+1eKXFeGVS=OdvyF0VNFZivCA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 25, 2022 at 09:59:17AM +0100, Ard Biesheuvel wrote:
>
> On arm64, this is implemented in an assembler macro 'cond_yield' so we
> don't need to preserve/restore the SIMD state state at all if the
> yield is not going to result in a call to schedule(). For example, the
> SHA3 code keeps 400 bytes of state in registers, which we don't want
> to save and reload unless needed. (5f6cb2e617681 'crypto:
> arm64/sha512-ce - simplify NEON yield')

Yes this would be optimally done from the assembly code which
would make a difference if they benefited from larger block sizes.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
