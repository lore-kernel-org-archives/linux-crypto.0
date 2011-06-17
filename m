From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/5] misc: add clocksource-based entropy generation
 driver
Date: Fri, 17 Jun 2011 23:01:54 +0200 (CEST)
Message-ID: <alpine.LFD.2.02.1106172259460.11814@ionos>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com> <1308002818-27802-6-git-send-email-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	"Venkatesh Pallipadi (Venki)" <venki@google.com>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:37335 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932677Ab1FQVB5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jun 2011 17:01:57 -0400
In-Reply-To: <1308002818-27802-6-git-send-email-jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 13 Jun 2011, Jarod Wilson wrote:
> This is a fairly simple driver that just starts up a kernel thread that
> periodically calls the active clocksource's entropy-gathering function,
> if it has one. The default interval of 100us between polls doesn't show
> any measurable impact to cpu usage on a core 2 duo test rig here, and

Of course it does not show up.

> +		schedule_timeout(timeout);

That will line you up with the tick nicely. So in fact you run that
code with HZ frequency.

Thanks,

	tglx
