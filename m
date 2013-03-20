From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 01/10] workqueue: add wq_numa_tbl_len and
 wq_numa_possible_cpumask[]
Date: Wed, 20 Mar 2013 08:48:14 -0700
Message-ID: <20130320154814.GY3042@htj.dyndns.org>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
 <1363737629-16745-2-git-send-email-tj@kernel.org>
 <CACvQF53ssw_o4Hbjnp9Z2MZieBO=WhL0Po80jR6NGEjMNGENGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: laijs@cn.fujitsu.com, axboe@kernel.dk, jack@suse.cz,
	fengguang.wu@intel.com, jmoyer@redhat.com, zab@redhat.com,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org
To: Lai Jiangshan <eag0628@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACvQF53ssw_o4Hbjnp9Z2MZieBO=WhL0Po80jR6NGEjMNGENGA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Mar 20, 2013 at 11:43:30PM +0800, Lai Jiangshan wrote:
> > +       for_each_node(node)
> > +               BUG_ON(!alloc_cpumask_var_node(&wq_numa_possible_cpumask[node],
> > +                                              GFP_KERNEL, node));
> > +       for_each_possible_cpu(cpu) {
> > +               node = cpu_to_node(cpu);
> > +               if (WARN_ON(node == NUMA_NO_NODE)) {
> > +                       pr_err("workqueue: NUMA node mapping not available for cpu%d, disabling NUMA support\n", cpu);
> 
> since you used WARN_ON(), not BUG_ON(), I think you need to free
> allocated memory here.

I don't know.  Is it necessary?  It shouldn't happen sans bugs in arch
code and we're vomiting warning message with full stack trace.  The
system will function but something is seriously screwed.  I don't
think it matters whether we free the puny number of bytes there or
not and I don't wanna nest deeper there. :P

-- 
tejun
