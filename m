Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4D314A98
	for <linux-crypto@vger.kernel.org>; Mon, 26 Feb 2024 01:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708911620; cv=none; b=VlBDvVVc3ee6k5zU2OZ5Q0Wa6pORXDsC2vtGeC5Nc71njKCMLBg4Y5n7L7KwUxlOxp2l4vKRw8HpMENxiDKBELAnM3GIQVWbPV4CcBBDUyxRUhcHguixZPJ414jKg/xLHev6onooG8xWNVS1kUc0Ga1H0RYbZadsQtnpi1Pdwfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708911620; c=relaxed/simple;
	bh=CEF5PY0v162e8nADzCCdKuh/9GsYfRE40wXrl7GU0Gg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Tq+6I/T0pth/FpZQMbHsl4idfcNTFc32VPOosti5cFTQGayPupiGJsLRA6twOkG+conRCL5cjkd0IjM/R7YYc0Fnc28Gw15lwDiXlK8DPmkgdAKcjogBHsWe9gFF/EUvKDw/Lo7OZCHvksEEZmRTO9usG/k2uFXsb4x6xaKdDXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=hh1wLVTo; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="hh1wLVTo"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6da202aa138so1605188b3a.2
        for <linux-crypto@vger.kernel.org>; Sun, 25 Feb 2024 17:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1708911618; x=1709516418; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gao7hRUfZpXivOmhIfnNUfW8TTK3M/4khJ9JgCKSDQQ=;
        b=hh1wLVTodmB84UDVO/dzjHZ9nJiQ8bE9iHVsmejcIoH9U3N45ObaMGrhaXOfB72Qfn
         JJ2sM9wdnWCkttN1oQAlcWPZlYs76LtoEacrlxV3dqFPnuDs3aQFErVXWVd5tqBm9/hw
         L6n1hUksh1huqjxi/1G/5A9q8HUpjEErXDwDchcxPxYg7rakasnV2L5NvCveyDwgDr2o
         svNk0qtlZiSXYvbNXRqD5z6ehGW4qF6dhWsvU5cVbRdH38h8cJutBQY+c6EZlHdvUcv1
         Fx3mWjoJiwm2s23qKOsOIYkJV1IDDZtoNE2Vg24wRZrUOFPkSbKXEI9A/wjroz1PXlIW
         Xixg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708911618; x=1709516418;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gao7hRUfZpXivOmhIfnNUfW8TTK3M/4khJ9JgCKSDQQ=;
        b=CoF/3A5Y0YCSdYUIXsjjQzLs9LNNmdXj+r5pXPTw4FGNxPrkv8LubjnfPbAxs0d6AE
         s0XJCxoNa7N73Zl+0rLbSp6oMKY6+gmxM/TAGRR/2N7uqPuXp+ynQkV7eV0xUW6SzA/5
         KQbJg0AlJdCmwHov/IetsaACFyL1rJ1H0khGtQrqFoS3DsZj7wy/3i3+Yyl9Rpncxrvt
         1X+3PNaSkP6RPIMafes1TwToitPEMpP4fj1yydMR0NfV4fzdA8kfvYqAXi8FMWVHwFlA
         cWA2gP70kgwamrs3U7G9bvaUJ8HBWk7H43aLzDfV7BSOlRjzBovtIxHrcU33FTqDrcbL
         6cig==
X-Forwarded-Encrypted: i=1; AJvYcCUiwk1VZKBSRbvb69XUw71g9Z6aORIHv1CyQyKlpgSjXy5mUPsXCH7hHhk3jzgRSNUdJ3HgP5AX7CIFd4t/GMmzo/I35jUsR2iMTiUK
X-Gm-Message-State: AOJu0YzpknYdysX3QTVPfKcm9hVk+2CaHqT2uspNaic10cwT2mZjBHh0
	fCdiSYi9zs2Spm5SdGYWIXVE4n8BCuzeikBbeyk1zxOQIrsea4VW4cDBZT1Pz9s=
X-Google-Smtp-Source: AGHT+IHTuQoynqJXhnnP1IcEo6E63UPeUVZkFOzSf4oem6puafXcOc8BzJSUIQCfain5+m3MPFeN0g==
X-Received: by 2002:a05:6a00:14c5:b0:6e5:2f27:5235 with SMTP id w5-20020a056a0014c500b006e52f275235mr1867135pfu.11.1708911618546;
        Sun, 25 Feb 2024 17:40:18 -0800 (PST)
