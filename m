Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69ED51A0BDB
	for <linux-crypto@vger.kernel.org>; Wed, 26 Mar 2025 13:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742994427; cv=none; b=Pvq2zyUZtpp3LNPcsFNuO4D1ZYBRQFPiFPvXF6/HsPH+K2asi3fR1JXBPMQcMnmx42IOmGWYdOwpzZt06M186818/r1G7qgKGgW/v3brluVuMuqrzL1XELQhozRhtc03VH5Z9Xi9fsyCusUL0GbWFNwrknXUJNbgFuv6SLbFFoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742994427; c=relaxed/simple;
	bh=XdA26/EPlIx2cqlacwICwFsoyXO4ceVn0JqdWFLv2WU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bpCdJIjjnFFcxHpFctjjQy4rfnQoKjYcdiVQ+OIHBd6OUezL6rsFztN6VT18UNnZCHF/ed8FQzu3kWybR/v5+xAHSCcYTH3m6e1m0280tQBAvb7MhnUUseRvGeLmjxWRTT/ULKYWIlyQaHZDrrKpP6jhww4Z2W7pxdkcJUEy2L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=RlScOTRl; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="RlScOTRl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6HqVqN+hBfl7eMxMWGyAtquDTebNpx7FfYSm4BjyJ7s=; b=RlScOTRlfscezxvEiNMAo1eCKm
	I26fAjRgispi4325jVldreR3sKQdvYIGr8QwaXeEOUBHkxr4R76Tn/09Cb3UtQdslYwbIr5hTBhxZ
	Qbiue/EYMJzb4jQeFHzYYztZqLmcNXxWy9HloSh8Ai0ZtFGZPjaz/0uqLW0/fYctRGOTqNyCiJbPQ
	scSEk7+RWtNBiBnDp/uSebEHcsHNsvnGL9a39nvagAufCtBs+ROgSuFw9yQ2Fg9NxNkNzeWct/Bcg
	BR89Z7X9ASV0wSnwGmJd6XphzWsoVjbnYlEhPwz9wdG16fw0EkIpSzonb4eRFJ/b3hbCxMFo67311
	IvH9zfug==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1txQTD-00AI1C-0U;
	Wed, 26 Mar 2025 21:07:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Mar 2025 21:06:59 +0800
Date: Wed, 26 Mar 2025 21:06:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Manorit Chawdhry <m-chawdhry@ti.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Megha Dey <megha.dey@linux.intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>, Udit Kumar <u-kumar1@ti.com>,
	Pratham T <t-pratham@ti.com>
Subject: Re: [v2 PATCH] crypto: sa2ul - Use proper helpers to setup request
Message-ID: <Z-P78_9NKGMBFs3s@gondor.apana.org.au>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
 <2620cdada3777a66d3600cd1887cd34245d1e26a.1739674648.git.herbert@gondor.apana.org.au>
 <20250326090035.izxxf3sboom7hvcv@uda0497581-HP>
 <Z-PGEtO8JmyC5xU_@gondor.apana.org.au>
 <20250326100027.trel4le7mpadtaft@uda0497581-HP>
 <Z-PRckWg9Yw1hOVj@gondor.apana.org.au>
 <20250326123120.wjsldcblqhs5e2ta@uda0497581-HP>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326123120.wjsldcblqhs5e2ta@uda0497581-HP>

On Wed, Mar 26, 2025 at 06:01:20PM +0530, Manorit Chawdhry wrote:
>
> Thanks for the fix! Although, it still fails probably due to the
> introduction of multibuffer hash testing in "crypto: testmgr - Add
> multibuffer hash testing" but that we will have to fix for our driver I
> assume.
> 
> [   32.408283] alg: ahash: sha1-sa2ul digest() failed on test vector 0; expected_error=0, actual_error=-22, cfg="random: inplace_two_sglists may_sleep use_digest multibuffer(9/13/uneven) src_divs=[100.0%@+860] key_offset=17"
> [...]
> [   32.885927] alg: ahash: sha512-sa2ul digest() failed on test vector 0; expected_error=0, actual_error=-22, cfg="random: use_digest multibuffer(6/9/uneven) nosimd src_divs=[93.34%@+3634, 6.66%@+16] iv_offset=9 key_offset=70"
> [...]
> [   33.135286] alg: ahash: sha256-sa2ul digest() failed on test vector 0; expected_error=0, actual_error=-22, cfg="random: inplace_two_sglists may_sleep use_digest multibuffer(15/16/uneven) src_divs=[100.0%@alignmask+26] key_offset=1"

There are no other messages?

This means that one of the filler test requests triggered an EINVAL
from your driver.  A filler request in an uneven test can range from
0 to 2 * PAGE_SIZE bytes long.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
