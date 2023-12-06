Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFDF62A
	for <linux-crypto@vger.kernel.org>; Wed,  6 Dec 2023 00:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="la+CqPPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A3FC433C8;
	Wed,  6 Dec 2023 00:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701823619;
	bh=b5r5GxuYWHo36uh4ovYgu5m135G+N9ZSSwh0htqUnfM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=la+CqPPqfkLVqIiY+xzaHmGFS9CkyQKnrbETqIQqwbah3+lvOql3uSGTnKbd83GLn
	 CzuOC3tBU4YX+V8KeKYAKaiAHdqLsvqhqCFg79UNf+B39DvfMCQ6TyyGfa1uXiTgQu
	 VlXLmGB/edcKWRAWOUYlFMEIz0IXVwPjs+cKEXvZlGOhgd7iIzfj22r0+1vDGkIRxE
	 3LT0+Z1LetBYgNADApH2HDkkJ/mM04ENyOwRyK9PytwjoKUnF7Dgr+OxQzx/IF3oeU
	 CpYVPv9ANhxGcLcr/YNz+008+G6UFW1VV5Vd/GgNA57hTptrXjkS++E1NxT5ERcKXq
	 5Q8PKY4BV++Wg==
Date: Tue, 5 Dec 2023 16:46:56 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jerry Shih <jerry.shih@sifive.com>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	conor.dooley@microchip.com, ardb@kernel.org, conor@kernel.org,
	heiko@sntech.de, phoebe.chen@sifive.com, hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 00/12] RISC-V: provide some accelerated cryptography
 implementations using vector extensions
Message-ID: <20231206004656.GC1118@sol.localdomain>
References: <20231205092801.1335-1-jerry.shih@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205092801.1335-1-jerry.shih@sifive.com>

On Tue, Dec 05, 2023 at 05:27:49PM +0800, Jerry Shih wrote:
> This series depend on:
> 2. support kernel-mode vector
> Link: https://lore.kernel.org/all/20230721112855.1006-1-andy.chiu@sifive.com/
> 3. vector crypto extensions detection
> Link: https://lore.kernel.org/lkml/20231017131456.2053396-1-cleger@rivosinc.com/

What's the status of getting these prerequisites merged?

- Eric
