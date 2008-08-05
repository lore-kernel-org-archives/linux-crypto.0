From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add fips_enable flag
Date: Tue, 5 Aug 2008 14:14:22 +0800
Message-ID: <20080805061422.GA19801@gondor.apana.org.au>
References: <20080730203407.GA14674@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.linux.org, davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58039 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752574AbYHEGQg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Aug 2008 02:16:36 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KQFqU-0003BF-Hg
	for <linux-crypto@vger.kernel.org>; Tue, 05 Aug 2008 16:16:34 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1KQFqU-0005Bm-00
	for <linux-crypto@vger.kernel.org>; Tue, 05 Aug 2008 14:16:34 +0800
Content-Disposition: inline
In-Reply-To: <20080730203407.GA14674@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 30, 2008 at 04:34:07PM -0400, Neil Horman wrote:
>
> +int fips_enabled;

This didn't build for me:

  Building modules, stage 2.
  MODPOST 58 modules
WARNING: "fips_enabled" [crypto/crypto_algapi.ko] undefined!

So I've added an EXPORT_SYMBOL_GPL on it and applied to cryptodev-2.6.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
