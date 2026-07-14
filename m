Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7047D36074F
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 07:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784015893; cv=none; b=K8zjfqAkW+D0KcPlWP4zRFE3S3nPiSaH6VrBKst5PmnNr3IBw9PusU+IcK9QLn66nGwdQ5hc8YBOGA18OG3S0Fumzkpb0h9z9RNFyeIoX8mazwKRvvzfspjKNNsSprpWt/z86VPiTQWGAEtl5RycWlNAr6Zl2I5VlY7KV2uUGIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784015893; c=relaxed/simple;
	bh=XTWkmfzt6ioT+1/A2ObsntoO/EkHl+ez7DSgh7Aza20=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lqgBiHQsW7dA+zuDn3jhVNIe4txNzHkd83mHmdjUGVnwU5eSJ1x2UStI3bnuBteF6gfQ8vX1/C8nKTQPVosLf4lxlT/EArAFz4Mp159OcixagYWDGHMd6kL03xFOr1IVztCOgSsls7MUGh+NRF040DUo0oQBIDiCygdUXYl1Wig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W6HxbwsP; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W6HxbwsP"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493e4ccccc2so25567775e9.2
        for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 00:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784015889; x=1784620689; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O4Va9/3fzJvfM0bModCoGUiBD/cgXboTZMAPr8id/xE=;
        b=W6HxbwsPIIbivKodrovJjANef+lzT0KsOLNattSdQB146cJt5IHcCHT7JCmkGAv2Re
         BUcRNj6SregR2/3V5ldQNMe1fxottrjDO1poMDu1EwlPcmJEQ/TjZucqtuYp9CoACTdD
         E0A0UZQRqzpvBp8hpmm19BaShEnUC3pqk1cHwsePUfGShUcQcakoG9se95AvjUiTiDs2
         owUqdKheFUBiKUoQkayACjR53DJFjhMt6bGDZ4LoEYO5PYtn48L3LY3MgfFr4I5WQlsX
         Rc/UdLWJXNqMvzm0mh7M431oTdP8pr16GYZSoDotjOiYH0cCRQDULLXaySARk+rVPI+m
         7sGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784015889; x=1784620689;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O4Va9/3fzJvfM0bModCoGUiBD/cgXboTZMAPr8id/xE=;
        b=TmCtwsDzWa71ai+vS5VvjLRttEKvpg+5m3fMBROwqd8JY6npboTF+gK/CUjsITPpaX
         XJJh7OwXLvef5anAkaoofimdXURNcu0fJdz+8AubHGxRq5WE6DcO2v7H7ggUDQBsZJmG
         RzOFTdG4l1EErSlYC6EytzveES0XwSw2EkG6MPrCBdYr0j5b2d07X0CyZwN9jzYm+OYv
         8mkRQyGMkbWP0r+kYFjSv6G6JHzGbpPNZ2EzrDLv/tiia3d40MEraDbzehZy3LkjPXR3
         EFj/6sI4R9Wt2dlpAGz90sdRUE39fTydrST6aazE2oyWeLTiTV+a2jaqTZoKm1ZVxCl2
         Fk8w==
X-Forwarded-Encrypted: i=1; AHgh+RrZ9OCgk8s0oIzvyf4wXeTZjacB10DVAyAGQY8g4vTW/Jh5U3T/yRUapCMmWWkrZ0Kc6+KVSLVE1sCut60=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeZJdj29S1fIo5ULxnRgkAjr/N2AIkUGoBsZxfzh4h9uSd6lWW
	bp41el5b7E15XWx3TDxeI8paw+kyAjoLg/tsmK70IwSI4VuOOTFtPAju
