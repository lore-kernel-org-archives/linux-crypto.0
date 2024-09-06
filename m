Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B88014A4F3
	for <linux-crypto@vger.kernel.org>; Fri,  6 Sep 2024 06:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725605993; cv=none; b=TjJ9B9Vp+enD+/NDaW3qlySVUFP7+mZ0l9pmwiJog+Jefubh7Yflx3QKI0LR8bBBJIPadyAxmH6Yqeqw6XYHeHrj7neo0Z4CYpGz5p5d1R2pgWlES40xr5cu9faSt6XVMz422W1gqLgB4QbC3LYYLAxlzUaIcOHrrepCwcpZVNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725605993; c=relaxed/simple;
	bh=8qOQm0kDwoZX3a0Q6qDWXPKFd9/Awi56nz0HebjogZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AMdeU0XqJl31rX/QwR19BNwFOXZsbfWyjVlDXNpfhidjroX87oW3JFniakz4/NkEn2T8nmbNKZOdtvrgOVTv7/tRUuY8prZ+LyjPG4D/YJKuFfhzK5DS5l1BIv+h6mugRgtzSFXmoUBci+w6PlxYQsC0dgQ2IxxTSRbUsYVLy7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=b/5GkZQV; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="b/5GkZQV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ud0cEW8M6x9iqd7bf2yGPbn3LbhTUr/1zKjDhyuq+jA=; b=b/5GkZQVZ7JtLZDFGl8kPQI+cx
	P1pcUtKamiDzaPIXt4SHohWVNpdjIJLKxLwhwLGqOyxIrFRlX18tD8RyA0tLkkksobuA4rgvoyWx3
	jd6I4COwbCGnmQ/2EgkwdH2H40uVrjNVVU80EF93kxwTIBmUEdDa5Et7DNY41aE0LO5CDeBycEeIX
	cR2APfX4bFROw37LbWvr5oyf5UqbQwpb1q41zrPGfG3Y3LiVBDrMnwfdWF+6PAVRaJBt4OumfK+K+
	mav8xooEfQ+lzWEsqlbxm9H6I5z5MJg5amBZ14lrPX8cNWY0SX7cYbllQ/7HdA6LjAfrqNQx/46vf
	hNnhmtpA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1smSmW-000WNq-0I;
	Fri, 06 Sep 2024 14:59:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Sep 2024 14:59:33 +0800
Date: Fri, 6 Sep 2024 14:59:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Guoqing Jiang <guoqing.jiang@canonical.com>
Cc: sean.wang@mediatek.com, olivia@selenic.com, matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] hwrng: mtk - Use devm_pm_runtime_enable
Message-ID: <ZtqoVVpgqmVgCcc-@gondor.apana.org.au>
References: <20240826070415.12425-1-guoqing.jiang@canonical.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826070415.12425-1-guoqing.jiang@canonical.com>

On Mon, Aug 26, 2024 at 03:04:15PM +0800, Guoqing Jiang wrote:
> Replace pm_runtime_enable with the devres-enabled version which
> can trigger pm_runtime_disable.
> 
> Otherwise, the below appears during reload driver.
> 
> mtk_rng 1020f000.rng: Unbalanced pm_runtime_enable!
> 
> Suggested-by: Chen-Yu Tsai <wenst@chromium.org>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@canonical.com>
> ---
>  drivers/char/hw_random/mtk-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
