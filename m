Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C56527FD51;
	Mon,  8 Dec 2025 23:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765235354; cv=none; b=Nhc8JhTA3+UMZ+ptzzJg4ajKu3orHKrvFMd9BL70ROhbY10BGd/akYIzeZMzF4qH/gwoG+czf/b3XT6phKcImnnZV/uWHG4Sw+HG+E2wLHQgUBc1mwFmTDC87W3UllWYKWKs4jcmkiB64OYbOMSU2VPIU9ctRxaijs45P0t36E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765235354; c=relaxed/simple;
	bh=akhtEbJUiRojKJtbftuWFnBF21f5LJGNssVKktpsdgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AKWqWDbSAb8fhQQruwaLlx4ETS+YiJsgW1Eq81AuSwmV6QoW3OKN7VNLkMgbToiUXq01RoZ7c13ZVLWc0qLlnOey1AvKwbp9NgozNCa7w2ejovdxLxElafnNZvIzEhJ2X56MvZdi8Wc6A1qE3Hsg4tmnCHkzRO3j0dAR6j4MK3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PquNqk8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PquNqk8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C05AC4CEF1;
	Mon,  8 Dec 2025 23:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765235353;
	bh=akhtEbJUiRojKJtbftuWFnBF21f5LJGNssVKktpsdgI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PquNqk8stkQH3T6tYxNjnUGKCwEWKuga1Zdbz1UStzQZYMR9qhhn8PCafJNcMFXW1
	 OQVMlLkM/tzEPo5X+2IVJpcgNzIGCGQraCHumowp795cNudgPFdI/r/sGGqUwWVW0G
	 KicMoKbigreyVm/RIqMB6IpZZz3h6U0JMGamWDsk7B8ynHwjRy6NwykC/NUlAAfovX
	 jkwIMzdwFN61JqkSJ3xpYee8KdBkBr6KG/tfjps6OAxiVqVrpav9eMfGy2jY7h1+x2
	 aidY4AZbU8BUgnKvA8vJF4e274Ekab7Gz3LcMQrm/OKG/hjDcrYhyFYkMBRGCAQjTq
	 CnX3RgziD8t8A==
Date: Mon, 8 Dec 2025 15:09:11 -0800
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
Message-ID: <20251208230911.GA1853@quark>
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
> 
> Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
> ---
> Changes in v2:
> - Remove frame pointer maintenance, and simply avoid touching s0. Since
>   this is a leaf function, this also allows unwinding to work.
> - Link to v1: https://lore.kernel.org/r/20251130-riscv-chacha_zvkb-fp-v1-1-68ef7a6d477a@iscas.ac.cn
> ---
> 

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

- Eric
