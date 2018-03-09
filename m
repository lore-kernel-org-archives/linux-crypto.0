From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 3/4] crypto: bcm: Constify *hash_alg_name[]
Date: Fri, 09 Mar 2018 06:35:35 -0800
Message-ID: <1520606135.26370.9.camel@perches.com>
References: <1519768888-19866-1-git-send-email-hernan@vanguardiasur.com.ar>
         <1519768888-19866-3-git-send-email-hernan@vanguardiasur.com.ar>
         <20180309142954.GA12852@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, steven.lin1@broadcom.com,
        arvind.yadav.cs@gmail.com, colin.king@canonical.com,
        raveendra.padasalagi@broadcom.com, ray.jui@broadcom.com,
        scott.branden@broadcom.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        =?ISO-8859-1?Q?Hern=E1n?= Gonzalez <hernan@vanguardiasur.com.ar>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180309142954.GA12852@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 2018-03-09 at 22:29 +0800, Herbert Xu wrote:
> On Tue, Feb 27, 2018 at 07:01:27PM -0300, Hernán Gonzalez wrote:
> > Note: This is compile only tested.
> > No gain from this except some self-documenting.
[]
> > diff --git a/drivers/crypto/bcm/spu.c b/drivers/crypto/bcm/spu.c
[]
> > @@ -23,8 +23,9 @@
> >  #include "cipher.h"
> >  
> >  /* This array is based on the hash algo type supported in spu.h */
> > -char *hash_alg_name[] = { "None", "md5", "sha1", "sha224", "sha256", "aes",
> > -	"sha384", "sha512", "sha3_224", "sha3_256", "sha3_384", "sha3_512" };
> > +char const * const hash_alg_name[] = { "None", "md5", "sha1", "sha224",
> 
> Please make that
> 
> 	const char *const
> 
> Ditto with patch 4.
> 
> Thanks,

and likely, as this is a global name, it should
be something like crypto_hash_alg_name
