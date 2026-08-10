Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9163A960E;
	Mon, 10 Aug 2026 08:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786350930; cv=none; b=uVbA8L7tAZg1mZKJIJHc4e2lttUV6MRt8oGx2jInTGM3DG6AGaFUmYB7jCl79tfyzWOdsL4UW5MYbEiMoPw3XgGDXEjl0tnnycr1ZVyiVIsqNLtwQeCGhWO2O0gwvQlDneMmGT6BxxdpBFuHohUSuWkOOUHWqUzNhQrGv7h+0Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786350930; c=relaxed/simple;
	bh=xr1izviaGrp9hQUvDGFbGy4C6il3g9p7usaIf9lpPgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W7+vMtj5BUrGtOhUVH6oAZT4Ev8f7eQd+acWWaU1uV2/sB51zAZ6b/5M1YoCqa71bBn/Wf1lu7oRP/PcCieHza66lxLumkZyIoWW5I+X7ilU0Ihf7MQlnEE5IDJRUX8DylsoDO6q/W3Hn5m30PIlswsuINS1mB+6YUNoHfnmV+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=P3HYMj/8; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="P3HYMj/8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=B+uc/sepcJFvD631qwlmQBNWSuK8OcmLWiLP2V7L+CM=; 
	b=P3HYMj/8E8GIAcGpAaAjJA1ygYfknX/Py8ZvU2IusLP6zPl2nwq01f1mfpieUyf8dUTkYGga7X9
	mp3zBTLqa/lz3b4tZx8QALulAss0tglt10ud2MFo1fVDnZvLmdeQ7Q8xXprztRLmSCDOPY2cmM8DK
	raninTlwQVs6JsCSWMQFEJyqA9/D8uaNA+ZKP9l6nWttgvVmSVHbEzQqlyU8T0526x6ozUv7TqXwd
	iYQTN/++Oc9SkuytyygRb3qUUnhyNxRGvSlFRXD8vUbb6wD+dja7zoCktMU1YQoqPw5ne940952R/
	HFmAWBZMd/UbG69JQkCpLkA8mZ9veCrPNSHg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wtLTh-00000003WpG-1EKL;
	Mon, 10 Aug 2026 16:35:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 10 Aug 2026 18:35:25 +1000
Date: Mon, 10 Aug 2026 18:35:25 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Bartosz Golaszewski <brgl@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: qce - simplify devm_qce_register_algs
Message-ID: <anmNTRwtIkvc-ls7@gondor.apana.org.au>
References: <20260731102532.742739-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731102532.742739-3-thorsten.blum@linux.dev>

On Fri, Jul 31, 2026 at 12:25:32PM +0200, Thorsten Blum wrote:
> Drop the redundant ret = -ENODEV initialization. Use a while loop and
> reuse the local index variable i on the error path.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/qce/core.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
