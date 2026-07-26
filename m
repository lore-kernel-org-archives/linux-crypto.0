Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3C5377EBF;
	Sun, 26 Jul 2026 23:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785110155; cv=none; b=WN37optBMI48iEHldTY2+IfOOMC3+CMyvG0OoS94eG8YOE1gMya5Y8Szn7KuoHiI0OPQoXnC12djeOssoP3w3rGN7ZKGNUWWsqfAWM6bKc1C2si2QDSajRtHRjApB9ciafzKe020uUbkCaUT2xTr/27+w+htvSon6R5xG6bENmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785110155; c=relaxed/simple;
	bh=JEDw1PF17rDVvIAyKv6iNInYYAcYmlSUwKnj6g7J/Xc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NtGEBRmgtYo1JRcU3fVPjDZAK4mIpve+Da5g3iUr5tk31dxm19M4HqeHPxrpFM+pl6EgfCoyxZQ/MtC8zvQjhWji9VnpAmdrlcTljjugdKjHBVEZjsCNttH4ZPRTzsbNE9+isWWM7JjGH4Ee+l0GH7C8Asq2somvLLoUeDsXzps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=LuYnyPPW; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="LuYnyPPW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=vETogFUV84+7z2Vd7ZgM3RAjYEu2R94iRWWjaEIWnUo=; 
	b=LuYnyPPWBz+0v1vQLt0igKHjgLoFQrTb/rHLFM6ftLT3T6welFfAgDuCfA+Y0tz2JvYLFm8gOwW
	4mKI3I+GWBEaNgcTBb609CH5SJPtpdmEtksEBfhU9OHYWktZAZph+55B/spURDHci1bKHke78GMw6
	ab1hfMQ1/mpT0X02VgDi+/Hs7J3JzLd7vac1ClpCmXZ5OJvb8c9JwBPRNaZpbBuYJUaM9GBrzlpAh
	R9kUg4kyr4/oYBfBWpJd1Tlr6HNvR6b5L2PritGx1dbPvIA7hR7ofUOxTQtO0iaMdYHOsab1MuybR
	bErj+BmL7KIuA0b2FS6HB1CneRYd6xlWhbAA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wo8h5-0000000Gyec-3w8J;
	Mon, 27 Jul 2026 07:55:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 27 Jul 2026 09:55:43 +1000
Date: Mon, 27 Jul 2026 09:55:43 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Thomas Richard (TI)" <thomas.richard@bootlin.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	gregory.clement@bootlin.com, richard.genoud@bootlin.com,
	u-kumar1@ti.com, a-kumar2@ti.com
Subject: Re: [PATCH v4] hwrng: core - Stop/start hwrng_fillfn() kthread
 before/after suspend-resume
Message-ID: <amaef-KUBBjOcyMH@gondor.apana.org.au>
References: <20260713-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v4-1-b5fb4c520b05@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v4-1-b5fb4c520b05@bootlin.com>

On Mon, Jul 13, 2026 at 01:25:37PM +0200, Thomas Richard (TI) wrote:
>
> This is the fourth iteration, as requested by Herbert I replaced BUG_ON()
> by lockdep_assert_held().
> ---
> Changes in v4:
> - use lockdep_assert_held() instead of BUG_ON()
> - Link to v3: https://lore.kernel.org/r/20260703-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v3-1-b7165cb9cf38@bootlin.com

https://sashiko.dev/#/patchset/20260713-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v4-1-b5fb4c520b05%40bootlin.com

Sashiko is asking about whether user-space can restart the hwrng
thread via sysfs after you stop it in the notifier.  I know nothing
about suspension so I can't say whether that's possible.  But if
it is possible then you'd need to close the race window with a flag
of some kind.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
