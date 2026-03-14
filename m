Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E02230270;
	Sat, 14 Mar 2026 05:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773465159; cv=none; b=rmgaYff04yU+AssK+280K1Sb2stGaM/JzgLnqF41ogWI6OxXWbP4rzcHIuLunltkIvmWOAbNLn7DvnvTJdTbJaOSTc0+HEVIv3gkOKf3G5+ksTzh8c5Qef4S9fiTF3nBZ/rcCxoUFSsrGgWX7wYPNPm3BZNit1TIAcdoTUB55sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773465159; c=relaxed/simple;
	bh=JLqacoEXAMnbLwhIRWJWcC7ay4epBLiUxyBReIZ6U+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rYeemWZotrabdabt5jWCZlr3r2tdQTT9Z44goO853lUM4ZSycYXVnG8u65B+wLs5A3+4/OMcYyePhb+/WwXsXwkM9BpJCwzgGhesSH7aH3MOBT/9akl/4GD91Jp/b6cr4rV/hPKPcV6d+h+dkKHmJj+VBE3dvlW2ArUdsQNOeUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=MeQ95VN4; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="MeQ95VN4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=SWX8mp/QqIVkCzDjkHiTCaW5kLocZdjN2u/rdkiH+HM=; 
	b=MeQ95VN4n3ha+2BwoFwvHpHFv7MI+O9MLJjW/VzZXhLMKOs2r4JUFzB2s4dBHs5Be66yuodVSQ3
	LUM980kIpB3EQpQDGrV45J8O7hKoOgXXVsmBJP++aryZ4A5xrd56LjDL7LRdzQ0r1nVEQb14L6iC1
	5ChMbuL/fB95xetB8Ujw6cFFuDAbk6QsDE+mMCRTyY/gfLZVpQmruqWBzEkCG2fXL7KG8j7bNkT0Y
	cqCrOprtC6Y3CbQ0aBBUuRcSQxpHoLZBvARc4HYpGv3LXrxMuguAKNoCx1++K5P3vwPamz1UWbzKs
	EUCAB+xyotFoEP//+1aZ3pMoMqOzWoSnOY6w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w1HIV-00EL8L-2v;
	Sat, 14 Mar 2026 13:12:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Mar 2026 14:12:23 +0900
Date: Sat, 14 Mar 2026 14:12:23 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: davem@davemloft.net, robh@kernel.org, krzk+dt@kernel.org,
	conor+dt@kernel.org, matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com, atenart@kernel.org,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v3 1/2] dt-bindings: crypto: inside-secure,safexcel: add
 compatible for MT7981
Message-ID: <abTuNxU_qoQO2nUI@gondor.apana.org.au>
References: <20260303185451.70794-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303185451.70794-1-olek2@wp.pl>

On Tue, Mar 03, 2026 at 07:53:49PM +0100, Aleksander Jan Bajkowski wrote:
> The MT7981 as well as the MT7986 have a built-in EIP-97 crypto accelerator.
> This commit adds a compatible string for MT7981.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
> ---
> v3:
> - drop oneOf
> v2:
> - just add compatible strings
> ---
>  .../devicetree/bindings/crypto/inside-secure,safexcel.yaml   | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
