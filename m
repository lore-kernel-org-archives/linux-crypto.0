Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5113939C6;
	Fri,  6 Feb 2026 10:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770375551; cv=none; b=s9DvAStvuCM/UmBV66ZtlfhyDgdX+e20CdRzZn3kD9fFfuvzh854vWPcs44/iKa0dVdMUG/YroTWGdWkyBjTA0h5OFyXeGrc5DwSwrqWevPNcOTmb7hH1yHz3F8VRo8BIOjzP5MhMv/EHeA06o/Toz6+f3JiWrQ0tNsD+pQdDqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770375551; c=relaxed/simple;
	bh=4H3nTF4QBbLa68ngUo4Z9QDiucpatCUi4qQH1hQlwFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=syLbPN5fT4BPsCYv02h3zLw1FzqkxXFXiKz/K372MbCFjO2sKEuTXyO6cKZPUhhLtBfTSw5yvfc/lPwsebcwbYzF78VUAvQ5g6smi373kQpvkcNF03qv+0R2N0XWvjn29BCS5bdDmxv3aiOuIvSkW1pWCmvSvky4RsDlIuWxf5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=LUAk3D4C; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="LUAk3D4C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=4DLjTXJ8stSk+vJPHJeJ0wEhnfBhVsOkH2x6uhGqd+E=; 
	b=LUAk3D4CgDf6EO6m6e0l+nlk1HUCvhkKgnX5wLmBhAGdJuQ29KD0SzxiDwNTU9JkUALPoVidV6F
	PyB6u76ezRlcCqH0yTTLm1oscx4GGWwWSphIMXApTiIeShYkR/eAF5jMjLEMSalyZ/CcAle5ca2Vr
	Qil2jqSqOCUlVWWNtTyMcuwWS9af61SPxJjfkOD6jQCtObwHcVruHugxfHkezDfA7sSYx71rlxPmh
	Fyf0tRArO0UDsRHO9HhVv9H2ihRJgRgyDz3r037Tiam6QYQimD7ZuUcdlxMne37PKHhPv/wLN1qxY
	7BnDUmYobTc+qA1ZldsDlOO+lZSy2akobTWA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1voJXr-004zV8-0g;
	Fri, 06 Feb 2026 18:58:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Feb 2026 18:58:39 +0800
Date: Fri, 6 Feb 2026 18:58:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Neil Horman <nhorman@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: rng - Use unregister_rngs in register_rngs
Message-ID: <aYXJXxI3jlfa4_WG@gondor.apana.org.au>
References: <20260126175018.237812-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126175018.237812-2-thorsten.blum@linux.dev>

On Mon, Jan 26, 2026 at 06:50:18PM +0100, Thorsten Blum wrote:
> Replace the for loop with a call to crypto_unregister_rngs(). Return
> 'ret' immediately and remove the goto statement to simplify the error
> handling code.  No functional changes.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/rng.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
