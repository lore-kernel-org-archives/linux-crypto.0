From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: rsa - fix invalid check for keylen in fips mode
Date: Tue, 21 Jul 2015 20:25:21 +0800
Message-ID: <20150721122521.GA25104@gondor.apana.org.au>
References: <20150721001826.24499.51560.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, dan.carpenter@oracle.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33321 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbbGUMZ5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jul 2015 08:25:57 -0400
Content-Disposition: inline
In-Reply-To: <20150721001826.24499.51560.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 20, 2015 at 05:18:26PM -0700, Tadeusz Struk wrote:
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
