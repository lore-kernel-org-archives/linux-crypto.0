From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 0/3] crypto: algif_skcipher - fixes after skcipher
 conversion
Date: Mon, 1 Feb 2016 21:06:44 +0800
Message-ID: <20160201130644.GA6904@gondor.apana.org.au>
References: <20160128152354.5394.90834.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44355 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204AbcBANGt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 08:06:49 -0500
Content-Disposition: inline
In-Reply-To: <20160128152354.5394.90834.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 28, 2016 at 07:23:54AM -0800, Tadeusz Struk wrote:
> Hi Herbert,
> While testing the algif_aead async patch, I have rerun the async
> algif_skcipher tests and I have found some problems.
> There are three different issues around algif_skcipher and skcipher.
> Two are skcipher conversion related, and one is a bug in the
> algif_skcipher, not related to the conversion. It started to
> manifest itself after a fix the the qat driver.

OK I've decided to fix this differently.  The expectation of getting
back the original request is incorrect.  There are multiple places
where we will return a request other than the original.

We should probably change the API so that instead of passing the
struct crypto_async_request we just pass in void * instead.  That
way nobody could make this mistake.

Anyway, the following patches should fix the algif_skcipher issue.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
