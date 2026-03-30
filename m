Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3361429D
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 09:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774863109; cv=none; b=O4CXV0wLCggZrKQsLG+J8PlJHVurVsekRwavOov/rhpsAk8RrLAIv1LoUqNO1fNiNpOYkyrnWQiSz6Ixdm60it6u4039DufT92dbdusfliMMzQ7PVVBdu17U6cvIpKGtjT5oSbhitueonwnGBLK6s3d5XdSYSqCwPMW5IeCDLnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774863109; c=relaxed/simple;
	bh=LU+5ctIuk/2P8a3ACWO/4xkPZ6cdiMXVw5WjWNmJytc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f6D+CNqUAuYBM61i/FNCWyUMT6ub86JbF8CuTRHbYxUWzzxBOg2Yo9Mq7VJUa4wEIiKxQVTtzEF5aLUtHoNEl4IR0eigLrjYq4Fk9TMvkYPW7H8MO7AZ+2yk6CVZ3KCfAIad2rotl5WTEVY7p7i0rbH/c1PAJGKe/or8yRRqCqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GfoK27ib; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GfoK27ib"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43cfac48bc7so578081f8f.0
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 02:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774863105; x=1775467905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=evkirLKGhh0WuOBuZT2IPb0j74uGRBwEy0ZVb1MgXNE=;
        b=GfoK27ibM8Zo7Fx+TZVqoDdltGw6oPhCMZStiC/5mXK5KlvG9KMRcQRoDAbWUxDAdq
         8LzQQhvLzswSnTscYlyFNyssWgMBcpH8Zf48bH9Q0qNFi8Gcl1xgdRg0IlLyH3VTboFR
         95WZE37pBmeNCQmX9TdyD3IUqim0VZkJTpUIsOwfpSxWubX7WeDscdTZDSRpObfkBPLB
         iTvS0HrYJuyEEEAaOXepY8/ZBCjqqVLTZOeyihac8TGBdZ/ckZw6KQmfKSXYN7vhTNud
         f5yalO6SiCYPdO9qRU3uaTTQp0Vf3p/fCGorlThd2u0K9CunJFwDbBgY/VyVwYXB4gTc
         NpQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774863105; x=1775467905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=evkirLKGhh0WuOBuZT2IPb0j74uGRBwEy0ZVb1MgXNE=;
        b=B5vMnFSHqcIMa3KOlsgBRQirCJrtLYLQPDKoB1/PQ5+yGGiTN6mqFKw4gqElV+3hrC
         caP/GjnKsVtrUiDXTx+9A+76vO6YjVmUAaLngJEpYbWZbnWWopfr/k8+Bg9HclD7aGJM
         UdUvD02u6uWFpghHc1joSSGcc23tjnlDAVeS1CCW7VVDVphqLz2HubpBmrV/n4r701n9
         TRzrcmUL954e0a8l4qkENB70bxHF/L3Ljkq55UC1OZ/jfiolcQX4gPzGKcZ8SyzYGNLR
         I4olHUafqeulrCU7w8PRvlgYhYFa/6hfLCxN3b6cpOfhNz3YFmkcyEeRl7ZhrmgqZsgf
         Djfg==
X-Forwarded-Encrypted: i=1; AJvYcCVzW0Yf9zDEq5/8nqUIpixT2eE2MwxvZ7wbqsGF9VI0bj0g39xM6cuefzK4HzP/K97Gz6BHVPqLMgNtxmg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWvA0YsCfHX3f97lQKAeGySq2gWAmj2C/RZDB6hS+zZKME2s1q
	6p2+n5MFI+vr1GZyANuDgIIBSoWGJ0dBf+OY5y3RXf9rJ2t636R4Sf+K