Received: from ?IPv6:2402:7500:5dc:7e53:808:399a:34d8:b170? ([2402:7500:5dc:7e53:808:399a:34d8:b170])
        by smtp.gmail.com with ESMTPSA id e17-20020aa79811000000b006e45c5d7720sm2903150pfl.93.2024.02.25.17.40.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Feb 2024 17:40:17 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH riscv/for-next] crypto: riscv - parallelize AES-CBC
 decryption
From: Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <20240210181240.GA1098@sol.localdomain>
Date: Mon, 26 Feb 2024 09:40:14 +0800
Cc: linux-riscv@lists.infradead.org,
 Palmer Dabbelt <palmer@dabbelt.com>,
 linux-crypto@vger.kernel.org,
 =?utf-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>,
 Heiko Stuebner <heiko@sntech.de>,
 Phoebe Chen <phoebe.chen@sifive.com>,
 Andy Chiu <andy.chiu@sifive.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <71CC95E2-D5A2-4158-ADD2-C28216B00F3A@sifive.com>
References: <20240208060851.154129-1-ebiggers@kernel.org>
 <04703246-6EF6-4B54-B8F1-96EDEC2FBA6B@sifive.com>
 <20240210181240.GA1098@sol.localdomain>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)

On Feb 11, 2024, at 02:12, Eric Biggers <ebiggers@kernel.org> wrote:
> On Sat, Feb 10, 2024 at 11:25:27PM +0800, Jerry Shih wrote:
>>> .macro	aes_cbc_decrypt	keylen
>>> +	srli		LEN, LEN, 2	// Convert LEN from bytes to =
words
>>> 	vle32.v		v16, (IVP)	// Load IV
>>> 1:
>>> -	vle32.v		v17, (INP)	// Load ciphertext block
>>> -	vmv.v.v		v18, v17	// Save ciphertext block
>>> -	aes_decrypt	v17, \keylen	// Decrypt
>>> -	vxor.vv		v17, v17, v16	// XOR with IV or prev =
ciphertext block
>>> -	vse32.v		v17, (OUTP)	// Store plaintext block
>>> -	vmv.v.v		v16, v18	// Next "IV" is prev ciphertext =
block
>>> -	addi		INP, INP, 16
>>> -	addi		OUTP, OUTP, 16
>>> -	addi		LEN, LEN, -16
>>> +	vsetvli		t0, LEN, e32, m4, ta, ma
>>> +	vle32.v		v20, (INP)	// Load ciphertext blocks
>>> +	vslideup.vi	v16, v20, 4	// Setup prev ciphertext blocks
>>> +	addi		t1, t0, -4
>>> +	vslidedown.vx	v24, v20, t1	// Save last ciphertext block
>>=20
>> Do we need to setup the `e32, len=3Dt0` for next IV?
>> I think we only need 128bit IV (with VL=3D4).
>>=20
>>> +	aes_decrypt	v20, \keylen	// Decrypt the blocks
>>> +	vxor.vv		v20, v20, v16	// XOR with prev ciphertext =
blocks
>>> +	vse32.v		v20, (OUTP)	// Store plaintext blocks
>>> +	vmv.v.v		v16, v24	// Next "IV" is last ciphertext =
block
>>=20
>> Same VL issue here.
>=20
> It's true that the vslidedown.vx and vmv.v.v only need vl=3D4.  But it =
also works
> fine with vl unchanged.  It just results in some extra data being =
moved in the
> registers.  My hypothesis is that this is going to be faster than =
having the
> three extra instructions per loop iteration to change the vl to 4 =
twice.
>=20
> I still have no real hardware to test on, so I have no quantitative =
data.  All I
> can do is go with my instinct which is that the shorter version will =
be better.
>=20
> If you have access to a real CPU that supports the RISC-V vector =
crypto
> extensions, I'd be interested in the performance you get from each =
variant.
> (Of course, different RISC-V CPU implementations may have quite =
different
> performance characteristics, so that still won't be definitive.)

Hi Eric,
Thank you. I think the extra vl doesn't affect performance =
significantly. The main
tasks are still the aes body.
The original implementation is enough right now.

> In general, this level of micro-optimization probably needs to be wait =
until
> there are a variety of CPUs to test on.  We know that parallelizing =
the
> algorithms is helpful, so we should do that, as this patch does.  But =
the
> effects of small variations in the instruction sequences are currently =
unclear.
>=20
> - Eric

