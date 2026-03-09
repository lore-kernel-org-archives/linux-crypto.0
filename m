Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [144.76.133.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA063407599;
	Mon,  9 Mar 2026 17:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.133.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773079198; cv=none; b=AQJjIb2AAH74oGlsM5ppF3e3lb3ZVsru7T5wNMSOFUHFUdTQeDftcKG2maKCmi0b3VY4jD4ICqTx+4YWmpgQZLbwX9Z7NylB5b9RDSMgDu76rTo1YcfeITEcK1aK6gr5ed/Ssyxfxe/0kk0Hp6AG/G02WI0ObtagyuGzzyynHoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773079198; c=relaxed/simple;
	bh=c//TlHLudlYMiJ/hQkbuHxWvTFwDGvZJGJ4BL41BeR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mh2O0QOQHWw5q3pBtVeC8tpx7gN3mr4QrU6uV+0n3eaTwbF5Rrj6ylx1J2FwYyC7eZ3USfaJpl9E/ghAK+ZD+w6RcjJKgfGwNfBBNbvGaR3uZ3q2tejK88kf1B7VT16ZOO+O9tP4C7Ajdps1d8LSl8bNX5LV+cizv3ciUCy/bMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=144.76.133.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by bmailout3.hostsharing.net (Postfix) with ESMTPS id C0B6C2025727;
	Mon, 09 Mar 2026 18:59:46 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 8851A4F38C; Mon,  9 Mar 2026 18:59:46 +0100 (CET)
Date: Mon, 9 Mar 2026 18:59:46 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ignat Korchagin <ignat@linux.win>
Subject: Re: [PATCH] MAINTAINERS: update email address for Ignat Korchagin
Message-ID: <aa8KkkKldYOVNg0A@wunner.de>
References: <20260309173445.71393-1-ignat@cloudflare.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309173445.71393-1-ignat@cloudflare.com>

On Mon, Mar 09, 2026 at 05:34:45PM +0000, Ignat Korchagin wrote:
> Since I'm moving from Cloudflare update my email address in the
> MAINTAINERS file and add an entry to .mailmap so nothing gets lost.
> 
> Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>

Acked-by: Lukas Wunner <lukas@wunner.de>
