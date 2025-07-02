Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD7E1C700C;
	Wed,  2 Jul 2025 15:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751469518; cv=none; b=GGQzmQRl2zquWLL1qB6lDkmDwGGcxN6ZTSIBvuABKEqOpgmLWkjSsZ/Wgug23530wSnJ2V+/pdBtmYb+s6l9KNqxGGd6NBorif1Ol8WaLTFA7C2iG3Wj1KB06BZt8OVAbWKHmf5kIUqvGJaCOvJ/kuJQLTrYz27KZM1eJW+ba/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751469518; c=relaxed/simple;
	bh=oF9g4X7KgjS/c6li8VSN+63EDU68bK9gdw5MKEWVQ8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rvS+R5Jfr3BRHGoLirG9lm9oHalCKxwYPP3m+eER3lJ+LN8koDHJ5Hm22oaeLYbbWMWyielc0OmZJFV1QSZZw5poMTQls62qwm0Tx1kZMEs37u/z9liXBYxKtFrWqqmO9VYprBV3wajl5IMJnaB2rvYoyIoxKPEpKb7U5ov2HLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uTcgQomD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uTcgQomD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612DCC4CEE7;
	Wed,  2 Jul 2025 15:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751469517;
	bh=oF9g4X7KgjS/c6li8VSN+63EDU68bK9gdw5MKEWVQ8M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uTcgQomDunwklFtclIOdvGA6h5WV7hjLjzpfSE/47Lm0NDsfZ/e6H5Na7YUt/9kUJ
	 xRj7Qo3LJqsRhQlUKSyBEhw9z598o5Xx2P4YnLE0jUpot9PGwu7VEsHeaIuIuHdVba
	 wfCwscvLH36Z5IelO2prPUuQJsVDplP+6zZuW0+dgg6Idqqr1s6FLTNlpArGe6faG/
	 TKkle3LootKUBy/Qy3cDhcU91124hAgF8ccB5StwokBbcaenomPDWcrgR/Z4FQxjjl
	 txvLHTFYOnP8dKigV1QVSV/grqikO++0NUdBfN6NveIvK2T1y7af2ASW0tRAe7alCc
	 l6Cw+Dw85j1fQ==
Date: Wed, 2 Jul 2025 16:18:32 +0100
From: Lee Jones <lee@kernel.org>
To: Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: herbert@gondor.apana.org.au, jarkko@kernel.org,
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	peterhuewe@gmx.de, jgg@ziepe.ca, linux-integrity@vger.kernel.org,
	Yinggang Gu <guyinggang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: Re: [PATCH v11 1/4] mfd: Add support for Loongson Security Engine
 chip controller
Message-ID: <20250702151832.GT10134@google.com>
References: <20250619025138.2854-1-zhaoqunqin@loongson.cn>
 <20250619025138.2854-2-zhaoqunqin@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250619025138.2854-2-zhaoqunqin@loongson.cn>

On Thu, 19 Jun 2025, Qunqin Zhao wrote:

> Loongson Security Engine chip supports RNG, SM2, SM3 and SM4 accelerator
> engines. This is the base driver for other specific engine drivers.
> 
> Co-developed-by: Yinggang Gu <guyinggang@loongson.cn>
> Signed-off-by: Yinggang Gu <guyinggang@loongson.cn>
> Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
> Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
>  drivers/mfd/Kconfig             |  11 ++
>  drivers/mfd/Makefile            |   2 +
>  drivers/mfd/loongson-se.c       | 253 ++++++++++++++++++++++++++++++++
>  include/linux/mfd/loongson-se.h |  53 +++++++
>  4 files changed, 319 insertions(+)
>  create mode 100644 drivers/mfd/loongson-se.c
>  create mode 100644 include/linux/mfd/loongson-se.h

This looks okay to me now.

Let me know when you have all of the other Acks.  Unless we decided
otherwise, this whole set should be merged via one subsystem (usually
MFD).  Once tested and merged, I can send out a pull-request for other
maintainers to pull from if they so wish.

-- 
Lee Jones [李琼斯]
