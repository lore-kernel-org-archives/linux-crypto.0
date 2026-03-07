Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A5E276049;
	Sat,  7 Mar 2026 01:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772845795; cv=none; b=nCZ9Mq6NEC7tIptibtj48OTHU8YXpZudn2nPZomXrUCwE38oP02YPCSlUguQsM4qyoyl/RFTuxXU57PKV3KKdr/i+TVgW1SnuQIpM3+bsw9tj23wncRREcb+WTixZej2Fs2TOAp0AjScpHyYA8najlntLjzJZV4Ntq1Zu7Qacw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772845795; c=relaxed/simple;
	bh=Y0Z3SUitQqa68r9jboXntcNVNtUh3qz9/oaKNZPf7+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CuKPeaqI80mJmFU1aAE67LIDIySLacj0VuoxEBSb46CboCjBANBeQ70XDHbIriDmEcFjdLTlyJFnTrmbfkVycVTnhhCYJw8n+tm3UdOqktMmAUuNNZazz427ZGDlBgNJJjI0tmIk/edM9JTG9oojkKw3bFdKtFNlotxMl7Z6mq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=gSrRye6j; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="gSrRye6j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Te6CQxafowcylD09FG2huxeGmtjrSZipVYPGxN3FkIo=; 
	b=gSrRye6jMhDmrBiy4sl6ikG3D+zST7Vhs9mwH6fGMa8cgZNvbAvLurOgw1Tyt7kBJ5kyFXgZA+H
	HH4eJu8zEEIdO9DQX5bl4Nu+SKvfushwEwjVDq9XQYzmVSj9vuVQsZ0kmFjDW8obWSvAsq9wmlOeC
	bfcbQ9Wl20gWRbZSsw3ZWvttumLNgcaUMocDKf8n1s3a67jLOIQ1BTozfdRsICtj714h8Hn9ScwF9
	urfUJgzUD8jEDRUpDkKMvxTqL1lxlxmeKIutTbIpRwrCVoQaN/LDxevEBlEtCarxv4Ihxv6ducvkJ
	q+Fsszc0zo+cvTRBCTcVCUYaKzjXwEp6pHmQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vygAd-00CHOd-2J;
	Sat, 07 Mar 2026 09:09:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 07 Mar 2026 10:09:31 +0900
Date: Sat, 7 Mar 2026 10:09:31 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Cheng-Yang Chou <yphbchou0911@gmail.com>, davem@davemloft.net,
	catalin.marinas@arm.com, will@kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, jserv@ccns.ncku.edu.tw
Subject: Re: [PATCH v2] crypto: arm64/aes-neonbs - Move key expansion off the
 stack
Message-ID: <aat6y_ppHGNlUWFH@gondor.apana.org.au>
References: <20260306064254.2079274-1-yphbchou0911@gmail.com>
 <20260306213502.GB9593@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306213502.GB9593@quark>

On Fri, Mar 06, 2026 at 01:35:02PM -0800, Eric Biggers wrote:
>
> I'll plan to take this through the libcrypto-fixes tree.  Herbert, let
> me know if you prefer to take it instead.

No objections from my end.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
