Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A40C125A0;
	Mon, 11 May 2026 05:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778477558; cv=none; b=YFU5gvRrdp2Wo1gRglnFdtY8TTCv9lPPG5Pv3YkApbWik3JZIqxWspjHERXTX/AbpJ3rMn4+KITVqFo1NlEpoAzwOWOhparTXeB/6HeK2fYj/EFJ66MM0vkMmBRA1OPzsXWCu1rRY2B9GdlPO62ichuwrZ9XlYR8iRu/NJ6biQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778477558; c=relaxed/simple;
	bh=whJ0tzdATyn6xQuQyHvlEb9y9KQ1uSP2Oz8XEIvlZGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VIfqEeOXPUTeDvnSgsmTfKWR0oxJCbM9BmJbaJw1Z5BWW0t5xIWUTt74W2RIBK/iD2F9ocKntRcWNIB4RKsROiVi2BaJbZj3v/xzIwXYYeJtiozFEC/t205JReY2D2PGGas75zmL1FBwpkIyu1WiSFH/lUV567xS1JT+SPe4zVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=FR10EpZA; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="FR10EpZA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=nW6FlOEz1fqqM4k+MzHjMp0VrqCe99NnSBZ4ciCEffo=; 
	b=FR10EpZAJvY/ftuo1JWnHtzeh5k3liBWyjUdMybPYwqXxzplyBwTh2sDbtxGJv5cBzs4c/uAatK
	/0dRMFY4j/bjnAQcOKD0wMH0YpZ5LQ4mRsVSrpTf1qfpQThfBJt+UTWEnh3d3jm6qCMgGnhinKLEP
	W5J1lxaNGEg/hWweE++Zt+cLryUavTKgnfvP8hvt6SlB3lJsaRJKE/fblPD3jHqOYYGSs3Jel/ZwL
	PL4vL2VoSLXe++7bH5uEnE9FrD9FI+QTvPoHJwqknBC2nRDKhntY2fboluPfgTojy55h38g3KvF4C
	rSZGBCpZ2wMlgk6vl7YKHfFZSE4z6YiRlg4A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wMJFg-00CzqX-1K;
	Mon, 11 May 2026 13:32:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 11 May 2026 13:32:24 +0800
Date: Mon, 11 May 2026 13:32:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: yuri08 <nvt031@gmail.com>
Cc: davem@davemloft.net, w@1wt.eu, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: algif_aead - Prevent async UAF on early socket
 close
Message-ID: <agFp6PwyWsnvr5Gk@gondor.apana.org.au>
References: <CAFpG_BHU49CKUpak795wkiczROiKUX8CsN2dp_94s4P5M9rr4Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFpG_BHU49CKUpak795wkiczROiKUX8CsN2dp_94s4P5M9rr4Q@mail.gmail.com>

On Sun, May 10, 2026 at 09:05:57PM +0700, yuri08 wrote:
> When an AEAD request falls back to the asynchronous software path (e.g.,
> cryptd), the Crypto API returns -EINPROGRESS and control returns to
> user-space. If user-space immediately closes the socket fd, the memory
> mapping for the RX SGL (req->dst) provided via recvmsg is torn down
> while the cryptd workqueue is still actively writing to it (e.g., during
> authenc_esn_decrypt ESN scratch writes).
> 
> To mitigate this race condition without adding complex pinning mechanisms,
> we utilize the crypto backlog capability. By adding
> CRYPTO_TFM_REQ_MAY_BACKLOG to the async callback flags, we ensure that
> the crypto core properly serializes the request completion, preventing
> the socket resources from being released by af_alg_release() while the
> workqueue is still processing the destination buffers.
> 
> Fixes: a664bf3d603d ("crypto: algif_aead - Revert to operating
> out-of-place")
> Signed-off-by: NGUYEN TUAN <nvt031@gmail.com>
> ---
>  crypto/algif_aead.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> index cb651ab58d62..123456789abcd 100644
> --- a/crypto/algif_aead.c
> +++ b/crypto/algif_aead.c
> @@ -229,7 +229,8 @@ static int _aead_recvmsg(struct socket *sock, struct
> msghdr *msg,
>          areq->outlen = outlen;
> 
>          aead_request_set_callback(&areq->cra_u.aead_req,
> -  CRYPTO_TFM_REQ_MAY_SLEEP,
> +  CRYPTO_TFM_REQ_MAY_SLEEP |
> +  CRYPTO_TFM_REQ_MAY_BACKLOG,

This patch makes no sense.  We got rid of MAY_BACKLOG back in 2020
specifically because it causes the kind of problems that you're
reporting.

On a modern kernel, the socket reference is meant to keep the socket
from releasing its data prematurely.  The socket reference is only
dropped after completion.

Is it possible that you're using some ancient kernel dating from
the 2010's? Because from the context of the patch that you sent
in private, it appears to indicate that MAY_BACKLOG was still
being used.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
