From: Yu Chen <yu.c.chen@intel.com>
Subject: Re: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation
 encryption
Date: Tue, 24 Jul 2018 00:23:02 +0800
Message-ID: <20180723162302.GA4503@sandybridge-desktop>
References: <cover.1531924968.git.yu.c.chen@intel.com>
 <20180718202235.GA4132@amd>
 <20180718235851.GA22170@sandybridge-desktop>
 <20180719110149.GA4679@amd>
 <20180719132003.GA30981@sandybridge-desktop>
 <20180720102532.GA20284@amd>
 <1532346156.3057.11.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pavel Machek <pavel@ucw.cz>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        "Lee, Chun-Yi" <jlee@suse.com>, Theodore Ts o <tytso@mit.edu>,
        Stephan Mueller <smueller@chronox.de>,
        Denis Kenzior <denkenz@gmail.com>, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gu, Kookoo" <kookoo.gu@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
To: Oliver Neukum <oneukum@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1532346156.3057.11.camel@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,
On Mon, Jul 23, 2018 at 01:42:36PM +0200, Oliver Neukum wrote:
> On Fr, 2018-07-20 at 12:25 +0200, Pavel Machek wrote:
> > Hi!
> 
> Hello,
> 
> > > Let me paste the log here:
> > > 
> > > 1. (This is not to compare with uswsusp but other
> > >     tools) One advantage is: Users do not have to
> > >     encrypt the whole swap partition as other tools.
> > 
> > Well.. encrypting the partition seems like good idea anyway.
> 
> Yes, but it is a policy decision the kernel should not force.
> STD needs to work anyway.
>
If the swap partition is too large, and there's low usage
of memory, then it might a little time costly to encrypt
the whole partition. You are right, people has choice to
choose which mode they like.
> > > 2. Ideally kernel memory should be encrypted by the
> > >    kernel itself. We have uswsusp to support user
> > >    space hibernation, however doing the encryption
> > >    in kernel space has more advantages:
> > >    2.1 Not having to transfer plain text kernel memory to
> > >        user space. Per Lee, Chun-Yi, uswsusp is disabled
> > >        when the kernel is locked down:
> > >        https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/
> > >        linux-fs.git/commit/?h=lockdown-20180410&
> > >        id=8732c1663d7c0305ae01ba5a1ee4d2299b7b4612
> > >        due to:
> > >        "There have some functions be locked-down because
> > >        there have no appropriate mechanisms to check the
> > >        integrity of writing data."
> > >        https://patchwork.kernel.org/patch/10476751/
> > 
> > So your goal is to make hibernation compatible with kernel
> > lockdown? Do your patches provide sufficient security that hibernation
> > can be enabled with kernel lockdown?
> 
> OK, maybe I am dense, but if the key comes from user space, will that
> be enough?
> 
Good point, we once tried to generate key in kernel, but people
suggest to generate key in userspace and provide it to the
kernel, which is what ecryptfs do currently, so it seems this
should also be safe for encryption in kernel.
https://www.spinics.net/lists/linux-crypto/msg33145.html
Thus Chun-Yi's signature can use EFI key and both the key from
user space.
Best,
Yu
> > >    2.2 Not having to copy each page to user space
> > >        one by one not in parallel, which might introduce
> > >        significant amount of copy_to_user() and it might
> > >        not be efficient on servers having large amount of DRAM.
> > 
> > So how big speedup can be attributed by not doing copy_to_user?
> 
> That would be an argument for compression in kernel space.
> Not encrpting would always be faster.
> 
> > >    2.3 Distribution has requirement to do snapshot
> > >        signature for verification, which can be built
> > >        by leveraging this patch set.
> > 
> > Signatures can be done by uswsusp, too, right?
> 
> Not if you want to keep the chain of trust intact. User space
> is not signed.
> 
> > >    2.4 The encryption is in the kernel, so it doesn't
> > >        have to worry too much about bugs in user space
> > >        utilities and similar, for example.
> > 
> > Answer to bugs in userspace is _not_ to move code from userspace to kernel.
> 
> Indeed.
> 
> > > Joey Lee and I had a discussion on his previous work at
> > > https://patchwork.kernel.org/patch/10476751
> > > We collaborate on this task and his snapshot signature
> > > feature can be based on this patch set.
> > 
> > Well, his work can also work without your patchset, right?
> 
> Yes. But you are objecting to encryption in kernel space at all,
> aren't you?
> 
> 	Regards
> 		Oliver
> 
