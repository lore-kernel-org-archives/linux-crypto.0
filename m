From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: virtio-rng scatterlist null pointer dereference with VMAP_STACK=y
Date: Sun, 16 Oct 2016 09:59:54 -0700
Message-ID: <CALCETrV6dT7dB1+KkHEo2V_kpO1STWBY196VUPRSVAZCQiJeOQ@mail.gmail.com>
References: <20161016002151.GA18235@hydra.tuxags.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jens Axboe <axboe@fb.com>,
        Dave Gordon <david.s.gordon@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161016002151.GA18235@hydra.tuxags.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Oct 15, 2016 at 5:21 PM, Matt Mullins <mmullins@mmlx.us> wrote:
> With VMAP_STACK=y and HW_RANDOM_VIRTIO=y, I get the following crash:
>
> [    1.470437] BUG: unable to handle kernel NULL pointer dereference at  (null)
> [    1.473350] IP: [<ffffffff812f7c35>] sg_init_one+0x65/0x90
> [    1.474658] PGD 0
> [    1.475169] Oops: 0000 [#1] SMP
>
> Entering kdb (current=0xffff880069b0c980, pid 1) on processor 1 Oops: (null)
> due to oops @ 0xffffffff812f7c35
> CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.8.0-08682-g41844e3 #246
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> task: ffff880069b0c980 task.stack: ffffc90000c54000
> RIP: 0010:[<ffffffff812f7c35>]  [<ffffffff812f7c35>] sg_init_one+0x65/0x90
> RSP: 0000:ffffc90000c57d00  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffffc90000c57d20 RCX: 0000000000082000
> RDX: 0000000000000d68 RSI: 0000000410000c57 RDI: ffffc90000c57d40
> RBP: 0000000000000820 R08: 0000000000000000 R09: ffffc90000c57d20
> R10: 0000000000019228 R11: ffff88017fff8500 R12: 0000000000000010
> R13: 0000000000000010 R14: 0000000000000000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88017fc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000001806000 CR4: 00000000001406a0
> Stack:
>  ffff8800694bf500 0000000000000001 ffffc90000c57d68 ffffffff8138286f
>  0000000000000002 0000000000000000 0000000000000000 0000000000000000
>  ffff8800694bf500 ffffc90000c57d68 ffff8800694bf500 0000000000000000
> Call Trace:
>  [<ffffffff8138286f>] ? virtio_read+0x9f/0xe0
>  [<ffffffff81381ade>] ? add_early_randomness+0x3e/0xa0
>  [<ffffffff813820af>] ? set_current_rng+0x3f/0x160
>  [<ffffffff81382416>] ? hwrng_register+0x186/0x1d0
>  [<ffffffff81382620>] ? virtrng_scan+0x10/0x20
>  [<ffffffff8135790e>] ? virtio_dev_probe+0x21e/0x2b0
>  [<ffffffff8138789e>] ? really_probe+0x14e/0x250
>  [<ffffffff81387a22>] ? __driver_attach+0x82/0xa0
>  [<ffffffff813879a0>] ? really_probe+0x250/0x250
>  [<ffffffff81385d22>] ? bus_for_each_dev+0x52/0x80
>  [<ffffffff81387093>] ? bus_add_driver+0x1a3/0x220
>  [<ffffffff818b0634>] ? hwrng_modinit+0xc/0xc
>  [<ffffffff81388046>] ? driver_register+0x56/0xd0
>  [<ffffffff818b0634>] ? hwrng_modinit+0xc/0xc
>  [<ffffffff810003c2>] ? do_one_initcall+0x32/0x150
>  [<ffffffff81095900>] ? parse_args+0x170/0x390
>  [<ffffffff8188a188>] ? kernel_init_freeable+0x11e/0x1a3
>  [<ffffffff818898f4>] ? set_debug_rodata+0xc/0xc
>  [<ffffffff8157d930>] ? rest_init+0x70/0x70
>  [<ffffffff8157d935>] ? kernel_init+0x5/0x100
>  [<ffffffff81582625>] ? ret_from_fork+0x25/0x30
> Code: 01 c5 48 89 ee 48 89 e9 48 c1 ed 23 48 8b 04 ed c0 49 9c 81 48 c1 ee 0c
> 48 c1 e9 1b 48 85 c0 74 0a 0f b6 c9 48 c1 e1 04 48 01 c8 <48> 8b 08 48 89 f0 89
> 53 08 48 c1 e0 06 44 89 63 0c 48 83 e1 fc
>
>
> It looks like add_early_randomness() uses a buffer on the stack, which (with
> VMAP_STACK) fails to be added to a scatterlist due to use of virt_to_page in
> sg_set_buf().
>
> None of this looks obviously wrong to me, but in combination it is not
> functional.  Hence, I don't have a particular fix in mind, and I've CC'ed folks
> from both the hw_random and scatterlist history.

Using a buffer on the stack is bogus here.  Presumably virtio_read
should allocate a heap buffer.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
