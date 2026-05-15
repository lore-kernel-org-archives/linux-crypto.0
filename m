Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23253CF951;
	Fri, 15 May 2026 10:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840619; cv=none; b=dsuTC71CYE+kG33Ger3gkNkgUEfMn/bSJVT08aDlhdsPNthVY1NgnZDpj89w8dQnpBqfIlTe574TK+xKcygJcUEWl3PWkTnDxbY4kMtBlmVWJDTf/VGNC4lKNZP4f41h1qCzRLhZrLfAiDgFXouPF5HDtbLL7zURtd5enRKmgnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840619; c=relaxed/simple;
	bh=R7aXz9mTPmKJVoVtiS3o2B/RRmY2AzQeUggiuMFqnoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ixpOsloIqrURCvW4fjuBy5i8mNNiKDEF1zHtmcWOPaIkOye0U5EoWXsFCipCZKR2O9kMmpxVyLkgnpn/Ck91aKiWmHRrptFKPHHH9iKBQhu/fQigfreN+8y6XkP95sf6gLpH/SAZPNxY9AhTVRm3PNy+TIZWafDzF9BRzHpddJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=U/M9ZD3w; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="U/M9ZD3w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Vmkw9ZqL3i7iGxyj5c3GlZDa8M1kFmHjk7JdniExjMc=; 
	b=U/M9ZD3wK0CMg7Wap+kOw6vIBRH2Krx4hjKR0sdeTJKbA9CQqUonUuGsCLZxNkO03Q+wXfLWQZ2
	LDuPJJ57ay4DlCWLLPCsQy5vHn8LnM2vzpcKQQkCxNxUJXhaFhsFrSZHceiUISaos2SiRvQ3ZP+wP
	bYHkteQ5E8GWgD8Xevg2tqoFWDmvJUSOrCrH0IK/oEXf6j7n9JelIPpTlzz49vkLRyYiSPeuvXB0N
	LIEbD3cl8G0H4ME541Iec/obr/WejT4RphdzAk+rbRdUo2uXW3hqx3Bjtl2QbMBHOg3H5kY0tICef
	nM7tMV287qyL2yhLTxxgi27QWFzLKmAgBhaQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNphe-00EOYB-1C;
	Fri, 15 May 2026 18:23:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 18:23:34 +0800
Date: Fri, 15 May 2026 18:23:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] talitos: use devm_platform_ioremap_resource()
Message-ID: <agb0JpSHrDp4Nu6r@gondor.apana.org.au>
References: <20260507234416.677882-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507234416.677882-1-rosenp@gmail.com>

On Thu, May 07, 2026 at 04:44:16PM -0700, Rosen Penev wrote:
> platform_get_resource and devm_ioremap effectively open codes this.
> 
> The return type of devm_platform_ioremap_resource() is also nice as it
> has multiple errors that it can return.
> 
> Because it internally calls devm_request_mem_region(), reg values and
> sizes cannot overlap. This was manually verified to be the case for all
> talitos users.
> 
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/talitos.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
