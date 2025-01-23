Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5E81E884;
	Thu, 23 Jan 2025 23:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737674276; cv=none; b=RHqsuyMNU0CG8GZfg3GS5JUtgYcclcu4JbF/1/M0bbQzUW+QAUhxiuckZ5115k0mPTWbbr5uRz+SfbSUOgUoHbF4U03pVRRGLSZ3auIwtE+2hDeuhRE6yzBvfa3vUonD1G5a2Ws/iXXf+txjzI2YV10XFXNBjZ9pzChEN5fIkxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737674276; c=relaxed/simple;
	bh=GTTdIWKImeZAhYdGYyxD+3Fe7uPbMqELUhWLqcDKsOA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rixI0WW9YCeN3YlRSPAIVfgzwqj0fuLCBQ3ZiKcV7q0U5NtKZyz0bgaLCa/rGkDwjxBLavPfYEmcHsHQVCjTXWccYpN0/SVMVvSezKT6TZOaV3EpnWKCw59zMpIznN1jmpbywuAPpGWeu46DRbNvnpH2gNdW4h8jy5WmlNxKqIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DVwEWaae; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DVwEWaae"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-436249df846so10090035e9.3;
        Thu, 23 Jan 2025 15:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737674273; x=1738279073; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l2f7ElXBBga4o4uoEaVggdWximdrmoWLi94L+oHUujU=;
        b=DVwEWaaeWDka6cStJIIYSn5zMvyMpkwmhPzmUbprjZC4Ap5nwewpB3ZyElbg0m27EM
         AA2WQJvFlddfSEIMcA0gCkqNbetEjGpQes+yetuznExatLgFvyDxdnyMW9LNPoGz1KTG
         gPWbE0DviNk/7uO0E4TDOosZv6vuW/o9O2AAXwpbFdnhp75J1e/h+wSMzhJ1bFkRSk5k
         JZQVaFcgYvFVeG9xVdg45x2+DxDV14FIz8bMF4M3lrsp9CzdpCefEdWQy3+0CjN4y5FZ
         I8YntYlI0VmnQz9Aw55Q1U4hlmeQ1xL7v+TwR02gRGkqHw0c1KfoHTzauoWgB5W/mNke
         VF2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737674273; x=1738279073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l2f7ElXBBga4o4uoEaVggdWximdrmoWLi94L+oHUujU=;
        b=IkBroSoSj2xpUTaaR4BfhK+vZQ0YNv5dJd2RJXrFIWkylerhYWHv1/TTvmzDFIrH6u
         J/DwOchQ7jiApxVupWY563FMxcnbIo+6PyApgGtVLJrhrOH4bvRVrQfB8P35E1OeSL6o
         D+h9fSFB753Ei1qJjQzWZXMFxijTmx3Xc7aGnfuZFVYG6RKdsN4Ejiv0Zbg+HKCZa3DY
         4SRSYEncEF696k8NQF/Mda9Rerl7DP1BegcRv4O3nCSumh6+rcK4To4/BIAZQdf6onYv
         93slByUAjcwWDn6jNa55brayBsYMcrCVoOti324PRI5mE/YNKjCQvyST/1Hc9UvsaUqc
         6nZw==
X-Forwarded-Encrypted: i=1; AJvYcCU2fQe0wprdCRcpW5zH9BI2AFh6Mdxwj8cbgI/j1dgItEebwxEDFxL3FvRwwZ8HPef2qPiEVFYcYU91BFk=@vger.kernel.org, AJvYcCVrYraMea1ZzoTzZLMEUbwO2iCNwQuJulOahjv82ZYJrjbz7wjhBGWW2mX+fWrJZB5FjvkxCDeIs+2rrp8M@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4O7WC9LsMcLgM8EzF8KLY7Xs3ONiRHnwZ7KJqfRlxa3hbqDou
	pZRgrOz+ZovPosiVPoBWOJ5HCfaTXMwW0s1rHO6aBBQE7Ys4JW3x
