From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/4] crypto: bcm: Constify *hash_alg_name[]
Date: Fri, 9 Mar 2018 23:04:11 +0800
Message-ID: <20180309150411.GA13375@gondor.apana.org.au>
References: <1519768888-19866-1-git-send-email-hernan@vanguardiasur.com.ar>
 <1519768888-19866-3-git-send-email-hernan@vanguardiasur.com.ar>
 <20180309142954.GA12852@gondor.apana.org.au>
 <1520606135.26370.9.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?iso-8859-1?Q?Hern=E1n?= Gonzalez <hernan@vanguardiasur.com.ar>,
        davem@davemloft.net, steven.lin1@broadcom.com,
        arvind.yadav.cs@gmail.com, colin.king@canonical.com,
        raveendra.padasalagi@broadcom.com, ray.jui@broadcom.com,
        scott.branden@broadcom.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1520606135.26370.9.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 09, 2018 at 06:35:35AM -0800, Joe Perches wrote:
>
> and likely, as this is a global name, it should
> be something like crypto_hash_alg_name

crypto_ is not a good prefix here.  Perhaps crypto_bcm_.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
