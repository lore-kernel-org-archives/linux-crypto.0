From: Oliver Neukum <oneukum@suse.com>
Subject: Re: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation
 encryption
Date: Tue, 24 Jul 2018 13:49:41 +0200
Message-ID: <1532432981.17797.13.camel@suse.com>
References: <cover.1531924968.git.yu.c.chen@intel.com>
         <20180718202235.GA4132@amd> <20180718235851.GA22170@sandybridge-desktop>
         <20180719110149.GA4679@amd> <20180719132003.GA30981@sandybridge-desktop>
         <20180720102532.GA20284@amd> <1532346156.3057.11.camel@suse.com>
         <20180723122227.GA30092@amd>
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
In-Reply-To: <20180723122227.GA30092@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mo, 2018-07-23 at 14:22 +0200, Pavel Machek wrote:

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

Hi,

very well, maybe we should state clearly that the goal of these
patch set is to make Secure Boot and STD coexist. Anything else
is a nice side effect, but not the primary justification, right?

And we further agree that the model of Secure Boot requires the
encryption to be done in kernel space, don't we?
Furthermore IMHO the key must also be generated in trusted code,
hence in kernel space. Yu Chen, I really cannot see how
a symmetrical encryption with a known key can be secure.

	Regards
		Oliver
