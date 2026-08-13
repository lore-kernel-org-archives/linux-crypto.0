Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6C1478E5E
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 14:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786630128; cv=none; b=Beo4zbI7XQLA7iJ20gUPiClY+y3YqsbzvF9owmXQfhf02j7rprzC5VNvTWDzMklzfOd1guLAanxEvfgivNL8zCxRpolNtH9v8bZ5YDeb/+/MwuycG2g58p1aGxadzcL5KGc27PHEhhlBDNKHNdQkMrlNjtQsBPICDH8bhZZyI/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786630128; c=relaxed/simple;
	bh=QJg9RJdIOcQd1kPkwL9YVCQ3uiVf6uZcs8vurwK3+0A=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Wh6sdeZBnFwVsSy6i7BGytpDdGsL0jBEm0O7HyVaV/iCcM10LNwNcDK9nT92dLUPtG6DlQVmAukeFxSb2CW2nfw58YiQyuu2ZKMn70hJYKsBVNYs4OR4aKoFV9oJg2vJAtvEKl8ew50XOjbgTDBbBVf2qX/UyvpVv3TwMWrJnO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Me1C4xhk; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=tVYFogK9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Me1C4xhk";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="tVYFogK9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786630124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5203/Ce3qhWypNFAl6PpIjVViCBYaXllLI1G/IlX2wk=;
	b=Me1C4xhk4xVMHF1YPllL4hcFHfGgxqSkjytTtuVebxbqi5d0UutiZt8HoNEPJJfTJjaevF
	9mT9pLCJoRjPF16rv/mh/uuOy5BrU4LzXRbekmvtUTTSAYd9Qbm6YZ9X2oMAS01Ekp37cS
	FoxuooyFZBvHrM3iNTFr6upUOgWXmjI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-MTFQrpMTPYSTG0HL5GtnQQ-1; Thu, 13 Aug 2026 10:08:36 -0400
X-MC-Unique: MTFQrpMTPYSTG0HL5GtnQQ-1
X-Mimecast-MFC-AGG-ID: MTFQrpMTPYSTG0HL5GtnQQ_1786630115
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4957287363bso5505035e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 07:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786630115; x=1787234915; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5203/Ce3qhWypNFAl6PpIjVViCBYaXllLI1G/IlX2wk=;
        b=tVYFogK9qWHGdlNH0pFxNUDB0WNF9M4YfBAsnikXAkw8SdGpiINmcS/eDyf+mxdMMT
         x60rBL81E9T2yJzEB8VGcDIfUQnVqQYHnYOjNHPiQcLNNAuretKILfWIjeCEkJnRrwMN
         TRGdw9BlI5bmaLx1lWtcD8J5Hn7nUHyKSxtxSRekwHpxxMZXLXD4zMA+0opBp2y8OCXS
         VJtSsEN35pcTnKIngXjVubDimW1CUVwr27UnG9vvcGzkaTBuVgHoZCi3lBdBMtaanBx4
         YH3Tsb14qMKES4TWN+LokFWHt5rCXPwCcz6FpF5OjDfNAc5ltswG2ACsFBUEH2vo/0/g
         mJ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786630115; x=1787234915;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5203/Ce3qhWypNFAl6PpIjVViCBYaXllLI1G/IlX2wk=;
        b=Vu4C6WUWDcE1/CbrXQoelg3b6HiDat6sk4G7TGtqxu8T+5f0nwXTvGIMwwmTe0Lfsq
         cijmHYNAoc4dOELgklvfjCRyigmvVowe0r/CrJR2TL2y1M1lUTEifoGMaNO+jP0En2OS
         HFLQgOq+WJJdTVshlLYjE0opAmxQwV/K6vzGgv6tgynsuxxoZblcdQ3L1ReLdygJ3izB
         LV8W36Xc5XEdwzmFTw0ZMevJdceSB4bN4/5rz9duDKbDQOimn8XEdXi7EtI4Xz/Lfobe
         VgXNH3lhs1LxEqXDGgNTGCTXc3ub+3wOkikQlks85X1e49symcon2CL3GtZl4ox+HKas
         tLAw==
