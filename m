Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E01929D26E;
	Mon, 23 Mar 2026 07:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774249383; cv=none; b=M7QIKGkYNvdiE/GqUSk6QRJRgOiKKA7sAEJm/ILFYNUpdaiMO1RkFNChvmVuvEboJdATI1GQ59LWoqGE5CHZ98076LLP/Ap2jgryUgU4WOcS/yIZES4RWZ0Yu8AH6bSB49bjjbIhoKBBTWGGXVyhtYAGeRjvHeAhow+u81irJaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774249383; c=relaxed/simple;
	bh=1rSu4RQkFCyIT02LoT5ovl1VxSe1zgAJeKBBL87AEr0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uGMvIPK2wCzwGGAi77hqALBlO20IK0OKDKtmRSd1UI17Jc9eOr+4rVN4ulqtEFmEAdGutQhGXUXaAC4ArBNi+igW/orXU8km8O+2XpE73jutdegthhzfgp5NrA4tEPy83MxdZrwCdNL8MO4UTGb8Y5Kx/18SQXZqqLtG/yYLSmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=PpQNflzo; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="PpQNflzo"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62MNIWxT1001600;
	Mon, 23 Mar 2026 00:02:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pfpt0220; bh=a5oMiRRG1AfGGBtx6Ga6NFZdp
	t35zloGraFZPulSOIU=; b=PpQNflzoqvvLG6wzGPATTFZV3VPVd5HuzdAbeiR7Q
	t5hGTu9lUtzVrMYeoXBk2Pa6Ore71q76kTPkocFEdGmIVBqJdGPJVSEXSoEnACcW
	lAIaQkoruUDH6OF9hfIBsmz0nqlSok4nupTp6y+fqWT4mhBbzlUrxo4otrjg5nA/
	9s4S4kvJaKA+f7DIOgYpU7w5Iymw5g0TL0HrEJaii8MF+KUg0k+PLBfgD2Fbw46w
	VjBNFhSFHeqLq24y3BGvi+/CPbwfFW3ULYMoeI4p4EEqoMS6UQfYAo9F0q20YeTH
	Fb5TElGzhbs/lfj0SjspD+Td2QrpAmZ5SXTUyw4lr3+rA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4d2fk71a6f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Mar 2026 00:02:47 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 23 Mar 2026 00:02:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 23 Mar 2026 00:02:45 -0700
Received: from kernel-ep2 (unknown [10.29.36.53])
	by maili.marvell.com (Postfix) with SMTP id 8237D3F70A2;
	Mon, 23 Mar 2026 00:02:41 -0700 (PDT)
Date: Mon, 23 Mar 2026 12:32:40 +0530
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
Message-ID: <20260323070240.GA758874@kernel-ep2>
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
X-Authority-Analysis: v=2.4 cv=caPfb3DM c=1 sm=1 tr=0 ts=69c0e597 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=l0iWHRpgs5sLHlkKQ1IR:22 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8
 a=x027Qmh1OypKTmINcz0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA1MiBTYWx0ZWRfX1G9qggGA8gbx
 C7yarYFYcmTo3KNUKiHfxbBBBLA05TmXGrsY/O2W0jT0D43vZyadumbifIZcHi/fAMWWXv/ikuP
 c4+U8n9XrWSz2IBnYCL4OpUVLIBPuYXN6WUWiouZCCvIC6+xCN4ocp5PQLdefgvq1iI/mCD4/ed
 rNyS1ikGzd/DZ9Tvc1tzQC8CYTcWU+L3hZWC3MuzMFvNsjXX0iF7L6OTrtg6JvtkNX/oN9Cyzv8
 H9djlABcqqw95Dck0OMLRf/iUe10us8Egt+rNe2D+mkmf8erCZo1fRRoo2dYMzYWkBL1KOowayz
 W+lB/dYnnN90oa3Kjo1TZwePUkO5IvuYMmNXJWAKzEkHtfd+PIfjAAb1muC9U+Byj82V0OMLtti
 vcaKLb/5nvLRZ2YxDuCgW2eH7jB41knGeAKvUkRNwtaiqZ265wdgWGWEqNbLyafYL4B6sLKJaoK
 79l51ZL3t7CSvJ4YM+Q==
X-Proofpoint-GUID: fUi-nYQCvL7XaTYZ_BbP4PPIX-u1yctZ
X-Proofpoint-ORIG-GUID: fUi-nYQCvL7XaTYZ_BbP4PPIX-u1yctZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_02,2026-03-20_02,2025-10-01_01

Hi,

On 2026-03-22 at 04:22:08, Eric Biggers (ebiggers@kernel.org) wrote:
> cn10k_ecb_aes_encrypt() just encrypts a single block with AES.  That is
> much more easily and efficiently done with the AES library than
> crypto_skcipher.  Use the AES library instead.
> 
Thanks for the patch. Give me couple of days, I will test and
ack.

Sundeep

> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
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
