From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 03/20] padata: Make padata_alloc() static
Date: Mon, 17 Apr 2017 11:14:23 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1704171113040.2327@nanos>
References: <20170415170107.643253702@linutronix.de> <20170415171651.483363066@linutronix.de> <CAHmME9q=Jvnw51jUw+iVkeN8vY=uDJu-N1jJ9oAcH7PEjnSY0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:47144 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752543AbdDQJOk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Apr 2017 05:14:40 -0400
In-Reply-To: <CAHmME9q=Jvnw51jUw+iVkeN8vY=uDJu-N1jJ9oAcH7PEjnSY0g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 16 Apr 2017, Jason A. Donenfeld wrote:

> I rather like this option of padata, which, since it lives in
> kernel/padata.c and linux/padata.h, should be generic and useful for
> other components. Seems like the ability to allocate it for a
> particular set of worker CPUs and callback CPUs could be useful down
> the line. Would rather not see it become static.

It's simple enough to export it once there is an actual user. Just keeping
stuff global because it might be useful somewhere down the road is really
pointless.

Thanks,

	tglx
