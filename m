Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA9A441054;
	Fri, 15 May 2026 10:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840046; cv=none; b=UxojKqLAujYCSoAKiJzWQRovNebF4k8Ckc/2h36ly+6wqGfybfjCrL1iBVneasNbJfg8FrDH3liQvNw9i+fjipkL7M7s5b2u9GQL6sjo5WZEEbYNeON8ug2PE154VjwLBH03KZR8qo6m5yuWfveZQVxxRZcaFtdmhJt5KwPCHA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840046; c=relaxed/simple;
	bh=z04omXcEpqh1x2VkJVMfCUFGdyCAO1ePW1o4F9HDxvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kxKZW/c8maIkfdaPciuFsJ92e4umumpVoz7hfftc55TZmoz3XMVMshWv1M9beVdqxGceO3IHwK7bKGOg6ASE4+rZgiy6hi62dqrD0CEH1VDfaGFO/vjzZsO7KtXVDaJQVjb6fafO5gjKkn0q9hOLbC8BvQGf8YU21M91L7Y/agQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Y2ZVH2vg; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Y2ZVH2vg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=EQAIrYuBBe6ZELOGYcs1axL1U7ksKdyMyMZNHOxF7RI=; 
	b=Y2ZVH2vgFmd1YVPfiSEJmzaPujJpr+d5xq3gzTH39qS9HLYYq29sksEWnmTHcbP1tcNfO/Oq+Zn
	4clPhcKZkTj3aJorZM/pR6Fnr2sbmufr+3uMHqO7FzkCwtJNDueEZ6pmQn6nne7El1SSdNeRG5M6+
	oUig4z2D3MfD2qaKI+kJDWs8Qn3eob7ECED7//CmdfWXOt6gGVGBbOr7IwMX4c9HqOVgfa7a/OwTN
	bZEFx+dSFl/zUMZ6tMdfyCDwcjf5BUZo6E9WhVutY46quCd8qN1kw0oB6s8L4qNcw5NYIC4Q8C3Ol
	Tte0pr1ElK7CLD6MwlkXu9bPJ85gZFU139gA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNpYJ-00EOHt-0P;
	Fri, 15 May 2026 18:13:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 18:13:55 +0800
Date: Fri, 15 May 2026 18:13:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	George Cherian <gcherian@marvell.com>,
	Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>, Kees Cook <kees@kernel.org>,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Amit Singh Tomar <amitsinght@marvell.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: Drop explicit assigment of 0 in pci_device_id
 array
Message-ID: <agbx44LfQembS6X7@gondor.apana.org.au>
References: <20260504153221.2151136-2-u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260504153221.2151136-2-u.kleine-koenig@baylibre.com>

On Mon, May 04, 2026 at 05:32:21PM +0200, Uwe Kleine-König (The Capable Hub) wrote:
> Assigning .driver_data for drivers that don't use this struct member is
> just noise that can better be dropped. The same applies for an explicit
> zero in the terminating entry. Drop these.
> 
> Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
> ---
> Hello,
> 
> this is a preparing change for making struct pci_device_id::driver_data an
> anonymous union (similar to
> https://lore.kernel.org/all/cover.1776579304.git.u.kleine-koenig@baylibre.com/).
> This requires named initializers for .driver_data, but dropping unused
> assignments is still better and a nice cleanup on its own.
> 
> Best regards
> Uwe
> 
>  drivers/crypto/cavium/cpt/cptvf_main.c             | 4 ++--
>  drivers/crypto/cavium/nitrox/nitrox_main.c         | 4 ++--
>  drivers/crypto/marvell/octeontx/otx_cptvf_main.c   | 4 ++--
>  drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c | 6 +++---
>  4 files changed, 9 insertions(+), 9 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
