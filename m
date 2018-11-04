Return-Path: <SRS0=8KRZ=NP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51910 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728901AbeKDS0a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Nov 2018 13:26:30 -0500
Received: by mail-wm1-f65.google.com with SMTP id w7-v6so5401342wmc.1
        for <linux-crypto@vger.kernel.org>; Sun, 04 Nov 2018 01:12:14 -0800 (PST)
Date: Sun, 4 Nov 2018 10:12:11 +0100
From: LABBE Corentin <clabbe@baylibre.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        nhorman@tuxdriver.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] crypto: Implement a generic crypto statistics
Message-ID: <20181104091211.GB6963@Red>
References: <1537351855-16618-1-git-send-email-clabbe@baylibre.com>
 <1537351855-16618-2-git-send-email-clabbe@baylibre.com>
 <20181103225234.GD808@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181103225234.GD808@sol.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Nov 03, 2018 at 03:52:35PM -0700, Eric Biggers wrote:
> On Wed, Sep 19, 2018 at 10:10:54AM +0000, Corentin Labbe wrote:
> > diff --git a/include/uapi/linux/cryptouser.h b/include/uapi/linux/cryptouser.h
> > index 19bf0ca6d635..6dafbc3e4414 100644
> > --- a/include/uapi/linux/cryptouser.h
> > +++ b/include/uapi/linux/cryptouser.h
> > @@ -29,6 +29,7 @@ enum {
> >  	CRYPTO_MSG_UPDATEALG,
> >  	CRYPTO_MSG_GETALG,
> >  	CRYPTO_MSG_DELRNG,
> > +	CRYPTO_MSG_GETSTAT,
> >  	__CRYPTO_MSG_MAX
> >  };
> >  #define CRYPTO_MSG_MAX (__CRYPTO_MSG_MAX - 1)
> > @@ -50,6 +51,16 @@ enum crypto_attr_type_t {
> >  	CRYPTOCFGA_REPORT_AKCIPHER,	/* struct crypto_report_akcipher */
> >  	CRYPTOCFGA_REPORT_KPP,		/* struct crypto_report_kpp */
> >  	CRYPTOCFGA_REPORT_ACOMP,	/* struct crypto_report_acomp */
> > +	CRYPTOCFGA_STAT_LARVAL,		/* struct crypto_stat */
> > +	CRYPTOCFGA_STAT_HASH,		/* struct crypto_stat */
> > +	CRYPTOCFGA_STAT_BLKCIPHER,	/* struct crypto_stat */
> > +	CRYPTOCFGA_STAT_AEAD,		/* struct crypto_stat */
> > +	CRYPTOCFGA_STAT_COMPRESS,	/* struct crypto_stat */
> > +	CRYPTOCFGA_STAT_RNG,		/* struct crypto_stat */
> > +	CRYPTOCFGA_STAT_CIPHER,		/* struct crypto_stat */
> > +	CRYPTOCFGA_STAT_AKCIPHER,	/* struct crypto_stat */
> > +	CRYPTOCFGA_STAT_KPP,		/* struct crypto_stat */
> > +	CRYPTOCFGA_STAT_ACOMP,		/* struct crypto_stat */
> >  	__CRYPTOCFGA_MAX
> >  
> >  #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
> > @@ -65,6 +76,47 @@ struct crypto_user_alg {
> >  	__u32 cru_flags;
> >  };
> >  
> > +struct crypto_stat {
> > +	char type[CRYPTO_MAX_NAME];
> > +	union {
> > +		__u32 stat_encrypt_cnt;
> > +		__u32 stat_compress_cnt;
> > +		__u32 stat_generate_cnt;
> > +		__u32 stat_hash_cnt;
> > +		__u32 stat_setsecret_cnt;
> > +	};
> > +	union {
> > +		__u64 stat_encrypt_tlen;
> > +		__u64 stat_compress_tlen;
> > +		__u64 stat_generate_tlen;
> > +		__u64 stat_hash_tlen;
> > +	};
> > +	union {
> > +		__u32 stat_akcipher_err_cnt;
> > +		__u32 stat_cipher_err_cnt;
> > +		__u32 stat_compress_err_cnt;
> > +		__u32 stat_aead_err_cnt;
> > +		__u32 stat_hash_err_cnt;
> > +		__u32 stat_rng_err_cnt;
> > +		__u32 stat_kpp_err_cnt;
> > +	};
> > +	union {
> > +		__u32 stat_decrypt_cnt;
> > +		__u32 stat_decompress_cnt;
> > +		__u32 stat_seed_cnt;
> > +		__u32 stat_generate_public_key_cnt;
> > +	};
> > +	union {
> > +		__u64 stat_decrypt_tlen;
> > +		__u64 stat_decompress_tlen;
> > +	};
> > +	union {
> > +		__u32 stat_verify_cnt;
> > +		__u32 stat_compute_shared_secret_cnt;
> > +	};
> > +	__u32 stat_sign_cnt;
> > +};
> > +
> 
> All the 32-bit fields need to be 64-bit.  In some cases, UINT32_MAX crypto
> operations can be done in seconds.
> 
> It's also weird that everything shares the same crypto_stat structure.  I think
> there should be a different struct for each algorithm type, like there is for
> the existing crypto_user algorithm reporting.  In fact you are kind of already
> doing that since the struct is loaded full of unions.  But it would be much
> cleaner to use actually different structures.
> 
> - Eric

Hello

I agree, separate structures will be cleaner.
I will address this in a followup patch.

Thanks
