From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build warnings after merge of the crypto tree
Date: Fri, 10 Feb 2017 14:12:51 +1100
Message-ID: <20170210141251.03b39b40@canb.auug.org.au>
References: <20170206122837.0226fb89@canb.auug.org.au>
        <20170206090340.GA9531@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170206090340.GA9531@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On Mon, 6 Feb 2017 17:03:40 +0800 Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Feb 06, 2017 at 12:28:37PM +1100, Stephen Rothwell wrote:
> > 
> > After merging the crypto tree, today's linux-next build (x86_64
> > allmodconfig) produced these warnings:
> > 
> > warning: (CRYPTO_DEV_ATMEL_AUTHENC) selects CRYPTO_DEV_ATMEL_SHA which has unmet direct dependencies (CRYPTO && CRYPTO_HW && ARCH_AT91)
> > warning: (CRYPTO_DEV_ATMEL_AUTHENC) selects CRYPTO_DEV_ATMEL_SHA which has unmet direct dependencies (CRYPTO && CRYPTO_HW && ARCH_AT91)
> > 
> > Introduced by commit
> > 
> >   89a82ef87e01 ("crypto: atmel-authenc - add support to authenc(hmac(shaX), Y(aes)) modes")
> > 
> > In file included from include/linux/printk.h:329:0,
> >                  from include/linux/kernel.h:13,
> >                  from drivers/crypto/atmel-sha.c:17:  
> 
> This patch should fix both issues.  Thanks,

I am still getting these warnings ... I have seen no updates to the
crypot tree since Feb 2.

-- 
Cheers,
Stephen Rothwell
