Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308DD3C9EF8
	for <linux-crypto@vger.kernel.org>; Tue, 25 Aug 2026 19:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787685624; cv=pass; b=BZx+Jr/axfTDh/VmNVN/KQsh5qb5zB0lFh6v4vrbhILb57/sy36FyhWF2DA03gvjQgCzwFslhhbvjROLqdbJQ5jZCsZ1YF4HfqHdylubfyHUNpPrf/hXuG5FYioRlX9kJwGulLXKD/smn9JDzIz63bZxb4ApPEl4mqYMXJEJdUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787685624; c=relaxed/simple;
	bh=xkLEoNeBbWtVSN7j1O8Zov7Y8VwgQr+BliodPWhjLJ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BoO8x8eFUksctJ8LkikOx5Ae4hNeR9ZEq9ZbR5pTAvnvdEsSGwvo8zNoK62FJAfnwtCd192qOs1x8kjY4b+MLNwrgbW4dNa5HzixoJy9tBpZ1f/DEe5sJo4o1NW88aBaDGN5eRbVpP3JtAfitOUBt0mM0/V6lV2yH4673OMisHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=goAYzks+; arc=pass smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="goAYzks+"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cbe4c537ad6so16343a12.0
        for <linux-crypto@vger.kernel.org>; Tue, 25 Aug 2026 12:20:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787685622; cv=none;
        d=google.com; s=arc-20260327;
        b=pEu8gL1t+jbmARYSRUT2SeK/WE/9QX9Yt0PIAZURqJ90QJV5IYpyTv2SHfD/5Jdi9o
         AdlzPPSGt2SF/32TQ6Nah6a8rEfz4xHdj1jWhx06gY12m3br6KLdXBeNINmLgGVaw8On
         kgN5ehHL0sGFAIIAX/Nlnm5seNAvesBbNjashvpI9A/mQdFKLYhkuf/pYmG/3szRxc66
         y0qMJuO3OXxOtEI5C2jkmvxxVUgoQJJ8fgv7ydBnAogLiwxyplG8xvPqT0g4Wv0c43Ft
         MQ3YSc3DWgmBOFpq6zwXNOCwBdotR6hu+rAp1DEVMtV7bLqk6vcZ6fRrTvsWSGrfVi/N
         4afg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xkLEoNeBbWtVSN7j1O8Zov7Y8VwgQr+BliodPWhjLJ8=;
        fh=7YQIpIjCSHvhDOs2jQUY5aeXtguN0nBmX4NpSlOxfoA=;
        b=gsN8V//iqO0G6OWF6ZNMIG9X4/+q6keIyfBOqNjPSEv1/F2c8cZkbnf25rTu80L69b
         WlIIPvh8htBLA18Z94bpUETPpq3uLFpQzQRKGBCgQjMS0IelrtY6E0sI/cm7EhcNme9J
         9D8jXD/7Z++jstmpC4WbLyWH/tKFW7hBny7iJqW3e6rQ2eqsuFwJz8bxuwrhxTE7/WzP
         k1qyYpGjNUCoc3x2VtHuJgpQUkRpNw9LoNHMDM1ZY2L9BS/C/J/itRuZBBnBy0lxl+CJ
         woeaQQKmcd7am1tfizvIOSGhI55vINSpeZ7X9iHqJDHf4/zNII7Xt3sk+WjXk67I/egm
         wWEA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787685622; x=1788290422; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xkLEoNeBbWtVSN7j1O8Zov7Y8VwgQr+BliodPWhjLJ8=;
        b=goAYzks+5Ki/4s07v2M+O7v6WQmZ5EJ0Lp2+u/FSiYVOLU+wSkX+u4pLsIv/hjYvw+
         M/yIhnzR+m8L9BL2X3te0hIHujnWS548glRPRayxu5+U/QHxuC8ytCb0piyB7g7zQL0g
         whMNNf5cQYvWT6w6xwfW10zrHpTzy8IXncUkr1u2tgGDFnDCdPF9UsBmJjT/blGxz6rh
         lnkqX4HIN3EotfUjuaFLjDdwxHhBgwC79MLhpkJuC6R+cdzHzlgS7m/6W6/klpFoAVVJ
         R41H83gjaFSsD9oPEz1HovKSpgw8/DCZElKQipOR4z4lUTW46S5HyGppklvS8txZY75J
         rXGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787685622; x=1788290422;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xkLEoNeBbWtVSN7j1O8Zov7Y8VwgQr+BliodPWhjLJ8=;
        b=NRyQrnp+MmWlWammFzQngV9kCaxc9VCihv/O/g2WdIIR8Yyza7XcCLYijQglyWBDpz
         2Y79veF/g5ZntvW3a+pyL90EniSBMlpdzbEE3L3cwD6j1lxBkosn2FT0s7J8SClL+NqP
         IuzS1mfKbSPMzKg30ONOCA/2zW8BYdUVkc3VUi9oW4jk6lvhUPZPlo6lYKDz0Vzx6pu5
         p1r2cB/CbDNP3SYAvXFzAYN1GQPkku1mYkH2B4mrNxrCTOGPsW+wwR8ubHgSC2oD4yRO
         gH13ZjrOWvdS5PgPLD3Nx+1UpxajybDBvKXQdSHg3OTiH54PEXI2sXnaLDLNHCBsuZSM
         LYVQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpoe9vrb9rYrTOG9z+vBEfbRCKpEhvz+LXLaolL1C9uZLezceUk3TYJaz2/IdZ88LR936FJMOJiP+lGEQ0=@vger.kernel.org
