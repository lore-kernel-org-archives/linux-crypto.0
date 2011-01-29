From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: mark ghash as fips_allowed
Date: Sat, 29 Jan 2011 15:14:51 +1100
Message-ID: <20110129041451.GC21186@gondor.apana.org.au>
References: <20110126170054.GB18067@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:60277 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab1A2EOx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Jan 2011 23:14:53 -0500
Content-Disposition: inline
In-Reply-To: <20110126170054.GB18067@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 26, 2011 at 12:00:54PM -0500, Jarod Wilson wrote:
> A self-test failure in fips mode means a panic. Well, gcm(aes)
> self-tests currently fail in fips mode, as gcm is dependent on ghash,
> which semi-recently got self-test vectors added, but wasn't marked as a
> fips_allowed algorithm. Because of gcm's dependence on what is now seen
> as a non-fips_allowed algorithm, its self-tests refuse to run.
> Previously, ghash got a pass in fips mode, due to the lack of any test
> vectors at all, and thus gcm self-tests were able to run. After this
> patch, a 'modprobe tcrypt mode=35' no longer panics in fips mode, and
> successful self-test of gcm(aes) is reported.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Both patches applied.  Thanks Jarod.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
