From: Yu Chen <yu.c.chen@intel.com>
Subject: Re: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation
 encryption
Date: Tue, 24 Jul 2018 00:38:48 +0800
Message-ID: <20180723163848.GB4503@sandybridge-desktop>
References: <cover.1531924968.git.yu.c.chen@intel.com>
 <20180718202235.GA4132@amd>
 <20180718235851.GA22170@sandybridge-desktop>
 <20180719110149.GA4679@amd>
 <20180719132003.GA30981@sandybridge-desktop>
 <20180720102532.GA20284@amd>
 <1532346156.3057.11.camel@suse.com>
 <20180723122227.GA30092@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Oliver Neukum <oneukum@suse.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
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
In-Reply-To: <20180723122227.GA30092@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,
On Mon, Jul 23, 2018 at 02:22:27PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > > 2. Ideally kernel memory should be encrypted by the
> > > >    kernel itself. We have uswsusp to support user
> > > >    space hibernation, however doing the encryption
> > > >    in kernel space has more advantages:
> > > >    2.1 Not having to transfer plain text kernel memory to
> > > >        user space. Per Lee, Chun-Yi, uswsusp is disabled
> > > >        when the kernel is locked down:
> > > >        https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/
> > > >        linux-fs.git/commit/?h=lockdown-20180410&
> > > >        id=8732c1663d7c0305ae01ba5a1ee4d2299b7b4612
> > > >        due to:
> > > >        "There have some functions be locked-down because
> > > >        there have no appropriate mechanisms to check the
> > > >        integrity of writing data."
> > > >        https://patchwork.kernel.org/patch/10476751/
> > > 
> > > So your goal is to make hibernation compatible with kernel
> > > lockdown? Do your patches provide sufficient security that hibernation
> > > can be enabled with kernel lockdown?
> > 
> > OK, maybe I am dense, but if the key comes from user space, will that
> > be enough?
> 
> Yes, that seems to be one of problems of Yu Chen's patchset.
> 
It is a trade off to derive the key in user space, we once
tried to derive the key in user space, and people suggested
a better way is to do it in user space. And there is a similar
user case of kernel using key from user space is derived from ecryptfs
for ext4.
> > > > Joey Lee and I had a discussion on his previous work at
> > > > https://patchwork.kernel.org/patch/10476751
> > > > We collaborate on this task and his snapshot signature
> > > > feature can be based on this patch set.
> > > 
> > > Well, his work can also work without your patchset, right?
> > 
> > Yes. But you are objecting to encryption in kernel space at all,
> > aren't you?
> 
> I don't particulary love the idea of doing hibernation encryption in
> the kernel, correct.
> 
> But we have this weird thing called secure boot, some people seem to
> want. So we may need some crypto in the kernel -- but I'd like
> something that works with uswsusp, too. Plus, it is mandatory that
> patch explains what security guarantees they want to provide against
> what kinds of attacks...
> 
> Lee, Chun-Yi's patch seemed more promising.				Pavel
> 
The only difference between Chun-Yi's hibernation encrytion solution
and our solution is that his strategy encrypts the snapshot from sratch, 
and ours encryts each page before them going to block device. The benefit
of his solution is that the snapshot can be encrypt in kernel first
thus the uswsusp is allowed  to read it to user space even kernel
is lock down. And I had a discussion with Chun-Yi that we can use
his snapshot solution to make uswsusp happy, and we share the crypto
help code and he can also use our user provided key for his signature.
>From this point of view, our code are actually the same, except that
we can help clean up the code and also enhance some encrytion process
for his solution. I don't know why you don't like encryption in kernel, 
because from my point of view, without encryption hibernation in kernel,
uswsusp could not be enabled if kernel is lock down : -) Or do I miss something?
Best,
Yu
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
