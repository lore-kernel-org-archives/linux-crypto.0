Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905DC156F20
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 05:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744003258; cv=none; b=Y0QmRIvPPHe0HZwMKR4vw5t3FaJ1Y1rVo37hXedXmUWmK2AfpFlveBsLh6KBrO5poCNQRaqG/s8lbkat0bfaHjy7HLcI1qgsDLVVsU0j6UakFgWo93h+hYIuLW3chTLX/MM9ahrEkhiOGDXVSZzIT3Yzj3xQT4JdME9wDZJTQdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744003258; c=relaxed/simple;
	bh=XT8UzjDoQqyNO8P/8h1i3MpCaWKkzbPgDu+8Gaonr20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hb64e/m328WqhEyVB8pKXUo7IRohrvuRlOeePfmU4ICKSDVDo3aRVbafNMdFzuiiLmTmh7cV0KdBjpOIDKwWaVGJLs7rCOPzGTLYLlsHtDjnoGi044ziT4+WM6RMOSyI5AA8j6LIcvKWn3HkGrLlpE0z3sbQqFeEA6vVeViFgBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Ds5ueZtT; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Ds5ueZtT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=p8qpq0ivKJBMMdkKCoFETIG3jPXWKlufr5BY/htVWpU=; b=Ds5ueZtTw8dLTTN6J01RvvgJCe
	di7SyLr0MfOl8+3ZNCRpnlz0tjEK7R2O8X67IsgaVbGKSP+TfyH1eLllJwqHKXC8Aexlxw8Jp9htd
	ZxHc+/WViMYNCSe8iskqrmmKQ9pRDOOi2WDmGBVs/5PW6UdraWqdqrhqZwSp7hzaT7v28BJRY/MlL
	PhplkfyqBPLhB9uK5d7fjVt9RkzHxsJmYawbm2rUPVqo1exnWHuLAVLS61ClN3UaftIPMOFG0AsvN
	SbS1vNZewcnqPCLkwEl5hKTdNbfnYwh/WY8s65BZTFkNfloLrXbYMnt8uUCpPaPNeV1f0EfnSxONA
	lcHwIZpQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1eui-00DNHH-2g;
	Mon, 07 Apr 2025 13:20:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 13:20:52 +0800
Date: Mon, 7 Apr 2025 13:20:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, andriy.shevchenko@intel.com,
	qat-linux@intel.com
Subject: Re: [PATCH 0/8] crypto: qat - fix warm reboot
Message-ID: <Z_NgtNf6JL0Cpi97@gondor.apana.org.au>
References: <20250326160116.102699-2-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326160116.102699-2-giovanni.cabiddu@intel.com>

On Wed, Mar 26, 2025 at 03:59:45PM +0000, Giovanni Cabiddu wrote:
> This series of patches addresses the warm reboot problem that affects
> all QAT devices. When a reset is performed using kexec, QAT devices
> fail to recover due to improper shutdown.
> 
> This implement the shutdown() handler, which integrates with the
> reboot notifier list to ensure proper device shutdown during reboots.
> 
> Each patch in this series targets a specific device driver which has a
> different commit id, therefore a different `Fixes` tag.
> 
> Giovanni Cabiddu (8):
>   crypto: qat - add shutdown handler to qat_4xxx
>   crypto: qat - add shutdown handler to qat_420xx
>   crypto: qat - remove redundant prototypes in qat_dh895xcc
>   crypto: qat - add shutdown handler to qat_dh895xcc
>   crypto: qat - remove redundant prototypes in qat_c62x
>   crypto: qat - add shutdown handler to qat_c62x
>   crypto: qat - remove redundant prototypes in qat_c3xxx
>   crypto: qat - add shutdown handler to qat_c3xxx
> 
>  drivers/crypto/intel/qat/qat_420xx/adf_drv.c  |  8 ++++
>  drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   |  8 ++++
>  drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c  | 41 +++++++++++--------
>  drivers/crypto/intel/qat/qat_c62x/adf_drv.c   | 41 +++++++++++--------
>  .../crypto/intel/qat/qat_dh895xcc/adf_drv.c   | 41 +++++++++++--------
>  5 files changed, 85 insertions(+), 54 deletions(-)
> 
> -- 
> 2.48.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
