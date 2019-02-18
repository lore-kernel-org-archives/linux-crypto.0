Return-Path: <SRS0=tWXW=QZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C948DC10F01
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Feb 2019 16:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 900C5217F5
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Feb 2019 16:01:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WEZCFADl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731897AbfBRQBR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Feb 2019 11:01:17 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59948 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731800AbfBRQBR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Feb 2019 11:01:17 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190218160115euoutp01c1adcb67206b4e938ac894b744bdda88~EgLJYfP6k3035730357euoutp01C
        for <linux-crypto@vger.kernel.org>; Mon, 18 Feb 2019 16:01:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190218160115euoutp01c1adcb67206b4e938ac894b744bdda88~EgLJYfP6k3035730357euoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1550505675;
        bh=C3YyHPasrjcj0odMLNMtMAQKA6Z2cWZ4yPrw/Bg1liI=;
        h=From:To:Cc:Subject:Date:References:From;
        b=WEZCFADld8dZP+8be56ZMjB+nFcqjraTdpgqidO5FafE0f7m15lHWuh0T8a+RZxi6
         oL2OJijAysNcexsXXDKe4eYa6WLjLEwiO+hM6yLv96SvvjjwY3UxHD6HiIyL+uNR4Z
         2usTlVG9eKVCuGzSDMKx6Qi8TXcuSJ95WGY9N4KM=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190218160114eucas1p12717be44f704370acb706727dee55e8b~EgLImCN1Q0407604076eucas1p1F;
        Mon, 18 Feb 2019 16:01:14 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id B3.E2.04806.9C6DA6C5; Mon, 18
        Feb 2019 16:01:14 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190218160113eucas1p2183a3620f8322ee33273d3bfe5f06486~EgLHutM-R2967929679eucas1p2Q;
        Mon, 18 Feb 2019 16:01:13 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190218160113eusmtrp100faad93c013dcd712bc460d407787c9~EgLHf2omU1405614056eusmtrp1o;
        Mon, 18 Feb 2019 16:01:13 +0000 (GMT)
X-AuditID: cbfec7f5-79db79c0000012c6-bd-5c6ad6c9c59b
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id EC.DE.04128.9C6DA6C5; Mon, 18
        Feb 2019 16:01:13 +0000 (GMT)
