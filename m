Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C07EAC6;
	Wed, 11 Jun 2025 02:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749610701; cv=none; b=chmbUX9DeWl6ro3t/i3+x54URxMHZFrM2/RS9IpqUa4gVP+j8g5ez49j4i7MlRfjfb59r4hI/sodpOfjwlvTxsgKjm4yuSi1Yj5fSkplq/3A6ytw9fmDrvyRrrCjgGVjXYnMpcK8LqhXi6xGQLiIf0Mc8TnMGFNyOiHWLLtQymI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749610701; c=relaxed/simple;
	bh=44eaPKq89GU5Ue0BcG1ibIxkJ+osEZ2gCDMAFPdXEVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j+nnrqHpjxo72kyOHBR97AoaJ/C+01IOHlzYBZdCZhx/ZG2LCSv5KJNfhOSblQbcrN7qvfK1QLPcwAYjCyG5FWBera83GpJd4z1nFmHFw7MLTWwf4NKQIxLM4GrF1nW0GQDDv8tUIRwmB6Nf046i+I61yGP90pMFPC33JfmSU3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Bfbd4iEZ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Bfbd4iEZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Fpp8Kr4ftMN0X10bOkCAMCxo7eWm/XkkNLg6p3N79TQ=; b=Bfbd4iEZBOwdTIe9oD9fl9vFIK
	sg055JWYJAABL0wTrgk8tQCynE/7Y/pGDZ9iFa3BldlFX51XkBgiKqx0/oCFXAq5GeGhIGC1G/Xx6
	URX5U/7rkicP0hY4aGGoYU/rhc4uwarMtPxWFYQ46y99wTyPxlcU+3LoO9QZZr3FH90zE3yB8rDoL
	7gbViXpLRcdVZijtMMqFUeyJ/Y3Ug0e3XTC3wXZWHJVSmHkNSnd6ONoR6AtSIGK0Gy/3C8psm57Ew
	FaLMS0Ux/gmHSvIVpj9KWFS7wHoEju2KVwrhbm7RW8vI1qyeXqx0AUEJgLhZiXw855zmJmOK9Q5r4
	fDV3rscw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uPBes-00CF9J-0I;
	Wed, 11 Jun 2025 10:57:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Jun 2025 10:57:46 +0800
Date: Wed, 11 Jun 2025 10:57:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?utf-8?B?4oCcQ2hlbmdaaGVuZ2hhbuKAnQ==?= <chengzhenghan@uniontech.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_crypto: Fix build warnings about export.h
Message-ID: <aEjwqtotEEH8QMHB@gondor.apana.org.au>
References: <20250611025131.22055-1-chengzhenghan@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250611025131.22055-1-chengzhenghan@uniontech.com>

On Wed, Jun 11, 2025 at 10:51:31AM +0800, “ChengZhenghan” wrote:
> From: ChengZhenghan <chengzhenghan@uniontech.com>
> 
> I got some build warnings with W=1:
> arch/x86/coco/sev/core.c:
> arch/x86/crypto/aria_aesni_avx2_glue.c:
>  warning: EXPORT_SYMBOL() is used,
>  but #include <linux/export.h> is missing
> arch/x86/crypto/aria_aesni_avx_glue.c:
>  warning: EXPORT_SYMBOL() is used,
>  but #include <linux/export.h> is missing
> arch/x86/crypto/camellia_aesni_avx_glue.c:
>  warning: EXPORT_SYMBOL() is used,
>  but #include <linux/export.h> is missing
> arch/x86/crypto/camellia_glue.c: warning:
>  EXPORT_SYMBOL() is used,
>  but #include <linux/export.h> is missing
> arch/x86/crypto/curve25519-x86_64.c:
>  warning: EXPORT_SYMBOL() is used,
>  but #include <linux/export.h> is missing
> arch/x86/crypto/serpent_avx_glue.c:
>  warning: EXPORT_SYMBOL() is used,
>  but #include <linux/export.h> is missing
> arch/x86/crypto/sm4_aesni_avx_glue.c:
>  warning: EXPORT_SYMBOL() is used,
>  but #include <linux/export.h> is missing
> arch/x86/crypto/twofish_glue.c:
>  warning: EXPORT_SYMBOL() is used,
>  but #include <linux/export.h> is missing
> arch/x86/crypto/twofish_glue_3way.c:
>  warning: EXPORT_SYMBOL() is used,
>  but #include <linux/export.h> is missing
> so I fixed these build warnings for x86_64.
> 
> Signed-off-by: ChengZhenghan <chengzhenghan@uniontech.com>
> ---
>  arch/x86/crypto/aria_aesni_avx2_glue.c    | 1 +
>  arch/x86/crypto/aria_aesni_avx_glue.c     | 1 +
>  arch/x86/crypto/camellia_aesni_avx_glue.c | 1 +
>  arch/x86/crypto/camellia_glue.c           | 1 +
>  arch/x86/crypto/curve25519-x86_64.c       | 1 +
>  arch/x86/crypto/serpent_avx_glue.c        | 1 +
>  arch/x86/crypto/sm4_aesni_avx_glue.c      | 1 +
>  arch/x86/crypto/twofish_glue.c            | 1 +
>  arch/x86/crypto/twofish_glue_3way.c       | 1 +
>  9 files changed, 9 insertions(+)

module.h always includes export.h so this is not needed at all.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