X-Gm-Gg: AfdE7ck91RGlcRkL3upRWs/Koi5oVdMWxOqfjmgf1N4ulJUGTyZoCQwN+i0zzKy9y8E
	AEMWCG6X20C77kVdzTCz2ROxifdDGB5HIavwZryU4Qr38zXvXcBeP85JI7Cg8WPdxW4icXgrRMK
	pHDqFfy/sKLdqkGPLm8HlxYAiIgnA56CMZSkLc3i0U9NsPmBzeckpe5yvqRkdx/H92A/uZFTohd
	SvSM6LsFyf+NX4EyGitPsV+pmMW40dpehF50uNilASHU2DPQgPI1zwV8m0047ues29ja5eyz+PV
	3zWDcMulp3DCV9QCpCaJQUXar63flcbsSxhMXU/m33f1wOCCUwOVuqT+9pjNmJjPW3jeg+5w+0g
	m25+zT19KWq4tNpBFKXYwdB9hP2e9AjahvDh+F4D6Nre6/Luf83SJI4j/APkrIDb6xXQ+w2oXZQ
	baPhR4DRj3SMqaaNswfptYHe8VvCJxcg1aXQu8ZLVTa4a9167vvg==
X-Received: by 2002:a05:600c:1d9a:b0:493:c8f7:3631 with SMTP id 5b1f17b1804b1-495389bcc3fmr12972915e9.22.1784015888603;
        Tue, 14 Jul 2026 00:58:08 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4950a2f635dsm58640505e9.12.2026.07.14.00.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 00:58:08 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:58:04 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/33] lib/crypto: aes: Add CTR and XCTR support
Message-ID: <20260714085804.189692f8@pumpkin>
In-Reply-To: <34db35e3-7d6e-4ce2-bd3c-cbe74b321bc4@redhat.com>
References: <20260707053503.209874-1-ebiggers@kernel.org>
	<20260707053503.209874-5-ebiggers@kernel.org>
	<40932e40-a909-4b95-b739-c4727c1cc153@redhat.com>
	<20260713235439.GB24654@quark>
	<34db35e3-7d6e-4ce2-bd3c-cbe74b321bc4@redhat.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 14 Jul 2026 06:53:32 +0200
Thomas Huth <thuth@redhat.com> wrote:

