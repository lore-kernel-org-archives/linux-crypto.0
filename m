Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3EE21CA13;
	Sat, 13 Dec 2025 02:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765593025; cv=none; b=jnUhctt90MxUGzDAnN6SDr2XWG5aWQAhEWJRbkLhFw7pml2LApMFVKJV3NM1ZdTgEmyqOrdXFfLZbR8i8WhwvJVoJSZ6jz+99lYB9xFmz6MHuuJzjwm/ASuwFmX85MzPUcjYEs2C4HHP9zH688JfKDvgTtmTahlmkgG0FdDC64A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765593025; c=relaxed/simple;
	bh=eTbT3AU92DE1tjaPEckIZuyNYfDXAo1QlvRyHg2T6J4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aEM2O0pme9Bea6WI5/a0rlHoOKNj4KGZb+rGQp/HGapnNu7OKgBDbvrOOmNDdpXiB8QEHo7KHpWTCZSzygP7gMvfeHzCTE5wwSqlE2atXchuHLJkPocTrUaLg/gJ0i5VAJoBT05nKn5HsnEpv+RYpG03uA2XRoeXDrcUjExtZTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=unDOBcpo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="unDOBcpo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A64AC4CEF1;
	Sat, 13 Dec 2025 02:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765593024;
	bh=eTbT3AU92DE1tjaPEckIZuyNYfDXAo1QlvRyHg2T6J4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=unDOBcpoZODCMa1jcrL2BhidX/SEb7Z5cPfwpYt7nIuz/9N7VPvKtctmylegSdGxL
	 WtfjFyvWCjhG7jdoz/fHQvGiO/iA9zMnBJyfcNAxRoOxA1zyuSKRT50Z4puGAE+xLk
	 KBPjFcJyypRUmPvoh83XEDr+8jRyJ/RMYv1zIl62Py7wHPvLPAuqdeYJS5WTH0fm4S
	 r49X4BlKmfvpvT05CbCHnuSE33RZ++GzkUfgANeBS31O9WqC3OZS271GBxKDCH4HNT
	 hxmUqa0N+AFdUeaPa0Xu/ms3xPcDe/IRaNGkteGZ7moECK1Dr2mpl1xO6qnl+YxPIu
	 /w1pZaJxqaOoA==
Date: Fri, 12 Dec 2025 18:30:18 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Charles Mirabile <cmirabil@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-riscv@lists.infradead.org, Jason@zx2c4.com, ardb@kernel.org,
	zhihang.shao.iscas@gmail.com, zhangchunyan@iscas.ac.cn
Subject: Re: [PATCH] crypto: riscv: add poly1305-core.S to .gitignore
Message-ID: <20251213023018.GB71695@sol>
References: <20251212184717.133701-1-cmirabil@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251212184717.133701-1-cmirabil@redhat.com>

On Fri, Dec 12, 2025 at 01:47:17PM -0500, Charles Mirabile wrote:
> poly1305-core.S is an auto-generated file, so it should be ignored.
> 
> Fixes: bef9c7559869 ("lib/crypto: riscv/poly1305: Import OpenSSL/CRYPTOGAMS implementation")
> Signed-off-by: Charles Mirabile <cmirabil@redhat.com>
> ---
>  lib/crypto/riscv/.gitignore | 2 ++
>  1 file changed, 2 insertions(+)
>  create mode 100644 lib/crypto/riscv/.gitignore
> 
> diff --git a/lib/crypto/riscv/.gitignore b/lib/crypto/riscv/.gitignore
> new file mode 100644
> index 000000000000..0d47d4f21c6d
> --- /dev/null
> +++ b/lib/crypto/riscv/.gitignore
> @@ -0,0 +1,2 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +poly1305-core.S
> -- 

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

I added:

    Cc: stable@vger.kernel.org

(Since 6.18 is affected)

- Eric
