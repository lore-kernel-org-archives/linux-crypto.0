From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation
 encryption
Date: Thu, 19 Jul 2018 22:58:47 +0800
Message-ID: <20180719145847.GJ18419@linux-l9pv.suse>
References: <cover.1531924968.git.yu.c.chen@intel.com>
 <20180718202235.GA4132@amd>
 <20180718235851.GA22170@sandybridge-desktop>
 <20180719110149.GA4679@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yu Chen <yu.c.chen@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        Theodore Ts o <tytso@mit.edu>,
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

Hi,

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

My patchset signs and encrypts the snapshot image pages in memory. The
main logic is applied to snapshot.c

https://github.com/joeyli/linux-s4sign/commit/bae39460393ada4c0226dd07cd5e3afcef86b71f

The pros of my solution is that the signed/encrypted snapshot image can 
be stored to anywhere. Both in-kernel and userspace.

Yu's patch is encrypt the page buffer before sending to block io layer
for writing to swap. The main logic is applied to swap.c. It's against
the swap solution in-kernel.

The pros of Yu's solution is that it encrypts the compressed image data.
So, for the huge system memory case, it has better performance.

Yu's plan is using the sysfs to switch different encrypt/sign solutions.
And, we will share encrypt/sign helper and key manager in the above two
solutions.

Thanks a lot!
Joey Lee
