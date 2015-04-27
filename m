From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 2/5] lib: introduce crc_t10dif_update()
Date: Mon, 27 Apr 2015 19:41:14 -0400
Message-ID: <yq1y4lduokl.fsf@sermon.lab.mkp.net>
References: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com>
	<1429972410-7146-3-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: target-devel@vger.kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	Sagi Grimberg <sagig@mellanox.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27615 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbbD0Xlj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2015 19:41:39 -0400
In-Reply-To: <1429972410-7146-3-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Sat, 25 Apr 2015 23:33:27 +0900")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> This introduces crc_t10dif_update() which enables to calculate
Akinobu> CRC for a block which straddles multiple SG elements by calling
Akinobu> multiple times.

Looks good. We need this for the initiator side too.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
