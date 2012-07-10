From: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/6] workqueue: use @pool instead of @gcwq or @cpu where applicable
Date: Tue, 10 Jul 2012 16:30:36 -0700
Message-ID: <CA+8MBbKtCODJxv0zQ2uL_wRE9U6F6tdOVwYSMv9=OQNLGzcVXQ@mail.gmail.com>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
	<1341859315-17759-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	joshhunt00-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org,
	vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bpm-sJ/iWh9BUns@public.gmane.org,
	elder-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org,
	gustavo-THi1TnShQwVAfugRpC6u6w@public.gmane.org, johan.hedberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1341859315-17759-4-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 9, 2012 at 11:41 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> @@ -1234,7 +1235,7 @@ static void worker_enter_idle(struct worker *worker)
>          */
>         WARN_ON_ONCE(gcwq->trustee_state == TRUSTEE_DONE &&
>                      pool->nr_workers == pool->nr_idle &&
> -                    atomic_read(get_gcwq_nr_running(gcwq->cpu)));
> +                    atomic_read(get_pool_nr_running(pool)));
>  }

Just had this WARN_ON_ONCE trigger on ia64 booting next-20120710. I
haven't bisected ... just noticed  that two patches in this series tinker
with lines in this check. next-20120706 didn't generate the WARN.

-Tony

Mount-cache hash table entries: 1024
ACPI: Core revision 20120518
Boot processor id 0x0/0x0
------------[ cut here ]------------
WARNING: at kernel/workqueue.c:1217 worker_enter_idle+0x2d0/0x4a0()
Modules linked in:

Call Trace:
 [<a0000001000154e0>] show_stack+0x80/0xa0
                                sp=e0000040600f7c30 bsp=e0000040600f0da8
 [<a000000100d6e870>] dump_stack+0x30/0x50
                                sp=e0000040600f7e00 bsp=e0000040600f0d90
 [<a0000001000730a0>] warn_slowpath_common+0xc0/0x100
                                sp=e0000040600f7e00 bsp=e0000040600f0d50
 [<a000000100073120>] warn_slowpath_null+0x40/0x60
                                sp=e0000040600f7e00 bsp=e0000040600f0d28
 [<a0000001000aaad0>] worker_enter_idle+0x2d0/0x4a0
                                sp=e0000040600f7e00 bsp=e0000040600f0cf0
 [<a0000001000ad020>] worker_thread+0x4a0/0xbe0
                                sp=e0000040600f7e00 bsp=e0000040600f0c28
 [<a0000001000bda70>] kthread+0x110/0x140
                                sp=e0000040600f7e00 bsp=e0000040600f0be8
 [<a000000100013510>] kernel_thread_helper+0x30/0x60
                                sp=e0000040600f7e30 bsp=e0000040600f0bc0
 [<a00000010000a0c0>] start_kernel_thread+0x20/0x40
                                sp=e0000040600f7e30 bsp=e0000040600f0bc0
---[ end trace 9501f2472a75a227 ]---
