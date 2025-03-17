Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB96221567
	for <linux-crypto@vger.kernel.org>; Mon, 17 Mar 2025 08:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742200610; cv=none; b=EMeQ4L+EoH9STRIhK9r2V9negCe2jy/XOPnyyEHPu6O0EdGZxTghi3H4WMXC1aSzNOMsZyboLtWy2oZK4Um19bvpNXRlK13VLazqA3J4yK7zU9HtqxDe40i/vyGUr6Ru3CMnRTPaaPX1NZWAJKo+a8t6o+jNCBgfFzGZcW9CesQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742200610; c=relaxed/simple;
	bh=BxVYAhS9eESGDnCM7TiKrWMN6vh8pwmbaWl+/kKdNDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SLXY9cikD3b8JVKuuT4FAXjTOlXoiYwEYsuyKwq+JtN7XC382pkJIWErR9lABuo4/Le6UOlru7y7BoUfQvHw2Pf4vEcJKdXlunioL21UjzTQiW9Z2acKWjcthFt1mX4K7FVJpmUAEejpXiLEm04g4c8mKui8lcHT616CfFeu6Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ivmw4DYO; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ivmw4DYO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1JT479yO1qrvrYn72ldGs65inpG7Ho5yif2XAIDKOV0=; b=ivmw4DYOfjx+EOXV3aeZbFYbBs
	ZDGpDEXTB7oW3xTiY2ZlP9LabNlRGlG8wT6AO5wxOqhbjxETmAdViCEr56pBGKR3iJoupq1sRoi9k
	2ocaRBZtSy6CtTljttFDPGblq/uuvLrEElvyZPnwxc0WNxMyMhH3FFKYmup0jwCd9t4HvS2TwBq+M
	CtPIORJzsVSE/TkbLgvVnC59bIGiX7kulPDSHBFmbE9lhwCRrPKKYH38pTJr3SCM8kQhU0/aWPkmN
	TAL5xTn9ydjL7dgc4hUW4VuhAiSjkzKTCib6iIdSNyz0LHSQpiHhJakAjJrF/6ktyPiGrrtYWA5zF
	a8e3UkeQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tu5xj-007Ubv-2G;
	Mon, 17 Mar 2025 16:36:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 17 Mar 2025 16:36:43 +0800
Date: Mon, 17 Mar 2025 16:36:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [v3 PATCH 3/8] crypto: acomp - Move stream management into scomp
 layer
Message-ID: <Z9ffG2tUULLAP8Nc@gondor.apana.org.au>
References: <cover.1741488107.git.herbert@gondor.apana.org.au>
 <25f96a0e0e642e9d1c6014b12b00fd21b9f9c785.1741488107.git.herbert@gondor.apana.org.au>
 <20250316043631.GC117195@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250316043631.GC117195@sol.localdomain>

On Sat, Mar 15, 2025 at 09:36:31PM -0700, Eric Biggers wrote:
>
> either, let alone have a full set of per-CPU buffers.  FWIW, this series makes
> the kernel use an extra 40 MB of memory on my system if I enable
> CONFIG_UBIFS_FS, which seems problematic.

This patch series should resolve the problems for ubifs, assuming
that you don't actually mount anything of course:

https://lore.kernel.org/linux-crypto/cover.1742200161.git.herbert@gondor.apana.org.au/T/#t

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
