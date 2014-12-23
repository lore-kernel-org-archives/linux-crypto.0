From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Using separate initcall level for crypto subsystem
Date: Wed, 24 Dec 2014 08:17:16 +1100
Message-ID: <20141223211716.GB3051@gondor.apana.org.au>
References: <EB9C4333-B282-4D94-9713-C986F1B7E931@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Johan Hedberg <johan.hedberg@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:48270 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbaLWVRU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Dec 2014 16:17:20 -0500
Content-Disposition: inline
In-Reply-To: <EB9C4333-B282-4D94-9713-C986F1B7E931@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 22, 2014 at 10:46:47AM -0800, Marcel Holtmann wrote:
> Hi,
> 
> we wanted to add some crypto selftests to the Bluetooth subsystem that checks our usage of the crypto handling we use for Bluetooth Low Energy Legacy Pairing and Secure Connections.
> 
> Since the Crypto subsystem and Bluetooth subsystem both use subsys_initcall that goes horrible wrong when running it built-in. So I wonder if it would make sense to introduce a crypto_initcall that comes before the subsys_initcall.
> 
> Any thoughts on this?

If it's just for self-tests would it be possible for them to be
done after system boot-up?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
