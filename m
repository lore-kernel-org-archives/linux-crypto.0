Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4C43D75A0;
	Sun, 11 Oct 2026 15:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791731575; cv=none; b=H9okMK1gG3rPhFp1ETU+liZWs94sk22jwSeypUFT0SbsFMF5Q8lbshc4oG7abVl4cwdKZHmZnKWZ4jv2jlH62alOD6vYBcagXetPMEWzMLelJVNoIzCCyy5QwOfaDZGUBQQpq8wJSzOT/XgHUjtyrfGLwMaYiDwhWPajKEaIIpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791731575; c=relaxed/simple;
	bh=AT3EOoHI6vEWhhOW/47tW8BmLzVJ7heHZlkdCzzvl14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MKF7cirB/fod0ZKImbOXwWPQCTqaK+AyS6MXJzgYLeAMUrLfrHwf9Q3M5dUBMYHFy4MOwM7IrW+Gz7e2ocl9F6RyIbOQKbV+cWJdgaLqlONP5qNCMEZnzB4tS3QVNuIBdUhlxxnd1os3D180GSvN4HF3j/AQzCZf9U5hVL9vySg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oPOCJBBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oPOCJBBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31821F0089B;
	Sun, 11 Oct 2026 15:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791731573;
	bh=pvICUiKV0JeddJgZDCfHSonuPLm3tzUGTCLppNrtDzQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oPOCJBBIaS+PlHrFKMzmE4tkRfKxBzkLoezE7h1HNor0o6tJdXORAjMEK71sfYwfO
	 z8GnoRid1+l7IT/60YojUqm0k0sCU9K9w/789Hm5kikRlFUepfyKIGQyjP7zkgIzH6
	 gFUXe1udwRQik1bxITsk4PnheXQ1SW06O2kcowTh9oafj+hJGYsWhYXzEWYsf2vvYD
	 x+4lEWWkPsC8fpa9X+edFv5tQs/0yLVece5HvAML+apbXxq1MqTbuWPPICTALhEaEn
	 19mXpwICuwzX/09hMhKDBfa1YbVBP2BS91jgs1TqrBLwf/SrLOhIjeodGwQjU1Dg9f
	 tr+2Opg7cxMaA==
Date: Sun, 11 Oct 2026 17:12:43 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org, WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
	Tianyang Zhang <zhangtianyang@loongson.cn>
Subject: Re: [PATCH 2/2] lib/crc: loongarch: Add 3-way parallel CRC32(C) for
 large buffers
Message-ID: <20261011151243.GB168780@quark>
References: <20261011142930.492999-1-chenhuacai@loongson.cn>
 <20261011142930.492999-2-chenhuacai@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261011142930.492999-2-chenhuacai@loongson.cn>

On Sun, Oct 11, 2026 at 10:29:30PM +0800, Huacai Chen wrote:
> The crc* loop is a single serial dependency chain: every instruction
> consumes the previous one's result. CRC is linear over GF(2), so a
> buffer can be split into 3 contiguous lanes processed by independent
> chains and combined afterwards:
> 
>     crc(A|B|C) = shift(crc(A), |B|+|C|) ^ shift(crc(B), |C|) ^ crc(C)
> 
> with lanes B and C seeded with 0. The shift (multiplication by x^(8n)
> mod P) is linear, so its multiplier is tabulated at module init as 4x256
> tables built from crc32_le_base()/crc32c_base(); each combine then costs
> 4 lookups instead of a log-time GF(2) square loop.
> 
> Lanes use a fixed 2 KiB stride (6 KiB superblock); smaller buffers fall
> through to the serial path. The 3-way parallel loop CRC32 is measured on
> a Loongson-3C6000 machine (single core, cache-hot, with UAL):
> 
>     8 KiB:   8.4 -> 12.0 GB/s
>     64 KiB:  8.4 -> 12.4 GB/s   (+45% over the serial hw loop,
>                                  ~12x over the generic table)
> 
> Correctness was verified bit-exact against crc32c() over all lengths
> 0..6168 with 3 seeds, plus 3000 random offset/length/seed combinations.
> 
> Signed-off-by: Tianyang Zhang <zhangtianyang@loongson.cn>
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>

So is this new code testable in QEMU?  That's a prerequisite for adding
new optimized CRC or crypto code.

Please also note that you should just run crc_kunit instead of writing
custom in-kernel CRC test code.

- Eric
