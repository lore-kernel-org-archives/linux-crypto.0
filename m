From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/6] crypto: SHA1 multibuffer implementation
Date: Fri, 30 May 2014 17:26:57 +0800
Message-ID: <20140530092657.GB12760@gondor.apana.org.au>
References: <cover.1400856726.git.tim.c.chen@linux.intel.com>
 <1400886132.2970.356.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:42858 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbaE3J11 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 May 2014 05:27:27 -0400
Content-Disposition: inline
In-Reply-To: <1400886132.2970.356.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 23, 2014 at 04:02:12PM -0700, Tim Chen wrote:
>
> The outline of the algorithm is sketched below:
> Any driver requesting the crypto service will place an async
> crypto request on the workqueue.  The multi-buffer crypto daemon will
> pull request from work queue and put each request in an empty data lane
> for multi-buffer crypto computation.  When all the empty lanes are filled,
> computation will commence on the jobs in parallel and the job with the
> shortest remaining buffer will get completed and be returned.  To prevent
> prolonged stall when there is no new jobs arriving, we will flush a crypto
> job if it has not been completed after a maximum allowable delay.

I'm a bit uncomfortable with the idea of only having a delay here.
How about in addition to the delay we also flush the queue as
soon as the CPU is idle?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
