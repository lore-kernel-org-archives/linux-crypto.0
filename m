Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A65143AA8;
	Sat,  4 Jan 2025 01:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735953259; cv=none; b=Tfdf55I+paGWhiO0BMBDA9SfKtayKyMia8QU2t58LaZZN+5BEw4hxgm+SMe5LMQuzT1E6vP/C2b1jYpN4aP9IgfwNPhwDdpOELw0kXGvModIJOlo5oTgUFinpLmojIldtLztZUYRr8YgwR4E4DguxqsNAs76Mt9Gq0umDFyQb+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735953259; c=relaxed/simple;
	bh=VQficUGqmniCBh26+FNsNmNODR6uP2sRN3aR3dIe5Z0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FpxsA973Tvs3JhwS5XAmeOEogdUHgROk7VDlTEOdYkl0442ZjJoyn1urPDmt5ksREJRi4zYmb3SsHqGe8nl/A/WE5UE/DYeCOZ3KOvqDYU8mAMOwyl9HzxzRPGD7IXHskBugokdFBMfoGadYyWwc13s4XwszHhhDaLDJT2Eig3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=jZSmAjRf; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="jZSmAjRf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6izykP3CJX+x5ZDNZI4qfj++QaPPbkc64TG03z8kobs=; b=jZSmAjRfcesvETiYQCWanLGqN1
	TREibfIeX0WhrT4lQa30LK4sVylGBkqSEyJ501GJriWoR0NsHzrbowhxHg9B2VViDvFdz75yh20LW
	NS0ZomgxR30MNg67tWWdBpdNUM7AFzx9Gj9xfoK/DBhHtC8h37EeOXpv2dkbax/BdDak01gTCVkUq
	WDyACrIX8TTCwrA18yqdti7QsECVo8OQ6o01tM3h2nRNdIZqdzC7ToT3t5K6kUFFnEQn7N/DDsod6
	oQtO6a/7vDM89ui2FIxHx7Ps61DcT7yJRiLqvy4ygc3wdqw1/JlInFL7PMwwP2r4MA2DhNOV19UT1
	emfLHAaA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tTsX2-005fZr-1W;
	Sat, 04 Jan 2025 09:14:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 04 Jan 2025 09:14:09 +0800
Date: Sat, 4 Jan 2025 09:14:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: fips - Use str_enabled_disabled() helper in
 fips_enable()
Message-ID: <Z3iLYS7az6_dXbKn@gondor.apana.org.au>
References: <20241223075410.405632-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241223075410.405632-2-thorsten.blum@linux.dev>

On Mon, Dec 23, 2024 at 08:54:11AM +0100, Thorsten Blum wrote:
> Remove hard-coded strings by using the str_enabled_disabled() helper
> function.
> 
> Use pr_info() instead of printk(KERN_INFO) to silence a checkpatch
> warning.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/fips.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
