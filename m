Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59F1288B1;
	Mon, 16 Sep 2024 08:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726475966; cv=none; b=sYQlxX5lDZfK1rvcX2+JtQboyZnO1j07I1aNSIaCwYtJIZuCTvdSOdcrjs8/b47GRryTuzKsh+eUXsdj0QF/XeWx+0UcCekMWKSKB3QNM7cy2igPAkVolH9syieeuS0Az+N4hHQr02Oi3GHKh1WTk1ZanoTpoqQhbfxIQ10rSCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726475966; c=relaxed/simple;
	bh=5wmU3wNRqWeGfeTeUjpRCeyNNDPEYvCrVrqChh9r4h4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wadh3f0fD0eRpz01qS8ZzNS9ERH1tUMoI9/nxw66HOQZ9KM+cnd+/zjmTvbj/0Arm0OeeBd1KFk/LMfNLoUrdcCk2iQOfyldeZy8gziz6O0UIGKddb/zXPa5KYdENyRbzF6JNbnq45pn4eCl6AVsitGF+BZB8QxCmW7jtdVILeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=SdpkkFBO; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="SdpkkFBO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5ztQ5UCZw4pxwgb8jxltM7S+mP447O5EdUv1R07M1qg=; b=SdpkkFBOfaxKt34uNB/s3napvE
	jTCIBwYpX7mhVmuwA4XBbKgdAj3aWFFd0bx6hhUoKM6TnKZvVBBZu8jSNPvg578hb0HydNz49SQHI
	qTvhJQHl/emwGpUKmI5VUkEyKkKue0GX87xmLxpFHGLlS8Ps/WxypVhHofK2ApgPWnSSGtX4qLZNH
	x/8dlgcVx2hMJQhiJ6Jj7hBTBUXm0xPVchxo7GCW/Ttmx1K8CPibn0xunnGA4tFQqGKx5B+ffRlB8
	/MUicarGEMszgAtlw9nTNIzGjLVMyTjOhpUaWdFS4+bY20OFiQulahPCMdg4Tqnhwr0VOqo0sjKVl
	VlSsBhOQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sq76A-002lbE-2a;
	Mon, 16 Sep 2024 16:38:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 16 Sep 2024 16:38:56 +0800
Date: Mon, 16 Sep 2024 16:38:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: George Rurikov <g.ryurikov@securitycode.ru>,
	Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc: MrRurikov <grurikovsherbakov@yandex.ru>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: Fix logical operator in _aead_recvmsg()
Message-ID: <ZufuoJC8sFi9ETqZ@gondor.apana.org.au>
References: <20240916074422.503645-1-g.ryurikov@securitycode.ru>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240916074422.503645-1-g.ryurikov@securitycode.ru>

On Mon, Sep 16, 2024 at 10:44:22AM +0300, George Rurikov wrote:
> From: MrRurikov <grurikovsherbakov@yandex.ru>
> 
> After having been compared to a NULL value at algif_aead.c:191, pointer
> 'tsgl_src' is passed as 2nd parameter in call to function
> 'crypto_aead_copy_sgl' at algif_aead.c:244, where it is dereferenced at
> algif_aead.c:85.
> 
> Change logical operator from && to || because pointer 'tsgl_src' is NULL,
> then 'proccessed' will still be non-null
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Cc: stable@vger.kernel.org
> Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of duplicate code")
> Signed-off-by: MrRurikov <grurikovsherbakov@yandex.ru>
> ---
>  crypto/algif_aead.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Cc Stephan.

> 
> diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> index 7d58cbbce4af..135f09a4b3f8 100644
> --- a/crypto/algif_aead.c
> +++ b/crypto/algif_aead.c
> @@ -191,7 +191,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>                 if (tsgl_src)
>                         break;
>         }
> -       if (processed && !tsgl_src) {
> +       if (processed || !tsgl_src) {
>                 err = -EFAULT;
>                 goto free;
>         }
> --
> 2.34.1
> 
> Заявление о конфиденциальности
> 
> Данное электронное письмо и любые приложения к нему являются конфиденциальными и предназначены исключительно для адресата. Если Вы не являетесь адресатом данного письма, пожалуйста, уведомите немедленно отправителя, не раскрывайте содержание другим лицам, не используйте его в каких-либо целях, не храните и не копируйте информацию любым способом.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
