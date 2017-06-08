From: David Miller <davem@davemloft.net>
Subject: Re: Crypto Fixes for 4.12
Date: Thu, 08 Jun 2017 10:05:02 -0400 (EDT)
Message-ID: <20170608.100502.1861332545609152555.davem@davemloft.net>
References: <20170304074119.GA3041@gondor.apana.org.au>
        <20170523034211.GA12748@gondor.apana.org.au>
        <20170608092320.GA6478@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170608092320.GA6478@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 8 Jun 2017 17:23:21 +0800

> This push fixes a couple of places in the crypto code that were
> doing interruptible sleeps dangerously.  They have been converted
> to use non-interruptible sleeps.  This push also fixes a bug in
> asymmetric_keys where it would trigger a use-after-free if a
> request returned EBUSY due to a full device queue.

Where is the gcc shash miscompile workaround?

Thanks.
