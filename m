Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D2A1DEFE8;
	Thu, 15 Oct 2026 04:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792039677; cv=none; b=E1vksdhM5sDH7pFuCYs7yWUjosffnGjgTo8QrAcZLXA3MHLLGqxptuYaxIZY8GUoShBVDy4l8YVFHKC+ByfOS+Jnmt5TmpOPGDBFq6Dl18TokYJNEj6pHkPQ9cxSORT0zZJ54hdGU6BUlCHZ7WtcBvAhJVl33mUuDG9XFXaQMXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792039677; c=relaxed/simple;
	bh=C45WphjiOFWOK7REO4Jpzo8oL8N6ntkmcBbq5zVWzOw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=XYHgyiCl+byAvBXIyiF2iLblQUizRW9y2obcshQvnS6hwgGQBRrA0Q/PUo5NpGf/KlTI8DmA8S3stvg3QjC2Dr1Ubl5j18qR5EktXDp2OBmQBOKaBEjTNB0v3e61hub8PZKjiKJFEObmuacYnPIXiqAIxfQs+F9CPysVvdMa+II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=dGxeTv7z; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="dGxeTv7z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=EJ4GS294BFMbgOzCdOvoW9Apflv3PDnamA531T32wac=; b=dGxeTv7zY9gBdQ+t9q9tli4/KL
	mGoHjEiz3y+aaf5KP/S22wKMUHBd4IizEcJk8Kdjv51zVd/xJxHe/xuOeEG16AIxzt/ZayHCqYUki
	hK7A42VerfL2cWqywzf9HpMbDmwo6uDJRYRdo3NgFy81Z1y3n09yXRTJ4oSnId6jjmDViXGB/oYMO
	BTQaQG2mLRVfSfn3+2tfrG75RmN7HW8cIBy4ngvLPfWtFMR9lebLuCGJ/+4e4cD5BmTeQN1yKY10M
	6WJAtIguttf52n6Ds91V2IyUhO7ERSIbai5fHSVDGFmoijvatSyE0hs4cRC6jkeQdtFHhK2/CfwZu
	qCoNP3HQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHDNX-000000042jD-2MmV;
	Thu, 15 Oct 2026 12:47:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Oct 2026 15:47:43 +1100
Date: Thu, 15 Oct 2026 15:47:43 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Cc: ebiggers@kernel.org, ardb@kernel.org, Jason@zx2c4.com,
	skhan@linuxfoundation.org, me@brighamcampbell.com,
	jkoolstra@xs4all.nl, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, raizudeen.kerneldev@gmail.com
Subject: Re: [PATCH] lib/crypto: md5: correct header inclusions
Message-ID: <atBa776tU-O1Qg-T@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015033843.6056-1-raizudeen.kerneldev@gmail.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Mohamad Raizudeen <raizudeen.kerneldev@gmail.com> wrote:
> The file uses 'rol32()' inline function (inside the MD5STEP macro) but
> does not explicitly include `<linux/bitops.h>`, currently relying on
> indirect includes.
> 
> Also, `<linux/unaligned.h>` is included but never used, as the code
> relies on direct pointer casts.
> 
> Add the missing `<linux/bitops.h>` and remove the unused
> `<linux/unaligned.h>`.
> 
> Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> ---
> lib/crypto/md5.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/crypto/md5.c b/lib/crypto/md5.c
> index 3d2b017a0525..a838bb90103f 100644
> --- a/lib/crypto/md5.c
> +++ b/lib/crypto/md5.c
> @@ -13,10 +13,10 @@
> #include <crypto/hmac.h>
> #include <crypto/md5.h>
> #include <linux/export.h>
> +#include <linux/bitops.h>
> #include <linux/kernel.h>

bitops.h is redundant because kernel.h already includes it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
