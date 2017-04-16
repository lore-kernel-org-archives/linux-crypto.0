From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [patch 03/20] padata: Make padata_alloc() static
Date: Sun, 16 Apr 2017 08:22:21 +0200
Message-ID: <CAHmME9q=Jvnw51jUw+iVkeN8vY=uDJu-N1jJ9oAcH7PEjnSY0g@mail.gmail.com>
References: <20170415170107.643253702@linutronix.de> <20170415171651.483363066@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:39191 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752310AbdDPGW0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Apr 2017 02:22:26 -0400
In-Reply-To: <20170415171651.483363066@linutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I rather like this option of padata, which, since it lives in
kernel/padata.c and linux/padata.h, should be generic and useful for
other components. Seems like the ability to allocate it for a
particular set of worker CPUs and callback CPUs could be useful down
the line. Would rather not see it become static.

Jason
