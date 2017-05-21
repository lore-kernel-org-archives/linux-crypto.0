From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: DEADLOCK: bisected to d215aab82d81974f438bfbc80aa437132f3c37c3
 ("cpu/hotplug: Convert hotplug locking to percpu rwsem")
Date: Sun, 21 May 2017 18:09:10 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1705211807030.3023@nanos>
References: <20170521154416.GA25687@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: steffen.klassert@secunet.com, peterz@infradead.org,
        bigeasy@linutronix.de, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:34427 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756623AbdEUQJX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 May 2017 12:09:23 -0400
In-Reply-To: <20170521154416.GA25687@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 21 May 2017, Corentin Labbe wrote:
> Since linux-next-20170517 at least I got the following DEADLOCK warning:
> [    4.311614] ============================================
> [    4.316919] WARNING: possible recursive locking detected
> [    4.322227] 4.12.0-rc1-next-20170517+ #273 Not tainted
> [    4.327360] --------------------------------------------
> [    4.332665] swapper/0/1 is trying to acquire lock:
> [    4.337451]  (cpu_hotplug_lock.rw_sem){++++++}, at: [<c01cc998>] stop_machine+0x1c/0x3c

The offending commit has been removed from -next. We are working on a replacement.

Thanks,

	tglx
