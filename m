From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 1/5] random: Blocking API for accessing nonblocking_pool
Date: Tue, 19 May 2015 09:35:15 +0200
Message-ID: <2404915.vbuKFfjVR8@tachyon.chronox.de>
References: <1921857.OvxEu6y28S@tachyon.chronox.de> <6511355.kQJsTdtLzf@tachyon.chronox.de> <20150519072227.GA28837@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>, pebolle@tiscali.nl,
	andreas.steffen@strongswan.org, sandyinchina@gmail.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150519072227.GA28837@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 19. Mai 2015, 15:22:27 schrieb Herbert Xu:

Hi Herbert,

> On Tue, May 19, 2015 at 07:58:25AM +0200, Stephan Mueller wrote:
> > Herbert, do you have any ideas?
> 
> On the /dev/random side,
> 
> 1) Add a struct module argument in addition to func/data.
> 2) Grab module ref count when func/data is registered.
> 3) Drop module ref count after func returns.
> 
> On the drbg side,
> 
> 1) Allocate data pointer before func/data registration, it should
> contain a flag indicating whether drbg is still alive.
> 2) In cra_exit, zap the flag in allocated data.
> 3) In func immediately return if flag indicates drbg is dead.
> 4) Free allocated data pointer when func is done.
> 
> Obviously you need to add some locking so that func doesn't race
> against cra_exit or any other drbg paths that it intersects.

Thank you for the hints. I will follow your guidance.

Just for my edification: why is this (rather complex sounding) approach 
preferred over a simple cancel API? Other async APIs (e.g. the AIO syscalls 
with io_cancel) have such cancel operations.

Such cancel function would be as simple as:

void get_blocking_random_bytes_cancel(void *private)
{
        struct random_work *rw, *tmp;

        mutex_lock(&random_wait_list_mutex);
        list_for_each_entry_safe(rw, tmp, &random_wait_list, list) {
                if (private == rw->rw_private) {
                        list_del(&rw->list);
                        kfree(rw);
                        break;
                }
        }
        mutex_unlock(&random_wait_list_mutex);
}

-- 
Ciao
Stephan
