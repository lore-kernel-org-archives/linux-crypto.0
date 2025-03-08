Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6C0196
	for <linux-crypto@vger.kernel.org>; Sat,  8 Mar 2025 10:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741430778; cv=none; b=Dgl8FZfWj9S/HMP5gF/gF92EpiRLS19daJU8Ia1HkS6ZmufWTyU29LjmUWIxkx2YnAE9rM+VjW+chQ9xHvnVC6TqghivkbhWSYG/zQcOI1KzdoA3Je9O0lII40789t6qBRwidY+AiretQDUyNaUiF1bvR2tQPuHgBUECLSiQHwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741430778; c=relaxed/simple;
	bh=Py8JDp4paC7MUlQPdJv1P8K9yISN6bz6JqUWf/8ZOdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JeTdUIR9rbURY1EpBSLstlJYekOQWnpWkpR14xSzVQOVcbV0FPqpg/19Cv6NxxoJmpMcH5o+vKIKEaNUKBr+3aSj3Au89kwohfkkx4mH5UQMmYFZ7bFWvC7293jkq3aUYIpUMFRp01nYavT7IaKSwa80t3HQZVODG2IAXdAtZlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZaKdcIz8; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZaKdcIz8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QWTii+kAvX/yw67HHD6XBHgX/jVm9GNvO6Euzod42PI=; b=ZaKdcIz822Ss1ELlFo8TjYBfk1
	/qTrObJqW2YQHmNcPLXVlPsOMjK29Ql4wsksWTm7y9CSyjy59tOWZAd0kldjUHmJotwg/lZwgpmaV
	03F+cnStWnoBZoiqng9nKABywHB6JKiTdDXRpdZJf3McuW5uig8dxfrQpgsk7sG1KNKYiyO5pBPLz
	dz50lAca1YppspUu6mtE6WuclKOr58UZzDOydGlq8k9HmUJO/0gP4ghDkumponCkgB0a1czwML0Gl
	QweG9hlLsijs9TnGtATpZRZDfHyoOE18rHMpt6DT76kM1JVgjNxABR43n/8duDm8Obhq8XhDivVfC
	rIbSZmkg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tqrh0-004qJ4-1A;
	Sat, 08 Mar 2025 18:46:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 08 Mar 2025 18:46:06 +0800
Date: Sat, 8 Mar 2025 18:46:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 1/3] crypto: scatterwalk - Change scatterwalk_next
 calling convention
Message-ID: <Z8wf7rGMcj6MveQF@gondor.apana.org.au>
References: <cover.1741318360.git.herbert@gondor.apana.org.au>
 <2b608ececa9eee4141391ee33dcb7d59590b9280.1741318360.git.herbert@gondor.apana.org.au>
 <20250307214349.GB27856@quark.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250307214349.GB27856@quark.localdomain>

On Fri, Mar 07, 2025 at 01:43:49PM -0800, Eric Biggers wrote:
>
> This is okay (it makes it a bit easier to accidentally use addr after it was
> unmapped, but it's probably worth the simplification in code), but I think using
> 'void *__addr' would be more consistent with other places in the kernel that use
> a similar trick to have something both const and non-const.  For example
> struct inode in include/linux/fs.h has i_nlink and __i_nlink.

OK I'll rename this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
