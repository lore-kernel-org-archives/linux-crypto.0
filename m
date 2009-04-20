From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/3] crypto: add self-tests for rfc4309(ccm(aes))
Date: Mon, 20 Apr 2009 14:26:40 +0800
Message-ID: <20090420062640.GB1135@gondor.apana.org.au>
References: <200904091434.59639.jarod@redhat.com> <200904150835.38818.jarod@redhat.com> <200904150935.15947.jarod@redhat.com> <200904150937.11979.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:33648 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751548AbZDTG0n (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2009 02:26:43 -0400
Content-Disposition: inline
In-Reply-To: <200904150937.11979.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 15, 2009 at 09:37:11AM -0400, Jarod Wilson wrote:
> Add an array of encryption and decryption + verification self-tests
> for rfc4309(ccm(aes)).
> 
> Test vectors all come from sample FIPS CAVS files provided to
> Red Hat by a testing lab. Unfortunately, all the published sample
> vectors in RFC 3610 and NIST Special Publication 800-38C contain nonce
> lengths that the kernel's rfc4309 implementation doesn't support, so
> while using some public domain vectors would have been preferred, its
> not possible at this time.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

This one looks good to me.  So if you just drop patch 1 (unless
there's something I'm missing), change patch 2 to use continue
and resubmit, then I'll put them in cryptodev.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