Received: from AMDC3218.DIGITAL.local (unknown [106.120.51.18]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190218160112eusmtip201413564294153aa6434868d50ea1af6~EgLHDcaN50380003800eusmtip2s;
        Mon, 18 Feb 2019 16:01:12 +0000 (GMT)
From:   Kamil Konieczny <k.konieczny@partner.samsung.com>
To:     k.konieczny@partner.samsung.com
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: s5p: update iv after AES op end
Date:   Mon, 18 Feb 2019 17:00:46 +0100
Message-Id: <20190218160046.6387-1-k.konieczny@partner.samsung.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsWy7djP87qnrmXFGPR8ZrSYc76FxWLtnj/M
        Ft2vZCz69v1ntDh/fgO7xf17P5ksLu+aw2Yx4/w+Jov/v5qZHTg9tqy8yeSx7YCqx6ZVnWwe
        /xZOYfE4+G4Pk8fnTXIBbFFcNimpOZllqUX6dglcGQs2H2Qq2MFV8eXTSpYGxkccXYycHBIC
        JhL3ni1k62Lk4hASWMEosX3Oa2YI5wujxIbHHYwQzmdGiRtnF7DDtMxoXARVtZxR4vC+x2xw
        Ld3PprKAVLEJmEs82n6GCcQWEVCWmHxvOlgHs8AqJomNV36DJYQFLCR27foHNpZFQFXi2fIn
        YHFeAWeJ3o/zGCHWyUuc713HDhEXlDg58wnYAmagePPW2WBDJQTa2SXufFoIdZ+LxI45j6Bs
        YYlXx7dA2TISpyf3sEDY5RK7tz5jh2huYZSYO3kRE0TCWuLw8YusXYwcQBs0Jdbv0ocIO0pc
        WriUDSQsIcAnceOtIMQNfBKTtoE8BhLmlehoE4Ko1pWY9/8MK4QtLdH1fx0rRImHxK1FwiCm
        kECsxKKNihMYFWYh+WsWkr9mIVywgJF5FaN4amlxbnpqsXFearlecWJucWleul5yfu4mRmAS
        Ov3v+NcdjPv+JB1iFOBgVOLhXbA8K0aINbGsuDL3EKMEB7OSCO+Ro0Ah3pTEyqrUovz4otKc
        1OJDjNIcLErivNUMD6KFBNITS1KzU1MLUotgskwcnFINjPX8vPfWn63VbDzt0Oxg63wiImxn
        e3aK46pH/SYLre3WH2Z+rZm72DCy1PKSctRatYNsT5exL3KeaFRgd4Q16sf9XVI8i178uNhd
        ab6YqXDbzR9Rszpbvzuf38Y1dVbk9OPrbKYlan7utP11aFbVXuZzHSv0Ppu4Nq7pXvljRSvH
        9KO3HaTr+pVYijMSDbWYi4oTAWoC4G0+AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42I5/e/4Pd2T17JiDG5tYreYc76FxWLtnj/M
        Ft2vZCz69v1ntDh/fgO7xf17P5ksLu+aw2Yx4/w+Jov/v5qZHTg9tqy8yeSx7YCqx6ZVnWwe
        /xZOYfE4+G4Pk8fnTXIBbFF6NkX5pSWpChn5xSW2StGGFkZ6hpYWekYmlnqGxuaxVkamSvp2
        NimpOZllqUX6dgl6GQs2H2Qq2MFV8eXTSpYGxkccXYycHBICJhIzGhcxdzFycQgJLGWUmP7q
        PDNEQlqi8fRqJghbWOLPtS42iKJPjBIN97YxgiTYBMwlHm0/A1YkIqAsMfnedLBJzAIbmCT2
        rrnLBpIQFrCQ2LXrHzuIzSKgKvFs+ROwBl4BZ4nej/MYITbIS5zvXccOEReUODnzCQuIzQwU
        b946m3kCI98sJKlZSFILGJlWMYqklhbnpucWG+kVJ+YWl+al6yXn525iBEbAtmM/t+xg7HoX
        fIhRgINRiYd3wfKsGCHWxLLiytxDjBIczEoivEeOAoV4UxIrq1KL8uOLSnNSiw8xmgIdO5FZ
        SjQ5HxideSXxhqaG5haWhubG5sZmFkrivOcNKqOEBNITS1KzU1MLUotg+pg4OKUaGNXyrLhf
        9lm2v3Od3XpT8X+Q/+Fjn1o+rZUxa1i139qh9pVf7+MlDAxPJtvvbWw4s+zo9dLyBzrbZb7s
        XCHsb+kVwcmhXx22/Z1sfNbFQI8q9pZvL5fFe9r9cmRJWbSt7sv1N+uXOPnZF62bIvlNw6b4
        /N/eZ+8sHf1fThI/Ixp7KuuT5cazu5VYijMSDbWYi4oTAaONEleWAgAA
X-CMS-MailID: 20190218160113eucas1p2183a3620f8322ee33273d3bfe5f06486
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190218160113eucas1p2183a3620f8322ee33273d3bfe5f06486
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190218160113eucas1p2183a3620f8322ee33273d3bfe5f06486
References: <CGME20190218160113eucas1p2183a3620f8322ee33273d3bfe5f06486@eucas1p2.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix bug "s5p-sss crypto driver doesn't set next AES-CBC IV". This should
also fix AES-CTR mode. Tested on Odroid U3 with Eric Biggers branch
"iv-out-testing".

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
---
 drivers/crypto/s5p-sss.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 0064be0e3941..3ea058addad3 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -463,6 +463,9 @@ static void s5p_sg_copy_buf(void *buf, struct scatterlist *sg,
 
 static void s5p_sg_done(struct s5p_aes_dev *dev)
 {
+	struct ablkcipher_request *req = dev->req;
+	struct s5p_aes_reqctx *reqctx = ablkcipher_request_ctx(req);
+
 	if (dev->sg_dst_cpy) {
 		dev_dbg(dev->dev,
 			"Copying %d bytes of output data back to original place\n",
@@ -472,6 +475,11 @@ static void s5p_sg_done(struct s5p_aes_dev *dev)
 	}
 	s5p_free_sg_cpy(dev, &dev->sg_src_cpy);
 	s5p_free_sg_cpy(dev, &dev->sg_dst_cpy);
+	if (reqctx->mode & FLAGS_AES_CBC)
+		memcpy_fromio(req->info, dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), 0x10);
+
+	if (reqctx->mode & FLAGS_AES_CTR)
+		memcpy_fromio(req->info, dev->aes_ioaddr + SSS_REG_AES_CNT_DATA(0), 0x10);
 }
 
 /* Calls the completion. Cannot be called with dev->lock hold. */
-- 
2.20.1

