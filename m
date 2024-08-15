Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE47F1494C5
	for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 06:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723701998; cv=none; b=GX/ynFEaUbWTMx/8S4c1tJLg6BSUH3X1EEsuBlF9hOm5FC9IVxmML105px+STWlntjVCb9MOkehs0Mmk05rPlIOacUWcLlsmd5e2bHisVD7K5A7t6tNhf/iU2jVCdatNpbz8gR3WeR+7eI/TeSXV8bffPFt228yhNRsjlE4Jazg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723701998; c=relaxed/simple;
	bh=RTKFyUQwFegcl6/BCpT1I1Hpp+067gYSf0aQnth8sws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KOBdQluF/EO7MxNINeut7BO/4u3DJqx7iw5rq9jRtydFoxpPCYiBXyD1Ok5fmCdrww65hlkScvdfsXaSz3dxocs8pQgOEjZ4xJ6QtPb3L2eoiKPMO8mBhfI7m/bNm3CbwsLdHyrrQD3UhsbIHxTNnRQZAPEBnWnqa7grlUJQDzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FifjV0zb; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FifjV0zb"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-428141be2ddso3160555e9.2
        for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2024 23:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723701995; x=1724306795; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vKHsZwayYZRozYYImc1aOP2l35ByAvjEwf7kB5Gtv7o=;
        b=FifjV0zbBIKnOsKtmyn20pUVgRHkagMgHFfItP7N5PgOAjetjOKVL+DGZnmO69LmDM
         fMFQX8GL/MSCkO1yQ8kygsRqCG1FepXUGBqPqkyAvaQP/dNcplaDjNFkBCl8feLtSB8S
         zS3lp0O4gUsSKxdIZqhO4CyjZuiblbCskD2KQkThai2ouP1JJ3lZw/qTM5a/xZbRLD8+
         q2eU7w/b1+hsR5kJIZznejZl5tNtcg4CGlqxWiCJ48QVEEGmltYn5MwdVvgk44AjNkjk
         Fbpy7Toj07uNfJ5FqB1PGop6nucOSMOcOOXijUsl6+AEBWyEMnN0TW9J4CfTLFwUpxgd
         rUyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723701995; x=1724306795;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vKHsZwayYZRozYYImc1aOP2l35ByAvjEwf7kB5Gtv7o=;
        b=MogQw1z77Gb5LQWXzovrq2ZQQnwrJdFit8W92wzA3pp7lIeRgT/blEPlVU7cO9j96+
         R7xNhP+M7jSQ/oJOWU87JfkGdpkqAK1I5ih+LlHYppI7CeJaoLtsb0BqQ2aARiF5ureG
         iMe01qdI7OrLBkzuazUbMUtDnU+1CPoIGRjwToSYqd3xTIEiRHbGZPyjUBqMRCMnFpQd
         CWzMTZIib1DsQvqcoh/lGolZ+1lZWck/53kGrxN0ekW8ptLxxIpl0L5OSjzmk3SRHxEc
         puA2YllAMN078/FGm/50+sROgStx/Bz68yMjRESjOPpX16d2qqSymTtlzt+hEgUP5cdR
         7bsg==
X-Forwarded-Encrypted: i=1; AJvYcCVuqtkchARD2gU5JAiH09XOxEfzV5pmsdEllVRBvs+atG43YgqjVDU+iVpqiklgleX17iQBZYBo1SNtUfjdJycGRpBhKVbDVok7pkBY
X-Gm-Message-State: AOJu0YxzlPWVAVxGSaJtiMWGRhWDsKX/wq/wyRLKFfL7L06kH5+ItLSr
	o52RKNXvpMIBBiBtNTn+tnoGJrA05o3/+iiJDDb4guqrId+t0zfcx2i/jvbyH+Q=
X-Google-Smtp-Source: AGHT+IEj5CSZVQvqAuV9q7l+qL6pMl2qGp+aTtrg8qAVmZYvKtkYF1+Abg9van5Xoqmj8i7e1uHT1Q==
X-Received: by 2002:a05:600c:1391:b0:428:10ec:e5ca with SMTP id 5b1f17b1804b1-429dd237540mr26322595e9.14.1723701994976;
        Wed, 14 Aug 2024 23:06:34 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ded80241sm38399875e9.48.2024.08.14.23.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 23:06:34 -0700 (PDT)
