Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C25409620
	for <linux-crypto@vger.kernel.org>; Fri, 29 May 2026 20:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780084942; cv=pass; b=rw6jWTf3XGvURhi0rbzn1NMGNMEJSvoPV/HSC3ygKIshlHg5lU3l+WaKr2i5jKTOcsUneYKxXAfM25YeV+PUOog/4YlXrzuCM02dJt/BnBquG3dco0ulTJmSSs4m/VT97jy0PcFF5unQwiV3/6E55gK1d9q7GVUttywsQWbqutQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780084942; c=relaxed/simple;
	bh=Beybb1FQvkJhoq0J6vM+xZ6YJFGMgrZMkSVqBvo/3So=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jkQBKQQeOqFhYpjszWisDJhD4jOkq25fRZ01mzjUVUsMmORs3jMHAJ4CeLtBokEBGoSceXVnfuD1g6LjfJ993P+lGNVFeSivP3zKQda80KilN6tZJ8KE2JwlL1UKTncUBES2/9XI6xrI89agwrVvkcFuMNAnPciRSdwCvcTwF8Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n/AHk6rW; arc=pass smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n/AHk6rW"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-304e5d3cdfeso85828eec.3
        for <linux-crypto@vger.kernel.org>; Fri, 29 May 2026 13:02:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780084939; cv=none;
        d=google.com; s=arc-20240605;
        b=GCTf800m4CYYbKpuYCFmXvRtH7B2R2775Mb3OQBT8EluzeZeNMuZxZzXKdZ+n/V7Wz
         x6RAeyrTLrO4NRrIYMKKLg9DFAzABHQ11r5eAhthkg70FR5DDsTGuISVOFqC12KWIoAV
         luTj0Btdwk1AGOa0yo5t07pQ1s+7k27ZSizIDXCTH5y+X/BPrq1WwI2WwJ/QZeWxSbp4
         OLfbvKyTywQa6B96E3/aeTThQf0DI95lsOppNvSMjzXAbd8nHJaB94Clk9StpB4lGsEk
         B7gB+8urtQ2pyJoqGVuDHSAnTpQdiqVWxEgSVX3c3LK5jhTYyqjBnjRS+QmBnj+B8HeJ
         Mczw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Beybb1FQvkJhoq0J6vM+xZ6YJFGMgrZMkSVqBvo/3So=;
        fh=w++Yc6W/z2Jfv/ySPtcbEiTG64d7n9sH98+AIyENcGg=;
        b=WKAs/aoVk07jcdEV0Ubr+URIdJ5Y0m3URTMsjnWuoy2fslpTwRalhlIYD088fdaN/i
         VF/BqfF/cXxlmkV6sG2LroNst2MUuJvj15JakMgtVPoqVb58JhWApv3i7YLQLlpBY7p9
         TMvrPoegzfHqAhmumuizZT8PbZJkmB599FzcHiiNeQKIzD5mqc6E8mKPAzIebgneJm1L
         Z29QBOSbGRv/enWYF/K92+D5DBVOn/7aUt+jSwK6Ysz5rvPB91RoVxwC37yc2/52LsFt
         Ke750CN30n4LCSXfDfe0iH+QwHv0HFdLDy3stxh0xqAtYn0FqVOjeobq/gMGbzhYCoeS
         TYSw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780084939; x=1780689739; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Beybb1FQvkJhoq0J6vM+xZ6YJFGMgrZMkSVqBvo/3So=;
        b=n/AHk6rWv5gDyOFvDtsypN8sY+VzIlykz6oxBbRr9kKx8W1wFqSkXUKlsvYXP21Esc
         yd71gG6Po8uTengblAis3hxCsW5We41m+dGTd43U/8NHyMxtO5+DVL/Hc7wPm4wr3VS+
         TvbZfVS8/SDEIarM/K2UUUtA00ezMMdTVbrXi6eQ3oTvqMFp3kxY4CxfrWmCm+2T51TT
         yjDDtYbkWRQWSRO3crk0TXcoor2VVw6j96DT6bRiWe0Bl+E4aP69qVssJNjzQMGdjoZh
         zxqwN+puSF1oOHEUOUE/OHwffdHhG6Q3QTS1dXMdKvS/MlivO8C/wy07VrfH23Fz+W0D
         Zp8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780084939; x=1780689739;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Beybb1FQvkJhoq0J6vM+xZ6YJFGMgrZMkSVqBvo/3So=;
        b=Us58A8fOfZdHoV3qE6Dcp0dJX7gsUafGFkrrVmYr0OvIkhMbE47nXzqRN3wW58j8wX
         G1J+pxpdGYWlAiVTdZLDoCnaHZi5Gkvvy0VCcAibDMzFFnhOeYNVgbSUQH0ZWcX3aYpX
         YVhK+myX/EjNq0cQXf42l9f4mmAqFmuMapSuEHmXVn4/eXvTroYX6Klpo87QKv11Y6cc
         xCGqd4ahKqg2/g0n0UVc0VAU5Q9mzUrlQjWEnuttn2TlXuE4HvUrdlr31jmcYpBGJXJG
         noVhKvNbDV7RA9+m7/21zakyJl5DOGCVDb4Fg6v6XazEy0Q0O4i5oVnoeWANB/Uq6brB
         anhQ==
