Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA1636D9FE;
	Mon, 12 Oct 2026 07:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791789860; cv=none; b=Z5Yi9vvOoF29jCzsqdcgJfsQ4PelNJXTN4337O1FZ38ix82hmUpEEdQKKyGrq8y0AeFimYe+dTp47IX5AX6eE1qhMguc/AH/bMw3pPw3Ya1K6qCwELSJJpgwfCbnjI9dlDvNRdCXvshvLCiA+Ljp0+9C7d6p3GEubpYHT3SwcrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791789860; c=relaxed/simple;
	bh=KjVsv4xyVa9u2VoyBJ4ZqWQvKsRJ2KeSDHMdlfBGEWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DaNjuHs40wgMIa168jdefNcyWYidZQYkEyMs0BeyJmmwPrE063Agmc0mtzesaoCQ52RFJf9khjRzv6FqF4ogkf1KhpuvP+F++GM9f4BTZqZ3A6wJUAhRe8OO6jLIc7MR/lp6a2K0fpoY1HR3FPjjsPaMbIOYxE3YWXeMcFcL3Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XxwtubCq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XxwtubCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339541F0089B;
	Mon, 12 Oct 2026 07:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791789859;
	bh=P3wHb/EZ8441LC7+tG8lPoS+lQkqJwPDU4EThXyn6mI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XxwtubCqihCBwUqOYXors/gLJWNj3YCHwc5kGL+GpllLf0FH4JgrVaprqxUNyLXbe
	 UZTPvRt1IVzKD+hSN7j4o1H9mQak9Mdglbh40/oMzFesyXKqVQsuBasZBNUR371Jr+
	 ZTlneREyf/j3b+ZOMmy+c0Pflt8HRxp4WxK3BrAv0bquL55yDLPU0KiM/YDWWMQcCG
	 RStfMt5Levij+jqVNxi2I0L28yN1EfZdhmPtp4Ry695PaEgpJXeUCpsDyqE2fXf7Wu
	 7A8+tMB3WcQKLlIQZ26x9/tFfeTtx074/J2YYFdRbMQ1RJMnHySgbgfYz+T0bpWkTk
	 KgW0jZa1MV7wQ==
Date: Mon, 12 Oct 2026 07:24:17 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Huacai Chen <chenhuacai@loongson.cn>, Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org, WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
	Tianyang Zhang <zhangtianyang@loongson.cn>
Subject: Re: [PATCH 2/2] lib/crc: loongarch: Add 3-way parallel CRC32(C) for
 large buffers
Message-ID: <20261012072417.GB828441@google.com>
References: <20261011142930.492999-1-chenhuacai@loongson.cn>
 <20261011142930.492999-2-chenhuacai@loongson.cn>
 <20261011151243.GB168780@quark>
 <CAAhV-H4YwMFMQP1razrWDG=XKvBVyN64Hv0rKsA+TNN-4bt20g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhV-H4YwMFMQP1razrWDG=XKvBVyN64Hv0rKsA+TNN-4bt20g@mail.gmail.com>

On Mon, Oct 12, 2026 at 02:45:24PM +0800, Huacai Chen wrote:
> Yes, crc_kunit is passed.

Are you sure?  This patch reads 4096 bytes from a 4-byte buffer, which
seems a bit problematic.

- Eric
