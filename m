Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F82A31328D
	for <linux-crypto@vger.kernel.org>; Fri, 16 Jan 2026 22:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768602621; cv=none; b=bzsLtfYwOrosmFneTbW7Y4n6Ybv2MSBnnxY9l9hkFDOrAi4SjFu88/I3aRIqWF7OAQGDTbPh85tswtNmi/XsptYizagoNjNvPch1GOKqSIe5bZch6MFRkrL2lZLDAQdVABp4v5cM2yhTSR/QXtMtX26S8vovSYfG79qo5q9qPwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768602621; c=relaxed/simple;
	bh=dG/D69cqK/Ty2Ep6B4YLN1bPeHBFFiRmxFtpxPoYyew=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bvxWwnQNFJNxvVdBM75wOM4l8/CZAHPbmJVptLlECrGoVhbRFSZrrNyDjsX8C6ZcxcbmQUK3nXZEvSw4aT7rCf6gnJhS1tfHjK4l9vbaubZlE8lIY/oHE7OLhdzIsBdL+2OiupzhsKCXzwF6nbzVf78DDZmKyPiVMqmGz8n8BF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TcKDICdo; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TcKDICdo"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-432755545fcso1472031f8f.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Jan 2026 14:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768602618; x=1769207418; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lxK0gotd4uJBuq5yCuZa4Y0yPqnCu9xY2SR2B7d1Ka8=;
        b=TcKDICdoWExfE5BhoohKDTYDqMDlPUbZieR5kHLup65eobKkVHYHwxn+DNRXuCAYNl
         JJDjqKpxOpchPz9jA70ZO2viyQRMxXYwGgetOfxeorEseovUPJOwS99uOGjVHmpdAndn
         AxC8Av00sbVzRk55YZzf1+4nqXlqUex3PmevPCRtrJDDbVzNEAWIODuP9FSawV378Ict
         W/uyXpW9O2fQY2pyTgrXtC7zhQJIvYggXiAHWFiDZ6Z9l2rr/LUTmMP67J2IE79iSbiO
         Vv1Kox0Yroik7FQsu0bnVuOIosXzNxIJklLdBfn2UwV0fUH1qsjNL/YO+FSIApxxi/jP
         hb9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768602618; x=1769207418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lxK0gotd4uJBuq5yCuZa4Y0yPqnCu9xY2SR2B7d1Ka8=;
        b=gFbAOMFhPE7Myya2QSuz29Tppd1/v203AvgKP/c3mWTK9mPYLJynZ+UIiW/UMhc6MX
         cgVhlGZg4dXPKzeAKQ57wufS1kRGgcyftw6eTz47lbou1tdmIKdesCp1nQHoI09DNFx3
         QE1AMF4bs4De96kk46blCIXiLXX6l5TZ92ADBdl2Gg/n+x3sXlj4ymOmjomlHUSM6UPG
         rP+JlfuAgCiYp93LKobCUqiirZIoJkbt3DVe75dxDEAvKWKS0W+pe+4QyJyC/xN/d46P
         3Epp4+5iyjXhweoU0ZCUA/HAAsj5QbmRBaoXIoDgJKGLeESy49gJ2fQwU1VkzJTdNE2j
         PINg==
X-Forwarded-Encrypted: i=1; AJvYcCV5KwxblK4lQF3jIQ74mpSBIW3yhCJJZZgf9x7EUb5Zgx0WZdzJVdBEXNeYWRbMUKj8Gee2p0bEr+BgmLQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4G7Aa1yZNKZu9dZcX6h4/XjSA5octXQvNrwhYXLzb1qeLVMoJ
	Im20CWFfNNMzVqEKOmpjdyrfsMc/344EYszs+aPl9Xum5bhihHFpuY5V
X-Gm-Gg: AY/fxX75xGpp7HClB8V4Usm3+/ynzGxDDWHEG0r6gFIr8M8WqTb2yf1qY0yvEH1aIFi
	brk99EntzR9Efp0pjakjLLTiBfYcrVrIhtDVJL3PjR7rYsCiwLTfWdHl9WArSI1YQ1zCSF+/amR
	wnnIE9HVlzCxq4GyOUGj1NwJDLCerSAFfiHC35Bh9YfG8JWe0l2AG41PQUJxp7DEx8fItUAFc8Q
	ZxEClFU/64+KBAWTHmlzoFtu4K9TAAUvjTFfDUXR0MFFCYX8w2Uz0TKmlxTgMflbkYiaOPxCt/a
	bEp4MDY8k96OHSd5utad5Fa34RxNhFNMa9e+IQpBrsSYe6cwOfpwDn2uaajlZC+zvA6Mr1v5ggA
	/50udjAzmYNbvtQw/BTO6aH8p9vZy8MiyfEUJL+59toiLB+8cLMEDeXnUeumNfujUMljpEybV/h
	7cJttUNWxgvlz0VCgsf/8xdf9ZeQkTOmAvmYfgnaUoRdVxU5bdsRNq
X-Received: by 2002:a05:6000:288b:b0:430:fa9a:767 with SMTP id ffacd0b85a97d-4356998ad3fmr5550380f8f.23.1768602617490;
        Fri, 16 Jan 2026 14:30:17 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435699272a0sm7655699f8f.17.2026.01.16.14.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 14:30:17 -0800 (PST)
Date: Fri, 16 Jan 2026 22:30:15 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Harald Freudenberger <freude@linux.ibm.com>,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v1 1/1] lib/crypto: tests: Add KUnit tests for AES
Message-ID: <20260116223015.60887d5d@pumpkin>
In-Reply-To: <aedfebcb-4bca-4474-a590-b1acc37307ac@linux.ibm.com>
References: <20260115183831.72010-1-dengler@linux.ibm.com>
	<20260115183831.72010-2-dengler@linux.ibm.com>
	<20260115204332.GA3138@quark>
	<20260115220558.25390c0e@pumpkin>
	<389595e9-e13a-42e3-b0ff-9ca0dd3effe3@linux.ibm.com>
	<20260116183744.04781509@pumpkin>
	<2d5c7775-de20-493d-88cc-011d2261c079@linux.ibm.com>
	<20260116194410.GA1398962@google.com>
	<aedfebcb-4bca-4474-a590-b1acc37307ac@linux.ibm.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 Jan 2026 21:55:04 +0100
Holger Dengler <dengler@linux.ibm.com> wrote:

> On 16/01/2026 20:44, Eric Biggers wrote:
...
> > The warm-up loops in the existing benchmarks are both for cache warming
> > and to get the CPU frequency fast and fixed.  It's not anything
> > sophisticated, but rather just something that's simple and seems to
> > works well enough across CPUs without depending on any special APIs.  If
> > your CPU doesn't do much frequency scaling, you may not notice a
> > difference, but other CPUs may need it.  
> 
> Do you have a gut feeling how many iterations it takes to get the CPU speed
> up? If it takes less than 50 iterations, it would be sufficient with the new
> method.

It may not matter what you do to get the cpu speed fixed.
Looping calling ktime_get_ns() for 'long enough' should do it.
That would be test independent but the 'long enough' very
cpu dependent.
The benchmarks probably ought to have some common API - even if it
just in the kunit code.

The advantage of counting cpu clocks is the frequency then doesn't
matter as much - L1 cache miss timings might change.

The difficulty is finding a cpu clock counter. Architecture dependent
and may not exist (you don't want the fixed frequency 'sanitised' TSC).

	David
