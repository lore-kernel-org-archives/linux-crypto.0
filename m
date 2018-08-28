From: Megha Dey <megha.dey@linux.intel.com>
Subject: Re: KASAN: use-after-free Read in sha512_ctx_mgr_resubmit
Date: Tue, 28 Aug 2018 15:17:16 -0700
Message-ID: <1535494636.15041.15.camel@megha-Z97X-UD7-TH>
References: <00000000000072d64d05737b6b8c@google.com>
         <20180820073119.GA14931@sol.localdomain>
         <CAKv+Gu9Y0TLOuMba43HPihYqy-kk0nttBfPj1_UukiYy1cBcFw@mail.gmail.com>
         <20180822062036.mdq4q5o5zdzuxh7s@gondor.apana.org.au>
         <1535411336.3516.2.camel@megha-Z97X-UD7-TH>
         <CAKv+Gu_oZ0Z37WV1h4opi-cYZT5FWU_bmrkBjx8LXpvKpPoZNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot <syzbot+d5455bac3ba1ee9114e5@syzkaller.appspotmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        the arch/x86 maintainers <x86@kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu_oZ0Z37WV1h4opi-cYZT5FWU_bmrkBjx8LXpvKpPoZNA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 2018-08-28 at 01:01 +0200, Ard Biesheuvel wrote:
> On 28 August 2018 at 01:08, Megha Dey <megha.dey@linux.intel.com> wrote:
> > On Wed, 2018-08-22 at 14:20 +0800, Herbert Xu wrote:
> >> On Tue, Aug 21, 2018 at 02:43:56PM +0200, Ard Biesheuvel wrote:
> >> >
> >> > I agree. The code is obviously broken in a way that would have been
> >> > noticed if it were in wide use, and it is too complicated for mere
> >> > mortals to fix or maintain. I suggest we simply remove it for now, and
> >> > if anyone wants to reintroduce it, we can review the code *and* the
> >> > justification for the approach from scratch (in which case we should
> >> > consider factoring out the algo agnostics plumbing in a way that
> >> > allows it to be reused by other architectures as well)
> >>
> >> I agree too.  Could one of you guys send me a patch to remove
> >> them?
> >>
> >
> > Hi,
> >
> > We are working on a fix to solve these corner cases.
> >
> 
> Great. thanks.
> 
> But it would also be helpful if you could try and answer the questions
> raised by Eric:
> - in which cases does this driver result in a speedup?

The multibuffer algorithm approach results in a speedup only when there
are a large number of independent jobs. Similarly if there is a steady
stream of independent jobs, multibuffer works well. So another way of
looking at this is that if there are a lot of flushes, then one
shouldn't be using multibuffer algorithms.
 
> - how should we tune the flush delay to prevent pathological
> performance regressions?

We have not optimized the flush delay on the ground that it should not
be occurring often. If this seems to be happening a lot, then perhaps we
could optimize it along the lines that if more than N "lanes" are full,
we will continue to use the present flush algorithm, else we could
switch to an optimized single buffer code for one of the lanes. Any
other suggestions are welcome too.
 
> - is it still safe in the post-Spectre era of computing to aggregate
> hash input from different sources (which may be different users
> altogether) and process them as a single source of input?

hmmm, I am not sure how one could do side-channel attack, could you
maybe give an example? One could do a denial of service attack, by
flooding it with too many requests.

Also Eric had raised the issue whether we need AVX2 multibuffer now that
we have SHA instructions. However, for cases where jobs come in fast
enough, sha1-mb is seen to perform better than sha-ni algorithm.

Since, we already have lowered the priority of the multibuffer
algorithms, users who know that they would have a consistent inflow of
jobs should only opt for the multibuffer algorithm.

>From Herbert's suggestion, I am also working on removing the mcryptd
layer for the multibuffer algorithms, and follow the simd model to
simplify the multibuffer model.

Hence, instead of removing these algorithms, I would like to suggest the
following:
1. Find a fix for the corner cases of memory corruption
2. Remove mcryptd layer, add simd interface for hash 
3. try to reuse code for hash multibuffer algorithms instead of
duplicating the same code 3 times.

Thanks,
Megha 
