From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: "crypto_hash_setkey" call from atomic context
Date: Mon, 14 Dec 2015 17:57:00 +0800
Message-ID: <20151214095700.GA32274@gondor.apana.org.au>
References: <CACzeOEfg9x+aEwuP9xH3BLd5+RzpDBZBGsnsLw7skW9FP5LVGw@mail.gmail.com>
 <20151211074223.GA11688@gondor.apana.org.au>
 <CACzeOEfOSi7T2CmE1HjU-ryCGEBj-b0h2E-o0BrmKWiFvMcEHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"Nordell, Joakim" <joakim.nordell@intel.com>,
	"Chen, Shujuan" <shujuan.chen@intel.com>, doru.gucea@intel.com
To: Fabrizio Demaria <fabrizio.f.demaria@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36955 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127AbbLNJ5V (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Dec 2015 04:57:21 -0500
Content-Disposition: inline
In-Reply-To: <CACzeOEfOSi7T2CmE1HjU-ryCGEBj-b0h2E-o0BrmKWiFvMcEHQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 14, 2015 at 09:53:03AM +0100, Fabrizio Demaria wrote:
> In our MPTCP implementation we handled the setkey problem by
> pre-allocating a properly aligned key's buffer right after
> "crypto_alloc_hash", outside atomic context [1]. Would this workaround
> be enough to guarantee that "crypto_hash_setkey" can be safely called
> in atomic contexts? Is it always the case that "crypto_hash_setkey"
> calls "crypto_shash_setkey"?

First of all don't use crypto_hash_* in new code.  It is obsolete.
Instead use shash or ahash as appropirate.

The proper way to manage keys is to set them when you allocate the
tfm.  You should use a different tfm for each key.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
