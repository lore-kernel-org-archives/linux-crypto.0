Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46132C04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 09:07:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 139D226E72
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 09:07:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="STX+aLua"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfFCJHg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 05:07:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20980 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727209AbfFCJHg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 05:07:36 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20190603090733epoutp016649bbefbabcd9da470d378fd5420e8b~kpQ62may90169001690epoutp01-
        for <linux-crypto@vger.kernel.org>; Mon,  3 Jun 2019 09:07:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20190603090733epoutp016649bbefbabcd9da470d378fd5420e8b~kpQ62may90169001690epoutp01-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1559552853;
        bh=Yd2cOToR+vjJ86ocOT/jMyRteAv9ma3tL/lsMJSLD4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=STX+aLuaNPGbq7+PbrBO3l4jAdufXhm5RsRnLstLg1MXQ7/8ld814RFKt8YH/Wqdw
         CgUjca8gmEqZfGb+KqSRTHzFRsXXUBGUvE9lEY8U4I72j7dLuXIVzgsm/yo7kF/T4j
         vHzx4Uqvjh+MEXXDXv4H/03J7q8RbFRI1x8AMQ4k=
Received: from epsmges5p3new.samsung.com (unknown [182.195.40.194]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20190603090731epcas5p24e9d86df21e3125b4458c9a00eb67360~kpQ48kC8T2256922569epcas5p2b;
        Mon,  3 Jun 2019 09:07:31 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7F.0A.04067.F43E4FC5; Mon,  3 Jun 2019 18:07:27 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20190603090245epcas5p4a6cdfdb7ef72bfd36472f43bb4e1e0f1~kpMu6zcfz1942819428epcas5p4_;
        Mon,  3 Jun 2019 09:02:45 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190603090245epsmtrp252984807868b80dae3cd04524c3bc792~kpMu56t3B2094820948epsmtrp2P;
        Mon,  3 Jun 2019 09:02:45 +0000 (GMT)
X-AuditID: b6c32a4b-7a3ff70000000fe3-38-5cf4e34f75ca
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        97.FB.03662.532E4FC5; Mon,  3 Jun 2019 18:02:45 +0900 (KST)
Received: from localhost.localdomain (unknown [107.109.224.135]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190603090243epsmtip20bcdb3e867cc32a6eed2c77935413a53~kpMs7JybS1194011940epsmtip2U;
        Mon,  3 Jun 2019 09:02:43 +0000 (GMT)
From:   Maninder Singh <maninder1.s@samsung.com>
To:     akpm@linux-foundation.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, keescook@chromium.org, gustavo@embeddedor.com
Cc:     joe@perches.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, a.sahrawat@samsung.com,
        pankaj.m@samsung.com, v.narang@samsung.com,
        Maninder Singh <maninder1.s@samsung.com>
Subject: [PATCH 4/4] zstd: change structure variable from int to char
Date:   Mon,  3 Jun 2019 14:32:06 +0530
Message-Id: <1559552526-4317-5-git-send-email-maninder1.s@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559552526-4317-1-git-send-email-maninder1.s@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRjm2znOYzk7TKsvqyEnJmipZ9bWybQCUw8YZQgWIazD/FBpO1s7
        0zL6IXgplS5mhfd1IcNLGuJlTSNTLLspw6ysULtYIVHqNLAy29yk/j3v877P9zy830tg0hKx
        P5HOm5CR57SUeBne1hMUHLLvw0wyXfxlFWPrQExlU4OYqRzIxZnWTjlTNLGOqRj9gDNPi3TM
        6MiciBm0VoqZHnM+zox8bRUx3Y+qwC5vtiLbhrMttcMitvG+nG3rkrN9pb9wdqbuBcaebakD
        rL1ZlkAc0kamIS4FGQMQr9GnpPOpUVR8ojparVTRihDFNmYrFcBzOhRF7d6TEBKbrnUEpQIy
        OW2Gg0rgBIEK2xFp1GeYUECaXjBFUciQojUowg2hAqcTMvjUUI1eF6Gg6XClY/KwNq2koQYY
        Hvgd75l/7JkNFshC4EVAcgs0v7aDQrCMkJIdAFp+nvVwFdMADkz2uosfALa9f+OxJBk8l+Nu
        3AXwt7kKOBtSchbAhrcrnFhMhsI6ayfuHPIjswEcGSpeNMHI+wCO519fVPiSMfBavxl3YpyU
        w2d984sWEjIW9s6fw112MjjcX4AVAoLwIuPgk3txzncgOSiGfXcq3JF2wzFbuacL+8KJhy1u
        7A/t3+6KXYJTAL4se4G7iosAFnyvdU/thGOvej2dDhgZBJusYS56Pbz0uFHkxBjpA8/8+ihy
        8RJoqV7Ccpg7fNsdYi20T025Q7NwvL1e5NpROYB3qvM9zwNZ+T+LKwDUgTXIIOhSkaA0bObR
        sf8/rhksHmRwvAU09+/pBiQBKG/JpNdMstSDyxSydN0AEhjlJ+HeOChJCpd1Ahn1amOGFgnd
        QOlYZzHmv1Kjd5w3b1IrlOEqFb2NVm5mVApqteSCx1CylEzlTOgIQgZkXNKJCC//bHAgfuHV
        XNzY9uVleTExSWFAZcGvFvCqgczIGGvRBdrmm2hWmyLi64cWfP5cvhaCLDepvunScTwh9Jn3
        mVuj0dbLtq+n4975FZn3Rrduoj9rB0sPtW/0kZ1cHijLqu7qKpk9GvjuY3nSXOuUpuSnIqfm
        Rtbwp97nURMb8g5OD6zYT+FCGqcIxowC9xfSEB3+pgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWy7bCSvK7poy8xBj0/jC0u7k61mLN+DZvF
        nPMtLBZb96hadL+SsZh9/zGLxZnuXIv7934yWVzeNYfN4vD8NhaLe2+2MlkcOjmX0YHHY3bD
        RRaPLStvMnmsO6jqse2AqseJGb9ZPL6susbs0bdlFaPH501yARxRXDYpqTmZZalF+nYJXBmT
        1yxjLDgmUnH47yn2Bsb/Al2MnBwSAiYSl/ubWUFsIYHdjBJXlyRAxKUlfv57zwJhC0us/Pec
        vYuRC6jmM6NEb9c+dpAEm4CexKpde1hAEiICbYwS/Rv/s4I4zAInGSXudn5gBqkSFnCVWHRu
        PtgoFgFVibMn/oKt4xVwkzj6tx9qhZzEzXOdQPUcHJwC7hKn97tDXOQmsettE+sERr4FjAyr
        GCVTC4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCQ1dLawfjiRPxhxgFOBiVeHhnsH+JEWJN
        LCuuzD3EKMHBrCTCm3gbKMSbklhZlVqUH19UmpNafIhRmoNFSZxXPv9YpJBAemJJanZqakFq
        EUyWiYNTqoGx69uEWZ/S7FWPGYmtUu24sXFVe8Fb+Q3dT2eKNHP+v8iT5LbEyFAvLDMh27Q2
        Ztqi91diHknFpO2Ki9k716nv3eWHHtI6fw6yGLrrhDmG51zewRAqwJG7VDP9pzD3ZZZTUr93
        tRxUrOfYe+t65OGuyrZZay9cmbE4I5l9Z5/L2u8/bgcfzS9UYinOSDTUYi4qTgQA5mQnyFkC
        AAA=
X-CMS-MailID: 20190603090245epcas5p4a6cdfdb7ef72bfd36472f43bb4e1e0f1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20190603090245epcas5p4a6cdfdb7ef72bfd36472f43bb4e1e0f1
References: <1559552526-4317-1-git-send-email-maninder1.s@samsung.com>
        <CGME20190603090245epcas5p4a6cdfdb7ef72bfd36472f43bb4e1e0f1@epcas5p4.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Elements of ZSTD_frameParameters structure are used as flag, so
just declare them as char. ZSTD_frameParameters structure is used by
ZSTD_parameters.

Before:
======
sizeof(ZSTD_parameters)
$1 = 40

After:
=====
sizeof(ZSTD_parameters)
$1 = 32

Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Signed-off-by: Vaneet Narang <v.narang@samsung.com>
---
 include/linux/zstd.h  | 6 +++---
 lib/zstd/compress.c   | 4 ++--
 lib/zstd/decompress.c | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/zstd.h b/include/linux/zstd.h
index 5103efa..a1e3483 100644
--- a/include/linux/zstd.h
+++ b/include/linux/zstd.h
@@ -164,9 +164,9 @@ typedef struct {
  * The default value is all fields set to 0.
  */
 typedef struct {
-	unsigned int contentSizeFlag;
-	unsigned int checksumFlag;
-	unsigned int noDictIDFlag;
+	unsigned char contentSizeFlag;
+	unsigned char checksumFlag;
+	unsigned char noDictIDFlag;
 } ZSTD_frameParameters;
 
 /**
diff --git a/lib/zstd/compress.c b/lib/zstd/compress.c
index 306e31b..7e0cea2 100644
--- a/lib/zstd/compress.c
+++ b/lib/zstd/compress.c
@@ -2435,9 +2435,9 @@ static size_t ZSTD_writeFrameHeader(void *dst, size_t dstCapacity, ZSTD_paramete
 {
 	BYTE *const op = (BYTE *)dst;
 	U32 const dictIDSizeCode = (dictID > 0) + (dictID >= 256) + (dictID >= 65536); /* 0-3 */
-	U32 const checksumFlag = params->fParams.checksumFlag > 0;
+	BYTE const checksumFlag = params->fParams.checksumFlag > 0;
 	U32 const windowSize = 1U << params->cParams.windowLog;
-	U32 const singleSegment = params->fParams.contentSizeFlag && (windowSize >= pledgedSrcSize);
+	BYTE const singleSegment = params->fParams.contentSizeFlag && (windowSize >= pledgedSrcSize);
 	BYTE const windowLogByte = (BYTE)((params->cParams.windowLog - ZSTD_WINDOWLOG_ABSOLUTEMIN) << 3);
 	U32 const fcsCode =
 	    params->fParams.contentSizeFlag ? (pledgedSrcSize >= 256) + (pledgedSrcSize >= 65536 + 256) + (pledgedSrcSize >= 0xFFFFFFFFU) : 0; /* 0-3 */
diff --git a/lib/zstd/decompress.c b/lib/zstd/decompress.c
index 269ee9a..7828264 100644
--- a/lib/zstd/decompress.c
+++ b/lib/zstd/decompress.c
@@ -233,7 +233,7 @@ size_t ZSTD_getFrameParams(ZSTD_frameParams *fparamsPtr, const void *src, size_t
 		BYTE const fhdByte = ip[4];
 		size_t pos = 5;
 		U32 const dictIDSizeCode = fhdByte & 3;
-		U32 const checksumFlag = (fhdByte >> 2) & 1;
+		BYTE const checksumFlag = (fhdByte >> 2) & 1;
 		U32 const singleSegment = (fhdByte >> 5) & 1;
 		U32 const fcsID = fhdByte >> 6;
 		U32 const windowSizeMax = 1U << ZSTD_WINDOWLOG_MAX;
-- 
2.7.4

