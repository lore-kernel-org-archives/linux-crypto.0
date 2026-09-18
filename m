Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494674343F2;
	Fri, 18 Sep 2026 09:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789725274; cv=none; b=Ui7adAnoXsy+ycWmUUYl9R0eD0hAMjmgk5UafTsiSZDdF4xJhVnrt9ztLJ4V5nIeyZKzUtGpO2F5c6hegq8OeWUZc3XwtKcAyTopQzeE9aOM1wf19tKYetCah3I+uAd1F81ykK7KQA1itB5tVUCUgFzhI1II6yCH+TFPDmpMrWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789725274; c=relaxed/simple;
	bh=hkmJSAFONAPXXBUdmavUrbDYmt9YHbfsebDpW7tdGBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ltzjbXWVFB2l1z27kFxuePzlmyIBWqA9CWhXDDQsZ2sANxjF6A1YdHQ4AvGEHg9fT99313Yne6XrLDwasjyKFjSSNvw4ZL7VOhhkUcYTwqpuaI2qvMCqwoGRmXCr2f3mtEsNB8sUig2spKWamvwo3p7f8jlh2lr5MRURQ6QDpCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=BCVr90uR; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="BCVr90uR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=kMt7o3T5uUv20HjYgOfM0t0mH+fD9HVr1xfqdEKSJaw=; 
	b=BCVr90uRlRxRuJh3Y8AOTFAVsX5cvjnxNQkEtc79U6UX79AU4cSgHYxJSrpd8WYzXtrxpyEalT4
	/gkL5hgTFuJOHkEBLolvp6QoUcPIz/OssCt9Xqh/vvQo5Z+gj3pYgHrWa0dokfbHZ1pogCqiS3Vhl
	NUtc6A7mGAZdoQVM1g7YPabVEWA6HuC7zPEybXLmKOhyyfeUAxhKniA5t04aB+YKNmhrgIqkUGqiI
	TgeVUyP5WOdDePxf5g8bj0UVLKd4Pw0k7lumv5NG4JJEAfL4KcFodLkBqK2LDuFlZnhiGQOjIBeZk
	ui4vc9rMPzfykRTt7mZSGA3pgG0/IuL745Cw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7VIU-0000000FM1R-1jFG;
	Fri, 18 Sep 2026 17:54:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 19:54:22 +1000
Date: Fri, 18 Sep 2026 19:54:22 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Michal Simek <michal.simek@amd.com>, Harsh Jain <h.jain@amd.com>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: xilinx - use kfree_sensitive() in cleanup paths
Message-ID: <aq0KTowSMfT9hUJr@gondor.apana.org.au>
References: <20260908190002.403337-2-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908190002.403337-2-blum@kernel.org>

On Tue, Sep 08, 2026 at 09:00:00PM +0200, Thorsten Blum wrote:
> In zynqmp_aes_aead_cipher() and versal_aes_aead_cipher(), replace
> memzero_explicit() followed by kfree() with kfree_sensitive() to
> simplify the code.
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/crypto/xilinx/zynqmp-aes-gcm.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
