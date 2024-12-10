Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194C319E966;
	Tue, 10 Dec 2024 11:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733831711; cv=none; b=ObdqGXr0W1f4Yw5yj4eHc3MIkD35/uJMl93UWkEunO20bXJlMIIcGdyn7hNI4C65YzqVbCpizYN5yivIU1bUAtRMPTz2KFV39sPrTCKAh/g08CdyWKJnp/qIAQSiPKD8NGVaN/DtCeWUThoNQKr88X4Z9i2RAi7negq/luUscqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733831711; c=relaxed/simple;
	bh=FFYRaVt398kWlY3AcePts9f2SooVUww1t10zGlceo8M=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K/CKsc0itaT5uHK0duc/ma4vLDDgCyM6mg4dtEhvgWpB5trkjz9zyUQSEQzP7ail3sxCIFTT1ojXuRXRbJeUugpxbCyClhri4XoSbTtI5QZo2ah4AIGhKcTwZaAt86C5POF5KX4pTYwdVTewl31ZuSQeNgm4XlCMa8LLLW9jx/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K2to5tnk; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K2to5tnk"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-385d7f19f20so2496251f8f.1;
        Tue, 10 Dec 2024 03:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733831708; x=1734436508; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=GxtTqQBTIL8qkdLSUdzE6PIJ9G6FWWi9p3lyqXCUMq0=;
        b=K2to5tnkPpV8JIeCEqkwkLfSeazKcfPnphGNJayvq2m2cHB0/xA1gndJm+DQVOljlW
         aDIK8qUD2aAMURuj2Jfs0PiA+T2wH15NPotA8Yn1AUZDF1YN2Xw54m93vHWEWPUvv90w
         KWyumzEbbPKjFW4mdpxUWGQQFubjmMZuGaV7YiRR75F3v7MhtoJXkx9CTWqpBBvcL9nU
         B/EWwZ1MWzemyqcWZ9TNS6rpF4m0LmXoEtm1PfxUKTHT6y/7AJ1fANfuKgCYrwgQhgGo
         9+p2DBqFOfqjfMQdW2sk0Iv0mMeOKfiCxVeSKsuvTN+cySQvf7l/nWnW0CnxHukd+OfI
         EAmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733831708; x=1734436508;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GxtTqQBTIL8qkdLSUdzE6PIJ9G6FWWi9p3lyqXCUMq0=;
        b=l8QWKFBDOGjpC0oQOiRzojIYCWlTQ5KJonl6H4QCz6CmNbXpNFmjLCrmtUb5jDAnAM
         eQapDYtaEU7499Qalbj17jO2S/eFrKsB+Pq3zccJRzPi9nUImYbgoJp9LVtA9oTuKK2E
         BTKK4R/btJZiazhNZj54Wv8uoWi/cBJVcSCbfVYbtFshjUtQ3JS/CfgKTEJiN8GeoGYd
         qS94g/XxLR5lFvbO1ieoS9OPWzSl15VrcuJZwq+MNSOKKvmR580hwRvL3sqkKx6Apa7h
         fMVqABSQcpmkG0S7fAMFayxneZXvZpjjgXLwREruP8vFC70MS66FItii9+BJz53jiT/y
         ftfA==
X-Forwarded-Encrypted: i=1; AJvYcCWPk/VOBYmso5/9M/9Z/K3ZlbIFxsZPivYpBN12wJ+LNY8N0jB5AePFpyEjI5EguG3lENeJkW5ckLeK4nlg@vger.kernel.org, AJvYcCWazWk7Fbb6fRXcepRhQnLlLkbT83vzuw28iodi0NX0F0f1fKakf8lOs23Bd1rSTHcnBTJm+VFzjXTQYt1b@vger.kernel.org, AJvYcCXdvEX8cGIEX3CKjO+sLNpILVj8INwla9PvMzHsZNyNgG9Hvz29LemhB2suyHJH1SL7PAQvuEvESIPL@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0MANT6sSNShdqwIikGWZRvnFH05VM8OGsl+/WQa/P1zmxk70W
	v9OXkFRdvB+2rcGo1URyEHTm8qSgR617uWH/F7xDqlCvnSqyg3ws
