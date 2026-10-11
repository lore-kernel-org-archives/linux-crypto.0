Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B9F44A730;
	Sun, 11 Oct 2026 15:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791730864; cv=none; b=GbkZdDfNUmGiwA3KkvSh3HqUXQ1g8URqHAD8EqeXgJfZlGU17cjPo4xJM5obiACH5rlXt13pQqphJ90bvvHL3p13BvvexTHE4xIhdl5AEBucW4aQgshS7ACa2Z3YuCVKlNO55eAlnB3/bY6fZ4Dmon1ZftRfKxDvk9cvqlhq1xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791730864; c=relaxed/simple;
	bh=8G7BZRLq3tOEUcGomMkQ50ujt0x/KpVVxNnpwA17Gx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DZzeR1jCClCfVF9WLcTxbPcf+cpt5NU09osxj4PKksOW5uTIPDepWbHhl1rQosDp8bdYOSunPEDXVLO8IsyPbr1SWMDqL134KkVSSza2YTmeQuUXoVLY2ZH7jR71GZz/4jovNovQJvvZO7TZUW5N9EwrcPa/8GDvZuNwBnn4fyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nlJ2evjX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nlJ2evjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0E81F0089B;
	Sun, 11 Oct 2026 15:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791730863;
	bh=ASnO93aOJb4LVqVNx8riBvf3yTKDm3sx2Oqf378HyGc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nlJ2evjXCwrwa6OeQXI9wDzTdtxCHYNXAtbBEd73vyjhNx+zSO+nLqC/C9YNDJMxf
	 THDqJj+kIFjXGVSkDFlsPEA9uE+g0HzjvQ9In6dfXQ5VngXpQfEZmwnwt6dNCE5Wsu
	 lAjsznGbsqzaAKFrECaF4+HYdgGLBipjoEsdH4ouAhpfaRqR9zTC0qJYHnVOEG0CDs
	 MsOTSqHQgPqY6rIW3nYTgoYHvzKUkBLgmyK7SMiIQgUOiWaHU9sMhRFRIChUyG9gd5
	 NC7DN9/Bb2FPP60R22e1RvkSPievEtw3jBT/pyBmfvZET2Iy3MtrfTgFfCpMX2QUDk
	 5SseXBrm75Xlw==
Date: Sun, 11 Oct 2026 17:00:52 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org, WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
	Tianyang Zhang <zhangtianyang@loongson.cn>
Subject: Re: [PATCH 1/2] lib/crc: loongarch: Use hardware unaligned load in
 CRC32(C) loops
Message-ID: <20261011150052.GA168780@quark>
References: <20261011142930.492999-1-chenhuacai@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261011142930.492999-1-chenhuacai@loongson.cn>

On Sun, Oct 11, 2026 at 10:29:29PM +0800, Huacai Chen wrote:
> +static inline u32 get_le32(const void *p)
> +{
> +	if (static_branch_likely(&have_ual))
> +		return *((__le32 *)p);
> +	else
> +		return get_unaligned_le32(p);
> +}

No, this is just broken.  The bare misaligned access is undefined
behavior in C.  Also, every other use of {get,put}_unaligned_* in the
kernel would need this; it is not specific to the CRC code.  Also, it is
inefficient to compile both code paths into the binary.

The only way that realistically works, as we know from the other
architectures, is for the unaligned access support to be known at
compile time, and to have {get,put}_unaligned_* do the right thing
accordingly.

Since loongarch made the incorrect decision to not specify unaligned
access unconditionally, similar to RISC-V it can be worked around only
by overriding that in the kconfig.  For loongarch that appears that
already be implemented; just unset CONFIG_ARCH_STRICT_ALIGN when you
know the kernel will run only on CPUs that have fixed this bug.

- Eric
