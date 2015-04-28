From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 2/5] lib: introduce crc_t10dif_update()
Date: Tue, 28 Apr 2015 19:07:30 -0400
Message-ID: <yq18udbyhql.fsf@sermon.lab.mkp.net>
References: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com>
	<1429972410-7146-3-git-send-email-akinobu.mita@gmail.com>
	<1430242716.660.70.camel@schen9-desk2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	target-devel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	Sagi Grimberg <sagig@mellanox.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43271 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031262AbbD1XHr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Apr 2015 19:07:47 -0400
In-Reply-To: <1430242716.660.70.camel@schen9-desk2.jf.intel.com> (Tim Chen's
	message of "Tue, 28 Apr 2015 10:38:36 -0700")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>>>>> "Tim" == Tim Chen <tim.c.chen@linux.intel.com> writes:

Tim> There are a lot of duplicated code between crc_t10dif_update and
Tim> crc_t10dif.  The only difference is for the update function we
Tim> import the crc value.  I will prefer that we consolidate the code
Tim> into a local inline function that crc_t10dif_update and crc_t10dif
Tim> invoke to get rid of all the duplication.

I'm OK with that approach.

-- 
Martin K. Petersen	Oracle Linux Engineering
