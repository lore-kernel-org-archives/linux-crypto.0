Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554B615D1
	for <linux-crypto@vger.kernel.org>; Sun, 20 Apr 2025 05:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745127996; cv=none; b=rGesYFFhQJLI7v4Ls7zToSmVWHXrU2JEhuc0j1BHqMJh58et7P4Po9ck0j5CcLv/w9cmagJ+LMhlGH3yFCkGWoVyZnOLBuhE3irPTfoXeWdBZjVT1Qper8mXpGl2zkT0WPmld2S7CFDekGT3XG+NJkFUFkiDnfy6SdXNA5q7uRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745127996; c=relaxed/simple;
	bh=daVwUqaYyeoKS6r2GaZZJ/801iswaUvGefACxKzPjpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BheC0dKid1PWk93nmh/YR8g7zxiozp95ejERqCAOynnR2KNgvDtZqF0YldsLhy02xBJTSp4Y7bLrBGQCjCAEgy77+4VY25CNTR9CujFFfY5bqmC3zvGgnToP9OD+vrki3/T8B0+1RUT8INwRZFE7/eNGQZsGLgRAa7RqTD8hqKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.95.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id A912A2C4C0DD;
	Sun, 20 Apr 2025 07:46:10 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 149F34AA2A; Sun, 20 Apr 2025 07:46:24 +0200 (CEST)
Date: Sun, 20 Apr 2025 07:46:24 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ignat Korchagin <ignat@cloudflare.com>
Subject: Re: [PATCH] crypto: public_key - Make sig/tfm local to if clause in
 software_key_query
Message-ID: <aASKMEe53YQvqiS9@wunner.de>
References: <Z_9gygoIHTH7A9Ma@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_9gygoIHTH7A9Ma@gondor.apana.org.au>

On Wed, Apr 16, 2025 at 03:48:26PM +0800, Herbert Xu wrote:
> The recent code changes in this function triggered a false-positive
> maybe-uninitialized warning in software_key_query.  Rearrange the
> code by moving the sig/tfm variables into the if clause where they
> are actually used.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Hm, I've tried to reproduce the warning with W=1 and W=2 to no avail
(with gcc 14).  How did you trigger it?

FWIW,
Reviewed-by: Lukas Wunner <lukas@wunner.de>

I suppose this may have been introduced by 63ba4d67594a ("KEYS:
asymmetric: Use new crypto interface without scatterlists").

Thanks,

Lukas
