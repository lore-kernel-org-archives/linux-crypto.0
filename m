From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/7] crypto: sha256-mb - SHA256 multibuffer job manager
 and glue code
Date: Tue, 5 Apr 2016 20:03:57 +0800
Message-ID: <20160405120357.GA12510@gondor.apana.org.au>
References: <1458851163-3448-1-git-send-email-megha.dey@linux.intel.com>
 <1458851163-3448-3-git-send-email-megha.dey@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, tim.c.chen@linux.intel.com,
	fenghua.yu@intel.com, Megha Dey <megha.dey@intel.com>
To: megha.dey@linux.intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46923 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147AbcDEMEF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Apr 2016 08:04:05 -0400
Content-Disposition: inline
In-Reply-To: <1458851163-3448-3-git-send-email-megha.dey@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 24, 2016 at 01:25:58PM -0700, megha.dey@linux.intel.com wrote:
> From: Megha Dey <megha.dey@intel.com>
> 
> This patch introduces the multi-buffer job manager which is responsible for
> submitting scatter-gather buffers from several SHA256 jobs to the
> multi-buffer algorithm. It also contains the flush routine to that's
> called by the crypto daemon to complete the job when no new jobs arrive
> before the deadline of maximum latency of a SHA256 crypto job.
> 
> The SHA256 multi-buffer crypto algorithm is defined and initialized in
> this patch.
> 
> Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
> Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>

sha1-mb still has the same issues that I complained about for the
aes-mb submission.  In particular, I don't like the use of shash
to handle what is really an async implmentation.

So I'd like to see this fixed first before we add any more copies
of this code.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
