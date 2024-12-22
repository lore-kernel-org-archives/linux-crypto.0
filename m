Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF36E74BE1
	for <linux-crypto@vger.kernel.org>; Sun, 22 Dec 2024 04:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734841209; cv=none; b=cAkczDWCCDmCNo+KzgFs09TUE1YB0/O6Jp5FkM2+SptRT72lgRPkwyhmql+5cvGwIkB1qMhNecPgGSWE4WJxNBoXmZbm/QkkkLWDdJvjNeR8az3EN7S4gd0cwr5jkzKthF7W66pvwA44VFo0sceupqYlhUpBhAsKGz/CyaB0iB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734841209; c=relaxed/simple;
	bh=yInzIf61X3KgrL5g9BeEhHlB6BXcLvT2ZZL6wokqBh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fVOM4Vd7gzLmRYBl/Z6CsYrIx+pBaVKcjM98zUMPq6h9ahbvhVEsqwZyPzcghfMEKavvXGgwy0VPU1lptbjIayN37lQ+WJp6iXTECh814HtdWNGRBWVxY8fWtnJ59U+pXq6w85JGSMxYKERGj3FI+KyTW5DRolbQoXxVkAWYlTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=XL323oCF; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="XL323oCF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SYgCubW0nWk+fAutDOrPFXWKDA82LQgvfiyMVhgZ5oI=; b=XL323oCFBkyawfmzUjO9DFJsYG
	nR4uGjc81QQ+3dfkiUOKea5t9h7cU2uQfaph1Ggvf29CaCdHfYbxCbYtWxNscuJb7+Kppgy0heVd5
	5SiRCqoZ8Wk8Ide1VXwa940WTQoTDRs2CIlZR9Y1E0BDwodGRKPS/91FvdIPoj5SKZRFcSVK5btem
	2msOlY7vs/cVQCtfbp+o0bXn7XwvPApVV+6Y7fVn1xtbq5CjpHudzDJJHkNnBnPI8Hya6BSNZOHnK
	YuTj1hcMmrFb6uSI8gdBhuAICcmumH5hhNur2YrVJ9CCq6PPmpdW940/0PzNqdCmgZmUg6F/ywX1k
	kWqJhCtw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tPDEh-002Uej-0h;
	Sun, 22 Dec 2024 12:19:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 22 Dec 2024 12:19:55 +0800
Date: Sun, 22 Dec 2024 12:19:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Cc: clabbe@baylibre.com, linusw@kernel.org, kaloz@openwrt.org,
	davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: ixp4xx: fix OF node reference leaks in
 init_ixp_crypto()
Message-ID: <Z2eTa6Agqf_2IOCI@gondor.apana.org.au>
References: <20241215072720.932915-1-joe@pf.is.s.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241215072720.932915-1-joe@pf.is.s.u-tokyo.ac.jp>

On Sun, Dec 15, 2024 at 04:27:20PM +0900, Joe Hattori wrote:
> init_ixp_crypto() calls of_parse_phandle_with_fixed_args() multiple
> times, but does not release all the obtained refcounts. Fix it by adding
> of_node_put() calls.
> 
> This bug was found by an experimental static analysis tool that I am
> developing.
> 
> Fixes: 76f24b4f46b8 ("crypto: ixp4xx - Add device tree support")
> Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
> ---
>  drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c | 3 +++
>  1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
