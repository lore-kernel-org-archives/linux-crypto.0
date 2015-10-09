From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v3 0/5] crypto: fixes for Marvell hash
Date: Fri, 9 Oct 2015 21:57:25 +0200
Message-ID: <20151009215725.76a20f82@bbrezillon>
References: <20151009102904.GL32532@n2100.arm.linux.org.uk>
	<20151009104637.GA18798@n2100.arm.linux.org.uk>
	<20151009194309.GA7401@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Arnaud Ebalard <arno@natisbad.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Cooper <jason@lakedaemon.net>,
	linux-crypto@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:38065 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753771AbbJIT52 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 15:57:28 -0400
In-Reply-To: <20151009194309.GA7401@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Russel, Herbert,

On Fri, 9 Oct 2015 20:43:10 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> After all, here's a version 3, which fixes the other bug I mentioned
> below - we now have correct hash results.  A couple of patches have
> been added, one to fix that, and a second patch to factor out the
> duplication in the import functions.  This gets openssh working with
> the digests enabled.
> 
> Acks so far received have been added.  Patch 3 has changed, so I didn't
> add the ack for the previous version.  Please re-review patch 3.

Could we had the CC stable + Fixes tags to patches 1 to 4 so that they
can be applied on 4.2 too?

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
