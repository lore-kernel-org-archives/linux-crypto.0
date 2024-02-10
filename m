Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47965C8F3
	for <linux-crypto@vger.kernel.org>; Sat, 10 Feb 2024 18:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707588763; cv=none; b=HBHiJmbT0s8+nQa4VFAUbAs+zKSkhTGbc210w4r4v/PpjFKJ9i3I3UgWsIMKmmLOATKhFHzf8FvbKdb6B0SIsE71pK9O+ornNrbETtjUn6lNPQcQqx66KnXk4udKeYBWg41X54x4cWweg2UB8uysazGsQdwteMwpJjLk3TEC0as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707588763; c=relaxed/simple;
	bh=J7eVMcLYjTAhRw0qnGWZ6vRpGFo/1AYZBX0WuO/8k7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lpDvPSxtG7JqCY4o2JvBZfajuDDAUNzzVFud1puLr3pI/gc4Za7Asd8JmZYHwyilz5r0Fqqlxz/Lik76OXNezBLM8VhkChO+Ay6yk8FOmKLVTLOkcqd8btvziwMWjogM5HpeQFdz0Ev4mY32yc3P6EZjvK6hUf7Cw+LV8Je+kDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xz+Co7sw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xz+Co7sw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7800EC433C7;
	Sat, 10 Feb 2024 18:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707588762;
	bh=J7eVMcLYjTAhRw0qnGWZ6vRpGFo/1AYZBX0WuO/8k7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xz+Co7swEy5nyM4XgXp4SdtPmHBaKFobM9EGybWj8lp5YcOFb6A2L5D0nGHoNeZ3I
	 nsXtDOAxgihjFSc/4Rguq09TyplRyQB6ixlaA911DZ3Ki+Nms4UkxGPPhjAhxBeRlH
	 QF6oR9EgElTAxoQei553oKwedMkOMqCke9d3f5h60B/E3K9KUk00bnL8y9DaCbg1Ok
	 TZS/2+uMP+GXeu8YPe2PHZ7KxcHk9RfKXGvxRdG6w40mYBR+UYS/HEawKu9MUHfgkQ
	 MM7pHfAytxhnXrmPjrsPWa/rake1gHuLNvf2x0ts7FpHASenLMl0nlXJMyqigz1J7a
	 m1ohsWGaihqBw==
Date: Sat, 10 Feb 2024 10:12:40 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jerry Shih <jerry.shih@sifive.com>
Cc: linux-riscv@lists.infradead.org, Palmer Dabbelt <palmer@dabbelt.com>,
	linux-crypto@vger.kernel.org,
	Christoph =?iso-8859-1?Q?M=FCllner?= <christoph.muellner@vrull.eu>,
	Heiko Stuebner <heiko@sntech.de>,
	Phoebe Chen <phoebe.chen@sifive.com>,
	Andy Chiu <andy.chiu@sifive.com>
Subject: Re: [PATCH riscv/for-next] crypto: riscv - parallelize AES-CBC
 decryption
Message-ID: <20240210181240.GA1098@sol.localdomain>
References: <20240208060851.154129-1-ebiggers@kernel.org>
 <04703246-6EF6-4B54-B8F1-96EDEC2FBA6B@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04703246-6EF6-4B54-B8F1-96EDEC2FBA6B@sifive.com>

On Sat, Feb 10, 2024 at 11:25:27PM +0800, Jerry Shih wrote:
> > .macro	aes_cbc_decrypt	keylen
> > +	srli		LEN, LEN, 2	// Convert LEN from bytes to words
> > 	vle32.v		v16, (IVP)	// Load IV
> > 1:
> > -	vle32.v		v17, (INP)	// Load ciphertext block
> > -	vmv.v.v		v18, v17	// Save ciphertext block
> > -	aes_decrypt	v17, \keylen	// Decrypt
> > -	vxor.vv		v17, v17, v16	// XOR with IV or prev ciphertext block
> > -	vse32.v		v17, (OUTP)	// Store plaintext block
> > -	vmv.v.v		v16, v18	// Next "IV" is prev ciphertext block
> > -	addi		INP, INP, 16
> > -	addi		OUTP, OUTP, 16
> > -	addi		LEN, LEN, -16
> > +	vsetvli		t0, LEN, e32, m4, ta, ma
> > +	vle32.v		v20, (INP)	// Load ciphertext blocks
> > +	vslideup.vi	v16, v20, 4	// Setup prev ciphertext blocks
> > +	addi		t1, t0, -4
> > +	vslidedown.vx	v24, v20, t1	// Save last ciphertext block
> 
> Do we need to setup the `e32, len=t0` for next IV?
> I think we only need 128bit IV (with VL=4).
> 
> > +	aes_decrypt	v20, \keylen	// Decrypt the blocks
> > +	vxor.vv		v20, v20, v16	// XOR with prev ciphertext blocks
> > +	vse32.v		v20, (OUTP)	// Store plaintext blocks
> > +	vmv.v.v		v16, v24	// Next "IV" is last ciphertext block
> 
> Same VL issue here.

It's true that the vslidedown.vx and vmv.v.v only need vl=4.  But it also works
fine with vl unchanged.  It just results in some extra data being moved in the
registers.  My hypothesis is that this is going to be faster than having the
three extra instructions per loop iteration to change the vl to 4 twice.

I still have no real hardware to test on, so I have no quantitative data.  All I
can do is go with my instinct which is that the shorter version will be better.

If you have access to a real CPU that supports the RISC-V vector crypto
extensions, I'd be interested in the performance you get from each variant.
(Of course, different RISC-V CPU implementations may have quite different
performance characteristics, so that still won't be definitive.)

Here is the alternative variant given as a diff from this patch:

diff --git a/arch/riscv/crypto/aes-riscv64-zvkned.S b/arch/riscv/crypto/aes-riscv64-zvkned.S
index 43541aad6386c..ef380771f606a 100644
--- a/arch/riscv/crypto/aes-riscv64-zvkned.S
+++ b/arch/riscv/crypto/aes-riscv64-zvkned.S
@@ -146,10 +146,13 @@ SYM_FUNC_END(aes_ecb_decrypt_zvkned)
 	vle32.v		v20, (INP)	// Load ciphertext blocks
 	vslideup.vi	v16, v20, 4	// Setup prev ciphertext blocks
 	addi		t1, t0, -4
+	vsetivli	zero, 4, e32, m4, ta, ma
 	vslidedown.vx	v24, v20, t1	// Save last ciphertext block
+	vsetvli		t0, LEN, e32, m4, ta, ma
 	aes_decrypt	v20, \keylen	// Decrypt the blocks
 	vxor.vv		v20, v20, v16	// XOR with prev ciphertext blocks
 	vse32.v		v20, (OUTP)	// Store plaintext blocks
+	vsetivli	zero, 4, e32, m4, ta, ma
 	vmv.v.v		v16, v24	// Next "IV" is last ciphertext block
 	slli		t1, t0, 2	// Words to bytes
 	add		INP, INP, t1
@@ -157,7 +160,6 @@ SYM_FUNC_END(aes_ecb_decrypt_zvkned)
 	sub		LEN, LEN, t0
 	bnez		LEN, 1b
 
-	vsetivli	zero, 4, e32, m1, ta, ma
 	vse32.v		v16, (IVP)	// Store next IV
 	ret
 .endm

A third variant would be to just replace vmv.v.v with vmv1r.v.

In general, this level of micro-optimization probably needs to be wait until
there are a variety of CPUs to test on.  We know that parallelizing the
algorithms is helpful, so we should do that, as this patch does.  But the
effects of small variations in the instruction sequences are currently unclear.

- Eric
