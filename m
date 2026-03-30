Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A85C2C21EE;
	Mon, 30 Mar 2026 09:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774862278; cv=none; b=uhaX4G88PdzEG24L7vu0s3qIQpK8vhqgB+5I+1avPAzyesllEa1r/dBaVHdnUTFR9UdEviORfAxLDXuV7rwDxPW36pQuGnRO6ckiEhgbL2IfXF/jPl55EEKFvdsn4HhjOBcXyAqM8BdKCE4m5TVm1smZ67fbd7fl+nD58o5023c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774862278; c=relaxed/simple;
	bh=eo2F6IByeg7TMJu94lVkFvqCB8Rm1o+fhRKaxK7pK8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZI99hevs7F+3HUl5/ycfEwDSxpCrXppEvJH7qbg6Lfm/iy7eMorDnBNUoR+UStnEagq3seWkh97+ut7nHNA4xbpqvRoTZtCL1Vk4cDbw/GH7D8x8QjSfvwKg3BD1v1HwbOn67FCNoasE0jbo8Pm7X0mWVFuvQwr1VPAxY2yZGYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=pCtl85fV; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="pCtl85fV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=zUwEBaG9uQ3dYUOCSfxdYyIp/VwIgG+fgAgoqoHEw7s=; 
	b=pCtl85fVKvJ4gT8TC0bbHnVsIG4tjKeAj5ZU70JfKTbYx8dNtGB3xzBNhk17ypp8+h3FPZA3x5V
	n+tFi3zI3+U0SjwkmOEu30E5j1SwEcwNSDxlroMzDOOCLPiXyMEFgG99jEtEJgCu2PSza+KIY6zeN
	HU9GKQ00oh8lIgiM3aW8560cW9QkTHJzLGroXkMq4sOI2pkf/dd2p5wd/ih8HO1ZVx+T1PDuiMEwH
	Vkayki76rrjQRJONtCCllWUjfblnHGFlHGXppTcN4vL51EY4o6fITxtGs6Wta1a0eBBD19EmFHcyy
	hwfrPwGKhqNIp2eM1JDdN4wqrt5d127md5/w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w77qc-002Fdh-2B;
	Mon, 30 Mar 2026 16:46:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 30 Mar 2026 17:46:05 +0900
Date: Mon, 30 Mar 2026 17:46:05 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com, linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] crypto: testmgr - Add test vectors for
 authenc(hmac(md5),cbc(aes))
Message-ID: <aco4TfqpfWBZ1UIm@gondor.apana.org.au>
References: <20260303184916.69132-1-olek2@wp.pl>
 <abToanZh-mkEjmJ-@gondor.apana.org.au>
 <c2a3dc2e-8d4a-4a59-ac5a-ca22be705488@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2a3dc2e-8d4a-4a59-ac5a-ca22be705488@wp.pl>

On Fri, Mar 27, 2026 at 06:03:48PM +0100, Aleksander Jan Bajkowski wrote:
>
> Checked the crypto tree, and this patch still isn't applied. I've sent
> multiple test vectors, and you're probably referring to a another patch.
> Should I send it again, or will you accept it as is?
> 
> By the way, that's the last one. As of now, all my routers have the missing
> vectors added :)

Thanks I'll put the patch back into the queue.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
