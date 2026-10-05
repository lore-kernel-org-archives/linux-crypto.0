Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241CD375AC4;
	Mon,  5 Oct 2026 13:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791207186; cv=none; b=IwQoBn/p4kAH/xe9Xsw8qwg223tuz2atziCQzICiGQ9N9N6c9UKk/fDi37GUTzrGEPZfaXHSuoeEDQguBq8fJbMDNw0yMNlvUjKfTTQFMmIP5sQWCnQ/Fs4I4gQMlNbEZ8lD5FQd1kx291PVmPriM6sHhYQM56geo527FFRZpHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791207186; c=relaxed/simple;
	bh=aT8PS2E3a7bhd924HAuIfPBfiLuL3+9jINhJTSwiUCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aFPNTX8c+g4GrmRQo29ElQB9uRaaFQw56xR/zEWwnFGI6a1ZpbrppqB9gKVQoNDKJUBns5kMQ4JUCdJOs8Zpu6ojtZMcCOsIU9mKl9GvyLGtdQ5tpjMAqRF4llDjqC2r+Sr2RfjOIIJKY0hn6mj3vF7EKfQrmqmiCM8I5m0u7q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E8cHoytT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E8cHoytT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8891F000FF;
	Mon,  5 Oct 2026 13:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791207184;
	bh=vRSjAn2HXlvNPh5TXJ1/OPlTSvXLCZd3301h7Tj9cBk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E8cHoytTQxKGfJUI+2+DLj0MCjcb74VDeahz5csF72vZZMuQIafv3kB9+S0G55aNQ
	 QXWjy3/QPf65PMWKJ88VDDpqMeWSB86ftruhhr9CPGb+SGvt9XswJBllpUJcyb3S7o
	 3N8fFTpNOnk0J8n7Uupc1yPk8O4LZjv/Ha7r6Ib4w6hegn2n+96wNMyhjJu3QbjUQU
	 qcnGdOMyCVrbkJsuiIaqdfI5NKHbFPfS5QPiHmEtvCo73XZhSeUcx7M6YOrv/EWye6
	 EAN/wFiFf7+b1zCmRAEWEf2KnvBCgY0X0La9r7PJvEp6BdXUWNjEr6q9q/EJkGwfZO
	 Gqi+YTYbMGYUA==
Date: Mon, 5 Oct 2026 15:32:59 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: Stian Halseth <stian@itx.no>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>, linux-crypto@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] lib/crypto: sparc/aes-xts: Add optimization using the
 AES opcodes
Message-ID: <20261005133259.GB3436@quark>
References: <20261004192812.4145406-1-stian@itx.no>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261004192812.4145406-1-stian@itx.no>

On Sun, Oct 04, 2026 at 09:28:12PM +0200, Stian Halseth wrote:
> Implement aes_xts_encrypt_arch() and aes_xts_decrypt_arch() with the AES
> opcodes, for AES-128 and AES-256, two blocks per iteration. AES-192,
> which IEEE 1619 does not specify, and data that is not 8-byte aligned
> are left to the generic code.
> 
> The tweak is kept as little-endian words, so that multiplying it by x is
> a 128-bit shift done with addcc and the VIS3 addxc. A little-endian
> store and an ordinary load through a stack slot give it in the byte
> order of the data, and the slot is cleared on return. The routines open
> a register window, as %g4-%g6 belong to the kernel.
> 
> With that, xts-aes-lib no longer has to be kept off SPARC. Register it
> there again, with the priority x86 and RISC-V use, so that it also
> outranks an xts(ecb-aes-sparc64) instance (priority 300).
> 
> On a T7-1 (M7), MiB/s unless noted:
> 
>                                xts(ecb-aes-sparc64)  xts-aes-lib
>   AF_ALG, 64 KiB, AES-128                     415         1092
>   AF_ALG, 64 KiB, AES-256                     390          936
>   dm-crypt on brd, AES-256:
>     sequential read                          1399         2559
>     sequential write                         1472         3480
>     4 KiB write latency, QD1 (us)            40.6         32.7
> 
> dm-crypt now matches aes-cbc-essiv on the same ramdisk.
> 
> On a T4-1, AF_ALG AES-256 goes from 238 to 544 MiB/s, and AES-128
> from 252 to 616.
> 
> Tested with CONFIG_CRYPTO_SELFTESTS_FULL, and against OpenSSL over
> random keys, tweaks and lengths, on both machines.
> 
> Link: https://github.com/sparclinux/issues/issues/106
> Signed-off-by: Stian Halseth <stian@itx.no>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
