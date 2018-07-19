From: Yu Chen <yu.c.chen@intel.com>
Subject: Re: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation
 encryption
Date: Thu, 19 Jul 2018 21:20:03 +0800
Message-ID: <20180719132003.GA30981@sandybridge-desktop>
References: <cover.1531924968.git.yu.c.chen@intel.com>
 <20180718202235.GA4132@amd>
 <20180718235851.GA22170@sandybridge-desktop>
 <20180719110149.GA4679@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        "Lee, Chun-Yi" <jlee@suse.com>, Theodore Ts o <tytso@mit.edu>,
        Stephan Mueller <smueller@chronox.de>,
        Denis Kenzior <denkenz@gmail.com>, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gu, Kookoo" <kookoo.gu@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180719110149.GA4679@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 19, 2018 at 01:01:49PM +0200, Pavel Machek wrote:
> On Thu 2018-07-19 07:58:51, Yu Chen wrote:
> > Hi,
> > On Wed, Jul 18, 2018 at 10:22:35PM +0200, Pavel Machek wrote:
> > > On Thu 2018-07-19 00:38:06, Chen Yu wrote:
> > > > As security becomes more and more important, we add the in-kernel
> > > > encryption support for hibernation.
> > > 
> > > Sorry, this does not really explain what security benefit it is
> > > supposed have to against what attack scenarios.
> > > 
> > > Which unfortunately means it can not reviewed.
> > > 
> > > Note that uswsusp already provides encryption. If this is supposed to
> > > have advantages over it, please say so.
> > > 
> > The advantages are described in detail in 
> > [PATCH 1/4]'s log, please refer to that.
> 
> Are you refering to this?
>
Not this one. I've sent v2 of this patch set which
explain more on this:
https://patchwork.kernel.org/patch/10532935/
Let me paste the log here:

1. (This is not to compare with uswsusp but other
    tools) One advantage is: Users do not have to
    encrypt the whole swap partition as other tools.

2. Ideally kernel memory should be encrypted by the
   kernel itself. We have uswsusp to support user
   space hibernation, however doing the encryption
   in kernel space has more advantages:
   2.1 Not having to transfer plain text kernel memory to
       user space. Per Lee, Chun-Yi, uswsusp is disabled
       when the kernel is locked down:
       https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/
       linux-fs.git/commit/?h=lockdown-20180410&
       id=8732c1663d7c0305ae01ba5a1ee4d2299b7b4612
       due to:
       "There have some functions be locked-down because
       there have no appropriate mechanisms to check the
       integrity of writing data."
       https://patchwork.kernel.org/patch/10476751/
 
   2.2 Not having to copy each page to user space
       one by one not in parallel, which might introduce
       significant amount of copy_to_user() and it might
       not be efficient on servers having large amount of DRAM.
   2.3 Distribution has requirement to do snapshot
       signature for verification, which can be built
       by leveraging this patch set.
   2.4 The encryption is in the kernel, so it doesn't
       have to worry too much about bugs in user space
       utilities and similar, for example.
> # Generally the advantage is: Users do not have to
> # encrypt the whole swap partition as other tools.
> # After all, ideally kernel memory should be encrypted
> # by the kernel itself.
> 
> Sorry, this does not really explain what security benefit it is
> supposed have to against what attack scenarios.
> 
> Note that uswsusp already provides encryption. If this is supposed to
> have advantages over it, please say so.
> 
> Also note that joeyli <jlee@suse.com> has patch series which encrypts
> both in-kernel and uswsusp hibernation methods. His motivation is
> secure boot. How does this compare to his work?
>
Joey Lee and I had a discussion on his previous work at
https://patchwork.kernel.org/patch/10476751
We collaborate on this task and his snapshot signature
feature can be based on this patch set.

Thanks,
Yu
