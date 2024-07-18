Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B32877F2C
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jul 2024 23:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721344466; cv=none; b=kKjFULC2Zi6Zhtu+FSKMcJUmcantJ0iyEiCvwVWs/V/ztdUzh931edCQAOx3z1nvHYG/+HnnBvbc6L64/gD/ZFkq6JkDwG/McCzmylPKFATpVyEdU2DNuzWboFgBlcVhFmhNpgbY5JOoNXsM/Ynq+sEaFmjJYQnbGPggPhfAY30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721344466; c=relaxed/simple;
	bh=lwCQ3RqpIS7D64LHT01YQB3FMaupHjYiipi2lAPfVhw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=axCabwxmswfH3n6ulWO9Fv1iNUj8+S+OVhTgx3bFkqEophGOhdF3EeKCxecQ1URJOCPg8dWTrj2fXNSNEGcj59UvkTnf/O8nILnCtrxBBEG4mmECQCpMlIgYzFnMitr+I0106tlQj//xythEAEmADTVngowvyskpwVLPnjibT9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aYTvzBTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aYTvzBTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C72C116B1;
	Thu, 18 Jul 2024 23:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721344466;
	bh=lwCQ3RqpIS7D64LHT01YQB3FMaupHjYiipi2lAPfVhw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aYTvzBTGcLc9/ugDIJy8U76mKjzyrrh90dFAKuDXZsgw+d4ArCRXr8O2qF6Qo0Vh3
	 6hvYI6Fx+eUoL2HSG2UCTfxDs96AI1r0o+2HRqhOOvEr51TwYc7Hu3/Vr8Jh1WGULe
	 TuqGMF5XwoyK/Z1YEcysXHw9ybhmwIv/xvg62IhbrxEKx3LmCX22b3vMY7Z4O3p41o
	 5xk32phujj8Unr/6Rg7q/m7ClLsMycEBWZ2e0OPFaymwoZxfJXpGAgQDt3cSU65Lxa
	 s5YNMU6fgGiWxk3loTllk82g4e5ScZfHjGc4YJWNd+9BUHHJPPnQxRyrwJZ0ky5awz
	 I8QonjxMZecyg==
Date: Thu, 18 Jul 2024 23:14:24 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/8] crypto,fs: Separate out hkdf_extract() and
 hkdf_expand()
Message-ID: <20240718231424.GA2582818@google.com>
References: <20240718150658.99580-1-hare@kernel.org>
 <20240718150658.99580-2-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240718150658.99580-2-hare@kernel.org>

On Thu, Jul 18, 2024 at 05:06:51PM +0200, Hannes Reinecke wrote:
> Separate out the HKDF functions into a separate file to make them
> available to other callers.
> 
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Hannes Reinecke <hare@kernel.org>
> ---
>  crypto/Makefile       |   1 +
>  crypto/hkdf.c         | 112 ++++++++++++++++++++++++++++++++++++++++++
>  fs/crypto/hkdf.c      |  68 ++++---------------------
>  include/crypto/hkdf.h |  18 +++++++
>  4 files changed, 140 insertions(+), 59 deletions(-)
>  create mode 100644 crypto/hkdf.c
>  create mode 100644 include/crypto/hkdf.h

I was only sent patch 1, so this is unreviewable as there is no context.

- Eric
