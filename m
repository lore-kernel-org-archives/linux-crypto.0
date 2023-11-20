Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53357D289
	for <linux-crypto@vger.kernel.org>; Mon, 20 Nov 2023 19:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R9jDPi+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FC7C433C8;
	Mon, 20 Nov 2023 19:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700508484;
	bh=D9xGetJBsZnX1EJOaSpAcRc2P8I2rT0kE7jgOjR+FqU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R9jDPi+dvngrxY4pnMjeT33brWQCVXkZfXA7MT1UUq8PmeWrCSwP1hJWed8+A2DDM
	 86oYWF6ArCAm1awiKjyewwtmI1MtTJRCs8mi1tY19UpN4LAx8/gkf0qvKQD6bhs1P4
	 IlO8/GJQCSS56lObJxhM3+IdURCjRn6QDNfoMwCxLYkSYl75TKLaSc8bgo01hn6p0C
	 HK9okuAbttEQEa+uMxH5ge0TrGqN6gWuezVceBwwtYTnRFcnnwuVhFzwZRydcCeI2w
	 xmP5RzEn8lZTWZ5eqx9ismJjW21Jn6s3rsRfIQAhhDnJ0ffyFz5p/gFtqtLE7dDNk3
	 omZ0xyb3++HpA==
Date: Mon, 20 Nov 2023 11:28:02 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jerry Shih <jerry.shih@sifive.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, palmer@dabbelt.com,
	Albert Ou <aou@eecs.berkeley.edu>, herbert@gondor.apana.org.au,
	davem@davemloft.net, andy.chiu@sifive.com, greentime.hu@sifive.com,
	conor.dooley@microchip.com, guoren@kernel.org, bjorn@rivosinc.com,
	heiko@sntech.de, ardb@kernel.org, phoebe.chen@sifive.com,
	hongrong.hsu@sifive.com, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 06/12] RISC-V: crypto: add accelerated
 AES-CBC/CTR/ECB/XTS implementations
Message-ID: <20231120192802.GB964@sol.localdomain>
References: <20231025183644.8735-1-jerry.shih@sifive.com>
 <20231025183644.8735-7-jerry.shih@sifive.com>
 <20231102051639.GF1498@sol.localdomain>
 <267FDF51-7720-40AC-9416-B5361C45393B@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <267FDF51-7720-40AC-9416-B5361C45393B@sifive.com>

On Mon, Nov 20, 2023 at 10:47:29AM +0800, Jerry Shih wrote:
> > There's no fallback for !crypto_simd_usable() here.  I really like it this way.
> > However, for it to work (for skciphers and aeads), RISC-V needs to allow the
> > vector registers to be used in softirq context.  Is that already the case?
> 
> I turn to use simd skcipher interface. More details will be in the v2 patch set.

Thanks.  Later, I suspect that we'll want to make the vector unit usable in
softirq context directly.  But for now I suppose the SIMD helper is tolerable.

- Eric
