Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9E4187FFE;
	Wed, 28 Aug 2024 14:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724855607; cv=none; b=OxIMuggM4i9JNJZoQEg8YUMH3IWTvCnDXshSrUJrYRa0xzmVJEO6RMIqhXjh7aZ0ZKjZtZp4UcbibPooHtRsb6m+zMIa52QcAnAj9z3WzBCBic2sCP9toJwByjyqmvOY70x1mhHUdym9ZUjvyV3c6+XPwHMN1KdgGZo0sCMCHkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724855607; c=relaxed/simple;
	bh=PF6UF1fn9hMI8JR/Cy+zzGr4iIff+A46TvVgp9cEggQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VjoXjY7ezl0H9u0/iQISOL5yjGQBmg5KWGDXLJZ5qYuWDt8P41xsSyJcECDnFE2nkTeBdoTl/qq+WkyK9gVyF+oBwFogqthz/OFYvs01aD59+GGxknk5ghC8S3uHeG3hNzoHpYHuP7EpIWhDeTaztxX25j2W8sBOUXBASS6bvU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=SCPpGUve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="SCPpGUve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A396AC51A85;
	Wed, 28 Aug 2024 14:33:25 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="SCPpGUve"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1724855603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Sj8wnYnfQbOIZ6p5fQLvU8adgvsiFvV+DlxgShrGCK0=;
	b=SCPpGUvevfCrWoju4NgLvGSiajbpC2Pqm0pb/81FOhuQhvognSNNP9UxM+jjBQjF1mnspl
	dmUra7fc++56EyPxvNpqIVuPuennXds0Me+c2fj71luJR4MOsaga8OBrpzfLvUr6IOo2P8
	ranNJeNFYDiiTOic7b1FUhn9ihjDKQo=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3f7cb780 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 28 Aug 2024 14:33:23 +0000 (UTC)
Date: Wed, 28 Aug 2024 16:33:20 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Xi Ruoyao <xry111@xry111.site>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 1/4] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
Message-ID: <Zs81MFn93DRfhjq_@zx2c4.com>
References: <20240827132018.88854-1-xry111@xry111.site>
 <20240827132018.88854-2-xry111@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240827132018.88854-2-xry111@xry111.site>

On Tue, Aug 27, 2024 at 09:20:14PM +0800, Xi Ruoyao wrote:
> +extern void __arch_chacha20_blocks_nostack(u8 *dst_bytes, const u32 *key,
> +					   u32 *counter, size_t nblocks);

As of the latest master, the forward declaration here isn't necessary.
