Return-Path: <SRS0=jzkg=6X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38303C38A2A
	for <linux-crypto@archiver.kernel.org>; Sat,  9 May 2020 03:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16D6E20746
	for <linux-crypto@archiver.kernel.org>; Sat,  9 May 2020 03:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgEIDmQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 23:42:16 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2128 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726415AbgEIDmQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 23:42:16 -0400
Received: from dggemi405-hub.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id B8176AE831D12A79E648;
        Sat,  9 May 2020 11:42:13 +0800 (CST)
Received: from DGGEMI525-MBS.china.huawei.com ([169.254.6.251]) by
 dggemi405-hub.china.huawei.com ([10.3.17.143]) with mapi id 14.03.0487.000;
 Sat, 9 May 2020 11:42:04 +0800
From:   Song Bao Hua <song.bao.hua@hisilicon.com>
To:     "tanshukun (A)" <tanshukun1@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Xu Zaibo <xuzaibo@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH 12/13] crypto: hisilicon/zip - Use temporary sqe when
 doing work
Thread-Topic: [PATCH 12/13] crypto: hisilicon/zip - Use temporary sqe when
 doing work
Thread-Index: AQHWJQZAcAZApu4+hkePZFWlj8fJQ6ifGvTA
Date:   Sat, 9 May 2020 03:42:04 +0000
Message-ID: <B926444035E5E2439431908E3842AFD249C8F3@DGGEMI525-MBS.china.huawei.com>
References: <1588921068-20739-1-git-send-email-tanshukun1@huawei.com>
 <1588921068-20739-13-git-send-email-tanshukun1@huawei.com>
In-Reply-To: <1588921068-20739-13-git-send-email-tanshukun1@huawei.com>
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
> Subject: [PATCH 12/13] crypto: hisilicon/zip - Use temporary sqe when doing work

> From: Zhou Wang <wangzhou1@hisilicon.com>

> Currently zip sqe is stored in hisi_zip_qp_ctx, which will bring corruption with multiple parallel users of the crypto tfm.

> This patch removes the zip_sqe in hisi_zip_qp_ctx and uses a temporary sqe instead.

This looks like a quite correct fix as in the old code, the 2nd request will overwrite the zip_sqe of the 1st request if we send the 2nd request before the 1st one is completed.
So this will lead to the mistakes of both request1 and request2.

unfortunately, it seems the hang issue can still be reproduced with this patch applied if we ask multi-threads running on multi-cores to send requests in parallel. Maybe something more needs fix?

> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
> ---
>  drivers/crypto/hisilicon/zip/zip_crypto.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)

> diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
> index 369ec32..5fb9d4b 100644
> --- a/drivers/crypto/hisilicon/zip/zip_crypto.c
> +++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
> @@ -64,7 +64,6 @@ struct hisi_zip_req_q {
>  
>  struct hisi_zip_qp_ctx {
>  	struct hisi_qp *qp;
> -	struct hisi_zip_sqe zip_sqe;
>  	struct hisi_zip_req_q req_q;
>  	struct hisi_acc_sgl_pool *sgl_pool;
>  	struct hisi_zip *zip_dev;
> @@ -484,11 +483,11 @@ static struct hisi_zip_req *hisi_zip_create_req(struct acomp_req *req,  static int hisi_zip_do_work(struct hisi_zip_req *req,
>  			    struct hisi_zip_qp_ctx *qp_ctx)
>  {
> -	struct hisi_zip_sqe *zip_sqe = &qp_ctx->zip_sqe;
>  	struct acomp_req *a_req = req->req;
>  	struct hisi_qp *qp = qp_ctx->qp;
>  	struct device *dev = &qp->qm->pdev->dev;
>  	struct hisi_acc_sgl_pool *pool = qp_ctx->sgl_pool;
> +	struct hisi_zip_sqe zip_sqe;
>  	dma_addr_t input;
>  	dma_addr_t output;
>  	int ret;
> @@ -511,13 +510,13 @@ static int hisi_zip_do_work(struct hisi_zip_req *req,
>  	}
>  	req->dma_dst = output;
>  
> -	hisi_zip_fill_sqe(zip_sqe, qp->req_type, input, output, a_req->slen,
> +	hisi_zip_fill_sqe(&zip_sqe, qp->req_type, input, output, a_req->slen,
>  			  a_req->dlen, req->sskip, req->dskip);
> -	hisi_zip_config_buf_type(zip_sqe, HZIP_SGL);
> -	hisi_zip_config_tag(zip_sqe, req->req_id);
> +	hisi_zip_config_buf_type(&zip_sqe, HZIP_SGL);
> +	hisi_zip_config_tag(&zip_sqe, req->req_id);
>  
>  	/* send command to start a task */
> -	ret = hisi_qp_send(qp, zip_sqe);
> +	ret = hisi_qp_send(qp, &zip_sqe);
>  	if (ret < 0)
>  		goto err_unmap_output;
>  

Best Regards
Barry

