From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 0/3] crypto: algif_skcipher - fixes after skcipher
 conversion
Date: Wed, 3 Feb 2016 21:36:48 +0800
Message-ID: <20160203133648.GA29251@gondor.apana.org.au>
References: <20160201130644.GA6904@gondor.apana.org.au>
 <E1aQED3-00022H-5o@gondolin.me.apana.org.au>
 <56AFC83D.2010005@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45502 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbcBCNgy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Feb 2016 08:36:54 -0500
Content-Disposition: inline
In-Reply-To: <56AFC83D.2010005@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 01, 2016 at 01:03:57PM -0800, Tadeusz Struk wrote:
> 
> I think this should be:
> sreq = kzalloc(sizeof(*sreq) + reqsize + ivsize, GFP_KERNEL);

Good catch.  Here is another spin.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
