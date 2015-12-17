From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH v3 2/4] crypto: niagara: Use precalculated hash from
 headers
Date: Thu, 17 Dec 2015 09:48:24 +0100
Message-ID: <20151217084824.GA20217@Red>
References: <1450184423-31155-1-git-send-email-clabbe.montjoie@gmail.com>
 <1450184423-31155-3-git-send-email-clabbe.montjoie@gmail.com>
 <20151217084018.GA9166@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151217084018.GA9166@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Dec 17, 2015 at 04:40:18PM +0800, Herbert Xu wrote:
> On Tue, Dec 15, 2015 at 02:00:21PM +0100, LABBE Corentin wrote:
> > Precalculated hash for empty message are now present in hash headers.
> > This patch just use them.
> > 
> > Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> > ---
> >  drivers/crypto/Kconfig   |  2 ++
> >  drivers/crypto/n2_core.c | 33 ++++++---------------------------
> >  2 files changed, 8 insertions(+), 27 deletions(-)
> > 
> > diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> > index b9ec295..dea754b 100644
> > --- a/drivers/crypto/Kconfig
> > +++ b/drivers/crypto/Kconfig
> > @@ -194,6 +194,8 @@ config CRYPTO_DEV_NIAGARA2
> >         select CRYPTO_DES
> >         select CRYPTO_BLKCIPHER
> >         select CRYPTO_HASH
> > +       select CRYPTO_MD5
> > +       select CRYPTO_SHA1
> 
> Don't we need CRYPTO_SHA256 as well?
> 
> Thanks,

Hello

You are right, I missed it also in ccp/ux500.

Regards
