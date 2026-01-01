Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB48207A32
	for <linux-crypto@vger.kernel.org>; Thu,  1 Jan 2026 23:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767310533; cv=none; b=CDrzyU4IbyfkEanL9iRYfSLJWewvkZXARBgirVI4Q+NKRQZJ2zB3irqCJ35jtzf4kS92q+MHYVff8J+0IKlSEWFxm5jAOlQkVgRwsL4npPfxS56N6qFTsaCs7FeiSjFieD3qKxFCWJuRzmP5daQD4ClTSquSe9NGarDWyxDOXUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767310533; c=relaxed/simple;
	bh=OAFrUmcPPePGkYKkfAAGmm7y8LjRQyAwnzckTsYgVw4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FrMVK3IcavvBkU8fmSaK1CJsIFVmMOAw2FcToImhR6B8TaQTJLz2HxeRk5Z7swTATuc5HhStrjVxw4GgK/AkfUfCGLRRmOICfuKOAA24fHXuUy0xHHGgeTBbk1d1cxxlRKQ3YDpMOzPyTY+vhLUhJCBZN0QU+/Zz9h0wtup/Dss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DFteTaPo; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DFteTaPo"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47796a837c7so74856215e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 01 Jan 2026 15:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767310530; x=1767915330; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=27+CpLiUKYyan6qq43bOyVhLwa+ur0QYRLOmONozosk=;
        b=DFteTaPodvBP7BT647enrkApPZVOEjbBruyBKs35oCJ4lZj5Rtx6X1e9mqERJUyY1w
         HHo91BIoDHb9tEJfh3Vde2cDKPaqm7VZlsIqn6e9xMYkvVm1RXwnFKojyl/7WC+hCSdb
         maU36RokpaX7P9PK/uz10Fd2E7zzCYk9/IT39vntjo7Kv52LxwJfyCAtUa512ifFprY2
         Llh1nWndFsXBy0UqJc3f0a16fs2plYvhHYTSB5rR7FsD/uLamlZP3OpnOpRqsoJW4HML
         5S9YOQ1bZwoZLVb6ZyQWVlLfyXJ7dFDl0M3gw0MsxZQGbdkeHyPKzcXzmsenfQ97LL9t
         J6pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767310530; x=1767915330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=27+CpLiUKYyan6qq43bOyVhLwa+ur0QYRLOmONozosk=;
        b=XNwOUPS0ZnSCwvTc8kEbYbFjBs/nQENzA3nbauzdzZUFaRIBEMuw+FzBw4Ym3JrtmL
         ed57V4dtNZAM74SVGJJuS71N0Z5QR8mTH0NucPukUhSWF1++1/y7EhmIaXBCJKi5yvmp
         skqZjS3pfRrsJi2tUJxT1ofk8NClWy5h0CWMnWNWJFjnbiOmLp5CXzUfn4RKXTjvC8c+
         et2pl8vIwRm7UftDt29XkjRVAupfOber4VtVlbVjwrjRga3NoioS6/U0TTOCSKsTC0Iw
         5L/f7Fyaq/FMyP6H6RvFztXkmTgGgwf4Opy3pp55Tj6CeAzOUnYkw7CgVKdiUyGQ1H59
         kPDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVaBKT3vUXk3PunL/feM5gbWeXfXPc4l5b67/zxgCpPgvtVr2QPnGWobj7oEDbRwvTHUa1P7KM6jnugpmM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQCPr35LGrwm7aHPXCIP7B9hk09KSRGfQvuRPhIyaFqPqm067j
	0R/1YypTcV7pWbvMyT8u7aaU91en9kfcoX0NBRrfpC0j238O4K/spfEG
X-Gm-Gg: AY/fxX4qMjIwUs3v0+X6ulIp4j9WkjGHrpoUxFTwxGPO4HY08ZEkNrEcD0YcujHAx9N
	DpBLPTWACZBP7FmRyzAo0M/2TOFUOMOCu0FZ1/FbQ4CAanR2umiekA2RoAcllBekKIs4+OA18bR
	c2hSB/Cj9839uMj7guXjn/18OZg7ThTfdzIc4WgjmUqZ3mMcrX286oMSpr8shm74o6MixC/OYmG
	30nVFEjW5lKgljIK8X1F4oqbNFQyn2wJilQ84ROVmyoSkgQ2jYPj6dPNvu0boQSPNz7Xc0o9How
	nCgMyxGyfqt1KEExSIfKzqdnfRfJgUsOZg2bf8C+9uis5ftoIof5/NQNDGw65GOXWdXNJqGWYbK
	qxj4h5WBmPGPDCMGHqvi/akbakW53oBevBPUG3Q+1Hv6s/QjAg0/maC7rPa3diVkjoONu+vDBZc
	psqpT1fox8+ETReiarTr4SC1DDLKzMFVLqI74nDkfECIUloF6zADLvNGhWW2BVxsk=
