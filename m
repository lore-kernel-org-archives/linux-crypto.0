From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/4] crypto: akcipher: add crypto_akcipher_type methods
 needed by templates.
Date: Tue, 17 Nov 2015 21:42:51 +0800
Message-ID: <20151117134251.GA9363@gondor.apana.org.au>
References: <1447412495-4370-3-git-send-email-andrew.zaborowski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Andrew Zaborowski <andrew.zaborowski@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46482 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbbKQNm4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Nov 2015 08:42:56 -0500
Content-Disposition: inline
In-Reply-To: <1447412495-4370-3-git-send-email-andrew.zaborowski@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Andrew Zaborowski <andrew.zaborowski@intel.com> wrote:
> Add two dummy methods that are required by the crypto API internals:
> .ctxsize and .init
> (just because the framework calls them without checking if they were
> provided).  They're only required by the complicated code path needed to
> instantiate a template algorithm.  Also expose crypto_akcipher_type like
> other crypto types are exposed to be used from outside modules.
> 
> Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>

Nack.  They are only required if you use obsolete methods of creating
a tfm.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
