From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - fix invalid check for RSA keylen in fips
 mode
Date: Tue, 21 Jul 2015 20:26:12 +0800
Message-ID: <20150721122611.GB25104@gondor.apana.org.au>
References: <20150721001827.24523.30789.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, dan.carpenter@oracle.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33192 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbbGUM0g (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jul 2015 08:26:36 -0400
Content-Disposition: inline
In-Reply-To: <20150721001827.24523.30789.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 20, 2015 at 05:18:27PM -0700, Tadeusz Struk wrote:
> The condition checking allowed key length was invalid.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
