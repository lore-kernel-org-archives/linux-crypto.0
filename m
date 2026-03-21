Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE137346FDB;
	Sat, 21 Mar 2026 08:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774082684; cv=none; b=dpk+fP018WsvXL+Z24TIe5r0z4fewP8BHallnQ3QF4HAhbxIiTANTucYx0vJXzEvQ2sIGEYnOdRkzU13azvLZ+1sRDFNhzNo5VV7owFcG9d5jAgtgnbgdrcQCasVdaNZzzm3XwRCEsKEXRM47OlYjdsP7fZJAYcs+FmkvaLSGWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774082684; c=relaxed/simple;
	bh=Ox7PtjAooksMblxTqEknOoRFKB6RJmP1/E3fKgadloE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HUkwL3jmXljKx745OwPH1DHywXkQjSliOv6lp+pbMhiKQtsov8/ZL2WwS1Sh/z6LQ06k2s0nFhiXKfPP+HaJRuEn796czECTNo6Z39fJ07TUNzcvjHA2Ion5reyhdgPqnN4tiAHT5+T6w8kMX2sZTy6XXFy+uU9uRNzkGVfQ9zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=a/vrsT9v; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="a/vrsT9v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=4LcMthmZq2UlHlX6mq9K9qphF3lSZPiu9ZMzjfT2sh4=; 
	b=a/vrsT9vdUQLXygm1cirTW+9bRZwfdp78sKlVP1vf0cdnjGPVpCA5jdGSsAA1YSEt63OW8OY4qU
	DinaaPizuZbswBGt+CYQPgDhtVp63hVW36oxiMbnSOemSDCCxY2P/gfDcrM5uSvK9MfCYreMpy/Vn
	5scqx6K5LzT60oGSAN8TcLurI1QyS9lqii5LAlakroPUWeZFCpR7L7LG4jXbmOqvyPhlSZB2NNAde
	95NJYwcTp5z9WM5cCgSAwsqL6ZOr2Vc3ELxZ98tHafHL4JYCwBim5o0wVCI4vC7vvjeW88tS1oCpy
	t3+zrk1Vzzcw7DkUg5tOS6W9I8lLhhXPks0g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w3rwF-00GJ6M-2S;
	Sat, 21 Mar 2026 16:44:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 21 Mar 2026 17:44:07 +0900
Date: Sat, 21 Mar 2026 17:44:07 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tycho Andersen <tycho@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Kishon Vijay Abraham I <kvijayab@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kim Phillips <kim.phillips@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 7/7] crypto: ccp - Update HV_FIXED page states to
 allow freeing of memory
Message-ID: <ab5aV8_BW5jfUDc3@gondor.apana.org.au>
References: <20260317162157.150842-1-tycho@kernel.org>
 <20260317162157.150842-8-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317162157.150842-8-tycho@kernel.org>

On Tue, Mar 17, 2026 at 10:21:57AM -0600, Tycho Andersen wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> After SNP is disabled, any pages allocated as HV_FIXED can now be freed.
> Update the page state of these pages and the snp_leak_hv_fixed_pages()
> function to free pages on SNP_SHUTDOWN.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> ---
>  drivers/crypto/ccp/sev-dev.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