Date: Thu, 15 Aug 2024 09:06:30 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com, shwetar <shwetar@vayavyalabs.com>
Subject: Re: [PATCH v7 4/6] Add SPAcc aead support
Message-ID: <6557f8f8-42d9-4824-af0d-1d327c5972be@stanley.mountain>
References: <20240729041350.380633-1-pavitrakumarm@vayavyalabs.com>
 <20240729041350.380633-5-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240729041350.380633-5-pavitrakumarm@vayavyalabs.com>

On Mon, Jul 29, 2024 at 09:43:48AM +0530, Pavitrakumar M wrote:
> +static int spacc_aead_setkey(struct crypto_aead *tfm, const u8 *key,
> +			     unsigned int keylen)
> +{
> +	struct spacc_crypto_ctx *ctx  = crypto_aead_ctx(tfm);
> +	const struct spacc_alg  *salg = spacc_tfm_aead(&tfm->base);
> +	struct spacc_priv	*priv;
> +	struct rtattr *rta = (void *)key;
> +	struct crypto_authenc_key_param *param;
> +	unsigned int authkeylen, enckeylen;
> +	const unsigned char *authkey, *enckey;
> +	unsigned char xcbc[64];
> +
> +	int err = -EINVAL;
> +	int singlekey = 0;
> +
> +	/* are keylens valid? */
> +	ctx->ctx_valid = false;
> +
> +	switch (ctx->mode & 0xFF) {
> +	case CRYPTO_MODE_SM4_GCM:
> +	case CRYPTO_MODE_SM4_CCM:
> +	case CRYPTO_MODE_NULL:
> +	case CRYPTO_MODE_AES_GCM:
> +	case CRYPTO_MODE_AES_CCM:
> +	case CRYPTO_MODE_CHACHA20_POLY1305:
> +		authkey      = key;
> +		authkeylen   = 0;
> +		enckey       = key;
> +		enckeylen    = keylen;
> +		ctx->keylen  = keylen;
> +		singlekey    = 1;
> +		goto skipover;
> +	}
> +
> +	if (!RTA_OK(rta, keylen)		       ||
                    ^^^^^^^^^^^
This check validates that rta->rta_len is less than keylen.

> +	    rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM ||
> +	    RTA_PAYLOAD(rta) < sizeof(*param))
> +		return -EINVAL;
> +
> +	param	  = RTA_DATA(rta);
> +	enckeylen = be32_to_cpu(param->enckeylen);
> +	key	 += RTA_ALIGN(rta->rta_len);
> +	keylen	 -= RTA_ALIGN(rta->rta_len);

However we're subtracting RTA_ALIGN() not rta->rta_len so there is a chance that
this subtraction can make keylen negative (but it's unsigned so a large positive
value).  Both keylen and rta->rta_len would need have to not be multples of 4.
For example, if they were both set to 9.

(I'm not a domain expert so maybe here is checking for % 4 at a different level).

A high positive value of keylen would lead to memory corruption later in the
function.

regards,
dan carpenter

> +
> +	if (keylen < enckeylen)
> +		return -EINVAL;
> +
> +	authkeylen = keylen - enckeylen;
> +
> +	/* enckey is at &key[authkeylen] and
> +	 * authkey is at &key[0]
> +	 */
> +	authkey = &key[0];
> +	enckey  = &key[authkeylen];
> +
> +skipover:
> +	/* detect RFC3686/4106 and trim from enckeylen(and copy salt..) */
> +	if (ctx->mode & SPACC_MANGLE_IV_FLAG) {
> +		switch (ctx->mode & 0x7F00) {
> +		case SPACC_MANGLE_IV_RFC3686:
> +		case SPACC_MANGLE_IV_RFC4106:
> +		case SPACC_MANGLE_IV_RFC4543:
> +			memcpy(ctx->csalt, enckey + enckeylen - 4, 4);
> +			enckeylen -= 4;
> +			break;
> +		case SPACC_MANGLE_IV_RFC4309:
> +			memcpy(ctx->csalt, enckey + enckeylen - 3, 3);
> +			enckeylen -= 3;
> +			break;
> +		}
> +	}
> +
> +	if (!singlekey) {
> +		if (authkeylen > salg->mode->hashlen) {
> +			dev_warn(ctx->dev, "Auth key size of %u is not valid\n",
> +				 authkeylen);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	if (!spacc_check_keylen(salg, enckeylen)) {
> +		dev_warn(ctx->dev, "Enc key size of %u is not valid\n",
> +			 enckeylen);
> +		return -EINVAL;
> +	}
> +
> +	/* if we're already open close the handle since
> +	 * the size may have changed
> +	 */
> +	if (ctx->handle != -1) {
> +		priv = dev_get_drvdata(ctx->dev);
> +		spacc_close(&priv->spacc, ctx->handle);
> +		put_device(ctx->dev);
> +		ctx->handle = -1;
> +	}
> +
> +	/* Open a handle and
> +	 * search all devices for an open handle
> +	 */
> +	priv = NULL;
> +	priv = dev_get_drvdata(salg->dev[0]);
> +
> +	/* increase reference */
> +	ctx->dev = get_device(salg->dev[0]);
> +
> +	/* check if its a valid mode ... */
> +	if (spacc_isenabled(&priv->spacc, salg->mode->aead.ciph & 0xFF,
> +				enckeylen) &&
> +			spacc_isenabled(&priv->spacc,
> +				salg->mode->aead.hash & 0xFF, authkeylen)) {
> +		/* try to open spacc handle */
> +		ctx->handle = spacc_open(&priv->spacc,
> +				salg->mode->aead.ciph & 0xFF,
> +				salg->mode->aead.hash & 0xFF,
> +				-1, 0, spacc_aead_cb, tfm);
> +	}
> +
> +	if (ctx->handle < 0) {
> +		put_device(salg->dev[0]);
> +		pr_debug("Failed to open SPAcc context\n");
> +		return -EIO;
> +	}
> +
> +	/* setup XCBC key */
> +	if (salg->mode->aead.hash == CRYPTO_MODE_MAC_XCBC) {
> +		err = spacc_compute_xcbc_key(&priv->spacc,
> +					     salg->mode->aead.hash,
> +					     ctx->handle, authkey,
> +					     authkeylen, xcbc);
> +		if (err < 0) {
> +			dev_warn(ctx->dev, "Failed to compute XCBC key: %d\n",
> +				 err);
> +			return -EIO;
> +		}
> +		authkey    = xcbc;
> +		authkeylen = 48;
> +	}
> +
> +	/* handle zero key/zero len DEC condition for SM4/AES GCM mode */
> +	ctx->zero_key = 0;
> +	if (!key[0]) {
> +		int i, val = 0;
> +
> +		for (i = 0; i < keylen ; i++)
> +			val += key[i];
> +
> +		if (val == 0)
> +			ctx->zero_key = 1;
> +	}
> +
> +	err = spacc_write_context(&priv->spacc, ctx->handle,
> +				  SPACC_CRYPTO_OPERATION, enckey,
> +				  enckeylen, NULL, 0);
> +
> +	if (err) {
> +		dev_warn(ctx->dev,
> +			 "Could not write ciphering context: %d\n", err);
> +		return -EIO;
> +	}
> +
> +	if (!singlekey) {
> +		err = spacc_write_context(&priv->spacc, ctx->handle,
> +					  SPACC_HASH_OPERATION, authkey,
> +					  authkeylen, NULL, 0);
> +		if (err) {
> +			dev_warn(ctx->dev,
> +				 "Could not write hashing context: %d\n", err);
> +			return -EIO;
> +		}
> +	}
> +
> +	/* set expand key */
> +	spacc_set_key_exp(&priv->spacc, ctx->handle);
> +	ctx->ctx_valid = true;
> +
> +	memset(xcbc, 0, sizeof(xcbc));
> +
> +	/* copy key to ctx for fallback */
> +	memcpy(ctx->key, key, keylen);
> +
> +	return 0;
> +}

