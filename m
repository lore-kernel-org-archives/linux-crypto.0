From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: qat - Don't move data inside output buffer
Date: Mon, 17 Aug 2015 16:48:54 +0800
Message-ID: <20150817084854.GA28441@gondor.apana.org.au>
References: <20150813035433.25108.3065.stgit@tstruk-mobl1>
 <20150813035445.25108.76927.stgit@tstruk-mobl1>
 <20150814051410.GA2370@gondor.apana.org.au>
 <55CD8733.2000904@intel.com>
 <20150814062636.GA2799@gondor.apana.org.au>
 <55CDF969.6070704@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: keescook@chromium.org, jwboyer@redhat.com, smueller@chronox.de,
	richard@nod.at, steved@redhat.com, linux-kernel@vger.kernel.org,
	dhowells@redhat.com, linux-crypto@vger.kernel.org,
	james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net, vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43275 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbbHQItS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Aug 2015 04:49:18 -0400
Content-Disposition: inline
In-Reply-To: <55CDF969.6070704@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 14, 2015 at 07:21:29AM -0700, Tadeusz Struk wrote:
> 
> Yes, that was wrong, sorry. The reason I wanted to change it is that
> the SW implementation can return a number with leading zeros.
> This is because mpi_read_buffer() returns the whole thing.

I think mpi_read_buffer is broken.  It should return exactly the
same thing as mpi_get_buffer, except that it should do so in the
buffer provided instead of allocating a new one.

So it most certainly should remove all leading zero bytes.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
