Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A490F1922FD;
	Thu, 26 Mar 2026 04:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774497915; cv=none; b=hHUAZM9MBrjgX17vXm1aLrYKv0IuUbi7i23GSZRnNhWyKxmoE4ZwgQTS+p1TgFfRCInUsvoXpvvvy9DKe/gh1TtLQKg6EO8AH63d3rLDymvae5t94AbJFoAReXcoTXb+dJLgpDB12xQoM9hKVyEOB0gsKPXOTAewsFSEZuIoEEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774497915; c=relaxed/simple;
	bh=aqxq4IGli6X5Yxdqxf9nSbnR+MpccJMejMEKQbl4+30=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YizPyvOLeTHrhCydS2LB2nZV21X+cZLrF26GcMerQIj3leLABGod9G+OBR/ChxpFXGkn4zIaTlPEC2f89XUqDNBTK+gcEliWYkRiEChPmCdi+CcrS/f5eq9pWETPQ2IDAG5fsmzfgDH/94D91YXO/5BKjtvWl9+8QloCtGs5QwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=gDpW763M; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="gDpW763M"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PISkgW2125466;
	Wed, 25 Mar 2026 21:04:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pfpt0220; bh=hxDtg18exr/Y+8aeNhxNFeZgi
	slnD7iao7812bSxF5g=; b=gDpW763MOPi4iMCVpmUc3TDtZiAVQKC9I9PPSicN2
	w0wdWfAcWyCHkfso65Bsy9UePqbX6VZ8uRKJqumaCp2lPv3DBHLCHMuxgP3/hDJs
	maWzwf5ac6BlBjJP+wyPI0F3fZHIRKbr5mwmIwtfpVBTzyJfkmglcwoS0S3NCwFK
	yMHEHjrlK+yvcLf9huokLh5pV9cYYGEV9tpYtP0ww/J02yQSktIRtNwa5fWUvsif
	0I1RFYQ4d33MFiyp4RUhVKMF1Ac1zLqgxQeRckcSz8jhDORrGU6Jd2FgqRM4JU5K
	v6gidivNCSLNFUBDpxODafBdWUZg3Zf8pF4gdYx9/64CA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4d47nabbd3-11
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 21:04:57 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Mar 2026 21:04:49 -0700
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Mar 2026 11:08:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 25 Mar 2026 11:08:38 -0700
Received: from kernel-ep2 (unknown [10.29.36.53])
	by maili.marvell.com (Postfix) with SMTP id 5EEB53F7055;
	Wed, 25 Mar 2026 11:08:34 -0700 (PDT)
Date: Wed, 25 Mar 2026 23:38:33 +0530
From: Subbaraya Sundeep <sbhatta@marvell.com>
To: Eric Biggers <ebiggers@kernel.org>
CC: <netdev@vger.kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
        "David S .
 Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Sunil Goutham
	<sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>, hariprasad
	<hkelam@marvell.com>,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Sabrina Dubroca
	<sd@queasysnail.net>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] octeontx2-pf: macsec: Use AES library instead
 of ecb(aes) skcipher
Message-ID: <20260325180833.GA1270525@kernel-ep2>
References: <20260321225208.64508-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260321225208.64508-1-ebiggers@kernel.org>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI2MDAyOCBTYWx0ZWRfX5gjiLGzlsXOt
 8TIJlWHf4t5/c7uWtj6lnHoXXcMUopuZCRR/kvZwVgmpKeXCl61sVu/yBoFi2bA9YHOTO7GAKTF
 G5inTLjB74obKDpDMz8lflYDbFU/uJKFuoJJYujGZHu/R9vH1c6uKu/WkzLqp6x4fO1TAjS7sxU
 F7REGshHUCgBEm/s3Zw90ie8G3ICCd5XHmhCMppJWEhW0jc/eNJi+vifJajOGgrrzq1mN4qf1gJ
 5ldofpY2CYrkMoqgLSuefonpjAF402bW3MkYODPBeO159Kkl5FPKnlm0BKpVtLNomCMHxop1+nf
 zQ3IBCTfaRJQusuGJtStLxm/Nz6BneIRooLv+I1inKtM23WbYjLs8tp2AqSSXpOo8Hs4UUuXFoK
 GPx9f+gwuLHge8IjTbbFd5vjH8U7embO7V0P+O5gRUzUO2yx3JXqRqdA+4PH54SudmvjSe8EtB8
 F5j3KV2EyOYY0MUBf9g==
X-Authority-Analysis: v=2.4 cv=LsifC3dc c=1 sm=1 tr=0 ts=69c4b069 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=l0iWHRpgs5sLHlkKQ1IR:22 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8
 a=M5GUcnROAAAA:8 a=x027Qmh1OypKTmINcz0A:9 a=CjuIK1q_8ugA:10
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: It4zsH2TmcFebMh6oPixZN9RlcMZnanF
X-Proofpoint-GUID: It4zsH2TmcFebMh6oPixZN9RlcMZnanF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_01,2026-03-24_01,2025-10-01_01

