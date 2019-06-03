Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5103AC04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 09:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2958320717
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 09:07:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="nf/hqcm5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfFCJHZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 05:07:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16379 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727335AbfFCJHZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 05:07:25 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20190603090722epoutp044dfef7cf01a280e99f49facd9c28973b~kpQw2IJuB0302903029epoutp04b
        for <linux-crypto@vger.kernel.org>; Mon,  3 Jun 2019 09:07:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20190603090722epoutp044dfef7cf01a280e99f49facd9c28973b~kpQw2IJuB0302903029epoutp04b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1559552842;
        bh=tZKqPAwV7Q+Pt/ObqE9NhR22cgjhADG2J0JuKnllm/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nf/hqcm5xapxruxe6VhNYh+0cAG3CWKfgTbnlrAytVS+8zvQ6wKfKoQhXYbNpuP0Z
         kaunCiF0XQ92BRtEkp1908XmND+yAMLkuBL9E9Agwm0RkB8n9Ib2TWy51EK0oZI7Yr
         eXaAcUEXij0gfHEi8bGQVp5Ot/1h8uUxWw0wnzSo=
Received: from epsmges5p1new.samsung.com (unknown [182.195.40.196]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20190603090719epcas5p34f05154c41832ca075be91f6e662a513~kpQuHuszH0762807628epcas5p3X;
        Mon,  3 Jun 2019 09:07:19 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        42.83.04071.743E4FC5; Mon,  3 Jun 2019 18:07:19 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20190603090240epcas5p17d0881686df3fa3042d0b2d659e925b3~kpMphMo7D1265112651epcas5p1X;
        Mon,  3 Jun 2019 09:02:40 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190603090240epsmtrp104223169b072e7ef55a5656a6773954f~kpMpgUfKJ1674016740epsmtrp1i;
        Mon,  3 Jun 2019 09:02:40 +0000 (GMT)
X-AuditID: b6c32a49-59fff70000000fe7-7d-5cf4e347b4a7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A6.FB.03662.F22E4FC5; Mon,  3 Jun 2019 18:02:39 +0900 (KST)
Received: from localhost.localdomain (unknown [107.109.224.135]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190603090237epsmtip284b1974d2fb7a21167a243f80a56cb01~kpMncDTHl1692616926epsmtip2S;
        Mon,  3 Jun 2019 09:02:37 +0000 (GMT)
From:   Maninder Singh <maninder1.s@samsung.com>
To:     akpm@linux-foundation.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, keescook@chromium.org, gustavo@embeddedor.com
Cc:     joe@perches.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, a.sahrawat@samsung.com,
        pankaj.m@samsung.com, v.narang@samsung.com,
        Maninder Singh <maninder1.s@samsung.com>
Subject: [PATCH 3/4] zstd: move params structure to global variable to
 reduce  stack usage
Date:   Mon,  3 Jun 2019 14:32:05 +0530
Message-Id: <1559552526-4317-4-git-send-email-maninder1.s@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559552526-4317-1-git-send-email-maninder1.s@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA01SfUgTYRzm3Z3bTVwcU+ltldnREA11t9o6Qysq9PoCSULIgV36ota+2k3N
        IDSxVa5SyyinpfSJSyqHmZhWWlG5MCzyg8rCvrUozQQRottuUv89z4/n48fvfQlMWS1VEXlm
        O7KZOSMlDcZb70fHxKa8nzRoXGdppu82YuquN0mZumdlOHOzQ804RxcwtW/f48xTp4l5Ozwt
        YV6010mZ+/UOnBn+dlPCdD85C9aEsLUlfTjb0jgkYa91qdnWe2r28ZkZnJ1092Ps8RY3YH95
        IlKJ7cbEXMRlI1skMmdZsvPMOUnUprTMdZk6vYaOpROYFVSkmTOhJGr95tTY5DyjsCgVWcAZ
        84VRKsfzVPyqRJsl344icy28PYlC1myjldZa43jOxOebc+KyLKaVtEaj1QnKHcbctsrLQdZ7
        wXtdR6dBCXhOlAM5AcnlsPVqM14OggkleRvA4XcTQCQTAjleKhXJFIAVntNBs5ZTtWMBSyeA
        d91NEpH8BvDHsc+YTyUl46C7vcOvCiNLhKyXVf5gjOwC8KPjAvCpQkkDnBrpl/kwTqpha7XX
        P1eQyfDw6zuBvgg41HtESCUIOZkCvXdTfDmQHJDCqcsOIGrWw5PNhyQiDoWjj1pkIlbBrxUO
        mWg4BOBATT8ukmoAj/xoDKhWw3eDD2W+BoyMhtfb48XxQniq55o/FCPnwGMzHwIFCth2bhar
        YdnQjcCi8+Gv8XFcxCz8c6tcJt7FBeDgFY+sEkS4/lU0AOAG85CVN+UgXmelzajw/5fzAP+P
        jNnQBly9m7sBSQAqRPFTPmlQBnEFfJGpG0ACo8IU3CthpMjmivYhmyXTlm9EfDfQCeeswlTh
        WRbhf5vtmbROq9drEjS6ZYyepuYqTgS9NCjJHM6OdiNkRbZZn4SQq0qAxVXcW9y8J0seldF3
        y7iT2WJwv4o6Mw5SlXecZfpFBw52phR4F1UmpDnfOLWvJ6aXZGzY5o1+xK2q11nePN36/UFi
        3tjI+Z3fetIXyzvtRckff9es3bV/RpF2SaVsKOhwlcZULe2pCNemg/hEBf+lq957xfPwYohj
        40jyp081hUoK53M5Ogaz8dxfY4zs+6cDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWy7bCSvK7+oy8xBp+eW1lc3J1qMWf9GjaL
        OedbWCy27lG16H4lYzH7/mMWizPduRb37/1ksri8aw6bxeH5bSwW995sZbI4dHIuowOPx+yG
        iyweW1beZPJYd1DVY9sBVY8TM36zeHxZdY3Zo2/LKkaPz5vkAjiiuGxSUnMyy1KL9O0SuDJ2
        TFjGWnCAq2JWz0/GBsZLHF2MnBwSAiYSU2e/Zuli5OIQEtjNKHHn23V2iIS0xM9/71kgbGGJ
        lf+es0MUfWaUmHLrICNIgk1AT2LVrj1g3SICbYwS/Rv/s4I4zAInGSXudn5gBqkSFoiSmN9/
        mg3EZhFQldg25TRYN6+Am0THnX2sECvkJG6e6wSq5+DgFHCXOL3fHSQsBFSy620T6wRGvgWM
        DKsYJVMLinPTc4sNC4zyUsv1ihNzi0vz0vWS83M3MYKDV0trB+OJE/GHGAU4GJV4eGewf4kR
        Yk0sK67MPcQowcGsJMKbeBsoxJuSWFmVWpQfX1Sak1p8iFGag0VJnFc+/1ikkEB6Yklqdmpq
        QWoRTJaJg1OqgVFNr3AGw0ymGbFVV8LS501i3fX/G/f8FfNVTgieqZ6gNtXhxLyTN2VSS0Kq
        1Ri0ei5WO0SWRVX7FO2XuKyiv++6hybDJA+TtRKLjodK821alRBRH6N2+sz2A480Z6+ctGHL
        74u3rDcyyxnfamxIFZ26yV6hakZEbbr+7hlntioJ9qw4sVQvJFeJpTgj0VCLuag4EQADeWDp
        WgIAAA==
X-CMS-MailID: 20190603090240epcas5p17d0881686df3fa3042d0b2d659e925b3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20190603090240epcas5p17d0881686df3fa3042d0b2d659e925b3
References: <1559552526-4317-1-git-send-email-maninder1.s@samsung.com>
        <CGME20190603090240epcas5p17d0881686df3fa3042d0b2d659e925b3@epcas5p1.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As params structure remains same for lifetime, just initialise it
at init time and make it global variable.

Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Signed-off-by: Vaneet Narang <v.narang@samsung.com>
---
 crypto/zstd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/crypto/zstd.c b/crypto/zstd.c
index 4e9ff22..80a9e5c 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -32,6 +32,8 @@ struct zstd_ctx {
 	void *dwksp;
 };
 
+static ZSTD_parameters params;
+
 static ZSTD_parameters zstd_params(void)
 {
 	return ZSTD_getParams(ZSTD_DEF_LEVEL, 0, 0);
@@ -40,8 +42,10 @@ static ZSTD_parameters zstd_params(void)
 static int zstd_comp_init(struct zstd_ctx *ctx)
 {
 	int ret = 0;
-	const ZSTD_parameters params = zstd_params();
-	const size_t wksp_size = ZSTD_CCtxWorkspaceBound(params.cParams);
+	size_t wksp_size;
+
+	params = zstd_params();
+	wksp_size = ZSTD_CCtxWorkspaceBound(params.cParams);
 
 	ctx->cwksp = vzalloc(wksp_size);
 	if (!ctx->cwksp) {
@@ -160,7 +164,6 @@ static int __zstd_compress(const u8 *src, unsigned int slen,
 {
 	size_t out_len;
 	struct zstd_ctx *zctx = ctx;
-	const ZSTD_parameters params = zstd_params();
 
 	out_len = ZSTD_compressCCtx(zctx->cctx, dst, *dlen, src, slen, &params);
 	if (ZSTD_isError(out_len))
-- 
2.7.4

