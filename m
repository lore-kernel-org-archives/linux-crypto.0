From: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC 7/7] crypto: Add PCLMULQDQ accelerated GHASH
	implementation
Date: Tue, 07 Jul 2009 13:18:03 +0800
Message-ID: <1246943883.5282.100.camel@yhuang-dev.sh.intel.com>
References: <20090621135121.GA3153@gondor.apana.org.au>
	 <1246937512.5282.99.camel@yhuang-dev.sh.intel.com>
	 <20090707034548.GA28075@gondor.apana.org.au>
	 <20090707040232.GA28257@gondor.apana.org.au>
	 <20090707040341.GA28303@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1044 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbZGGFSB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2009 01:18:01 -0400
In-Reply-To: <20090707040341.GA28303@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2009-07-07 at 12:03 +0800, Herbert Xu wrote:
> On Tue, Jul 07, 2009 at 12:02:32PM +0800, Herbert Xu wrote:
> >
> > Actually I'll do the remaining DIGEST algorithms right now because
> > without them hmac can't be converted.
> 
> Nevermind, there aren't any remaining DIGEST algorithms :)
> 
> I'll get onto hmac.

Thank you. Will post the updated version after you have done with hmac.

Best Regards,
Huang Ying

