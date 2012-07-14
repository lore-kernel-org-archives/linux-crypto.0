From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/6] workqueue: introduce NR_WORKER_POOLS and
 for_each_worker_pool()
Date: Fri, 13 Jul 2012 21:44:38 -0700
Message-ID: <20120714044438.GA7718@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
 <1341859315-17759-6-git-send-email-tj@kernel.org>
 <20120714035538.GB5638@dhcp-172-17-108-109.mtv.corp.google.com>
 <CA+55aFyeauqCqrWsx4U2TB2ENrugZXYj+4vw3Fd0kGaeWBP3RA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, joshhunt00-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
	davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bpm-sJ/iWh9BUns@public.gmane.org, elder-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, gustavo-THi1TnShQwVAfugRpC6u6w@public.gmane.org,
	johan.hedberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyeauqCqrWsx4U2TB2ENrugZXYj+4vw3Fd0kGaeWBP3RA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hello, Linus.

On Fri, Jul 13, 2012 at 09:27:03PM -0700, Linus Torvalds wrote:
> Seeing code like this
> 
> +       return &(*nr_running)[0];
> 
> just makes me go "WTF?"

I was going WTF too.  This was the smallest fix and I wanted to make
it minimal because there's another stack of patches on top of it.
Planning to just fold nr_running into worker_pool afterwards which
will remove the whole function.

> Why are you taking the address of something you just dereferenced (the
> "& [0]" part).

nr_running is atomic_t (*nr_running)[2].  Ignoring the pointer to
array part, it's just returning the address of N'th element of the
array.  ARRAY + N == &ARRAY[N].

> And you actually do that *twice*, except the inner one is more
> complicated. When you assign nr_runing, you take the address of it, so
> the "*nr_running" is actually just the same kind of odd thing (except
> in reverse - you take dereference something you just took the
> address-of).
> 
> Seriously, this to me is a sign of *deeply* confused code. And the
> fact that your first version of that code was buggy *EXACTLY* due to
> this confusion should have made you take a step back.

Type-wise, I don't think it's confused.  Ah okay, you're looking at
the fifth patch in isolation.  Upto this point, the index is always 0.
I'm puttin it in as a placeholder for the next patch which makes use
of non-zero index.  This patch is supposed to prepare everything for
multiple pools and thus non-zero index.

> As far as I can tell, what you actually want that function to do is:
> 
>   static atomic_t *get_pool_nr_running(struct worker_pool *pool)
>   {
>     int cpu = pool->gcwq->cpu;
> 
>     if (cpu != WORK_CPU_UNBOUND)
>         return per_cpu(pool_nr_running, cpu);
> 
>     return unbound_pool_nr_running;
>   }

More like the folloiwng in the end.

static atomic_t *get_pool_nr_running(struct worker_pool *pool)
{
	int cpu = pool->gcwq->cpu;
	int is_highpri = pool_is_highpri(pool);

	if (cpu != WORK_CPU_UNBOUND)
		return &per_cpu(pool_nr_running, cpu)[is_highpri];

	return &unbound_pool_nr_running[is_highpri];
}

> I didn't test the code, btw. I just looked at the patch and went WTF.

Eh... yeah, with or without [2], this is WTF.  I'll just refresh it
with the above version.

Thanks.

-- 
tejun
