Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438F518E25;
	Mon, 22 Jul 2024 06:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721631355; cv=none; b=QSJEOBTGNne7h3HEFPPqTgiuN2KQRTyov+GTiaRbzMKyRFlyNRQevfKDxsPsQ7/yFjyYTr5TGm5uaEt6oTukmfZsIzerocqxmfiy7kjTlOwIvSjVBraGARV/HEEgPtDdEuz5TMuKV/hUuW8kOnFKASbKlsxdoia2G0z5mUVB+Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721631355; c=relaxed/simple;
	bh=Ko8xyGgocBN/wPPtGRaAEQedMQwY6e02BMceNIGgjf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nRsx4BIIwgXyhHCJ3RzO6j7D62ovbt3/OvyLlmdRbwyYtoIKpbH0RNyOOwU5Iz+P5IIW7v5qs1lE731/2xGk4CO+VmVh67nPhFb0B1rS82CBbYflsOrun5BUW2ZeEAvmk1/bw6HaUwJS2HqOkmeSxRxhgsh70D/gHfH1pO64GWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=HQVrW/zI; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="HQVrW/zI"
Received: from gaggiata.pivistrello.it (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 323981FA1F;
	Mon, 22 Jul 2024 08:55:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1721631341;
	bh=2Bg6YEuqceLZiz3jS9dKfEdns79OObSYHCiVyb4lmlM=;
	h=Received:From:To:Subject;
	b=HQVrW/zIPfHw2oIHXuzjUI8FUQ9qJmqswkDxj7WmvpghHTkkFkgWfZuT5yeam42fU
	 gWc59stqkDe3MJXDHc2+BM2r3YP+dHGthjybxX58wYhTIjjRS9ByFyAoGaPOnTApbS
	 9WeBPsyI27FXTPi0raAm8ubhlxNbkcH8MSK7J5FOBHETiUP8JI7kA/gH0+ftnGkowx
	 WS+/JSnyfMy/3shrerkfRmQWijZmYyQIs8FI1MJvV5BON0TqxgXu0v5WKt1CNYoY+v
	 7prstYowUuHEJlHyvi7xthNFMc+t9IQck6jbqeMHnn0cPJedx4fqsfYwAZDHNYMG8F
	 Sd5x1yXz1mmtA==
Received: by gaggiata.pivistrello.it (Postfix, from userid 1000)
	id DBDF77F9C5; Mon, 22 Jul 2024 08:55:40 +0200 (CEST)
Date: Mon, 22 Jul 2024 08:55:40 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Bharat Bhushan <bbhushan2@marvell.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Olivia Mackall <olivia@selenic.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH v1] hwrng: Kconfig - Do not enable by
 default CN10K driver
Message-ID: <Zp4CbFEIvgVjgIug@gaggiata.pivistrello.it>
References: <20240625195746.48905-1-francesco@dolcini.it>
 <ZoiLd/Cezq2CS4Zp@gondor.apana.org.au>
 <SN7PR18MB53144B37B82ADEEC5D35AE0CE3AC2@SN7PR18MB5314.namprd18.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN7PR18MB53144B37B82ADEEC5D35AE0CE3AC2@SN7PR18MB5314.namprd18.prod.outlook.com>

Hello Herbert, Bharat

On Thu, Jul 18, 2024 at 10:10:31AM +0000, Bharat Bhushan wrote:
> > On Tue, Jun 25, 2024 at 09:57:46PM +0200, Francesco Dolcini wrote:
> >> From: Francesco Dolcini <mailto:francesco.dolcini@toradex.com>
> >> 
> >> Do not enable by default the CN10K HW random generator driver.
> >> 
> >> CN10K Random Number Generator is available only on some specific
> >> Marvell SoCs, however the driver is in practice enabled by default on
> >> all arm64 configs.
> >> 
> >> Signed-off-by: Francesco Dolcini <mailto:francesco.dolcini@toradex.com>
> >> ---
> >> as an alternative I could propose
> >> 
> >> default HW_RANDOM if ARCH_THUNDER=y
> 
> Yes, make default if ARCH_THUNDER is true

Herbert, this patch was merged, do you want a follow-up patch as Bharat wrote
or you are good with the current status?

Francesco