X-Gm-Message-State: AFuF++nG23EtHnBXEQNk3BI+AVFcu/9O4BncdkkIgGe1BeaBtGlGSjKM
	WnOGm3grea7fwSNMoEa+xgHj0NrJKMz5Un1NrwnTATOhXF9vP+7CxMoZjhwBfHDmwaVlxNnsEB5
	KoCUbjf4aGz+QrvbcIxFqYVYO/4JU+Z0=
X-Gm-Gg: AR+sD12v2hSbor7RU8obWr+4f2uE+NHyC6uW0hQEVPQRXsPUPQBrIY/4R98WQ2T8d9W
	8NzjsnQFtlo5NwX3wJqAduihf3XztGO2AW89dMH/gI+7NeOT2cu2ROHq8oKG1A1IFPNKKncl/ZD
	NO/Hy/4B6r+s8FuPaMpybna8IS9JsP3TOpZd2KRksSfgYQ+b7REk7fuGbAhAHIC9P8ItdUKE0C9
	E8GB+BKQAinCnT105J1hFsMH0ytZPrJ7CxQyc/C6hpToFiB2/cT1Pl87uMOG7AUAd6n7NaNPeMJ
	B7atkQIkFpvMyNMXrdpZE2N5Ey8ESDvPUjisS0ALzrvVYmBIjFOLr+YAAIgBA/MOR93yuKhtUdU
	2OKA5zSvFnTJhtxSfFCbMTyOSR+8muB332Gbc6jLXfQqsjg5KFmg2ekSSIqCMKoHcBxAhC0o=
X-Received: by 2002:a17:902:f789:b0:2d5:cbd3:8eb1 with SMTP id
 d9443c01a7336-2d707bdebccmr3413445ad.3.1787685622061; Tue, 25 Aug 2026
 12:20:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260820-gb-uart-transport-v1-0-282da14ab7b7@beagleboard.org>
 <20260820-gb-uart-transport-v1-3-282da14ab7b7@beagleboard.org>
 <20260821030018.GA1961@sol> <93977935-ea60-48de-9d13-23454e038c18@beagleboard.org>
 <20260825175625.GA3673306@google.com>
In-Reply-To: <20260825175625.GA3673306@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 25 Aug 2026 21:20:08 +0200
X-Gm-Features: AcwNN1X5Bqs8KXrNiEWoe8c0uoNxGkwdgVcb-4DayQsyE-o_UymlYyy142l22eU
Message-ID: <CANiq72=uUR4Vo9W55Kq6tQjc+6Q4_+wiWhCo-VLdkvg6PJeoAw@mail.gmail.com>
Subject: Re: [PATCH 3/7] rust: crc_ccitt: add CRC-CCITT abstraction
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ayush Singh <ayush@beagleboard.org>, Jason Kridner <jkridner@beagleboard.org>, 
	robertcnelson@gmail.com, Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	=?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Ard Biesheuvel <ardb@kernel.org>, Ayush Singh <ayush@beagleboard.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, greybus-dev@lists.linaro.org, 
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 25, 2026 at 7:56=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> kconfig options usually should be in the same directory as the code they
> control.

The code is conceptually part of the subsystem, and will eventually be
moved to their directory when it is split into several crates -- that
is why we have put the Kconfig options in the subsystems they belong
to.

I hope that clarifies.

Cheers,
Miguel
