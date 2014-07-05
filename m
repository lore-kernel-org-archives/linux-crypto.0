From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 3/4] DRBG: Fix format string for debugging statements
Date: Fri, 04 Jul 2014 17:09:33 -0700
Message-ID: <1404518973.6384.30.camel@joe-AO725>
References: <4927386.WYHrRe3NJm@myon.chronox.de>
	 <20140704112116.GC25934@mwanda> <1404493040.6384.21.camel@joe-AO725>
	 <3856718.HehN4Xqlpl@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
	linux-crypto@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0228.hostedemail.com ([216.40.44.228]:37966 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753619AbaGEAJh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Jul 2014 20:09:37 -0400
In-Reply-To: <3856718.HehN4Xqlpl@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 2014-07-05 at 01:57 +0200, Stephan Mueller wrote:
> And I also get the same output. Yet I am not sure how that code can be 
> compared to the code in the kernel.

What that code shows is that the ARRAY_SIZE
type is size_t.

The difference is ARRAY_SIZE in the kernel
should be output with %zu.
