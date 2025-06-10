Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23900246BD6
	for <linux-crypto@vger.kernel.org>; Tue, 10 Jun 2025 13:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749562006; cv=none; b=KQ6PVq82RTeqjnzmUtskEQKPcBL8nq2AOJoYePszpQUaiwwBhTQE9R5Ce9QJpYPbcAj1ONzLtZ9/X1TT39ZmYoYPHTzJYe7ZgDNpIBEp8pjQJkcVoGzvDjHwp9NAoeKZe0t7U0HeLP0VQrKlmEpIO+shEdtJ/qwoZBooqDlwqpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749562006; c=relaxed/simple;
	bh=APZDvGSYegJLN/zQ5E9EYiraL6K9C4h9tep0OmCRjBM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=WvdYvNiPwnEJlHv/toZ6hGeLV2lTiJXttTduAwyM2dkoT3DXB75T7txc89ylvs0TvqSRkM+VP/j7Vfaxx4EvgGrs0CYyeSlsYTFgkBBlbSBJQLlnO6HyOFZGeIBavwTnQB/qzLyH6NpO7Lq0rBTgJ0LUrPPXTqz5Y5emU7CirXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org; spf=pass smtp.mailfrom=cryptogams.org; dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b=og2ZjfZ0; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b="og2ZjfZ0"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43cfe63c592so62724945e9.2
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jun 2025 06:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cryptogams.org; s=gmail; t=1749562003; x=1750166803; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LH44WntEY2fTVqXbHAq8i1nzDw/kDJ8Gl3v9f3DoQvQ=;
        b=og2ZjfZ0VExlWvgsJ+UxBD8vqJdDlPe9ZEQOMcGUZRkJclVEQbqsodVh5aRkZar2Qo
         3anmhmjZwYfthiVIFGnB4q9/1JjlG2t3ogXa6pEtbS4OnxMXO3s+YhLNzgb4z+QCxQOE
         GOJqTmcQZtfBGQJz6AGUMYwVVOtC2qX81E60Bc2/CorjryxtGWCCGG+kAqbboZFKFsSx
         XUfvLTLm7FPnHFuXoRjhExqV7R8Ewdud1BkBCYHEq6an2HLqfLx+lezO2HtiFyCRcthM
         oxqtbRBRdBY63sqq5U5PAsAuaCoMQH1OC9KI/vC2IuzKs5iHF3Qd67Az4T0HIqcB4pJj
         i+5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749562003; x=1750166803;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LH44WntEY2fTVqXbHAq8i1nzDw/kDJ8Gl3v9f3DoQvQ=;
        b=HO68gN9kD0bpPJZT5tI9ew/eGrPU0LX5ghC9WNKVh6tykd5NPU8QTmUTNa7HdWQ+6T
         nQ8nDjzoa36gjxGJ/FZLT0+Ph6bUF82UkdCUgyZab5QAM0MUD6HgwuUPY+Qkk+e0elKr
         NCYnkGYwi8SPNtyocRnVGFQE+SZ0xC6gKUO6PkcPQuxdVFcnBSi+Lc06tsFKxwT8tdVn
         sJ2tjvQr4Ve/jsIFd+cNo87B8wSlB512JVzWOJC6Nyg68PZZJTvfUjtjHHKMGXFmj4er
         ItWC0Fw5/gsmKDmqfBamsTNVl+IG+NFe2lEjPfTkMB3dUosb1DmCRdagcOu0egc2xfxl
         dacA==
X-Gm-Message-State: AOJu0Yyv1Vi+dSw9Lt4IyuW61NB5mz/fSoZTgf+vWmEM5bJQNeZA5miF
	KlfuNdpVR7OghUflJEvo4USBXif0ZkkHwfUORYtha4kjUMqIdWQB5iQnG1wNiYOWw5Y=
X-Gm-Gg: ASbGnctHjEAHGqPfRQlH7pIxpU+6YOEMWgmJxB2OjctRfELvFuNLt3xMzbzFMwHLmvU
	5D5/VIv6POZb9Q0w4IsVfG3mlksVUU1zdwDSePY1rtOQzk29w8RmE0kRoX/sVSboeStQlwJmNxM
	WPTQUIVQghbulyn5NePGSvyXkwS7bP4L+mJFE/AYalUZUwDHbRVXw8UwOIWl+RnZ7zInrqMHEWO
	9bJGPjFREqy/jHUYDCrCUAU5hYJ4YeU9tyZk55I4LrakwV8v+ig/ZBPKg/sP7/+9CsywDIH0E8Q
	yRUBS+EIsvIxhbeTtuaxZMusYRe++34+LjoZP6t4L6waRzaNikiQ3LACOU3Js2ozMAd4S0WVEuI
	+lzaUR4QRVE0gq9D2
X-Google-Smtp-Source: AGHT+IFlQReiFJK/Af7RgrjNQqPklkEfv1/bZJWTvAfp+oUAWvrqUQ2eGtnyyMmp2qtcoWM8f0FNSA==
X-Received: by 2002:a05:600c:314a:b0:450:cfe1:a827 with SMTP id 5b1f17b1804b1-4530bba5129mr95169265e9.31.1749562003150;
        Tue, 10 Jun 2025 06:26:43 -0700 (PDT)
Received: from [10.59.10.179] ([185.201.75.120])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-452730d15f4sm143315905e9.40.2025.06.10.06.26.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jun 2025 06:26:42 -0700 (PDT)
Message-ID: <f237f87e-50bb-4cbe-a1f9-f1ce41173725@cryptogams.org>
Date: Tue, 10 Jun 2025 15:26:40 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Andy Polyakov <appro@cryptogams.org>
Subject: Re: [PATCH v3] crypto: riscv/poly1305 - import OpenSSL/CRYPTOGAMS
 implementation
To: Eric Biggers <ebiggers@kernel.org>,
 Zhihang Shao <zhihang.shao.iscas@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
 herbert@gondor.apana.org.au, paul.walmsley@sifive.com, alex@ghiti.fr,
 zhang.lyra@gmail.com
References: <20250609074655.203572-3-zhihang.shao.iscas@gmail.com>
 <20250609201306.GD1255@sol>
Content-Language: en-US
In-Reply-To: <20250609201306.GD1255@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>> +void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
>> +			  unsigned int len, u32 padbit)
>> +{
>> +	len = round_down(len, POLY1305_BLOCK_SIZE);
>> +	poly1305_blocks(state, src, len, 1);
>> +}
>> +EXPORT_SYMBOL_GPL(poly1305_blocks_arch);
> 
> This is ignoring the padbit and forcing it to 1, so this will compute the wrong
> Poly1305 value for messages with length not a multiple of 16 bytes.

Right. There seems to be misunderstanding. It should be sufficient to 
pass -Dpoly1305_blocks=poly1305_blocks_arch as one compiles the assembly 
module, linux/lib/crypto takes proper care of the padding and the padbit 
to meet the assembly module's "expectations." In other words there is no 
need to implement this glue subroutine in C, not here.

Cheers.

