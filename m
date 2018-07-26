From: Oliver Neukum <oneukum@suse.com>
Subject: Re: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation
 encryption
Date: Thu, 26 Jul 2018 09:30:46 +0200
Message-ID: <1532590246.7411.3.camel@suse.com>
References: <cover.1531924968.git.yu.c.chen@intel.com>
         <20180718202235.GA4132@amd> <20180718235851.GA22170@sandybridge-desktop>
         <20180719110149.GA4679@amd> <20180719132003.GA30981@sandybridge-desktop>
         <20180720102532.GA20284@amd> <1532346156.3057.11.camel@suse.com>
         <20180723162302.GA4503@sandybridge-desktop>
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
In-Reply-To: <20180723162302.GA4503@sandybridge-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Di, 2018-07-24 at 00:23 +0800, Yu Chen wrote:
> 
> Good point, we once tried to generate key in kernel, but people
> suggest to generate key in userspace and provide it to the
> kernel, which is what ecryptfs do currently, so it seems this
> should also be safe for encryption in kernel.
> https://www.spinics.net/lists/linux-crypto/msg33145.html
> Thus Chun-Yi's signature can use EFI key and both the key from
> user space.

Hi,

ecryptfs can trust user space. It is supposed to keep data
safe while the system is inoperative. The whole point of Secure
Boot is a cryptographic system of trust that does not include
user space.

I seriously doubt we want to use trusted computing here. So the
key needs to be generated in kernel space and stored in a safe
manner. As we have a saolution doing that, can we come to ausable
synthesis?

	Regards
		Oliver
