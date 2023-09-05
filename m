Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F10DFC83F2C
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Sep 2023 16:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245253AbjIEQUf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354124AbjIEJpP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Sep 2023 05:45:15 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BD6AC
        for <linux-crypto@vger.kernel.org>; Tue,  5 Sep 2023 02:45:10 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 90047201E2;
        Tue,  5 Sep 2023 11:45:08 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id v9hu3-dkGetV; Tue,  5 Sep 2023 11:45:07 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A0F1320184;
        Tue,  5 Sep 2023 11:45:07 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 9AA9680004A;
        Tue,  5 Sep 2023 11:45:07 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 5 Sep 2023 11:45:07 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Tue, 5 Sep
 2023 11:45:06 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 2BC023182A9C; Tue,  5 Sep 2023 11:45:06 +0200 (CEST)
Date:   Tue, 5 Sep 2023 11:45:06 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Lu Jialin <lujialin4@huawei.com>
CC:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "Guo Zihua" <guozihua@huawei.com>, <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v3] crypto: Fix hungtask for PADATA_RESET
Message-ID: <ZPb4ovJ+eatyPk1E@gauss3.secunet.de>
References: <20230904133341.2528440-1-lujialin4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230904133341.2528440-1-lujialin4@huawei.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 04, 2023 at 01:33:41PM +0000, Lu Jialin wrote:
> ---
>  crypto/pcrypt.c | 4 ++++
>  kernel/padata.c | 2 +-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
> index 8c1d0ca41213..d0d954fe9d54 100644
> --- a/crypto/pcrypt.c
> +++ b/crypto/pcrypt.c
> @@ -117,6 +117,8 @@ static int pcrypt_aead_encrypt(struct aead_request *req)
>  	err = padata_do_parallel(ictx->psenc, padata, &ctx->cb_cpu);
>  	if (!err)
>  		return -EINPROGRESS;
> +	if (err == -EBUSY)
> +		return -EAGAIN;
>  
>  	return err;
>  }
> @@ -164,6 +166,8 @@ static int pcrypt_aead_decrypt(struct aead_request *req)
>  	err = padata_do_parallel(ictx->psdec, padata, &ctx->cb_cpu);
>  	if (!err)
>  		return -EINPROGRESS;
> +	if (err == -EBUSY)
> +		return -EAGAIN;
>  
>  	return err;
>  }
> diff --git a/kernel/padata.c b/kernel/padata.c
> index 222d60195de6..81c8183f3176 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -202,7 +202,7 @@ int padata_do_parallel(struct padata_shell *ps,
>  		*cb_cpu = cpu;
>  	}
>  
> -	err =  -EBUSY;
> +	err = -EBUSY;

Why not just returning -EAGAIN here directly?

