From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 01/10] workqueue: add wq_numa_tbl_len and
 wq_numa_possible_cpumask[]
Date: Wed, 20 Mar 2013 07:48:59 -0700
Message-ID: <20130320144859.GU3042@htj.dyndns.org>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
 <1363737629-16745-2-git-send-email-tj@kernel.org>
 <CAAmzW4OosERgCwGnDx7HGHOf7BxbBPNYugA_V8wbegKvOiDqgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: laijs@cn.fujitsu.com, axboe@kernel.dk, jack@suse.cz,
	fengguang.wu@intel.com, jmoyer@redhat.com, zab@redhat.com,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org
To: JoonSoo Kim <js1304@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAmzW4OosERgCwGnDx7HGHOf7BxbBPNYugA_V8wbegKvOiDqgQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Mar 20, 2013 at 11:08:29PM +0900, JoonSoo Kim wrote:
> 2013/3/20 Tejun Heo <tj@kernel.org>:
> > Unbound workqueues are going to be NUMA-affine.  Add wq_numa_tbl_len
> > and wq_numa_possible_cpumask[] in preparation.  The former is the
> > highest NUMA node ID + 1 and the latter is masks of possibles CPUs for
> > each NUMA node.
> 
> It is better to move this code to topology.c or cpumask.c,
> then it can be generally used.

Yeah, it just isn't clear where it should go.  Most NUMA
initialization happens during early boot and arch-specific and
different archs expect NUMA information to be valid at different
point.  We can do it from one of the early initcalls by which all NUMA
information should be valid but, I don't know, having different NUMA
information coming up at different times seems error-prone.  There
would be no apparent indication that certain part is available while
others are not.

We could solve this by unifying how NUMA information is represented
and initialized.  e.g. if all NUMA archs used
CONFIG_USE_PERCPU_NUMA_NODE_ID, we can simply modify
set_cpu_numa_node() to build all data structures as NUMA nodes are
discovered.  Unfortunately, this isn't true yet and it's gonna be a
bit of work to get it in consistent state as it spans over multiple
architectures (not too many tho, NUMA fortunately is rare), so if
somebody can clean it up, I'll be happy to move these to topology.
Right now, I think it's best to just carry it in workqueue.c.

Thanks.

-- 
tejun
