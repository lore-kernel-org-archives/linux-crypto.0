From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 0/2] crypto: akcipher - Changes to asymmetric key API
Date: Wed, 14 Oct 2015 22:26:50 +0800
Message-ID: <20151014142650.GB17455@gondor.apana.org.au>
References: <20151008162644.2509.28472.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51882 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbbJNO0z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 10:26:55 -0400
Content-Disposition: inline
In-Reply-To: <20151008162644.2509.28472.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 08, 2015 at 09:26:44AM -0700, Tadeusz Struk wrote:
> This series updates the asymmetric key API.
> The changes include
>  - setkey function has been split into set_priv_key and set_pub_key.
>  - akcipher requests takes sgl for src and dst instead of void *.
> Users of the API i.e. two existing RSA implementation and
> test mgr code have been updated accordingly.

Both applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
