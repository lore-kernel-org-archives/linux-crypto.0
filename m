Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49514ACC95
	for <linux-crypto@vger.kernel.org>; Mon, 12 Oct 2026 16:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791822391; cv=none; b=sClFxqtCO4YbP9BNPusQAz3eKvMXGdjI2sKkymyYJ5+Be4BKCSStrUZeOAR6uF+dmu9V8g2BHvCFvnk8Bo3eKVNCkQ4vU2Mjn7iMskc+97NHN/tBG8eHAbQ7SSZv9qU1iRDr4vhTzJFPC3qxRJ3trzKsrH6WC5kkG298GTx56GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791822391; c=relaxed/simple;
	bh=DJl1h1zX1CaTeRF2kmfSSDgZTrjxgcg6/cl3EJ7w9Lc=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FqbCB4J3aBx9CEIQ7ek8uHEvbLQwJisG0GOdLr9pJ75/XY1VcZoj++zRVaxSBYwrDVdGkC6UpbajduVSOT22fV5HPaD6ZM6yZcgSS7ketSHD64TPZug3qz3GIf73SZxrSYJLnyTJ0LIvY03zn2jGDIvAQLAoDZXF9DGz1K0YLiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H/y6NOSp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H/y6NOSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C431F008A4
	for <linux-crypto@vger.kernel.org>; Mon, 12 Oct 2026 16:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791822389;
	bh=A5yMycJwawPg0C3KC+oeROk1OVlGqbmOeMxx37gHkgo=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=H/y6NOSpa1dM7CEj5vQvvFBcP9cuGERYPsfPAlkJtFRd0ATEj36G6bXIK0Pl+VtDc
	 pPds8LGurpWdqo0KQAO2bBn2BPYtpcDVHyhWNOhZjJYeNWTcTfOpZYzE60m1AiP92Z
	 rcug3S2fT44XKbSZhWbM4RXyjC9l7rnpe9tH0xTKMKCZDe1bz1jqS2aiDJkPQjRSuB
	 WXnWGY4ZrazMfrnRmr2c3BpsOotfrHfqivHHx7Gl9+83nK2I5/QjLC5/mTXq1G7sne
	 ysUWStjhwxoqN15ElgaqBzyE2FRh6VVkhTuDbXQshlId2BvAAdOLSCUgCRS7uYAfY0
	 DwKXJZwd5lNRg==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-3a65ed9c7cfso15327581fa.3
        for <linux-crypto@vger.kernel.org>; Mon, 12 Oct 2026 09:26:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzpK4mg+0y83J10GCyhKWXJC6Tdeoxn5jSn2BKDOkbXsBShmdwSq4n4r0He+0bTDfW53WtZT55OEXPhrEQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYJxbo5XErRv09qd3nXIOE5k1Ih9oPJKi88BKf3cfembodl+Yw8r
	IfYF//KGUQEOr0ZsB3AxaHV4JU3EPbuAtdqiuI+c3H3JED+eXwll9cYooRnz7m/gYXqIhpTYWF/
	CrIraF+XVBkgJlXiuMeBXjNnfxUSx0eXwTX1mp0Ph+Q==
X-Received: by 2002:a05:651c:211b:b0:39c:624d:82b9 with SMTP id
 38308e7fff4ca-3a9c51556e2mr26412571fa.4.1791822388127; Mon, 12 Oct 2026
 09:26:28 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 12 Oct 2026 12:26:26 -0400
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 12 Oct 2026 12:26:26 -0400
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <asdVyUKWndnZ1Mxv@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com>
 <ar9qNirrzOTDLipN@gondor.apana.org.au> <CAMRc=MdRBu5gg7Q3pz8Wn9Da4RpmmiKLP2-LwiszKCd3o8jQdQ@mail.gmail.com>
 <asdVyUKWndnZ1Mxv@gondor.apana.org.au>
Date: Mon, 12 Oct 2026 12:26:26 -0400
X-Gmail-Original-Message-ID: <CAMRc=McxneS=y9eof9cO7CY2Z0GW6swk8JZKiCvY7wQxLyxdeA@mail.gmail.com>
X-Gm-Features: AclHuK90qLjVg-NEmXjcMIVyxP5clymZXcyYKBdYqwoXDXyduVU9WFnN6XNIWLU
Message-ID: <CAMRc=McxneS=y9eof9cO7CY2Z0GW6swk8JZKiCvY7wQxLyxdeA@mail.gmail.com>
Subject: Re: [PATCH v9 00/14] crypto: qce - Fix crypto self-test failures
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thara Gopinath <thara.gopinath@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Stanimir Varbanov <svarbanov@mm-sol.com>, Eneas U de Queiroz <cotequeiroz@gmail.com>, 
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, Eric Biggers <ebiggers@kernel.org>, 
	Demi Marie Obenour <demiobenour@gmail.com>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Russell King <linux@armlinux.org.uk>, 
	Abel Vesa <abelvesa@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	Bartosz Golaszewski <brgl@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 8 Oct 2026 10:35:21 +0200, Herbert Xu
<herbert@gondor.apana.org.au> said:
> On Fri, Oct 02, 2026 at 10:31:41PM +0300, Bartosz Golaszewski wrote:
>>
>> > Please check the Sashiko comments:
>> >
>> > https://sashiko.dev/#/patchset/20260922-qce-fix-self-tests-v9-0-b1aa742e79af%40oss.qualcomm.com
>> >
>>
>> I've gone through them. None of the issues were introduced by this series, all
>> are pre-existing. I've added them to my list and will fix them. Can we not
>> delay this series any longer and instead work in smaller steps since the crypto
>> algos will be disabled by default anyway?
>
> The very first comment appears to be pointing to new code:
>
>> > +/*
>> > + * BAM DMA cannot handle zero-length transfers, so the driver always holds
>> > + * back at least one byte to submit to the engine. A zero rctx->buflen at
>> > + * finalization time does not necessarily mean the message is empty: the
>> > + * caller may have imported a state that already reflects some hashed data
>> > + * with nothing currently buffered. Handle both cases through the software
>> > + * fallback: reconstruct the running state when there is one instead of
>> > + * assuming the message is empty.
>> > + */
>> > +static int qce_ahash_finalize_zero(struct ahash_request *req)
>> > +{
>> > +	struct qce_sha_reqctx *rctx = ahash_request_ctx_dma(req);
>> > +	HASH_FBREQ_ON_STACK(fbreq, req);
>> > +	struct __sha256_ctx core;
>> > +	struct scatterlist sg;
>> > +	int ret;
>> > +
>> > +	sg_init_one(&sg, NULL, 0);
>> Can this trigger a kernel panic during zero-length finalization?
>> qce_ahash_finalize_zero() creates a dummy scatterlist by calling
>> sg_init_one(&sg, NULL, 0).
>> sg_init_one() unconditionally calls sg_set_buf(), which attempts to resolve
>> the page via virt_to_page(NULL).
>> If CONFIG_DEBUG_SG is enabled, this triggers a BUG_ON(!virt_addr_valid(buf))
>> kernel panic, because 0 is not a valid linear map address.
>> If disabled, it results in a bogus PFN being stored in the scatterlist,
>> leading to potential invalid memory access during software fallback operations.
>> This path appears reachable by untrusted userspace via AF_ALG performing a
>> zero-length HMAC finalization.
>
> How is this a pre-existing issue?
>

Sorry, this and a couple others were introduced here, v10 coming up.

Bart
