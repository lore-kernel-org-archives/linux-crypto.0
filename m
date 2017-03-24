From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 6/7] md/raid10, LLVM: get rid of variable length array
Date: Fri, 24 Mar 2017 15:09:36 +0100
Message-ID: <20170324140936.45gjbfdjyyag5cce@hirez.programming.kicks-ass.net>
References: <20170317001520.85223-1-md@google.com>
 <20170317001520.85223-7-md@google.com>
 <20170317120837.pr74cv3xuj7qpoin@hirez.programming.kicks-ass.net>
 <CAG_fn=XcQLtcHRSm2BHYce9LMtyFJ+fWxfE4vYPCw+7U0DcrmQ@mail.gmail.com>
 <20170317124404.mt3jd5q5vyk63q2w@hirez.programming.kicks-ass.net>
 <CA+=D-XXy9yEQc-jLxSqRUwq=4ADnFqaxnsjSzV4=8jOisym=bQ@mail.gmail.com>
 <20170317192746.y5ade3bymifdni2p@hirez.programming.kicks-ass.net>
 <96158847-4F1F-4293-8435-E111F39E3260@zytor.com>
 <CACT4Y+awYCAwoCkh8PQ-i2BdkxeuFp9meVXp=Yv6hGY8YjDnQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>, Michael Davidson <md@google.com>,
        Alexander Potapenko <glider@google.com>,
        Michal Marek <mmarek@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Shaohua Li <shli@kernel.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "open list:KERNEL BUILD + fi..." <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55892 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965014AbdCXOKA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2017 10:10:00 -0400
Content-Disposition: inline
In-Reply-To: <CACT4Y+awYCAwoCkh8PQ-i2BdkxeuFp9meVXp=Yv6hGY8YjDnQg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 24, 2017 at 02:47:15PM +0100, Dmitry Vyukov wrote:
> > Seriously, you should have taken the hack the first time that this
> > needs to be fixed.  Just because this is a fairly uncommon construct
> > in the kernel doesn't mean it is not in userspace.
> 
> There is a reason why it is fairly uncommon in kernel.

So first off; its not entirely clear that the code as it exists it
correct. From a cursory reading of it and surrounding code, there is no
actual upper limit on the variable. If I were stupid enough to make a
raid with 64 devices I'd get a huge on-stack structure.

Since you're touching it; you should check these things.

And secondly, refactor the code to not look like dog vomit. You can do
more than the absolute minimal patch to make it compile, I'm sure.
