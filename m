From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/3] hw_random: timeriomem_rng: Migrate to new API and
 improve performance
Date: Mon, 10 Apr 2017 19:22:48 +0800
Message-ID: <20170410112248.GB8800@gondor.apana.org.au>
References: <20170405232100.2023-1-raltherr@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: alex@digriz.org.uk, openbmc@lists.ozlabs.org,
        Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Rick Altherr <raltherr@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170405232100.2023-1-raltherr@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Apr 05, 2017 at 04:20:57PM -0700, Rick Altherr wrote:
> AST2400 can generate 32-bits of random data every 1us.  Original driver
> was limited to one 32-bit read every jiffie due to deprecated API and use
> of timers.  Migrating to new hwrng API and switching to hrtimers
> improves read performance of /dev/hwrng to 13Mb/s.
> 
> Changes in v2:
> - Split API migration into separate patch
> - Split type and variable renames into separate patch
> - Split performance improvements into separate patch

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
