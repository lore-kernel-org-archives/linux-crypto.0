Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03D12D238A;
	Fri, 12 Jun 2026 15:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781277542; cv=none; b=SwE531+LHmMcitvqrs66OScL1qDDTTKZOiwUqgijc6jiMuP4K77BG4ajD2Q+5JaStrfspLFSM/9WWb0YkcdR92vywHBqn0zqI2RgtDdx5oWS6Wth3hncj4wSsHwneJ1ntBXC3IFyHsdQavDsErF21uLBBEqEdngzFoYxPH9Czdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781277542; c=relaxed/simple;
	bh=lbg+SMGsWp4BtP6lcfEB7aTWyTeoS0HsJIY8wK1JkE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yo6+Fi0I2qMmiWjyFLPk0M38SdyoKCY7w4cxckKgW6r0saEuAkwp9GbPWQ9VLR6OiwLWfGXeNZNSwQmeHUSfZ7o2asNK7WuPtZ2FPdhfDUYT+p9S/G/QMdgupEJnwPtYZBLcT7qzICkUFa+DQLL8PJTr8pZ67Q6KF0TmorP+J3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g6pRgvPD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g6pRgvPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02921F000E9;
	Fri, 12 Jun 2026 15:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781277541;
	bh=nJgg2z66KKWWL7qfq7s6kgAGlpbnhuz1ME1IVsqPCI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g6pRgvPD68YBp8bYZ82r0rJO7j2IiS6qvB+9qBBpyiBDC7N8goyNi85L+WYGpzlgW
	 I1J+x62OOs4QQYpzqyrA1AP9B/+48R7U59cAvdpsOyDPhyD3Fy2PY6O6W3CPvEUBA7
	 9Tc+SyJ/KeUif4j0L4yoVY1SJgevdrDKZE498WtlX4h17VKiGKOztOQvTacPlmqUfp
	 Q6+0i2riQiIFe1sZ3+Ctrtr7NBlztdBWl7WDzlDTe5AV8M4qPRwAlaZ2fqqdtEC06Y
	 CD8DZXwVbWQVfuPBKIR4eaFrI+9XXL1TZaJxtB9DEmCuZFl7YBlTETkEgc8E+yUwqG
	 EUGNvdDcFF2Lg==
Date: Fri, 12 Jun 2026 09:18:58 -0600
From: Tycho Andersen <tycho@kernel.org>
To: ZongYao.Chen@linux.alibaba.com
Cc: Ashish Kalra <ashish.kalra@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Michael Roth <michael.roth@amd.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Brijesh Singh <brijesh.singh@amd.com>, 
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp: Fix SNP range list bounds check
Message-ID: <aiwjJI_7VvTV4E5I@tycho.pizza>
References: <20260612092525.1203150-1-ZongYao.Chen@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612092525.1203150-1-ZongYao.Chen@linux.alibaba.com>

On Fri, Jun 12, 2026 at 05:25:25PM +0800, ZongYao.Chen@linux.alibaba.com wrote:
> From: Zongyao Chen <ZongYao.Chen@linux.alibaba.com>
> 
> snp_filter_reserved_mem_regions() checks the range list size before
> adding a new entry. If the page-sized SNP_INIT_EX buffer is already
> full, the next matching resource can still write one entry past the end
> of the buffer.
> 
> Check that there is room for the next entry before appending it, and
> compute the next entry pointer only after the bounds check.

> Fixes: 1ca5614b84ee ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zongyao Chen <ZongYao.Chen@linux.alibaba.com>

I believe there is a version of this in the crypto tree already as
1b864b6cb213 ("crypto: ccp - Fix snp_filter_reserved_mem_regions()
off-by-one").

Thanks,

Tycho
