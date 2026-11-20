Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168187;
	b=KUdQ5W/nHyHVrl95CaQr5aSlM2JbumBmUxBmZLwuw2WT9nb1YxGEamBsPcLpFlBvMEPn
	 kr37CnVQ6XQQc1vzmqnyyUiwDQHQTe+LENOd/vXA28dsPRJqZSE/YRUbfAFg40CHN1QRn
	 QkTe1kFFabvN9PhkWm4ipiaIhFqt0Ad+P6Vm9KupjMQ2Wk7QeB70XNyC5j0hy1xHMTNY3
	 yHJ5b2986ooMyaV9KWUDk4ALXgoqiPjHeOz2evp4uU2AukIAqwiFbE7RxZxayqfEzPEyi
	 mGSRvwEIFRCreejMblweuDPjVsq+WnugYYq9xF3HHteWGJw8QjA+E/5XpluoWnPlc/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168187;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=Dw4p4I5iIgHPR6iLHR0gyKsTPKAy203NjBPDL1ureKM=;
	b=wVEiZnNLe6q6Sk5khkB9bbuSA8F1UUZEgV6FBARC8o1Ai/kFxYZesGAC23bphjop2yHN
	 bqq7DibwiaQhVP2vTDqRTshsflvYSpoWyhntxzJo+gMlxTc1c+7Gcf40xAGJDeAF687MV
	 aplrqFD7H+7l9DDBUr2fJA1xP7fbN3926nRonIbM4YDsKF0iA4ST2RfRGdsdQAR0sNIDO
	 202ziqAUlfhiEhQ2jEhbAvdOWv6HDzwIpMX1bb2NB8i8S14W3j3H+ZkH5HL5iyKnQzsAW
	 RjJb3un0cTI17AHSHNC75ORPiSUqB0TJVEMGrQxeS+fgJPsAf10n+UEGidMRgfO70xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=RlrYyot6;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14B2606A33F
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 09:49:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D14B2606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=RlrYyot6
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Dw4p4I5iIgHPR6iLHR0gyKsTPKAy203NjBPDL1ureKM=; 
	b=RlrYyot6SP9+fd9yVKAEsHSqRmdn9Tf8bn85zIAV874lHSIWQYq5QKNfz/FAsomtZFLGyUYaCXp
	KxsfKbIXCW5JVqgvrXE3ZwhS4W2byiVzq2Zv16dtCRL3L3hQUXBiCYxLPc38NBlUwj+sqp2H7IeS9
	p3pXiELF73J3rBREKSJiQptATX2xzTs36E6AtrilkpcZO4SnUW3pC4IGSmJFxNEIu5B3rDSU1vflc
	hSyeeP3OI2xIcp0m63WzuauKwbwMjrkVsUpPdmGm1DMh/yUbsACnfa00PRcWKoaO3vQyWlTw2TbLx
	uEEAgFHJxeFx5fhGi9Bny2g+8MaspZN22/fg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xULFU-0000000HYXb-3w4g;
	Fri, 20 Nov 2026 17:49:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2026 17:49:40 +0800
Date: Fri, 20 Nov 2026 17:49:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] crypto: arm64/ghash - Reduce boilerplate
Message-ID: <awAXtOjMOVqZn6dn@gondor.apana.org.au>
References: <20261109164502.905237-2-u.kleine-koenig@baylibre.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261109164502.905237-2-u.kleine-koenig@baylibre.com>

On Mon, Nov 09, 2026 at 05:45:02PM +0100, Uwe Kleine-König wrote:
> Make use of module_cpu_feature_match() which expands to nearly the code
> that is typed out.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
> ---
>  arch/arm64/crypto/ghash-ce-glue.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
