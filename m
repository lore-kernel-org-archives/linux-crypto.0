From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API.
Date: Mon, 04 Aug 2008 12:25:58 +0100
Message-ID: <1217849158.3454.599.camel@pmac.infradead.org>
References: <1217842507.20845.18.camel@localhost.localdomain>
	 <1217844725.3454.580.camel@pmac.infradead.org>
	 <1217846139.20845.25.camel@localhost.localdomain>
	 <1217846726.3454.589.camel@pmac.infradead.org>
	 <1217847481.20845.37.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Austin Zhang <austin_zhang@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46147 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYHDMjJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 08:39:09 -0400
In-Reply-To: <1217847481.20845.37.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2008-08-04 at 06:58 -0400, Austin Zhang wrote:
> BTW, why did I always got each email on this thread twice:(? (the same
> email twice) 

You're probably subscribed to the linux-kernel list, and you're also
being Cc'd directly.

Normally, your filters should notice the copy which has a Return-Path:
matching 'linux-kernel-owner.*@vger.kernel.org', and put that into your
lkml folder with a few hundred other messages each day -- while the copy
which is direct will still have the original sender, and would go into
your inbox where you'll see it.

-- 
dwmw2

