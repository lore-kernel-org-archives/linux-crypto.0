Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC621C07DC;
	Thu, 23 Jan 2025 20:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737665895; cv=none; b=n9o2DaVtWaB+buXeGhSKKjkgvbBqa+TBQfFPGTrKfSyG7Tamj7M7x4r/RaH/iJSfGc2DZ8i4J56HehIJbEUxdcArkjtwa67KHt4eHmb6Ff3x4y6Z0t9WfKD34wJ/1J+/6VsvnF+3TqZfmFIIj+abyYYdwwPsp+yXd47agmnfb1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737665895; c=relaxed/simple;
	bh=PE2nwUlOlGPJqJwHgXGUqtlHOiwABexmkzxmzZtB1IA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iGEkgBg/BdNjUiAYpRjmOackuXLI8RekpE2a5oCXuOus2OSx9b79ZscmWtghF7O++ZtYSkMnkSmghZ7vgioUUdvLArRXpPu+qN/rBS/dBPVor7+PtEL4U5ugjHuaW/J8Av700uR2ymd8y0/V5OkrP3E7Evzxe8txJVIWdEzW5jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SUO0sBZA; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SUO0sBZA"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4362f61757fso14384065e9.2;
        Thu, 23 Jan 2025 12:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737665892; x=1738270692; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2kIwddxTC6/GCXc+DqWUgAafQQvvpurTDzFy1K5ycls=;
        b=SUO0sBZAc6022DZzidBFaXyBzKK+e3Sf0eeUgrsDFVUuyrHr9s/4C+MEAFO/lzuJIg
         5kEA3lWf2Z4r13Wx18/QHwmtw4y9FFr4I0/GVq3ZdUkxpw2f49j8wjFxgdqRMTgCMaof
         QMnKlcXeRf2Vdls/jsr72m6UB9mHmgHS2Ltu8eA6qXIcvON1fRcyb5sTWsMC3vm/+YRd
         jrryNHQ12CHHvg3kFM6p6r34UDov1Wya7UH6HQajPGoRCcIJIxeG5JfrCskJ9CrZIRiF
         9MUbvtx+7BBAxVTSEMbZ+JsCOUcvLFI5C9oTVxdyaT5LKxG3YjBq2FdmL4ZpdR8uRriA
         Wvuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737665892; x=1738270692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2kIwddxTC6/GCXc+DqWUgAafQQvvpurTDzFy1K5ycls=;
        b=dwkIhaiMpJiVdoI4CY6vqmq9AeNKAxD+w55m3xPM3jSs0lSzLmS5xbfpun7qoB1GU5
         57Ek/PNWfJEonh+vqvPhlJWSh2wXr9z7K154khQF8fvjrqTVE1NBp3Sib8DhdklpwBG2
         xLFnFYCNDISDVWH3681W5kSfY9nG2ikpHpsfL/Ic4vSLS5/lSJUyTmKw6OFHcYZ3DXbA
         z5tveUVDKTlpPmHd4rpG9fh9jrEI37i4x2+QQI4B7ocosS4BUciaA2PBx6zO8BXeLiiQ
         xDG8BsQ6kbMabkEC+JtLXvrsEdj2zvJPGT0F6q6IR/OjkSdOn4/DBzqYnJ2o9EK+khG0
         HHFA==
X-Forwarded-Encrypted: i=1; AJvYcCVX2IdwtZZx5SiyyX5lWzoyEvahtY1zFlHhtC6fwevc+35l9Lv4iVdtbjecLO9OT3LeUQLYOq8/hwONVp0q@vger.kernel.org, AJvYcCWEhfcNIOlH9ij3j8bd0nW25Rb5pzg2T6rW0G6KmczAKRdDyNam9PXA9TVbOiNugkmynh3lxuFfmB07SWM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOwW+c3x3BAIdsiKbU9fHnSd6bIOcxuhb5EjiHWIJXf6yTxvFh
	QOTgjDVDkLj98PMFVco7r4nwKD5Z4huZM9rYp1kT9ZWXJIWSln0+
