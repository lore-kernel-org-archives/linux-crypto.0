Return-Path: <SRS0=jzkg=6X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 522EEC38A2A
	for <linux-crypto@archiver.kernel.org>; Sat,  9 May 2020 03:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C744217BA
	for <linux-crypto@archiver.kernel.org>; Sat,  9 May 2020 03:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgEID0A convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 23:26:00 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2067 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728355AbgEID0A (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 23:26:00 -0400
Received: from dggemi405-hub.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 53DBE46CF9C47DD79D22;
        Sat,  9 May 2020 11:25:57 +0800 (CST)
Received: from DGGEMI423-HUB.china.huawei.com (10.1.199.152) by
 dggemi405-hub.china.huawei.com (10.3.17.143) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Sat, 9 May 2020 11:25:56 +0800
Received: from DGGEMI525-MBS.china.huawei.com ([169.254.6.251]) by
 dggemi423-hub.china.huawei.com ([10.1.199.152]) with mapi id 14.03.0487.000;
 Sat, 9 May 2020 11:25:49 +0800
From:   Song Bao Hua <song.bao.hua@hisilicon.com>
To:     "tanshukun (A)" <tanshukun1@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Xu Zaibo <xuzaibo@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH 13/13] crypto: hisilicon/zip - Make negative compression
 not an error
Thread-Topic: [PATCH 13/13] crypto: hisilicon/zip - Make negative
 compression not an error
Thread-Index: AQHWJQYuugrMzbLYXUa2JUSNbpkAvKifF3kA
Date:   Sat, 9 May 2020 03:25:48 +0000
Message-ID: <B926444035E5E2439431908E3842AFD249C8DC@DGGEMI525-MBS.china.huawei.com>
References: <1588921068-20739-1-git-send-email-tanshukun1@huawei.com>
 <1588921068-20739-14-git-send-email-tanshukun1@huawei.com>
In-Reply-To: <1588921068-20739-14-git-send-email-tanshukun1@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.201.87]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Shukun Tan
> Sent: Friday, May 8, 2020 6:58 PM
> To: herbert@gondor.apana.org.au; davem@davemloft.net
> Cc: linux-crypto@vger.kernel.org; Xu Zaibo <xuzaibo@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> Subject: [PATCH 13/13] crypto: hisilicon/zip - Make negative compression not an error

> From: Zhou Wang <wangzhou1@hisilicon.com>

> Users can decide whether to use negative compression result, so it should not be reported as an error by driver.

> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
> Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
> ---
>  drivers/crypto/hisilicon/zip/zip_crypto.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

> diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
> index 5fb9d4b..0f158d4 100644
> --- a/drivers/crypto/hisilicon/zip/zip_crypto.c
> +++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -341,7 +341,7 @@ static void hisi_zip_acomp_cb(struct hisi_qp *qp, void *data)
 
>  	status = sqe->dw3 & HZIP_BD_STATUS_M;
 
> -	if (status != 0 && status != HZIP_NC_ERR) {
> +	if (status != 0) {

Hi Zhou, it seems your comment is saying we won't report errors for some cases. But the code seems to report more errors by removing the "&&" as the condition becomes weaker.
Anything have I lost?

>  		dev_err(dev, "%scompress fail in qp%u: %u, output: %u\n",
>  			(qp->alg_type == 0) ? "" : "de", qp->qp_id, status,
>  			sqe->produced);

Best Regards
Barry

