From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/5] target: Fix several problems related to T10-PI support
Date: Mon, 27 Apr 2015 19:50:58 -0400
Message-ID: <yq1tww1uo4d.fsf@sermon.lab.mkp.net>
References: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com>
	<553CBF07.6080902@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	target-devel@vger.kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	Sagi Grimberg <sagig@mellanox.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30813 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbbD0XvT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2015 19:51:19 -0400
In-Reply-To: <553CBF07.6080902@dev.mellanox.co.il> (Sagi Grimberg's message of
	"Sun, 26 Apr 2015 13:33:43 +0300")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:

Sagi> The problem is that the HBA does not have the write_same
Sagi> functionality you introduce here, i.e. generate multiple same
Sagi> protection fields for a single data block.

Adding support to DIX would be problematic since it would essentially
turn a WRITE SAME into a WRITE. You'd only do one block of DMA but you'd
get N blocks going over the wire.

In target mode it is conceivable to set up a prot sgl after parsing the
CDB and let the HBA do the work. But I'm not aware of any hardware that
allows that.

Sagi> In this case, for WRITE_SAME, have the fabrics generate/verify a
Sagi> single data block (one integrity field) like they do today, and
Sagi> then the core will expand it to the correct number of sectors
Sagi> using some form of sbc_dif_expand_same()

Yeah. In a simple world you'd just keep overriding the ref tag in the
received PI tuple. But for performance reasons you'll obviously want to
do I/O in units bigger than a single block. Blindly preallocating PI to
fit the entire I/O is also be problematic, however, since a block count
of 0 unfortunately means "the whole disk".

-- 
Martin K. Petersen	Oracle Linux Engineering
