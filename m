From: Oliver Neukum <oneukum@suse.com>
Subject: Re: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation
 encryption
Date: Tue, 24 Jul 2018 13:40:57 +0200
Message-ID: <1532432457.17797.8.camel@suse.com>
References: <cover.1531924968.git.yu.c.chen@intel.com>
         <20180718202235.GA4132@amd> <20180718235851.GA22170@sandybridge-desktop>
         <20180719110149.GA4679@amd> <20180719132003.GA30981@sandybridge-desktop>
         <20180720102532.GA20284@amd> <1532346156.3057.11.camel@suse.com>
         <20180723162302.GA4503@sandybridge-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <smueller@chronox.de>,
        Denis Kenzior <denkenz@gmail.com>,
        Eric Biggers <ebiggers@google.com>,
        Kookoo Gu <kookoo.gu@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Rui Zhang <rui.zhang@intel.com>, Theodore Ts o <tytso@mit.edu>,
        Joey Lee <JLee@suse.com>, Pavel Machek <pavel@ucw.cz>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
To: Yu Chen <yu.c.chen@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180723162302.GA4503@sandybridge-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Di, 2018-07-24 at 00:23 +0800, Yu Chen wrote:
> Hi,
> On Mon, Jul 23, 2018 at 01:42:36PM +0200, Oliver Neukum wrote:
> > On Fr, 2018-07-20 at 12:25 +0200, Pavel Machek wrote:

> > > So your goal is to make hibernation compatible with kernel
> > > lockdown? Do your patches provide sufficient security that hibernation
> > > can be enabled with kernel lockdown?
> > 
> > OK, maybe I am dense, but if the key comes from user space, will that
> > be enough?
> > 
> 
> Good point, we once tried to generate key in kernel, but people
> suggest to generate key in userspace and provide it to the
> kernel, which is what ecryptfs do currently, so it seems this
> should also be safe for encryption in kernel.
> https://www.spinics.net/lists/linux-crypto/msg33145.html
> Thus Chun-Yi's signature can use EFI key and both the key from
> user space.

It seems to me that your initial reasoning was correct and the key
should be generated in kernel space.

	Regards
		Oliver
