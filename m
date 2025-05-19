Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611191E8322;
	Mon, 19 May 2025 05:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747634386; cv=none; b=N17VsG0SRHdsk9i5QXqAabnkooDyq3aaFcz2GCWMDl4aGMONRG/KvHOuRPA8LcHhCArLMTKSTo00N29XjMHzh1wB/NZ4mD+817M8NY2DABnOU5OBttQOPlufP23Xj9WM935hazuYZHe2Pp7VG3XOjFq4mLbp8KyUolNqhnocXL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747634386; c=relaxed/simple;
	bh=zBPG+1Zk6RvZVrAKXCvxbQRgmi8sFzDsDkEOg9tIjxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H72wW1CpUkxG23li9Zl9EBnmV96PSZfI65QPdKhOWVtP4xPbSKcvaVRI2LW0jiUmV8/0RccZEhERQiReZLvJComKgSYgc3RerYREeaT9Ks1vaFNssvr2FuD0KSlDsZLp7w4n98cT9Ak/UdePxIqRRWXUlGAKEPrd0S7sXGt6sxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=A2pLHEp5; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="A2pLHEp5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rsg46bluH4QDcw33HuNClbrQzsMqLKbe9LV+4+RubOU=; b=A2pLHEp51/2cUbDYgAiVhZh8se
	pQZsy6oifO4wzubkwgWDJVWTmDXVAGmhOO8bxN62ORCHan/YuY3XJ2BTibimKZbEvtTeJtSVIJh2v
	FjQsvSsdipkS18ZLdiPVU6DcFdh2d+oElvrF02XrnQmo8bPVpGT7EDQ7r/lvMmx0fDnVAph2cxJKv
	SaciN9PKcZyX62kJDF0wW980pZtB+qI0+w4F9NrgNXT6mjkZ6H0PVRO+Uf/vBamPV01Tg9VYjLMJ2
	Eokn4xvRE4Iix9Fi1JQX6sZKLsw5W/w/P3322qr5UqT8m5/UUxjfB4zfGo9gmPAmRQxlJXBx6cEFS
	Ma1PkSrA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGtXD-00783F-1N;
	Mon, 19 May 2025 13:59:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 13:59:35 +0800
Date: Mon, 19 May 2025 13:59:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] dt-bindings: crypto: Drop obsolete mediatek,eip97-crypto
Message-ID: <aCrIx0LSKFpG-kQj@gondor.apana.org.au>
References: <20250513184042.3051424-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250513184042.3051424-1-robh@kernel.org>

On Tue, May 13, 2025 at 01:40:41PM -0500, Rob Herring (Arm) wrote:
> The mediatek,eip97-crypto binding is half abandoned. The driver was
> dropped in 2020 as the Mediatek platforms use InsideSecure block and
> the driver for it. All the platforms except MT7623 were updated. A
> patch to update it was submitted, but never addressed the review
> comments.
> 
> Link: https://lore.kernel.org/all/20210303080923.16761-1-vic.wu@mediatek.com/
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  .../bindings/crypto/mediatek-crypto.txt       | 25 -------------------
>  1 file changed, 25 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/crypto/mediatek-crypto.txt

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
