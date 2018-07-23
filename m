From: Oliver Neukum <oneukum@suse.com>
Subject: Re: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation
 encryption
Date: Mon, 23 Jul 2018 13:42:36 +0200
Message-ID: <1532346156.3057.11.camel@suse.com>
References: <cover.1531924968.git.yu.c.chen@intel.com>
         <20180718202235.GA4132@amd> <20180718235851.GA22170@sandybridge-desktop>
         <20180719110149.GA4679@amd> <20180719132003.GA30981@sandybridge-desktop>
         <20180720102532.GA20284@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        "Lee, Chun-Yi" <jlee@suse.com>, Theodore Ts o <tytso@mit.edu>,
        Stephan Mueller <smueller@chronox.de>,
        Denis Kenzior <denkenz@gmail.com>, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gu, Kookoo" <kookoo.gu@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
To: Pavel Machek <pavel@ucw.cz>, Yu Chen <yu.c.chen@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720102532.GA20284@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fr, 2018-07-20 at 12:25 +0200, Pavel Machek wrote:
> Hi!

Hello,

> > Let me paste the log here:
> > 
> > 1. (This is not to compare with uswsusp but other
> >     tools) One advantage is: Users do not have to
> >     encrypt the whole swap partition as other tools.
> 
> Well.. encrypting the partition seems like good idea anyway.

Yes, but it is a policy decision the kernel should not force.
STD needs to work anyway.

> > 2. Ideally kernel memory should be encrypted by the
> >    kernel itself. We have uswsusp to support user
> >    space hibernation, however doing the encryption
> >    in kernel space has more advantages:
> >    2.1 Not having to transfer plain text kernel memory to
> >        user space. Per Lee, Chun-Yi, uswsusp is disabled
> >        when the kernel is locked down:
> >        https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/
> >        linux-fs.git/commit/?h=lockdown-20180410&
> >        id=8732c1663d7c0305ae01ba5a1ee4d2299b7b4612
> >        due to:
> >        "There have some functions be locked-down because
> >        there have no appropriate mechanisms to check the
> >        integrity of writing data."
> >        https://patchwork.kernel.org/patch/10476751/
> 
> So your goal is to make hibernation compatible with kernel
> lockdown? Do your patches provide sufficient security that hibernation
> can be enabled with kernel lockdown?

OK, maybe I am dense, but if the key comes from user space, will that
be enough?

> >    2.2 Not having to copy each page to user space
> >        one by one not in parallel, which might introduce
> >        significant amount of copy_to_user() and it might
> >        not be efficient on servers having large amount of DRAM.
> 
> So how big speedup can be attributed by not doing copy_to_user?

That would be an argument for compression in kernel space.
Not encrpting would always be faster.

> >    2.3 Distribution has requirement to do snapshot
> >        signature for verification, which can be built
> >        by leveraging this patch set.
> 
> Signatures can be done by uswsusp, too, right?

Not if you want to keep the chain of trust intact. User space
is not signed.

> >    2.4 The encryption is in the kernel, so it doesn't
> >        have to worry too much about bugs in user space
> >        utilities and similar, for example.
> 
> Answer to bugs in userspace is _not_ to move code from userspace to kernel.

Indeed.

> > Joey Lee and I had a discussion on his previous work at
> > https://patchwork.kernel.org/patch/10476751
> > We collaborate on this task and his snapshot signature
> > feature can be based on this patch set.
> 
> Well, his work can also work without your patchset, right?

Yes. But you are objecting to encryption in kernel space at all,
aren't you?

	Regards
		Oliver
