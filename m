From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v3 2/5] lib: introduce crc_t10dif_update()
Date: Wed, 29 Apr 2015 09:07:35 -0700
Message-ID: <1430323655.660.71.camel@schen9-desk2.jf.intel.com>
References: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com>
	 <1429972410-7146-3-git-send-email-akinobu.mita@gmail.com>
	 <1430242716.660.70.camel@schen9-desk2.jf.intel.com>
	 <20150429004911.GA7221@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	target-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	Sagi Grimberg <sagig@mellanox.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150429004911.GA7221@gondor.apana.org.au>
Sender: target-devel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2015-04-29 at 08:49 +0800, Herbert Xu wrote:
> On Tue, Apr 28, 2015 at 10:38:36AM -0700, Tim Chen wrote:
> >
> > +       if (update) {
> > +               err = crypto_shash_import(&desc.shash, &crc);   
> > +               BUG_ON(err);
> 
> You don't even have to make this conditional.  Just always do
> the import since it's just doing a memcpy anyway.
> 

Cool, this will simplify things more :)

Tim
