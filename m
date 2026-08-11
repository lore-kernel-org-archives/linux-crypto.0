Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D0F3DCD8D;
	Tue, 11 Aug 2026 18:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786474335; cv=none; b=n5ND9A01aC9sj9EFLqaArkl+PKnae2tHLEv0wlFgl8U9l4mhVv1Oi96bLrSfoaZOrySqT7tjOMdhF6o9CDTuaEZSHp0cweaG1RTRjcMy6TJBkxUssg2ky+BNZkU2Rg9G6DSrdKhMv+hIhvpaPivkLcDyXELg7lyDZYdpw19WWrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786474335; c=relaxed/simple;
	bh=G+NaQLTyYY2pNl5bZ3e7NQR+2GBXpxrOqz0IObpJa7A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ll53F5nbyZpsHvgvvF+Cjcecg8lsawXEyP0rSsIbOHyNpjhBJZLwSHcgxGK7QTOdijpzM02Bswh5j16f2YdYvBRAQfG5Z3h4lbxB8H0Cq2VfTT+CO3RUdXLIReT5fAnK8GsfIAqgYh9a6/RelF0pJ81MJ70isIEd6Zuvw0EjbY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eQ3H7m0s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eQ3H7m0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FFD1F000E9;
	Tue, 11 Aug 2026 18:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786474334;
	bh=fllhlD9JR2X+lJWzx3BXk7XfctiewMpFvgqVu9s0Nak=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=eQ3H7m0s1Btx6N3972GqIG5N1Jo2aaKW5dgge+IjqH92jcMIPRCgRtRjeRk/Pgk58
	 t54u1v0uGQ2EShjLdvuIdagNBL8IjF3ce4eiNelIuL45XY7vfVavNEgPj4czPAG4lB
	 oGBg2FS2CsP/FxSfSBdqoU5NhXLRDzig+Hyzuu3ESLPNvoxskiEUtNbfDo4gBt89jp
	 OZnwymrrCzuCO9TAKYKifmb37c6F0a2/Wk1bIUAUlwQp9VTvrRCS3Sz+ol+V1F76Su
	 7+eYcYtc00kYCFI2j+vY9SfWkNVnCNbL5Sxmtw5LX9edZ9omiTMNNGk7SMfxLLD0Fg
	 9n7G9RKWwhc/Q==
From: Vinod Koul <vkoul@kernel.org>
To: Dave Jiang <dave.jiang@intel.com>, Frank Li <Frank.Li@kernel.org>, 
 Kristen Accardi <kristen.c.accardi@intel.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, 
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
 stable@vger.kernel.org
In-Reply-To: <20260805-iaa-crypto-fixes-zswap-v2-0-55c02694f499@intel.com>
References: <20260805-iaa-crypto-fixes-zswap-v2-0-55c02694f499@intel.com>
Subject: Re: (subset) [PATCH v2 0/5] crypto: iaa - Fixes for multi entry SG
 lists
Message-Id: <178647432965.1113716.8156058778454772233.b4-ty@kernel.org>
Date: Wed, 12 Aug 2026 00:22:09 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13.0


On Wed, 05 Aug 2026 14:19:21 -0700, Vinicius Costa Gomes wrote:
> Since commit e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs
> from zsmalloc"), iaa_crypto started seeing some failures with
> multi-entry scatter lists.
> 
> For that we introduce software fallback, in patch 2/5, to iaa-crypto
> when SG lists have more than one entry, for both input and output.
> Patch 4/5 adds a bounce buffer so small/simple requests can be
> linearized and sent to the hardware. This recovers most of the
> performance.
> 
> [...]

Applied, thanks!

[1/5] dmaengine: idxd: assign all engines to group 0 in IAA defaults
      commit: 4a8b7929550eb94d60b32c2c06479444672da381

Best regards,
-- 
~Vinod


