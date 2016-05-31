From: Megha Dey <megha.dey@intel.com>
Subject: Re: [PATCH 1/7] crypto : stylistic cleanup in sha1-mb
Date: Tue, 31 May 2016 13:01:56 -0700
Message-ID: <1464724916.9394.2.camel@megha-Z97X-UD7-TH>
References: <1463704984-2136-1-git-send-email-megha.dey@intel.com>
	 <20160531081311.GA14591@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	fenghua.yu@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:1543 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbcEaT4c (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 15:56:32 -0400
In-Reply-To: <20160531081311.GA14591@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2016-05-31 at 16:13 +0800, Herbert Xu wrote:
> On Thu, May 19, 2016 at 05:43:04PM -0700, Megha Dey wrote:
> > From: Megha Dey <megha.dey@linux.intel.com>
> > 
> > Currently there are several checkpatch warnings in the sha1_mb.c file:
> > 'WARNING: line over 80 characters' in the sha1_mb.c file. Also, the
> > syntax of some multi-line comments are not correct. This patch fixes
> > these issues.
> > 
> > Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
> 
> This patch says 1/7 but there is no cover letter and I've only
> seen patches 1 and 2.  What's going on?

Herbert , I had 7 patches for the async+avx2 sha256-mb implementation. I
had sent just the async related changes here. However, I will resend the
patches as 2 sets. One which has only async implementation changes and
the other which has only sha256-mb avx2 implementation changes. Please
disregard the current patches and review the ones I will be sending
again.

> 
> Cheers,
