From: Dave Watson <davejwatson@fb.com>
Subject: Re: [RFC crypto v3 8/9] chtls: Register the ULP
Date: Tue, 30 Jan 2018 09:11:44 -0800
Message-ID: <20180130171144.GA42146@davejwatson-mba>
References: <20180125210850.GA69117@davejwatson-mba>
 <CY4PR1201MB0230C0D2D0F24900A084574D97E60@CY4PR1201MB0230.namprd12.prod.outlook.com>
 <CY4PR1201MB0230042A4D0EA83DC8F1BE7397E40@CY4PR1201MB0230.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "sd@queasysnail.net" <sd@queasysnail.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "ganeshgr@chelsio.co" <ganeshgr@chelsio.co>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Boris Pismenny <borisp@mellanox.com>,
        Ilya Lesokhin <ilyal@mellanox.com>
To: Atul Gupta <atul.gupta@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CY4PR1201MB0230042A4D0EA83DC8F1BE7397E40@CY4PR1201MB0230.namprd12.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 01/30/18 06:51 AM, Atul Gupta wrote:

> What I was referring is that passing "tls" ulp type in setsockopt
> may be insufficient to make the decision when multi HW assist Inline
> TLS solution exists.

Setting the ULP doesn't choose HW or SW implementation, I think that
should be done later when setting up crypto with 

setsockopt(SOL_TLS, TLS_TX, struct crypto_info).

Any reason we can't use ethtool to choose HW vs SW implementation, if
available on the device?

> Some HW may go beyond defining sendmsg/sendpage of the prot and
> require additional info to setup the env? Also, we need to keep
> vendor specific code out of tls_main.c i.e anything other than
> base/sw_tx prot perhaps go to hw driver.

Sure, but I think we can add hooks to tls_main to do this without a
new ULP.
