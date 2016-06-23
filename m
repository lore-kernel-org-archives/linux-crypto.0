From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: crypto: rsa - Do not gratuitously drop leading zeroes
Date: Thu, 23 Jun 2016 08:25:05 -0700
Message-ID: <1f2459d0-aea9-f595-18f6-854177f0eb8d@intel.com>
References: <20160622101432.GA30454@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:35745 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbcFWPZG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Jun 2016 11:25:06 -0400
In-Reply-To: <20160622101432.GA30454@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,
On 06/22/2016 03:14 AM, Herbert Xu wrote:
> This was prompted by the caam RSA submission where a lot of work
> was done just to strip the RSA output of leading zeroes.  This is
> in fact completely pointless because the only user of RSA in the
> kernel then promptly puts them back.
> 
> This patch series resolves this madness by simply leaving any
> leading zeroes in place.

The reason why mpi_write_to_sgl() strips the leading zeros is only
because we said that it needs to work in the same way as the
mpi_read_buffer(), which does remove it for whatever reason.
So should we now change the mpi_read_buffer() as well?
The mpi_read_buffer() is called from mpi_get_buffer(), which is used
only by lib/digsig.c
We also need to change the qat rsa implementation because it does remove
zeros as well, but it will be very easy to do.
Thanks,
--
TS
