Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06FF9443;
	Fri, 23 Jan 2026 05:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769147680; cv=none; b=F0Kedc6smFwRRPel17plQxaZgeK3+ztXA8gVwkuNKOeDL10zUX9Gr1IHsSe+UCjEuCI71iw1ZvkTYVlz5XkrNYjUOUQz7/L3W3MWmL8D36JLSMO1v7A5xwi3GX0TSXQkrL8XLboNPmr6JPq3OZ61n4wpMmmDtm7/5yWSpMoCfkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769147680; c=relaxed/simple;
	bh=VaS9LTVkkDkfTFcMJM4TyPBY7sQe/Zg59gXLXpy0A+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NqFbxHngekRaJvCpHkuEDDqX3n1G7yMWBxcrF2RIFfnR//a84VD96NC3T4fpairLRs1gww4G12MCuv4nWSkgDDlhd9FUbwBK2USMVC/tvFMKkNGbl4/5fIy2cML12W5voswRVDmnN8LSb+qR6RymX7V5VxS84NfXe3mGo2AiqYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=AnqKnJaS; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="AnqKnJaS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=HwzA5PectezhbySm14kOGAx3X2JCc+6nRbqadM2vfqk=; 
	b=AnqKnJaS8vj30JMQh4MGXABLx4kCZVryURML3wcukDx3g2W5kbLBxr52acVMv9OWWZBKLocCRiY
	0kS4683ofnYFmKAvgX+n7wu7wforYGpX9kJFU3UsYb53Wf3uhSK0Hzb5c5D7sf8RgtfsJ+206lRrd
	G4cmx/J/X7IVMaENvYf5dAJLnaWRDIikmrfjWYPH9HAxxucT2oPEmX0Z2hosredQCk3RLhNiWCAYc
	4UBX1iDozurOe5SFaFBtwC4SkjbScTVosHol37Nw8ztdZmnR0ZzRJNiF3XAxrmgpsDkLl20iJq1V5
	YAeGeBQ1pdquJ9aefGWqBlsghcocXMy59Eag==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vjA7p-001VLk-04;
	Fri, 23 Jan 2026 13:54:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 Jan 2026 13:54:29 +0800
Date: Fri, 23 Jan 2026 13:54:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: simd - Simplify request size calculation in
 simd_aead_init
Message-ID: <aXMNFa_Wa1Ps_j8V@gondor.apana.org.au>
References: <20251222104254.635373-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251222104254.635373-1-thorsten.blum@linux.dev>

On Mon, Dec 22, 2025 at 11:42:53AM +0100, Thorsten Blum wrote:
> Fold both assignments into a single max() call to simplify the code.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/simd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
