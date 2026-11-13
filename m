Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794569298;
	b=ykuM94KOs8X/ECA3EPw2UEMBLr5i76nC+BiUVcPNgkcol4gQOJkC6fI7rmrehgHUnOEk
	 nwW1MjCxzd61x0PHBsZ6Gc32C7qTPM3DDH/83D+hP3P+w9VQg7YbPs7CThDmAsQPa6uZi
	 86WKzyIaCph59tUz5Llf54ehIkiaiphc2OgvxneBR8R2iU/ZhEnpNfTJzsTTS3Y/4I9+N
	 dOWNCbBEvX52zpdgGpDcOfXpsj+N4609rzzHBkszP7LmnhwHdDm89D7hMCH6/ZZlh64Xd
	 wjr852zSax+ajynnmimBrx+N8K+6H75EWq4K4WpJBVj8JSDgwkVQyJh9c4sfKnEyxbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794569298;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=mJ7s+syXoT90r15smycj+SigpCQvPifOz44qvjuC1Lo=;
	b=v+apZKDWgIS88aOfpMKvtLem8TipKBAkLmXInmdDXFp/965VQsIJ+tYj3cGhYeAvX306
	 5TnrgAt+ZFDa0PwwjRz3aNzFRTIAJ2jyrQLuZ+GwZsc4Y9k/JIR+6KDYQMtHG3X/2X0K/
	 KZNN9wHtEOxX7YLMQZkVLtJDBPwdd1BGciiFmTxwTbqPvvJcPOzjQEm8rgqvplOfs8Slb
	 pg+PlZi9jwieODAhQTGB9ugvfUoFRd131i3ngAfLS3WTe2TSZqxx+cfiQwv+OvSbUXYcN
	 mDnTHof3zpoqXrDiEI40uzObTy7NwV8VE2t92h0IkCY0upgXUUu5RsPEPYqAv6dZmQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ahMa2osV;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b="Ey5/3toZ";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2A8606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 11:28:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E2A8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ahMa2osV;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Ey5/3toZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794569297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mJ7s+syXoT90r15smycj+SigpCQvPifOz44qvjuC1Lo=;
	b=ahMa2osVPRiXnhS+GW5urSWdF1za7vQpgvAZ/tn9XhPTe2N1gunJ/pDbbtEevE0JXheu8r
	nNtPHn8hfwFmvg2lwy2eKSFlBdaWxn7Pb1p2aoRKgHvc/1PDUrzVLYo5sWCZmfflhPoucF
	vMKHblyvZ6LderM2Hrt5rTkJwWRNQFw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-lbQsuclUP5-pD26wuVFPow-1; Fri, 13 Nov 2026 06:28:15 -0500
X-MC-Unique: lbQsuclUP5-pD26wuVFPow-1
X-Mimecast-MFC-AGG-ID: lbQsuclUP5-pD26wuVFPow_1794569295
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4930269afdcso537636f8f.2
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 03:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794569295; x=1795174095; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mJ7s+syXoT90r15smycj+SigpCQvPifOz44qvjuC1Lo=;
        b=Ey5/3toZAFwvO2ZscbEgBAtBmUktbaPMiZjBlYcTr8d0x0nIn+pkgowLXVo/+Ncj8S
         Lc401WBm7gAeOidWbcRZSMkatF5QEVMaHHhpvUcoi0odDixYih2P56VxAneDQoKLoCyy
         YFR6kTWhKolY3z5PhHcRqgynGEOzVRQ+aKEGK5zvxz+h2tLWNJYOUz4t+Z2Jbg5emk6m
         yFYbkn7k1qWEgUJQGtPfJ1kWi3gpSDnR2SwAZgSTPNsoQ4Ik5xS5XQkOorfV5pi2UMje
         thOLN2pcqLviJvNFvqsA11bQm8GW3Q01td/gvKfHVhXrZjgEia4R6TFAhzQnybqRWq2D
         tOKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794569295; x=1795174095;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mJ7s+syXoT90r15smycj+SigpCQvPifOz44qvjuC1Lo=;
        b=msoGOZ7fOnPOkel6FShXj0aCjE5yEBCHFo/PGrxj2Q1d3j/XdshgbK/EmN0kswr7n9
         AurO5ho9zPWX/64Xre94IFONezFQaFEBuBrB2r/hwgaf3yF+eeTMaI1aM9q2zk62ur2j
         2tSp7AP0zyWmJF7TbX6kCPJwJvsnG5ynB821VFYNxLOFSP6C3xVNW+rk2Ch3LEL3uMcb
         yxrR4BhecK1WbvJywKvQe3C7nEpxWKl1e0dMn9ZG0VWGSBiPKIoYTMsnkIHlkWs/rE7L
         e5J3QZLeTP0KfoVLxZrCR+rVakQ7KnDIN4m5lv21Cg/rW+Wj5UYBaR+ESxuUTkhJitqr
         7I7Q==
