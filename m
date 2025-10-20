Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FEE2F7ADE
	for <linux-crypto@vger.kernel.org>; Mon, 20 Oct 2025 23:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761004479; cv=none; b=gediaEe0FGInILuK3Q4/x0FBH3oJQtxfTKv1dUEjK/15SfpfPEImt7dNgGLMfUodXP20mSkqk3Vr93gpXWLUBSXgs2uw5ZePGfkFY5JEGsgG4iKfLA4eI/6i2dwm5BBvd+8efknke01knzLVa5JifwEyGbj+FOSyDv5+pfw6OBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761004479; c=relaxed/simple;
	bh=Z8yBcQJaMDVMDwGKP92PcEANBe9SMhtbIsxuU/XAv6A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q2Mxbexs31zyM6XSwz29YK+0+PQlThRb2PpjRFI1vNJPvBS9kasTdj7yx5UKY1puG46g4ZDNWCWIm2l8I2NOD3RGRthggD9zZ4AINUFP8NwXEgounUIUfH/WD+O6C8aebGHYekdDC9YaWA4fwxHhr2hJC/UT58Ii6Jnm85OOI2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GxEt3KwI; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GxEt3KwI"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-793021f348fso4419320b3a.1
        for <linux-crypto@vger.kernel.org>; Mon, 20 Oct 2025 16:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761004478; x=1761609278; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jkJQ2Wqv2WIkS8r8m2VU+kwyMn/g5LRAACPYO1/MIBg=;
        b=GxEt3KwIwHh8VkYt/6Hwuf/IhkydNHarL+dhQT2kaJB466b6T9JK8szeEOCs4QSIMw
         6jck9vs578B839o2yDz/jjSDVOwZIsaGSs48tq51uhRJHQQ07qKuRcll6k69IiMeJh3c
         0ArGk/AVQpP3ncKXUFzVNYAHnW/gWmnd6RKgTeQlrJq6jFoXkP65Dj45eCyFvgDP+E8k
         e3MY7HGsmMHi11PdYteg8sn3QKM2lvNqgmRRXuJFf9kuyUdsk3hjP1GMfspFEG9tRbvR
         mLi8mFQznpIbnT97helbZNp6vkVXYipBdyEW/Dfhu7Gv7alLkI5Aacux65mJ6w0Cc5Re
         nhag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761004478; x=1761609278;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jkJQ2Wqv2WIkS8r8m2VU+kwyMn/g5LRAACPYO1/MIBg=;
        b=fY5NM8LPOhBKcEmXy6IdZjqeF6ZMU+5QdYkVzm5Tc9s7/RDC/jB9dinMJ8rtjlmuE4
         o9wQQOIkuH9ZEhb3eZztpkkj+IQ8ItASDUQXLYTvwWMmJM50czflQaqHIahBs5aVSIPU
         kN8BMdkStbLbRkSC2osp49Lfws+cK3dI1J0fwB9aOBGLmEKZ5cnifBV/t+sq32aT9mBK
         S4w6q+eGEQUmiRXBXJZQvLVIPuV6K/RG6znH4wzlpLwO8nlEFoyhqtuPbulLG23aiR5U
         izQA83bloEKDccqahoJMohlH/c4AWLWfu+5BLZvwbWRLgjm/4zNrFGdTVvDQX095MCLU
         VoQQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2xREUEhbKNJAVA3PP+GgBGEeQ8JPn7iSkTHJ5XTdco2xP/GMYHEqPcSnLg04HZ4/wFuc2n0QOWQJtXNI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzx4kSE5v6O0Wvkp7tcurDXbZy3kB4SSqwC288FmArSDrt4ul8L
	RybtPXLcfRArza7tnsOTLLhPMtOjyRIzQoH0KZwEF2xGnmOLHBGIJJC5
X-Gm-Gg: ASbGncuxe8laBH5EuUlvqQdryQZkkOIJ7vIZJZtA7m81lBdtLBOiWBdJqCnBFpV3j8r
	I1Lbd/evsoKfN/V6+Esb/bZ8/a3O2Sa4e3vyDCAD3udka3QlemEMW9AMfP60EiI0bid4bN2zQVg
	8jje+Gj+jmo6NMQpOvl7P1GMfgT2THs95X0HNkg25Yl4WBJaoFwIqx9uoUtc5SKAAV/2MBmnToQ
	IA1aP8gCrqkLPMg1kRWTopfJRwy/uZdFh0f49bJdYabixcphUlNOuF197UFmwzmQsE3Nu1nOBus
	kP4azeolYtP3mE+2XHLO2eodP9d96iIpXD3Vu3/oB+TbmdbJZsi/ns0b2i144v+DZnERQ5AiaZ/
	BqEVGadAo6NDmtsBjktLO3XNJgnnFMRA9Yp7TyQUah+sSf8rG4KrAhDezv6wlLsy6ZuJcgxu3OW
	6vllub8zJkO5qioNnxopCAsw==
X-Google-Smtp-Source: AGHT+IEWbUvYFru0xgeOb8F6Gj2YJIGo2FfUgJ3zMwHaKzd+9qSePGSKb4FX+0Eekq3XescoXtalXQ==
X-Received: by 2002:a05:6a20:918f:b0:334:97dd:c5b4 with SMTP id adf61e73a8af0-334a856e67amr20900400637.27.1761004477385;
        Mon, 20 Oct 2025 16:54:37 -0700 (PDT)
Received: from [192.168.0.150] ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff15b0csm9487310b3a.2.2025.10.20.16.54.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 16:54:36 -0700 (PDT)
Message-ID: <c42e042b-f1b1-453e-a350-dc5c99d38c75@gmail.com>
Date: Tue, 21 Oct 2025 06:54:32 +0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/17] lib/crypto: Add SHA3-224, SHA3-256, SHA3-384,
 SHA3-512, SHAKE128, SHAKE256
To: David Howells <dhowells@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-s390@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Stephan Mueller <smueller@chronox.de>
References: <aPXfzd0KBNg-MjXi@archie.me>
 <20251020005038.661542-1-ebiggers@kernel.org>
 <20251020005038.661542-4-ebiggers@kernel.org>
 <1062376.1760956765@warthog.procyon.org.uk>
Content-Language: en-US
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <1062376.1760956765@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/20/25 17:39, David Howells wrote:
> Bagas Sanjaya <bagasdotme@gmail.com> wrote:
> 
>>> +If selectable algorithms are required then the crypto_hash API may be used
>>> +instead as this binds each algorithm to a specific C type.
>>
>> What is crypto_hash API then? I can't find any of its documentation beside
>> being mentioned here.
> 
> crypto_shash, then.

OK, thanks!

-- 
An old man doll... just what I always wanted! - Clara
