From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: HW Accelerated IPSEC?
Date: Fri, 10 Jun 2011 08:59:51 +0800
Message-ID: <20110610005951.GA27419@gondor.apana.org.au>
References: <4DF116AB.8020105@borg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Kent Borg <kentborg@borg.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:35102 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab1FJA74 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jun 2011 20:59:56 -0400
Content-Disposition: inline
In-Reply-To: <4DF116AB.8020105@borg.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Kent Borg <kentborg@borg.org> wrote:
> Kent Borg wrote:
>> Does HW acceleration of IPSEC work?
> 
> [...sounds of crickets...]
> 
> Let me re-phrase the question.
> 
> Should loading a crypto module (in this case mv_cesa in a Sheevaplug) 
> cause IPSec to break?  (Is the crypto system wired up with IPSec?  Does 
> that wiring work?)

Since your IPsec is actually breaking, then mv_cesa is probably
getting used.

Did you compile in the self-test suite (unset
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS)?

It sounds like a bug in mv_cesa.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
