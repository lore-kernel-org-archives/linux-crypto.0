From: "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: RE: [PATCH 2/7] crypto: sha256-mb - SHA256 multibuffer job manager
 and glue code
Date: Fri, 8 Apr 2016 18:37:05 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712205DFA3CFB@ORSMSX106.amr.corp.intel.com>
References: <1458851163-3448-1-git-send-email-megha.dey@linux.intel.com>
 <1458851163-3448-3-git-send-email-megha.dey@linux.intel.com>
 <20160405120357.GA12510@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>,
	"Dey, Megha" <megha.dey@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"megha.dey@linux.intel.com" <megha.dey@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23512 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758534AbcDHShK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Apr 2016 14:37:10 -0400
In-Reply-To: <20160405120357.GA12510@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Tuesday, April 05, 2016 5:04 AM
> To: megha.dey@linux.intel.com
> Cc: davem@davemloft.net; linux-crypto@vger.kernel.org; linux-
> kernel@vger.kernel.org; tim.c.chen@linux.intel.com; Yu, Fenghua
> <fenghua.yu@intel.com>; Dey, Megha <megha.dey@intel.com>
> Subject: Re: [PATCH 2/7] crypto: sha256-mb - SHA256 multibuffer job
> manager and glue code
> 
> On Thu, Mar 24, 2016 at 01:25:58PM -0700, megha.dey@linux.intel.com
> wrote:
> > From: Megha Dey <megha.dey@intel.com>
> >
> > This patch introduces the multi-buffer job manager which is
> > responsible for submitting scatter-gather buffers from several SHA256
> > jobs to the multi-buffer algorithm. It also contains the flush routine
> > to that's called by the crypto daemon to complete the job when no new
> > jobs arrive before the deadline of maximum latency of a SHA256 crypto job.
> >
> > The SHA256 multi-buffer crypto algorithm is defined and initialized in
> > this patch.
> >
> > Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
> > Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
> > Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
> 
> sha1-mb still has the same issues that I complained about for the aes-mb
> submission.  In particular, I don't like the use of shash to handle what is really
> an async implmentation.
> 
> So I'd like to see this fixed first before we add any more copies of this code.

We will update the patches and re-send out sha1/256/512 AVX2 mb algos using async implementation.

Thanks.

-Fenghua
