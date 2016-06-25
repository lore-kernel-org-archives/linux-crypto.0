From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: rsa - Do not gratuitously drop leading zeroes
Date: Sat, 25 Jun 2016 09:44:54 +0800
Message-ID: <20160625014454.GA25805@gondor.apana.org.au>
References: <20160622101432.GA30454@gondor.apana.org.au>
 <1f2459d0-aea9-f595-18f6-854177f0eb8d@intel.com>
 <20160624142814.GA21730@gondor.apana.org.au>
 <1e8d942b-a549-b8a7-58d0-19c375597cfb@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53174 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbcFYBpB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 21:45:01 -0400
Content-Disposition: inline
In-Reply-To: <1e8d942b-a549-b8a7-58d0-19c375597cfb@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 24, 2016 at 08:25:02AM -0700, Tadeusz Struk wrote:
> Yes, but now mpi_get_buffer() calls mpi_read_buffer() and it is also
> used by security/keys/dh.c

It appears to be using mpi_read_buffer gratuitously.  It should
simply use mpi_get_buffer.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
