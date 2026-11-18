Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794976573;
	b=1DOr6wm/JCcpoNy163Uu+DZXeE9uQoVmctQjSRxREmEi5G+pXPClmdYzF/hHmKTP1vNC
	 VY7B2Q9KKqMu12Q/H3VisG2r8hDal487Jbxn4x6wOVnzp1ruM6Ey9AVLFAH54ZgtB3FMm
	 6rd0eBezrx57nttlZbix3t+H+f7v7dPRwmI9md1C+HmFslu7du6fJJnVtvKDOlrKPR4iz
	 QVgplY5TmWmoFm67NLyC5Hg0HIwA0g3oEbxVwgecYRNCm98LGR0n48AagH1dHg+eX7cds
	 w0P05Ch4t4VH7fbxQcEuJQ/ibTXjAv25DrQ4cnQO3upi5fftUOXGsSb8nZ9vX5vFE9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794976573;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qNnE6g3+PUwbzFucpvqDKcl4G6oLiP5CvG99ZoUAkFQ=;
	b=2y62r3TTKeVKB27eUzbdcfLffQOGrwfgO6p/O+RUYad9PlCBPZs+NjSLkswIPHBL6cHG
	 tySfCoQFD7YGnA6LKhhwjIbf4d4s7gxFCwJxKHchDBRezxr3as/EzPOgiJsnkMPAOViKH
	 FGpn6ki87DZbwQfblmfNLv7FfUTg3bUI+GoNGUIiRdCfQqoj17u/biW+z/gLWQNuhFQHq
	 2AGFApZhXlkxX/j+8UKZmS/TTc2xp3+8mUPPzOA+V3tAI9CXd9HJPYVy/Z3SN149vCBzT
	 4te6Ad3xsmLLKzFh3JUuIsrckAIp6jt9KUYhKiYNx7FlqkRCU/gQRhkteVrgzID/ENg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ijCxQD2C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1012606A31C;
	Wed, 18 Nov 2026 04:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ijCxQD2C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5081F000C5;
	Wed, 18 Nov 2026 04:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794976572;
	bh=qNnE6g3+PUwbzFucpvqDKcl4G6oLiP5CvG99ZoUAkFQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ijCxQD2CQ+kBezr8SXEdJnk49KsHdZXBK3kaxICRgO4D66yPjZ9Lw0DM+Zl9A7xtN
	 ucmCdXYp4Xa1anZ17asNRahtQNGOy4kVJ8Ihl/LQ9aymwzhmH5r5xFtMQfMXFkr0bH
	 eoGvIpB8MjIef7vXhHTFLfUJFtogQcNuhuJMN1DCHAf/sQZfOBH9lbiK3mZu1ZZ9zy
	 +J8Yu9aQ4dpAe94Wjtgp17+oc6JTSRt0B3fpknmtoiI+PaCGOAdNUWTN99VIJ1zPys
	 j2jyZ5Jdp88CeJwFBCY7EAdvuXtyXE50I2P+hgdr5bY4B5tYa0yQ2JJyxGJ5MiSuuk
	 R2uupAQY2sy+Q==
Message-ID: <sashiko-outbox-220105@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 02/12] arm64: factor .eh_frame parser out of
 patch-scs.c into <asm/eh_frame.h>
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dylan Hatch" <dylanbhatch@google.com>, "Catalin Marinas" <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, "Nathan
 Chancellor" <nathan@kernel.org>, "Nicolas Schier" <nsc@kernel.org>, "Nick
 Desaulniers" <ndesaulniers@google.com>, "Bill Wendling" <morbo@google.com>, "Justin
 Stitt" <justinstitt@google.com>, "Weinan Liu" <wnliu@google.com>, "Jens
 Remus" <jremus@linux.ibm.com>, linux-kbuild@vger.kernel.org, linux-crypto@vger.kernel.org, "Josh
 Poimboeuf" <jpoimboe@kernel.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Indu Bhagat" <ibhagatgnu@gmail.com>, "Prasanna
 Kumar T S M" <ptsm@linux.microsoft.com>, live-patching@vger.kernel.org
In-Reply-To: <20261117043504.1021063-3-dylanbhatch@google.com>
References: <20261117043504.1021063-1-dylanbhatch@google.com>
 <20261117043504.1021063-3-dylanbhatch@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 04:36:11 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] arm64: integer underflow in CIE bounds check in
  eh_frame_next_fde()
--

commit 0cead277c4697d2464f308f0fb23b8a3a16a0749
Author: Dylan Hatch <dylanbhatch@google.com>

arm64: factor .eh_frame parser out of patch-scs.c into <asm/eh_frame.h>

This commit moves the DWARF .eh_frame CIE/FDE iterator and opcode stepper
out of arch/arm64/kernel/pi/patch-scs.c into a shared <asm/eh_frame.h>
header.

> diff --git a/arch/arm64/include/asm/eh_frame.h b/arch/arm64/include/asm/e=
h_frame.h
> new file mode 100644
> index 0000000000000..6c17fed1860f1
> --- /dev/null
> +++ b/arch/arm64/include/asm/eh_frame.h
[ ... ]
> +static __always_inline int eh_frame_next_fde(struct eh_frame_fde_iter *i=
t)
> +{
> +	while (it->size > 4) {
> +		const struct eh_frame *frame =3D (const void *)it->p;
> +		const struct eh_frame *cie;
> +		const u8 *cie_ptr;
> +		size_t min_size;
> +		int step, ret;
[ ... ]
> +		cie_ptr =3D (const u8 *)&frame->cie_id_or_pointer;
> +		if (frame->cie_id_or_pointer > (u32)(cie_ptr - it->start))
> +			return EDYNSCS_INVALID_CIE_HEADER;
> +
> +		cie =3D (const void *)(cie_ptr - frame->cie_id_or_pointer);
> +		if (cie !=3D it->cie) {
> +			if (cie->cie_id_or_pointer !=3D 0 ||
> +			    cie->size =3D=3D 0 || cie->size =3D=3D U32_MAX ||
> +			    cie->size > (u32)(cie_ptr - (const u8 *)cie -
> +					      sizeof(cie->size)))
> +				return EDYNSCS_INVALID_CIE_HEADER;
> +			ret =3D eh_frame_parse_cie(cie, it);

[Severity: Medium]
Can the cie->size bounds check in eh_frame_next_fde() underflow when
frame->cie_id_or_pointer is 1, 2, or 3?

Since cie is cie_ptr - frame->cie_id_or_pointer, the distance
cie_ptr - (const u8 *)cie equals frame->cie_id_or_pointer.  Subtracting
sizeof(cie->size) (4) when frame->cie_id_or_pointer < 4 wraps to
0xfffffffd..0xffffffff, bypassing the upper-bound check on cie->size and
allowing eh_frame_parse_cie() to read past the end of a malformed
.eh_frame buffer.

Also, even when frame->cie_id_or_pointer >=3D 4, subtracting
sizeof(cie->size) from cie_ptr - (const u8 *)cie bounds the end of the CIE
against cie_ptr ((const u8 *)frame + 4) rather than (const u8 *)frame,
which allows the CIE to overlap frame->size.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117043504.1021=
063-1-dylanbhatch@google.com?part=3D2
