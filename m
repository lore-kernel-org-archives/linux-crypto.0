Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C84371CF2
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 11:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773745807; cv=none; b=E/UwnlgTQfx2St054l+bud571KeNVJY8GH5MFTQRo/OAWWeItAGt+vvA4yhR9NYG8WyXEy9/29Ojj7Xa6EarOWOs6/eRcGA+eb+Br9FYztl7+NGBiFbhwEPlbwP8oo72zwjzZgNnnhXBuTixUYqF1vHXDAlErRD1FdJUR4fHM4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773745807; c=relaxed/simple;
	bh=3WAjNRN04nQy+fv7l48vENykenWQ85FeesFLfakNvD0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=LJojZN/FoNhwohAvESayg9faQIi73QnrHM/5jK/PjO/ioUZxBYMVZcjCaQTnUAtVELb+BvN8b0w9rVbUWPn+6/B16Kmu3zbC7Z2sT9D09tcE8qHYTJW61/uQShxRWQFHEmzlSa6JCixpIelrBL2fX26PDrQYAkUXLJPr6qSPt4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k0ErCAZJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k0ErCAZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83507C19425;
	Tue, 17 Mar 2026 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773745806;
	bh=3WAjNRN04nQy+fv7l48vENykenWQ85FeesFLfakNvD0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=k0ErCAZJ8zmoZg+4jAZE1H8O8hMmyEozfmeMdbLbmVAall0SEZIe3FA+YWbvtHQnQ
	 KgA02E7hKovf5GLtZOT1WilHHHeweJSQVfdZpEhz4FET7RKVpD/KX6UDsCLDgOvuUr
	 l4bDiJus83VdYrOBjBpahT5qV0wec9NIe27Sy/7Z9Xrb+KfY0nxwt0VE7CoVutDUYv
	 Z5SNO/5IctR7zm2Y6eakeitQPuWwfyyKyTY5Cnm4ntBKf7+ukavS3VVRT0EzDPBXgo
	 6wcGZT6nOb0FKs6bdYQQX6pl9UzN8uOmYnbj4O9B4eJuJmO5AVM4c2u+cs1LN+ezr6
	 4+vwujiimJ2cQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6014EF40069;
	Tue, 17 Mar 2026 07:10:05 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 17 Mar 2026 07:10:05 -0400
X-ME-Sender: <xms:jTa5ae9g9SOHeQqsa0qKDEkuoQZbIZvlKWRTWQkthYx7IlW2x5rDLA>
    <xme:jTa5aZjTcz6X_-Bpy-NLQTxX_nspsG3HbhKKFxTp5_nAl8wRP8GHoMh0X_7ZfExx1
    pkegiuYBy45x2_5_m5e1TneyDZIZmzNhLNF8Pp0ZNHxb3UIDbdIab8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdduuddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeekvdffkefhgfegveekfedtieffhfelgeetiedvieffhfekfeeikeetueeg
    teetteenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    epudenucfrrghrrghmpehmrghilhhfrhhomheprghrugdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeijedthedttdejledqfeefvdduieegudehqdgrrhgusgeppe
    hkvghrnhgvlhdrohhrghesfihorhhkohhfrghrugdrtghomhdpnhgspghrtghpthhtohep
    iedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheptggrthgrlhhinhdrmhgrrhhinh
    grshesrghrmhdrtghomhdprhgtphhtthhopegvsghighhgvghrsheskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtohepfihilhhlsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlih
    hnuhigqdgrrhhmqdhkvghrnhgvlheslhhishhtshdrihhnfhhrrgguvggrugdrohhrghdp
    rhgtphhtthhopehlihhnuhigqdgtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdrohhrgh
    dprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhr
    gh
X-ME-Proxy: <xmx:jTa5achZyU1vLYIMGKbTt0dFFKmX5h6-484cf6PaICoRCjY3mVL96w>
    <xmx:jTa5aXTukjgbmF1dWzMMd88bsQI0KhA4xrG0utrPe_HLS9je8FSR0A>
    <xmx:jTa5aWWb_24DKbQVkjdwODOhSHtD9gYWDDlvG-Cj58hFnx1WgBMXBQ>
    <xmx:jTa5aTRWPU7t33hePwFFokMYAQF6cMx5xq_Ajh5-CiWQd2dluVouTw>
    <xmx:jTa5aYlANUOVa_XQ7Ut0cb4nw74QxgOExhOtO2Ob32WXqtANylhjtPSm>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 41604700065; Tue, 17 Mar 2026 07:10:05 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A3tCmaBtu5Tc
Date: Tue, 17 Mar 2026 12:09:42 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>
Message-Id: <7e88b710-2302-4b7b-8f11-4e25088bb3c7@app.fastmail.com>
In-Reply-To: <20260314175744.30620-1-ebiggers@kernel.org>
References: <20260314175744.30620-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crc: arm64: Drop check for CONFIG_KERNEL_MODE_NEON
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, 14 Mar 2026, at 18:57, Eric Biggers wrote:
> CONFIG_KERNEL_MODE_NEON is always enabled on arm64, and it always has
> been since its introduction in 2013.  Given that and the fact that the
> usefulness of kernel-mode NEON has only been increasing over time,
> checking for this option in arm64-specific code is unnecessary.  Remove
> this check from lib/crc/ to simplify the code and prevent any future
> bugs where e.g. code gets disabled due to a typo in this logic.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This patch is targeting crc-next
> (https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next)
>
>  lib/crc/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/lib/crc/Kconfig b/lib/crc/Kconfig
> index cca228879bb5a..52e216f397468 100644
> --- a/lib/crc/Kconfig
> +++ b/lib/crc/Kconfig
> @@ -46,11 +46,11 @@ config CRC_T10DIF
> 
>  config CRC_T10DIF_ARCH
>  	bool
>  	depends on CRC_T10DIF && CRC_OPTIMIZATIONS
>  	default y if ARM && KERNEL_MODE_NEON
> -	default y if ARM64 && KERNEL_MODE_NEON
> +	default y if ARM64
>  	default y if PPC64 && ALTIVEC
>  	default y if RISCV && RISCV_ISA_ZBC
>  	default y if X86
> 
>  config CRC32
>
> base-commit: c13cee2fc7f137dd25ed50c63eddcc578624f204
> -- 
> 2.53.0
