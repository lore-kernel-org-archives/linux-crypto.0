From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: don't raise alarm for no ctr(aes*) tests in
	fips mode
Date: Tue, 5 May 2009 09:08:47 +0800
Message-ID: <20090505010847.GA13071@gondor.apana.org.au>
References: <200904282118.22823.jarod@redhat.com> <20090504111010.GA4991@gondor.apana.org.au> <200905041456.59427.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40262 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754074AbZEEBIv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 May 2009 21:08:51 -0400
Content-Disposition: inline
In-Reply-To: <200905041456.59427.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 04, 2009 at 02:56:58PM -0400, Jarod Wilson wrote:
>
> Ah... Now I think I see... We can provide an initial counter w/o a
> problem, but counter incrementation is implementation-specific, so

Not in Linux.  If you're going to provide ctr you'd better increment
in the way the current implementation does it.  Otherwise anything
that wraps around it, such as RFC3686 will fail.

Another way to put it, only the counter mode as used in RFC 3686,
CCM and GCM is what we call ctr.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
