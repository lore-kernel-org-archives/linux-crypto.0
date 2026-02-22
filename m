Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D7AE555
	for <linux-crypto@vger.kernel.org>; Sun, 22 Feb 2026 18:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771785113; cv=none; b=Gp7xA9BRS6y6xv0xRRxU4UdF2HoCntQLLNHVZ7k1db88HriSIc2eqv0OAi2QLQMbNnUdG9iB2LPAWpMtBu65/JIpPbMYcbMcozaRZi18T/rS4UJbQlZnCZu7F2iratf+k1Ah7W+QecbjZsXT40PylVS6MADOO+vZhSJ1laa+oIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771785113; c=relaxed/simple;
	bh=e/CSVdBwzzKkwCtFcbxbYi/B3jHjcunPSplQZJEY+7c=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=oyPwkOofCdhqPaxDCzieZn33RD7frM7OVRh+FX11r4Srkgw20+nmWWJa0aJo2GE2HUgrchqBX1+q6/l7qGD6BVdxUbmM6/4gpJD1imJc7V0Fshk3hWWxWvIrDu5mDbnSSLLr57+CiqK3oen53Xk4ixzEsv8Bd/HGMz/T/zG52IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RuRNP42j; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RuRNP42j"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771785109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e/CSVdBwzzKkwCtFcbxbYi/B3jHjcunPSplQZJEY+7c=;
	b=RuRNP42jd1C0YDEmmq30bCd6GeZXG/FKTRDKC8OohuoG7uROUeE7ScV6/VvKeIqhMsRbeB
	VvpQfG5O4jpCCATD5dUoxRHqT0YA0dBFX3/qi5yi2NANz6ScQAhZMj2QpeIxR4yODSA0RF
	Gt4MUx+AvFZmDWZMyIuCL7s6OIpCyLM=
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.4\))
Subject: Re: [PATCH] crypto: atmel-sha204a - Fix uninitialized data access on
 OTP read error
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <CAFXKEHY40ybHVbWLWPjOR_wuv5sV9YYXyum6nTT7LHG+irBpUw@mail.gmail.com>
Date: Sun, 22 Feb 2026 19:23:02 +0100
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Nicolas Ferre <nicolas.ferre@microchip.com>,
 Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Claudiu Beznea <claudiu.beznea@tuxon.dev>,
 stable@vger.kernel.org,
 linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <FCD7E828-7951-49E0-81B9-523C1A4DC2B6@linux.dev>
References: <20260220133135.1122081-2-thorsten.blum@linux.dev>
 <CAFXKEHY40ybHVbWLWPjOR_wuv5sV9YYXyum6nTT7LHG+irBpUw@mail.gmail.com>
To: Lothar Rubusch <l.rubusch@gmail.com>
X-Migadu-Flow: FLOW_OUT

On 22. Feb 2026, at 18:29, Lothar Rubusch wrote:
> Hi Thorsten! So this one was tested on your hardware?
>=20
> Wouldn't it make more sense to squash this with the patch before: 'Fix
> error codes in OTP reads' (which IMHO actually fixes mainly the bounds
> check)? This on it's own I'd consider rather a refac than "Fixes".

Sorry, I forgot to add that I only compile-tested it (like the others),
as I don't have access to the hardware right now. If you could test it
on your setup, that would be very much appreciated.

And yes, happy to squash them, I just found it after submitting [1].

Thanks,
Thorsten

[1] =
https://lore.kernel.org/lkml/20260215205152.518472-3-thorsten.blum@linux.d=
ev/

