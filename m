Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FA515746F;
	Tue,  2 Dec 2025 05:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764653592; cv=none; b=mqsknOMi54JXoKHOdQr1/hW8OCOM8eZZERbbZkRX+1e3T2v5w1iW5fwlIt1bYKCGpp4LT04ALwPhLjESGNwxCXmlFqfawhuJIWd7OT6ZZkHqVUoKfvbi/hglNZqyJAheozeFLU2JtzQr0l3jtX27c1vcLMtCLFGqF/zD1L16bTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764653592; c=relaxed/simple;
	bh=47IMsY1kQA4YwR5Mz8xcNpK665wyScNkGv3MmAg3+3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gOAxY/45CdQ/QfRLT5Xd5UI+E3u0jziR/XVy2LCemNiHnSnC3+oEReuOAXFv6YnCaVgkifikKfRhp1pc9GB85dS6w+kT426aGQ+Ww8bjygbZUE0Hiei0jmkmPP8paGO8SwM5PYfUT5MSMfr6++B+shUzD6dbnERz+fNOOn9LV8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FQ2Ua0Ki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FQ2Ua0Ki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274EFC4CEF1;
	Tue,  2 Dec 2025 05:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764653591;
	bh=47IMsY1kQA4YwR5Mz8xcNpK665wyScNkGv3MmAg3+3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FQ2Ua0KijlAy42Za3O/QMHe2KK77BMZyuCrHRTcbI01AGh5q5z/1eUMdAfnM0bzl8
	 NpJvnhAEG8DwxcfzU3DltT3xJrSsxxfRoEtRVacrd1+HZ6ClhkgYDCxTf88YeiKam7
	 zKM2Lc6XpovHqjr8GrJXFNev8pKyoLfa8zJYLzpGkxuA+FT3bAeVxL4NnLx2M/oIp4
	 Ed+1n8jz7MQLnnkUp36RA+WS8Bw+G5NlMIfsHFLLk8U7fmYj4xCIZqfSAiNP9VfLpB
	 6C8CvyulTJKJc5KSlAbIWUtaal+8AYQvAo9SEmXY5dhEwg+hYhQBMLo66Bbghr88Y2
	 SELkfRn/QpCMQ==
Date: Mon, 1 Dec 2025 21:31:19 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Vivian Wang <wangruikang@iscas.ac.cn>
Cc: Jerry Shih <jerry.shih@sifive.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lib/crypto: riscv/chacha: Avoid s0/fp register
Message-ID: <20251202053119.GA1416@sol>
References: <20251202-riscv-chacha_zvkb-fp-v2-1-7bd00098c9dc@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251202-riscv-chacha_zvkb-fp-v2-1-7bd00098c9dc@iscas.ac.cn>

On Tue, Dec 02, 2025 at 01:25:07PM +0800, Vivian Wang wrote:
> In chacha_zvkb, avoid using the s0 register, which is the frame pointer,
> by reallocating KEY0 to t5. This makes stack traces available if e.g. a
> crash happens in chacha_zvkb.
> 
> No frame pointer maintenence is otherwise required since this is a leaf
> function.

maintenence => maintenance

>  SYM_FUNC_START(chacha_zvkb)
>  	addi		sp, sp, -96
> -	sd		s0, 0(sp)

I know it's annoying, but would you mind also changing the 96 to 88, and
decreasing all the offsets by 8, so that we don't leave a hole in the
stack where s0 used to be?  Likewise at the end of the function.

- Eric
