From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [next-20180509][bisected a794d8d] ppc boot warnings at crypto/testmgr.c:3720
Date: Fri, 11 May 2018 10:14:45 +0300
Message-ID: <CAOtvUMd4RGVmkahgFY0L0pWKautxs8qXZXkXx-tAtsNaSB0TPg@mail.gmail.com>
References: <1526021972.6192.7.camel@abdul>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, mpe <mpe@ellerman.id>,
        sachinp <sachinp@linux.vnet.ibm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526021972.6192.7.camel@abdul>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, May 11, 2018 at 9:59 AM, Abdul Haleem
<abdhalee@linux.vnet.ibm.com> wrote:
> Greeting's
>
> Today's next kernel on powerpc machine has boot warnings with commit
>
> a794d8d : crypto: ccree - enable support for hardware keys

Adding the crypto list and maintainer as it came in via the crypto tree.

>
> Warning disappears when above commit is reverted.
>
> Machine Type: Power8 PowerVM LPAR
> kernel : 4.17.0-rc4-next-20180509
> config: attached.
> test: kexec boot
>
> trace logs:
> -----------
> Initialise system trusted keyrings
> workingset: timestamp_bits=38 max_order=18 bucket_order=0
> zbud: loaded
> pstore: using deflate compression
> WARNING: CPU: 6 PID: 109 at crypto/testmgr.c:3720 alg_test.part.6+0xd4/0x460
> Modules linked in:
> CPU: 6 PID: 109 Comm: cryptomgr_test Not tainted 4.17.0-rc4-next-20180509-autotest-00002-g0244ae7 #2
> NIP:  c0000000004a60f4 LR: c0000000004a60e4 CTR: c0000000004a0200
> REGS: c000000289acb9d0 TRAP: 0700   Not tainted  (4.17.0-rc4-next-20180509-autotest-00002-g0244ae7)
> MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 24000484  XER: 20000000
> CFAR: c0000000009b9110 SOFTE: 0
> GPR00: c0000000004a0260 c000000289acbc50 c00000000115df00 0000000000000001
> GPR04: c000000000c13e64 000000000000000d 0000000000000400 0000000000000000
> GPR08: 0000000000000000 0000000000000001 000000000000006b 0000000000000000
> GPR12: 0000000000000000 c00000000eca7800 c000000000128918 c0000002812a3600
> GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
> GPR20: 0000000000000000 c000000000c13560 c000000288c29880 0000000000000400
> GPR24: c000000288c29800 000000000000000d c000000000c135a8 c000000000a1db38
> GPR28: c000000000c13128 c000000000c13e60 c000000000a1c788 0000000000000001
> NIP [c0000000004a60f4] alg_test.part.6+0xd4/0x460
> LR [c0000000004a60e4] alg_test.part.6+0xc4/0x460
> Call Trace:
> [c000000289acbc50] [c000000289acbcc0] 0xc000000289acbcc0 (unreliable)
> [c000000289acbd90] [c0000000004a0260] cryptomgr_test+0x60/0x80
> [c000000289acbdc0] [c000000000128a68] kthread+0x158/0x1a0
> [c000000289acbe30] [c00000000000b628] ret_from_kernel_thread+0x5c/0xb4
> Instruction dump:
> 3b5a56a8 48000024 60000000 eb9effc8 ebbe0000 7f83e378 7fa4eb78 48513001
> 60000000 7c7f1b78 7d3f00d0 79290fe0 <0b090000> 2f9f0000 419d013c 7fe90034
> ---[ end trace f8ddd7633e720997 ]---
> testmgr: alg_test_descs entries in wrong order: 'ecb(paes)' before 'ecb(khazad)'
>

Oouch! this is is my bad. I've changed the cipher name (from haes to
paes) based on review feedback
but forgot that the cipher test names are alphabetically ordered.

I wonder why I didn't see this myself as I'm 100% sure booted this fix
on 2 different platforms.

Maybe because Khazad was not enabled in my test setup and I guess
there are no other cipher starting in I, L,M,N,O ?

Fix coming up shortly. Sorry about this.

Gilad



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
