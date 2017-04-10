From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: authenc: crash if key is not set
Date: Mon, 10 Apr 2017 18:54:34 +0800
Message-ID: <20170410105434.GA8562@gondor.apana.org.au>
References: <13796038.esLDiIrSPd@positron.chronox.de>
 <20170410104125.GA8427@gondor.apana.org.au>
 <6053931.eUnbK4IiOn@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:51850 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752757AbdDJKyy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Apr 2017 06:54:54 -0400
Content-Disposition: inline
In-Reply-To: <6053931.eUnbK4IiOn@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 10, 2017 at 12:49:16PM +0200, Stephan Müller wrote:
>
> May I ask that we agree on the memory management fix prior to handling this 
> issue? When consolidating the common code, I plan to have common code for the 
> nokey logic which then is automatically applicable to aead too.

I think we should fix this first.  Mixing this with the other
issue is going to make backporting harder.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
