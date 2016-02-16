From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/2] crypto: asynchronous compression api
Date: Tue, 16 Feb 2016 19:57:17 +0000
Message-ID: <20160216195717.GA4207@gondor.apana.org.au>
References: <20160209105355.GA10652@gondor.apana.org.au>
 <1455039069-17475-1-git-send-email-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58999 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbcBPT5W (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2016 14:57:22 -0500
Content-Disposition: inline
In-Reply-To: <1455039069-17475-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 09, 2016 at 05:31:07PM +0000, Giovanni Cabiddu wrote:
>
> Changes in v2:
>     - added compression and decompression request sizes in acomp_alg
>       in order to enable noctx support
>     - extended api with helpers to allocate compression and
>       decompression requests with different context sizes

Can you give an example on how to use the noctx support with
your acomp interface?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
