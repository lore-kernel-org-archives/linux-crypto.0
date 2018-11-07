Return-Path: <SRS0=rMEF=NS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38643 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbeKHE1Y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Nov 2018 23:27:24 -0500
Received: by mail-wr1-f67.google.com with SMTP id d10-v6so18561605wrs.5
        for <linux-crypto@vger.kernel.org>; Wed, 07 Nov 2018 10:55:45 -0800 (PST)
Date: Wed, 7 Nov 2018 19:55:41 +0100
From: LABBE Corentin <clabbe@baylibre.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] crypto: crypto_user_stat: made crypto_user_stat
 optional
Message-ID: <20181107185541.GB5133@Red>
References: <1541422274-40060-1-git-send-email-clabbe@baylibre.com>
 <1541422274-40060-2-git-send-email-clabbe@baylibre.com>
 <20181106014126.GC28490@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106014126.GC28490@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 05, 2018 at 05:41:27PM -0800, Eric Biggers wrote:
> Hi Corentin,
> 
> On Mon, Nov 05, 2018 at 12:51:10PM +0000, Corentin Labbe wrote:
> > Even if CRYPTO_STATS is set to n, some part of CRYPTO_STATS are
> > compiled.
> > This patch made all part of crypto_user_stat uncompiled in that case.
> > 
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> >  crypto/Makefile                      |  3 ++-
> >  crypto/algapi.c                      |  2 ++
> >  include/crypto/internal/cryptouser.h | 17 +++++++++++++++++
> >  include/linux/crypto.h               |  2 ++
> >  4 files changed, 23 insertions(+), 1 deletion(-)
> > 
> > diff --git a/crypto/Makefile b/crypto/Makefile
> > index 5c207c76abf7..1e9e5960946a 100644
> > --- a/crypto/Makefile
> > +++ b/crypto/Makefile
> > @@ -54,7 +54,8 @@ cryptomgr-y := algboss.o testmgr.o
> >  
> >  obj-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
> >  obj-$(CONFIG_CRYPTO_USER) += crypto_user.o
> > -crypto_user-y := crypto_user_base.o crypto_user_stat.o
> > +crypto_user-y := crypto_user_base.o
> > +crypto_user-$(CONFIG_CRYPTO_STATS) += crypto_user_stat.o
> >  obj-$(CONFIG_CRYPTO_CMAC) += cmac.o
> >  obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
> >  obj-$(CONFIG_CRYPTO_VMAC) += vmac.o
> 
> Doesn't CONFIG_CRYPTO_STATS also need to depend on CONFIG_CRYPTO_USER?
> Currently you can enable it but without CRYPTO_USER the API won't be available.
> 
> config CRYPTO_STATS
> 	bool "Crypto usage statistics for User-space"
> 
> should be:
> 
> config CRYPTO_STATS
> 	bool "Crypto usage statistics for User-space"
> 	depends on CRYPTO_USER
> 
> > diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> > index 3634ad6fe202..35de61d99cd5 100644
> > --- a/include/linux/crypto.h
> > +++ b/include/linux/crypto.h
> > @@ -515,6 +515,7 @@ struct crypto_alg {
> >  	
> >  	struct module *cra_module;
> >  
> > +#ifdef CONFIG_CRYPTO_STATS
> >  	union {
> >  		atomic_t encrypt_cnt;
> >  		atomic_t compress_cnt;
> > @@ -552,6 +553,7 @@ struct crypto_alg {
> >  		atomic_t compute_shared_secret_cnt;
> >  	};
> >  	atomic_t sign_cnt;
> > +#endif
> 
> This is a long ifdef, so use:
> 
> #endif /* CONFIG_CRYPTO_STATS */
> 
> - Eric

I will fix that
Thanks
