Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8931CD2B;
	Thu,  6 Mar 2025 05:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741238268; cv=none; b=qff6djZCF2YVOahwnQTEZAWwGhMJ5r5ndr5/GInOaADZBo5Uj7i7NKI9ni4YPoqeemBbETKbU305BJI8RHApWBkhv/eVG69mDSevXUivFqVcYN85+W6LLvzSV1JTXETe0NifLBNp0ASVYb+q+OCLw5BZ3Lh39XNRa9sQwpOVpiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741238268; c=relaxed/simple;
	bh=WYFWuMsvQGQ7/YrFeFoyl61Xj9FhjYRgqlpD086BI+I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K0tdjwE3xWJ/7vYUJNLPH+fkUb3MKfhoPgDsn859CjfHicDyyoRVx60W826j2UhPm6yh1sOpvUYFkFkP7DgYazARXh7Fk9HV1OFe7O3zAGfJrw4DWXcUmHpY6/APoMGEFtemFsp1sh7xIrO4WQ5+vamwC77EpwAgYgy41rtTHZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mew+9OEY; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mew+9OEY"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3911748893aso164343f8f.3;
        Wed, 05 Mar 2025 21:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741238265; x=1741843065; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/XTve7yZUkpJ6I7Ayk3GGXKo8U7zE5G1KYgy4s9AqZw=;
        b=mew+9OEYgXvAw57igyaKcaKPnlKby8eH6pZtokWnRTYyIzNuUeCTi6mUOQDAg+ZPGW
         HRx+ODg+YhUYWkeeAe7z9PxdGL6gVdbK8VqGPR22q+I9mxREgIUe1MG/39rVwQWerF0j
         Mf2ienwLpz0U8X8vvDVVJdo6BsMypbj42xUsKbNu4RroYRspjQ3Bo/ujPRmSVvUd6V2G
         4oLRDJyskNYhfdV8IjyYBrXI7ZiTPEBorUcqsfU0nUC4zPlc/VCCV/N2gMDFxGpyzdT8
         u85QrCCHTpQgN0aUssBNXjIoQBoQtECVVbW/al6ABwogtu7fU12zchiLsS5nrb66wB6q
         b9gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741238265; x=1741843065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/XTve7yZUkpJ6I7Ayk3GGXKo8U7zE5G1KYgy4s9AqZw=;
        b=uYtU8dFFLSSvTWkqh86CwQ9mB83TkCMcUt+jw8VBkA6OiPoIHUKCoC89ZSEKK2ngf5
         ZSVo/7X6iy1vhOE0OjVnmE7CXLioyPH1nvh/+N7tpvIXKXro/e/EAOVmCwdG1zO4+yVq
         AItsFkZ3zfVFeUPnUv7oXk1DQiTlqYV4h639fhFysaO7009OLxSSbVngDXuvjZXwqiT4
         USRfYnoQFlDDKXzjFAOkOEgM38/LZu9Q7HoQxfvwEh8AaDLm/AbEy4knvUCMZLlP8auk
         c/3B3jyspk4dVedvCFg/b2ye9Bqs6P1uiQbE/B3EWka+QF2bn0EaKEJgZ7+idl5Q5yCM
         Bv/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVx6N3HqOroan/xMWrlZSBNRsOf2Dym8Im1+XdCdpV7BdvhBe/TxgYFGmnOF9HP+awXZiRzEPGUwB+wx8A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYxe9NUjnUOHOls0wVWYp9uxwRYWjx+QQQMo9dwMeUazitXy3W
	Gwbjv/UcccUvV09pMZk6+C1MZyeK0PF9yiQ0eY2vYwihmhh1iyGy
X-Gm-Gg: ASbGncuemBH+0Y+lMbN9+jVMBtN5JHxE22GSCnAcifwXoaWX+jQ6Tmuc88JAo+2mbkX
	MeDRB1pCjNp/Saa6l7eUuMGz62AxVXC8MdJmL9w468RDoh4Yy4yUHNjNTZpyNmuNtNhJ8gAeQP4
	a2SWDAHdKR/7CwG/qey0mRr1ScXgJrpXuWWsNCj4CF71iWvsV9gsAKYqKp8Q+zDzMhZjhx9U3S3
	WOWl4F7hqeaqjsIp3/X6MMdziWsCT2Ox42yviIRhMkW1Rg/6qVMHEE/6l2a7DXrNz6SrfuXGwqs
	s7n7Nce/SK44WKsspSbKoASDBI636/8zJsCrqsrEwkYD+O/tSpkPepS9JVHlVXtru2c4kLKSa03
	Wus626I0=
