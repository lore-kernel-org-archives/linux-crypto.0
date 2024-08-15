Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6311A4F37
	for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 08:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723711253; cv=none; b=ByTtiU0XbonDNDL0jTT1P2gfcGmoIZ6IyFIe1y0bWB6kKQMgHgl8f5DS4tcVA6yQOMbZ70H+JauAkyY+xQa0kH5TlFN/86vMFQNazPNtiHEiM7BaUZtXgPczx5HDCsKXuAI1xw9SEN/yH9de4ZrX/JibtshIynOOsxVje42GVJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723711253; c=relaxed/simple;
	bh=Xix8flVsJT+jIqHhUutoPBhJnGkYCTJlq84zqWpLJHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AQViFGM9WIWcmeXzC4WdaFteVisrUOzF4CzINq0dpYmoheXCyzwdGcF6N+cuZ5ZWCpo0MorOz+MN3SMD1OG8nemAPKXG7yNciGArlIo901VHd+c81tWwq3RXZAxlVzGUFtabN6YbqMfP3S1WbK9LpZ9JovnhIW5GSYiDqwakSVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1seVto-004oL8-2g;
	Thu, 15 Aug 2024 16:40:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Aug 2024 16:40:45 +0800
Date: Thu, 15 Aug 2024 16:40:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com,
	shwetar <shwetar@vayavyalabs.com>
Subject: Re: [PATCH v7 4/6] Add SPAcc aead support
Message-ID: <Zr2_Dbaa0-qxRtgp@gondor.apana.org.au>
References: <20240729041350.380633-1-pavitrakumarm@vayavyalabs.com>
 <20240729041350.380633-5-pavitrakumarm@vayavyalabs.com>
 <6557f8f8-42d9-4824-af0d-1d327c5972be@stanley.mountain>
 <Zr2-re9H7-5OlUHb@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zr2-re9H7-5OlUHb@gondor.apana.org.au>

On Thu, Aug 15, 2024 at 04:39:09PM +0800, Herbert Xu wrote:
>
> Good catch.  Those RTA_ALIGNs should be removed per the generic
> authenc code.
> 
> The same bug exists in drivers/crypto/marvell/octeontx*, could
> you please send patches for all of these?

In fact they should all be using crypto_authenc_extractkeys.

Let me clean this up.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
