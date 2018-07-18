From: Yu Chen <yu.c.chen@intel.com>
Subject: Re: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation
 encryption
Date: Thu, 19 Jul 2018 07:58:51 +0800
Message-ID: <20180718235851.GA22170@sandybridge-desktop>
References: <cover.1531924968.git.yu.c.chen@intel.com>
 <20180718202235.GA4132@amd>
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
In-Reply-To: <20180718202235.GA4132@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,
On Wed, Jul 18, 2018 at 10:22:35PM +0200, Pavel Machek wrote:
> On Thu 2018-07-19 00:38:06, Chen Yu wrote:
> > As security becomes more and more important, we add the in-kernel
> > encryption support for hibernation.
> 
> Sorry, this does not really explain what security benefit it is
> supposed have to against what attack scenarios.
> 
> Which unfortunately means it can not reviewed.
> 
> Note that uswsusp already provides encryption. If this is supposed to
> have advantages over it, please say so.
> 
The advantages are described in detail in 
[PATCH 1/4]'s log, please refer to that.
Thanks,
Yu
> 								Pavel
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
