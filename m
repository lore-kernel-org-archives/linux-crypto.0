Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FE724A077;
	Wed,  5 Mar 2025 14:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741184818; cv=none; b=uCN7JUg8Z/0kvO/2zizBqtA+fHVD9HVEFUZDuinlVVeHkADsTmoAGRi0Wxs3BwyxLsfCs3hxCoLxhRah5zmeljS9zU18Fhr1t3RTYsM7sXI94XRA2xzqXy922Yxx0RHrjxFrtl09eJS+mcpc3Z1/wOHhGYEG0/Kk8vm5IC9bCa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741184818; c=relaxed/simple;
	bh=eUK2lpiP1FoSgc9h1gORMk92bbuPc9yvLgGu1Z6Qwhk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=awyAYf9eC5X0ofKwZOfpw2stFOKmLglGE0XteYt/vHuYr4Y8rafvHeNMKaoxKMU6sBNWZkk1Ku8q0kcO4muOZObn3igeNmvXGiIlP6FvYMlLzttCddwtJwOQNs0NqAEExaLXAcl5YVRa2jIVgXuVwUutYJlE/8xEt4j/UGsWPqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jDfRs4YW; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jDfRs4YW"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43bc0b8520cso22445615e9.1;
        Wed, 05 Mar 2025 06:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741184815; x=1741789615; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5w41DRiJ/9J1ZtMFKS35HZz81JTi9tqzjEpSgeekIgk=;
        b=jDfRs4YWY9ZTDNq0IjY8oATG3naABg7HWzf/ZLoyifBgDNsRmW2/GBhqaOAOc+0ByG
         V7O6XIWaNbH+M/5mzQ1aZC+Ui7crxaH3J3WepzjCKN3atJWrIVGXDwMqbnT/Knvtq3GI
         fEkC2+bobNkcH5SkOJ2MHHxGiL/usyx+6MIrf2uplgBpI98VPYl7SYQNaz56RoskZC0W
         QHtIX8TnHM6qxCU7sARlMbtsmIse/4QdFa40nr0Sn2FLPGeRyvoMGxdAoyWtqy/dy5xR
         dq6Szkqjb8DOW/Psl4ArOMNuZyMoixvAO1XJXoUPfmo9Ldo520K+Lkc1vyE6o18/UsSY
         Oj7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741184815; x=1741789615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5w41DRiJ/9J1ZtMFKS35HZz81JTi9tqzjEpSgeekIgk=;
        b=iEEndm8YSaicMgEoxox4y+h+QH+d9yR4g2C2XtYj3heX9x7CHez0JozHp8YxnjziJo
         Rvy+1BgbhiMkA3lRkDVMOJoQnpLC+HTIsgeIXYizRKvdgPdSHejVH2gwpShYI7FEUIFv
         z0e/XX3TzPd+En71uDBtXcMTONA8bfU2p6FcbNR58UGHNQC01gcGAUETfm3WZyVM4q6F
         AqEz5h4V9vhQodxuPvFhJfWf3jMJ4rE1ewsoC2OVMci+T/soqlW84S8sPKivjI0rmHoq
         2tsESewF5JuX/OyvIIQAFrKhD7sXE4lacosqa4dX3xGsGMMeK6+e8rzVhHKWxl6bWoVd
         c+iw==
X-Forwarded-Encrypted: i=1; AJvYcCUyeC3sWqbVjjMIb8Yan2H9Esyhp094n9TuaL1NvJuk2tbGIcmPRJkJvjQEiwzY2Bb2xVGbcwie8kJkFUw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxmmnPR7daN49yTiTRD+4pW9z8T0uXbn6H4aS8OYQ3KVZGtvrl
	Knekn0UY3RmdGMN8j/8Rkxv83ZxTXE+Phk9J6Zf4LRCYWty64toT6rHwFg==
X-Gm-Gg: ASbGncuWNB33+zmaQDxKlrPyNNgyFOOgXxQR0uBBeMDPTSIqf6qW20e/sJfS2boadvP
	d0YBlwiP3inobZcPGwyXroQKjx5egvc1us9U9rRwahGwF5x2Wq/IOehJqGs1jIcfS2Ju68evb6v
	Y+9N+R9l8wl7EI4c/iEjYzikUKgyhf2uvUdNnaumwz/b0jpxuhRKimrk1XS3/xM9xEqF7izLapT
	Y2UliPT0jSeD4Oa3wra5bCnCWDPucHZ4NrsiwS+HO0dCTXEBIsaKcUyzEAyG0cOJfbZBo1zdO0+
	itFNVnUMIqpPLO6pniEKTyOwej6BJl7x70Wel17C45i26FoQUorK7QiPFXG4E6fN/zaUVLzAezo
	5grRSL0c=
X-Google-Smtp-Source: AGHT+IF0B41RHaO5k5y1Clubg7F9JL3YEVmmZXW9Ppx3hJLmnuQaUQzgcDjx+6PEq+4SMBuJY10G4w==
X-Received: by 2002:a05:6000:4007:b0:390:f45e:c84a with SMTP id ffacd0b85a97d-3911f7cb10fmr3522154f8f.48.1741184814990;
        Wed, 05 Mar 2025 06:26:54 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e4848252sm21356612f8f.69.2025.03.05.06.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 06:26:54 -0800 (PST)
Date: Wed, 5 Mar 2025 14:26:53 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, Bill Wendling <morbo@google.com>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel
 <ardb@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers
 <nick.desaulniers+lkml@gmail.com>, Justin Stitt <justinstitt@google.com>,
 linux-crypto@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] x86/crc32: optimize tail handling for crc32c short
 inputs
Message-ID: <20250305142653.751d9840@pumpkin>
In-Reply-To: <20250304213216.108925-1-ebiggers@kernel.org>
References: <20250304213216.108925-1-ebiggers@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  4 Mar 2025 13:32:16 -0800
Eric Biggers <ebiggers@kernel.org> wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> For handling the 0 <= len < sizeof(unsigned long) bytes left at the end,
> do a 4-2-1 step-down instead of a byte-at-a-time loop.  This allows
> taking advantage of wider CRC instructions.  Note that crc32c-3way.S
> already uses this same optimization too.

An alternative is to add extra zero bytes at the start of the buffer.
They don't affect the crc and just need the first 8 bytes shifted left.

I think any non-zero 'crc-in' just needs to be xor'ed over the first
4 actual data bytes.
(It's over 40 years since I did the maths of CRC.)

You won't notice the misaligned accesses all down the buffer.
When I was testing different ipcsum code misaligned buffers
cost less than 1 clock per cache line.
I think that was even true for the versions that managed 12 bytes
per clock (including the one Linus committed).

	David
