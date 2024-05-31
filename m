Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AFA134402;
	Fri, 31 May 2024 09:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717148287; cv=none; b=kUz+yoZv99L1sgJBEwbApuQ5csp/kwAiJCuYwhf044apldETPjlHXUv8czek+sHdcVQ9t0eBOg9SV+64zXT79FymyvtcWPKetPTfdNn0Ovr8AdqWKulvMDo/qfHEczvcJlkLgjJuIkzFLELWawzH2bj2OL8H7x2PQkbsV2WAFE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717148287; c=relaxed/simple;
	bh=TmJQi0bSiVuBkD2H9lgA70T1zw++y/0cUfaqaDuFVR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NVIDngF/IizFVHxUCXaeTl2n2zTiCX8Jf+KdRxI/0BQa7FucYGRfizR5plbrjfwFQiKKTkSp1TSB6IZRYBd2bRJ9HHQ0f01eDXSSS6mg7MVM6A9ICqu4vlkLfWW7V5A+Db5FR2Hsrs0M9s5wwmVJQucLNcm9etnafLDkjZxj10U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCyhZ-0049sD-1x;
	Fri, 31 May 2024 17:37:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 May 2024 17:37:35 +0800
Date: Fri, 31 May 2024 17:37:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v4 16/71] crypto: x86/poly1305 - Switch to new Intel CPU
 model defines
Message-ID: <ZlmaXyWpH779vJQM@gondor.apana.org.au>
References: <20240424181245.41141-1-tony.luck@intel.com>
 <20240424181458.41462-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240424181458.41462-1-tony.luck@intel.com>

On Wed, Apr 24, 2024 at 11:14:58AM -0700, Tony Luck wrote:
> New CPU #defines encode vendor and family as well as model.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/crypto/poly1305_glue.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Both applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