X-Gm-Message-State: AOJu0YykLYGedLDDxXDMETh8t4RR83MTI59qo4JFHKcH8IqUf4pLOA6W
	B7bU87HBNpO0Z3QX4tw3elUIoc8wlIAu1dQCxg4g/x/UfWxleFhpyg+Sg6r244RG0IkzDFzEfR1
	8ksQ/MSYGR2b5VODNkwoSfbZdmWXTCdEJ18FqS/ha7tsDpBesUz7X1LEBqljEWr+BAA==
X-Gm-Gg: AR+sD10bsh7CbJKhnO2foTzyNdxk2Ww/smdL0XQLc3fc8OjsN1H5R9ReslNuAyoVdq9
	kLbHZshEjR1kzCPbw1xZB1ch5NpT00u1bNl11za1zSpc/30RYOQifR+9x0W5lpaZPY+marDIvEq
	FbM/D5hZACA7CBFs5mqGM+CQ/6hFf3SSrMeju/KDeWZBW4Eot4nZkMXsGxlQyFLihz8b275aTHs
	YWETa2LtCtigNHoz8iKBrLytOQgorAo+VPonLTyJikjpC8Xj9rNrFvvGzGpRdmqTmnJKy3uuWUG
	lAPUH9hfKA2pqT9Ddh/rrNArpOXUAgHsJqEZaoFuon8v+ZZTdGqkgcapPfIUU/di9RI6tHcJ
X-Received: by 2002:a05:600c:1914:b0:499:5210:c537 with SMTP id 5b1f17b1804b1-499821c59b9mr71255825e9.1.1786630115373;
        Thu, 13 Aug 2026 07:08:35 -0700 (PDT)
X-Received: by 2002:a05:600c:1914:b0:499:5210:c537 with SMTP id 5b1f17b1804b1-499821c59b9mr71254645e9.1.1786630114884;
        Thu, 13 Aug 2026 07:08:34 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.115.27])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499820c2897sm128587115e9.0.2026.08.13.07.08.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2026 07:08:32 -0700 (PDT)
Message-ID: <05aa107e-36cf-48d2-8190-7a0c10c77dbc@redhat.com>
Date: Thu, 13 Aug 2026 16:08:31 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/10] crypto: Provide a wrapper function for zeroizing
 crypto_aes_ctx
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
 linux-kernel@vger.kernel.org, Antoine Tenart <atenart@kernel.org>
References: <20260810093009.608090-1-thuth@redhat.com>
 <20260810093009.608090-2-thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260810093009.608090-2-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/08/2026 11.29, Thomas Huth wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> Several crypto drivers need to zeroize their local crypto_aes_ctx
> structures after use to avoid leaking key material on the stack.
> Currently some call sites do this with their own memzero_explicit()
> call, which is error-prone since it is easy to miss a return path
> (what already happened in some drivers). Some other call sites miss
> to clear crypto_aes_ctx completely.
> 
> Provide an aes_zeroize_ctx() helper that can be used with __cleanup()
> to automatically zeroize the context when it goes out of scope.
> 
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>   include/crypto/aes.h | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/include/crypto/aes.h b/include/crypto/aes.h
> index 3279cfa546085..e70607249ae5c 100644
> --- a/include/crypto/aes.h
> +++ b/include/crypto/aes.h
> @@ -159,6 +159,19 @@ static inline int aes_check_keylen(size_t keylen)
>   int aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
>   		  unsigned int key_len);
>   
> +/**
> + * aes_zeroize_ctx - Clear a crypto_aes_ctx structure
> + * @ctx:	The location of the context that should be zeroized
> + *
> + * Explicitly fills the crypto_aes_ctx with zeroes. This should be done
> + * once the context is not required anymore to avoid that its contents
> + * are leaked on the stack or heap (if not using kfree_sensitive()).
> + */
> +static inline void aes_zeroize_ctx(struct crypto_aes_ctx *ctx)
> +{
> +	memzero_explicit(ctx, sizeof(*ctx));
> +}
  Hi Herbert!

Just a quick note: I've included an updated version of this patch in the 
series that targets libcrypto here:

  https://lore.kernel.org/linux-crypto/20260813134953.979481-2-thuth@redhat.com/

... so I think I'll best resubmit the remaining patches of this series here 
once the libcrypto series got accepted.

  Thomas

