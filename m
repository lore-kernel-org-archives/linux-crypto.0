Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3889F29CE5;
	Sat, 26 Oct 2024 06:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729925595; cv=none; b=o321WkqET5xjbQbvfjGCtlnynBF8FuLlspxLGSnUtofBrseVwifhugqIvcvVaMEY/5DuVA0iP/zW47GPlLU2q+vZrARygHIVrVlABzypsOdxTGKDx22RvwbbA0XhYrIDxSWXsNgNya4FrU3fkyaEkuIOzw4BmaTFmYyvWjNC7h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729925595; c=relaxed/simple;
	bh=QJvLdK+wCiwLhbO975C0bPfNczVQWVsevuNn9U2giBc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=owPiR/Nho4R9pnOWiObWFzeotHeAN2qsZDsAOJARIU2swzjw/L4boUzjAqszTDeZa1XuUM90ARAsHlV63twDo1fea8xS/PwmN2R2fJg86VbWWCImVj4ct9PuqxJqLj+3WwTBI499kNbRypS5cSRQVqjj28Ca5xd5FWD228+1MNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Wxuqpdj5; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Wxuqpdj5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=rayIZPLvmg1WK0WKZTmexEEmG6O6yNDBVCWaCdAgmm8=; b=Wxuqpdj5eDh4sPFl0XTn2PPFh/
	cCOFVG3xtZjMf8dDceXoCbYn66tyOrbq2xsQlJze/lv6rEhPaUCCZfTpZhJTna1acpOeIN/yODuDK
	NQ+51SKdCUJGHnb+ps1a/QN8Q5Cr8hmcxoU3mT7EglAcoGik8T1Xr3QKjr9nQr88+MznROCDr7NiN
	6XalRm9RULzVw5wMe3KqEzVyS1UMU6fPuAGS9ZZkvl6qJZWeD9xGWET/oaP/Rjw5asocq5PxoGG5a
	YxYJo60lDA8pL6ICacRLw+ZstWe+K8Vc68bQnoIAAoFQ7fXdfcgDZKSdqc4otJ4rJxmfK5Ghv7EyY
	bh30I0cQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t4afY-00CFrf-2L;
	Sat, 26 Oct 2024 14:53:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 26 Oct 2024 14:53:04 +0800
Date: Sat, 26 Oct 2024 14:53:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, ardb@kernel.org, jpoimboe@kernel.org,
	peterz@infradead.org
Subject: Re: [PATCH 0/3] crypto: x86/crc32c - jump table elimination and
 other cleanups
Message-ID: <ZxyR0JR37_uuZ5f2@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014042447.50197-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> This series cleans up the x86_64 assembly implementation of CRC32C to
> reduce code size, improve performance, and eliminate the use of the
> outdated and problematic jump table idiom.
> 
> Eric Biggers (3):
>  crypto: x86/crc32c - simplify code for handling fewer than 200 bytes
>  crypto: x86/crc32c - access 32-bit arguments as 32-bit
>  crypto: x86/crc32c - eliminate jump table and excessive unrolling
> 
> arch/x86/crypto/crc32c-intel_glue.c       |   2 +-
> arch/x86/crypto/crc32c-pcl-intel-asm_64.S | 354 ++++++++--------------
> 2 files changed, 126 insertions(+), 230 deletions(-)
> 
> 
> base-commit: cfea70e835b9180029257d8b772c9e99c3305a9a

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
