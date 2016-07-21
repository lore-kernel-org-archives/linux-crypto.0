From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] crypto: x86/glue_helper make bool
Date: Thu, 21 Jul 2016 19:13:44 -0400
Message-ID: <20160721231344.GJ21225@windriver.com>
References: <1469139180-26863-1-git-send-email-mcgrof@kernel.org>
 <20160721230111.GI21225@windriver.com>
 <20160721230607.GA5537@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <lkp@01.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:37642 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbcGUXNt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Jul 2016 19:13:49 -0400
Content-Disposition: inline
In-Reply-To: <20160721230607.GA5537@wotan.suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[Re: [PATCH] crypto: x86/glue_helper make bool] On 22/07/2016 (Fri 01:06) Luis R. Rodriguez wrote:

> On Thu, Jul 21, 2016 at 07:01:11PM -0400, Paul Gortmaker wrote:
> > [[PATCH] crypto: x86/glue_helper make bool] On 21/07/2016 (Thu 15:13) Luis R. Rodriguez wrote:
> > 
> > > Paul's changes to remove MODULE_LICENSE() out of the x86 glue_helper
> > > causes a kernel with CONFIG_CRYPTO_GLUE_HELPER_X86=m to taint since
> > > it now detects the license is missing if you try to build the driver
> > > as a module, log below.
> > 
> > Reported and fixed two days ago ; the fix went out in yesterday's
> > linux-next via the tip tree.
> > 
> > https://lkml.kernel.org/r/20160719144243.GK21225@windriver.com
> > 
> > I fixed it by restoring the license, since making it bool might break
> > existing use cases,
> 
> How so?

In the now deleted text, you wrote:

      Fix this by removing the module option for it via Kconfig as it
      cannot be a module.

      glue_helper: module license 'unspecified' taints kernel.

The 2nd line of output clearly contradicts your 1st line stating it
cannot be a module.   It clearly was a module, and loaded, and tainted
the kernel because it had no license.

As for use cases, there can be many that could break. Someone with a
kernel that just fit in flash, now ends up with glue_helper builtin, and
their kernel won't fit anymore.

Or someone has a script that manually ran "modprobe glue_helper" at
startup along with other specifically chosen modules.  Now that step
will fail.

As I said, I don't want to be introducing runtime changes in an audit
for unnecessary module.h instances.

Paul.
--
> 
>   Luis
