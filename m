From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v4 3/4] lib: introduce crc_t10dif_update()
Date: Tue, 05 May 2015 09:16:33 -0700
Message-ID: <1430842593.660.112.camel@schen9-desk2.jf.intel.com>
References: <1430461431-5936-1-git-send-email-akinobu.mita@gmail.com>
	 <1430461431-5936-4-git-send-email-akinobu.mita@gmail.com>
	 <1430496906.660.79.camel@schen9-desk2.jf.intel.com>
	 <CAC5umyi8dQgtN4qQBm6_X6MvPZo56sUs-RRKR+4Ds6Tx_67-wA@mail.gmail.com>
	 <1430755775.660.88.camel@schen9-desk2.jf.intel.com>
	 <CAC5umyg5iAXruJkvCOQui84TdueLCik72+Wi3caXpmHUQghvyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: target-devel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	Sagi Grimberg <sagig@mellanox.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21957 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbbEEQQe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 May 2015 12:16:34 -0400
In-Reply-To: <CAC5umyg5iAXruJkvCOQui84TdueLCik72+Wi3caXpmHUQghvyw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2015-05-05 at 13:22 +0900, Akinobu Mita wrote:

> The reason for crypto_shash_import() was I wanted to make
> crc_t10dif_update() more generic.  But as far as I can see existing
> crct10dif modules (crct10dif-generic and crct10dif-pclmul), we don't
> need it (i.e. '*(__u16 *)desc.ctx = crc' instead of crc_t10dif_import)
> 
> Do you think it's better to remove crc_t10dif_import call from
> crc_t10dif() and crc_t10dif_update() altogether?

Yes, it will be better if we can eliminate crc_t10dif_import call if
we can do a direct assignment.

Tim
