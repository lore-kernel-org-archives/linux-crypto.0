Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC9B292901
	for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 05:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747288309; cv=none; b=jm77mdH1yJ2aZBTNgt6rbYA0SUr/Cg4fIW2mZdPBmoWZznKDTHTlU34EQk2+adMHKvgpji2My9g+kSY8r3dT6qDyy/rbDLtBNi0tyE4Z+eq5SeMcVZR1DJxRT3b4LyXOo/tYplcyQprwIZORRyMQyYXpUVwnYHGuxuT1uUd9WzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747288309; c=relaxed/simple;
	bh=Iv9cS6HvlRSL/N6320Z6s8PCDRTSk/sdRsWp6UCgmNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XKMr8PLGL1PQjlXYAPZp1Ejc2TgpPL+ZzdNydM+WRwelCnGqs0sjE7INd2JSnzw0MIkCS5EyN5KIZhb4OVh9DOXhe4Emng9JgDu14vXqNr7xVrankUuaOpKVeVY7WIGSZynawwrVDiH105qv+lbiuERaMD3oAbkS/6qzbo1Qo8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Qj6GrN4X; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Qj6GrN4X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jetTA5mFkeouBVJwr4tv+ppy8wSm4Xk+vI6pPbCyFfs=; b=Qj6GrN4XrYJ8rgxEztFtkghjQw
	ZnINajxKWRaJEzr2z15oMgOjB15UpP/T8VeUgTIaDVi8Mf7h83P6UzMqoDJXpUzjMDR2FV9M6mHAU
	zp0wU9hm6HAjT4T/R3k2u3d7ZPF6oViqTq+ojjmnAp/vzcUF095t3pEiHi29csnINIyfxkmVpkNxi
	o+QrN88Vb30bWFGpNB+cRbfO/y4x8Ox6MhniUq5tpJgJ2gw5vQYOwGq3GnTcu6QkV81PvCn9swqg/
	KPRt6PIgPpGNm2KJ66qsblKpaMwdnBSzqyzuvY7xhnhlp0wMs8Y43QnZ4ft4Bsuwz5TYrWr1eJbFh
	8g+ANPDQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFRVN-006EWq-20;
	Thu, 15 May 2025 13:51:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 May 2025 13:51:41 +0800
Date: Thu, 15 May 2025 13:51:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v3 PATCH 00/11] crypto: Add partial block API and hmac to ahash
Message-ID: <aCWA7cGxGwlwhZh3@gondor.apana.org.au>
References: <cover.1747214319.git.herbert@gondor.apana.org.au>
 <aCSer34x-WvSRn4m@Red>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCSer34x-WvSRn4m@Red>

On Wed, May 14, 2025 at 03:46:23PM +0200, Corentin Labbe wrote:
>
> I get multiple crash on lot of qemu with this patch:

Thanks for the report.  This is caused by conflicts between the
self-test and the two hmac instances, one shash and one ahash.

I'll repost the series with this fixed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
