Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D13716407
	for <linux-crypto@vger.kernel.org>; Mon, 13 Nov 2023 08:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZyVNEcTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F33C433C9;
	Mon, 13 Nov 2023 08:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699865158;
	bh=R+YbthBcWevS7QzDZRR/F6r4B8sEoGTPJMyLzjiosuQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=ZyVNEcTFWImhOFKPvYsHFQb5stuA+e/SmpH2fYBMNBISo1egD0gNGodevw6knUE5h
	 zSPElYpE94YyhKpC92hn1Qj51I/b9WyXSY7lfPGK41TQAv/sva7CatXRfJc1D0upRt
	 OEPPCa6xs5yWzdBh9xqMo5/EUDSmvoM9J9bblshzV8DRAkQHYTvf0TIO+6xhEiB5dV
	 6T0IZcjlVC+vfhsxI2bln7iYX2E/yi0qJtUewPx8ZrvuG+c9f4KDhFEPxuS7N2tgtv
	 ZF5dbJ0PJxCeR5n5RFgOpn77nt6F/38U9wqKV0nPmfx4wzEcf7KCBKHYfSUWBPDaR9
	 707NWAQYZh0lQ==
From: Leon Romanovsky <leon@kernel.org>
To: Mustafa Ismail <mustafa.ismail@intel.com>,
 Shiraz Saleem <shiraz.saleem@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-rdma@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
In-Reply-To: <20231029045756.153943-1-ebiggers@kernel.org>
References: <20231029045756.153943-1-ebiggers@kernel.org>
Subject:
 Re: [PATCH] RDMA/irdma: use crypto_shash_digest() in irdma_ieq_check_mpacrc()
Message-Id: <169986515442.285886.8959271939050774739.b4-ty@kernel.org>
Date: Mon, 13 Nov 2023 10:45:54 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d


On Sat, 28 Oct 2023 21:57:56 -0700, Eric Biggers wrote:
> Simplify irdma_ieq_check_mpacrc() by using crypto_shash_digest() instead
> of an init+update+final sequence.  This should also improve performance.
> 
> 

Applied, thanks!

[1/1] RDMA/irdma: use crypto_shash_digest() in irdma_ieq_check_mpacrc()
      https://git.kernel.org/rdma/rdma/c/42c9ce5203de6d

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
