Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C743B7B68;
	Thu, 30 Jul 2026 07:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395935; cv=none; b=gY5dTF5xQR6VvfKfo7pW9MkIpKZXY3uhaFky/hBTEhSdPoHGGc/LBHi5MJLLeu9ws5zNNwnDORDQQJ978nopaZ0K/4gj+913AUaBDq61T7Lme94vRvEyRy9u0FN55O1Q1ZC9by2sGha91KsqFx7QsS7qwhnsohoGlhgRl4aZSww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395935; c=relaxed/simple;
	bh=YvldhKBQI5rPlwM4XHWeJV5wdSST5NPz9HqVrSTpwms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c7Z/aU7V9Tj7o4+OeGwyYV3SbTP1zaRlxnU9V/8++rFqLNH+vBmOgQeFhY9t/dF45bS75vBN20f/4Ip4AzYImATZ6o1QaoM68vQow77aNXrXXMplpeegXlYvtcRn/9mlwb1s4h8dJsxKPDXZQ709146yY5/z+2HqzTfNKs/7ewc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ITknDDE/; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ITknDDE/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Hsa9CuUl/rc+k6UbFgdZ9VAPPTakSkaPNtgO6F1gYSc=; 
	b=ITknDDE/coGOHswIm7UDW9h2XtepWa4y39/wcMEFM3fgsSizKt3W7LJG/nqVh/t0+9JGyQhC2wf
	ox5MPTEZfznTSep9lx5J26dCfVjMYD/Y7frj6TWQwbpqWCGp6IeLHETfsxKZ4yQvxPZGeqgL4nNX+
	nP/2xIq/gFRJVLM/sPo9Gv35V74m8ipLHX6kkYu2Bw9Lmv0XgFp/ZO99MHlvZxHXbq5S/By+2MNjQ
	IuE8xWDW8P+f6qgPpW2LnvQkB0eu4kWEQvLCkAezTAMEeeZfLlOVFeiGgAomwCH3Eyzfvrr+pYabG
	Gi/9LLYKzKxeJ4xhHMggiFXivOvGJDTfxb+Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wpL2W-00000000Rdr-1Qsz;
	Thu, 30 Jul 2026 15:18:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jul 2026 17:18:48 +1000
Date: Thu, 30 Jul 2026 17:18:48 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Paul Louvel <paul.louvel@bootlin.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Herve Codina <herve.codina@bootlin.com>,
	Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/19] crypto: talitos - Driver cleanup
Message-ID: <amr62AUAifNXVIns@gondor.apana.org.au>
References: <20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911@bootlin.com>

On Wed, Jul 22, 2026 at 10:53:44AM +0200, Paul Louvel wrote:
>
> Changes in v4:
> - The modification I did in v3 in PATCH 1 was incomplete. message_size
>   was not initialized in ahash_init(), and not incremented in
>   ahash_process_req().
> - Link to v3: https://patch.msgid.link/20260721-7-1-rc1_talitos_cleanup-v3-0-7c71a2b77c83@bootlin.com

Please check the Sashiko comments:

https://sashiko.dev/#/patchset/20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911%40bootlin.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
