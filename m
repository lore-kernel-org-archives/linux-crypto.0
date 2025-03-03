Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C24C1DFD83;
	Mon,  3 Mar 2025 20:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741032914; cv=none; b=I59LKldy1YARXOl5YeNM7heQVAXApV6r3PAB1t+yWJaaFMEa8oIC0Cf0NgF2GZeCN7Hul5P5/1YJ+9kJ42l1f4X1TE+DnUm3gsuskN1/pXvOeGQzAkA+GuN1y2YzCGCahwxLtjVqCgYk+qb7CexWEMiusFw53Uy5WVshqU7KdTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741032914; c=relaxed/simple;
	bh=a7tjVGX/fWg7trjOFWAiSMlw93q/R3mkYEIjqIsDTq4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l23kRd3yBbShUFBJmk3qRK11gE/teBPr/mztiN7YrXezGlBFANh4To8htxH9bGGVySsoO3yAueQwx677RMDZ4vt5ZNM5v/eDc9ce8TFNq+7N5l5u4uIj4jMpzL4ggjQYSneA+EgcEDf60WCyFXB9N97M6G+yH8qNvcxm/dQCvqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nKmVwFwo; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nKmVwFwo"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-390e88caa4dso2249139f8f.1;
        Mon, 03 Mar 2025 12:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741032911; x=1741637711; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6HISwtThj2ckJiw/oP+EKb6mnu3LLOXUZTz/QPS9xm0=;
        b=nKmVwFwoFnvJVOKfhEML9dWXRlWkI4KpIqfJBkbXlahQrB2LrMltddwLQMe656ldgo
         GULDgn3T4RVnikSOdqp18++YXoM+IuTw+dfOekKYxJgEe/sYr3V/l935EU6tNkcYAjxD
         CxdMUK6jtbPL6/5M+dUSMLTw8r9SdttPiPsK98h/aWDJ2j/ZjaaxyNQkmdo4KvFZzyHM
         cXRa+AXvN9PuQ9WPO4wI5ka7KNoyAodQPYoEz2WMsviQ93EyxNLnSsG4qgYs/Ig6arah
         P8Hx/NMUJI0uBf8XRRI0selBKQnpBl6zPKWBHoAJD0QKlnKhvUb8BMvysqIHdqUMa9tV
         moYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741032911; x=1741637711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6HISwtThj2ckJiw/oP+EKb6mnu3LLOXUZTz/QPS9xm0=;
        b=sTbQx6KTx4fxCB0r1X/JqQK3gNUSxI7b60JcvlHeoJLCZCHaqj0lmUQH7lSrBPfqpO
         cM+YZtSQCIodRNDDoa7ZuMKuoUQQY3S2UhSjbyD4TDC/Y0weg0+ewWV7e4qvTw8+Nu5G
         xNCcK1RsAKNOAuRR+Ih0H1sbo70+C3Suh1LxnbcpIOKl4f7PxjzxhHPwyN4ahGoP5eLv
         KhcbI7LOPMXUCX4TN5J4hm4X3C0KLrLXs8TzZtySF0IwyEV8EcIZ2YtrBcYP3PuRkRHW
         YquSqe4qiLSPbegFUhmhdl5/5MHjrnZytxXn6OGkgqmrelVgXeVFxcNDvdViDRuBeLOA
         jpuA==
X-Forwarded-Encrypted: i=1; AJvYcCWte//7wz0qQ1sYYCzaqQQwE25nCaXaSWNCMS285/Zh4Gd7xkvV3jf2rDTifM4tYll3ayb1t7Jha6CeqIY=@vger.kernel.org, AJvYcCXycBb2pTvz/AdkvY/ggRODC4Q/ZTMMR6TEv+rbeSqKsRhOekbxJ+P2oS/CWbWYDIaoJJZjNplla0inN6iT@vger.kernel.org
X-Gm-Message-State: AOJu0YzsBfIH0w5H2HmVU5AsvDx3EexWWvXJSi1bBx/aOvHUa7ctirWE
	BrAQs7qtX1PUfvnMm0+CFQlyjGy+0zQ55I1/BhDU22ozh9Hg3fSr
