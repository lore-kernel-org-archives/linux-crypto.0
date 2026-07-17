Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1788B3164BB;
	Fri, 17 Jul 2026 08:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784276163; cv=none; b=DC7fVueFJLnMHdwamx8nBT8bIS9ZbTPk3Q5OKrO+rIQ8Iayz2jCtn6/IdksXSnsSX6E64fYGyPY4Vqh2qNYU0k6DWupgm8iRwA+FZmqkeFHwSqWOFjMnyOyafdonLClDkcr0fce6WmhQKh40HfyyCoO+whd3TlJE/emlXjyN8qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784276163; c=relaxed/simple;
	bh=nZV6OtmQpQ6+bpVbh72lZBX2NDa4O5fPs40HhALEybA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ic3HU8lLnROdcrBP1/GRlCBvR+FU4AFe87NdQ4X48hs7wz7hyCg/kC4YBka8XTsUzzKzi7HXIN3zTGigwFaiUy7agUmLfJiV7re44UEd0g+j9r3mfecTSfzaeo0Sn2ul3YvBuu57s37p1yTLXs5soogePCKbzS8ZAATpX7dmydI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=UWuu4YPV; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="UWuu4YPV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=9u6YeJ9ymOritC0+BnINDxv5hOVKF32GEDT66OPMcwI=; 
	b=UWuu4YPV0YhV87y9HSgPQ/4+MOFqwvKEEewEmaCHMI+Iyg0i7de2etlX8uwnethgKTsiUugb7C8
	l1+mtQTNhzvO/LjKaNMixAXkEtL8e03hTwWdIT/gp2kaKTetj6aTinB+O3rM8DXmAa0UXWRJ6NZAD
	N3YM8lxl2vaPr8QKQD92mo3vf56FmwM/7qc3GC0YcfL45YDWTDtSENOCjo8TMPUxpwpRRIWuHgbbQ
	7sfmOK1UMpZqpOgOK6xDpB0XJAgrYCXeJuZXSthCjTHi3jnj5b98qQSVSyneD7m2iQMcp4Z40C+GU
	tp6WTWLk8uniSgwHLArJhQqXH1QWmCY9Z0sg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wkdjc-0000000EO9E-1EoI;
	Fri, 17 Jul 2026 16:15:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Jul 2026 18:15:52 +1000
Date: Fri, 17 Jul 2026 18:15:52 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Manuel Ebner <manuelebner@mailbox.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: fix bracket
Message-ID: <alnkuDG6RSzoWNqw@gondor.apana.org.au>
References: <20260709143837.405758-2-manuelebner@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709143837.405758-2-manuelebner@mailbox.org>

On Thu, Jul 09, 2026 at 04:38:37PM +0200, Manuel Ebner wrote:
> Remove needless ')' from code block.
> 
> Fixes: 3b72c814a8e8 ("crypto: doc - convert crypto API documentation to Sphinx")
> Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
> ---
>  Documentation/crypto/architecture.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