X-Gm-Gg: ASbGnctK/ch31OUMK9DnOwpVMnXyKZm1mA8f590+VHrQe6oqPV9F3VZWBUcmt1kxbhG
	8XJr+Y/BeJPg1PCZz9uGZRvY2rWrr+39V6O6NKn2mGWgyccNSwOdgHlvNeHHo2ZogcCvsF97+NS
	K5Z0lzb+338SYsjUS3uFt5aTvP101gP22dqGZurpibR8oWjX9D+0vgDbZLeA1JaqKg+jH3OokEp
	C02F3X5X6mVNpnxUJrmyejcAyMYEAMyc1HSOUPGOE2ivwi6l43l9rrYwlNbp6nkxYV6DHIe/1G5
	+NKhq4NyyQ==
X-Google-Smtp-Source: AGHT+IEqPyQZxvaTdaCGPBbnnyYvA3iFt3x9GqsjfxRLDxoVwreBtdhs6qFT0if4l4gCopK2n/CUaQ==
X-Received: by 2002:a5d:6d86:0:b0:386:378c:b7ec with SMTP id ffacd0b85a97d-386378cb923mr8329503f8f.58.1733831708190;
        Tue, 10 Dec 2024 03:55:08 -0800 (PST)
Received: from Ansuel-XPS. (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-386329a15b0sm11246137f8f.45.2024.12.10.03.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 03:55:07 -0800 (PST)
Message-ID: <67582c1b.050a0220.83ef5.c8df@mx.google.com>
X-Google-Original-Message-ID: <Z1gsFv24WRhhdqlb@Ansuel-XPS.>
Date: Tue, 10 Dec 2024 12:55:02 +0100
From: Christian Marangi <ansuelsmth@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, upstream@airoha.com,
	Richard van Schagen <vschagen@icloud.com>
Subject: Re: [PATCH v7 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
References: <20241112015920.22564-1-ansuelsmth@gmail.com>
 <20241112015920.22564-4-ansuelsmth@gmail.com>
 <Z1e0LHycNGcWqd2q@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1e0LHycNGcWqd2q@gondor.apana.org.au>

On Tue, Dec 10, 2024 at 11:23:24AM +0800, Herbert Xu wrote:
> On Tue, Nov 12, 2024 at 02:59:00AM +0100, Christian Marangi wrote:
> >
> > +static int eip93_hash_export(struct ahash_request *req, void *out)
> > +{
> > +	struct eip93_hash_reqctx *rctx = ahash_request_ctx(req);
> > +	struct eip93_hash_export_state *state = out;
> > +	DECLARE_CRYPTO_WAIT(wait);
> > +	int ret;
> > +
> > +	crypto_init_wait(&wait);
> > +	/* Set the req callback for hash_partial_final wait */
> > +	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> > +				   crypto_req_done, &wait);
> > +
> > +	/* Set for partial hash generation */
> > +	rctx->partial_hash = true;
> > +	rctx->export_state = true;
> > +	rctx->state = state;
> > +
> > +	/* Save the first block in state data */
> > +	if (rctx->left_last || rctx->len) {
> > +		struct mkt_hash_block *block;
> > +
> > +		block = list_first_entry(&rctx->blocks,
> > +					 struct mkt_hash_block,
> > +					 list);
> > +
> > +		memcpy(state->data, block->data,
> > +		       SHA256_BLOCK_SIZE - rctx->left_last);
> > +	}
> > +
> > +	/* Call hash_partial_final.
> > +	 * This will send a dummpy 0 length packet. This is done to
> > +	 * wait for every descriptor to being handled and sync the sa_state
> > +	 * from the host. Partial hash and any other data will be copied in
> > +	 * eip93_hash_handle_result()
> > +	 */
> > +	ret = crypto_wait_req(eip93_hash_partial_final(req), &wait);
> 
> Sorry, you can't do that here.  Your hash state should have been
> exported when the request previously completed.  The export function
> must not sleep.
>

Ah that unfortunate but doesn't that goes against the async idea of ahash
OPs? Anyway is busy loop acceptable here?

The main problem here is that .update only enqueue packet to be
processed and we don't wait for it to finish as that would result in
really bad performance.

To export the state with the previous request (.update) we would have to
wait for each packet to complete or we would export the wrong partial
hash.

The process is fast enough so busy loop here should not be problematic
but waiting for every packet sent to .update on being processed might
introduce big performance regression.

Thanks for checking this hope you can help me understand this.

-- 
	Ansuel
