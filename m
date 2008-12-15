From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH crypto] AES: Add support to Intel AES-NI instructions
Date: Mon, 15 Dec 2008 14:38:42 +1100
Message-ID: <20081215033842.GA28499@gondor.apana.org.au>
References: <1229054926.5936.160.camel@yhuang-dev.sh.intel.com> <20081212195722.GA24489@Chamillionaire.breakpoint.cc> <1229307542.5936.204.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"mingo@elte.hu" <mingo@elte.hu>,
	"tglx@linutronix.de" <tglx@linutronix.de>
To: Huang Ying <ying.huang@intel.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57282 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751802AbYLODjP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 14 Dec 2008 22:39:15 -0500
Content-Disposition: inline
In-Reply-To: <1229307542.5936.204.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 15, 2008 at 10:19:02AM +0800, Huang Ying wrote:
> 
> The general x86 implementation is used as the fall back for new AES-NI
> based implementation. Because AES-NI can not be used in kernel soft_irq
> context. If crypto layer is used to access general x86 implementation,

Why is that? The VIA PadLock also "touches" the SSE state but we still
use it on softirq paths.

In fact Suresh told me earlier that your AES instruction wasn't
going to have the SSE problems that VIA had, is this not the case?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
