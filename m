From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] crypto: qat: Fix random config build warnings
Date: Thu, 26 Jun 2014 14:51:44 +0800
Message-ID: <20140626065144.GA17901@gondor.apana.org.au>
References: <20140624221833.3872.65930.stgit@tstruk-mobl1.intel.com>
 <20140624221924.3872.42454.stgit@tstruk-mobl1.intel.com>
 <20140625133658.GA10122@gondor.apana.org.au>
 <53AAD410.4090400@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, bruce.w.allan@intel.com,
	linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:58883 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaFZGvt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Jun 2014 02:51:49 -0400
Content-Disposition: inline
In-Reply-To: <53AAD410.4090400@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 25, 2014 at 06:52:16AM -0700, Tadeusz Struk wrote:
> On 06/25/2014 06:36 AM, Herbert Xu wrote:
> >>  	struct icp_qat_fw_la_resp *qat_resp = resp;
> >> >  	struct qat_crypto_request *qat_req =
> >> > -			(void *)(dma_addr_t)qat_resp->opaque_data;
> >> > +				(void *)(__force long)qat_resp->opaque_data;
> > Why not just get rid of the (__force long) altogether?
> It complains when cross compiled for 32bit.

OK all applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
