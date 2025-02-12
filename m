Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746A31DB12C;
	Wed, 12 Feb 2025 05:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739338163; cv=none; b=Sh6xP7AitRgYhsOdxkgbxh4ue/pqvBjd+rPFaaFa/S5tsFz6lr9L/67KWiICI9aSpc5BkC/DMrxlaJGwPCDL3HAUN+ySsJqUoxzdKAiPEKDoZpMAAfd4DqOdaRnV51FlGRViRk7tlyeqCkp2gg0dBZtm+9fwk/cXBG8SxtamPGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739338163; c=relaxed/simple;
	bh=uHt5b0GqbNG1UkOEMtB9etZTVhbcO1v3CJE/EQlRy20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LT/RoRX3TnYegvBQ4W3MyrhktURrLbnFbbkUEnZUv1WtrrsjSeLnQ9Bv5MoULAjvoXG03t8bfl6SIH+NC2gC916NXjCHaiIwK6FU6VJKsFCiZmYC6GXR52KD9j0gOy46T+TYtfmFjTTb1u4vhf7FPxjQQmYJjECB/UCaguZ/Z1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=VRYKAEcQ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="VRYKAEcQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YwQu72M7gw/MHwCE/46tLUOeyJYtz49nwSEpIt3H+kM=; b=VRYKAEcQjKVI1Fs9OjVQhq+HSM
	oUCMqUaiR9L8nCQ+D9avvGX6vk2BSKTzMyYTss49GfVMS9Obq2mAzElLyqQoySFcYYf2QhOAkFkjY
	w9PQ9ptefaMm/iDlJSP4VQxlgxKjsU1EA68nzsQBlG4NrCsiIRNA20mPQyVCNBgIVTvRMKOdWytWp
	NZ339RiY8iVoh2Pg6mT1IVDueltQpIwcG9wqJC+DUAIppcfXauxVw/Fnmtfw1Im5LzCUvVqe89WsF
	5eB0lfV0oEconYOO5vUt8E86RxDFlTabfen1zJYKjmU+6uhdzinS9/uLUKcgeThvXLUPofyqmryOn
	vf3ScslQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ti56E-00HEDZ-1P;
	Wed, 12 Feb 2025 13:29:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 12 Feb 2025 13:29:11 +0800
Date: Wed, 12 Feb 2025 13:29:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: kernel test robot <lkp@intel.com>, Danny Tsen <dtsen@linux.ibm.com>,
	oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: lib/Kconfig - Fix lib built-in failure when arch
 is modular
Message-ID: <Z6wxp7UE9MAht4pc@gondor.apana.org.au>
References: <202501230223.ikroNDr1-lkp@intel.com>
 <Z6woN4vgdaywOZxm@gondor.apana.org.au>
 <20250212050936.GB2010357@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250212050936.GB2010357@google.com>

On Wed, Feb 12, 2025 at 05:09:36AM +0000, Eric Biggers wrote:
>
> Please name these like ARCH_HAS_CURVE25519 and CRYPTO_LIB_CURVE25519_ARCH to be
> consistent with the CRC library, the many other ARCH_HAS_* options, and
> CRYPTO_LIB_CURVE25519_GENERIC.  Nothing uses names that contain "MAY_HAVE",
> which is ambiguous.
> 
> FWIW, at some point the arch optimized crypto algorithms also need to just be
> enabled by default.  The fact that they're not is a longstanding bug that is
> really harmful to users and needs to be fixed.

I'm simply responding to an lkp report.  While your suggestions
may have merit, I don't have the time to pursue them.

Feel free to send patches if you wish.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
