Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D24B4119E7;
	Wed, 23 Sep 2026 08:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153481; cv=none; b=uVFpBO1i5ei3lM1OJjKb/ZUawz3S2w96wdAJ4gO5rX6jXqZjyNoOq9Ac3zz3toGXJHnHjPIW3P4y9T7F/q/vZ/9401JbUm85obLYdsZOmXfo6zxwoL6WoD9rQzioaeZNXJz/HJOV6lU/Jlfmh1cdik4MIQwYXfn4Wc7zahQUyq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153481; c=relaxed/simple;
	bh=TwjWuXtmjbpCubC9WzO48ZtUBGNN/z7uY9o+uewUZHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QNQhdnquKCRTcHvZrUL13Ln71ALLa1HtBB2VJbt9txoWxGTXZBpxtThy4f+FbGIqCsMvk6irWRw4b/dEFimpEWy51C6A12XFX0nhUENxOBo7C/+fQjpW5iY3FXyRp/YwAg1DP0eIJgbQ2m1MV69M9HFhpZ4zTo+k3/JGjv/cWl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=RPoq+n0m; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="RPoq+n0m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ro7pEmvZNK3XGMabC4lVjmZbWwUyLq3UHWN4CJxyQu4=; 
	b=RPoq+n0mleY7T7RBiPxzoVvPycHH1QoybwhAUt/3Rxky+a1fNfaMdQL9fY1unumWbTXIMckREtB
	ld5hNdFav1nQ1LByU8hbcgrN7Yb+f/nIyCP4B5Ue4umrp18gjL/HwDfy/fgrheg35C+acHVgzzV05
	6f4Mcd16L3L0s+CmzMf2IwbfvKGKhO/k/bEu1qbltwMsUuuwkB3D18sv+NustHyAD3ZiZDQc4fEM/
	QTbU4lUtzY1z3GVbhhQpyNXlBSOsPHvL6x0ZWSBHxO9lS38BKkEPIF+MlVzaW+wY2E6Di1fVS1Ooy
	NOuxKhycVYEE1LUK466dWB8hfxhIZB3r/WIg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9Igx-0000000GyE1-24CM;
	Wed, 23 Sep 2026 16:51:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 18:51:03 +1000
Date: Wed, 23 Sep 2026 18:51:03 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Haren Myneni <haren@us.ibm.com>, Dan Streetman <ddstreet@ieee.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>,
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/842: depend on the decompressor for KUnit tests
Message-ID: <arOS954lq6Il5E_N@gondor.apana.org.au>
References: <20260917055645.26780-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917055645.26780-1-kmehltretter@gmail.com>

On Thu, Sep 17, 2026 at 07:56:45AM +0200, Karl Mehltretter wrote:
> 842_DECOMPRESS_KUNIT_TEST selects the decompressor even when no other
> option needs it, including through KUNIT_ALL_TESTS.
> 
> Depend on 842_DECOMPRESS as required by
> Documentation/dev-tools/kunit/style.rst. This also prevents the test from
> promoting a modular decompressor to built-in.
> 
> Fixes: cca072cb1423 ("lib/842: add KUnit tests for the decompressor")
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Closes: https://lore.kernel.org/r/CAMuHMdVcZ5cV4-HrjLYfFKh6UshiVxq5eXCNyp0Z1k_SMAvF5g@mail.gmail.com/
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
> Follow-up to the accepted commit, based on cryptodev-2.6/master.
> 
> Testing: Checked Kconfig dependency resolution for eight x86_64
> configurations before and after the change, including KUNIT_ALL_TESTS
> and modular/built-in combinations.
> 
>  lib/Kconfig.debug | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
