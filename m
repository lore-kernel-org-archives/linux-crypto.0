Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE0D2472AE;
	Sat,  7 Mar 2026 05:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772861713; cv=none; b=QgERsd1gb9CnuPoa+FLEvhiWVFnAHSFSs9yUnYbKWWjip6h7jnqpIzW9qe5ErGbBMTkyodpn0Plu07yWN/MQSS1HXiFV35cwf9p2tPp043h0Cd4iS0kW6bO9c1fA9YS5P+anf9G1AOtPLkcaN1BDtxw0IfpTH3jeFNNokHoWJV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772861713; c=relaxed/simple;
	bh=GVL6l+D7sBuV+EAvIxGUnDYu9aYEMQG3ud6XiUcFfGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RT2eHGe3GlFn1rSbf4SnqcKoXmUbs93aBkhAk1EJrCIQsKBO9PcxgRgeTR24MaTtR12xTEpVigEbd6hin9nayebx2BM4uFDh+2u6dySUdei/ZH9UhVvbgwv3OYV8D4/XmiVZyIcHaXC+QI2c35ZoVqEFh08JxJ4NTDJnhBH7fTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=eu/JzrcU; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="eu/JzrcU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=hORSsZ0Ksf4M9N5TzUPCj5qHvIphXguMOSDsdNTg9DQ=; 
	b=eu/JzrcUEAUCl1fAMfENg0G0EEQEpyWyAOVwyztQg8il2Z2hXJVnBn70BUzKLdJ/9dpu/YUtia2
	LCwei4Y+1xIOGGuPbCyW69ePn8abl4YBvrGFJV8zj7qB+F4h1jv9DZd/G5/dlTV5A6/U52D9PA7nv
	/rCPIPfO7cOtNOYttFSZN1+1L4DSsAc9kFMY1SYj+wVGbLJrhOXRpiGs7NouuRR98KffJsanyMh/Q
	fKffxroNQtJtTF4Aj3tRX1wx61Id5OSDDkIjqLBu+7IYkjPgpdysn6JARDPMhJBMzJRYoGNax4ATC
	jvPMes7w8xdoZ1P57RSmSX4U5hC7m7apT21A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vykJe-00CJdL-0w;
	Sat, 07 Mar 2026 13:35:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 07 Mar 2026 14:35:06 +0900
Date: Sat, 7 Mar 2026 14:35:06 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 1/3] crypto: ti - Add support for AES-CTR in DTHEv2
 driver
Message-ID: <aau5CsZw3cO0tOeT@gondor.apana.org.au>
References: <20260226125441.3559664-1-t-pratham@ti.com>
 <20260226125441.3559664-2-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226125441.3559664-2-t-pratham@ti.com>

On Thu, Feb 26, 2026 at 06:24:39PM +0530, T Pratham wrote:
> Add support for CTR mode of operation for AES algorithm in the AES
> Engine of the DTHEv2 hardware cryptographic engine.
> 
> Signed-off-by: T Pratham <t-pratham@ti.com>
> ---
>  drivers/crypto/ti/Kconfig         |   1 +
>  drivers/crypto/ti/dthev2-aes.c    | 173 ++++++++++++++++++++++++------
>  drivers/crypto/ti/dthev2-common.c |  19 ++++
>  drivers/crypto/ti/dthev2-common.h |  17 +++
>  4 files changed, 180 insertions(+), 30 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