X-Gm-Gg: ASbGncsaWlXLYckAWPptj//N7TKkEJCfjD/uMICOE/Ho16F6LtmcDQFAhQpZnQE4PwU
	LY0aqyOM00ZAFSNkhlGgDq6VboE9OD3XgvN+Iyk4s03Dud/ET5SAPcCaogMeS0JYlWKnouuaZUh
	V/U0tfraRA1ceF31rnl2Df1i7MPgnxp7ZbTkbDgZfvnY+ubhEVsvIFLUjfjQgvhAH4Zqte+Icjw
	41/idUk9PS4YDPM8U4ei/5l4RNgO/qNLBvCJtbuO59r3UqA7GYy4OVsPB9cYBkasbTHvuRf2bcg
	EJ46x7SoxoMc5YXIv6f/CGJ3xuOS9oBMMMgzEHftR+k=
X-Google-Smtp-Source: AGHT+IEE0Tcke8awkYxcQ/BQVoHZZb2VKBuKGA74MNbLpuGWFdgR6uiXz30Ey/3PZMBQBxKYX2qvKA==
X-Received: by 2002:a05:600c:4fc1:b0:437:c3a1:5fe7 with SMTP id 5b1f17b1804b1-438914340a4mr231135555e9.20.1737674273437;
        Thu, 23 Jan 2025 15:17:53 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd5730a6sm5806535e9.35.2025.01.23.15.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 15:17:53 -0800 (PST)
Date: Thu, 23 Jan 2025 23:17:52 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Linus Torvalds
 <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, Chao Yu
 <chao@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Geert
 Uytterhoeven <geert@linux-m68k.org>, Kent Overstreet
 <kent.overstreet@linux.dev>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Vinicius Peixoto <vpeixoto@lkcamp.dev>, WangYuli
 <wangyuli@grjsls0nwwnnilyahiblcmlmlcaoki5s.yundunwaf1.com>
Subject: Re: [GIT PULL] CRC updates for 6.14
Message-ID: <20250123231752.67d40550@pumpkin>
In-Reply-To: <20250123211603.GB88607@sol.localdomain>
References: <20250119225118.GA15398@sol.localdomain>
	<CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com>
	<20250123051633.GA183612@sol.localdomain>
	<20250123074618.GB183612@sol.localdomain>
	<20250123140744.GB3875121@mit.edu>
	<20250123205810.744c8823@pumpkin>
	<20250123211603.GB88607@sol.localdomain>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 23 Jan 2025 13:16:03 -0800
Eric Biggers <ebiggers@kernel.org> wrote:

> On Thu, Jan 23, 2025 at 08:58:10PM +0000, David Laight wrote:
...
> > For a small memory footprint it might be worth considering 4 bits at a time.
> > So a 16 word (64 byte) lookup table.
> > Thinks....
> > You can xor a data byte onto the crc 'accumulator' and then do two separate
> > table lookups for each of the high nibbles and xor both onto it before the rotate.
> > That is probably a reasonable compromise.  
> 
> Yes, you can do less than a byte at a time (currently one of the choices is even
> one *bit* at a time!), but I think byte-at-a-time is small enough already.

I used '1 bit at a time' for a crc64 of a 5MB file.
Actually fast enough during a 'compile' phase (verified by a serial eeprom).

But the paired nibble one is something like:
	crc ^= *data++ << 24;
	crc ^= table[crc >> 28] ^ table1[(crc >> 24) & 15];
	crc = rol(crc, 8);
which isn't going to be significantly slower than the byte one
where the middle line is:	
	crc ^= table[crc >> 24];
especially for a multi-issue cpu,
and the table drops from 1k to 128 bytes.
That is quite a lot of D-cache misses.
(Since you'll probably get them all twice when the program's working
set is reloaded!)

Actually you need to rol() the table[]s.
Then do:
	crc = rol(crc, 8) ^ table[] ...
to reduce the register dependency chain to 5 per byte.

	David
