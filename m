Return-Path: <SRS0=jzkg=6X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9492C28CBC
	for <linux-crypto@archiver.kernel.org>; Sat,  9 May 2020 08:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CCC924957
	for <linux-crypto@archiver.kernel.org>; Sat,  9 May 2020 08:42:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgEIImm convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 May 2020 04:42:42 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2501 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725930AbgEIIml (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 May 2020 04:42:41 -0400
Received: from dggemi403-hub.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 9F5EEA5F07300B0ECC05;
        Sat,  9 May 2020 16:42:35 +0800 (CST)
Received: from DGGEMI423-HUB.china.huawei.com (10.1.199.152) by
 dggemi403-hub.china.huawei.com (10.3.17.136) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Sat, 9 May 2020 16:42:35 +0800
Received: from DGGEMI525-MBS.china.huawei.com ([169.254.6.251]) by
 dggemi423-hub.china.huawei.com ([10.1.199.152]) with mapi id 14.03.0487.000;
 Sat, 9 May 2020 16:42:27 +0800
From:   Song Bao Hua <song.bao.hua@hisilicon.com>
To:     "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        "tanshukun (A)" <tanshukun1@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Xu Zaibo <xuzaibo@huawei.com>
Subject: RE: [PATCH 12/13] crypto: hisilicon/zip - Use temporary sqe when
 doing work
Thread-Topic: [PATCH 12/13] crypto: hisilicon/zip - Use temporary sqe when
 doing work
Thread-Index: AQHWJQZAcAZApu4+hkePZFWlj8fJQ6ifGvTA//+wygCAAKPTMA==
Date:   Sat, 9 May 2020 08:42:26 +0000
Message-ID: <B926444035E5E2439431908E3842AFD249C9E0@DGGEMI525-MBS.china.huawei.com>
References: <1588921068-20739-1-git-send-email-tanshukun1@huawei.com>
 <1588921068-20739-13-git-send-email-tanshukun1@huawei.com>
 <B926444035E5E2439431908E3842AFD249C8F3@DGGEMI525-MBS.china.huawei.com>
 <5EB6526A.20804@hisilicon.com>
In-Reply-To: <5EB6526A.20804@hisilicon.com>
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

> > 
> >> From: Zhou Wang <wangzhou1@hisilicon.com>
> > 
> >> Currently zip sqe is stored in hisi_zip_qp_ctx, which will bring corruption with multiple parallel users of the crypto tfm.
> > 
> >> This patch removes the zip_sqe in hisi_zip_qp_ctx and uses a temporary sqe instead.
> > 
> > This looks like a quite correct fix as in the old code, the 2nd request will overwrite the zip_sqe of the 1st request if we send the 2nd request before the 1st one is completed.
> > So this will lead to the mistakes of both request1 and request2.

> Yes.

> > 
> > unfortunately, it seems the hang issue can still be reproduced with this patch applied if we ask multi-threads running on multi-cores to send requests in parallel. Maybe something more needs fix?

> Currently we do not support multi-threads using one crypto_acomp in this driver.
> If you tested like this, it may go wrong, as we do not protect queue which is in zip ctx.

Zhou, Thanks for clarification. I'm ok with this patch as it is definitely going to the right direction and removing some race conditions. 
Maybe we need a follow-up patch to address the parallel problem later.

> Best,
> Zhou

Barry

> > 
> >> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
> >> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> >> Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
> >> ---
> >>  drivers/crypto/hisilicon/zip/zip_crypto.c | 11 +++++------
> >>  1 file changed, 5 insertions(+), 6 deletions(-)
> > 
> >> diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c 
> >> b/drivers/crypto/hisilicon/zip/zip_crypto.c
> >> index 369ec32..5fb9d4b 100644
> >> --- a/drivers/crypto/hisilicon/zip/zip_crypto.c
> >> +++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
> >> @@ -64,7 +64,6 @@ struct hisi_zip_req_q {
> >>  
> >>  struct hisi_zip_qp_ctx {
> >>  	struct hisi_qp *qp;
> >> -	struct hisi_zip_sqe zip_sqe;
> >>  	struct hisi_zip_req_q req_q;
> >>  	struct hisi_acc_sgl_pool *sgl_pool;
> >>  	struct hisi_zip *zip_dev;
> >> @@ -484,11 +483,11 @@ static struct hisi_zip_req *hisi_zip_create_req(struct acomp_req *req,  static int hisi_zip_do_work(struct hisi_zip_req *req,
> >>  			    struct hisi_zip_qp_ctx *qp_ctx)  {
> >> -	struct hisi_zip_sqe *zip_sqe = &qp_ctx->zip_sqe;
> >>  	struct acomp_req *a_req = req->req;
> >>  	struct hisi_qp *qp = qp_ctx->qp;
> >>  	struct device *dev = &qp->qm->pdev->dev;
> >>  	struct hisi_acc_sgl_pool *pool = qp_ctx->sgl_pool;
> >> +	struct hisi_zip_sqe zip_sqe;
> >>  	dma_addr_t input;
> >>  	dma_addr_t output;
> >>  	int ret;
> >> @@ -511,13 +510,13 @@ static int hisi_zip_do_work(struct hisi_zip_req *req,
> >>  	}
> >>  	req->dma_dst = output;
> >>  
> >> -	hisi_zip_fill_sqe(zip_sqe, qp->req_type, input, output, a_req->slen,
> >> +	hisi_zip_fill_sqe(&zip_sqe, qp->req_type, input, output, 
> >> +a_req->slen,
> >>  			  a_req->dlen, req->sskip, req->dskip);
> >> -	hisi_zip_config_buf_type(zip_sqe, HZIP_SGL);
> >> -	hisi_zip_config_tag(zip_sqe, req->req_id);
> >> +	hisi_zip_config_buf_type(&zip_sqe, HZIP_SGL);
> >> +	hisi_zip_config_tag(&zip_sqe, req->req_id);
> >>  
> >>  	/* send command to start a task */
> >> -	ret = hisi_qp_send(qp, zip_sqe);
> >> +	ret = hisi_qp_send(qp, &zip_sqe);
> >>  	if (ret < 0)
> >>  		goto err_unmap_output;
> >>  
