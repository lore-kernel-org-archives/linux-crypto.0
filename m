From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API.
Date: Mon, 04 Aug 2008 11:27:57 +0100
Message-ID: <1217845677.3454.582.camel@pmac.infradead.org>
References: <1217842507.20845.18.camel@localhost.localdomain>
	 <1217844725.3454.580.camel@pmac.infradead.org>
	 <20080804102557.GA21265@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Austin Zhang <austin_zhang@linux.intel.com>,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60741 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbYHDK2L (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 06:28:11 -0400
In-Reply-To: <20080804102557.GA21265@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2008-08-04 at 12:25 +0200, Sebastian Siewior wrote:
> * David Woodhouse | 2008-08-04 11:12:05 [+0100]:
> >And it would be nice if we could make libcrc32c use this too, rather
> >than just the 'crypto' users.
> 
> I'm not sure if I remeber correctly but I thing Herbert was planning to
> convert all users over to the crypto API to avoid compile time
> dependency.

That's one way of doing it, although it seems a little bit like overkill
in this particular case.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



