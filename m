From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: rsa - Do not gratuitously drop leading zeroes
Date: Fri, 24 Jun 2016 22:28:14 +0800
Message-ID: <20160624142814.GA21730@gondor.apana.org.au>
References: <20160622101432.GA30454@gondor.apana.org.au>
 <1f2459d0-aea9-f595-18f6-854177f0eb8d@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49630 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbcFXO2W (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 10:28:22 -0400
Content-Disposition: inline
In-Reply-To: <1f2459d0-aea9-f595-18f6-854177f0eb8d@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 23, 2016 at 08:25:05AM -0700, Tadeusz Struk wrote:
> 
> The reason why mpi_write_to_sgl() strips the leading zeros is only
> because we said that it needs to work in the same way as the
> mpi_read_buffer(), which does remove it for whatever reason.
> So should we now change the mpi_read_buffer() as well?

Didn't we add mpi_read_buffer specifically for akcipher before
we switched over to SGs? If nobody is using it we should just
delete it.

> We also need to change the qat rsa implementation because it does remove
> zeros as well, but it will be very easy to do.

The way it's done with my patches you don't have to do the conversion
right away because it'll cope with either stripping or not stripping
leading zeroes.  But yes it should simplify the code in qat so please
send in patches when you have time.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