X-Gm-Gg: ASbGncumYC/MBjDGtSLLeWlLP3ooOYMA+8dHHSVJ2x+0dP01WllXyodkQalI38lMhXB
	D75QSMFCdWNZccX1tdBinj4bPRaPJdQPVXj/MiYIiiSrtUD5g+G4chlPOhpNhlNOtn3z6IidgJi
	i1XLKA/unWgTAuh1G7CRd35R06HzCiYxfWc7Tyz0GdoV8cxtA3hYh86DtB5xmcXYbCsEzEnh91P
	9ShIez0jQ8m9+RqNelXhJXMZ7y5zemuKYDuSY0YyTjW0WXqEo8oImcIG5t4g8jjv6VY5qncmON0
	I8SX/IrbNpQyENvsC2rLkwYySJerYmg1TPd0x5bdXP5csn8XPqFBzFYEHmNVGiCHKIu4wgiyXl3
	+ZLCQS/s=
X-Google-Smtp-Source: AGHT+IEZcFcEwop42cS1sSfMsNTzvj2OjK7gTdBaNBV75eJDj3qnhXXQFC1+gCRjILig9VtED+gPKg==
X-Received: by 2002:a05:6000:4188:b0:390:ea4b:e89 with SMTP id ffacd0b85a97d-390eca26303mr11107065f8f.48.1741032910822;
        Mon, 03 Mar 2025 12:15:10 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bbbff18b3sm62631025e9.24.2025.03.03.12.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 12:15:10 -0800 (PST)
Date: Mon, 3 Mar 2025 20:15:09 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Bill Wendling <morbo@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H.
 Peter Anvin" <hpa@zytor.com>, Eric Biggers <ebiggers@kernel.org>, Ard
 Biesheuvel <ardb@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Nick
 Desaulniers <nick.desaulniers+lkml@gmail.com>, Justin Stitt
 <justinstitt@google.com>, LKML <linux-kernel@vger.kernel.org>,
 linux-crypto@vger.kernel.org, clang-built-linux <llvm@lists.linux.dev>
Subject: Re: [PATCH v2] x86/crc32: use builtins to improve code generation
Message-ID: <20250303201509.32f6f062@pumpkin>
In-Reply-To: <CAGG=3QVkd9Vb9a=pQ=KwhKzGJXaS+6Mk5K+JtBqamj15MzT9mQ@mail.gmail.com>
References: <CAGG=3QVi27WRYVxmsk9+HLpJw9ZJrpfLjU8G4exuXm-vUA-KqQ@mail.gmail.com>
	<CAGG=3QVkd9Vb9a=pQ=KwhKzGJXaS+6Mk5K+JtBqamj15MzT9mQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 27 Feb 2025 15:47:03 -0800
Bill Wendling <morbo@google.com> wrote:

> For both gcc and clang, crc32 builtins generate better code than the
> inline asm. GCC improves, removing unneeded "mov" instructions. Clang
> does the same and unrolls the loops. GCC has no changes on i386, but
> Clang's code generation is vastly improved, due to Clang's "rm"
> constraint issue.
> 
> The number of cycles improved by ~0.1% for GCC and ~1% for Clang, which
> is expected because of the "rm" issue. However, Clang's performance is
> better than GCC's by ~1.5%, most likely due to loop unrolling.

How much does it unroll?
How much you need depends on the latency of the crc32 instruction.
The copy of Agner's tables I have gives it a latency of 3 on
pretty much everything.
If you can only do one chained crc instruction every three clocks
it is hard to see how unrolling the loop will help.
Intel cpu (since sandy bridge) will run a two clock loop.
With three clocks to play with it should be easy (even for a compiler)
to generate a loop with no extra clock stalls.

Clearly if Clang decides to copy arguments to the stack an extra time
that will kill things. But in this case you want the "m" constraint
to directly read from the buffer (with a (reg,reg,8) addressing mode).

	David
