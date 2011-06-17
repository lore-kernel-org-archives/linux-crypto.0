From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/5] tsc: wire up entropy generation function
Date: Fri, 17 Jun 2011 22:58:42 +0200 (CEST)
Message-ID: <alpine.LFD.2.02.1106172256550.11814@ionos>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com> <1308002818-27802-5-git-send-email-jarod@redhat.com> <BANLkTin=BkfyPjaWRc1rfTWU34NLdn7FLgY6yUbSrjzPpx7Gmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
	John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>
To: Venkatesh Pallipadi <venki@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:60134 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab1FQU6t (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jun 2011 16:58:49 -0400
In-Reply-To: <BANLkTin=BkfyPjaWRc1rfTWU34NLdn7FLgY6yUbSrjzPpx7Gmg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On Mon, 13 Jun 2011, Venkatesh Pallipadi wrote:

> On Mon, Jun 13, 2011 at 3:06 PM, Jarod Wilson <jarod@redhat.com> wrote:
> > TSC is high enough resolution that we can use its low-order byte to
> > stir new data into the random number generator entropy pool.
> 
> >From what I vaguely remember from years past, rdtsc, especially last
> few bits of it are not very good as random number source. As they are
> based on lower bus frequency and a multiplier. May be things have
> changed these days. Adding Peter and Suresh for comments.

Recommended reading:

  https://www.osadl.org/fileadmin/dam/rtlws/12/Okech.pdf

Thanks,

	tglx
