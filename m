Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495B1287278;
	Thu, 10 Jul 2025 08:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752135529; cv=none; b=tR3qIt4aLzXSWiq5zxjiG1rZOBLpo/B5IUb6DIoyHFj6ZXMRbUDOWqP0BBAPiF/ljHVLCghbSK6RfR/EBQe+qI6yvvGX61HEyout5xK0tcD1q2qnulbjktILPpfb+IdUh4NmKXbToY6J4SkQYpRjmXXqoMyY/jX9/rTSnzO/nxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752135529; c=relaxed/simple;
	bh=5+H4tRa0pcMur5v0gN8WGxrU1edB5quRSK5i24AvtSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e/Vzql3KBr3CUTsYtnLZNk6yLev9TPR+axV3O1kS2ox1UCfVemYK8Qu5n9z4FcU6ymATb+a9AJvY5zd2bIUiJAXWWYI5I/jyFwkhR+zoMyh261A4z/KWk5xzJQg1Feb94YjMsoiVFKXHh4ocxLx17jIYrTx/CFQNc6Be1XLYtPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=KhiHvPQO; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="KhiHvPQO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=A3YuZpPavZ7H5Wm+8AmsuN06CxIlGmCWGMCDS4nNlvg=; b=KhiHvPQOcBLu5R9MvQ/BXEMVaO
	7dsYl4O8M4OGDiMjZop5O1IfDTSptMAS8pN3Qmf9KJ16GmE7qBxl/INTkKYTxQNrWGjIcpHWKcEoa
	C41fIA74StUBt6Tznjn32+KvJb07qds0KNRkUvgFVRikmNC0o1ftmlmVl+9Uxq9EL2zg/3HfSasgT
	dSlMwEkW3bYw66aJjyqNlqmDw/7HcjWzun5yES+p19tfe3geqssZoxyclqIgjtu+Ek+SdLGSvXl7Z
	xRLpe9m7JtpIzbOwiJZiRk5k8qEYwjunFUhhQOrzOwOo9wGQ0/EzvuyCFjguLCQi140LqB9Xk9kJg
	uHRHWGQQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uZmEk-005OvE-2a;
	Thu, 10 Jul 2025 16:18:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Jul 2025 20:18:31 +1200
Date: Thu, 10 Jul 2025 20:18:31 +1200
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>, linux-hardening@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: zstd - replace zero-length array with flexible
 array member
Message-ID: <aG93V-SzidshlBgT@gondor.apana.org.au>
References: <20250703171933.253654-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250703171933.253654-2-thorsten.blum@linux.dev>

On Thu, Jul 03, 2025 at 07:19:34PM +0200, Thorsten Blum wrote:
> Replace the deprecated zero-length array with a modern flexible array
> member in the struct zstd_ctx.
> 
> No functional changes intended.
> 
> Link: https://github.com/KSPP/linux/issues/78
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/zstd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
