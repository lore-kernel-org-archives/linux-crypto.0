From: hpa@zytor.com
Subject: Re: [PATCH 6/7] md/raid10, LLVM: get rid of variable length array
Date: Fri, 17 Mar 2017 13:04:27 -0700
Message-ID: <96158847-4F1F-4293-8435-E111F39E3260@zytor.com>
References: <20170317001520.85223-1-md@google.com> <20170317001520.85223-7-md@google.com> <20170317120837.pr74cv3xuj7qpoin@hirez.programming.kicks-ass.net> <CAG_fn=XcQLtcHRSm2BHYce9LMtyFJ+fWxfE4vYPCw+7U0DcrmQ@mail.gmail.com> <20170317124404.mt3jd5q5vyk63q2w@hirez.programming.kicks-ass.net> <CA+=D-XXy9yEQc-jLxSqRUwq=4ADnFqaxnsjSzV4=8jOisym=bQ@mail.gmail.com> <20170317192746.y5ade3bymifdni2p@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Alexander Potapenko <glider@google.com>,
        Michal Marek <mmarek@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Shaohua Li <shli@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Matthias Kaehlcke <mka@chromium.org>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>,
        Michael Davidson <md@google.com>
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <20170317192746.y5ade3bymifdni2p@hirez.programming.kicks-ass.net>
Sender: linux-kbuild-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On March 17, 2017 12:27:46 PM PDT, Peter Zijlstra <peterz@infradead.org> wrote:
>On Fri, Mar 17, 2017 at 11:52:01AM -0700, Michael Davidson wrote:
>> On Fri, Mar 17, 2017 at 5:44 AM, Peter Zijlstra
><peterz@infradead.org> wrote:
>> >
>> > Be that as it may; what you construct above is disgusting. Surely
>the
>> > code can be refactored to not look like dog vomit?
>> >
>> > Also; its not immediately obvious conf->copies is 'small' and this
>> > doesn't blow up the stack; I feel that deserves a comment
>somewhere.
>> >
>> 
>> I agree that the code is horrible.
>> 
>> It is, in fact, exactly the same solution that was used to remove
>> variable length arrays in structs from several of the crypto drivers
>a
>> few years ago - see the definition of SHASH_DESC_ON_STACK() in
>> "crypto/hash.h" - I did not, however, hide the horrors in a macro
>> preferring to leave the implementation visible as a warning to
>whoever
>> might touch the code next.
>> 
>> I believe that the actual stack usage is exactly the same as it was
>previously.
>> 
>> I can certainly wrap this  up in a macro and add comments with
>> appropriately dire warnings in it if you feel that is both necessary
>> and sufficient.
>
>We got away with ugly in the past, so we should get to do it again?

Seriously, you should have taken the hack the first time that this needs to be fixed.  Just because this is a fairly uncommon construct in the kernel doesn't mean it is not in userspace.

I would like to say this falls in the category of "fix your compiler this time".  Once is one thing, twice is unacceptable.
-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
