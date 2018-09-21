From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] Fix static checker warning
Date: Fri, 21 Sep 2018 12:52:51 +0800
Message-ID: <20180921045251.cubm22rnx2cjsoup@gondor.apana.org.au>
References: <cover.1536959537.git.Janakarajan.Natarajan@amd.com>
 <31c49295223e51f5c1c4e36e7a09fe100dab1711.1536959537.git.Janakarajan.Natarajan@amd.com>
 <8dfca0f4-6639-3444-148f-eb0b0817fec6@amd.com>
 <20180919135741.5icpyesntcfbgtcr@mwanda>
 <7aa02bf8-8813-98e5-6729-af4ae63da7d0@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
To: "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7aa02bf8-8813-98e5-6729-af4ae63da7d0@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 20, 2018 at 03:43:48PM +0000, Natarajan, Janakarajan wrote:
> On 9/19/2018 8:57 AM, Dan Carpenter wrote:
> > Sounds reasonable.  The subject needs a subsystem prefix and it might
> > be better to make it more specific.  Like so:
> >
> > [PATCH 1/2] crypto: ccp - potential uninitialized variable
> 
> I'll put out a v2 with the subjects fixed.

This is not necessary.  I'll fix it up when I apply the patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
