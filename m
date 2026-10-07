Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B993F5BFA;
	Wed,  7 Oct 2026 06:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791354357; cv=none; b=HVlMYa8pNsHyB1P1ouMF8qM7t0mKHSHOVOBvV294YNK1IgaxZrH1iHZ8uYqwoZ/cqSiPlQxrSSXQgTqPWSC3FoJQIaRWsJh+sTVU1rIvxF279RAGTdRzD/1PlEn+RmEm5eBLpMFdgD4O9gNW7bwSw5jSy5cO4HMZ1PylM0BT+cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791354357; c=relaxed/simple;
	bh=IHX18+Z8DCxWdJ/mJd1fhwAHjvsQaKKztpdPLqxruYo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=XdTxFC5/KFMHbldjIZl0VyS1txXDj6mj8jp4lbU/5Q3gsvGxjuNRAotP2YKs8xHHkQC/MFIRhn/NuFVcdWIQ8xLuyBD29S5tAUURqaX4+0Vq0Ud8Vao4As+epwSwzSLt57Vi8CgO2tznnkhTQgZkb6yUl3CHIihFxUW+QGtDGWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=QFWTUzwg; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="QFWTUzwg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=ONxxEHM8gGb9JpDSIAVzRshPOv6r6+W1oSBPlfvg+Gc=; b=QFWTUzwgblCuBwXDRCe3VfXeBw
	mUYPUYH5UCS1O3L/hTIYHpLnRKhGC0tYjhNz2uwPhUJqrb11wj4jh8b55b+IcyfIk3iVLBv3hHSGQ
	IEtPIPvfpDNTKz5vENtOWJCU0WA+kyMDgRSiQdaJ2/vvtMzSzxRQW4ZL6WKbz0QTNNz6NsSTgOVn3
	HoACIuVYA1L57C4TyBZGBfYFCC2YZpjfXKtVU/H0T1CJNgC9zEjdEJILUFv/VzSfNy/whzFlmHQGj
	lEu3fx/stuZ1c0lSlCPwDiThS2CB288nH6M6O2MBqeLjDooxU96hyYoO6rtskBAqaog+zFMLm2icv
	+zqA+pDQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEL63-00000001T2D-1ZpX;
	Wed, 07 Oct 2026 14:25:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 07 Oct 2026 17:25:47 +1100
Date: Wed, 7 Oct 2026 17:25:47 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Runyu Xiao <runyu.xiao@seu.edu.cn>
Cc: ansuelsmth@gmail.com, atenart@kernel.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, runyu.xiao@seu.edu.cn,
	jianhao.xu@seu.edu.cn
Subject: Re: [PATCH] crypto: inside-secure: initialize EIP93 state before
 requesting IRQ
Message-ID: <asXl69ABi0_1ZKIJ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930092551.2976763-1-runyu.xiao@seu.edu.cn>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Runyu Xiao <runyu.xiao@seu.edu.cn> wrote:
> devm_request_threaded_irq() can invoke the handler as soon as
> registration starts.  The EIP93 probe currently requests the IRQ
> before allocating the descriptor rings and initializing the tasklet,
> locks, and IDR used by the handler.
> 
> Initialize the software and hardware state, and disable the device
> interrupts, before requesting the IRQ.  The existing interrupt enable
> remains after successful IRQ registration.
> 
> Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
> ---
> drivers/crypto/inside-secure/eip93/eip93-main.c | 12 ++++++------
> 1 file changed, 6 insertions(+), 6 deletions(-)

Please check

https://sashiko.dev/#/patchset/20260930092551.2976763-1-runyu.xiao%40seu.edu.cn

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
