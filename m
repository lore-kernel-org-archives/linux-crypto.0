From: Oliver Neukum <oneukum@suse.com>
Subject: Re: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation
 encryption
Date: Tue, 24 Jul 2018 14:47:54 +0200
Message-ID: <1532436474.17797.20.camel@suse.com>
References: <cover.1531924968.git.yu.c.chen@intel.com>
         <20180718202235.GA4132@amd> <20180718235851.GA22170@sandybridge-desktop>
         <20180719110149.GA4679@amd> <20180719132003.GA30981@sandybridge-desktop>
         <20180720102532.GA20284@amd> <1532346156.3057.11.camel@suse.com>
         <20180723162302.GA4503@sandybridge-desktop> <20180724120133.GD26036@amd>
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
In-Reply-To: <20180724120133.GD26036@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Di, 2018-07-24 at 14:01 +0200, Pavel Machek wrote:
> Hi!
> 
> > > > >        "There have some functions be locked-down because
> > > > >        there have no appropriate mechanisms to check the
> > > > >        integrity of writing data."
> > > > >        https://patchwork.kernel.org/patch/10476751/
> > > > 
> > > > So your goal is to make hibernation compatible with kernel
> > > > lockdown? Do your patches provide sufficient security that hibernation
> > > > can be enabled with kernel lockdown?
> > > 
> > > OK, maybe I am dense, but if the key comes from user space, will that
> > > be enough?
> > > 
> > 
> > Good point, we once tried to generate key in kernel, but people
> > suggest to generate key in userspace and provide it to the
> > kernel, which is what ecryptfs do currently, so it seems this
> > should also be safe for encryption in kernel.
> 
> Safe against what kind of attack? Please describe what kind of
> security you are trying to provide.

Unsigned code must not take over the priviledge level of signed code.
Hence:

1. Unsigned code must not allowed to read sensitive parts of signed
code's memory space

2. Unsigned code must not be able to alter the memory space of
signed code -> snapshots that are changed must not be able to be
resumed

> I don't think generating key in userspace is good enough for providing
> guarantees for secure-boot.

Why?

	Regards
		Oliver
