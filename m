Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46107339367
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 11:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784718173; cv=none; b=oEHeFMc9wP3w2/X1Yn5ARgoYmJ0Se+OlrMucelbbb+SPgiNO/D/xNLQxtsD2rFCHtnaYK2+LTvPkR9o34WQnCmHuuothRmdBk7A8hnb8tHq8CmK/6v2PEIwJ/zQOXRzwESd+h6KqzSxFcai2ZkU6Yorv75LHpqMu7NQRAbyttFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784718173; c=relaxed/simple;
	bh=ulQwfY7bEzqaei8kpJ9RX52FSpOhWzBdM1XDyV8iZng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uMPb1JrumAp6UXJa8230FieHyYeFfhAcPniHebCDC0RM0qBRvqLo3OFpKYQwcYu6ug4E5ZSfAZL+VDHf9L4W6m0zUNF351lOsS/ClbB0g80/RI+ZkG4NV6K/wKQvnCqIsKFnMN1G4oQwg9T9Yrn0qiR08d5y/8WprWjP9tFCJUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PHAtt8sU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=M81GsHu1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PHAtt8sU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="M81GsHu1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784718171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OxS0m9ljppMCZm+htohbm1IwqBsRNGTGeR+3HHQ79dA=;
	b=PHAtt8sUW0wyrAY3t0IIORNwYppB3c60hWJZxSVHSgbrOrzcyU9rb1NPZ7f1TUb08axsBG
	ni/7KGylmtXcbdkrDEc1y8fTHkcTjHI7nZ1mH3QpVr8J/BDifPmuDTErcUoJERSkiIEzyf
	/aFPO11aZSzOLDEGPf+h3uatdNo8qRg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-yV83AqzJPMKnpDf4oObxeg-1; Wed, 22 Jul 2026 07:02:50 -0400
X-MC-Unique: yV83AqzJPMKnpDf4oObxeg-1
X-Mimecast-MFC-AGG-ID: yV83AqzJPMKnpDf4oObxeg_1784718169
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4955fd77c18so23555505e9.2
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 04:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784718169; x=1785322969; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=OxS0m9ljppMCZm+htohbm1IwqBsRNGTGeR+3HHQ79dA=;
        b=M81GsHu1LTyV7ipGjHeiuANZMwX0UOE+x3yk9zpFjNipic9kHAsnirvC5qQisaZCAF
         s9JAzAglyFyChaUEqgpqG0G0KEAk4d2dXeBrd59NtzQSzQI4dm87ph3AsJ1an6bltoW9
         QjjNaxluzVIy00nd/Zs0jmtG7Hz+Y1Liwt8NK+DBp9qWcO03HwuxhXqKd1W/pqKd39KR
         gjCKO5R9ovtbLjgHLMN8HRACY4f5d03AtSJOYmNX9stWIcan0+OJKBOpIOcurTU8AJKg
         M5itec2sjXTNwZ82xwe2+KqYhrNcInLwtpJ/stlCT2WTjKTuilReTRQr6IPRFaUVl+Oz
         QiLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784718169; x=1785322969;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OxS0m9ljppMCZm+htohbm1IwqBsRNGTGeR+3HHQ79dA=;
        b=MzQy3kcx7e/sF6lHuImpxJ892/Z64R0m7C7ja0kSjtJH9wkqRPcYd0lROxIuMlZTNa
         bXJPz7lE68JB1CyPkfwiarJIoKDEhuwJmkZhAmFmzAjWw8qkIJCIJNTkxz2vda8UZaHR
         wLCKP8ZmcmQwTKWckN0qU8krsG1XYjJXCaWAO/e4tlmNclA5EMWYSz25hM4hOj5cPtVw
         4itQxIRJsrRJtJ4k5d0otLFoFG3XZ1194kglyIG8PYJIlbptylniUSATGSl05B16R8Ly
         evpdDJ3p/k/1Pr8MhHty1GbzdXS4wJR8fkZsUEZTyOpePZzhfUaBJAB7ndALAepIX+Jy
         nd3A==
X-Forwarded-Encrypted: i=1; AHgh+Ro6eimNIoY/fqpe0HouXSTSE6oU/ddVEl6z++jdiAoUDSFXhNDFT8vSjKcmoMjbrRmOiqcuhKuHC3TAbSc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8gfFFm7j3cebUafW9ABwvhxJknqAJ3EPWH+QyEv48dCO3j4O7
	R39PU5SRpkcOvFZW4l2vYtaa69KRtw0J7qOQcbG0R/mI6jUaUVfZZ5QBqqUJyWHgFGdXNli4Mmz
	m6/Bsu5o9mnlRVPJdDMcEuUsCuAyc9+sxT2MECmEgHNfJZ2PiVyHFMUBSdBQQ/apdgQ==
