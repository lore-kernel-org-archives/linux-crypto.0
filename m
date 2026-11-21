Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795290531;
	b=EeZgSwp0maQAI7qcqs9RP6p8+xi8ZBv4O1jrfr1a5rEjXUiIzgSRf2PGFVoFBz20eCnL
	 LjKaPWTqMeQPzm8Fne53B8UbR/XejrgX8R+jYpNpMd2TD6mfkWXJ0kxc1maopirtukRic
	 Wx/jMi9kQkSadbZ6JhUGr49AGJgJslOhBUcWBHwQZ3qTBhycnyceTpZrPbS8xdUtqGZgL
	 mA2hgnOkFqvT026FfwXO8XSPweX3Y49G2LE1l2tDfwhxC8a/4N/4mzGvV1bhljrC6JgRa
	 F+sWcLb2V3yUnMYfsI8SRZCAYbp8FolJaGFLETBxxjSiaUiaUtizCcTWTXIBPlTcgFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795290531;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=FNfXUEFx3KNT9v+Ggjhv1AJgo4iO4cxlU3+LWs139EA=;
	b=qGlmLLNiDiMLRlfpcaas0TdZLQgpwLK4FTfWMQ9AcvsjiKm89B/zAJxFm8Rqt+hIOW25
	 0xAwBzOENOCvlH3McZyhCt9AsdX403yWdfyzgj2xe3K3TytFoVy8LOPWzxwgWKXWlVOqK
	 xuyUvIASzIcSicjXzDL+zv99bwsPOssfn7mlnqfiE7RjvQalQEuRP/U91vofFUb0eu8RF
	 m2e6KhLoAd7Wy6AbyhG4ipQTfmMD+XodX+sIq23MJ+kW3CvpTaZalz5jmTYIrvomVeazg
	 FXWiD19v51ERtgpEYdkPQAc0SowoJ02MpD6b9OGAkXobVPOEmJxA7msiLNFKPGOnheg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d8i9iwWh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E77606A32A
	for <linux-crypto@vger.kernel.org>; Sat, 21 Nov 2026 19:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d8i9iwWh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312521F000C4;
	Sat, 21 Nov 2026 19:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795290531;
	bh=FNfXUEFx3KNT9v+Ggjhv1AJgo4iO4cxlU3+LWs139EA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d8i9iwWhKUrtlzrHSH6shNv9LBfChh904fuPTtPeiqY9a/UF4mFNadbFpbk23C9kc
	 yIsDDxInuo90Vbt0bC9YEcXQVUe7KWuUyuo98vEOpQinoOZEW2f+1MVHvWT+kllNxD
	 UpNGUC3UC4tiyFahUKidWeW8b0aCgNZm9eEpnRoQx4Q2UooczheB/g1S8gb2r7Y9Aq
	 r4ImUXYDH2OfF0nKvcA0yWYovpnMLBcJTDCy5kRePatojc5Rc+zXIztKB/e8xf3lj9
	 WRF955jj/ydurO5gw6eicj6ccM8nP2iVN991S5dSDtRkweCccv6pMIqmpWmWsL+sMc
	 5NjFg9tgEzE0w==
Date: Sat, 21 Nov 2026 11:48:49 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	Emanuele Rocca <emanuele.rocca@arm.com>
Subject: Re: [PATCH] lib/crypto: arm64/sha3: Use assembler for sha3
 instructions
Message-ID: <20261121194849.GA1975@quark>
References: <20261114204245.67919-1-ebiggers@kernel.org>
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
In-Reply-To: <20261114204245.67919-1-ebiggers@kernel.org>

On Sat, Nov 14, 2026 at 12:42:45PM -0800, Eric Biggers wrote:
> All supported assemblers (binutils 2.30 and later, and clang 17.0.1 and
> later) support the sha3 instructions now.
> 
> Therefore, drop the use of '.inst' in sha3-ce-core.S and just have the
> assembler generate the instructions.
> 
> This requires adding '.arch armv8.2-a+sha3'.  I also tried just
> '.arch_extension sha3', but that doesn't work with binutils 2.40 and
> earlier because they consider sha3 to depend on armv8.2-a or later (and
> this file isn't built with -march=armv8.2-a or later).  This was fixed
> in binutils 2.41 commit 205e4380c800, but the kernel currently supports
> binutils 2.30 and later.
> 
> Also prefix the immediate operands to 'xar' with '#', now that they no
> longer need to be plain numbers to generate an .inst.  This isn't
> required, but it follows the standard convention for immediates in arm64
> assembly, including elsewhere in the same file.
> 
> No change in the resulting .text section with either binutils or clang.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is intended to be taken through libcrypto-next
> 
>  lib/crypto/arm64/sha3-ce-core.S | 73 ++++++++++++---------------------
>  1 file changed, 26 insertions(+), 47 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
