From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v8 1/3] crypto: Key-agreement Protocol Primitives API
 (KPP)
Date: Tue, 14 Jun 2016 19:34:30 +0800
Message-ID: <20160614113430.GA21063@gondor.apana.org.au>
References: <1465854948-9084-1-git-send-email-salvatore.benedetto@intel.com>
 <1465854948-9084-2-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60725 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbcFNLef (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2016 07:34:35 -0400
Content-Disposition: inline
In-Reply-To: <1465854948-9084-2-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 13, 2016 at 10:55:46PM +0100, Salvatore Benedetto wrote:
>
> +struct kpp_alg {
> +	int (*set_secret)(struct crypto_kpp *tfm, void *buffer);

Sorry I think we need to change this.  Leaving this with no type
checking between the user and the driver is a recipe for disaster.

I think the easiest solution is to use either BER encoding like
rsa.c or netlink encoding like authenc.c.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
