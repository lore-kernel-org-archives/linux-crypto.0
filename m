Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA63923FC4C;
	Sat, 20 Sep 2025 12:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758371123; cv=none; b=HSx7GPf0eqw3xKEL1MLXib20S2XGmfcF3ZRzqNZz2EJBdPh8OxQOz7CEvn2cNeeu6ZqXOECYqnBFPGJ6DJjRgVYPL52tbnH2TqIu7k8aE00uLky/KiCH/2O/NEQs8m5HDX//XKb6zQ3KTw7vXGdGivz3rt8wMUhsTHq2M2MV62M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758371123; c=relaxed/simple;
	bh=O0LzlfWlPKjac7rDzW1wwLaYZ0d+D13hoP7xznHzlAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W/2sAieieAl2YlcHQ826zqkbM9v/4sAmVmYl8TTZXcxM6xQUTm+E96vuYw8m3GHcyejKvuESeedovJEVb27TmAfhblmo+DAxyfV3Q+CFGec5EWcmQkvlHbeXJWWbgirPitZ6mkpp4ya7Dgbk29Cdxc/sXEDpw545WGc3Cca1wuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=PHbvd1YC; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="PHbvd1YC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:MIME-Version:References:Message-ID:Subject:Cc:To:
	From:Date:cc:to:subject:message-id:date:from:reply-to;
	bh=1myR8utxz5y2QrmTAMsmbMQb8k6SiWfZd1R0kHbUaz8=; b=PHbvd1YC/SFRm5EPm9fhNueBnY
	J4XiUdRXcpiekickix/UjqPKwTPBKMiIqTbZERQ5ob8UXGe0EEeakC7/6qaCAzkSncok7WGQW8MVn
	qxKR/wU1e2ZHpVSHvYiCSg8PX8ENCD3C594naSBpNbW1XjU969zOnRdDl6uhsGuABfDmDDqRC169K
	bwTnFtI/Lte77HcdP9ML3R6YQrAdmQIjrXVUT6XSDCwUs59Ix/N+N2s+2hcBIqtCr8DsB1mNAkgJ5
	oX/ySoQp3q6mo2+JbBZ4Q548+0xiZkFCaAWgKGm7VAW3OvHzRKFZ/S+1svfT6eWdk1VxWIMSgp/Ye
	Xf1c9miQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uzweQ-00705v-2x;
	Sat, 20 Sep 2025 20:25:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 20 Sep 2025 20:25:14 +0800
Date: Sat, 20 Sep 2025 20:25:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: anubis - simplify return statement in
 anubis_mod_init
Message-ID: <aM6dKn2_qZc9LeMG@gondor.apana.org.au>
References: <20250914142554.1917199-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250914142554.1917199-2-thorsten.blum@linux.dev>

On Sun, Sep 14, 2025 at 04:25:55PM +0200, Thorsten Blum wrote:
> Return the result of calling crypto_register_alg() directly and remove
> the local return variable.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/anubis.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
