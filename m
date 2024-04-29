Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B42D86643
	for <linux-crypto@vger.kernel.org>; Mon, 29 Apr 2024 17:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714410309; cv=none; b=mVG0KSIkgA4Dl5OafFFRdei5eW5kiF6u/PcLW9FHyb0U+fXi0/gGyjsVaazK23cZBfci3jWsgygZwpkxCO4GUaRJ9auJwj1hx1QVSeiULXkoOVE0Iw7Vu9ZHK9CoWjZf4sk2CxFRjRb/PHsLYQExx/Z4SHRaw8WTsQmJFvYr8PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714410309; c=relaxed/simple;
	bh=MN4P/h1kq1Q02r/Lhf7jm0fR1hoE8r8RghANUoLDXuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AEo/JRiDsjxu5zo2xTLUAgQuTx+06OiD+UtPegdvP73o5CkVUYiGbxNDI2CWWMvvsR0qF+rn4BNVI6WEfdUieoUUINeJykQgaZU4IYXikKz/ahLxsBo7Vjm1gwpu3TWho5JytUpJIBr+HVtFwMw+057g9aI2EX4+pqyKx10M34E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=drvU758E; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="drvU758E"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7d9e70f388fso200310039f.2
        for <linux-crypto@vger.kernel.org>; Mon, 29 Apr 2024 10:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1714410306; x=1715015106; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NjIM1YsOHJSXus8VNmDaNi8MZ1j7PDi3kmS0uCHnMmg=;
        b=drvU758EbpECeq2zHD9OBmPsG9kodvQQ/Zo8huvVjKVTaiciYwoHFmriEPJlxU1aB0
         6UKB0Pof0r7fGmdG3fNTp9j7xcY2KonHy+QIQ8h8Nu9nMrnuKzbKkyeht/BQUqCuLAie
         ar0NvmSl73jVBq/CAdctJ7V0MZla8b9CDO+Hg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714410306; x=1715015106;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NjIM1YsOHJSXus8VNmDaNi8MZ1j7PDi3kmS0uCHnMmg=;
        b=P5bXUGuJ1F1DQoZ3WRL76hRLOOcsQXB9vwvqS3W0WvGGW81yj3IhDteK1FUVeAl9eq
         1L3gki3hSHZqWI6ZIRnJn8jTODkFQ7Rd/EgAg2imd/VatDYxtklBvdfU3h5n7plSVEAA
         kb/CDD9HTHA7/gTWvXGEgXcz2kNiHT7KdgVw1A0qgOxUQfFIUKdH+wzIQorh52lAsGpD
         HGUICeDwLu+ZI0s8DnIcEjA7TVIMhFvxxe0fMY9u61icorCmtj3MEgtveg8rvuas59pZ
         PkwsHNDfkAjc+M9S6S1WQzwTHa1ecSkq5pT7zux2wfABM2QBAs+4RaW4pq2z9Nq/eEYQ
         SDnw==
X-Forwarded-Encrypted: i=1; AJvYcCU1S0RDROTrNGL9vdswelRqsVjZNtGcF5A0DHblKVZJqDDjwc6StSJK1JhD3EXK+LpNnOQG7uOiJLe9IpgJDxpCgoghtlC8Q5ycJusc
X-Gm-Message-State: AOJu0Yz6rlxVI9Lu+NWluRw5Iu+v5EZK5wHzSN/lm/SjgS2iWsJDscBz
	Z9UId5ZQaIh7RdLpip8YI59T0KQzdGMWZTUY9FYlIYxKCMo0Kku5uEYB3N64oA==
X-Google-Smtp-Source: AGHT+IHFoa7yUHDaRgqu4l/JUQo/w0VQEfcK74Y0V+lFVzAsB35zJ7rZlOdiXClJHSoCrRrlV+IkTQ==
X-Received: by 2002:a5e:9246:0:b0:7de:a753:82b3 with SMTP id z6-20020a5e9246000000b007dea75382b3mr420256iop.15.1714410306525;
        Mon, 29 Apr 2024 10:05:06 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id x71-20020a63864a000000b00606dd49d3b8sm9250880pgd.57.2024.04.29.10.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 10:05:04 -0700 (PDT)
Date: Mon, 29 Apr 2024 10:05:01 -0700
From: Kees Cook <keescook@chromium.org>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Haren Myneni <haren@us.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] crypto/nx: Avoid potential
 -Wflex-array-member-not-at-end warning
