Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF0C179A3;
	Sun, 16 Feb 2025 05:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739683538; cv=none; b=XELI6jBTKJy2OB6U0QqowBAf+hNhLiiiFaSTu98dI/R2g0ZeT8HHW7hGKooysHvE2GKF8JPuA5fOMU9mkOASan/9VamBhPr2RXpF+y9rpFI7vebxtBP6nbapJjUDTjVozbtti8LXJ9U6zPS5FZjxbrup1nN5TRhfSUzYxa6d+iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739683538; c=relaxed/simple;
	bh=E1PEQFRhCS4n7p9krpKfU5W/DosUhYeqrxkk/zHIF08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ha/LeS8JC4459TfPbczeojuMbBJXoUSZ69U8Fs1vgNDJecFYG+lf8yc3dD647FQcIkzNQYcyuMV+gSUdKkNe+FA1KLyFsolcZKnMBZxHL4eBoXRsAHPGPGVCGEHzAjf+klk1pHXkV/nPNI1qHdWXbBcb92xTWbdk4YPwC9P04pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MaS5V+5Q; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MaS5V+5Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1Xj6WolkhQsmKLkxiHNBfiO9vOrDoIGKF3dwDdOhHDU=; b=MaS5V+5QILt73e+0l4CJVpTDtY
	Z46xKlqAQWlt3p4rRUKYtHW/yPe9dvwGtbsgiocgCFKQX+3wijW9apQ0AiasFl5pXJLG9jPUZZ+sy
	KvoXMb4aFyORoQU6mFFTyGMzOXtWw0/qXfcMLbciS9TSv30RC4Faw78EOVU5ym+6KjyfPGA4Vx/5g
	OubzGyC98Qy+PTrb2Z+ErF6hbumCA5t1uayo5W1Gp83VXlAG0SS6ihst4nTXlzJfhrmlmXELglDVb
	4UyI2i2ieG9Azp2ALwcCHOap5fyJY90VnjLNXGBgqmR5GnbBuX58JF0PqGF9Q0kW6GNawirBoHO3p
	YaX7NE1Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tjWwt-000hJk-1t;
	Sun, 16 Feb 2025 13:25:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Feb 2025 13:25:32 +0800
Date: Sun, 16 Feb 2025 13:25:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, liulongfang@huawei.com,
	shenyang39@huawei.com, qianweili@huawei.com,
	linwenkai6@hisilicon.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH 0/3] crypto: hisilicon/sec2 - fix the specification
 problems for the sec
Message-ID: <Z7F2zG5lvPuGSaAa@gondor.apana.org.au>
References: <20250205035628.845962-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205035628.845962-1-huangchenghai2@huawei.com>

On Wed, Feb 05, 2025 at 11:56:25AM +0800, Chenghai Huang wrote:
> From: Wenkai Lin <linwenkai6@hisilicon.com>
> 
> 1. Supports the case that the auth key length is 0.
> 2. Check if the aead authsize alignment is 4-byte aligned for cbc mode.
> 3. Fix for the specifications not supported by the sec hardware and
>    use the software api to do the caculation.
> 
> Wenkai Lin (3):
>   crypto: hisilicon/sec2 - fix for aead auth key length
>   crypto: hisilicon/sec2 - fix for aead authsize alignment
>   crypto: hisilicon/sec2 - fix for sec spec check
> 
>  drivers/crypto/hisilicon/sec2/sec.h        |   1 -
>  drivers/crypto/hisilicon/sec2/sec_crypto.c | 125 ++++++++-------------
>  2 files changed, 47 insertions(+), 79 deletions(-)
> 
> -- 
> 2.33.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
