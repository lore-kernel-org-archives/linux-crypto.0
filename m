From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: crypto: marvell/CESA: Issues with non cache-line aligned buffers
Date: Fri, 3 Jul 2015 11:43:05 +0200
Message-ID: <20150703114305.15611807@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Will Deacon <will.deacon@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:59716 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753858AbbGCJnJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Jul 2015 05:43:09 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello, 

We've been facing a bug with the new CESA driver on armada 370 for a
couple of days.

Arnaud found out that this bug appeared when we fixed the
req->src == req->dst case (by passing DMA_BIDIRECTIONAL when mapping the
sg list instead of mapping the same sg list twice, once with the
TO_DEVICE option and the second time with the FROM_DEVICE option).

After further investigations, we found out that invalidating the cache
(in addition to the clean operation already done when mapping the
region for DMA with the BIDIR option) was somehow fixing the problem.

Which led us to think that this could be related to a non cache-line
aligned buffer problem: if we share the cache line with someone
modifying its data during the DMA transfer, we could experience data
loss when the cpu decide to flush the data from this cache line to the
memory.
Russel, Will, could you confirm this is an issue that could happen ?

To validate this assumption we decided to test the alignment of the
src and dst sg list entries passed by the crypto framework, and most of
them are indeed not aligned on ARCH_DMA_MINALIGN. We made a dirty hack
to copy the content of non aligned sg lists into a new ones containing a
single aligned buffer (allocated with kmalloc) and it seems to solve
the problem.

We also noticed that the cra_alignmask fields were all set to 0 in the
CESA driver, but modifying them (setting them to ARCH_DMA_MINALIGN - 1)
does not seem to guarantee any alignment.
ITOH, the xxx_walk_xxx API seem to check these misalignment issues and
allocate new buffers to prevent such cases, but AFAICT, this is not
automatically done by the crypto framework, and it's the
responsibility of each driver to ensure the correct alignment.
Herbert, could you confirm that ?

Do you see anything else we should check ?

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
