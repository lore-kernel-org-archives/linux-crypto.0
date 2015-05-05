From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v4 3/4] lib: introduce crc_t10dif_update()
Date: Tue, 05 May 2015 09:12:57 -0700
Message-ID: <1430842377.660.110.camel@schen9-desk2.jf.intel.com>
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
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAC5umyg5iAXruJkvCOQui84TdueLCik72+Wi3caXpmHUQghvyw@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 2015-05-05 at 13:22 +0900, Akinobu Mita wrote:

> >
> > +
> > +__u16 crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len)
> > +{
> > +       return __crc_t10dif_update(crc, buffer, len, true);
> > +}
> > +EXPORT_SYMBOL(crc_t10dif_update);
> > +
> > +__u16 crc_t10dif(const unsigned char *buffer, size_t len)
> > +{
> > +       return __crc_t10dif_update(0, buffer, len, false);
> > +}
> >  EXPORT_SYMBOL(crc_t10dif);
> 
> You mean that we should avoid crypto_shash_import() function call
> in crc_t10dif(), right?
> 

I think it is okay for crypto_shash_import().
 
Just that we can eliminate an extra call from crc_t10dif
to crc_t10_dif as in your proposed patch, 

> +EXPORT_SYMBOL(crc_t10dif_update);
> +
> +__u16 crc_t10dif(const unsigned char *buffer, size_t len)
> + {
> +     return crc_t10dif_update(0, buffer, len);
> 

but use a local inlined __crc_t10dif_update.

Tim
