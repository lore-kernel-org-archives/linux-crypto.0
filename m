From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/6] workqueue: reimplement WQ_HIGHPRI using a separate
 worker_pool
Date: Thu, 12 Jul 2012 10:05:19 -0700
Message-ID: <20120712170519.GA20167@google.com>
References: <1341859315-17759-7-git-send-email-tj@kernel.org>
 <20120712130648.GA19214@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	joshhunt00-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org,
	vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bpm-sJ/iWh9BUns@public.gmane.org,
	elder-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org,
	gustavo-THi1TnShQwVAfugRpC6u6w@public.gmane.org, johan.hedberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
To: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120712130648.GA19214@localhost>
Sender: linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hello, Fengguang.

On Thu, Jul 12, 2012 at 09:06:48PM +0800, Fengguang Wu wrote:
> [    0.207977] WARNING: at /c/kernel-tests/mm/kernel/workqueue.c:1217 worker_enter_idle+0x2b8/0x32b()
> [    0.207977] Modules linked in:
> [    0.207977] Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc6-08414-g9645fff #15
> [    0.207977] Call Trace:
> [    0.207977]  [<ffffffff81087189>] ? worker_enter_idle+0x2b8/0x32b
> [    0.207977]  [<ffffffff810559d9>] warn_slowpath_common+0xae/0xdb
> [    0.207977]  [<ffffffff81055a2e>] warn_slowpath_null+0x28/0x31
> [    0.207977]  [<ffffffff81087189>] worker_enter_idle+0x2b8/0x32b
> [    0.207977]  [<ffffffff81087222>] start_worker+0x26/0x42
> [    0.207977]  [<ffffffff81c8b261>] init_workqueues+0x2d2/0x59a
> [    0.207977]  [<ffffffff81c8af8f>] ? usermodehelper_init+0x8a/0x8a
> [    0.207977]  [<ffffffff81000284>] do_one_initcall+0xce/0x272
> [    0.207977]  [<ffffffff81c6f650>] kernel_init+0x12e/0x3c1
> [    0.207977]  [<ffffffff814b9b74>] kernel_thread_helper+0x4/0x10
> [    0.207977]  [<ffffffff814b80b0>] ? retint_restore_args+0x13/0x13
> [    0.207977]  [<ffffffff81c6f522>] ? start_kernel+0x737/0x737
> [    0.207977]  [<ffffffff814b9b70>] ? gs_change+0x13/0x13

Yeah, I forgot to flip the WARN_ON_ONCE() condition so that it checks
nr_running before looking at pool->nr_running.  The warning is
spurious.  Will post fix soon.

Thanks.

-- 
tejun
