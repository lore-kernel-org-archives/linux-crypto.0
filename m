Return-Path: <SRS0=rMEF=NS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40080 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbeKHEaY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Nov 2018 23:30:24 -0500
Received: by mail-wr1-f67.google.com with SMTP id i17-v6so18562864wre.7
        for <linux-crypto@vger.kernel.org>; Wed, 07 Nov 2018 10:58:44 -0800 (PST)
Date: Wed, 7 Nov 2018 19:58:40 +0100
From: LABBE Corentin <clabbe@baylibre.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] crypto: crypto_user_stat: convert all stats from u32
 to u64
Message-ID: <20181107185840.GC5133@Red>
References: <1541422274-40060-1-git-send-email-clabbe@baylibre.com>
 <1541422274-40060-3-git-send-email-clabbe@baylibre.com>
 <20181106014242.GD28490@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106014242.GD28490@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 05, 2018 at 05:42:42PM -0800, Eric Biggers wrote:
> Hi Corentin,
> 
> On Mon, Nov 05, 2018 at 12:51:11PM +0000, Corentin Labbe wrote:
> > All the 32-bit fields need to be 64-bit.  In some cases, UINT32_MAX crypto
> > operations can be done in seconds.
> > 
> > Reported-by: Eric Biggers <ebiggers@kernel.org>
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> >  crypto/algapi.c                 |  10 +--
> >  crypto/crypto_user_stat.c       | 114 +++++++++++++++-----------------
> >  include/crypto/acompress.h      |   8 +--
> >  include/crypto/aead.h           |   8 +--
> >  include/crypto/akcipher.h       |  16 ++---
> >  include/crypto/hash.h           |   6 +-
> >  include/crypto/kpp.h            |  12 ++--
> >  include/crypto/rng.h            |   8 +--
> >  include/crypto/skcipher.h       |   8 +--
> >  include/linux/crypto.h          |  46 ++++++-------
> >  include/uapi/linux/cryptouser.h |  38 +++++------
> >  11 files changed, 133 insertions(+), 141 deletions(-)
> > 
> > diff --git a/crypto/algapi.c b/crypto/algapi.c
> > index f5396c88e8cd..42fe316f80ee 100644
> > --- a/crypto/algapi.c
> > +++ b/crypto/algapi.c
> > @@ -259,13 +259,13 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
> >  	list_add(&larval->alg.cra_list, &crypto_alg_list);
> >  
> >  #ifdef CONFIG_CRYPTO_STATS
> > -	atomic_set(&alg->encrypt_cnt, 0);
> > -	atomic_set(&alg->decrypt_cnt, 0);
> > +	atomic64_set(&alg->encrypt_cnt, 0);
> > +	atomic64_set(&alg->decrypt_cnt, 0);
> >  	atomic64_set(&alg->encrypt_tlen, 0);
> >  	atomic64_set(&alg->decrypt_tlen, 0);
> > -	atomic_set(&alg->verify_cnt, 0);
> > -	atomic_set(&alg->cipher_err_cnt, 0);
> > -	atomic_set(&alg->sign_cnt, 0);
> > +	atomic64_set(&alg->verify_cnt, 0);
> > +	atomic64_set(&alg->cipher_err_cnt, 0);
> > +	atomic64_set(&alg->sign_cnt, 0);
> >  #endif
> >  
> >  out:
> > diff --git a/crypto/crypto_user_stat.c b/crypto/crypto_user_stat.c
> > index a6fb2e6f618d..352569f378a0 100644
> > --- a/crypto/crypto_user_stat.c
> > +++ b/crypto/crypto_user_stat.c
> > @@ -35,22 +35,21 @@ static int crypto_report_aead(struct sk_buff *skb, struct crypto_alg *alg)
> >  {
> >  	struct crypto_stat raead;
> >  	u64 v64;
> > -	u32 v32;
> >  
> >  	memset(&raead, 0, sizeof(raead));
> >  
> >  	strscpy(raead.type, "aead", sizeof(raead.type));
> >  
> > -	v32 = atomic_read(&alg->encrypt_cnt);
> > -	raead.stat_encrypt_cnt = v32;
> > +	v64 = atomic64_read(&alg->encrypt_cnt);
> > +	raead.stat_encrypt_cnt = v64;
> >  	v64 = atomic64_read(&alg->encrypt_tlen);
> >  	raead.stat_encrypt_tlen = v64;
> > -	v32 = atomic_read(&alg->decrypt_cnt);
> > -	raead.stat_decrypt_cnt = v32;
> > +	v64 = atomic64_read(&alg->decrypt_cnt);
> > +	raead.stat_decrypt_cnt = v64;
> >  	v64 = atomic64_read(&alg->decrypt_tlen);
> >  	raead.stat_decrypt_tlen = v64;
> > -	v32 = atomic_read(&alg->aead_err_cnt);
> > -	raead.stat_aead_err_cnt = v32;
> > +	v64 = atomic64_read(&alg->aead_err_cnt);
> > +	raead.stat_aead_err_cnt = v64;
> >  
> >  	return nla_put(skb, CRYPTOCFGA_STAT_AEAD, sizeof(raead), &raead);
> >  }
> 
> Why not assign the result of atomic64_read() directly?
> I don't see the point of the 'v64' variable.
> 

Yes it will be more compact and easier to read

Thanks
