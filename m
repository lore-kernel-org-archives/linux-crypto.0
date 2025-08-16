Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC204C6E;
	Sat, 16 Aug 2025 08:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755333880; cv=none; b=bi7SsCkJ1G0BQt33dZYtiOBFLheSf38BcfM5CNut5c8/cTxqzS6J4L142N9fdWW0kXv6s1ePyc3ovAbkMnJBMJNKBlvNDDdE2TfiP/SGHjwxxmfe6c4iooTfSXf5Atfx3VU4CU8FNIf/PdFBh50RBboi9y+i+lidLxiMr1O3B88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755333880; c=relaxed/simple;
	bh=verRMrbZXFe+VsIlxfUpPw5b7wNn0cESVc2gQSnLPHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NskSbjT3KMVm9YaoUC4juwqBiwlbDCcoxb5kxZkBeYeNHIM44JMv4pcdhhP200HjjpXA5eLzeagZfo/rn1fPlq4iPoJugJtPKuFY8LUSUoLPshIdCx5/9Gbsihv8fLnWhwczFhxxzIw5KIGOENp9VWl7tJxk9YGqBbPAE0TwmUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=RHOnVL4J; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="RHOnVL4J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rS4K4LFSyVV9u4Lr5r/NAbwVGZRzaf4IaAWZSM7k8qo=; b=RHOnVL4JYMIXTpVtQkAMAvSWPA
	/1GkQwFnqDMKPBJUGIII/FDJ+lIPiDS3V1q+rDXt+20F+IPg6aI0d1lfpV+jKYrnz2HPdi2B18Yt3
	obCj+AMW2OEAj7fiS+szusEdZZk/BqDBzlJqImMrFZnoNTSIZelDoKsNR/bxvgXMxCGBKy2sKUzUm
	5mp0ZwyfGPaHpgNzptZWsIg36nuoAQyP5qdteMN4NTC3Av0Cm/KXj4Nk/c/UiWLPJGnTdWfj39sMT
	iOFUaFPz1PPE7V7Snzv5dE//ZGl4ebAFkkcGj2KbIarX64VGZKQkw3iD3MzMTgPSrTWgki2/stOyo
	lvGdgsBg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1unCHF-00ElwB-1y;
	Sat, 16 Aug 2025 16:44:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 16 Aug 2025 16:44:33 +0800
Date: Sat, 16 Aug 2025 16:44:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harsh Jain <h.jain@amd.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, mounika.botcha@amd.com,
	sarat.chand.savitala@amd.com, mohan.dhanawade@amd.com,
	michal.simek@amd.com, smueller@chronox.de, robh@kernel.org,
	krzk+dt@kernel.org, conor+dt@kernel.org
Subject: Re: [PATCH v4 3/3] crypto: drbg: Export CTR DRBG DF functions
Message-ID: <aKBE8Rc_hlhLUwfK@gondor.apana.org.au>
References: <20250723182110.249547-1-h.jain@amd.com>
 <20250723182110.249547-4-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723182110.249547-4-h.jain@amd.com>

On Wed, Jul 23, 2025 at 11:51:10PM +0530, Harsh Jain wrote:
>
> diff --git a/crypto/df_sp80090a.c b/crypto/df_sp80090a.c
> new file mode 100644
> index 000000000000..bde5139ba163
> --- /dev/null
> +++ b/crypto/df_sp80090a.c
> @@ -0,0 +1,243 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * NIST SP800-90A DRBG derivation function
> + *
> + * Copyright (C) 2014, Stephan Mueller <smueller@chronox.de>
> + */
> +
> +#include <crypto/df_sp80090a.h>
> +#include <crypto/drbg.h>

Please include header files directly rather than relying on indirect
inclusions that can disappear at any time.  You should add these ones
at least:

#include <linux/errno.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/string.h>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