On 2026-03-22 at 04:22:08, Eric Biggers (ebiggers@kernel.org) wrote:
> cn10k_ecb_aes_encrypt() just encrypts a single block with AES.  That is
> much more easily and efficiently done with the AES library than
> crypto_skcipher.  Use the AES library instead.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>

Thanks,
Sundeep

> ---
>  .../net/ethernet/marvell/octeontx2/Kconfig    |  1 +
>  .../marvell/octeontx2/nic/cn10k_macsec.c      | 53 +++++--------------
>  2 files changed, 13 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/Kconfig b/drivers/net/ethernet/marvell/octeontx2/Kconfig
> index 35c4f5f64f58..47e549c581f0 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/Kconfig
> +++ b/drivers/net/ethernet/marvell/octeontx2/Kconfig
> @@ -31,10 +31,11 @@ config NDC_DIS_DYNAMIC_CACHING
>  config OCTEONTX2_PF
>  	tristate "Marvell OcteonTX2 NIC Physical Function driver"
>  	select OCTEONTX2_MBOX
>  	select NET_DEVLINK
>  	select PAGE_POOL
> +	select CRYPTO_LIB_AES if MACSEC
>  	depends on (64BIT && COMPILE_TEST) || ARM64
>  	select DIMLIB
>  	depends on PCI
>  	depends on PTP_1588_CLOCK_OPTIONAL
>  	depends on MACSEC || !MACSEC
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
> index 4649996dc7da..2cc1bdfd9b2e 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
> @@ -2,11 +2,11 @@
>  /* Marvell MACSEC hardware offload driver
>   *
>   * Copyright (C) 2022 Marvell.
>   */
>  
> -#include <crypto/skcipher.h>
> +#include <crypto/aes.h>
>  #include <linux/rtnetlink.h>
>  #include <linux/bitfield.h>
>  #include "otx2_common.h"
>  
>  #define MCS_TCAM0_MAC_DA_MASK		GENMASK_ULL(47, 0)
> @@ -44,55 +44,26 @@
>  #define MCS_TCI_C			0x04 /* changed text */
>  
>  #define CN10K_MAX_HASH_LEN		16
>  #define CN10K_MAX_SAK_LEN		32
>  
> -static int cn10k_ecb_aes_encrypt(struct otx2_nic *pfvf, u8 *sak,
> -				 u16 sak_len, u8 *hash)
> +static int cn10k_ecb_aes_encrypt(struct otx2_nic *pfvf, const u8 *sak,
> +				 u16 sak_len, u8 hash[CN10K_MAX_HASH_LEN])
>  {
> -	u8 data[CN10K_MAX_HASH_LEN] = { 0 };
> -	struct skcipher_request *req = NULL;
> -	struct scatterlist sg_src, sg_dst;
> -	struct crypto_skcipher *tfm;
> -	DECLARE_CRYPTO_WAIT(wait);
> -	int err;
> -
> -	tfm = crypto_alloc_skcipher("ecb(aes)", 0, 0);
> -	if (IS_ERR(tfm)) {
> -		dev_err(pfvf->dev, "failed to allocate transform for ecb-aes\n");
> -		return PTR_ERR(tfm);
> -	}
> -
> -	req = skcipher_request_alloc(tfm, GFP_KERNEL);
> -	if (!req) {
> -		dev_err(pfvf->dev, "failed to allocate request for skcipher\n");
> -		err = -ENOMEM;
> -		goto free_tfm;
> -	}
> +	static const u8 zeroes[CN10K_MAX_HASH_LEN];
> +	struct aes_enckey aes;
>  
> -	err = crypto_skcipher_setkey(tfm, sak, sak_len);
> -	if (err) {
> -		dev_err(pfvf->dev, "failed to set key for skcipher\n");
> -		goto free_req;
> +	if (aes_prepareenckey(&aes, sak, sak_len) != 0) {
> +		dev_err(pfvf->dev, "invalid AES key length: %d\n", sak_len);
> +		return -EINVAL;
>  	}
>  
> -	/* build sg list */
> -	sg_init_one(&sg_src, data, CN10K_MAX_HASH_LEN);
> -	sg_init_one(&sg_dst, hash, CN10K_MAX_HASH_LEN);
> -
> -	skcipher_request_set_callback(req, 0, crypto_req_done, &wait);
> -	skcipher_request_set_crypt(req, &sg_src, &sg_dst,
> -				   CN10K_MAX_HASH_LEN, NULL);
> +	static_assert(CN10K_MAX_HASH_LEN == AES_BLOCK_SIZE);
> +	aes_encrypt(&aes, hash, zeroes);
>  
> -	err = crypto_skcipher_encrypt(req);
> -	err = crypto_wait_req(err, &wait);
> -
> -free_req:
> -	skcipher_request_free(req);
> -free_tfm:
> -	crypto_free_skcipher(tfm);
> -	return err;
> +	memzero_explicit(&aes, sizeof(aes));
> +	return 0;
>  }
>  
>  static struct cn10k_mcs_txsc *cn10k_mcs_get_txsc(struct cn10k_mcs_cfg *cfg,
>  						 struct macsec_secy *secy)
>  {
> 
> base-commit: fb78a629b4f0eb399b413f6c093a3da177b3a4eb
> -- 
> 2.53.0
> 
