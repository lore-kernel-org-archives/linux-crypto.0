Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE58F6FC3
	for <linux-crypto@vger.kernel.org>; Wed, 20 Mar 2024 01:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710899338; cv=none; b=PP+6yJEFDaT1dsml/Rxx/jIbMUfVxMdx6Vi5ToYrw185y13XeuXZ5/ahEkO12ezpjk4b95TDPU6Z8rmzOMJMHJMaAhrHfNKkZ1bfQKab9IyWFjIKrWUd1Dx1vdpZ2ZZXodN3v1A3GRlEhjkA8VLR1bpyvoi6ZhJb1XGTtqLJVJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710899338; c=relaxed/simple;
	bh=qI5Tub3LHNOZFOE4/6hw3EHPShN11Tc+qwy45TA6jzI=;
	h=Date:Subject:In-Reply-To:CC:From:To:Message-ID:Mime-Version:
	 Content-Type; b=eRXzwmA6PuxT82t1ZDPacICKxFelWCKKhoU4BJ3DXU93l4I9Ja/Zu9vlPa5o3bXHdU+0J8TaD/GVYXB5dQQbLo0w4DB174/YiWYapoXfB35YQW+6nl/rfWkJTMa6UA+dNGyB1lkfIptL+/e5OQgUnXY54F6hTDWHzucIwrs3ABc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com; spf=pass smtp.mailfrom=dabbelt.com; dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b=bgQHemEv; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="bgQHemEv"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6e709e0c123so3055301b3a.1
        for <linux-crypto@vger.kernel.org>; Tue, 19 Mar 2024 18:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1710899335; x=1711504135; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0XFWeUGhARFGLtFMmrEktN1r5EqqYdHQ1yDObB41VHU=;
        b=bgQHemEvN05cdGU6PpvED1zoIXJgO5LBFTlnx50deFNOuq+GHUAaD7l6X6AZeWsNJQ
         1plwhb/c1gHnH8CX4ofdt0KwXvycCbWRqrjaMWEoAZqkDU0abR8J6zUK964XMUM84i3y
         m0jGe4hOoPUABl+sORRsya0599TlvqK56yuJe7Xhp7fNPbL+YSSYdeec6RTgnBrNpZob
         xybC4lfWlAccgPfc+HFxo6jhah3Zeoe172z0ZQvSdKPMfJRUfsJKkp9FHnK8ZX2VfhdE
         mgwrO2RO2QPXa3nenA2EbMNh4RdKOzhMpBndkRFcmGXwEZN4OplqdUak+gI7NCAHIv+0
         tLdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710899335; x=1711504135;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0XFWeUGhARFGLtFMmrEktN1r5EqqYdHQ1yDObB41VHU=;
        b=OUsnXzgCVN0ae36mr4MJz7Uw4lkUL1gZPA26l+n3HVqcuMfp8M/tVw75wptwTEbCgs
         3JwA3ksMyz2qWEI6w/6jQHac0RHR9bXIXkYtaKw5tybz7hJ9qBiVSQY5w8XEXyWggTqO
         z93OlIV9hKhmDkB4KEOEjrotAzJKCctbJ5lXbVwq2qcq4T4Wa9vtqr6/SeU/9sUgtNoU
         buaCCrHnwNnMsG5HTVygMrg8zk+BccspFofpiW8heiLx9vr63rxw18NDtolntvzyhLff
         yiNxRxKBB4VsRC4AxU44RE++pFpBCzQl2M+Beg4hfBYb8GFGEbdvcAP8KIyNN+mybE+8
         sOsA==
X-Forwarded-Encrypted: i=1; AJvYcCU4wNn3At/yZUY9PQKf5ouNe3jOHM2chJA27dNPupP9GLI8ARFjMY7vzMHVx+8l3LbS5jcxVn/tViu7vLY+tje6HbR7AB8oOX/UDmhM
X-Gm-Message-State: AOJu0YwnevWW67bJi70Bl74uqmUTy4X1Kz27kfggV+un5PBAVQi2MW42
	pBofR22ZQ9mvOn/AYDOb+ogBwh1kuM5Yegk3T6Bhp9en6tlMe5DD32ciW6GrcDQ=
X-Google-Smtp-Source: AGHT+IEsM1/0CXsqPV1u7HWDW2kWwLy9n8txe/RJcjigdZRgO1jABEpVpPsAnwHTQDrbVR7Cz8D3Jw==
X-Received: by 2002:a05:6a20:b915:b0:1a3:69a9:e3e7 with SMTP id fe21-20020a056a20b91500b001a369a9e3e7mr4012756pzb.18.1710899334899;
        Tue, 19 Mar 2024 18:48:54 -0700 (PDT)
Received: from localhost ([50.213.54.97])
        by smtp.gmail.com with ESMTPSA id ld11-20020a170902facb00b001db5079b705sm1628209plb.36.2024.03.19.18.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 18:48:54 -0700 (PDT)
Date: Tue, 19 Mar 2024 18:48:54 -0700 (PDT)
X-Google-Original-Date: Tue, 19 Mar 2024 18:48:50 PDT (-0700)
Subject:     Re: [PATCH riscv/for-next] crypto: riscv - parallelize AES-CBC decryption
In-Reply-To: <20240210181240.GA1098@sol.localdomain>
CC: jerry.shih@sifive.com, linux-riscv@lists.infradead.org,
  linux-crypto@vger.kernel.org, christoph.muellner@vrull.eu, Heiko Stuebner <heiko@sntech.de>,
  phoebe.chen@sifive.com, andy.chiu@sifive.com
