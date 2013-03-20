From: Lai Jiangshan <eag0628@gmail.com>
Subject: Re: [PATCH 09/10] workqueue: implement NUMA affinity for unbound workqueues
Date: Wed, 20 Mar 2013 23:26:10 +0800
Message-ID: <CACvQF531UAJVBr1XtT2aZYOt6XATOC383jM=rfiOR-SB3Hj62w@mail.gmail.com>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
	<1363737629-16745-10-git-send-email-tj@kernel.org>
	<CACvQF51hz_H72zVTt4R=P84RDxat+WTe-Ehw8Zbj0cjifNt4ag@mail.gmail.com>
	<20130320150554.GX3042@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: laijs@cn.fujitsu.com, axboe@kernel.dk, jack@suse.cz,
	fengguang.wu@intel.com, jmoyer@redhat.com, zab@redhat.com,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130320150554.GX3042@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Mar 20, 2013 at 11:05 PM, Tejun Heo <tj@kernel.org> wrote:
> On Wed, Mar 20, 2013 at 11:03:53PM +0800, Lai Jiangshan wrote:
>> > +enomem:
>> > +       free_workqueue_attrs(tmp_attrs);
>> > +       if (pwq_tbl) {
>> > +               for_each_node(node)
>> > +                       kfree(pwq_tbl[node]);
>>
>> It will free the dfl_pwq multi times.
>
> Oops, you're right.  We need to do
>
>
>         for_eahc_node(node)
>                 if (pwq_tbl[node] != dfl_pwq)
>                         kfree(pwq_tbl[node]);
>         kfree(dfl_pwq);

I also missed.
we still need to put_unbound_pool() before free(pwq)

>
> Thanks!
>
> --
> tejun
