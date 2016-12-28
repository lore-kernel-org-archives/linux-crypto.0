From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 0/3] Cavium ThunderX ZIP driver
Date: Wed, 28 Dec 2016 17:01:53 +0800
Message-ID: <20161228090153.GC11904@gondor.apana.org.au>
References: <20161212150439.18627-1-jglauber@cavium.com>
 <20161227090227.GC10121@gondor.apana.org.au>
 <DM5PR07MB3148D87C62159523B750CD20E5690@DM5PR07MB3148.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Glauber <Jan.Glauber@cavium.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Nair, Vishnu" <Vishnu.Nair@cavium.com>
To: "Challa, Mahipal" <Mahipal.Challa@cavium.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DM5PR07MB3148D87C62159523B750CD20E5690@DM5PR07MB3148.namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Dec 27, 2016 at 11:39:21AM +0000, Challa, Mahipal wrote:
>
> Mahipal: One major issue is, the kernel use cases to validate the Cavium ThunderX ZIP driver are "ZSWAP" and "IPComp" which are not yet supported with scomp-acomp framework. 

OK I'll look into converting IPcomp.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
