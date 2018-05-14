From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: WARNING: kernel stack regs has bad 'bp' value (3)
Date: Mon, 14 May 2018 08:47:15 -0500
Message-ID: <20180514134715.vz656l5qp3z7zwsy@treble>
References: <001a11449aa2faf11805643af581@google.com>
 <CACT4Y+YOmbZGdBbFpmjRJXABGe1tD=F+3na77DwoPCEaROADyw@mail.gmail.com>
 <20180202221829.tdiji2332t7orcxj@gmail.com>
 <CACT4Y+afpDQ7A3caRmskML06h8Q6+NkVAn6HtV93ExPec-g2pA@mail.gmail.com>
 <CAKv+Gu_Lh1TroS4BJJp4PQNYbqZ8KR=6Z5hHX2+UiBfxC=sxQA@mail.gmail.com>
 <CACT4Y+awLWP3o0opx5CbAYpD4HpwVpQhPA-dDHmxAzJMs8_orQ@mail.gmail.com>
 <CAKv+Gu_Kigt9ouktBjFacFHbburot2i=-_m88-o4-XhtmhozVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Dmitry Vyukov <dvyukov@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers3@gmail.com>,
        syzbot <syzbot+ffa3a158337bbc01ff09@syzkaller.appspotmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_Kigt9ouktBjFacFHbburot2i=-_m88-o4-XhtmhozVA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, May 12, 2018 at 12:11:17PM +0200, Ard Biesheuvel wrote:
> On 12 May 2018 at 11:50, Dmitry Vyukov <dvyukov@google.com> wrote:
> > On Sat, May 12, 2018 at 11:09 AM, Ard Biesheuvel
> > <ard.biesheuvel@linaro.org> wrote:
> >> (+ Arnd)
> >>
> >> On 12 May 2018 at 10:43, Dmitry Vyukov <dvyukov@google.com> wrote:
> >>> On Fri, Feb 2, 2018 at 11:18 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> >>>> On Fri, Feb 02, 2018 at 02:57:32PM +0100, Dmitry Vyukov wrote:
> >>>>> On Fri, Feb 2, 2018 at 2:48 PM, syzbot
> >>>>> <syzbot+ffa3a158337bbc01ff09@syzkaller.appspotmail.com> wrote:
> >>>>> > Hello,
> >>>>> >
> >>>>> > syzbot hit the following crash on upstream commit
> >>>>> > 7109a04eae81c41ed529da9f3c48c3655ccea741 (Thu Feb 1 17:37:30 2018 +0000)
> >>>>> > Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide
> >>>>> >
> >>>>> > So far this crash happened 4 times on net-next, upstream.
> >>>>> > C reproducer is attached.
> >>>>> > syzkaller reproducer is attached.
> >>>>> > Raw console output is attached.
> >>>>> > compiler: gcc (GCC) 7.1.1 20170620
> >>>>> > .config is attached.
> >>>>>
> >>>>>
> >>>>> From suspicious frames I see salsa20_asm_crypt there, so +crypto maintainers.
> >>>>>
> >>>>
> >>>> Looks like the x86 implementations of Salsa20 (both i586 and x86_64) need to be
> >>>> updated to not use %ebp/%rbp.
> >>>
> >>> Ard,
> >>>
> >>> This was bisected as introduced by:
> >>>
> >>> commit 83dee2ce1ae791c3dc0c9d4d3a8d42cb109613f6
> >>> Author: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >>> Date:   Fri Jan 19 12:04:34 2018 +0000
> >>>
> >>>     crypto: sha3-generic - rewrite KECCAK transform to help the
> >>> compiler optimize
> >>>
> >>> https://gist.githubusercontent.com/dvyukov/47f93f5a0679170dddf93bc019b42f6d/raw/65beac8ddd30003bbd4e9729236dc8572094abf7/gistfile1.txt
> >>
> >> Ouch.
> >>
> >> I'm not an expert in x86 assembly. Could someone please check the
> >> generated code to see what's going on? The C code changes are not that
> >> intricate, they basically unroll a loop, replacing accesses to
> >> 'array[indirect_index[i]]' with 'array[constant]'.
> >>
> >> As mentioned in the commit log, the speedup is more than significant
> >> for architectures with lots of GPRs so I'd prefer fixing the patch
> >> over reverting it (if there is anything wrong with the code in the
> >> first place)
> >
> > I suspect the problem is with __attribute__((__optimize__("O3"))). It
> > makes compiler use rbp register, which must not be used.
> 
> IIRC, the additional speedup from adding that was significant but not
> huge. Given that we don't use O3 anywhere else, I guess we should just
> remove it.
> 
> Could you please check whether that makes the issue go away?
> 
> If so,
> 
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> for any patch that removes the O3 attribute override from keccakf()

The issue only affects CONFIG_FRAME_POINTER (which is no longer the
default on x86-64), so maybe -O3 could only be enabled for
CONFIG_FRAME_POINTER=n, in which case you'd still get the speedup with
the default ORC unwinder.

-- 
Josh
