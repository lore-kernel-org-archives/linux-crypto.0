Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CA717A319;
	Mon,  7 Apr 2025 05:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744003480; cv=none; b=YXLFNQ5AMFxZS3hkMjGsUu6Vz19aPhGi1H5uTK1OeOL9yBYcqNIY3gfEkrccYdIQj7TviNTF9pKhZWuBhhPCQVZDFSFwuIqICoJBBf5MQ1XBuMfTvT2nc+CORTWW4TSXGekX2pSt+Bf5bwKbySGa9+HJJsBMt2tjFmjdufdL4YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744003480; c=relaxed/simple;
	bh=x4/ZECRf2xLTgM64M82wzde//1q1BgFB1l4XoJ8942Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aJCLAVoseTRalhg6fAjNx6gFpWTNLiGtxNDN3nNHMyHOt+1kjgL7gkhK5jP1vc4fS54F7vzMN07mVsMnMpfJydg+f/YKvf7Ld0oGjAGTJDN/vuWVFr0gpo/sQslD+cOcVkWb1wPKbuoB3SnAuHqJeisWdKw9jX7j7vuZI/I9pio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Tle9oFmN; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Tle9oFmN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=F3Zl/p/xSIFkGCwxTRGfCYy96e823i/BGAgVv7utCw8=; b=Tle9oFmNKPrm2mjkiB+hqurC/0
	2IXKRQ3A3McjIQUdB/DNhdjA1yZlcklgU0GI2iGZMQMLPmzKpsn7Mw5S9BkD4mqTrmVISAdSvWNMZ
	L+zcyLWVJdOpWGfaTnovkABHKoUEkJJgGlFRrRDBUkc7dtdT0gaoWLXDjhyVBeJzm7TzcfBHISeis
	+TgHYkgKWmQeAS0EFVs349p8eLDcFvZpxWk5LbKSpW9TWRiFBFYLn9eiDIyhFKnaQs/16e1WC8lv/
	Uc1i0wxvhIvm+7TI9HHSflY9DTup8qX/hWCE2KFCzFF+RI4y15SME9ETsqmjnMKyIPuCs2D3b2Tjh
	mKw3O5jQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1eyI-00DNIp-29;
	Mon, 07 Apr 2025 13:24:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 13:24:34 +0800
Date: Mon, 7 Apr 2025 13:24:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net
Subject: Re: [PATCH 1/2] crypto: omap-aes - use dev_groups to register
 attribute groups
Message-ID: <Z_Nhkv2_86vSS8LD@gondor.apana.org.au>
References: <20250329180122.3668989-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250329180122.3668989-1-ovidiu.panait.oss@gmail.com>

On Sat, Mar 29, 2025 at 08:01:21PM +0200, Ovidiu Panait wrote:
> Instead of manually adding attribute groups, set dev_groups pointer to
> have the driver core do it.
> 
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> ---
>  drivers/crypto/omap-aes.c | 14 ++------------
>  1 file changed, 2 insertions(+), 12 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