X-Google-Smtp-Source: AGHT+IFykrAyAT5O6c04YFoH3Lag+3ew5m63uZmUh4H7niHoQ+9mrizV/PHBerQNo/QmXu8eiBPp8Q==
X-Received: by 2002:a05:600c:470e:b0:46e:506b:20c5 with SMTP id 5b1f17b1804b1-47d19589469mr480893055e9.26.1767310530274;
        Thu, 01 Jan 2026 15:35:30 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be3af6dbdsm308720065e9.19.2026.01.01.15.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jan 2026 15:35:30 -0800 (PST)
Date: Thu, 1 Jan 2026 23:35:28 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/3] Implementation of Ascon-Hash256
Message-ID: <20260101233528.52b91c9d@pumpkin>
In-Reply-To: <20260101210602.GA6718@sol>
References: <20251215-ascon_hash256-v1-0-24ae735e571e@kriptograf.id>
	<20251215201932.GC10539@google.com>
	<7920c742b3be0723119e19e323dc92bc@kriptograf.id>
	<20251216180245.GD10539@google.com>
	<bb05699bc7922bb3668082367b4750f2@kriptograf.id>
	<20251217040617.GA3424@sol>
	<aVTq6HaRr4G2gmho@Rusydis-MacBook-Air.local>
	<20260101210602.GA6718@sol>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 1 Jan 2026 13:06:02 -0800
Eric Biggers <ebiggers@kernel.org> wrote:

> On Wed, Dec 31, 2025 at 04:20:40PM +0700, Rusydi H. Makarim wrote:
> > On Tue, Dec 16, 2025 at 08:06:17PM -0800, Eric Biggers wrote:  
> > > On Wed, Dec 17, 2025 at 10:33:22AM +0700, Rusydi H. Makarim wrote:  
> > > > On 2025-12-17 01:02, Eric Biggers wrote:  
> > > > > On Tue, Dec 16, 2025 at 01:27:17PM +0700, Rusydi H. Makarim wrote:  
> > > > > > While no direct in-kernel use as of now  
> > > > > 
> > > > > Thanks for confirming.  We only add algorithms when there is a real
> > > > > user, so it's best to hold off on this for now.
> > > > > 
> > > > > - Eric  
> > > > 
> > > > Rather than leaving this work idle, would it be better to move the
> > > > implementation entirely into the Crypto API ?  
> > > 
> > > No, that's actually the most problematic part because it would put it in
> > > the name-based registry and become impossible to change later.
> > > 
> > > There's a large maintenance cost to supporting algorithms.  We've
> > > learned this the hard way.  In the past the requirements to add new
> > > algorithms to the kernel were much more relaxed, and as a result, the
> > > Linux kernel community has ended up wasting lots of time maintaining
> > > unused, unnecessary, or insecure code.
> > > 
> > > Just recently I removed a couple algorithms (keywrap and vmac).  Looking
> > > back in more detail, there was actually never any use case presented for
> > > their inclusion, and they were never used.  So all the effort spent
> > > reviewing and maintaining that code was just wasted.  We could have just
> > > never added them in the first place and saved tons of time.  
> > 
> > Looking at both lib/crypto/ and crypto/ directories, I initially did not
> > have an impression that mandatory in-kernel use of a cryptographic hash
> > function is a strict requirement for its inclusion in the linux kernel.  
> 
> It's no different from any other Linux kernel feature.
> 
> > On the other hand, I am also keen to see its possible use cases in the linux
> > kernel. Ascon-Hash256 specifically can be an alternative to SHA-256. For
> > instance, it can be an additional option of hash function in fs-verity for
> > processors with no SHA256 dedicated instructions. If that something that
> > interests you, I am open for further discussion.  
> 
> I haven't actually seen any demand for alternative hash functions in
> fs-verity.  Though, dm-verity is sometimes used with BLAKE2b for the
> reason you mention.  But this also means the kernel crypto subsystem
> already has alternatives to SHA-256.  With that being the case, it's not
> clear that adding another one would bring anything new to the table.
> How does the performance compare with BLAKE2s and BLAKE2b?

FYI blake2b (64bit) runs at a little under 3 clocks/byte fully unrolled
on my Zen5 cpu (I've not tried in Intel cpu yet, and need a newer one).
With the main loop not unrolled it is about 4 clocks/byte.
(I've not yet tried to see why it makes that much difference.)
But the 'elephant in the room' is the 'cold cache' case.
The break-even point is somewhere between 4k and 8k bytes
(and that is excluding the effect of evicting other code from the I-cache).

Blake2s (32bit) will run at half the speed - provided the cpu has
enough registers.
Blake2s and blake2b really need a few more than 16 registers - which 32bit
x86 doesn't have.

So something with a much smaller I-cache footprint might be useful.

	David


> 
> - Eric
> 