X-Google-Smtp-Source: AGHT+IHpz5lBCH2fwxlrTq59pWzTqiDyJY2lKmLmc1eX8A6erOeXEL+wiJGEzur2GcgaqjZkCdZM0g==
X-Received: by 2002:a5d:5984:0:b0:391:1f9:c59a with SMTP id ffacd0b85a97d-3911f7c4cf6mr4482893f8f.46.1741238264481;
        Wed, 05 Mar 2025 21:17:44 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd4352eccsm37431535e9.27.2025.03.05.21.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 21:17:43 -0800 (PST)
Date: Thu, 6 Mar 2025 05:17:40 +0000
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
Message-ID: <20250306051740.6f454cac@pumpkin>
In-Reply-To: <20250306025643.GA1592@sol.localdomain>
References: <20250304213216.108925-1-ebiggers@kernel.org>
	<20250305142653.751d9840@pumpkin>
	<20250305191608.GA19889@sol.localdomain>
	<20250305220739.1cb4b61e@pumpkin>
	<20250306025643.GA1592@sol.localdomain>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 5 Mar 2025 18:56:43 -0800
Eric Biggers <ebiggers@kernel.org> wrote:

> On Wed, Mar 05, 2025 at 10:07:39PM +0000, David Laight wrote:
> > On Wed, 5 Mar 2025 11:16:08 -0800
> > Eric Biggers <ebiggers@kernel.org> wrote:
> >   
> > > On Wed, Mar 05, 2025 at 02:26:53PM +0000, David Laight wrote:  
> > > > On Tue,  4 Mar 2025 13:32:16 -0800
> > > > Eric Biggers <ebiggers@kernel.org> wrote:
> > > >     
> > > > > From: Eric Biggers <ebiggers@google.com>
> > > > > 
> > > > > For handling the 0 <= len < sizeof(unsigned long) bytes left at the end,
> > > > > do a 4-2-1 step-down instead of a byte-at-a-time loop.  This allows
> > > > > taking advantage of wider CRC instructions.  Note that crc32c-3way.S
> > > > > already uses this same optimization too.    
> > > > 
> > > > An alternative is to add extra zero bytes at the start of the buffer.
> > > > They don't affect the crc and just need the first 8 bytes shifted left.
> > > > 
> > > > I think any non-zero 'crc-in' just needs to be xor'ed over the first
> > > > 4 actual data bytes.
> > > > (It's over 40 years since I did the maths of CRC.)  
> > ...  
> > > > 	David    
> > > 
> > > Sure, but that only works when len >= sizeof(unsigned long).  Also, the initial
> > > CRC sometimes has to be divided between two unsigned longs.  
> > 
> > Yes, I was thinking that might make it a bit more tricky.
> > I need to find some spare time :-)
> > 
> > I wasn't taught anything about using non-carry multiplies either.
> > And I can't remember the relevant 'number field' stuff either.
> > But (with no-carry maths) I think you have:
> > 	crc(n + 1) = (crc(n) + data(n)) * poly
> > If data(n+1) and data(n+2) are zero (handled elsewhere) you have:
> > 	crc(n + 3) = (((crc(n) + data(n)) * poly) * poly) * poly
> > I think that because it is a field this is the same as
> > 	crc(n + 3) = (crc(n) + data(n)) * (poly * poly * poly)
> > which is just a different crc polynomial.
> > If true your '3-way' cpu doesn't have to use big blocks.  
> 
> Well, to extend by some constant number of bits 'n', you can carryless-multiply
> by the polynomial x^n, pre-reduced by the CRC's generator polynomial.  That's
> basically how all the CRC implementations using carryless multiplication work.
> Take a look at the x86 and riscv optimized code, for example -- especially my
> new versions in the crc-next tree at
> https://web.git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next.
> 
> But x86 does not have a scalar carryless multiplication instruction, only vector
> (PCLMULQDQ).  It does have a scalar CRC instruction, for crc32c *specifically*,
> and that is what the code we're discussing is taking advantage of.  Given that
> there is overhead associated with using kernel-mode FPU (i.e. vector), it makes
> sense to do that, at least on short messages.
> 
> On longer messages a PCLMULQDQ-only implementation would work well, but so does
> interleaving the crc32c scalar instruction on multiple chunks, which is what is
> currently wired up in the kernel via crc32c-3way.S.  And yes, the chunks for
> that do not *have* to be long, but you still need to use pclmulqdq instructions
> to combine them

You should be able to use lookup tables to jump over the other chunks
(so processing a block of zero bytes).
Possibly 8 lookup tables of 16 entries each for each nibble (512 bytes).
Not nice for the d-cache though.

> (unless you do a really slow bit-at-a-time carryless
> multiplication), and you have to enter a kernel-mode FPU section to do that.

That pseudo-code is probably completely wrong.
I suspect that since it is 'just' doing 'data % poly' it relies on the fact that
	327 % 7 == 3 * (100 % 7) + 27
and reduces the length by one digit.
(Where a 'digit' could be 64 bits)
I need to look up pclmulqdq.
Trying to do anything with the simd instructions makes my head hurt.

	David
