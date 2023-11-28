Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62B96AD8
	for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2023 03:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HtlLnnuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3E6C433C8;
	Tue, 28 Nov 2023 03:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701143119;
	bh=mAazPanOHbBf1EpbjCncZ4WNSuavZPxp41OW/CwwxRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HtlLnnuUM2YaMmNqX508S+C7Qp+iKil8+8sWjiu/9VMk7LiQipfCRUzaBwJYhgplP
	 dZxLctoALIyGJzS7OpEHbiEIklOIiiU9dxVxgoE+t5kv5YSKsSsPg2mOl7GCh5gnXj
	 Q0O+zyuy0QM9VvFLnrJlDP4FHgDOq++v/yWGy3tEGRZcz52gGfFhwOhpxaOlGEvvWw
	 6e6k78IR+guspkCWWf9/iIYFOiCSFAai5hVGBbbRFAtypsZSnj2WK5e2+TDBY1FkwB
	 5rzKXkYdsaUfYofS5b66O8u4yyzmq5Iy2vK7aMkamVMVXq3SG2VL9gJ53d+TgcsSuy
	 8tEgq1ZtFO2cw==
Date: Mon, 27 Nov 2023 19:45:17 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jerry Shih <jerry.shih@sifive.com>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	conor.dooley@microchip.com, ardb@kernel.org, heiko@sntech.de,
	phoebe.chen@sifive.com, hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 01/13] RISC-V: add helper function to read the vector
 VLEN
Message-ID: <20231128034517.GE1463@sol.localdomain>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
 <20231127070703.1697-2-jerry.shih@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127070703.1697-2-jerry.shih@sifive.com>

On Mon, Nov 27, 2023 at 03:06:51PM +0800, Jerry Shih wrote:
> From: Heiko Stuebner <heiko.stuebner@vrull.eu>
> 
> VLEN describes the length of each vector register and some instructions
> need specific minimal VLENs to work correctly.
> 
> The vector code already includes a variable riscv_v_vsize that contains
> the value of "32 vector registers with vlenb length" that gets filled
> during boot. vlenb is the value contained in the CSR_VLENB register and
> the value represents "VLEN / 8".
> 
> So add riscv_vector_vlen() to return the actual VLEN value for in-kernel
> users when they need to check the available VLEN.
> 
> Signed-off-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> Signed-off-by: Jerry Shih <jerry.shih@sifive.com>
> ---
>  arch/riscv/include/asm/vector.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
