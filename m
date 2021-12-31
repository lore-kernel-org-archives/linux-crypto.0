Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21969C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Dec 2021 11:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhLaLe1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Dec 2021 06:34:27 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58786 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhLaLe1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Dec 2021 06:34:27 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n3GAw-0004rs-JK; Fri, 31 Dec 2021 22:34:23 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Dec 2021 22:34:22 +1100
Date:   Fri, 31 Dec 2021 22:34:22 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org, simo@redhat.com, skozina@redhat.com,
        Nicolai Stange <nstange@suse.de>
Subject: Re: [PATCH v3] crypto: jitter - add oversampling of noise source
Message-ID: <Yc7qvt5/nysNh4sW@gondor.apana.org.au>
References: <2573346.vuYhMxLoTh@positron.chronox.de>
 <4712718.vXUDI8C0e8@positron.chronox.de>
 <2790259.vuYhMxLoTh@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2790259.vuYhMxLoTh@positron.chronox.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 20, 2021 at 07:21:53AM +0100, Stephan Müller wrote:
> The output n bits can receive more than n bits of min entropy, of course,
> but the fixed output of the conditioning function can only asymptotically
> approach the output size bits of min entropy, not attain that bound.
> Random maps will tend to have output collisions, which reduces the
> creditable output entropy (that is what SP 800-90B Section 3.1.5.1.2
> attempts to bound).
> 
> The value "64" is justified in Appendix A.4 of the current 90C draft,
> and aligns with NIST's in "epsilon" definition in this document, which is
> that a string can be considered "full entropy" if you can bound the min
> entropy in each bit of output to at least 1-epsilon, where epsilon is
> required to be <= 2^(-32).
> 
> Note, this patch causes the Jitter RNG to cut its performance in half in
> FIPS mode because the conditioning function of the LFSR produces 64 bits
> of entropy in one block. The oversampling requires that additionally 64
> bits of entropy are sampled from the noise source. If the conditioner is
> changed, such as using SHA-256, the impact of the oversampling is only
> one fourth, because for the 256 bit block of the conditioner, only 64
> additional bits from the noise source must be sampled.
> 
> This patch is derived from the user space jitterentropy-library.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> Reviewed-by: Simo Sorce <simo@redhat.com>
> ---
>  crypto/jitterentropy.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
