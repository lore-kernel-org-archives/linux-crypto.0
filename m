Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4444C1FC10E
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jan 2025 19:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736881556; cv=none; b=i3Kqk012eo2iMiP+IMkL7WXpBLSaSBoHRoJEnJF8nF+CDrEmKQJWLAZ2ZLQP4JdxPalAtmL8jRaz1k9Egt7s4wXw1MZnV0kVJnxPQ3o1VKtBsILKj703T1opjX8bsDRzRryo6SmFc9LUNTnKWnGN/8QRbozGQr1REjfPZTXTcD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736881556; c=relaxed/simple;
	bh=lW7QHrqzzg8jlFsfL+HoNF1gMyRBecgeJLWCUKHiZTE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=EcVNn56PdOumfKERNQcsQqQlYCZm0RUH7MyaCUugjPsTa2hg5/QoT4wPk9sxUvnz6o3awQDD14yomb2Tb1H0LUxZvYyj2xob2diq0YOuF842zRgpq/n4dAn5t/q23RPJpLtc29w2M4PCzIOr/j9nlL3gtgC3YdEaUd8RO350i/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fhzh6XBo; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fhzh6XBo"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4363298fff2so5197855e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 14 Jan 2025 11:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736881552; x=1737486352; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+DfXWEXtvvASVkJwhSh6pd5L5pzdDyn7+i2QfVWpAdU=;
        b=fhzh6XBogKjLt5N+JS8tryuP3UwRqxWPnwpDt/d03Ycu5pHevbyBJu83Qh7VM2wxRs
         AoCaz0qI3Ga90nQB8HxF/uOMwve5Rfc93K/aFTsappTdubq0DXdF5+t8mBmUviNU2xE8
         kVI1QYXtD/a9S2xAGcK5KsSvJQXFz93Aou7M9IzwkMLd5vNZWO0sIwhaF7szM8mlky5R
         1Nb9TR+Tump1CKbb2KEjMR3NlrRKu7xHn0VmUJqOUdPnaWWT8UX2YmNKF7DEaQiX+vHY
         juZXOgbSvD41GiivNxstdTszHk+TS5trZ64h8h0RV+v2gGq9+oWTjl8HcYPaY+wuRMxN
         RKzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736881552; x=1737486352;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+DfXWEXtvvASVkJwhSh6pd5L5pzdDyn7+i2QfVWpAdU=;
        b=c5xLCXao2WUH68W98P9jFmXHYPKcLolvlPyVe7URWkki0fDWGPLPBcIvlpSt1M6VD7
         C+XsS+AVOjSc97m6TeFMioa8S9A4xa8rBM/kBY2zHtD7gpuMS1l6iBlx9QhH8bKqSVnk
         h2Q788frLQTEFZWCW3WvveRDBFK0gTngKdu75cEzjOxXCPt7QMI72+uiq3hthGiGQsVQ
         yzDzOLzcc+dIcOlfik1aIVR/Es1pq4mfOir7e8p2KzGMeM/VsoHp3znjGHcXu4sd7S+Y
         RqD/t0y2OzgxDwNqgkhySmGwJAtCGLPswtaWKiR0uoxE+UGfSaTQ1Cs//bqPyntXxMka
         B6jQ==
X-Forwarded-Encrypted: i=1; AJvYcCU86xR+ufhGclxHxcHx5KACaulZ/UmEPDYz9jQvzufLMbFYHcrKnEpSCotf5ZhQSCjCe+qHRSVuwuJC0hw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBNaLKhaDVEqL9RTLN1gRFg5mZr+3R+Wy3jt+XdKwssXheXLDP
	xytho9eMugzjph0vO4muGu4WjPX51gIMkvfGeyN3HinsnfKIV1WseU1Olr97t1I=
X-Gm-Gg: ASbGnctyXXpRgPJV7+St2F/8e4+DwNTeX3YQxvLCpKjEgJg+ilTEp9ngWWHdYGLhsfb
	KDqCQMfUnX3UqrHjX+k9E3351xvUedHKAVlYgqIgdTXMxLRztXvgSM6hm449fpOucRpt8zXC4Xq
	BxhIfCnikdl9jTJscmAgL6aIAzehllAbnQR3/bUWdQDz8+chlf8Nz5H5nPC7PR3yToJVmxDziKA
	SC6LszU8ixQS5XPpzgEROw27VvbTsetlgAolLHnp6BKKjKxtZIgP0sITIqIk18RKSLwKv8zmRrv
X-Google-Smtp-Source: AGHT+IFDLv2NINTRyzx7t9ysCH4kIutmWZ+d4iNDbpZ0ffaw3CUhcnSWtKVlBI8I3A9FwyI3SZ9gKA==
X-Received: by 2002:adf:9ccd:0:b0:38a:5557:7677 with SMTP id ffacd0b85a97d-38a872e161dmr7560128f8f.5.1736881552507;
        Tue, 14 Jan 2025 11:05:52 -0800 (PST)
Received: from [192.168.1.20] ([178.197.223.165])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e4c1b2asm15196659f8f.89.2025.01.14.11.05.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 11:05:51 -0800 (PST)
Message-ID: <3a50514d-2c28-4728-91d1-60ec91bcc2f9@linaro.org>
Date: Tue, 14 Jan 2025 20:05:50 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] crypto: Use str_enable_disable-like helpers
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, =?UTF-8?Q?Horia_Geant=C4=83?=
 <horia.geanta@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>,
 Gaurav Jain <gaurav.jain@nxp.com>,
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Boris Brezillon <bbrezillon@kernel.org>, Arnaud Ebalard <arno@natisbad.org>,
 Srujana Challa <schalla@marvell.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, qat-linux@intel.com
References: <20250114190501.846315-1-krzysztof.kozlowski@linaro.org>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Content-Language: en-US
Autocrypt: addr=krzysztof.kozlowski@linaro.org; keydata=
 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
 D2GYIS41Kv4Isx2dEFh+/Q==
In-Reply-To: <20250114190501.846315-1-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14/01/2025 20:05, Krzysztof Kozlowski wrote:
> Replace ternary (condition ? "enable" : "disable") syntax with helpers
> from string_choices.h because:
> 1. Simple function call with one argument is easier to read.  Ternary
>    operator has three arguments and with wrapping might lead to quite
>    long code.
> 2. Is slightly shorter thus also easier to read.
> 3. It brings uniformity in the text - same string.
> 4. Allows deduping by the linker, which results in a smaller binary
>    file.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

And now I noted that should be here:

Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com> # QAT

Best regards,
Krzysztof
