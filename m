Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE693DFC86;
	Thu,  8 Oct 2026 07:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791444480; cv=none; b=JGd7isRL/fL9nbLZNyYCB2U1PxleDi0QmNN3RULoO31B+IBhyMZHhhOzRXu1hSQmoxGL+jw7dFMA+awgQSLI3DuDAszmgoZj3VE4OgifxmDokrkacFzAo3Z05ucYKNE7w2M68qTf/l1HU0aMBDVUIBabcPs/v6oAr1fCqQ5KdtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791444480; c=relaxed/simple;
	bh=qBAGobkXEF80EkjGkrrUBJ18fZvzLv7B0XeiwAoe6WY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m8gqLmthkdYIA7X8suTlBwZ4sPXKOLl2WoxZpH9TRyNLwiTR4omsn+iWJUpqUa94xaYrjtNf9U/+dsKsyN4jv00NdnRuiFdY+CnnBweXItVZ4C7voUMcNemUWxqXMohgetTkjciN4svpiztKvVweYoQ/ZkXnimM3QxfudfrvZrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=mwWknI5Y; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="mwWknI5Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=B8ws3EBIy08Up+iiRNHokXFVPHN1FMASSEMGNyDJtng=; 
	b=mwWknI5YzBhXat3JROklBkDyGbfLKybILlVP1dy8NsbPpkavqvLilURbfhwq9Q1dZgOop8fkNwP
	SrifwseTLujxRer9xCofQr2ySUasmx6cpWSYOItkansN1c31jJZiZYzBoFygeQa1CWB5jXpi2+z0J
	RDBGgtn4fmBm+2jBWhsNA/XfI7CnNqqdecZ+EPL5Vv7PKngOHPyBgaZ26Zdiud11+xgvTHHSLpyON
	gzraNKAMyIMEFOFcUsXMIaHQXE4jNbQXTtyWBVfj7pQSLuAztfy//h9+q/NLC7MAfUfribQjl9oDQ
	jom76ZQ0jxCS5gZoMRlC+1HlX64HCiu8YqcQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEiXd-00000001mre-48EU;
	Thu, 08 Oct 2026 15:27:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 18:27:49 +1100
Date: Thu, 8 Oct 2026 18:27:49 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Myeonghun Pak <mhun512@gmail.com>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Lukasz Bartosik <lbartosik@marvell.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Ijae Kim <ae878000@gmail.com>
Subject: Re: [PATCH] crypto: marvell/octeontx - clean up VF resources when
 DOWN fails
Message-ID: <asdF9YJCHv6LQ_me@gondor.apana.org.au>
References: <20261004042634.1130247-1-mhun512@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261004042634.1130247-1-mhun512@gmail.com>

On Sun, Oct 04, 2026 at 12:26:34AM -0400, Myeonghun Pak wrote:
> A failed DOWN mailbox notification makes otx_cptvf_remove() skip all
> local cleanup. The driver core still completes unbind and releases the
> devm-allocated cptvf, leaving the raw IRQ handlers registered with that
> object as their argument. The sysfs group, crypto device-table entry,
> software queues and PCI resources also remain uncleaned.
> 
> Keep the notification error diagnostic, but run the existing local
> cleanup regardless of the PF response. This removes both IRQ handlers
> before killing the tasklet and releasing its resources, as on the
> successful notification path.
> 
> This issue was identified during our ongoing static-analysis research
> while reviewing kernel code.
> 
> Fixes: 10b4f09491bf ("crypto: marvell - add the Virtual Function driver for CPT")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Co-developed-by: Ijae Kim <ae878000@gmail.com>
> Signed-off-by: Ijae Kim <ae878000@gmail.com>
> Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
> ---
>  .../crypto/marvell/octeontx/otx_cptvf_main.c  | 29 +++++++++----------
>  1 file changed, 14 insertions(+), 15 deletions(-)

Please check

https://sashiko.dev/#/patchset/20261004042634.1130247-1-mhun512%40gmail.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
