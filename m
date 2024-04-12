Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972F2502AB
	for <linux-crypto@vger.kernel.org>; Fri, 12 Apr 2024 08:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712909253; cv=none; b=czkff9/lPhkYgORJo5YUDyUBZYuC8kua1a5jTmP2gKzVWDB/V+y6JlQCaNzCmgaNgn/Rctr+9oG459ny21C4Bw8fl9q8/IJyFjELusJ8tvPNegl4El1H9AmP1OXuFk+DpBG8NXjBLNV3VuTx+KlXnlBuI1q9HuFWLNfsghf6M1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712909253; c=relaxed/simple;
	bh=3IjMoJPPDsmrGln27ZH7cdC9pcrDYQA5K5g/Cj2Jo3Y=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=lR64WFdDotCLqTgOvYoUHakPYqIZFibHDMkF+76/ypDV6iAANV1AW8IoElrNyTtkED2awvQOnGdfGjUeNa0Vqvbe5GJdOpPKnJinzhxVIt39IKdJ6LrGMQS3W16zD8wjp/e1PblHiI1HFST0IR4fpGxSXJvowB8eZN0sAQJj4tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=UBWcZIIT; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="UBWcZIIT"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2a53e810f10so428915a91.0
        for <linux-crypto@vger.kernel.org>; Fri, 12 Apr 2024 01:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1712909252; x=1713514052; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nGl9jdbv5Am2wxVTko9m/8o+kZf52GqNyMAe+a/ezhg=;
        b=UBWcZIITH5sfwq21LqCMqFOsBKL8mQ2l1rL3SdHm8vLlTZ3X+5qJ06o0nB+8CClrzN
         vg4ra3Mwquo2/NxLOPA+UVJSiZ1jMRGjY5/EDFbT35c8qLewnX1HtQSn4iB1nliMutbz
         fd7aSlCVR0uZe//+7RPjCvMWhJKPJrNgM94wMdTmvnC2M6ETs+wVTcNgetCFvh5vbu7Z
         h2I2Wkprke/V2ok8zw4qF7FLWgZpZTMeptbllISHUYaLiilN5N3AqNzbuzQ6UAXXXbdQ
         coxRc4f9QTJdp7BW4nqcpAzV/vf4gAy9EVI+4pGPL4YTvVOlFKrS7HMCcczhl6ESvM9A
         dgEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712909252; x=1713514052;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nGl9jdbv5Am2wxVTko9m/8o+kZf52GqNyMAe+a/ezhg=;
        b=n4Bjj2ClLrEg1BszhphqU+bc5Itii1T3IZjT/zJ7o62ERXhsMrxZu+N/jKwLUZJI4d
         IxXtsbyMS/C2bwMbZeVbSaiZpbasnridzTd34ai1J9vGaBnIIy05xv9HJ92cbPDaVm23
         wfFxh6SoS8B67od7o8rvnPAvmWqHOQcjkprfYKaOTrzyUxwfQ7OcpK497SdrrPHtnYq0
         1vORP/xHjBwz7iArXMqLn/ytNAXFwGTMAV6XM1CfjiadV3y1HzigUjrxIC6q/wOXNAWr
         yqcfEHDMYtu+4ox6J6Q5TgGLSoX+pGMSabwxQwO/zTSyy5TlrKd2eDm8Ykq24mEHTn+f
         k12g==
X-Forwarded-Encrypted: i=1; AJvYcCU9QvbZDNHcScDhXiQvlqC8Lp0gIwYu3grtmXamWCQjWtsT1QVWMh0cNQDoFlW99X65a/WdhRO5HwcDEDIMZig0i/mMl920HBBhaHRl
X-Gm-Message-State: AOJu0Yx2mKwl8j8iY3UPUzelIjF6n569YbMILY3G8MfzDhnmHAixWRhb
	scpPX66mYgRokpy/Ej9EmD78V7/J9TXiRCyHtQ3viGiX4fB/v7FMuspHcRApYzc=
