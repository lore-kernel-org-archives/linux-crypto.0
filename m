Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ED018C008;
	Thu, 26 Dec 2024 19:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735242561; cv=none; b=rIzNxXSO7qVWghRwuW9kpifPPIqbO1WCsy4vDomVI15OUdUWhYkDzG16ZtTPsw4x5lnlcC77MD6WYjXpNYt3/rXf9zwsQzq7O1W8JPa+IO76uEUMaT78raXxJwN/9J1XZKfqv819YEulj/JRkr30tuYu8728ZyrCSutHChLyxMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735242561; c=relaxed/simple;
	bh=poFjjInoG54wj+h+pZENg988kvh7mtMzwNh3IW+0niI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hI1i3GmZjns3fcIRtMMf43p8CTlqRJzfPchdHbH2+9n4INlqD9cFZTQfeMsnaSDfPyLFPerUi8Q2xMT9WDvuwrv7iJ3Rd0jMDKeYAQnI5kMnnuURNT6TQkiBDloDppF7mVPccZCUy7hBLLl9VOrSANoQpIiTQFdIQUqrL+ignYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BUXEsdJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BUXEsdJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4784EC4CED7;
	Thu, 26 Dec 2024 19:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735242560;
	bh=poFjjInoG54wj+h+pZENg988kvh7mtMzwNh3IW+0niI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BUXEsdJcEN1nSrGf0us2xa2ChXRBtDiAmzJB6w68R19414XZ6ncR+L/hKx+6rO/AB
	 Oe6mniRvZGan/MSQyXbPt4ST8dfgHam+NKSri9NxJYV55KLpHQkdGfIEQTv3M20MrQ
	 cQjRrn3ojlwJLhfXC08t8pypScr4RuLV7xCi3awZryH06goqsSyJAz4KRxrRB/pcwV
	 Ab2CdSKMR3OSVJ3MSEc2uQQBDoNcCDJXCT5IuDMKQesiXWU1BUqBAd2ebISO/QXHf4
	 /z1/xsvBhRApUAdXL5voc03zulHeb/yURorBake6YUtOQkxMwneLJWG0j3nKSmRoFg
	 fSw7AMYbZw8dw==
Date: Thu, 26 Dec 2024 11:49:14 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Atharva Tiwari <evepolonium@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: vmac - Handle unaligned input in vmac_update
Message-ID: <20241226194914.GB4648@quark.localdomain>
References: <20241226170049.1526-1-evepolonium@gmail.com>
 <20241226190507.GA4648@quark.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241226190507.GA4648@quark.localdomain>

On Thu, Dec 26, 2024 at 11:05:07AM -0800, Eric Biggers wrote:
> On Thu, Dec 26, 2024 at 10:30:49PM +0530, Atharva Tiwari wrote:
> > The `vmac_update` function previously assumed that `p` was aligned,
> > which could lead to misaligned memory accesses when processing blocks.
> > This patch resolves the issue by, 
> > introducing a temporary buffer to ensure alignment.
> > 
> > Changes include:
> > - Allocating a temporary buffer (`__le64 *data`) to store aligned blocks.
> > - Using `get_unaligned_le64` to safely read data into the temporary buffer.
> > - Iteratively processing blocks with the `vhash_blocks` function.
> > - Properly freeing the allocated temporary buffer after processing.
> > 
> > Signed-off-by: Atharva Tiwari <evepolonium@gmail.com>
> 
> Are you using vmac for something?  As far as I know it is unused upstream, and
> we should just remove it instead.
> 

I strongly suspect this was just to address the TODO in the source code, and
this would be a good time to finally remove vmac
(https://lore.kernel.org/linux-crypto/20241226194309.27733-1-ebiggers@kernel.org)
from the kernel's museum of cryptographic algorithms.  But let me know if you're
in fact actually using it, and if so for what.  Thanks!

- Eric
