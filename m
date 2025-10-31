Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B29241679;
	Fri, 31 Oct 2025 13:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761918557; cv=none; b=puUdim89aysBapSVqmEVYv3x0vY6PdFXmqHMSQUzDusiIUYufV+eIbOyDZmXO8EZ0KrjbfZLf2KZgwSaK9T9Vak+Gvvx8kc1I9qEQlzTizQZXrAu4RUrjJIdyDq+D6Lz6Ighka8nTzcGvHrgjJB3IsLTuIbR/2O8iERx2LoeGVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761918557; c=relaxed/simple;
	bh=PgrGfdUP5lTvmOkmSaGxCFBfsydNsk1rKlTgyxAEbJY=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eyBd7wU3HO13UAdizi2Ctrmniu0qSPPOoWfNDGmgU3wlvnsBlMJSqSPEX17sz11mEpYQJwsX6Zd69EsAxhUY+s+huhB8+DXsnX4Oay9lIekTOL/ZE/M7+epL4F8JDtoa0SiR85sAypukEEyNbiQ5iCHVFoLMJITKvcneHuufD40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cyj0s3JBjz6L4ws;
	Fri, 31 Oct 2025 21:45:33 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id D81631402E9;
	Fri, 31 Oct 2025 21:49:11 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 31 Oct
 2025 13:49:11 +0000
Date: Fri, 31 Oct 2025 13:49:09 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Ard Biesheuvel <ardb+git@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v4 08/21] lib/crc: Switch ARM and arm64 to 'ksimd'
 scoped guard API
Message-ID: <20251031134909.00006bf3@huawei.com>
In-Reply-To: <20251031103858.529530-31-ardb+git@google.com>
References: <20251031103858.529530-23-ardb+git@google.com>
	<20251031103858.529530-31-ardb+git@google.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 31 Oct 2025 11:39:07 +0100
Ard Biesheuvel <ardb+git@google.com> wrote:

> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Before modifying the prototypes of kernel_neon_begin() and
> kernel_neon_end() to accommodate kernel mode FP/SIMD state buffers
> allocated on the stack, move arm64 to the new 'ksimd' scoped guard API,
> which encapsulates the calls to those functions.
> 
> For symmetry, do the same for 32-bit ARM too.
> 
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  lib/crc/arm/crc-t10dif.h   | 16 +++++-----------
>  lib/crc/arm/crc32.h        | 11 ++++-------
>  lib/crc/arm64/crc-t10dif.h | 16 +++++-----------
>  lib/crc/arm64/crc32.h      | 16 ++++++----------
>  4 files changed, 20 insertions(+), 39 deletions(-)
> 
> diff --git a/lib/crc/arm/crc-t10dif.h b/lib/crc/arm/crc-t10dif.h
> index 63441de5e3f1..aaeeab0defb5 100644
> --- a/lib/crc/arm/crc-t10dif.h
> +++ b/lib/crc/arm/crc-t10dif.h

>  static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
> @@ -20,21 +19,16 @@ asmlinkage void crc_t10dif_pmull8(u16 init_crc, const u8 *buf, size_t len,
>  static inline u16 crc_t10dif_arch(u16 crc, const u8 *data, size_t length)
>  {
>  	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE) {
> -		if (static_branch_likely(&have_pmull)) {
> -			if (likely(may_use_simd())) {
> -				kernel_neon_begin();
> -				crc = crc_t10dif_pmull64(crc, data, length);
> -				kernel_neon_end();
> -				return crc;
> -			}
> +		if (static_branch_likely(&have_pmull) && likely(may_use_simd())) {
> +			scoped_ksimd()
> +				return crc_t10dif_pmull64(crc, data, length);

>  		} else if (length > CRC_T10DIF_PMULL_CHUNK_SIZE &&
>  			   static_branch_likely(&have_neon) &&
>  			   likely(may_use_simd())) {

I briefly thought this was a functional change but it's not because
of may_use_simd() being something that isn't going to change between
the two evaluations.  

Would it hurt at all to pull that up to be
	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && likely(may_use_simd())) {
		if (static_branch_likely(&have_pmull)) {
			scoped_ksimd()
				return crc_t10dif_pmull64(crc, data, length);

 		} else if (length > CRC_T10DIF_PMULL_CHUNK_SIZE &&
 			   static_branch_likely(&have_neon)) {
		...

?

