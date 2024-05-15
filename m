Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480C056458
	for <linux-crypto@vger.kernel.org>; Wed, 15 May 2024 09:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715764022; cv=none; b=eSidIAEv+mw++EZVr1BjH/uFXnbh3yoWymJvq0TAf2mDz/EFSfFu5yik23cmNBl+T26G0+gdgap7QR8tqUjd2OEvKTS30I6y9YaS6QcYvB36LnbGTGX2aHfZVpCtpRQhnksLsBXHjhSfKN1achmmGL9ASyxMFdOGhqIMic+Z/Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715764022; c=relaxed/simple;
	bh=1xrqSVmY6y5f0IJU/CJ9W0rn3p4eJZgwKOfeaSBXORQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q7H/xhpM/0lTPJBqlGIlK0yPaePsvgRvjWzTFEdRzEbMtboWNAV5tE5SsQGfIjRBob8+2mmDu2LQVHG6BF6QltGj1m9427yHS79QHRqwWssI6jWooyCsfN5I1A1A/y/cx4WCLYpgg2dinNp1HYzt0LKSN1ci3mv4xcg68SYg2DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org; spf=pass smtp.mailfrom=cryptogams.org; dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b=W4Mibdny; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b="W4Mibdny"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2e0933d3b5fso97628671fa.2
        for <linux-crypto@vger.kernel.org>; Wed, 15 May 2024 02:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cryptogams.org; s=gmail; t=1715764019; x=1716368819; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sCN4Aw4+b34uYf5T+77CTVPm7n3v2SZABsZPxP6R4EM=;
        b=W4MibdnyEPm6VESKpU3NOozrmFp9lvzvSDRa92N6z8tVpClECojxMWGzKLzQIwY0wx
         F88b7mwtSrnt043J6VHiKCWARXxk/yfNYQQNd9ZwHzRH0lxPWrMcvzZpuG1S2uxRoHHO
         GcvQve3Cd3Q3eWxZACI+SwupUFcXYURiKJmSqJ6Zb3ampvurpwZYdrhsnCO9Dldt8aiQ
         m7M8bsJA4aYj8wV+BlYdbRGqOd+fO99tceqbfsmGI+ueUEWuodzmiqqAzjfBVrDTJy30
         KmDPu3EVkktp+kknNqIIxy4+KSei23oQvUuUME1W2Y3YRNyKwBhZDVlmYJXvzL6jKj+t
         5NHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715764019; x=1716368819;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sCN4Aw4+b34uYf5T+77CTVPm7n3v2SZABsZPxP6R4EM=;
        b=O8phXjqnSzsMjM3JLyYgF1odqnW6iFJSGs8TsO0QoiVjIkpR6VarVzUdLdXDDSU/Zg
         pJRz6IFjcwa9PBFzBq7EMK2IV/QPWCoRC2D6lenWojRYz4XJje3ZQeWBtauE3izBZzeZ
         reZPSZ7uzkxkT6inj6jYc4wMIaQWVg13rpAbN//bq7spK669JGyliAX4ZZBwxX4lU1AF
         29ozss1jZqppl71QUqvx6FNIlY5H8tAm2vMqApLCvHGSiWVUdOUmIBgtIC5czzmtRoxd
         2oxBSOkWCF+WSfJY7h/6zJn9K13q1PfF2D8cWias7UthW76r6uV0s44YlPkhCoOJAUcf
         GTcw==
X-Forwarded-Encrypted: i=1; AJvYcCUQOkMa0pjYnIdFaonhCw0S8uddIPLmj9NTe8Z/vKBGFggJuMHLO2Yh5bSkBY5lJ8douUP92VEH/v5MfOdqUNiUKhWBrEUevQg6oJzT
X-Gm-Message-State: AOJu0YyZk2EFLAzD+V4CnpLwnlzXKhhzuv2b9+LelSKg4QSHzbXkZOXZ
	pxkM+VAJr/rWtKIrL+A6Qn3Q3RV+foqBicaUK0xnhyEJDEmEbOSDha1di9UaPfg=
X-Google-Smtp-Source: AGHT+IFGA1MJpKD7oQyr1PZIq0Tmx5HGUB13Z1Mg0iiS0ZqwHQj3FyTq5u9WwgiEAYYNn+VyIwyrpw==
X-Received: by 2002:a2e:a794:0:b0:2e6:f3af:c6aa with SMTP id 38308e7fff4ca-2e6f3afcb13mr16822391fa.40.1715764019239;
        Wed, 15 May 2024 02:06:59 -0700 (PDT)
Received: from [10.0.1.129] (c-922370d5.012-252-67626723.bbcust.telenor.se. [213.112.35.146])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2e4d1621233sm20272571fa.126.2024.05.15.02.06.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 May 2024 02:06:58 -0700 (PDT)
Message-ID: <db513fd8-4723-4b4c-bc14-7da7222617b3@cryptogams.org>
Date: Wed, 15 May 2024 11:06:58 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] crypto: X25519 low-level primitives for ppc64le.
To: Danny Tsen <dtsen@linux.ibm.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, leitao@debian.org, nayna@linux.ibm.com,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 mpe@ellerman.id.au, ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
References: <20240514173835.4814-1-dtsen@linux.ibm.com>
 <20240514173835.4814-2-dtsen@linux.ibm.com>
Content-Language: en-US
From: Andy Polyakov <appro@cryptogams.org>
In-Reply-To: <20240514173835.4814-2-dtsen@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

> +SYM_FUNC_START(x25519_fe51_sqr_times)
> ...
> +
> +.Lsqr_times_loop:
> ...
> +
> +	std	9,16(3)
> +	std	10,24(3)
> +	std	11,32(3)
> +	std	7,0(3)
> +	std	8,8(3)
> +	bdnz	.Lsqr_times_loop

I see no reason for why the stores can't be moved outside the loop in 
question.

> +SYM_FUNC_START(x25519_fe51_frombytes)
> +.align	5
> +
> +	li	12, -1
> +	srdi	12, 12, 13	# 0x7ffffffffffff
> +
> +	ld	5, 0(4)
> +	ld	6, 8(4)
> +	ld	7, 16(4)
> +	ld	8, 24(4)

Is there actual guarantee that the byte input is 64-bit aligned? While 
it is true that processor is obliged to handle misaligned loads and 
stores by the ISA specification, them being inefficient doesn't go 
against it. Most notably inefficiency is likely to be noted at the page 
boundaries. What I'm trying to say is that it would be more appropriate 
to avoid the unaligned loads (and stores).

Cheers.

