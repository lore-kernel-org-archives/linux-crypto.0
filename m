Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC833CB2DB;
	Thu, 30 Jul 2026 07:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397258; cv=none; b=oBRCj19HyF87O7ZdYWBCys6CHOD0WWqaGRf7YHdgxzRwKuVSoGdKJQSKAefb4+v2sx+y7kLo3nLqRx6CWMMnodpyNy+k5VOVt5ywFf6Fp6raEGhkiXtjQoWDsrCSZ+MTuEFFmUVGYW193AdH7x3sIp5sr9EvdyWecRtyAIq2kN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397258; c=relaxed/simple;
	bh=niXpPz+O+rFBU0ZqC8R8+pefNBTZLkkfhJak92xmupo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fuVf8nzJHKI5mo7BQZBRovQgYwqltoiAEpkBsOyU4BPM//kiAw3koPwSlBo45eZJXVnpbz8JMqBrNZ0Dw6tzAAsPsUzHzqZ+58GeIlwetRQxKXQJK8S0sHtyrooCl+PA0WD5iDgePg9MK13M0l5p9hoEhNKJORpvDcGTa1TaNjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=rELAq5Rv; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="rELAq5Rv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=T/dj+SBEOz2D/GEzX9oc0frf6GsJOn47YuTXych8hyc=; 
	b=rELAq5RvqAPyD+Dmf2Qk3sXIxgvatowLyvPjUxMRTnbuiOx58qtPEXdPPxglnMzXWQsTZTrfH0k
	UytJju+W3Ud9Lh+bVB19FRkAMjdQYrBV1bTVZh5qlAvAVjiVSZKyqKge7QWLUrL7i3lvSp42mz3S6
	3the+dxy/7khDaUD+klGpu/dTSXQeptwJQ5KIVVI7944PRIa+iGdrPv9wU/1iyMzJAuomsdIi7ygP
	CtfUh2g3ll1JDDekvmRUx+mVCi1Si6u2iLvWIWXz+URifNwUS3qleLmqvm0dXLBNS4mWeCRSo6EeB
	Nf9IcVKQxE//CFJHMDXwkWNFB7lGFKIPdtPA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wpLNs-00000000Rxv-3vl8;
	Thu, 30 Jul 2026 15:40:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jul 2026 17:40:52 +1000
Date: Thu, 30 Jul 2026 17:40:52 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Bartosz Golaszewski <brgl@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qce - drop redundant variable in
 qce_skcipher_done
Message-ID: <amsABDcvu24i6lkv@gondor.apana.org.au>
References: <20260720232716.118402-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720232716.118402-3-thorsten.blum@linux.dev>

On Tue, Jul 21, 2026 at 01:27:17AM +0200, Thorsten Blum wrote:
> Remove the local ret variable and return the result directly.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/qce/skcipher.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