From: Palmer Dabbelt <palmer@dabbelt.com>
To: ebiggers@kernel.org
Message-ID: <mhng-7b6264a7-c1cd-46b2-97f1-b2c3d3dbb716@palmer-ri-x1c9a>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Sat, 10 Feb 2024 10:12:40 PST (-0800), ebiggers@kernel.org wrote:
> On Sat, Feb 10, 2024 at 11:25:27PM +0800, Jerry Shih wrote:
>> > .macro	aes_cbc_decrypt	keylen
>> > +	srli		LEN, LEN, 2	// Convert LEN from bytes to words
>> > 	vle32.v		v16, (IVP)	// Load IV
>> > 1:
>> > -	vle32.v		v17, (INP)	// Load ciphertext block
>> > -	vmv.v.v		v18, v17	// Save ciphertext block
>> > -	aes_decrypt	v17, \keylen	// Decrypt
>> > -	vxor.vv		v17, v17, v16	// XOR with IV or prev ciphertext block
>> > -	vse32.v		v17, (OUTP)	// Store plaintext block
>> > -	vmv.v.v		v16, v18	// Next "IV" is prev ciphertext block
>> > -	addi		INP, INP, 16
>> > -	addi		OUTP, OUTP, 16
>> > -	addi		LEN, LEN, -16
>> > +	vsetvli		t0, LEN, e32, m4, ta, ma
>> > +	vle32.v		v20, (INP)	// Load ciphertext blocks
>> > +	vslideup.vi	v16, v20, 4	// Setup prev ciphertext blocks
>> > +	addi		t1, t0, -4
>> > +	vslidedown.vx	v24, v20, t1	// Save last ciphertext block
>>
>> Do we need to setup the `e32, len=t0` for next IV?
>> I think we only need 128bit IV (with VL=4).
>>
>> > +	aes_decrypt	v20, \keylen	// Decrypt the blocks
>> > +	vxor.vv		v20, v20, v16	// XOR with prev ciphertext blocks
>> > +	vse32.v		v20, (OUTP)	// Store plaintext blocks
>> > +	vmv.v.v		v16, v24	// Next "IV" is last ciphertext block
>>
>> Same VL issue here.
>
> It's true that the vslidedown.vx and vmv.v.v only need vl=4.  But it also works
> fine with vl unchanged.  It just results in some extra data being moved in the
> registers.  My hypothesis is that this is going to be faster than having the
> three extra instructions per loop iteration to change the vl to 4 twice.
>
> I still have no real hardware to test on, so I have no quantitative data.  All I
> can do is go with my instinct which is that the shorter version will be better.
>
> If you have access to a real CPU that supports the RISC-V vector crypto
> extensions, I'd be interested in the performance you get from each variant.
> (Of course, different RISC-V CPU implementations may have quite different
> performance characteristics, so that still won't be definitive.)

We're stacking up a lot of stuff with HW-dependent performance 
questions, I think it's fine to just take what's reasonably simple for 
now.  If we try to speculate about what future hardware might do we're 
just going to go crazy with possibilities, IMO we're way better off just 
optimizing as things show up.

> Here is the alternative variant given as a diff from this patch:
>
> diff --git a/arch/riscv/crypto/aes-riscv64-zvkned.S b/arch/riscv/crypto/aes-riscv64-zvkned.S
> index 43541aad6386c..ef380771f606a 100644
> --- a/arch/riscv/crypto/aes-riscv64-zvkned.S
> +++ b/arch/riscv/crypto/aes-riscv64-zvkned.S
> @@ -146,10 +146,13 @@ SYM_FUNC_END(aes_ecb_decrypt_zvkned)
>  	vle32.v		v20, (INP)	// Load ciphertext blocks
>  	vslideup.vi	v16, v20, 4	// Setup prev ciphertext blocks
>  	addi		t1, t0, -4
> +	vsetivli	zero, 4, e32, m4, ta, ma
>  	vslidedown.vx	v24, v20, t1	// Save last ciphertext block
> +	vsetvli		t0, LEN, e32, m4, ta, ma
>  	aes_decrypt	v20, \keylen	// Decrypt the blocks
>  	vxor.vv		v20, v20, v16	// XOR with prev ciphertext blocks
>  	vse32.v		v20, (OUTP)	// Store plaintext blocks
> +	vsetivli	zero, 4, e32, m4, ta, ma
>  	vmv.v.v		v16, v24	// Next "IV" is last ciphertext block
>  	slli		t1, t0, 2	// Words to bytes
>  	add		INP, INP, t1
> @@ -157,7 +160,6 @@ SYM_FUNC_END(aes_ecb_decrypt_zvkned)
>  	sub		LEN, LEN, t0
>  	bnez		LEN, 1b
>
> -	vsetivli	zero, 4, e32, m1, ta, ma
>  	vse32.v		v16, (IVP)	// Store next IV
>  	ret
>  .endm
>
> A third variant would be to just replace vmv.v.v with vmv1r.v.
>
> In general, this level of micro-optimization probably needs to be wait until
> there are a variety of CPUs to test on.  We know that parallelizing the
> algorithms is helpful, so we should do that, as this patch does.  But the
> effects of small variations in the instruction sequences are currently unclear.

Ya, I agree.  So I'm fine with this, it's a base and we can always 
improve it when there's something concrete to run on.

> - Eric
