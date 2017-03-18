From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 6/7] md/raid10, LLVM: get rid of variable length array
Date: Sat, 18 Mar 2017 08:41:48 +0800
Message-ID: <20170318004148.u332zl63sbdqhiwb@wfg-t540p.sh.intel.com>
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
Content-Type: text/plain; charset=us-ascii; format=flowed
Cc: Borislav Petkov <bp@alien8.de>,
        Alexander Potapenko <glider@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
        kbuild-all@01.org
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+bybdpqB71=inx8amwr188Mb2QyBeRTDdWZ3AFyDwVX0A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Dmitry,
 
On Fri, Mar 17, 2017 at 08:05:16PM +0100, Dmitry Vyukov wrote:
>On Fri, Mar 17, 2017 at 7:57 PM, Borislav Petkov <bp@alien8.de> wrote:
>> On Fri, Mar 17, 2017 at 07:47:33PM +0100, Dmitry Vyukov wrote:
>>> This problem is more general and is not specific to clang. It equally
>>> applies to different versions of gcc, different arches and different
>>> configs (namely, anything else than what a developer used for
>>> testing).
>>
>> I guess. We do carry a bunch of gcc workarounds along with the cc-*
>> macros in scripts/Kbuild.include.
>>
>>> A known, reasonably well working solution to this problem is
>>> a system of try bots that test patches before commit with different
>>> compilers/configs/archs. We already have such system in the form of
>>> 0-day bots. It would be useful to extend it with clang as soon as
>>> kernel builds.
>>
>> Has someone actually already talked to Fengguang about it?
>
>+Fengguang

I've actually tried clang long time ago. It quickly fails the build
for vanilla kernel. So it really depends on when the various clang
build fix patches can be accepted into mainline kernel.

Thanks,
Fengguang
