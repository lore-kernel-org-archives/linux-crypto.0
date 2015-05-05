From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 3/4] lib: introduce crc_t10dif_update()
Date: Tue, 5 May 2015 15:54:36 +0800
Message-ID: <20150505075436.GA7378@gondor.apana.org.au>
References: <1430461431-5936-1-git-send-email-akinobu.mita@gmail.com>
 <1430461431-5936-4-git-send-email-akinobu.mita@gmail.com>
 <1430496906.660.79.camel@schen9-desk2.jf.intel.com>
 <CAC5umyi8dQgtN4qQBm6_X6MvPZo56sUs-RRKR+4Ds6Tx_67-wA@mail.gmail.com>
 <1430755775.660.88.camel@schen9-desk2.jf.intel.com>
 <CAC5umyg5iAXruJkvCOQui84TdueLCik72+Wi3caXpmHUQghvyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	target-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	Sagi Grimberg <sagig@mellanox.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAC5umyg5iAXruJkvCOQui84TdueLCik72+Wi3caXpmHUQghvyw@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, May 05, 2015 at 01:22:03PM +0900, Akinobu Mita wrote:
>
> The reason for crypto_shash_import() was I wanted to make
> crc_t10dif_update() more generic.  But as far as I can see existing
> crct10dif modules (crct10dif-generic and crct10dif-pclmul), we don't
> need it (i.e. '*(__u16 *)desc.ctx = crc' instead of crc_t10dif_import)

Yes we do the same thing with crc32c so I don't see why you couldn't
do that here.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
