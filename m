Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965E71FAE
	for <linux-crypto@vger.kernel.org>; Mon, 13 Nov 2023 08:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TW+8qALI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75469C433C7;
	Mon, 13 Nov 2023 08:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699864757;
	bh=uBhBQ7MMyj6BkkkbzmqbnntIKcSdxUmKjeRhih/37DI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=TW+8qALIbU5hkRwOu4M0zuEbIpInMlUPtcYBEKCnVLAC6HFQBFyRqMl29rNio7cPr
	 e2KCHDpBn2B1xr6sjYUwtSGblL2MYLcjhKQB2oD01S1u1RSHnB51Hqpd2Ih/21mvMU
	 5rBouiDwu2dxiEk40qd9dA6Hus4zG5YZO95cd7Bs5V53wjt/pR3jHF4SqvFUA3ANoS
	 420IFVhJba1UEyAb7Q21djywpUY4pjXxfVChhnTcMGdRRsrl3NjaWu/QKTHfyiP3AD
	 DYogZc9DniccyP2n+VsSGZICHMudrdouS3gX0un6S+X2j/KyYhyZ6mV6sL1LFw4EcQ
	 DweoGxCrsksCA==
From: Leon Romanovsky <leon@kernel.org>
To: Bernard Metzler <bmt@zurich.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-rdma@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
In-Reply-To: <20231029045839.154071-1-ebiggers@kernel.org>
References: <20231029045839.154071-1-ebiggers@kernel.org>
Subject:
 Re: [PATCH] RDMA/siw: use crypto_shash_digest() in siw_qp_prepare_tx()
Message-Id: <169986475332.283834.2146910872748586139.b4-ty@kernel.org>
Date: Mon, 13 Nov 2023 10:39:13 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d


On Sat, 28 Oct 2023 21:58:39 -0700, Eric Biggers wrote:
> Simplify siw_qp_prepare_tx() by using crypto_shash_digest() instead of
> an init+update+final sequence.  This should also improve performance.
> 
> 

Applied, thanks!

[1/1] RDMA/siw: use crypto_shash_digest() in siw_qp_prepare_tx()
      https://git.kernel.org/rdma/rdma/c/9aac6c05a56289

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