Message-ID: <202404290947.4A8BF6A6@keescook>
References: <ZgHmRNcR+a4EJX94@neat>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgHmRNcR+a4EJX94@neat>

On Mon, Mar 25, 2024 at 03:01:56PM -0600, Gustavo A. R. Silva wrote:
> -Wflex-array-member-not-at-end is coming in GCC-14, and we are getting
> ready to enable it globally.
> 
> Use the `__struct_group()` helper to separate the flexible array
> from the rest of the members in flexible `struct nx842_crypto_header`,
> through tagged `struct nx842_crypto_header_hdr`, and avoid embedding
> the flexible-array member in the middle of `struct nx842_crypto_ctx`.
> 
> Also, use `container_of()` whenever we need to retrieve a pointer to
> the flexible structure.
> 
> This code was detected with the help of Coccinelle, and audited and
> modified manually.
> 
> Link: https://github.com/KSPP/linux/issues/202
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/crypto/nx/nx-842.c |  6 ++++--
>  drivers/crypto/nx/nx-842.h | 11 +++++++----
>  2 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
> index 2ab90ec10e61..82214cde2bcd 100644
> --- a/drivers/crypto/nx/nx-842.c
> +++ b/drivers/crypto/nx/nx-842.c
> @@ -251,7 +251,9 @@ int nx842_crypto_compress(struct crypto_tfm *tfm,
>  			  u8 *dst, unsigned int *dlen)
>  {
>  	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
> -	struct nx842_crypto_header *hdr = &ctx->header;
> +	struct nx842_crypto_header *hdr =
> +				container_of(&ctx->header,
> +					     struct nx842_crypto_header, hdr);
>  	struct nx842_crypto_param p;
>  	struct nx842_constraints c = *ctx->driver->constraints;
>  	unsigned int groups, hdrsize, h;
> @@ -490,7 +492,7 @@ int nx842_crypto_decompress(struct crypto_tfm *tfm,
>  	}
>  
>  	memcpy(&ctx->header, src, hdr_len);
> -	hdr = &ctx->header;
> +	hdr = container_of(&ctx->header, struct nx842_crypto_header, hdr);
>  
>  	for (n = 0; n < hdr->groups; n++) {
>  		/* ignore applies to last group */
> diff --git a/drivers/crypto/nx/nx-842.h b/drivers/crypto/nx/nx-842.h
> index 7590bfb24d79..1f42c83d2683 100644
> --- a/drivers/crypto/nx/nx-842.h
> +++ b/drivers/crypto/nx/nx-842.h
> @@ -157,9 +157,12 @@ struct nx842_crypto_header_group {
>  } __packed;
>  
>  struct nx842_crypto_header {
> -	__be16 magic;		/* NX842_CRYPTO_MAGIC */
> -	__be16 ignore;		/* decompressed end bytes to ignore */
> -	u8 groups;		/* total groups in this header */
> +	/* New members must be added within the __struct_group() macro below. */
> +	__struct_group(nx842_crypto_header_hdr, hdr, __packed,
> +		__be16 magic;		/* NX842_CRYPTO_MAGIC */
> +		__be16 ignore;		/* decompressed end bytes to ignore */
> +		u8 groups;		/* total groups in this header */
> +	);
>  	struct nx842_crypto_header_group group[];
>  } __packed;
>  
> @@ -171,7 +174,7 @@ struct nx842_crypto_ctx {
>  	u8 *wmem;
>  	u8 *sbounce, *dbounce;
>  
> -	struct nx842_crypto_header header;
> +	struct nx842_crypto_header_hdr header;
>  	struct nx842_crypto_header_group group[NX842_CRYPTO_GROUP_MAX];
>  
>  	struct nx842_driver *driver;

Hmm. I think commit 03952d980153 ("crypto: nx - make platform drivers
directly register with crypto") incorrectly added "struct nx842_driver
*driver" to the end of struct nx842_crypto_ctx. I think it should be
before "header".

Then I see:

#define NX842_CRYPTO_HEADER_SIZE(g)                             \
        (sizeof(struct nx842_crypto_header) +                   \
         sizeof(struct nx842_crypto_header_group) * (g))

This is just struct_size(), really. And nothing uses:

#define NX842_CRYPTO_HEADER_MAX_SIZE                            \
        NX842_CRYPTO_HEADER_SIZE(NX842_CRYPTO_GROUP_MAX)

And then looking for what uses struct nx842_crypto_ctx's "group" member,
I don't see anything except some sizeof()s:

drivers/crypto/nx/nx-common-powernv.c:1044:     .cra_ctxsize = sizeof(struct nx842_crypto_ctx),
drivers/crypto/nx/nx-common-pseries.c:1021:     .cra_ctxsize = sizeof(struct nx842_crypto_ctx),

This is just a maximally sized ctx (as if the group count were
NX842_CRYPTO_GROUP_MAX), which we could use struct_size for again:

     .cra_ctxsize = struct_size_t(struct nx842_crypto_ctx, header.group,
				  NX842_CRYPTO_GROUP_MAX),

So then "group" can be entirely removed from struct nx842_crypto_ctx.

The result means we can also add __counted_by:


diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index 2ab90ec10e61..144972fe2e6f 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -62,10 +62,7 @@
  */
 #define NX842_CRYPTO_MAGIC	(0xf842)
 #define NX842_CRYPTO_HEADER_SIZE(g)				\
-	(sizeof(struct nx842_crypto_header) +			\
-	 sizeof(struct nx842_crypto_header_group) * (g))
-#define NX842_CRYPTO_HEADER_MAX_SIZE				\
-	NX842_CRYPTO_HEADER_SIZE(NX842_CRYPTO_GROUP_MAX)
+	struct_size_t(nx842_crypto_header, group, g)
 
 /* bounce buffer size */
 #define BOUNCE_BUFFER_ORDER	(2)
diff --git a/drivers/crypto/nx/nx-842.h b/drivers/crypto/nx/nx-842.h
index 7590bfb24d79..70d9f99a4595 100644
--- a/drivers/crypto/nx/nx-842.h
+++ b/drivers/crypto/nx/nx-842.h
@@ -160,7 +160,7 @@ struct nx842_crypto_header {
 	__be16 magic;		/* NX842_CRYPTO_MAGIC */
 	__be16 ignore;		/* decompressed end bytes to ignore */
 	u8 groups;		/* total groups in this header */
-	struct nx842_crypto_header_group group[];
+	struct nx842_crypto_header_group group[] __counted_by(groups);
 } __packed;
 
 #define NX842_CRYPTO_GROUP_MAX	(0x20)
@@ -171,10 +171,9 @@ struct nx842_crypto_ctx {
 	u8 *wmem;
 	u8 *sbounce, *dbounce;
 
-	struct nx842_crypto_header header;
-	struct nx842_crypto_header_group group[NX842_CRYPTO_GROUP_MAX];
-
 	struct nx842_driver *driver;
+
+	struct nx842_crypto_header header;
 };
 
 int nx842_crypto_init(struct crypto_tfm *tfm, struct nx842_driver *driver);
diff --git a/drivers/crypto/nx/nx-common-powernv.c b/drivers/crypto/nx/nx-common-powernv.c
index 8c859872c183..22ab4a5885f2 100644
--- a/drivers/crypto/nx/nx-common-powernv.c
+++ b/drivers/crypto/nx/nx-common-powernv.c
@@ -1041,7 +1041,8 @@ static struct crypto_alg nx842_powernv_alg = {
 	.cra_driver_name	= "842-nx",
 	.cra_priority		= 300,
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_ctxsize		= sizeof(struct nx842_crypto_ctx),
+	.cra_ctxsize		= struct_size_t(struct nx842_crypto_ctx, header.group,
+						NX842_CRYPTO_GROUP_MAX),
 	.cra_module		= THIS_MODULE,
 	.cra_init		= nx842_powernv_crypto_init,
 	.cra_exit		= nx842_crypto_exit,
diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
index 35f2d0d8507e..fdf328eab6fc 100644
--- a/drivers/crypto/nx/nx-common-pseries.c
+++ b/drivers/crypto/nx/nx-common-pseries.c
@@ -1018,7 +1018,8 @@ static struct crypto_alg nx842_pseries_alg = {
 	.cra_driver_name	= "842-nx",
 	.cra_priority		= 300,
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_ctxsize		= sizeof(struct nx842_crypto_ctx),
+	.cra_ctxsize		= struct_size_t(struct nx842_crypto_ctx, header.group,
+						NX842_CRYPTO_GROUP_MAX),
 	.cra_module		= THIS_MODULE,
 	.cra_init		= nx842_pseries_crypto_init,
 	.cra_exit		= nx842_crypto_exit,


-- 
Kees Cook
