From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - fix SKU definiftion for c3xxx dev
Date: Fri, 25 Dec 2015 21:46:28 +0800
Message-ID: <20151225134628.GD16174@gondor.apana.org.au>
References: <20151223153628.8771.71889.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34881 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbbLYNqa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Dec 2015 08:46:30 -0500
Content-Disposition: inline
In-Reply-To: <20151223153628.8771.71889.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 23, 2015 at 07:36:28AM -0800, Tadeusz Struk wrote:
> c3xxx doesn't have the esram BAR and only has 6 ue.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
