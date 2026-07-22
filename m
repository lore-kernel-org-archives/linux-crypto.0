Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE4D4749F0;
	Wed, 22 Jul 2026 16:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784736259; cv=none; b=B1wRouuQjxDXalkdJ2UisJ57QELG777tKzGgz3unMT2WE5E+c32R0uCTtG9yFxdgxuuqIKkVxyOJAxibs+rxxpnMDo5MN7XRsyyZQoU+VVt8AU5exTeOKLOp/Yxp9t/V/Pt+5rSd17HsRwAJKua6VOb4Hao3KXeBQK2KHLx+8Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784736259; c=relaxed/simple;
	bh=tO+EVSz50jcI7C9lkh6Ywk8YNxn+AZdu3z+SH1fNyrA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VFN/Nb+u0+rPjHKzeT5PLHAjv5smZi4BJt8nKv6JHzzGxtL5VhacA/fv2xZBsOVE9rsFtQeGJmKIBvf2TgbDP3tN50PKs+KEKfRQYgi+YBURF5DGEUw0HzW4W7jf4t4jPGlV2s8hH+45ayRI2bmlhlHOIXVSWOZUVc15DS1Fk3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=J6ysBfqV; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="J6ysBfqV"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 87AE940E00C4;
	Wed, 22 Jul 2026 16:04:14 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 00Dx1jsHFxic; Wed, 22 Jul 2026 16:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784736243; bh=tKGf5hs9WjodZOx/TkCFr6nU+z/NKF1CSL2qMS7grA4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J6ysBfqVBXYoCSn35EbqGbngVfmhm6wZk85Vuuc2jbjHFosrIAOmJLOrY3uiOR8Uh
	 e+CXC3khafi27Ep/ehrM0jq9mKBTf2WMsIk6v/6PfhtIEEc+x0gOSxC3vScw0yrFdC
	 YOdWgp+OHy8QvZpxtCOYw+pqFo6C0IpV41rWIl0FDjSRR9n7eDMDcGDZvXSdFanlWA
	 eeUN1ASszJR6R8aTnl9U0Ls4OU705AapjvUvUMUz7TlS5MbCthh+6oHsNLmSGABd/V
	 GtKcyEGLwWQlaTX6SgO9vJGRn5AEfWRb8i+0MjKiIwP/0rukUhuEOWBl/wIcfjLnut
	 MaBJmvmRwU0xxObM2JR5lQ8Y+SQdh/7JtCrR+ug7ych1yiO2wExsQ1m0e+YzWkeWRJ
	 lhmCr/zvWOdNWJT0VeZlLN/g48Sxfm3oU9JGFIiJ7TdOa/yXw2I595Zg/0zhgpM6HS
	 MUzS5QTfr2lFEwiic+8TLPiUpsbGboOm2j9/Un+kSKFwJvmRnkAOqp+fDPrMd64NwT
	 NZx3vzaepxZzSsGUiZgBybnUFTqXZ82gvfW8FCN1khAl3LVANKYcd7MNLi9Vkh+tsO
	 VVKMTcTR5FAMCgE2E22A1BJS43ZwUQ9UDGx6YZh+axSOAPpDnX0VtC6QioS2oPAGaY
	 jz2wZjEEjTxXo9KVjDPgawTY=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::2b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 45C7940E00DC;
	Wed, 22 Jul 2026 16:03:51 +0000 (UTC)
Date: Wed, 22 Jul 2026 09:03:47 -0700
From: Borislav Petkov <bp@alien8.de>
To: Eric Biggers <ebiggers@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Michael Roth <michael.roth@amd.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org,
	Carlos =?utf-8?B?TMOzcGV6?= <clopez@suse.de>,
	Alexey Kardashevskiy <aik@amd.com>
Subject: Re: [PATCH 0/3] Remove old AES-GCM library
Message-ID: <20260722160347.GBamDp48Gyb1jYXKTf@fat_crate.local>
References: <20260722025338.33354-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260722025338.33354-1-ebiggers@kernel.org>

On Tue, Jul 21, 2026 at 07:53:35PM -0700, Eric Biggers wrote:
> The old AES-GCM library code is being replaced as part of an overhaul
> that is adding support for all the common AES encryption modes with
> consistent conventions
> (https://lore.kernel.org/linux-crypto/20260715221153.246410-1-ebiggers@kernel.org/).
> 
> The SEV code is the only user of the old API.  Update it to use the new
> API instead.  Then remove the old API.
> 
> This applies to libcrypto-next.  If possible I'd like to take this
> through libcrypto-next for 7.3.  Acks are appreciated.

Fine with me as long as the additionally added AMD folks can verify everything
still works with their SNP guest setups.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
