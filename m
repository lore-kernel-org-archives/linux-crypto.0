Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE523B2FCC;
	Tue,  5 May 2026 05:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777959250; cv=none; b=rQtMMRnecG8vx+r6AdPJbpBTPQ8qlrAOpoweVEKXEIDDUYlk0zQ0YWE+OZktBCSkfrpTw/kJjIig3Kj2VFeshMlHpVDEglhpEp2vToVefZTpf5Z07zyXXGuszYl0BVe+JRsIRvDVnkHs2Dg7cTCHxzShCKvWoR+6MqzhVMta++g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777959250; c=relaxed/simple;
	bh=SgD0sbxmJkxk063EDpeWAgwvCybKLAiSda4Z36o+fJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DK9sP5rxCBrBjXJnqfIm9pM2IVk5UhajaHLTQGIAwuo0hVwjzYCUST4KsLoWdlliIC2CCCaywL12w/CAMMDZpLJJAm/4CvUNEY/N2X/ZhfQ4vf2aL59BDWppOaNfQQAMfnpJZjJjiO3m7xpfBgzPTw5uJ3tqWyOpZ7ia3atjrx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=YS1Yspqc; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="YS1Yspqc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=AfnUNetPugawbZx5ZF2U9vOuyACvllb7nbme+lljnGg=; 
	b=YS1YspqcYaCJNeZzbWWzQ3+1GBUtxV8eoDywcZvHhKzsvuS5Jv8Bpcmd7IqmG8yvNhgs5KdJ7YP
	pmhwW5Uvau259DfabDYMQBQq/5rlVvScFRxubbiK3XZrsXy3rfA5jqvFZ5hXl8om8Qwj2GwQmG+z3
	DdJCYDDbhV+EnGRt0GOY0irIVCvv8I9HWaUUX5nIQXjMJG+LKYn12ZJo7wfQmEzroLVflAMM9HWTE
	N/mOS0LvibXGZq9mFj9c8ueeaB7f4orDe+0d4qCv1ZNUBXACOZDTXzGBVeX1tnnOnJ6eVjTT6P/3e
	4kVDfxadBuvYPJJ02BYb6JflK0fS/HAMRUqw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wK8Ps-00BKSI-1Q;
	Tue, 05 May 2026 13:33:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 13:33:56 +0800
Date: Tue, 5 May 2026 13:33:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Olivia Mackall <olivia@selenic.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] hwrng: core - use MAX to simplify RNG_BUFFER_SIZE
Message-ID: <afmBRDCDqwJW_Ttg@gondor.apana.org.au>
References: <20260430110047.248825-5-thorsten.blum@linux.dev>
 <20260430110047.248825-7-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430110047.248825-7-thorsten.blum@linux.dev>

On Thu, Apr 30, 2026 at 01:00:50PM +0200, Thorsten Blum wrote:
> Replace the open-coded variant with MAX().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/char/hw_random/core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index 905a63525831..f8f7a2ee73c1 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -17,6 +17,7 @@
>  #include <linux/hw_random.h>
>  #include <linux/kernel.h>
>  #include <linux/kthread.h>
> +#include <linux/minmax.h>

No need for minmax.h because kernel.h already includes it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
