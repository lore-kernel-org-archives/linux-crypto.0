Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3568F3A3E79;
	Mon, 10 Aug 2026 08:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786350419; cv=none; b=jlBAcnuwW7bQ33dCcZFqVcXIBOSWky8ux5Zr49mJDBnV2rgFRIacZqjgHGoBCet9m0YvNGRKd4V1HK2coQTiz2DZCPkX+UrRqHT9jIMcXW3hfjglFD9WY27DJoYxUWiXZBr/mywa5YlXqPd2ql1VJidhkNzBHHLbbJu6Znj4fSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786350419; c=relaxed/simple;
	bh=8u8L5QFZ7HsMXM+uClQVSFN6QX0o4xsVJAigAtaJe5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uBCCScbX0h9T83tVqln79jCSKlHSObCY/uqvWlasYIqJQrc/F+mjd73F1+0b3/VfaceqdYICinxzH1LaoSTdwE9FmxZ3VCuF+bc6evne3TITWpUJEuyFN/ov5aV0AvTDdVZiA841x6WXmuO4TogSC+w1J2WiQAkZtJXA3R3HEuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=CLqg0846; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="CLqg0846"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=pwJIyQRnxM3zqh6zbTqbH/uU2hFHBVFkfjSb9ptwYA4=; 
	b=CLqg0846obmhT/ro7FbkQyf4KBXmsTnt2zcKJa13700PJkM3Ub1WmDzZvc0skR/lTxBeky9X4p/
	VYAuBx/V0YS4Fjnv80bRfRspsSF6Oqm5FeUOfcvZLBccQ6OB2SyEzn9hCgRwHrshPAd1OiayRqNq5
	osVMmICr9GNyWN78Sane5c+RKrRAlKqKyk/BiwwH8tZSgQdSQ5rQJAnHjtp9cS9Cbw8DAYaXwvBEs
	0dB8rAuP18Ap/l+qID6LOOdccwbX620VbPOCiwp4Fd16PjH2Xj9CvfpIcazhiN+7VdsRQNkMAVzh/
	1t+Kk37gePKmJvE5Uq1bZ9cO5kQZIiTvcovQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wtLLR-00000003WeQ-1nUj;
	Mon, 10 Aug 2026 16:26:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 10 Aug 2026 18:26:53 +1000
Date: Mon, 10 Aug 2026 18:26:53 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] crypto: talitos: Use platform_get_irq() to retrieve
 interrupt
Message-ID: <anmLTacvWJxwCKRS@gondor.apana.org.au>
References: <20260729030231.642651-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729030231.642651-1-rosenp@gmail.com>

On Tue, Jul 28, 2026 at 08:02:31PM -0700, Rosen Penev wrote:
> Remove the need to call irq_dispose_mapping as needed by
> irq_of_parse_and_map().
> 
> Simplify the function as a result. No need for gotos anymore.
> 
> Add a missing free_irq.
> 
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  v2: change irq checks as a result
>  drivers/crypto/talitos.c | 30 +++++++++++++-----------------
>  1 file changed, 13 insertions(+), 17 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
