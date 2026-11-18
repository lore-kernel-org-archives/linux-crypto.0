Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794978481;
	b=rMIk1WFHkzXPm3DkrEJAJuIMt0tKZApbGqD8RumM/MUC1QbisVT2ysjrDqWtcUTZdM8z
	 Wa11e6gn9eTbHDEZvQcb1of1+lWVm8OTMzGOgOO88DTGf8/D77zzaxbVdIvUEm+mKYgb1
	 8cNqGnbEjiWD6whPJw14kHmfHQYiztCb0lxkxYpLZtuXsD4x9uI5gJJG4yhimDnV1PjJU
	 Y6w4kiDrkxHGwwYdOUAfw4FOwJpdP1WB0lgfPiB31IV/bvpS6g8bzkaIcigtxX0HTKY+9
	 OBNyIU9AX7mzwFVnUczD+Xzak0lIu7Ok6ptFDH19GxvxBZIMeiheIzQ9MiXB92A1PjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794978481;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=mGkb+EjOSlLHs2Hp50X4VPuLXnV4T0Mq79/QyiPYW5E=;
	b=Q81ObXOAfbQI7NVklFsJY+c2GzUSt1dgOFuyRIkYU0LQZPQGRtrSlAZUnd7rujkN+/EB
	 Fry3kYgvBsMuneYe55fy1kaMKHusTyKf7hsRHUnFlQLkvuDQcJVBnsTp+QaamKEO5R6GO
	 rIzqvIGf7BEPlsRla6bBH2Xo4RMoGAlfjOUGFbEpyZWW7R/UJo5JDFCf8ePfqAPzyeRRX
	 1paa/OEEeDkzrWO0zHAfC2Kg5f21F/tE1cKYFynQUP2QM1mgv0D/fPstt5DKNI4QmzdZM
	 FM96S+InehVfAxQSXc9mQmiJM4gEZGLeT8gW6AUDYKoSlehzIoHZNorqOXI0xHPnigQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YXeiifdf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FF3606A31C;
	Wed, 18 Nov 2026 05:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YXeiifdf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675D71F000C4;
	Wed, 18 Nov 2026 05:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794978481;
	bh=mGkb+EjOSlLHs2Hp50X4VPuLXnV4T0Mq79/QyiPYW5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YXeiifdf0c/VhG5hMZSwUNR54qAqBFdaXyJZbh5XcO/2sqRss6CDwRKOn3GvreXYA
	 N8sol7JhMY1rQdccZSTvUitx5wYvboW86yXgWSWAqMyOJFFfLQaulb3z3D+J1KKGNj
	 KDMuYXlqz5Q94NnaURODLkdhuwDGTuqKRTVpXT3y3saAU73g2ANCWZTuKGPqc7N+23
	 Q8zu1NrpoUOL6Gvlb3JNFhApR/lkmZ4+eUo6/6hPvi61HJLTfYG85N7R02b51F/fjT
	 iEBaFvS4e9nIPbqwTLRgJSI+dEhsnuXdSkDG8vMrQvHYn8169Rt/V6pDb5vdckAerd
	 hjtaO/DrnzNPA==
Date: Tue, 17 Nov 2026 21:07:58 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Dylan Hatch <dylanbhatch@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Weinan Liu <wnliu@google.com>, Jens Remus <jremus@linux.ibm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-crypto@vger.kernel.org,
	llvm@lists.linux.dev, Josh Poimboeuf <jpoimboe@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Indu Bhagat <ibhagatgnu@gmail.com>,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 11/12] arm64, crypto/lib: annotate leaf functions
 with CFI info
Message-ID: <20261118050758.GD3400@sol>
References: <20261117043504.1021063-1-dylanbhatch@google.com>
 <20261117043504.1021063-12-dylanbhatch@google.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117043504.1021063-12-dylanbhatch@google.com>

On Tue, Nov 17, 2026 at 04:35:03AM +0000, Dylan Hatch wrote:
> Several arm64 assembly functions are leaf functions (they do not call
> other functions and do not modify x30). Add SYM_[TYPED_]LEAF_FUNC_*
> macros in <asm/linkage.h> that emit .cfi_startproc / .cfi_endproc so
> that .eh_frame entries are generated for these leaf functions and LR can
> be recovered by the unwinder when an exception is taken from one of
> them.
> 
> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
> ---
>  arch/arm64/crypto/aes-ce-ccm-core.S    | 12 +++----
>  arch/arm64/crypto/aes-neonbs-core.S    | 16 +++++-----
>  arch/arm64/crypto/ghash-ce-core.S      | 20 ++++++++----
>  arch/arm64/crypto/sm4-ce-ccm-core.S    | 16 +++++-----
>  arch/arm64/crypto/sm4-ce-cipher-core.S |  4 +--
>  arch/arm64/crypto/sm4-ce-core.S        | 44 +++++++++++++-------------
>  arch/arm64/crypto/sm4-ce-gcm-core.S    | 16 +++++-----
>  arch/arm64/crypto/sm4-neon-core.S      | 12 +++----
>  arch/arm64/include/asm/linkage.h       | 33 +++++++++++++++++++
>  arch/arm64/kernel/entry.S              |  7 ----
>  arch/arm64/lib/clear_user.S            |  4 +--
>  arch/arm64/lib/copy_from_user.S        |  4 +--
>  arch/arm64/lib/copy_page.S             |  4 +--
>  arch/arm64/lib/copy_to_user.S          |  4 +--
>  arch/arm64/lib/memchr.S                |  4 +--
>  arch/arm64/lib/memcmp.S                |  4 +--
>  arch/arm64/lib/memcpy.S                |  8 ++---
>  arch/arm64/lib/memset.S                |  8 ++---
>  arch/arm64/lib/mte.S                   | 28 ++++++++--------
>  arch/arm64/lib/strchr.S                |  4 +--
>  arch/arm64/lib/strcmp.S                |  4 +--
>  arch/arm64/lib/strlen.S                |  4 +--
>  arch/arm64/lib/strncmp.S               |  4 +--
>  arch/arm64/lib/strnlen.S               |  4 +--
>  arch/arm64/lib/strrchr.S               |  4 +--
>  arch/arm64/lib/tishift.S               | 12 +++----

Presumably you'll need to update lib/crypto/arm64/*.S and
lib/crc/arm64/*.S as well.

- Eric
