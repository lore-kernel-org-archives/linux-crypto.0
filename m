From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 6/7] md/raid10, LLVM: get rid of variable length array
Date: Fri, 17 Mar 2017 13:44:04 +0100
Message-ID: <20170317124404.mt3jd5q5vyk63q2w@hirez.programming.kicks-ass.net>
References: <20170317001520.85223-1-md@google.com>
 <20170317001520.85223-7-md@google.com>
 <20170317120837.pr74cv3xuj7qpoin@hirez.programming.kicks-ass.net>
 <CAG_fn=XcQLtcHRSm2BHYce9LMtyFJ+fWxfE4vYPCw+7U0DcrmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michael Davidson <md@google.com>, Michal Marek <mmarek@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Shaohua Li <shli@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Matthias Kaehlcke <mka@chromium.org>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: Alexander Potapenko <glider@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG_fn=XcQLtcHRSm2BHYce9LMtyFJ+fWxfE4vYPCw+7U0DcrmQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 17, 2017 at 01:31:23PM +0100, Alexander Potapenko wrote:
> On Fri, Mar 17, 2017 at 1:08 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, Mar 16, 2017 at 05:15:19PM -0700, Michael Davidson wrote:
> >> Replace a variable length array in a struct by allocating
> >> the memory for the entire struct in a char array on the stack.
> >>
> >> Signed-off-by: Michael Davidson <md@google.com>
> >> ---
> >>  drivers/md/raid10.c | 9 ++++-----
> >>  1 file changed, 4 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> >> index 063c43d83b72..158ebdff782c 100644
> >> --- a/drivers/md/raid10.c
> >> +++ b/drivers/md/raid10.c
> >> @@ -4654,11 +4654,10 @@ static int handle_reshape_read_error(struct mddev *mddev,
> >>       /* Use sync reads to get the blocks from somewhere else */
> >>       int sectors = r10_bio->sectors;
> >>       struct r10conf *conf = mddev->private;
> >> -     struct {
> >> -             struct r10bio r10_bio;
> >> -             struct r10dev devs[conf->copies];
> >> -     } on_stack;
> >> -     struct r10bio *r10b = &on_stack.r10_bio;
> >> +     char on_stack_r10_bio[sizeof(struct r10bio) +
> >> +                           conf->copies * sizeof(struct r10dev)]
> >> +                           __aligned(__alignof__(struct r10bio));
> >> +     struct r10bio *r10b = (struct r10bio *)on_stack_r10_bio;
> >>       int slot = 0;
> >>       int idx = 0;
> >>       struct bio_vec *bvec = r10_bio->master_bio->bi_io_vec;
> >
> >
> > That's disgusting. Why not fix LLVM to support this?
> 
> IIUC there's only a handful of VLAIS instances in LLVM code, why not
> just drop them for the sake of better code portability?
> (To quote Linus, "this feature is an abomination":
> https://lkml.org/lkml/2013/9/23/500)

Be that as it may; what you construct above is disgusting. Surely the
code can be refactored to not look like dog vomit?

Also; its not immediately obvious conf->copies is 'small' and this
doesn't blow up the stack; I feel that deserves a comment somewhere.