X-Gm-Gg: ATEYQzyntVh5NOkrEhsM4f4MbZCjQoUR49KClmJtC9x+kxRFDqub93jqeWJA+uOzP6q
	oRpvG2AqC0O1hoZdDTPC+wkH5gitzn0lzuzqLsaxkoa1etFjOAjMLMm8icKiQ2nJzDRxgw9D1AM
	a4u5GozRR5+RWIqFSe3DT7ztGceASEcnQ+eEdGXFVCND5Q8gZr8h66wI2ev5cPelcDlFRIOoH/m
	cTYREy98Bb2U9YaY8I58tYB+F99nKwzcINhi2qc/wCYYwEj0JdFrEpE7lFQva1eX2FR673KG1LM
	zQ7z8Fh8S2VR431TE8KIQSDADFNIM9q58yK/OlbSn8so5NCQnbRzz0AM4jnCeHc02yeTTuZgI7B
	QFrI072pMA2H3JJCSXmY3+tI18YBLb1fW+PY66EZvu3i2nWjGcY+SfwbJcr3FlMi2JfMyOsV4+i
	IhfUOVZTxe4CuuGpxCewVQ/JQQUIGeu5juu9QUoWJx6H9IdP2uVVorzaOIymgqhTPCbNfeQUk=
X-Received: by 2002:a05:6000:2282:b0:439:b811:11de with SMTP id ffacd0b85a97d-43b9e9d5e30mr20922607f8f.7.1774863104329;
        Mon, 30 Mar 2026 02:31:44 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43cf21e9e18sm16796564f8f.9.2026.03.30.02.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 02:31:44 -0700 (PDT)
Date: Mon, 30 Mar 2026 10:31:42 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Demian Shulhan <demyansh@gmail.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 ardb@kernel.org
Subject: Re: [PATCH v3] lib/crc: arm64: add NEON accelerated CRC64-NVMe
 implementation
Message-ID: <20260330103142.193e2a98@pumpkin>
In-Reply-To: <20260329221821.GC2106@quark>
References: <20260317065425.2684093-1-demyansh@gmail.com>
	<20260329074338.1053550-1-demyansh@gmail.com>
	<20260329203829.GA2746@quark>
	<20260329225704.0eb82966@pumpkin>
	<20260329221821.GC2106@quark>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 29 Mar 2026 15:18:21 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> On Sun, Mar 29, 2026 at 10:57:04PM +0100, David Laight wrote:
> > Final thought:
> > Is that allowing for the cost of kernel_fpu_begin()? - which I think only
> > affects the first call.
> > And the cost of the data-cache misses for the lookup table reads? - again
> > worse for the first call.  
> 
> I assume you mean kernel_neon_begin().  This is an arm64 patch.

Well, much the same.

> (I encourage you to actually read the code.  You seem to send a lot of
> speculation-heavy comments without actually reading the code.)

I have looked at the code, since I (mostly) understand the maths I can
almost work out what it is doing - but all the conversions between three
different ways of holding two 64bit values in one 128bit register really
don't help.

> Currently, the benchmark in crc_kunit just measures the throughput in a
> loop (as has been discussed before).  So no, it doesn't currently
> capture the overhead of pulling code and data into cache.  For NEON
> register use it captures only the amortized overhead.
> 
> Note that using PMULL saves having to pull the table into memory, while
> using the table is a bit less code and saves having to use kernel-mode
> NEON.  So both have their advantages and disadvantages.

Indeed - so the 128 is really a 'finger in the air' value :-)

> This patch does fall back to the table for the last 'len & ~15' bytes,
> which means the table may be needed anyway.

Nibble lookups on two separate tables (256 bytes instead of 2k) might
be almost as fast even with the tables in the cache.
The critical part of the table lookup loop should be the:
	crc = crc ^ table[crc & 0xff]
part (the rotate should get hidden in the memory read latency).
With nibble tables is becomes:
	crc = crc ^ table_lo[crc & 0xf] ^ table_hi[(crc & 0xf0) >> 4]
on any modern cpu the table lookups will happen in parallel; so it
should just add one 'xor' to the loop.
(And yes, I probably could measure it, at least in userspace on x86-64.)

> That is not the optimal way
> to do it, and it's something to address later when this is replaced with
> something similar to x86's crc-pclmul-template.S.

That is one bit I do need to grok...

	David

> 
> - Eric