X-Forwarded-Encrypted: i=1; AL+hErESp4YsExIf7pKD6t+9ggQBhu1gPFvGlspdjy2JqzDLme3wpWgcvjLMkcFNBNw38P5hxMLjmcIrI3Az9BQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z+AJb20xzWf5xyMytleBashQ3jbk7UPD3BfSupy6+TlE0y/52R/
	YqX+7ICEczOwxs9SOfYwTf3KpmHNTGSodT2OR7sr2zIcrWCnn327Iw7jyduO2kg4CoaEuNDT4ZL
	fKleXH1cj0LAovrJr2SeyEx4JM3eH2bP1gszrZgYqiECUbaxU5dtJoss+/eZ8wATDxY6v6uF01g
	==
X-Gm-Gg: AYBFou1DEVkaOsXWyKqkJhMm0ASqaTFjra4/g/3sQQhuYQUU0dVm6n4hVIbqt+OzMXM
	zj4XnQ+FiXM1C3lvsZwwUBVbSIbgVaUcQ2t4ndniLAlurwN1HtglBxdAziz9oeP5Tzb8TrlkYb+
	UssjNEdnMkMYgZR2Y0M/rhh/dGGwOc05w5AgpxK/LpGZ92THt2NyJmC69yZ6KvJWmLDT9g3soMr
	zzkhi13weoMSrr2DuQ7ao5/gxVAzh/MQN3cXBhJkkaZhItHAOPUCCGAA4DpCVlhdA6ntOaZ8DUe
	ncT+lbv+wPFEn0Vft6VLS6nAt+GObDcFAiZzCfZ4MYRuXx7y7U7rtwZogtLi5vrd3sT6HZAF1VN
	5h3YB1YhiX/WTDfHKOGv3QppElCfP0NgxKP5LVOmTX0aN
X-Received: by 2002:a05:6000:4b05:b0:49c:d519:7ba9 with SMTP id ffacd0b85a97d-49cd5197c97mr2689709f8f.17.1794569294661;
        Fri, 13 Nov 2026 03:28:14 -0800 (PST)
X-Received: by 2002:a05:6000:4b05:b0:49c:d519:7ba9 with SMTP id ffacd0b85a97d-49cd5197c97mr2689660f8f.17.1794569294077;
        Fri, 13 Nov 2026 03:28:14 -0800 (PST)
Received: from [192.168.0.9] ([47.64.115.75])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c605e5b2fsm4940129f8f.40.2026.11.13.03.28.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 03:28:13 -0800 (PST)
Message-ID: <cc552609-ece5-4f82-94b2-b00edf0f92a7@redhat.com>
Date: Fri, 13 Nov 2026 12:28:12 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/14] crypto: jitterentropy - Add library API
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
References: <20261018204618.104876-1-ebiggers@kernel.org>
 <20261018204618.104876-5-ebiggers@kernel.org>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20261018204618.104876-5-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 18.10.26 um 22:46 schrieb Eric Biggers:
> Make the jitterentropy RNG accessible using a regular set of functions.
> 
> This will allow drbg.c to just access it directly, instead of going
> through the overly-general crypto_rng abstraction.
> 
> Later commits will remove crypto_rng.
> 
> Note that the library API should also continue to meet all the same
> certification requirements, including the health check which occurs on
> the first call to crypto_jent_alloc().
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
...
> +int crypto_jent_get_bytes(struct jitterentropy *rng, u8 *out,
> +			  unsigned int out_len)
> +{
> +	int ret;
> +
> +	guard(mutex)(&rng->jent_lock);
> +
> +	ret = jent_read_entropy(rng->entropy_collector, out, out_len);
> +
> +	if (ret == -3) {
> +		/* Handle permanent health test error */
> +		/*
> +		 * If the kernel was booted with fips=1, it implies that
> +		 * the entire kernel acts as a FIPS 140 module. In this case
> +		 * an SP800-90B permanent health test error is treated as
> +		 * a FIPS module error.
> +		 */
> +		if (fips_enabled)
> +			panic("Jitter RNG permanent health test failure\n");
> +
> +		pr_err("Jitter RNG permanent health test failure\n");
> +		return -EFAULT;
EFAULT means "bad address" in the sense of a page fault ... not sure whether 
this is the appropriate error code here? Maybe -EIO would be a better fit?

  Thomas

