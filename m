From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1] hw_random: Fix timeriomem_rng for sub-jiffie update
 periods
Date: Wed, 5 Apr 2017 20:57:17 +0800
Message-ID: <20170405125717.GB26558@gondor.apana.org.au>
References: <20170404214307.7748-1-raltherr@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: alex@digriz.org.uk, openbmc@lists.ozlabs.org,
        Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Rick Altherr <raltherr@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37434 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753780AbdDENqa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2017 09:46:30 -0400
Content-Disposition: inline
In-Reply-To: <20170404214307.7748-1-raltherr@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 04, 2017 at 02:43:07PM -0700, Rick Altherr wrote:
> Some hardware RNGs provide a single register for obtaining random data.
> Instead of signaling when new data is available, the reader must wait a
> fixed amount of time between reads for new data to be generated.
> timeriomem_rng implements this scheme with the period specified in
> platform data or device tree.  While the period is specified in
> microseconds, the implementation used a standard timer which has a
> minimum delay of 1 jiffie and caused a significant bottleneck for
> devices that can update at 1us.  By switching to an hrtimer, 1us periods
> now only delay at most 2us per read.
> 
> Migrated to new hw_random API while I in this driver.
> 
> Signed-off-by: Rick Altherr <raltherr@google.com>

Thanks Rick.  Could you split this into two patches? One doing
the API conversion and the other one doing the substantive change
to the entropy gathering?

That way if there is a problem it'll be easier to track down.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
