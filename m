From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] crypto: ensure algif_hash does not pass a zero-sized
 state
Date: Fri, 9 Oct 2015 18:42:42 +0800
Message-ID: <20151009104242.GA1591@gondor.apana.org.au>
References: <20151009102904.GL32532@n2100.arm.linux.org.uk>
 <E1ZkUvo-0004QO-U8@rmk-PC.arm.linux.org.uk>
 <20151009103428.GA1410@gondor.apana.org.au>
 <20151009104106.GM32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39918 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964AbbJIKmv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 06:42:51 -0400
Content-Disposition: inline
In-Reply-To: <20151009104106.GM32532@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 09, 2015 at 11:41:07AM +0100, Russell King - ARM Linux wrote:
>
> Do you mean something like this?  As statesize is an unsigned int, testing
> for zero should be sufficient.

Yes looks great to me.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
