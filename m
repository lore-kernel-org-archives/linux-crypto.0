Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1511C2FAE
	for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2023 03:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Di770KJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C698C433C9;
	Tue, 28 Nov 2023 03:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701143138;
	bh=iUs8sHkTZHvgV4m7oQH03SHaVTmkC/+rsFHLswC0zcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Di770KJ8dOeJ74EzzegGRUa6qD1qCkdQpa96FR991b6MkcaeMI55ukBVgNIgJ74/8
	 AQYXl5jzn5x2Y7wEbRqSNQwktyHdtBurg1xytwHOCEvFd2nJPkcoRkB3bJNhZ2KAm7
	 gGu9PRlg3UcAmhz+OP9lY/BwvObgK5u83B6ggG4wvjEPmgcMiX9N6d50LSR9jjT6zv
	 tL29MNSFkF29D9n/P3hBLvEu98Lb5cEA4aAwZeIgCkR1SkVdr5cBYvfT71b6Z+RImA
	 hEz53xmbZz+Lrkoz4vP7FOTH5K9iBLEC+sJlBoRMo97u24ZDrJYBo2iQTJq+GKNWl3
	 vdncApXSdj61g==
Date: Mon, 27 Nov 2023 19:45:36 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jerry Shih <jerry.shih@sifive.com>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	conor.dooley@microchip.com, ardb@kernel.org, heiko@sntech.de,
	phoebe.chen@sifive.com, hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 02/13] RISC-V: hook new crypto subdir into build-system
Message-ID: <20231128034536.GF1463@sol.localdomain>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
 <20231127070703.1697-3-jerry.shih@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127070703.1697-3-jerry.shih@sifive.com>

On Mon, Nov 27, 2023 at 03:06:52PM +0800, Jerry Shih wrote:
> From: Heiko Stuebner <heiko.stuebner@vrull.eu>
> 
> Create a crypto subdirectory for added accelerated cryptography routines
> and hook it into the riscv Kbuild and the main crypto Kconfig.
> 
> Signed-off-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> Signed-off-by: Jerry Shih <jerry.shih@sifive.com>
> ---
>  arch/riscv/Kbuild          | 1 +
>  arch/riscv/crypto/Kconfig  | 5 +++++
>  arch/riscv/crypto/Makefile | 4 ++++
>  crypto/Kconfig             | 3 +++
>  4 files changed, 13 insertions(+)
>  create mode 100644 arch/riscv/crypto/Kconfig
>  create mode 100644 arch/riscv/crypto/Makefile

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