X-Gm-Gg: ASbGncsMuEjK8blIa2jQhypLBmO1pMRgnWmb49JuEoylUr9fs8pgUFYczDEyiLZPt0Q
	RovHJIKhuK3JNq1xmbVNHsprCFraoU2VLXqok5n6PseXzvoaM5Skcqlom9Bxyss10d/UnTeV54E
	9TkkTcqMwLFl+bMb9aW9OxZwXPtzRyNlVlY0XfHWzwIDnYCFGJFV7YJ3iLxtnJFqsO36tbbTyiM
	h6zTi8VP+kZ83TRLEvPAyKFNwa3Za3tN/qJfCWDFC45iq7hwg1MiPDYS+qx9RcGs/wKIBwV72JV
	fYI39OWcC/oBCfpb/yvi5YSD90aflpIqAAJy+e8jkdnp986pZa905Q==
X-Google-Smtp-Source: AGHT+IGXt0xGmmwoboEHi45ORJKpcto4d+6RlJVirh/XBYjbQQH0n4MTFEap3mu3DJ2wX0qeE9l5Og==
X-Received: by 2002:a05:6000:1a8c:b0:385:e5d8:2bea with SMTP id ffacd0b85a97d-38bf56639c9mr24070777f8f.20.1737665891664;
        Thu, 23 Jan 2025 12:58:11 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1764e9sm698524f8f.17.2025.01.23.12.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 12:58:11 -0800 (PST)
Date: Thu, 23 Jan 2025 20:58:10 +0000
From: David Laight <david.laight.linux@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Eric Biggers <ebiggers@kernel.org>, Linus Torvalds
 <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, Chao Yu
 <chao@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Geert
 Uytterhoeven <geert@linux-m68k.org>, Kent Overstreet
 <kent.overstreet@linux.dev>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Vinicius Peixoto <vpeixoto@lkcamp.dev>, WangYuli
 <wangyuli@grjsls0nwwnnilyahiblcmlmlcaoki5s.yundunwaf1.com>
Subject: Re: [GIT PULL] CRC updates for 6.14
Message-ID: <20250123205810.744c8823@pumpkin>
In-Reply-To: <20250123140744.GB3875121@mit.edu>
References: <20250119225118.GA15398@sol.localdomain>
	<CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com>
	<20250123051633.GA183612@sol.localdomain>
	<20250123074618.GB183612@sol.localdomain>
	<20250123140744.GB3875121@mit.edu>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 23 Jan 2025 09:07:44 -0500
"Theodore Ts'o" <tytso@mit.edu> wrote:

> On Wed, Jan 22, 2025 at 11:46:18PM -0800, Eric Biggers wrote:
> > 
> > Actually, I'm tempted to just provide slice-by-1 (a.k.a. byte-by-byte) as the
> > only generic CRC32 implementation.  The generic code has become increasingly
> > irrelevant due to the arch-optimized code existing.  The arch-optimized code
> > tends to be 10 to 100 times faster on long messages.  
> 
> Yeah, that's my intuition as well; I would think the CPU's that
> don't have a CRC32 optimization instruction(s) would probably be the
> most sensitive to dcache thrashing.
> 
> But given that Geert ran into this on m68k (I assume), maybe we could
> have him benchmark the various crc32 generic implementation to see if
> we is the best for him?  That is, assuming that he cares (which he
> might not. :-).

The difference between the clock speed and main memory speed on an m68k will
be a lot less than on anything more recent.
So I suspect the effect of cache misses is much less (or more likely it is
pretty much always getting a cache miss).
Brain wakes up, does the m68k even have a D-cache?
Checks the m68k user manual section 6 - it only has a I-cache (64 32-bit words).
So the important thing is probably keeping the loop small.
A cpu board might have an external data cache.

For a small memory footprint it might be worth considering 4 bits at a time.
So a 16 word (64 byte) lookup table.
Thinks....
You can xor a data byte onto the crc 'accumulator' and then do two separate
table lookups for each of the high nibbles and xor both onto it before the rotate.
That is probably a reasonable compromise.

	David
