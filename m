Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E295F4FE
	for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2023 04:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KsHK2C7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563E6C433C8;
	Tue, 28 Nov 2023 04:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701144796;
	bh=kAFkMvBuLfoHgFynFH6S+wAYd5BKHuLLlWYI0TgSnM8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KsHK2C7QQNAZvE2TpT26qgP1ecn2xqUubax583ZQy5fNMPwpmu2nys/t5HsPExq+g
	 wG+FFNol9mfsKnM+zqMiItVBu6YQ4psJBxsJXd9eWz7J8X/y41QYBUevA8jbCO3nhk
	 Y5W2quyU6plh7doZG9VKUbYXwzIHeQIQEeaIiN9KeitQ1tXtLNgRdondYiZYicad7i
	 BEtxWIUZxyjBe+cJ9aX1JPJtwPv6gGiYDpptmYPfB9/3I7WyRr4Ob2cD4RoRZ0duXx
	 CiRknHcsC8zqx6J7XaRuvFva0sPGO0R7xHj4fbMufD6iN1eW2IGRKo4iNN7aW0Z+DS
	 E4aRjGvVaEdkg==
Date: Mon, 27 Nov 2023 20:13:14 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jerry Shih <jerry.shih@sifive.com>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	conor.dooley@microchip.com, ardb@kernel.org, heiko@sntech.de,
	phoebe.chen@sifive.com, hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 12/13] RISC-V: crypto: add Zvksh accelerated SM3
 implementation
Message-ID: <20231128041314.GK1463@sol.localdomain>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
 <20231127070703.1697-13-jerry.shih@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127070703.1697-13-jerry.shih@sifive.com>

On Mon, Nov 27, 2023 at 03:07:02PM +0800, Jerry Shih wrote:
> +static int __init riscv64_riscv64_sm3_mod_init(void)

There's an extra "_riscv64" in this function name.

- Eric
