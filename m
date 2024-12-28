Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23EA154BE2;
	Sat, 28 Dec 2024 11:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735385794; cv=none; b=UR0wlyGgcajnWXQUr9x+beRtIxEmskxABLpNPSFuvGAwQGw6kqBr1S8b0m3dfC9BC9IfMeHAuDTQX26YDPrfDqDW8Y37bZRtIeiWTHXoZ+CyfVqkDLO3vPtc+M3JFxVZ6JJ8WJBCYzApluoU4JTz+0pgF5mKbFh4tXQVZlH7pi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735385794; c=relaxed/simple;
	bh=wgwYLSR/Pi9VXzZ8ygJPhcDlpIGtkIp7a7HCiH/bKf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TW8/AXlVaFJCvRdy4NWxaIVlPovKZ3gigPWvvNbxnfAPtFw5FY9vLOotgmM8q+vi611TVOuVtmg6WQ6LHYTuOzgSLEVgEg85/hpDl43hMeibqXvJBAK22kWU+3TrVJ2s/Pstx+kqE56/tMk8ysYyPoPVfN817xiKrz8sgQppN0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=D9xEXru8; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="D9xEXru8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Qv0c3ND11beStvUYmqNQu2TuZrBsx+u2XaK1VhIlI6g=; b=D9xEXru8t6medkC/D8y868RXLY
	gd5KHLUNC6WmOq5LgU86BzIVp7wDOZvBZ3Vy6AOPGAhTk7qXj6i2dTIK9ffLufWFLOaYtmHIcM18d
	xmOnDuO5IceefV/QyXZaHeuJJoRMcOPO3WKrh6p4rsHjAw4LTxFta/X/w1RwpA/ceNTuLHNyp90Dh
	DOL2a2wE5b8uFw+h56No+QY20X+k6ZJfRMPhsY78h/zqrC/APbDEJt536jjAMeZGQZfKc46+lVZxZ
	gi6PhoTdszHthUOT3ynjsC9INrK+7itT/ZOw3MG3VNI4UXKrmAuf+HRyAUEwjTP0zeO3uFol6tZSX
	qL57DHuw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tRUuE-003Z7r-0o;
	Sat, 28 Dec 2024 19:36:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 28 Dec 2024 19:36:14 +0800
Date: Sat, 28 Dec 2024 19:36:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Akhil R <akhilrajeev@nvidia.com>
Cc: davem@davemloft.net, thierry.reding@gmail.com, jonathanh@nvidia.com,
	linux-crypto@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] crypto: tegra: Use separate buffer for setkey
Message-ID: <Z2_iroxlT3C1d1HQ@gondor.apana.org.au>
References: <20241217161207.72921-1-akhilrajeev@nvidia.com>
 <20241217161207.72921-2-akhilrajeev@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217161207.72921-2-akhilrajeev@nvidia.com>

On Tue, Dec 17, 2024 at 09:42:01PM +0530, Akhil R wrote:
> The buffer which sends the commands to host1x was shared for all tasks
> in the engine. This causes a problem with the setkey() function as it
> gets called asynchronous to the crypto engine queue. Modifying the same
> cmdbuf in setkey() will corrupt the ongoing host1x task and in turn
> break the encryption/decryption operation. Hence use a separate cmdbuf
> for setkey().
> 
> Fixes:  0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
> Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
> ---
>  drivers/crypto/tegra/tegra-se-aes.c  | 16 ++++++++--------
>  drivers/crypto/tegra/tegra-se-hash.c | 13 +++++++------
>  drivers/crypto/tegra/tegra-se-key.c  | 10 ++++++++--
>  drivers/crypto/tegra/tegra-se-main.c | 16 ++++++++++++----
>  drivers/crypto/tegra/tegra-se.h      |  3 ++-
>  5 files changed, 37 insertions(+), 21 deletions(-)

So there is a maximum of 15 key slots? In that case you should not
be allocating them in setkey because there can be a lot more than
15 tfm's in the system.

Since the limit is so low they should only be allocated during an
encryption/decryption operation.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
