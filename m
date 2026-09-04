Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEC241D11E;
	Fri,  4 Sep 2026 09:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788513885; cv=none; b=Ia6m15qH67b0IM79Y7AL4+c//iYLg5RzyFEvLSph0nNQ0241KH/cWVFdNPw6TtX0hB94JnqKrc4rv6KviH8/w9NghAJT29BAXHBshcyunne/HVm6oY5ADO+3xLPKRQiv7aSHg4CawymgW61fU94Wqc8HbZ4u9I53WsqsStG4+lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788513885; c=relaxed/simple;
	bh=NqQEDdRHMhg5B+jmdf9cKYHZHrZZj/qtIq/5rdV9ziQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mn0ijbhYu1a/o60ba8afjBUuF8I1Yemv3cfM4UFmTneDPGjApalcUGj8IZnLHKLwd7qTdVHt/F7wHk7Tacup2JfFJD8aFaGM6sbz/DFmJoCgKyQK+H2bDbQvqoUxbcRQi/DfEytNeVVM+yT76QtSP6UDGkBHac+Q6AAil2RrJoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=kGQtRMhO; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="kGQtRMhO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=IY15GYqqYcoIVB7FbFnb+BcNyuhABaf1Q4ILaBqiqxU=; 
	b=kGQtRMhOegj/isnVZ29E/9XDYoZ8kEeNNS+qsfWVXJcqCVdglshxd1GwohUywZ+uuTLlwLJoT01
	H5qavf7H8+7b3kFeYScT57AFZbV8kaGr2TSpa6oTkry0zL6FXr3w064wOEiZ4GyLfgCyvsh+V740M
	i8FY8Qe6960n+0mrSMeqphjnibP22hRKQ5nSjgPzTPbQCS3cPQYt8r0RAgHe8OQ3+hcZmVTvw0u8K
	+J+VTH//sb7Dc+EkLs2zTFB4j9dAjxQBE2F2NkJXbQEJhC7ox9pyY8+qVwiUOV7tFLl7ooYiQHeRP
	09IG98GiEmOlja6jRHEuLh5TtHE7+WPxnnxA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x2Q9q-0000000AmYy-2lPb;
	Fri, 04 Sep 2026 17:24:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2026 19:24:26 +1000
Date: Fri, 4 Sep 2026 19:24:26 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "lianfeng.ouyang" <lianfeng.ouyang@starfivetech.com>
Cc: Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/2] hwrng: starfive: rework clk/reset teardown order
 for JHB100
Message-ID: <apqOSl1m-5ctry_T@gondor.apana.org.au>
References: <20260812023401.44149-1-lianfeng.ouyang@starfivetech.com>
 <20260812023401.44149-3-lianfeng.ouyang@starfivetech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812023401.44149-3-lianfeng.ouyang@starfivetech.com>

On Wed, Aug 12, 2026 at 10:34:01AM +0800, lianfeng.ouyang wrote:
> From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
> 
> Rework the StarFive TRNG driver to address hardware-specific requirements
>   for JHB100 SoC. To avoid reset-domain crossing glitches, the driver now
>   ensures clocks are gated before asserting reset during teardown for
>   JHB100, while JH7110 retains the original reset-first sequence.
> 
> Add per-compatible match data (struct starfive_trng_data) describing the
>   clock/reset teardown order, a new "starfive,jhb100-trng" compatible, and
>   select the ordering from it.
> 
> Fix the runtime-PM get/put balancing across the init/read/reseed/cleanup
>   paths, manage PM and the clk/reset teardown via devm so all error paths
>   unwind correctly, run the SEU-triggered reseed from a workqueue instead
>   of hard IRQ, and serialise the command sequences with a mutex.
> 
> Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
> ---
>  MAINTAINERS                          |   2 +-
>  drivers/char/hw_random/jh7110-trng.c | 295 +++++++++++++++++++++------
>  2 files changed, 239 insertions(+), 58 deletions(-)

Sashiko wasn't able to apply your patches.  Please try rebasing
and reposting.

https://sashiko.dev/#/patchset/20260812023401.44149-1-lianfeng.ouyang%40starfivetech.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
