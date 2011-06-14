From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 4/5] tsc: wire up entropy generation function
Date: Mon, 13 Jun 2011 18:47:32 -0700
Message-ID: <4DF6BDB4.2060201@zytor.com>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>	<1308002818-27802-5-git-send-email-jarod@redhat.com> <BANLkTin=BkfyPjaWRc1rfTWU34NLdn7FLgY6yUbSrjzPpx7Gmg@mail.gmail.com> <4DF690E4.1060004@zytor.com> <4DF6ADD0.6080607@borg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Venkatesh Pallipadi <venki@google.com>,
	Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	Matt Mackall <mpm@selenic.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Suresh Siddha <suresh.b.siddha@intel.com>
To: Kent Borg <kentborg@borg.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:60613 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245Ab1FNBsE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2011 21:48:04 -0400
In-Reply-To: <4DF6ADD0.6080607@borg.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/13/2011 05:39 PM, Kent Borg wrote:
> I was assuming that drivers, responding to an interrupt from some
> external event, would want to make this call.
> Such as a network driver.

Those already are doing this.

> Two points:
> 
> 1. Why look at the high-order bits?  How are they going to have values
> that cannot be inferred?  If you are looking for entropy, the low-order
> bits is where they're going keep it.  (Think Willie Sutton.)  If looking
> at the low-byte is cheaper, then let's be cheap.  If, however, if
> looking at more bytes *is* as cheap, then there is no harm.  But in any
> case let's keep the code lean enough that it can be called from an
> interrupt service routine.

Consider the case where the TSC is running in steps of 64 and you're
using the low 6 bits.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
