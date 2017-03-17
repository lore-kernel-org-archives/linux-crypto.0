From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 6/7] md/raid10, LLVM: get rid of variable length array
Date: Fri, 17 Mar 2017 20:26:42 +0100
Message-ID: <20170317192642.qnrf7xuopxzapl2r@hirez.programming.kicks-ass.net>
References: <20170317001520.85223-1-md@google.com>
 <20170317001520.85223-7-md@google.com>
 <20170317120837.pr74cv3xuj7qpoin@hirez.programming.kicks-ass.net>
 <CAG_fn=XcQLtcHRSm2BHYce9LMtyFJ+fWxfE4vYPCw+7U0DcrmQ@mail.gmail.com>
 <CAG_fn=WooTLkzex3hqPgO5pr7GsK3v7Z5riSA7K+-_S=S7rmBQ@mail.gmail.com>
 <20170317180350.63jjysejk2i6vkon@pd.tnic>
 <CACT4Y+Ysvjz+UzEi0dTtsNxxnG7WXTiZPr+KSk8HHwSu7vX1ew@mail.gmail.com>
 <20170317185720.5s7qa6hl233t24ag@pd.tnic>
 <CACT4Y+bybdpqB71=inx8amwr188Mb2QyBeRTDdWZ3AFyDwVX0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Borislav Petkov <bp@alien8.de>,
        Alexander Potapenko <glider@google.com>,
        Michael Davidson <md@google.com>,
        Michal Marek <mmarek@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Shaohua Li <shli@kernel.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "open list:KERNEL BUILD + fi..." <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org,
        kbuild-all@01.org, Fengguang Wu <fengguang.wu@intel.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+bybdpqB71=inx8amwr188Mb2QyBeRTDdWZ3AFyDwVX0A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 17, 2017 at 08:05:16PM +0100, Dmitry Vyukov wrote:
> You can also find some reasons in the Why section of LLVM-Linux project:
> http://llvm.linuxfoundation.org/index.php/Main_Page

>From that:

 - LLVM/Clang is a fast moving project with many things fixed quickly
   and features added.

So what's the deal with that 5 year old bug you want us to work around?

Also, clang doesn't support asm cc flags output and a few other
extensions last time I checked.