X-Forwarded-Encrypted: i=1; AFNElJ8ZPEZYAqvfAIvmofSosTAK5Wx26EngJiWcldj084urclmrjghhULNo14jbZQLuFQrWdGz7jFbcLV5ItWI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcJmAY0ATf1Oi47of2n8Xr0f+rIbsrY+2BQSRc8GMzps3wl+Ef
	TO3QK+4hUgQsgVpRUyuFh+E7eFJEg77i7nuMfoZTjrERmyo/cKxS56UH5tGqq6SM77y7oDG2pHz
	X/sFdd5Jik75mOFLg77i7F/rrYY+o48I=
X-Gm-Gg: Acq92OHKGnod/DjQz7NKAs7v9dkQ22AFDqd7a9wRj+kgiOP/FAqy+tS7RcNf9h1K5vC
	H+xigSnizks+9CMAT1FF7zMiwmZyxq5t2jYYBCJmScqS32Yx6Yw62fBe2WIXwLDC8Op3L6nufJb
	n6pShRQ0RWWllTvXD3vo7pGKQvhIC2NEf2z5CsYgbwtdzgcpFv6g4r9Y8YfVYxPbck5K47sdbxy
	LtLONEBKSyHP/4FsK92OG1BJ3/c9dvVpxXXgrSRI+CtRcvAGjcmXoeYaowDZndVemSkQ79lEgLK
	/XV/LqGEUAv5eXWJQrnQ5Djx4NR93TAkEXTGmDBkCboITXrnqCiKPwSpPaVX0dZtVlDsyjNlMBA
	ozx0szkuQk1LWfU4I/TPBjdS7582siYGZVA==
X-Received: by 2002:a05:7300:ec08:b0:304:2af3:5fef with SMTP id
 5a478bee46e88-304fa70effbmr272371eec.8.1780084939083; Fri, 29 May 2026
 13:02:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260529-rust-hw_random-virtio-rng-v1-0-b3153dd90311@pitsidianak.is>
In-Reply-To: <20260529-rust-hw_random-virtio-rng-v1-0-b3153dd90311@pitsidianak.is>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 29 May 2026 22:02:05 +0200
X-Gm-Features: AVHnY4KHpD9FOOlIQlr-gEq0KcBxVKz5BrteKsdhYuqZIzkx0FbA5_J74LcTsoc
Message-ID: <CANiq72mU=yQ_L_D6emvTj4c5E_ankLFvpXzkE7yTfcYfLB5T=g@mail.gmail.com>
Subject: Re: [PATCH 0/2] Add hw_random Rust bindings
To: Manos Pitsidianakis <manos@pitsidianak.is>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, manos.pitsidianakis@linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 29, 2026 at 5:50=E2=80=AFPM Manos Pitsidianakis
<manos@pitsidianak.is> wrote:
>
> A virtio-rng Rust driver that uses them will be submitted as a separate
> series since it also depends on the virtio abstractions series.

Please include that at least as a reference to a branch or similar,
since in most cases the user is needed to evaluate abstractions etc.

Thanks!

Cheers,
Miguel
