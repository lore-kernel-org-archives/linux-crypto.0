From: Oliver Neukum <oneukum@suse.com>
Subject: Re: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation
 encryption
Date: Tue, 24 Jul 2018 15:01:01 +0200
Message-ID: <1532437261.17797.22.camel@suse.com>
References: <cover.1531924968.git.yu.c.chen@intel.com>
         <20180718202235.GA4132@amd> <20180718235851.GA22170@sandybridge-desktop>
         <20180719110149.GA4679@amd> <20180719132003.GA30981@sandybridge-desktop>
         <20180720102532.GA20284@amd> <1532346156.3057.11.camel@suse.com>
         <20180723162302.GA4503@sandybridge-desktop> <20180724120133.GD26036@amd>
         <1532436474.17797.20.camel@suse.com> <20180724130110.GA29006@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Yu Chen <yu.c.chen@intel.com>,
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
In-Reply-To: <20180724130110.GA29006@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Di, 2018-07-24 at 15:03 +0200, Pavel Machek wrote:
> On Tue 2018-07-24 14:47:54, Oliver Neukum wrote:
> > On Di, 2018-07-24 at 14:01 +0200, Pavel Machek wrote:

Hi,

> > > Safe against what kind of attack? Please describe what kind of
> > > security you are trying to provide.
> > 
> > Unsigned code must not take over the priviledge level of signed code.
> > Hence:
> > 
> > 1. Unsigned code must not allowed to read sensitive parts of signed
> > code's memory space
> > 
> > 2. Unsigned code must not be able to alter the memory space of
> > signed code -> snapshots that are changed must not be able to be
> > resumed
> 
> Ok.
> 
> > > I don't think generating key in userspace is good enough for providing
> > > guarantees for secure-boot.
> > 
> > Why?
> 
> Because then, userpace has both key (now) and encrypted image (after
> reboot), so it can decrypt, modify, re-encrypt...?

Right. I was dense. But if the key is generated in kernel space,
the method works, doesn't it?

	Regards
		Oliver
