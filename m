Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5E71C8638;
	Wed, 16 Apr 2025 07:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744790226; cv=none; b=p7wZUGIWxsYzcZsoO2aSrVLPQ9zDqGMqUsRZ6xRLmcYzIcy1uKAP9WvIWxURyyWr/Q8Dwmt5z+tGOIh6I9flpNDwt2VYzg2d1FhS2xOf+YTrR//ck0Ir/FbiubcEnenoXQrB4hsGn7WslDSbsDhTqhE0bZgBzBtkJ8hFJ5UXGDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744790226; c=relaxed/simple;
	bh=n3RJjrNd1boYjFfJaN+p5hOEKO1Eho9ozwnDAb3h6G0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iii4uwUavHflAXE4p6vQRBJgQRUkFzUxdRBKKLNbyC3muTKqZtGLFaa/A6jlsiU6VxZqeJh3SfyVWAwbc2tlwKnc2IvvnJTY4D/V9/pJ4XtwaaCtNI7bJBDl4GiKVbCvm/n+VkfqPR9f8NAzrbKEuVjOmLVXr1/gZPhgrho5tGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=BnuGLxp5; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="BnuGLxp5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=y1/HgQhpMhG46vKfrbdW1mh6xcFvDgbpxkux0vEqbH4=; b=BnuGLxp5l+EG2yhtim0TpxMzmI
	V+30L2bHnkk0OB3/zBn4E9jmAIXmwZHhpYDOYZOoMIJ0tm9FZl6CtkNRF6VXXS9cUpPtRqdDFQzMW
	c+E1+MyJJnZJoW2/CxcNuhUMAwcMUmG0P1YQoaR+haPVNs/beOBtZJI2sswdxJNb6HeeJIyUYqOr2
	VnqGSdvXAu0DFLGuVk2281fONU/WR5tV/vfFi5SHVm2IZZiEkxNnF62KQ3LbkQPwHJv96WrJSmVB1
	oCtMzDUIoCJZMk7JipJQbUn+bXUqZMBcJuopZFg0nO/KNZfy5tEd5ijeqVdhcIjE2kA/U9cnQRmGM
	vlUpRl/g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4xdi-00G7rj-0z;
	Wed, 16 Apr 2025 15:56:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 15:56:58 +0800
Date: Wed, 16 Apr 2025 15:56:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: essiv - Remove unnecessary strscpy() size
 argument
Message-ID: <Z_9iyjGZOC4gJNFl@gondor.apana.org.au>
References: <20250408112300.804656-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250408112300.804656-1-thorsten.blum@linux.dev>

On Tue, Apr 08, 2025 at 01:22:59PM +0200, Thorsten Blum wrote:
> If the destination buffer has a fixed length, strscpy() automatically
> determines its size using sizeof() when the argument is omitted. This
> makes the explicit size argument unnecessary - remove it.
> 
> No functional changes intended.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/essiv.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
