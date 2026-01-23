Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4702037648D;
	Fri, 23 Jan 2026 05:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769147902; cv=none; b=QcIaynldiWguMNAk/FUQceGncP/lUvBgLqZDeVTd+y29k8xjL8rxgZ66eGXe70dU62/PhrLeepTb51sFs72rliOx45RSlS8vZmd5awFKEwtWsLbyTZsccNVgdw26GS4KIsnj6+eBqsrWBoZUlLSO7dHjShYGviK7KMFnCEbXGwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769147902; c=relaxed/simple;
	bh=gCfIEkwtlVOW1vh1W9KXZ/IsPBlSCJD5kc47XzgwUKA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=rQzYx5hETNggcDSQTFp1VQX5R13gg3KpMx084cpX1aT/YPQhoXJh+UBQ4sRkiq30Vb3YLuXdgqQoWsc5hRGev8NLEQlaUiNyGpVQzeq8xEshCAye8R/cn00V/hT+qD/MuC+4yqZA+Xo0Y8ZJSRlNUfjshFmdl/UAJeezPZ0vv5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=NN/vS+KR; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="NN/vS+KR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=s+Wo3iM2icQGPV6vcWu3/JhRLr/ikfaLTZIuEs7rhvs=; b=NN/vS+KRYZzpKhU9w3Zlkz646s
	1zqL+KNg/pMfLhyRVyL60ydBW4CRb0b8+YIxy7/lA7sGL95iCuDBl5yMKaJbILtVuEACvf89FIM8o
	seLqdUev1xhrya+hjVNyKoMJJCp/paGAjfLQjGchry3BZMF7Ws8pB8L31meXlgC9mghMC5R0zgiL2
	4pT+hlkaApm0j203xYKCkdntAsGLQSC/iiGMkSgxbNskJaa7s/0IHuZ0xH5AonZeP3sHGGwN+PhZn
	977OPw8JvKFyiXP7VZSqVF+bT0mtK+1AbJtKIWz7JcFCmfeWyI6mrHg51XQW/Yp5kbLs9Yl1BKmkq
	XJDqv4yg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vjABJ-001VO1-0W;
	Fri, 23 Jan 2026 13:58:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 Jan 2026 13:58:05 +0800
Date: Fri, 23 Jan 2026 13:58:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>
Cc: steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@weissschuh.net
Subject: Re: [PATCH] padata: Constify padata_sysfs_entry structs
Message-ID: <aXMN7Rqgn5-GIon9@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251226-sysfs-const-attr-padata-v1-1-8f1cf55bd164@weissschuh.net>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Thomas Weiﬂschuh <linux@weissschuh.net> wrote:
> These structs are never modified.
> 
> To prevent malicious or accidental modifications due to bugs,
> mark them as const.
> 
> Signed-off-by: Thomas Weiﬂschuh <linux@weissschuh.net>
> ---
> kernel/padata.c | 22 +++++++++++-----------
> 1 file changed, 11 insertions(+), 11 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
