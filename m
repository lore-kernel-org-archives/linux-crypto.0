From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 4/5] crypto: LRNG - enable compile
Date: Thu, 11 Aug 2016 16:03:07 +0200
Message-ID: <1774915.csgCvtfnqZ@tauon.atsec.com>
References: <201608112159.fFG7Xhcw%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: kbuild-all@01.org, herbert@gondor.apana.org.au,
	Ted Tso <tytso@mit.edu>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201608112159.fFG7Xhcw%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 11. August 2016, 21:50:15 CEST schrieb kbuild test robot:

Hi,

> Hi Stephan,
> 
> [auto build test ERROR on cryptodev/master]
> [also build test ERROR on v4.8-rc1]
> [cannot apply to next-20160811]
> [if your patch is applied to the wrong git tree, please drop us a note to
> help improve the system]

Thank you for the report. This is due to the missing include of asm/irq_regs.h 
which seem to be included my the tested arches through some other means.

I will add it in an update.

Ciao
Stephan
