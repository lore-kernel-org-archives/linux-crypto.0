From: David Miller <davem@davemloft.net>
Subject: Re: [BUGFIX] Fix AES-NI CTR optimization compiling failure with
 gas 2.16.1
Date: Fri, 12 Mar 2010 00:42:02 -0800 (PST)
Message-ID: <20100312.004202.27822414.davem@davemloft.net>
References: <1268377307.1640.491.camel@yhuang-dev.sh.intel.com>
	<4B99FD4D.4090206@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: ying.huang@intel.com, akpm@linux-foundation.org,
	herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: avi@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42201
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756568Ab0CLIll (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Mar 2010 03:41:41 -0500
In-Reply-To: <4B99FD4D.4090206@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Avi Kivity <avi@redhat.com>
Date: Fri, 12 Mar 2010 10:37:33 +0200

> Eventually you'll port the entire assembler into macros, as
> instructions are introduced more frequently that people upgrade their
> assemblers.  Maybe we should disable the new features and warn people
> (and distros) to upgrade their tools instead.

I totally and completely disagree.

It would have taken more than a year to get Niagara cpu support out to
people if I had done what you are suggesting.

And here we're talking about one instruction in one specialized case
in a very piece of crypto module assembler.
