From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 2/5] lib: introduce crc_t10dif_update()
Date: Wed, 29 Apr 2015 08:49:12 +0800
Message-ID: <20150429004911.GA7221@gondor.apana.org.au>
References: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com>
 <1429972410-7146-3-git-send-email-akinobu.mita@gmail.com>
 <1430242716.660.70.camel@schen9-desk2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	target-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	Sagi Grimberg <sagig@mellanox.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1430242716.660.70.camel@schen9-desk2.jf.intel.com>
Sender: target-devel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Apr 28, 2015 at 10:38:36AM -0700, Tim Chen wrote:
>
> +       if (update) {
> +               err = crypto_shash_import(&desc.shash, &crc);   
> +               BUG_ON(err);

You don't even have to make this conditional.  Just always do
the import since it's just doing a memcpy anyway.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
