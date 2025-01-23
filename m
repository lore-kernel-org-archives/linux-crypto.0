Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A724215A843
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jan 2025 20:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737665572; cv=none; b=mavQ3OrSXCqKIDsZJF0RWQTYnBBqi4hpPr9Yu9gr5GqDNSA6hdoE+byKsNjJV90uYrz/Yv6mf+7qDeKr++LQ4pu6iKWq5GL1tYb3BpCqYK9dvaCUMm6UJJkejfgGCCMe/OBvZNpPnQKZxn9UjWMfmE42x29naaCFQCAQtVhwR5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737665572; c=relaxed/simple;
	bh=umvZtUOcZ4eMvUvMwmzTobdFI+Zc5dz0wIQdkuFEjiE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CjRNOm5Dr6KJDJKUCj26HbC8X4qq0XCN8zi926IKTsU6Rwi8OZt/WFCsEZTMlRYridGqGboJmLJBGzVC8A6Ncshh+zitCK8wkM+EILREu34ViGJjQ7PuWqju2Pb3FUDjqCmhElcMiKFwsH8UGgkWzeuH1gx8JMPr6w0dBqa2n48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NqlbP+uY; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NqlbP+uY"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5d9837f201aso4677681a12.0
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jan 2025 12:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1737665569; x=1738270369; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=D9X54sbj+5rdlWF7lleGQ51wG7d0xub/Gs104pSK+7Y=;
        b=NqlbP+uYsKgeRlQIMvOn7p/DFvqW/Rq444KdCsbL7PDzVPCPtlYRgYB9PFfDMixCaV
         g26DvA2ywTjAgQl1M6MwalL9QVMLM4BrSA8LTdHVIZFiQXmkT3IZc6jVeEQQCxKAX4bC
         +ScloZBXyanUsFLGpFHhE39CUaFaKKwNDbD1w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737665569; x=1738270369;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D9X54sbj+5rdlWF7lleGQ51wG7d0xub/Gs104pSK+7Y=;
        b=E1F0fzCBRCTFzxKG8SivXHSx0Nq065XMPX19aaRMK+B4kx9JHW2HS6Q6Kgp+soAiec
         EUzjubvVKskFaX8oK7hb4hI4CVu6m25Csd165U/xRb17C9VtUbclsVw+wsZttZXVJGOj
         HpnZMflA3YZDfc5C7rv8z00gEvps/tXSauWBq+XBD2hQeLZ2cEsKHfPy4//4EiDrwfby
         FzKPJN38J7tfCWEf7XloxaXLBvVPUNMhn0yP+wNVTwtuHkn64NQD4FT2+ety01a0GhzL
         ygrmuTNhjdAYZ/jsunxQFzpXl21YR/0dXm4i+6N6L89VvFbx7Zkbou5J/PNSOe+hUsPH
         YT4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXgrbSDokJRUrpRBKBUBxwoo8T4FTBMu3ALGQr8lSlA7qM4417SUBcYEj+k03mjpCq1IzAYA5ejGP7YFNs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQFkUkO943w8DYtFWEvfOknshik+kjxFYLv7fIH0QOn/osutim
	NtP6sn0duqqsCmGZ4v7x2wd3aok15csx/hJVLc1Opgql+FHMLOniRclN3ntkf4NBsCGsf6fgqH5
	qlB+dEg==
X-Gm-Gg: ASbGnct9EL/K/oWBV0HRjZa1RHG+T10uRhYg7Pf70arhDPT6GJH4+8d4ll8mYlBmErY
	3OyX4AOawRX7y++bTIkaXYUONZRlsxRvNIHlG3auWjT9qeLPl+Z4aLzeFdB3GBf272OgYU8PMaG
	TtFMl3fhIJT1rqEhwRox8T8htskx6e4gHzR3iWA9dW377LT4iFh8sK7cpxjthJatkw3BNgRiv+2
	gW/tM3zcvdVw+RGoamqWGUV3K4rYYnkbjq6kk7i/Aex8Z1+YqCZHoW+YKG4xg8cFNCAy1wYvPRq
	asu7PLQ1I8PfyYyx/XyO7XQk++dLamKBFVyUG/+IiVOb1OPXmq8GfyY=
X-Google-Smtp-Source: AGHT+IGedm4XfEpDncRGvI9hXD5zFrSyxh0HF1Np68GLJZDaf/exLxKfZ36uehDsQKUK9Og1aLipWA==
X-Received: by 2002:a17:907:1c1c:b0:ab6:58e4:4fe7 with SMTP id a640c23a62f3a-ab6745c4653mr56582666b.11.1737665568820;
        Thu, 23 Jan 2025 12:52:48 -0800 (PST)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab675e631a2sm15949766b.48.2025.01.23.12.52.47
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 12:52:47 -0800 (PST)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aaf6b1a5f2bso505909566b.1
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jan 2025 12:52:47 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVFgFw4ILTs/1oJzGuUIXMlG8/9cevjoyUwlNIQyuFnATWBfz7qWcOr++HIHVjEle4voedMP6MMysGEbu8=@vger.kernel.org
X-Received: by 2002:a17:907:1c84:b0:aa6:9d09:b17b with SMTP id
 a640c23a62f3a-ab6746df0f3mr56503366b.28.1737665566782; Thu, 23 Jan 2025
 12:52:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250119225118.GA15398@sol.localdomain> <CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com>
 <20250123051633.GA183612@sol.localdomain> <20250123074618.GB183612@sol.localdomain>
 <20250123140744.GB3875121@mit.edu> <20250123181818.GA2117666@google.com>
In-Reply-To: <20250123181818.GA2117666@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Jan 2025 12:52:30 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiVRnaD5zrJHR=022H0g9CXb15OobYSjOwku3m54Vyb4A@mail.gmail.com>
X-Gm-Features: AWEUYZnxOBX8k4LP6AfWgf5M9Q_7g-oQx-Y19UjsMsnwJwZUs9ea7W9WHxqXVcs
Message-ID: <CAHk-=wiVRnaD5zrJHR=022H0g9CXb15OobYSjOwku3m54Vyb4A@mail.gmail.com>
Subject: Re: [GIT PULL] CRC updates for 6.14
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, Chao Yu <chao@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Vinicius Peixoto <vpeixoto@lkcamp.dev>, 
	WangYuli <wangyuli@grjsls0nwwnnilyahiblcmlmlcaoki5s.yundunwaf1.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 23 Jan 2025 at 10:18, Eric Biggers <ebiggers@kernel.org> wrote:
>
> FWIW, benchmarking the CRC library functions is easy now; just enable
> CONFIG_CRC_KUNIT_TEST=y and CONFIG_CRC_BENCHMARK=y.
>
> But, it's just a traditional benchmark that calls the functions in a loop, and
> doesn't account for dcache thrashing.

Yeah. I suspect the x86 vector version in particular is just not even
worth it. If you have the crc instruction, the basic arch-optimized
case is presumably already pretty good (and *that* code is tiny).

Honestly, I took a quick look at the "by-4" and "by-8" cases, and
considering that you still have to do per-byte lookups of the words
_anyway_, I would expect that the regular by-1 is presumably not that
much worse.

IOW, maybe we could try to just do the simple by-1 for the generic
case, and cut the x86 version down to the simple "use crc32b" case.
And see if anybody even notices...

              Linus
