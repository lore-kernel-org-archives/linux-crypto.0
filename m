Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC462634;
	Sat, 16 Aug 2025 09:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755336649; cv=none; b=jSPfCnckmsucKRdrJUvIlRfLFaqpvvHsBlH8oV/D7PyyWUA3C2t6DmdE43H8bZrZvnsvX8qlDiOk0zcwYx/Nf9DMdSBTAE1Qq4X8KsBLVzYMnnq8Q4WHFnPi6rEHaHH5/Onc1EKiEWjAE8NgATy+6mwVo/fGmrHHAb5nYoV6lXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755336649; c=relaxed/simple;
	bh=RnJPDQnRh52tMyoGfMVpXs355DI+8TqFwZY3Nsyg/hQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fFBoxlrBkIKsx1kQcWSipfEji7plt/5auTJhE4qe0PEau79iIAR1iFR4AeP/i788kGgldtXaJigRAmtmhSWmBDjhjVn4j8GjYIDMzBulmWOvWWgZ0yszmCDV+D51Jd6YKI4mMv1iZUVNs80mIfYNqIyKXg0C76N1aI4E0CMG5lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Yvy91sGj; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Yvy91sGj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4WiZ9ddpNrGSgA17pjQ7Do4+YzZaiUY0Hg+kDmv11gc=; b=Yvy91sGjFKWDa4QDCuhWNnVenx
	rtefdrPoiAQWGr9MeAIc7RK82rncwbCMaZ9LzIPmlJbq0H0Jv6sGSoa2PCNlAYwvUMQX3Mrxj50Of
	PSrKQn8GzeSayzurAzGZDOCITckNcrDPTkyAK2q3E81XLOs1G3Oq0O+Zh9AoSE1Nf27060FF1Yt0u
	pzAGcFMJv7aS+01yltWJrJa08mkLyTKdUw6JZdeZSu5i4X8s+qAeD3SEVQe3EpBuLGHCowc1AoBvq
	QgGn0AKP5mnr+zP08R+EtL8ctwoOiaEMaaheo2xpLeNv1mY/J7ux6RIEtVXq65vVTRnH72REkGMJy
	0avR0ryQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1unCzl-00EmJl-2C;
	Sat, 16 Aug 2025 17:30:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 16 Aug 2025 17:30:34 +0800
Date: Sat, 16 Aug 2025 17:30:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Colin Ian King <colin.i.king@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] crypto: stm32: Fix spelling mistake
 "STMicrolectronics" -> "STMicroelectronics"
Message-ID: <aKBPutUbmQCp28YX@gondor.apana.org.au>
References: <20250724105754.140400-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724105754.140400-1-colin.i.king@gmail.com>

On Thu, Jul 24, 2025 at 11:57:54AM +0100, Colin Ian King wrote:
> There is a spelling mistake in the module description text. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/crypto/stm32/stm32-cryp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
