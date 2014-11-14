From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 4/4] crypto: qat - Add new algif interface for
 userspace
Date: Fri, 14 Nov 2014 09:19:11 +0800
Message-ID: <20141114011911.GA10647@gondor.apana.org.au>
References: <20141106195931.13328.90501.stgit@tstruk-mobl1>
 <20141106195953.13328.77022.stgit@tstruk-mobl1>
 <20141107025607.GA9474@gondor.apana.org.au>
 <545C3FDB.4010106@intel.com>
 <20141107040531.GA9865@gondor.apana.org.au>
 <545C5786.4030205@intel.com>
 <20141107053105.GA17825@gondor.apana.org.au>
 <545D2200.2020107@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:35168 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965175AbaKNBTk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Nov 2014 20:19:40 -0500
Content-Disposition: inline
In-Reply-To: <545D2200.2020107@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 07, 2014 at 11:48:16AM -0800, Tadeusz Struk wrote:
>
> This way I can get much higher throughput than with algif_skcipher.

Yes that's a worthy optimisation.  See if you can change the
current implementation (without changing the interface) to achieve
this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
