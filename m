Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D48F14F9D6;
	Mon, 29 Dec 2025 00:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766969419; cv=none; b=YpjFKB6z1JjRZ6bPAk2NZYt36wG0KSZUJQoUeXD0qZPM2trTIeQkp8fYaMieQhUj3EzFGy5NtqwzFhdqOSpYxrc2gWjf4rhmvQHgXF1MJhykq0s+NXEWAg2+5BZRUPr0Z10FJOUkAS8xxwu7ptgbnOqx8AGA8rJv5Lr/XTgMzDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766969419; c=relaxed/simple;
	bh=gmutEJSnEa990Hl1VZnMkJ5fux9r4wqDGs9Wotu+1As=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vi2DhlmToJ7sKMfdsNtL+I6N1pD7kliNfUALJJ8qAFVDRQHmsTl4qEDV4H6nfK7iGiY0vxTnhKWD1oZae8j1Y2B8BBkzlEv2TZKFgyuKBJGxpy3/vzvZxetN7sfOht1ZTK9a4CZUyYkWi5sw0WQ9u+lpodq9DiejOM94W26ghWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=LaV6yhb3; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="LaV6yhb3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=/QsS2ld8+EiMli7ZsPiIu3K9r3S6uF+/qAeDlSzubKQ=; 
	b=LaV6yhb3IRlJXQvzBe8UwAOXCzXQ/Xk/9EQainsSaP/pu4vYnXyo7yLr3sarffdN+cC59brJzYw
	V8Tf8r53GZSBwLW5xkww6ypWdblQyKM21elVydDe9m/VfgEv/uWPG+55XxCtF/iyiHDrUs+V/THIS
	x+Bg9EPZoaKGundVulcqBdpsGNE8LxP6qQa25wdE4k3tcI/OCCxbsmpNd2OmNFRzRuf79xQjP5ueG
	QossXK/D7qgAW72MD2IIvGOGliuysAOFltVcSHySaiOoE/aUsGzkuxOeajRgzgdvT5ggTRCJ39ENs
	ni7b7TaxoEuYY39mmChsVJd0gcWYMpWh8Pow==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1va1SV-00D0EF-1L;
	Mon, 29 Dec 2025 08:50:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 29 Dec 2025 08:50:03 +0800
Date: Mon, 29 Dec 2025 08:50:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: octeontx2 - Use sysfs_emit in sysfs show
 functions
Message-ID: <aVHQOwVSP-RzmMrd@gondor.apana.org.au>
References: <20251215122608.385276-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215122608.385276-3-thorsten.blum@linux.dev>

On Mon, Dec 15, 2025 at 01:26:05PM +0100, Thorsten Blum wrote:
> Replace sprintf() with sysfs_emit() in sso_pf_func_ovrd_show() and
> kvf_limits_show(). sysfs_emit() is preferred for formatting sysfs output
> as it performs proper bounds checking.  No functional changes.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
