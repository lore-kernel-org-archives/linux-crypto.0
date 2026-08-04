Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDCB54788;
	Tue,  4 Aug 2026 06:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.167.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785826120; cv=none; b=iTDm6CyshueLLjUfck1YmWM8owBYFZjzxDZyKn/zMncyW5EkazApKQgKLRJr4aMdaKh3TH3ldAEeIRgkBW5BD6bW0jY5GwkCVYIaIy+7v9n2lXQ0gzq/f/CQiSQzsvOEaqz/L3+f1sKr0qD5RVdExZXDivwHJGZ5ZRrlfWGef0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785826120; c=relaxed/simple;
	bh=wyo0kNP2752aw+6vjr7ArizpX5AT0P6KYghiQmrEvFE=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=EsmOtWRRU0b3ZAA1DZao2etifhST2ARmYutDpLJZZRnB8nArHu7jCeLV8/QHj8ARbkAKwGRYikfMQH7tId24jwE/JGVFeKx91FSktI7dVwWv8JczpcUT+W48m1rDf1Kb68FRM9BX9/7kFsCUEfAVwqfF25KBPGZVkC+wxnNc+gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at; spf=fail smtp.mailfrom=nod.at; arc=none smtp.client-ip=116.203.167.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nod.at
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id E6E1B2698E2;
	Tue,  4 Aug 2026 08:39:05 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id yc6umqqUXnqv; Tue,  4 Aug 2026 08:39:03 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id CE2962698E5;
	Tue,  4 Aug 2026 08:39:03 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ZWxMHDt_nNgw; Tue,  4 Aug 2026 08:39:03 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id AED862698E2;
	Tue,  4 Aug 2026 08:39:03 +0200 (CEST)
Date: Tue, 4 Aug 2026 08:39:03 +0200 (CEST)
From: Richard Weinberger <richard@nod.at>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <630163276.8329.1785825543421.JavaMail.zimbra@nod.at>
In-Reply-To: <20260802230055.100746-2-ebiggers@kernel.org>
References: <20260802230055.100746-1-ebiggers@kernel.org> <20260802230055.100746-2-ebiggers@kernel.org>
Subject: Re: [PATCH 1/3] crypto: af_alg - Make cbc(paes) privileged-only
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF153 (Linux)/8.8.12_GA_3809)
Thread-Topic: crypto: af_alg - Make cbc(paes) privileged-only
Thread-Index: ZL7G55OIxUV/IijvwIkal9O9HtMGhw==

----- Urspr=C3=BCngliche Mail -----
> Von: "Eric Biggers" <ebiggers@kernel.org>
> An: "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>, "Herbert =
Xu" <herbert@gondor.apana.org.au>
> CC: "richard" <richard@nod.at>, "linux-kernel" <linux-kernel@vger.kernel.=
org>, "Eric Biggers" <ebiggers@kernel.org>
> Gesendet: Montag, 3. August 2026 01:00:53
> Betreff: [PATCH 1/3] crypto: af_alg - Make cbc(paes) privileged-only

> So far the only reported use cases for cbc(paes) have involved processes
> running as root.  Therefore, make af_alg_restrict=3D1 allow only
> privileged use of this algorithm for now.
>=20
> Fixes: 947d62c09436 ("Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6")
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Good catch, my intention was making it privileged only. :-S

Reviewed-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard
