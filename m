Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BBA1F12FB
	for <linux-crypto@vger.kernel.org>; Mon, 19 May 2025 06:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747634622; cv=none; b=pvgrCTo1nP7GcM9ztxmxXclxtlO52qNSYlK9pAgs0oqV4WYCWehrtzzK9xYgqw9+avZJ25bZZA277k5J7SjoC2ZRJpdSI1I8CKq3LCsAkI7b6Rtx3t06Ker7uixU/FlA7h+bNgh+1Q9iOpPG6UBPIqvV2ljiGo8JVs2+Ey6OD9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747634622; c=relaxed/simple;
	bh=dG68F6VtsoK9J6j1bCmPbdyB492XYwDpFFUOBCqwVSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VHxETvQadqa+dbzhPXVYLuSHSqqD39+fjOo9PdU7nMTpd2pcz/572L+C7sEb9BUn41M3xbHOqCRvNMwxKr5lX/PSjlAVCQkEZDiLPJOrVM417PKBUuJBHCNhf0jCmQVFAj1OXzYyMTj9tLPkd0ZKS5gdPtxmD2tKZG6ysxb8ZtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZtgAbMHY; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZtgAbMHY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=w01KZDbzfl15EBlzlWACzQck36j9gcU7zBtAVVH8HnI=; b=ZtgAbMHYc5WBpT0p6L2u9AV6el
	WgY9+gbhytBv/XTYgxi3qAEISRYw2vZ/teHFGOyD/VS8ejuPbfpIFbZVkWYFL6rQOkokXS3DVeGfX
	ajOP6szv64LilpIUltcdvfa7YlZ89DSyuw2QSa3la9KFER+F11gzys4gXtuGNkysvfw0VnUqLAb1Q
	ekJpMNCLHyJsX7ReoRH8o9TrBHkZC3tE8LMmpcPoj9zqvL5zSXpLT/+T53vX/5BNieHPRYahszmJr
	0iQ6lWxGw2naQVlcFN6hMmD5hNUpMZXb2anBInJGuMWDt9Ysx2SzRdWiMSIr9XgQ/P9U0O29uXFYX
	ZBsLwneA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGtb2-0078Bu-26;
	Mon, 19 May 2025 14:03:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 14:03:32 +0800
Date: Mon, 19 May 2025 14:03:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mario Limonciello <superm1@kernel.org>
Cc: mario.limonciello@amd.com, davem@davemloft.net, john.allen@amd.com,
	thomas.lendacky@amd.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/2] Add some missing info registers
Message-ID: <aCrJtG9ItfCyIjOB@gondor.apana.org.au>
References: <20250517202657.2044530-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250517202657.2044530-1-superm1@kernel.org>

On Sat, May 17, 2025 at 03:26:28PM -0500, Mario Limonciello wrote:
> From: Mario Limonciello <mario.limonciello@amd.com>
> 
> pspv5 and teev2 are missing the registers for version
> information.
> 
> Mario Limonciello (2):
>   crypto: ccp - Add missing bootloader info reg for pspv5
>   crypto: ccp - Add missing tee info reg for teev2
> 
>  drivers/crypto/ccp/sp-pci.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> -- 
> 2.43.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