> On 14/07/2026 01.54, Eric Biggers wrote:
> > On Mon, Jul 13, 2026 at 10:39:53AM +0200, Thomas Huth wrote:  
> >>> diff --git a/Documentation/crypto/libcrypto-unauth-encryption.rst b/Documentation/crypto/libcrypto-unauth-encryption.rst
> >>> index fb8106034089..6aca01d715da 100644
> >>> --- a/Documentation/crypto/libcrypto-unauth-encryption.rst
> >>> +++ b/Documentation/crypto/libcrypto-unauth-encryption.rst
> >>> @@ -27,6 +27,13 @@ Support for AES in the CBC and CBC-CTS modes of operation.
> >>>    .. kernel-doc:: include/crypto/aes-cbc.h
> >>> +AES-CTR and AES-XCTR
> >>> +--------------------
> >>> +
> >>> +Support for AES in the CTR and XCTR modes of operation.  
> >>
> >> I guess you already have this on your radar, but just in case: It would be
> >> nice to turn this into a full sentence, too.  
> > 
> > Yes, I'm making all of them full sentences.
> >   
> >>> +/**
> >>> + * aes_ctr() - AES-CTR en/decryption
> >>> + * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
> >>> + *	 overlaps the behavior is unspecified.
> >>> + * @src: The source data
> >>> + * @len: Number of bytes to en/decrypt
> >>> + * @ctr: The counter.  It will be incremented by ceil(@len / AES_BLOCK_SIZE).
> >>> + * @key: The key
> >>> + *
> >>> + * This implements AES in counter mode with a 128-bit big endian counter.
> >>> + *
> >>> + * This supports incremental en/decryption.  The length of each non-final chunk
> >>> + * must be a multiple of AES_BLOCK_SIZE, and the updated @ctr must be passed in
> >>> + * each time.  
> >>
> >> Maybe add some wording that ctr ideally should not be 0 for the first call,
> >> i.e. a "nonce" value?  
> > 
> > It depends on the usage.  If a distinct key is used for each message for
> > example, always starting at 0 is perfectly fine.
> > 
> > I'm not sure how far we should go to document the proper use of each
> > algorithm.  Really the AES-CTR support is just for internal use by
> > AES-GCM and AES-CCM, and a few odd users that implement specific other
> > protocols that need AES-CTR.  It's not intended to be a place to go to
> > receive an introduction to CTR mode.
> >   
> >>> +static __always_inline void inc_be128_ctr(u8 ctr[AES_BLOCK_SIZE])
> >>> +{
> >>> +	/* Casts to u8 are needed because of the implicit integer promotion. */
> >>> +	if (((u8)++ctr[AES_BLOCK_SIZE - 1]) != 0)
> >>> +		return;  
> >>
> >> Why do you handle the first value separately here? The code could be
> >> simplified to start with "int i = AES_BLOCK_SIZE -1" in the for-loop
> >> instead?  
> > 
> > Just a trick to optimize performance by unrolling the first iteration,
> > since 255 times out of 256 the first iteration is enough.  
> Ok, but then maybe add a comment here. Otherwise people will wonder why it 
> has been done like this when reading the code later.
> 
> FWIW, I doubt that this really makes a big difference here. Looking at a 
> function that contains your code, the disassembly currently looks like this 
> (with -O2):
> 
> 0000000000000000 <inc_be128_ctr>:
>     0:   80 47 0f 01             addb   $0x1,0xf(%rdi)
>     4:   48 8d 57 0e             lea    0xe(%rdi),%rdx
Those two run in the same clock.
>     8:   74 0a                   je     14 <inc_be128_ctr+0x14>
Depends on the 'addb', hopefully/likely predicted non-taken.
>     a:   c3                      ret
Predicted taken using the RSB.
Execution continues speculatively after the call even before the memory read
for 0xf(%rdi) has completed.
>     b:   0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
>    10:   48 83 ea 01             sub    $0x1,%rdx
>    14:   80 02 01                addb   $0x1,(%rdx)
>    17:   75 05                   jne    1e <inc_be128_ctr+0x1e>
>    19:   48 39 d7                cmp    %rdx,%rdi
>    1c:   75 f2                   jne    10 <inc_be128_ctr+0x10>
>    1e:   c3                      ret
> 
> So that's 3 assembly instructions 'til you reach the "ret".
> 
> When you drop the optimization, it looks like this:
> 
> 0000000000000000 <inc_be128_ctr>:
>     0:   48 8d 57 0f             lea    0xf(%rdi),%rdx
>     4:   eb 0e                   jmp    14 <inc_be128_ctr+0x14>
>     6:   66 2e 0f 1f 84 00 00    cs nopw 0x0(%rax,%rax,1)
>     d:   00 00 00
>    10:   48 83 ea 01             sub    $0x1,%rdx
>    14:   80 02 01                addb   $0x1,(%rdx)
That depends on the 'sub'
>    17:   75 05                   jne    1e <inc_be128_ctr+0x1e>
That is likely predicted not taken - so you get a misprediction penalty
>    19:   48 39 d7                cmp    %rdx,%rdi
>    1c:   75 f2                   jne    10 <inc_be128_ctr+0x10>
>    1e:   c3                      ret
> 
> That's 4 assembly instructions 'til you reach the "ret". Not such a big 
> difference...?

There is an extra 'jmp' - that will cost in the fetch-decode part.
The alignment pad (not there in the kernel) might also force another
i-cache line be accessed.
The first conditional branch is mispredicted - say 20 clocks. 

In any case the instruction count doesn't really matter.
What matters is the length of the register dependency chain and how
the branches get predicted.
I've gone back and annotated the asm.

> 
> And with -O3, both variants end up with the same code.

No one sane would compile the kernel (or much else) with -O3.
It bloats things too much.
gcc isn't that good at optimising loops for modern cpu. 

-- David

> 
>   Thomas
> 
> 

