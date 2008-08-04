From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API.
Date: Mon, 04 Aug 2008 11:45:26 +0100
Message-ID: <1217846726.3454.589.camel@pmac.infradead.org>
References: <1217842507.20845.18.camel@localhost.localdomain>
	 <1217844725.3454.580.camel@pmac.infradead.org>
	 <1217846139.20845.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Austin Zhang <austin_zhang@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39574 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbYHDKpd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 06:45:33 -0400
In-Reply-To: <1217846139.20845.25.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2008-08-04 at 06:35 -0400, Austin Zhang wrote:
> On Mon, 2008-08-04 at 11:12 +0100, David Woodhouse wrote:
> > You could perhaps just use 'unsigned long' here, to avoid the ifdef.
> Thanks. 
> > And it would be nice if we could make libcrc32c use this too, rather
> > than just the 'crypto' users.
> From previous discussing, herbert would like to transfer the libcrc32c 
> interface by new crypto because there were few user using the current 
> libcrc32c interface. 

Are we deprecating libcrc32c, then? Or just turning it into a wrapper
around the crypto code?

Either way, does it really make sense to force all crc32 users to pull
in the whole crypto framework? Some may get fractious about that...

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



