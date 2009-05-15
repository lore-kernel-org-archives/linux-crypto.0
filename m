From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: mark algs allowed in fips mode
Date: Fri, 15 May 2009 15:17:18 +1000
Message-ID: <20090515051718.GA9624@gondor.apana.org.au>
References: <200905071441.27093.jarod@redhat.com> <200905071527.59809.jarod@redhat.com> <20090508021233.GA20388@gondor.apana.org.au> <4A03BB57.3040807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59397 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762442AbZEOFRV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 May 2009 01:17:21 -0400
Content-Disposition: inline
In-Reply-To: <4A03BB57.3040807@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 08, 2009 at 12:55:51AM -0400, Jarod Wilson wrote:
> Set the fips_allowed flag in testmgr.c's alg_test_descs[] for algs
> that are allowed to be used when in fips mode.

Both patches applied.  Thanks Jarod!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
