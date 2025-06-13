Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDD72C1596
	for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 09:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749807238; cv=none; b=Rs9narU6x0oP1VlNDrYU4X/JCxzz3CEXFXP1o7JVMFC1TCQZlQQJNi/2+LPUqRC+cOY8eOTPqxpeS48HZSloEEhGQABsTXH9rKvgsbjiOG6+IMssTBnl1QI5nCin7glqhDv+lpsM+m6bWbQIP/B4UPeOFYjRXo/mZNydslIUKX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749807238; c=relaxed/simple;
	bh=1AGC0apQfmplOKkNVT6kMyh0sWwJ0KcaaseA3gWo39M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dqXtUjcaAYusndHO0swke26CVRJpsr74LF54gL3pW39KyFVAE9Yy/DeRgdIA5Kcdx7HLPeQ/t+Gb+pD9RTmGprGg1FMaTpC1TqIs2HeA9D+W3GpEAbORkzDV/OesXx7M4PueV5i/MSPe+FZmAbVx2gf8W8oTpdApnG3CdI9nLiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=QFeKcp0e; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="QFeKcp0e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=eiDldQfPfwzKSr2JntH/XpjfiXohsB4ICRa2zxFfcII=; b=QFeKcp0eCS4GIdoMXFQF3Bv4/a
	uEejWNbLKeqMgkPf/uZk238vC5ZhbzZEBBG23Yz7Lcas+gznphWRols8G45cFQ2PYyMzyoS5HEGbK
	eBBdTogEpkjUqdLa8LywDURyjm7aqGNU8zPXTYf+HyESF+ptRWycpOil7TV/kJcA0jJeiMBgGqBiq
	tPobFZ42ueWHj+c1tDzeeEs9JZx0J7IyHdFrg5BLu7ESUN7dJVirZFM05IxJVG/GfK0Kkc92S1EQV
	zULji5vmumYzXKJ8IRfzY9lLc8e3+LeZ5x8IBjwUUuFQWYpgdDvd2eTG6R6uncoAB+MHBOYqbFQFJ
	Sz4bVoBQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uQ0nD-00Csuh-1R;
	Fri, 13 Jun 2025 17:33:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Jun 2025 17:33:47 +0800
Date: Fri, 13 Jun 2025 17:33:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mario Limonciello <superm1@kernel.org>
Cc: mario.limonciello@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp - Add missing bootloader info reg for pspv6
Message-ID: <aEvwewkxTse78PpN@gondor.apana.org.au>
References: <20250519152107.2713743-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250519152107.2713743-1-superm1@kernel.org>

On Mon, May 19, 2025 at 10:21:01AM -0500, Mario Limonciello wrote:
> From: Mario Limonciello <mario.limonciello@amd.com>
> 
> The bootloader info reg for pspv6 is the same as pspv4 and pspv5.
> 
> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
>  drivers/crypto/ccp/sp-pci.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
