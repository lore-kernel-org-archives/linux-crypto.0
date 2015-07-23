From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - Fix invalid synchronization between
 register/unregister sym algs
Date: Thu, 23 Jul 2015 18:12:05 +0800
Message-ID: <20150723101205.GA13181@gondor.apana.org.au>
References: <20150722050747.29130.79115.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: qat-linux@intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43384 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbbGWKMP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Jul 2015 06:12:15 -0400
Content-Disposition: inline
In-Reply-To: <20150722050747.29130.79115.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 21, 2015 at 10:07:47PM -0700, Tadeusz Struk wrote:
> The synchronization method used atomic was bogus.
> Use a proper synchronization with mutex.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied to crypto.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
