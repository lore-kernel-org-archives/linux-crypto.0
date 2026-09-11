Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E3E30C157;
	Fri, 11 Sep 2026 05:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789103597; cv=none; b=m4YZBphJ7jUp34Wv1mEtIAoU2FJGt4HBzMeZvAfcm+gnJA5rXxH8lc3jmHiw3DVeb26xiZUFXlMrHIG3QeW8mh6pGIkpT/CGMeQu5CXPhePBl/s2dQwmjouOwqmtvT3XNqy0Kn53kQlcTbcZzoun7qT442C5K1bS0jHUDp0wbYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789103597; c=relaxed/simple;
	bh=oOvval8McVJyYVXx1aV6wMiX68Diuu4hwSzl2Z8eK8U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=aENp6/yvUOYptmL6kN4thr7pN47en/y6TLfDR/IyH3h2EIu/1XnLNftSmZKTgrrUzwLdwjnhs3O+02B0gkw0DQPHyAcADvft3qx+FpgTt5maM3COeI6qDrZ/6KtuB+nkq9OdyUdr6BHO/7MV0Z+zI1w+7rU86F9oHsdmSYzXjbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=HUYIWIah; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="HUYIWIah"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=6GiZjFOgF+AJ/792H5htU0nxXFf6pRM5nKezjdMZKO0=; b=HUYIWIahpX5rh1dQNNaVappbDF
	nxssIdDWYsiFpXmGSOWXzG1mNl9+dhXr6AJSmvbj1c8SPbElMWxjmOOAfMlPaXlTr7I75JbTi/kDB
	5r++suDoxiyDtFwD/MeINyPR1KZkzb1D7EYO1O4GKpg+395lkkOf5nf3xRgPzIYBsZxqVWA8WtWGE
	jpIPwWepMu8uKd5fgT7d84hgaXoldAhqwZqxA/G1+iNZ44rQgsstiPgVusoylEcy+0/NMYaEahnFE
	AnDxR8G+tuAJTZQVKpjspj23rO4ECq4r8Vu3WEeBL83g01+wFQx2In8yE8Is1UujXpuaWLBUnBaCa
	6Rm8qyPQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4tZV-0000000Ctvl-2bRq;
	Fri, 11 Sep 2026 13:13:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2026 15:13:09 +1000
Date: Fri, 11 Sep 2026 15:13:09 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Abel Vesa <abel.vesa@oss.qualcomm.com>
Cc: andersson@kernel.org, linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	abel.vesa@oss.qualcomm.com
Subject: Re: [PATCH] MAINTAINERS: Add Qualcomm Inline Crypto Engine entry
Message-ID: <aqON5aC1OxlRxqxU@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819-qcom-ice-add-maintainer-entry-v1-1-60fd2a7ccae7@oss.qualcomm.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Abel Vesa <abel.vesa@oss.qualcomm.com> wrote:
> Add an entry for the Qualcomm Inline Crypto Engine driver and
> its device tree bindings.
> 
> List myself as maintainer to keep an eye on it.
> 
> Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
> ---
> MAINTAINERS | 9 +++++++++
> 1 file changed, 9 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
