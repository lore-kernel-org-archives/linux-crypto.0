Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F170C4749F6;
	Wed, 23 Sep 2026 08:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153615; cv=none; b=coXqCmWVBcuz2UVDoi2m/BiJrcBmRElHI1XpfqytTWLj6+7FSHmc16bStOG3IA9yPf+oWR/zKGjIq5kY6ph9rnve9sODVjt6wAS0zyI5KPwqBXz498N3g+DiOVtpeAhVW9Ck2zcuu/bujpIqbzDp+TwpJOu2zL345/kiPtthniQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153615; c=relaxed/simple;
	bh=d4x95fks/ksgZ99UI5HdZUOoM1FLL3L6X4ZFZSdAQgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dg5EFIgkGWQssLShQhVS4U2re1jsSE/V9vOQ9jivYqdYXHABB02lc6SmVXiKQ1jmObmzRkGHvxAGqYcybN0Ba9pNzKxtOxgQq0EujvT/+PIho6yb3bbbYOQ06DobM2uX45KfPSayYK8Wlg79h16SWy5ZP9blg3nVgj8KC+9qm2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cH1dRhoC; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cH1dRhoC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=T6VklVw6l4oDMxyYHhFZnLLTGnu8s0GnRPXYCv7EAWQ=; 
	b=cH1dRhoCvZp1pbodyT2aD14ZVFg3fg5Wr0p4iIecMGmK+CS2jAERJ4rBX9Wexx1t2Gf25AQ7c0s
	PEoHJjh/z3mpnqUjfOaGgVZqmp+OBuBpLhrxvjSzEHSNG4DPBd0M+l8/ndnBP4SSx0OqB7IGPDsRx
	pzou3E1E4JR1Qkh8A2lktVZ6jEgLyBNkQmU0Y9SBH9Pt3QzWoVDzjpgnsqVoawafqoCgtXo7/AmE0
	1q4eybzYHhKJtA2y7DQk4pJw0ALOX31Q4cTNUyM4mjOy4xzTY0WZ3juVy3wpg93YIx0Gwv6xpGZ6C
	ppBbaYpX7lsHh1vSKZYRTyfWqdIS2IGB+PHw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9IjA-0000000GyIC-3Oh1;
	Wed, 23 Sep 2026 16:53:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 18:53:20 +1000
Date: Wed, 23 Sep 2026 18:53:20 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	"David S . Miller" <davem@davemloft.net>,
	Kees Cook <kees@kernel.org>, Xin Zeng <xin.zeng@intel.com>,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: qat - zero the VF migration state buffer on
 save
Message-ID: <arOTgIPLOW5PsWMT@gondor.apana.org.au>
References: <20260919054934.27322-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260919054934.27322-1-kmehltretter@gmail.com>

On Sat, Sep 19, 2026 at 07:49:34AM +0200, Karl Mehltretter wrote:
> The QAT VF migration state buffer is allocated with kmalloc(), while
> qat_vf_save_state() exposes all state_size bytes to userspace. The state
> manager writes only the serialized sections, leaving the unused tail
> unchanged. The first save can therefore disclose stale heap contents,
> and subsequent saves can disclose data left by an earlier migration.
> 
> Zero the whole buffer before writing the setup data. Once the setup data
> is present, preserve it and zero the remaining state area before each
> state save.
> 
> Fixes: f0bbfc391aa7 ("crypto: qat - implement interface for live migration")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
> Found by review. Compile-tested only; I do not have QAT hardware available.
> 
> Changes since RFC:
> - Drop the RFC tag and mark the patch ready for application.
> - Describe the concrete userspace exposure path and add Cc: stable.
> - No code changes.
> 
> RFC: https://lore.kernel.org/r/20260817042613.19855-1-kmehltretter@gmail.com/
> 
>  drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c | 5 +++++
>  1 file changed, 5 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
