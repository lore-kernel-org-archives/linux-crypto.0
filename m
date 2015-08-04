From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6/8] crypto: qat - Convert to new AEAD interface
Date: Tue, 4 Aug 2015 21:44:49 +0800
Message-ID: <20150804134449.GA30282@gondor.apana.org.au>
References: <20150730094138.GA15941@gondor.apana.org.au>
 <E1ZKkWe-0004C6-SN@gondolin.me.apana.org.au>
 <55BBDD1F.4020208@intel.com>
 <20150802012354.GB10055@gondor.apana.org.au>
 <55BF9E4E.6020006@intel.com>
 <20150804095909.GA28167@gondor.apana.org.au>
 <55C0BDA2.2030302@intel.com>
 <20150804133218.GA30148@gondor.apana.org.au>
 <55C0C12C.2030207@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40926 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112AbbHDNow (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Aug 2015 09:44:52 -0400
Content-Disposition: inline
In-Reply-To: <55C0C12C.2030207@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 04, 2015 at 06:42:04AM -0700, Tadeusz Struk wrote:
> On 08/04/2015 06:32 AM, Herbert Xu wrote:
> > What if someone calls adf_remove? For a software implementation
> > you can prevent the algorithm from going away by holding module
> > reference counts.  But a device can always be removed and you're
> > not going to stop that no matter how many reference counts you
> > hold :)
> 
> No way! It is defined as static ;)

It's exported as a PCI device, no? PCI devices can be removed
at any time through sysfs.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
