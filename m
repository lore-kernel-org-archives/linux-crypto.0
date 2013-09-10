From: Lucas De Marchi <lucas.de.marchi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] modules: add support for soft module dependencies
Date: Tue, 10 Sep 2013 11:01:38 -0300
Message-ID: <CAKi4VA+=1vOOt0BqdQHQaeF1hP3DrRtCL_ObXY0cPeO7S_MtYw@mail.gmail.com>
References: <20130724071757.GA30970@gondor.apana.org.au> <87siz38q2t.fsf@rustcorp.com.au>
 <20130725020329.GA14625@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
	Andreas Robinson <andr345-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Zhao Hongjiang <zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
	David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org,
	Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	"gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-modules <linux-modules-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-modules-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130725020329.GA14625-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-modules-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 24, 2013 at 11:03 PM, Herbert Xu
<herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org> wrote:
> On Thu, Jul 25, 2013 at 09:32:02AM +0930, Rusty Russell wrote:
>> Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org> writes:
>> > Hi Rusty:
>> >
>> > I don't know why this patch never went into the kernel, even
>> > though the corresponding features have been added to modprobe
>> > in most if not all distros.
>>
>> Because Andreas never sent me the patch?  This is the first I've *heard*
>> of this feature.  Looks like it didn't hit lkml either.  And what was
>> 2/2?
>
> 2/2 was the patch to actually use this in crc32c.
>
>> It's not how I would have done this: post-deps are more flexibly done at
>> runtime, because the module may have to do work to figure out what to
>> pull in.  But since it already exists, I'll apply this patch: it doesn't
>> cost the kernel anything.

But it did cause boot failures. The file modules.softdep file was
supposed to be informational until now. That's why depmod put a
comment saying to "copy on user's discretion to /etc/modules.d"
instead of parsing it directly.

If dependencies expressed with softdeps can be required dependencies
now, depmod needs to be updated to work it out otherwise we will get
missing dependencies as happened with the crypto stuff after this
patch. I'm CC'ing Tom who had the boot failure; it looks like the same
boot failure that caused this feature to get reverted the first time
(the deps being required by sd_mod).

Even if it is an optional module, it would be great to have depmod
updated so it parses the file directly now that we are exporting this
info. I can do that once we agree what we want to do with softdeps
coming directly from kernel itself.

However looking at the only user right now, crct10dif: couldn't we
detect at runtime if this module can be used instead of just trying to
load it as a pre softdep and possibly failing?


Lucas De Marchi
