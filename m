From: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>
Subject: Re: [PATCH] modules: add support for soft module dependencies
Date: Wed, 18 Sep 2013 16:47:10 +0930
Message-ID: <87zjray4y1.fsf@rustcorp.com.au>
References: <20130724071757.GA30970@gondor.apana.org.au> <87siz38q2t.fsf@rustcorp.com.au> <20130725020329.GA14625@gondor.apana.org.au> <CAKi4VA+=1vOOt0BqdQHQaeF1hP3DrRtCL_ObXY0cPeO7S_MtYw@mail.gmail.com> <87ob7x37p6.fsf@rustcorp.com.au> <CAKi4VALAu0ek6tYhb_Ls34hNU1Omjhv=QJDaACAp_0gpRy98HA@mail.gmail.com> <878uyuzxp0.fsf@rustcorp.com.au> <CAMOw1v7RhTfWu0K64ndxXdET9JQjg7Pr3DWKGMSM9gN9_pviJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lucas De Marchi <lucas.de.marchi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Andreas Robinson <andr345-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Zhao Hongjiang <zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
	David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org,
	Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	"gregkh\@linuxfoundation.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-modules <linux-modules-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
To: Lucas De Marchi <lucas.demarchi-Y3ZbgMPKUGA34EUeqzHoZw@public.gmane.org>
Return-path: <linux-modules-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMOw1v7RhTfWu0K64ndxXdET9JQjg7Pr3DWKGMSM9gN9_pviJQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-modules-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Lucas De Marchi <lucas.demarchi-Y3ZbgMPKUGA34EUeqzHoZw@public.gmane.org> writes:
> On Tue, Sep 17, 2013 at 11:10 PM, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org> wrote:
>> Lucas De Marchi <lucas.de.marchi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>>> On Thu, Sep 12, 2013 at 9:07 PM, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org> wrote:
>>>> I'm happy to change this macro to create a modinfo line like
>>>> "softdep:<modname>"
>>>
>>> how is that solving the issue that this macro can be used to designate
>>> a mandatory or optional dependency
>>> (https://lkml.org/lkml/2013/9/10/371)? If we decide the dependency is
>>> mandatory we can very well let modprobe use that dependency during
>>> module load
>>
>> I'm very close to sending Linus a revert commit at this point, since
>> there's no consensus on what it's for.
>>
>> *Clearly* softdep shouldn't indicate a mandatory dependency.  We already
>> have a way (several) to make mandatory dependencies!
>>
>> And the "pre:" vs "post:" thing is just weird.  If a module wants a post
>> dependency, you can request_module() it from a workqueue.
>>
>>>> ie. tools like mkinitrd could pick it up and try to find a matching
>>>> module, but depmod would ignore it.
>>>
>>> Some mkinitrd-like use whatever depmod/modprobe tells them it's
>>> needed. So kmod still needs to know about it.
>>
>> It sounds like we should create a separate tool, which takes a list of
>> modules and spits out the full pathname of all dependencies.  *That*
>> tool should include soft dependencies.
>>
>>>> It's really up to Lucas, since this affects him.
>>>
>>> IMO  saying "this is an optional dependency and we can work without"
>>> doesn't buy us much. Distros will end up putting the soft dep in
>>> /etc/modules.d, kmod will always use them anyway and failing to load
>>> the soft dep will fail the module load. I'd like to have no distro
>>> files in /etc/modules.d in future.
>>
>> I assumed modprobe would handle soft dependencies in modules and try to
>> pull them in, but *not* fail if they don't work.
>
> Iff the module doesn't *exist*. If it failed to load or failed for any
> other reason then we will abort trying to load the other module.
> However this is one thing we can change in modprobe to make it
> consistent and more predictable. But we really need to reach a
> consensus.

It is a bit of a corner case, but there are other conceivable reasons
why a module wouldn't load.  The hardware it wants might not be present,
or busy, or it conflicts with an existing module, or needs user
configuration (eg. commandline params).

It might be worth reporting, but I wouldn't stop loading on softdep fails.

>> The previous way of doing this was:
>>         install foo modprobe foo_softdep 2>/dev/null; modprobe --ignore-install foo $CMDLINE_OPTS
>
> I just hope this is in no way an incentive for people using install commands ;-)

Agreed.  install commands were implemented because I had no idea what
people wanted to do in future.  They definitely provide enough rope...

Cheers,
Rusty.
