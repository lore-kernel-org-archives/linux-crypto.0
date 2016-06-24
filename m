From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: crypto: rsa - Do not gratuitously drop leading zeroes
Date: Fri, 24 Jun 2016 08:25:02 -0700
Message-ID: <1e8d942b-a549-b8a7-58d0-19c375597cfb@intel.com>
References: <20160622101432.GA30454@gondor.apana.org.au>
 <1f2459d0-aea9-f595-18f6-854177f0eb8d@intel.com>
 <20160624142814.GA21730@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43447 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbcFXPZR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 11:25:17 -0400
In-Reply-To: <20160624142814.GA21730@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/24/2016 07:28 AM, Herbert Xu wrote:
> Didn't we add mpi_read_buffer specifically for akcipher before
> we switched over to SGs? If nobody is using it we should just
> delete it.
Yes, but now mpi_get_buffer() calls mpi_read_buffer() and it is also
used by security/keys/dh.c
Thanks,
-- 
TS
