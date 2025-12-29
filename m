Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F0C433AD;
	Mon, 29 Dec 2025 00:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766969409; cv=none; b=pKzKNzDqBfSIfctY0pLiTIu/PD5ctsO9okAys7thek8zVInAd6f6g3bHjl1y+EncgSRxYTUcOk6LxutJ/F4SofSRs6i4jGXZ/n8Gy6t+R5MIOq6aMenaBlOR4VBqrfAnejqbEyK62TFbpwWsxYisbk2lDtA+1M9LJPYJlvEobnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766969409; c=relaxed/simple;
	bh=ulHFMW4FhySr4kdOdZ8Aag5g0iwhCz+LCEHw7Y3Zy6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NLD+OXrWMSTAlJ9lwIh4GkYoKzKWdYuYnE35B4dUffaFK1Ac/dVmiAiqwQ5opq3QYchCR2ynS1sw9rqdC9Iiy4ha72v/3pHpL3jvAeTI84WfQUwMP+Zkwdx7n+N3AcLqaoHeAS4RyDZc94r84AYREDYcXDMibiispl83mIOp7H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=a3uT1kbY; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="a3uT1kbY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=0a1yniK35aW6BgLCV9Umo8b/cDTIh0OQGLUjEoKczXc=; 
	b=a3uT1kbYBAfwhHdVJWF7vo+lBRMW/bpvKkBSrSrsqBdMDfSZ3tce/V/H6D9vJi11tWAgmrcEjgT
	L8q3FbVgCUxDkz4ngZxshjOF3EI3vM+E1HGFnr4UomxLSxJIhc05+fiSftRBuBBEbd6IIXPamJeXu
	w16zGKtKCVlXXk1Lk5eZvV6yLC5AYHJWD36ECLBLLo5RPt2jhYg0ujXhuili3gI2e7LHriDky4Z7h
	tpeVZeERy107KLz7imsvSnG7Gc8UMp43KGxPrhCVne9Wor9xGXbTifnhA2D/cZTPjryr3XGc3BnZ8
	pOVzmAHR+BI6JiM6LxMlZjvBr9NrXlVtnxzg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1va1SG-00D0E7-1Z;
	Mon, 29 Dec 2025 08:49:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 29 Dec 2025 08:49:48 +0800
Date: Mon, 29 Dec 2025 08:49:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Kristen Accardi <kristen.c.accardi@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: iaa - Replace sprintf with sysfs_emit in sysfs
 show functions
Message-ID: <aVHQLOxrSn3b7wg6@gondor.apana.org.au>
References: <20251215072351.279432-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215072351.279432-2-thorsten.blum@linux.dev>

On Mon, Dec 15, 2025 at 08:23:52AM +0100, Thorsten Blum wrote:
> Replace sprintf() with sysfs_emit() in verify_compress_show() and
> sync_mode_show(). sysfs_emit() is preferred to format sysfs output as it
> provides better bounds checking.  No functional changes.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/intel/iaa/iaa_crypto_main.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
