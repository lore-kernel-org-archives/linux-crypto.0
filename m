From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: testmgr - don't print info about missing test
 for gcm-aes-aesni
Date: Thu, 25 Jun 2015 23:36:45 +0800
Message-ID: <20150625153645.GC11592@gondor.apana.org.au>
References: <20150624160130.480.47360.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56471 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbbFYPgs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Jun 2015 11:36:48 -0400
Content-Disposition: inline
In-Reply-To: <20150624160130.480.47360.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 24, 2015 at 09:01:30AM -0700, Tadeusz Struk wrote:
> Don't print info about missing test for the internal
> helper __driver-gcm-aes-aesni
> 
> changes in v2:
>  - marked test as fips allowed
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
