Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.220
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795505953;
	b=aNcFOA87th0NADw+BAaa+NcGnaOI4LzpFWBl1PuxdZATMe4C1uismwJLJUj4h6tf5YEM
	 v2xIM/qtuKmX5pe5nMXb2B9eYJp/5ddMhI5GPFFguhj/QpsGD3eSor1xWm4vhobteKJeq
	 aLLHPYoF/RFkTYZFialtZd26iXdtDeTq5kFv/C/qSDPHPDtJ0ejZ+K2Aynr78SYIOEX1Z
	 bGGDGCvuvnwmtQWIei09EWLSNqn06tCYHKWm1LM5222clAXBNYEmWgb0Yp7p9cINvKVuF
	 d2lOdlxEAoauNlDeooSPt92OSMst6yC9Fs6YwEqglkjlzffRDqp1QJfsd08j3BFIFew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795505953;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Subject:To:CC:
	 References:From:Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=zcwYIX9noGJ34U9bJlk+mPUn4i8ykxi3zI14C+8G2qg=;
	b=TiNF9ak4WH/c1ilr+9wzoxWx5YslCSHchB1pnberIgTCWwDwNjaN58tVS6gOWSKCwYGz
	 cTg/vEDyTm6R+wBZFX2n/HcMbZNDsxDBKOMhBq44RSsDFzsZ805eZkLh5zxbM5pLx8XCr
	 5wUoxe9mGDxZ39zUui4R92MsyE1sN47RQ2fg3nWIObis/4temsXpZv0jcpIpa9xOMT2k+
	 /fVkwgddNlxyXXfs8w2FZsnJ6rrfv7e7BVbbcnddlnBlMMeN/RyBzQB+a+Ig2SgQb1v28
	 4MMM79PYa5n32Yvb+zLpxIC1qZryi7MRy8kP1QkUFyQ3dqE2WzF+h+clqPsuIybhxow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Fw07X7In;
	arc=none smtp.remote-ip=113.46.200.220
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14484606A31E;
	Tue, 24 Nov 2026 07:39:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14484606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Fw07X7In
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zcwYIX9noGJ34U9bJlk+mPUn4i8ykxi3zI14C+8G2qg=;
	b=Fw07X7Inkjc4jnSDcQlOaorq3qgBitF0sj4wTow7JidAYA8rJPCNq/FblkRNLW02UhfruEaob
	afsO+IMGeFzV/7pPXEMEyrMmVNZtn5YYCLWi+jOs/sa8xk8MNapETZ1vPoJXUCrXkei+jHp9s2b
	RZaPODL8ZPhhWseScDY49jE=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4jYZRV4t7Tz12LCv;
	Tue, 24 Nov 2026 15:38:14 +0800 (CST)
Received: from whupemk100014.china.huawei.com (unknown [7.152.184.20])
	by mail.maildlp.com (Postfix) with ESMTPS id 70DF640575;
	Tue, 24 Nov 2026 15:39:03 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 whupemk100014.china.huawei.com (7.152.184.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 24 Nov 2026 15:39:02 +0800
Subject: Re: [PATCH 05/10] crypto: hisilicon/hpre - Fix buffer overflow on odd
 ECDH input size
To: Lee Jones <lee@kernel.org>, Zhiqi Song <songzhiqi1@huawei.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Weili
 Qian <qianweili@huawei.com>, Zaibo Xu <xuzaibo@huawei.com>, Meng Yu
	<yumeng18@huawei.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <stable@vger.kernel.org>
References: <20261123151055.2533735-1-lee@kernel.org>
 <20261123151055.2533735-6-lee@kernel.org>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <c468acae-dca2-f132-ced8-fe9911ccc6ee@huawei.com>
Date: Tue, 24 Nov 2026 15:39:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261123151055.2533735-6-lee@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 whupemk100014.china.huawei.com (7.152.184.20)

On 2026/11/23 23:09, Lee Jones wrote:
> hpre_ecdh_src_data_init() validates the input public key length using
> ctx->key_sz - (len >> 1) < 0 before copying len bytes into the upper
> half (offset ctx->key_sz << 1) of a (ctx->key_sz << 2)-byte coherent
> DMA buffer.
> 
> Because len >> 1 truncates the least significant bit, an odd input
> length of (ctx->key_sz << 1) + 1 (such as 65 bytes for NIST P-256)
> evaluates shift to 0, bypasses the bounds check, and writes one byte
> past the end of the coherent DMA allocation in
> scatterwalk_map_and_copy().  A zero length when ctx->key_sz is unset
> similarly bypasses the check.
> 
> Reject zero, odd, or oversized lengths explicitly before computing the
> coordinate offset.
> 
> Fixes: 05e7b906aa7c ("crypto: hisilicon/hpre - add 'ECDH' algorithm")
> Closes: https://sashiko.dev/#/bug/linux-42c6cdd1-7f7e-4071-bb2f-a4db5935267e
> Cc: stable@vger.kernel.org
> Signed-off-by: Lee Jones <lee@kernel.org>
> ---
>  drivers/crypto/hisilicon/hpre/hpre_crypto.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
> index 66a276786a7d..78ae987d338a 100644
> --- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
> +++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
> @@ -1484,9 +1484,10 @@ static int hpre_ecdh_src_data_init(struct hpre_asym_request *hpre_req,
>  	int shift;
>  
>  	/* Src_data include gx and gy. */
> +	if (unlikely(!len || (len & 1) || len > (ctx->key_sz << 1)))
> +		return -EINVAL;
> +
>  	shift = ctx->key_sz - (len >> 1);
> -	if (unlikely(shift < 0))
> -		return -EINVAL;
>

Reviewed-by: Longfang Liu <liulongfang@huawei.com>

Thanks!
Longfang.

>  	ptr = dma_alloc_coherent(dev, ctx->key_sz << 2, &dma, gfp);
>  	if (unlikely(!ptr))
> 
