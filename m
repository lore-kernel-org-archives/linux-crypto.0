From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] api: Set default CRYPTO_MINALIGN to unsigned long long
Date: Tue, 8 Jan 2008 17:15:48 +1100
Message-ID: <20080108061548.GE2529@gondor.apana.org.au>
References: <20080108060911.GA4305@gondor.apana.org.au> <20080107.221425.140140329.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4443 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753261AbYAHGPu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Jan 2008 01:15:50 -0500
Content-Disposition: inline
In-Reply-To: <20080107.221425.140140329.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 07, 2008 at 10:14:25PM -0800, David Miller wrote:
>
> Not to nit-pick but the CRYPTO_MINALIGN ifdef there at the
> end is superfluous.  It will always be defined.

Good point.  I'll get rid of that too.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
