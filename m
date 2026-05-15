Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528AD3A9627;
	Fri, 15 May 2026 10:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840361; cv=none; b=JSKO2UnmBCl5VqiHnae/dUgnZ0PDpNDLHjBzfuR6AWQtb/+Pz2vQmE29ksCvxz7sF4bvXVtsPaPe/bpU0wvkNQj2gt01d0yUywehLKjw+KRgD2ORFkiMPNpGl/Ufdkq6SQpcj6bOsstbcmhMqFTjoFoH1X03TazBVoq9T4/muwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840361; c=relaxed/simple;
	bh=LXL3mYrkU114bmJdDEMPNPL2bNzUhfPvVHgsmbEEhWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ulU9LMMgridcClgelFZ1WRgHdzH4d0xftRwjL4tEmbo66X2g1Yj2Ki4x1ogSW95Wun1HMEbIUskiK2FHiP07kBRJxTxZcMYFo/nB+31WdyKAOJSLzH/HL05VQaDfSO2KOZyLcY3K8YMhZbDxg8pf9FV/C+yCDdn6jKwO4IrwIN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ZiEc2znW; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ZiEc2znW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=+yIZQtkXFOLwPhwRjCzzI/VNNUQuXFrKdG/kcqjnh0k=; 
	b=ZiEc2znWb0+w1B3MlYFjF2+INrXep7wVIpUhti/t+OV9w7D0A+i/Sb7u1WlNiLc0lA9MDU2YjVo
	QRaQYrJvBaE/e+maNqf93Oe4YiiEbR8IsqZwaupWUHro3xYOpBsU7+XfEjeu/fsTnC4Db9ofYkGYa
	26+nLCWbkHDt2SiPFBCpuixEMF5tMwSDIrtXYMpyVwN14dEsigPvyptTadlMiygACIueGNNsi9VvS
	X7TlUjfZTQa08qeQw6IKZoDwx00RetipW9jo5kfgUrx/9YWT3wpbOMGdwQtPOMtibrt6k6RuVH/S8
	RiJjcGPJgCHYDZRdoknb3C1Aho2fcbWujPkw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNpdQ-00EOQS-2Q;
	Fri, 15 May 2026 18:19:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 18:19:12 +0800
Date: Fri, 15 May 2026 18:19:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Cc: George Cherian <gcherian@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: Move MODULE_DEVICE_TABLE next to the table itself
Message-ID: <agbzIHiVF4sN0pcX@gondor.apana.org.au>
References: <20260505102948.191683-2-krzysztof.kozlowski@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505102948.191683-2-krzysztof.kozlowski@oss.qualcomm.com>

On Tue, May 05, 2026 at 12:29:49PM +0200, Krzysztof Kozlowski wrote:
> By convention MODULE_DEVICE_TABLE() immediately follows the ID table it
> exports, because this is easier to read and verify.  It also makes more
> sense since #ifdef for ACPI or OF could hide both of them.
> 
> Most of the privers already have this correctly placed, so adjust
> the missing ones.  No functional impact.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> ---
>  drivers/crypto/cavium/cpt/cptpf_main.c             | 2 +-
>  drivers/crypto/cavium/cpt/cptvf_main.c             | 2 +-
>  drivers/crypto/marvell/octeontx/otx_cptpf_main.c   | 2 +-
>  drivers/crypto/marvell/octeontx/otx_cptvf_main.c   | 2 +-
>  drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c | 2 +-
>  drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