X-Gm-Gg: AR+sD11Ra7grTGMdAyn9uTuC0qxPLUGqyH9mb12IR9yun9DY5hUoljBw1fdum2ft0q9
	b1QEoxzuDcHYTk0c/IGjbVxZ24xbnyEoF79YuuauZ86x6MtTiNbFrFhD+52NjmC7azcH5kKbfbj
	T7NaAYVMCcBFXCkuyzz54bUNiwmFiDSJL0QI0en1LyZdB3cbiWaw521qF+qGBSVzYHVHMaQPu2n
	JTMTBbbvefBjiZe3PwtlYmikKJzD2SbeabyJjFYCT+ayqLaRcuWgiA7deQ+bI3ZINp7vkxPfy0i
	bKwh+6e7xXFl5oYrAj679bfgwcyb5MA49Q5wkB+Ar/vD5WXp1OIIF4UYmqcxZVCalguhhFXyRQ=
	=
X-Received: by 2002:a05:600c:1554:b0:493:c10c:22f0 with SMTP id 5b1f17b1804b1-4954a50d963mr298383095e9.20.1784718168794;
        Wed, 22 Jul 2026 04:02:48 -0700 (PDT)
X-Received: by 2002:a05:600c:1554:b0:493:c10c:22f0 with SMTP id 5b1f17b1804b1-4954a50d963mr298382655e9.20.1784718168420;
        Wed, 22 Jul 2026 04:02:48 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.113.188])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495686a8600sm116558095e9.6.2026.07.22.04.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 04:02:47 -0700 (PDT)
Message-ID: <ccaed4f3-a631-4d67-92ac-de9f1937e65c@redhat.com>
Date: Wed, 22 Jul 2026 13:02:46 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/13] lib/crypto: aes: Add GCM support
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260715221153.246410-1-ebiggers@kernel.org>
 <20260715221153.246410-7-ebiggers@kernel.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260715221153.246410-7-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/07/2026 00.11, Eric Biggers wrote:
> Add support for AES-GCM to the crypto library.
> 
> This will be used to provide streamlined implementations of the
> "gcm(aes)" and "rfc4106(gcm(aes))" crypto_aead algorithms.  Most users
> of these will also be able to switch to the library, which as usual will
> be faster and simpler, e.g.:
> 
>    - drivers/net/macsec.c
>    - fs/smb/client/
>    - fs/smb/server/
>    - net/ceph/messenger_v2.c
>    - net/mac80211/ (for both GMAC and GCMP)
>    - net/tipc/crypto.c
>    - security/keys/trusted-keys/trusted_dcp.c
> 
> (I've already written proof-of-concept patches for all the above, and
> they helped inform the API design.)
> 
> As usual, the architecture-optimized AES-GCM code will be migrated into
> the library as well (using the hooks provided in this commit as well as
> the GHASH ones), eliminating lots of repetitive boilerplate code.
> 
> Incremental en/decryption is supported.  Incremental operation is a bit
> controversial in AEAD APIs because users have to be careful not to
> consume any decrypted data that hasn't been authenticated yet.  But I do
> think it's the right choice here.  It's not fundamentally different from
> the existing incremental MAC APIs, and it's the only approach that's
> general enough to work well for all users in the kernel:
> 
>    - An array of virtually-addressed buffers (like that used by
>      BoringSSL's EVP_AEAD_CTX_sealv() and EVP_AEAD_CTX_openv()) doesn't
>      work in the kernel in general, since in some cases the data for a
>      single AES-GCM message is contained in a large number of highmem
>      pages that each need to be mapped into memory individually.  That
>      can be done efficiently only by using CPU-local mappings, but there
>      is a limited number of those.
> 
>      Ceph messenger v2 is a great example, as it can send or receive up
>      to 32 MiB in a single AES-GCM message.  And it needs the
>      en/decrypted data to go into a (potentially large) number of bvecs
>      provided by a custom iterator, as well as into four
>      virtually-addressed buffers, two of which can be large buffers in
>      the vmalloc region.
> 
>      Even just allocating an array big enough to store all the pointers
>      can be problematic in the kernel.  There are cases in which
>      decryption runs in GFP_NOIO context or even in softirq context,
>      where memory allocations are not as reliable as they normally are.
> 
>    - Meanwhile, 'struct scatterlist' (the choice of crypto_aead) has
>      turned out to be really inconvenient for anyone who *does* just have
>      virtually-addressed buffers.  This is especially true if they can be
>      in the vmalloc region, including the stack, as in that case the
>      conversion to a scatterlist has to be done page-by-page.
> 
>      And even for users who have all of their data in bare 'struct page',
>      none of them actually use 'struct scatterlist' as their native data
>      structure anyway.  They actually use skbs, bvecs, or other formats.
> 
>    - iov_iter is attractive, but ultimately not general enough either
>      (considering the Ceph case for example), but also too general in
>      some ways (like having support for userspace addresses).  Additional
>      iter types like ITER_SKB would help a bit, but bloating iov_iter
>      with more types would reduce performance elsewhere in the kernel.
> 
> Initial test coverage is provided by the crypto_aead support added in a
> later commit.  I'm planning a KUnit test suite as well.
Sorry for asking ignorant questions, but which later commit is this? I 
couldn't spot it :-/

Anyway, the previous AES-GCM code in lib/crypto/aesgcm.c featured some 
self-tests in libaesgcm_init() ... would it maybe make sense to add those 
here, too?

  Thomas