X-Google-Smtp-Source: AGHT+IGkFTDo+PWyXaeyOSY2amADa59LduvcEJ+hSQBEwUy0nDRJvaJ0TqxG3cldc9JpbpHf0UsuAA==
X-Received: by 2002:a17:90a:8b09:b0:2a5:e1e7:b994 with SMTP id y9-20020a17090a8b0900b002a5e1e7b994mr1541409pjn.19.1712909251929;
        Fri, 12 Apr 2024 01:07:31 -0700 (PDT)
Received: from ?IPv6:2402:7500:5d1:35b0:d179:3a11:9628:3bf0? ([2402:7500:5d1:35b0:d179:3a11:9628:3bf0])
        by smtp.gmail.com with ESMTPSA id h16-20020a17090a051000b002a2e4b593cdsm4338701pjh.51.2024.04.12.01.07.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Apr 2024 01:07:31 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH v3 05/10] crypto: riscv - add vector crypto accelerated
 ChaCha20
From: Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <tencent_C7B10C572AA62E84ABF1818F52904DFBCA05@qq.com>
Date: Fri, 12 Apr 2024 16:07:26 +0800
Cc: Eric Biggers <ebiggers@kernel.org>,
 Andy Chiu <andy.chiu@sifive.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 ardb@kernel.org,
 christoph.muellner@vrull.eu,
 heiko@sntech.de,
 hongrong.hsu@sifive.com,
 linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org,
 palmer@dabbelt.com,
 paul.walmsley@sifive.com,
 phoebe.chen@sifive.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <36AECE24-69F7-4A95-A9C5-E1EFBE05DE9B@sifive.com>
References: <20240122002024.27477-6-ebiggers@kernel.org>
 <tencent_C7B10C572AA62E84ABF1818F52904DFBCA05@qq.com>
To: Yangyu Chen <cyy@cyyself.name>
X-Mailer: Apple Mail (2.3445.9.7)

On Apr 12, 2024, at 15:59, Yangyu Chen <cyy@cyyself.name> wrote:
> On 2024/1/22 08:19, Eric Biggers wrote:> From: Jerry Shih =
<jerry.shih@sifive.com>
>>=20
>> Add an implementation of ChaCha20 using the Zvkb extension.  The
>> assembly code is derived from OpenSSL code (openssl/openssl#21923) =
that
>> was dual-licensed so that it could be reused in the kernel.
>> Nevertheless, the assembly has been significantly reworked for
>> integration with the kernel, for example by using a regular .S file
>> instead of the so-called perlasm, using the assembler instead of bare
>> '.inst', and reducing code duplication.
>>=20
>> Signed-off-by: Jerry Shih <jerry.shih@sifive.com>
>> Co-developed-by: Eric Biggers <ebiggers@google.com>
>> Signed-off-by: Eric Biggers <ebiggers@google.com>
>> ---
>=20
> Hi, Jerry Shih and Eric Biggers,
>=20
> Since this implementation is derived from OpenSSL, I have an issue on
> OpenSSL about this chacha20 implementation using Zvkb [1] and see a =
fixes
> PR by Jerry Shih [2].
>=20
> I wonder will kernel need to port those fixes to handle the =
non-multiple
> block length of the chacha20 cipher? If yes, we should port it =
immediately
> to catch up with the v6.9 release if we can.
>=20
> [1] https://github.com/openssl/openssl/issues/24070
> [2] https://github.com/openssl/openssl/pull/24097
>=20
> Thanks,
> Yangyu Chen
>=20

There is no non-multiple block size issue here. It's already handled by =
the gluing part.

=
https://github.com/torvalds/linux/blob/586b5dfb51b962c1b6c06495715e4c4f76a=
7fc5a/arch/riscv/crypto/chacha-riscv64-glue.c#L45-L53

-Jerry=
