From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: quesiton on async cipher
Date: Fri, 17 Jul 2009 14:26:35 +0800
Message-ID: <20090717062635.GA11410@gondor.apana.org.au>
References: <51FE95B17FDB99418C84C914C13FB37D5A469250@orsmsx509.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: "Ramakesavan, Ramu" <ramu.ramakesavan@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:45019 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934092AbZGQG0i (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jul 2009 02:26:38 -0400
Content-Disposition: inline
In-Reply-To: <51FE95B17FDB99418C84C914C13FB37D5A469250@orsmsx509.amr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ramakesavan, Ramu <ramu.ramakesavan@intel.com> wrote:
> I am new to Linux Crypto APIs. I can see usage of asynchronous cipher algorithms in testmgr.c. Is there a sample implementation for async cipher driver that uses crypto_ablkcipher or crypto_ahash? If there is one, pleas point me to it. 

Have a look under drivers/crypto.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
