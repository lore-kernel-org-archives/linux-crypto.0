From: David Miller <davem@davemloft.net>
Subject: Re: [BUGFIX] Fix AES-NI CTR optimization compiling failure with
 gas 2.16.1
Date: Fri, 12 Mar 2010 00:50:51 -0800 (PST)
Message-ID: <20100312.005051.09912332.davem@davemloft.net>
References: <4B99FD4D.4090206@redhat.com>
	<20100312.004202.27822414.davem@davemloft.net>
	<4B99FF0A.1030700@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: ying.huang@intel.com, akpm@linux-foundation.org,
	herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: avi@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33278
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756678Ab0CLIub (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Mar 2010 03:50:31 -0500
In-Reply-To: <4B99FF0A.1030700@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Avi Kivity <avi@redhat.com>
Date: Fri, 12 Mar 2010 10:44:58 +0200

> Strange, that people can install a new kernel, but not a new
> assembler.

Someone shouldn't have to upgrade their tools to build the
kernel.

And we work very hard to make sure this is the case except
in the most unavoidable situations.
