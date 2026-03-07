Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBF023EA85;
	Sat,  7 Mar 2026 05:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772861377; cv=none; b=K5yuoKbTFeuzHCLHKUbvyrNYcMBYks6aCjpiHVAIAWiRCspjTIBtujHqE8UhuDlJZO/p5vcLwwxe6XtnoRfClYZCoieSpL2eEweZzsK/nF9aAWcTvEANGOF8RAgHLQyoqdzd5DswrK39L4Q8nYwiRexGHAhwJOGiV0zrP+2Ozkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772861377; c=relaxed/simple;
	bh=mzeoRhurCcVIYbiQKqi3jCwZUxp1/XauRrHJwhTR55s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HIRoav/n1JmrQr5EIMqFBxbVx/GFM+FUSvNJ0WPhq4dc3+40nULPu3PRWxbFvvIfU+6xcekky8fH9cnAPFmdrNYzZZbaxdG2HDh8QeKgJildg5PJdo4r5rxOwYggpMFB55V87UX+aNlEJX+ki9OcJD5T0QpU7T8F21QJ8wuZwoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=FzsgjKbi; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="FzsgjKbi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=sCBY8KwYODV3Iuh+RJpz5hEdhfqTMdBgwqPY5IBrzTw=; 
	b=FzsgjKbiI7RBta4zsOCeIHSP0PbqpV4og6zxeA78Dpi7L5nxRFe4mZgou/+6jW4L52MC7ybFI3D
	HcktvcPDqCJnReuuMcQTPNpHod8Nur6KSi3t2a458V0kJW3Oplj4l9YZqL/ITi7Hay8i+4V4kdX6P
	AKCFvpC4wG8oyFEZGim+A+gv+5GvleCkJN4SGT3UuQBA0X10lSSe89ANmsptN+Ibk6N2LS1MgYkKP
	yzHa+rVW5dJuZ6rU6vsX60NbpfQBTUetz4X+dI3ipZfcyuv6hgAjdDa2Lt0Dl9C0JNWdWXJDQlSWy
	oImPO1n4wER4oDfYXTyhfuBfnMjoRSQPEajA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vykED-00CJXW-17;
	Sat, 07 Mar 2026 13:29:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 07 Mar 2026 14:29:29 +0900
Date: Sat, 7 Mar 2026 14:29:29 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qce - Replace snprintf("%s") with strscpy
Message-ID: <aau3ueHUy6cxljc2@gondor.apana.org.au>
References: <20260223155756.340931-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223155756.340931-1-thorsten.blum@linux.dev>

On Mon, Feb 23, 2026 at 04:57:55PM +0100, Thorsten Blum wrote:
> Replace snprintf("%s", ...) with the faster and more direct strscpy().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/qce/aead.c     | 6 +++---
>  drivers/crypto/qce/sha.c      | 6 +++---
>  drivers/crypto/qce/skcipher.c | 6 +++---
>  3 files changed, 9 insertions(+), 9 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
