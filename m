From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH v2] Add VMAC(AES) to Linux for intel_txt support
Date: Fri, 14 Aug 2009 13:22:01 +1000
Message-ID: <20090814032201.GA2544@gondor.apana.org.au>
References: <4A5F41C4.3050808@intel.com> <4A5F431B.6060307@intel.com> <4A805375.4030902@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Cihula, Joseph" <joseph.cihula@intel.com>
To: Shane Wang <shane.wang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44370 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754361AbZHNDWC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2009 23:22:02 -0400
Content-Disposition: inline
In-Reply-To: <4A805375.4030902@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 11, 2009 at 01:05:57AM +0800, Shane Wang wrote:
>
> For the comment
> > This is unnecessary.  Please use the standard kernel helpers
> > from asm/byteorder.h (which you get by including linux/kernel.h).
> The current code distinguishes some macro implementations according to 
> different platforms to improve the MACing speed, which is one of the 
> reasons VMAC is very fast for MACing. Do we need to give these up?

I'm talking about your macros such as get64BE/get64LE.  We have
identical standard kernel helpers be64_to_cpu/le64_to_cpu which
should already be optimal.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
