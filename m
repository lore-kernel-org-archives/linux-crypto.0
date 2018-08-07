From: Oliver Neukum <oneukum@suse.com>
Subject: Re: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation
 encryption
Date: Tue, 07 Aug 2018 12:04:19 +0200
Message-ID: <1533636259.7912.2.camel@suse.com>
References: <20180718202235.GA4132@amd>
         <20180718235851.GA22170@sandybridge-desktop> <20180719110149.GA4679@amd>
         <20180719132003.GA30981@sandybridge-desktop> <20180720102532.GA20284@amd>
         <1532346156.3057.11.camel@suse.com>
         <20180723162302.GA4503@sandybridge-desktop>
         <1532590246.7411.3.camel@suse.com> <20180806075754.GA12124@chenyu-desktop>
         <1533550820.15815.14.camel@suse.com>
         <20180807073840.GA17894@chenyu-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Pavel Machek <pavel@ucw.cz>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        "Lee, Chun-Yi" <jlee@suse.com>, Theodore Ts o <tytso@mit.edu>,
        Stephan Mueller <smueller@chronox.de>,
        Denis Kenzior <denkenz@gmail.com>, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gu, Kookoo" <kookoo.gu@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
To: Yu Chen <yu.c.chen@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180807073840.GA17894@chenyu-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Di, 2018-08-07 at 15:38 +0800, Yu Chen wrote:
> > As STD affects the whole machine it must require root rights.
> > So I cannot see how you can talk about a session belonging
> > to a user. Please explain.
> > 
> 
> The case is for physical access, not the 'user' in OS.

Well, yes, but Secure Boot does not guard against anybody
booting or halting the machine. It limits what you can
boot by a chain of trust.

I think you are trying to add a feature to Secure Boot.

	Regards
		Oliver
