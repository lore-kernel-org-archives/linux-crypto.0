Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C50200BBC;
	Wed, 12 Feb 2025 19:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739389930; cv=none; b=sHQ8gzThkPjgzhOCgSli3liGQOzQ3n+F6KeBx1RFilAJH/hFz5PKy/rFPe3uLL0jXkxXFu/cGX+6FZo+jnvz856TEjkd1o20CBuWf8wTYJq7Zmomboun2gaFe2OD3nHqQJ1m40pCo4dY/tM277KzOeYCQsPIQlScyTa70WRFR+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739389930; c=relaxed/simple;
	bh=MirLEMBUS3CsZ4GfrxE0VRsF/YJXIM51BRXXjBFtms0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tQeD5/e9PTODUqV5A3Xnug3YORCDOG+X17FmeZ/ShqwS8PZI+MeqyumdPHdcFgU39AZmS2m0MMK7PgVAqfEKXPfmZox44UQM6PdWYvyGNkgWSoCKZ30Di4ERI9+Y5XBgLPBOyX9lruuyFrq46wl5FE21aG4S0ATTkHxpws/9Clw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JY+xLVuf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JY+xLVuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7D8C4CEDF;
	Wed, 12 Feb 2025 19:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739389930;
	bh=MirLEMBUS3CsZ4GfrxE0VRsF/YJXIM51BRXXjBFtms0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JY+xLVufez0k6fR6Q7DZTWkhD/tkqmn1ZSdVQuGm0SJiBCXXT7u9mRKJi5LdZh9g+
	 1j/WnvF3nlLY2GZmdv4Gp6x9LzP19Izd5YOEGBYRjYfxPSio5rlxLj27g/HxG/ZtNy
	 2rW1C1WXYxOjqtnfbDDDDV9Xxv+IqQn/cQ6eFgu/TgQvzZGQLPC4jUAHK+1O82+k+q
	 4/ja/hr9jM12BqcyOGrIr4sv6XO5n96bDiup6lVZKMGxV7V7ofdhkuqfc83avPfKDx
	 85LttHzAgol5RRUiCDxcSYV91onhVTTEbGWfo3zxFieG/3zkpJZ9wkoepfzvvFdbc5
	 bMI1vq04B7GlA==
Date: Wed, 12 Feb 2025 11:52:08 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Zhihang Shao <zhihang.shao.iscas@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, ardb@kernel.org
Subject: Re: [PATCH v3] riscv: Optimize crct10dif with zbc extension
Message-ID: <20250212195208.GA128826@sol.localdomain>
References: <20250205065815.91132-1-zhihang.shao.iscas@gmail.com>
 <20250205163012.GB1474@sol.localdomain>
 <f827cbb0-f6ad-4397-9f30-ca43223c4853@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f827cbb0-f6ad-4397-9f30-ca43223c4853@gmail.com>

On Wed, Feb 12, 2025 at 04:08:51PM +0800, Zhihang Shao wrote:
> On 2025/2/6 0:30, Eric Biggers wrote:
> 
> > Maybe use 'const __be64 *' and 'const __be32 *' for the pointer, and use
> > be64_to_cpu() and be32_to_cpu().  Then the __force cast won't be needed.
> Maybe this problem seems dumb, but I have no idea to adapt both riscv32 and
> riscv64. I have tried to use 'const __be64 *' and 'const __be32 *' pointer
> in patch v4, but I forgot to test them in riscv32, and it turns out the code
> failed to compile due to my mistake of defining 'const __be64 * p_ul' and of
> course it wouldn't be work for riscv32. Maybe I need some inspiration for
> this problem, or I still think it better to use 'unsigned long const *'
> since it works fine in both riscv64 and riscv32.
> 
> Looking forward to your reply and guidance.
> 
> Yours,
> 
> Zhihang
> 

I'm working on this patch and am going to send out a cleaned-up version.

- Eric
