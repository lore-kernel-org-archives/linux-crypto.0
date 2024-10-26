Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EE2178CEC;
	Sat, 26 Oct 2024 06:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729925693; cv=none; b=JueJ78h3fZQyWOVD0xaHDQZU1qAz2trLWYDUkwUtvbQ7Wql6Kxj09E+2vZmPJIql7tL+NZ9vGDGgYcDbV7LFTQJrNB5u1zpZ7XfUhEdWbYKweFk+PhzgEDta2dmqyx1uZqvs/Py11L+suoz9i654OIKPvQSnmdznenIS+mKN7b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729925693; c=relaxed/simple;
	bh=pwHxqe9BI47VI7n+MeAs0fGEU8gMaU3kHuPLx67nE/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O8DyYAs9e/WKWB5VSg1ECtQ0LQ9N3tjrBkpJ41FRJy+rJnyGwli43ykB1PDncSzXU049nend9kWqYYb4MoznRotXljyaS1WVotv0W7QYl5sFRMGj3YFU2bY8/h0VgV1zgPPKCzwYo4IA9rVa4gRM9oAdKflRIZDiPCYGdIsaJUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=NG0qWazs; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="NG0qWazs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3ShUIroqGhEwp/grFXsq8H8tMHIY40CTyY5MT0udxOI=; b=NG0qWazs2WYAatr3H/hVEGdiLn
	v0ITcO6NggKSY9YMbyg12p5Qul68s/MrxMtL4kTVDsJRjw3c+xf3VsmHMNEp/MSWd5S2Zi/i/mHlW
	nklgbn46RbCOKVC/xNVS5lPxvgBOiFRtLm/vg8DfZ5SeWvZ/zhuk9GM+88Lg7yGjmBdME7+Rvc0hF
	9kUumlqVh0Iyn2sSKa/5gJzXepyI5WZ1xu6t53lxX2Uv/jlNb8dEB4YIbi+RbgU9V61Val6iBybBK
	6SeMqehc+mvxKx8Cq3OtNBpXWtYQjvqL2XeiX8L+xpIW8wguHC91OVKKrqu1AsWaM6Dwxnc5PQPjL
	1c9pJJKQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t4ah2-00CFt7-1U;
	Sat, 26 Oct 2024 14:54:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 26 Oct 2024 14:54:36 +0800
Date: Sat, 26 Oct 2024 14:54:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jayesh Choudhary <j-choudhary@ti.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: rng: Add Marvell Armada RNG support
Message-ID: <ZxySLAcz2lmjG763@gondor.apana.org.au>
References: <20241014185457.1827734-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014185457.1827734-1-robh@kernel.org>

On Mon, Oct 14, 2024 at 01:54:57PM -0500, Rob Herring (Arm) wrote:
> The Marvell Armada RNG uses the same IP as TI from Inside Secure and is
> already using the binding. The only missing part is the
> "marvell,armada-8k-rng" compatible string.
> 
> Rename the binding to inside-secure,safexcel-eip76.yaml to better
> reflect it is multi-vendor, licensed IP and to follow the naming
> convention using compatible string.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  ...g.yaml => inside-secure,safexcel-eip76.yaml} | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>  rename Documentation/devicetree/bindings/rng/{omap_rng.yaml => inside-secure,safexcel-eip76.yaml} (79%)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
