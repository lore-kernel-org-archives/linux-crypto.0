Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3090314E2D5;
	Fri, 10 May 2024 09:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715333000; cv=none; b=FOMjIFYWK8UwVcd6Wyf5qXSKMtQA1Jn0R27RGBweilSrR/Xq0cBUmyH4HrUZK2/uu5xUssP+O0E0V7YETHAbDVeaFoHqjqMW3an8MUIhJU2qIWAKF4JcXkr9WpeIKfRUPB7kmPALp3j1qCd0wvWJV+af1p9zfaH+N+Iqhs/9GtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715333000; c=relaxed/simple;
	bh=KiDqBy4DhT46HjwPX0N+O2lERYVvRNrR/RcydeCXD2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yipo781+OHjgvBOtEd32eVd8gJNfpl+shErz0e8vTCIXGBzdzwKAmZEjvumOOocydS9FA79JH5Qd/pIBB5ulwORnKSt/tLgfThlodVT12cnGPiMtLE1hIl67DD+ZCMvwz5CbUaKaojvDXQzQX+K3ckyBBEJ7nTYBNEuaV0UHEPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s5MT5-00DKEU-1k;
	Fri, 10 May 2024 17:23:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 May 2024 17:23:08 +0800
Date: Fri, 10 May 2024 17:23:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: iaa - Use kmemdup() instead of kzalloc() and
 memcpy()
Message-ID: <Zj3nfBKPrvHuWMwl@gondor.apana.org.au>
References: <20240502153338.6945-2-thorsten.blum@toblux.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240502153338.6945-2-thorsten.blum@toblux.com>

On Thu, May 02, 2024 at 05:33:39PM +0200, Thorsten Blum wrote:
> Fixes the following two Coccinelle/coccicheck warnings reported by
> memdup.cocci:
> 
> 	iaa_crypto_main.c:350:19-26: WARNING opportunity for kmemdup
> 	iaa_crypto_main.c:358:18-25: WARNING opportunity for kmemdup
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
> ---
>  drivers/crypto/intel/iaa/iaa_crypto_main.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
