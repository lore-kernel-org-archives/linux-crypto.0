Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C5EC04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 09:07:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E84627DF5
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 09:07:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZvVclXhW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfFCJHK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 05:07:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20765 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfFCJHK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 05:07:10 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20190603090706epoutp01c27cd57d9b00a406149fc8e724bbc7ef~kpQhves0a0168201682epoutp013
        for <linux-crypto@vger.kernel.org>; Mon,  3 Jun 2019 09:07:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20190603090706epoutp01c27cd57d9b00a406149fc8e724bbc7ef~kpQhves0a0168201682epoutp013
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1559552826;
        bh=x000a4ofnHkV6EutloqTs1bndNhC93/q3ooHNFHXZLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZvVclXhWSGlEZ38KU8UZ28pghJZ1wnjN63mZOWdh/s3CCFW/C6XiYT+HAKXzvoxUu
         JjbAwDhpNBrqFqhAuWfT9lg5ru/g92vaEyjmdBjKjEOxs23qGrAylzGBplJHEnDUzk
         TE1469iudGPyn1mQoOXTd3VbN7S3OCoJStqDuQaw=
Received: from epsmges5p2new.samsung.com (unknown [182.195.40.196]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20190603090704epcas5p12172290bf7cb908881a5eaa8b0a0e1b7~kpQf8uccf3067030670epcas5p1M;
        Mon,  3 Jun 2019 09:07:04 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        85.49.04066.833E4FC5; Mon,  3 Jun 2019 18:07:04 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20190603090232epcas5p1630d0584e8a1aa9495edc819605664fc~kpMiG7g5J3216432164epcas5p1R;
        Mon,  3 Jun 2019 09:02:32 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190603090232epsmtrp255425b486aba18027ef6c8cf4a259ac5~kpMiFyMOK2094820948epsmtrp2L;
        Mon,  3 Jun 2019 09:02:32 +0000 (GMT)
X-AuditID: b6c32a4a-95bff70000000fe2-51-5cf4e3382748
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F3.4F.03692.722E4FC5; Mon,  3 Jun 2019 18:02:31 +0900 (KST)
Received: from localhost.localdomain (unknown [107.109.224.135]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190603090229epsmtip2ff828eb62f3ee7c2ddce563ad937ca7b~kpMf-qgXi1194011940epsmtip2R;
        Mon,  3 Jun 2019 09:02:29 +0000 (GMT)
From:   Maninder Singh <maninder1.s@samsung.com>
To:     akpm@linux-foundation.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, keescook@chromium.org, gustavo@embeddedor.com
Cc:     joe@perches.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, a.sahrawat@samsung.com,
        pankaj.m@samsung.com, v.narang@samsung.com,
        Maninder Singh <maninder1.s@samsung.com>
Subject: [PATCH 1/4] zstd: pass pointer rathen than structure to functions
Date:   Mon,  3 Jun 2019 14:32:03 +0530
Message-Id: <1559552526-4317-2-git-send-email-maninder1.s@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559552526-4317-1-git-send-email-maninder1.s@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA01SbWxLYRTO23t33aJy1cRRLHOjgujWls47DGGxa/Nj7AeRyVzbm3W0t9Xb
        +vpBJbJlY5iQ2VZfkYgttjEzS7exDwubxUcWmxHzVT+MYDbLhIS218K/5zzPc87z5ryHpbQn
        GR2bI7mJSxJtPDOermubP8+A3w2nGz92zsNPGgj2VV9lsO/RYRrfbNTjIwMzcdmrdzTuOmLH
        r/p/qHC338fgtvO5NO7/dFOFWzvOolUThTLvE1qoLe9TCVUteqGuWS/cP/OTFoYreijhWG0F
        EoZqolLZLbblViJmEVc0kTIdWTlSdgKfkpaxJsMSZzQZTPF4CR8tiXaSwCeuTzWszbEFH8pH
        7xZtniCVKsoyH7tiucvhcZNoq0N2J/DEmWVzmszOGFm0yx4pOybTYV9qMhrNlqBzm83a0tBC
        O28Xo71Fz49SXvT2QAFSs8AthsD55ogCNJ7Vcg0Irvjq6ZCg5b4hGOnxKMIIgkNFZ9BYR81g
        I1KEJgTVDwK0UnxHcLfRT4VcDBcDFf7GsBDJeRH0Py0Kt1BcC4L3uZfCs6ZwyTBS/DgcSHN6
        OD5YGeRZVsOthQ/HZSUuCvoe5lMhWs0lwYM7SaExwPUycHEgXxXigUuE0fIkxT4FBu7VjlOw
        DoY+NzGKPw9Bb0kPrRSnEOR/Kf/rWgmvn7WPCw2iuPlQ7Y9V6FlwurNKFcIUNwkKfwZUCq+B
        +nNjWA+H+65FKHgGDA0O0goW4G1l7t+lliKoautiTqCo0n8RFxCqQNOJU7ZnE9niNEtkz///
        VoPC97gguR5dfri+FXEs4idqvqqH07UR4m55n70VAUvxkRrxRZDSZIn79hOXI8PlsRG5FVmC
        yyyidFMzHcHrltwZJos5Ls4Yb7QswnEmfprmZMTTdC2XLbrJTkKcxDXWp2LVOi+idgWe5WF9
        J9XPdI8IO1wb8h6r/cOFLwtPpLC+TavPLnwfO7u4/aChZPaxlL6N8TN+l95oZ/Ekzy15mbGh
        15vW3tzRcXTVnHu2ksiOsqZ4ao01cGqCdPWSv1uHPhnS5yZurht9c73ePNOScDrZ2bVx8mhZ
        1K/tW9e9qCzIvXwobRFPy1bRtIByyeIfnkjEJ6UDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWy7bCSvK76oy8xBu/v21hc3J1qMWf9GjaL
        OedbWCy27lG16H4lYzH7/mMWizPduRb37/1ksri8aw6bxeH5bSwW995sZbI4dHIuowOPx+yG
        iyweW1beZPJYd1DVY9sBVY8TM36zeHxZdY3Zo2/LKkaPz5vkAjiiuGxSUnMyy1KL9O0SuDIO
        7j7IUrBvOmPFxFs9zA2Mj+q6GDk5JARMJDZ93MPYxcjFISSwm1Hi0Jo/rBAJaYmf/96zQNjC
        Eiv/PWeHKPrMKPFrzVVmkASbgJ7Eql17WEASIgJtjBL9G/+zgjjMAicZJe52fgCrEhbwkvg2
        /QLYKBYBVYn+j2uB9nFw8Aq4SbzsL4bYICdx81wnM0iYU8Bd4vR+d5CwEFDFrrdNrBMY+RYw
        MqxilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/dxAgOXi3NHYyXl8QfYhTgYFTi4Z3B/iVG
        iDWxrLgy9xCjBAezkghv4m2gEG9KYmVValF+fFFpTmrxIUZpDhYlcd6neccihQTSE0tSs1NT
        C1KLYLJMHJxSDYwVVZ+7kjbcf/1jQ/7WyhnGygLrTsYs6CpfFvVg8bWVC/ec/xSdZ7Xomsgv
        JV6OsKUOtzveB5sluDZ6vjxkc/784vizEUJuNpr8Wz4ceDbT68H+uU4PtD9ki+6T2TOf63j9
        wwlJ5nWfnhs2VFd9ksn3qLkh/kvH+oPFrTKh9INpq+Yd67736OBfJZbijERDLeai4kQAidyI
        h1oCAAA=
X-CMS-MailID: 20190603090232epcas5p1630d0584e8a1aa9495edc819605664fc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20190603090232epcas5p1630d0584e8a1aa9495edc819605664fc
References: <1559552526-4317-1-git-send-email-maninder1.s@samsung.com>
        <CGME20190603090232epcas5p1630d0584e8a1aa9495edc819605664fc@epcas5p1.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

currently params structure is passed in all functions, which increases
stack usage in all the function and lead to stack overflow on target like
ARM with kernel stack size of 8 KB so better to pass pointer.

Checked for ARM:

                                Original               Patched
Call FLow Size:                  1264                   1040
....
(HUF_sort)                      -> 296
(HUF_buildCTable_wksp)          -> 144
(HUF_compress4X_repeat)         -> 88
(ZSTD_compressBlock_internal)   -> 200
(ZSTD_compressContinue_internal)-> 136                  -> 88
(ZSTD_compressCCtx)             -> 192                  -> 64
(zstd_compress)                 -> 144                  -> 96
(crypto_compress)               -> 32
(zcomp_compress)                -> 32
....

Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Signed-off-by: Vaneet Narang <v.narang@samsung.com>

Fixing, Line 211: Using & instead of && makes this somewhat difficult to read.
It's hard to believe this is a performance optimization.
Signed-off-by: Joe Perches <joe@perches.com>
---
https://lkml.org/lkml/2019/5/10/539 <joe@perches.com>

 crypto/zstd.c        |  2 +-
 include/linux/zstd.h | 10 +++----
 lib/zstd/compress.c  | 85 +++++++++++++++++++++++++++-------------------------
 3 files changed, 50 insertions(+), 47 deletions(-)

diff --git a/crypto/zstd.c b/crypto/zstd.c
index 2c04055..4e9ff22 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -162,7 +162,7 @@ static int __zstd_compress(const u8 *src, unsigned int slen,
 	struct zstd_ctx *zctx = ctx;
 	const ZSTD_parameters params = zstd_params();
 
-	out_len = ZSTD_compressCCtx(zctx->cctx, dst, *dlen, src, slen, params);
+	out_len = ZSTD_compressCCtx(zctx->cctx, dst, *dlen, src, slen, &params);
 	if (ZSTD_isError(out_len))
 		return -EINVAL;
 	*dlen = out_len;
diff --git a/include/linux/zstd.h b/include/linux/zstd.h
index 249575e..5103efa 100644
--- a/include/linux/zstd.h
+++ b/include/linux/zstd.h
@@ -254,7 +254,7 @@ ZSTD_CCtx *ZSTD_initCCtx(void *workspace, size_t workspaceSize);
  *               ZSTD_isError().
  */
 size_t ZSTD_compressCCtx(ZSTD_CCtx *ctx, void *dst, size_t dstCapacity,
-	const void *src, size_t srcSize, ZSTD_parameters params);
+	const void *src, size_t srcSize, const ZSTD_parameters *params);
 
 /**
  * ZSTD_DCtxWorkspaceBound() - amount of memory needed to initialize a ZSTD_DCtx
@@ -324,7 +324,7 @@ size_t ZSTD_decompressDCtx(ZSTD_DCtx *ctx, void *dst, size_t dstCapacity,
  */
 size_t ZSTD_compress_usingDict(ZSTD_CCtx *ctx, void *dst, size_t dstCapacity,
 	const void *src, size_t srcSize, const void *dict, size_t dictSize,
-	ZSTD_parameters params);
+	const ZSTD_parameters *params);
 
 /**
  * ZSTD_decompress_usingDict() - decompress src into dst using a dictionary
@@ -381,7 +381,7 @@ typedef struct ZSTD_CDict_s ZSTD_CDict;
  * Return:         The digested dictionary emplaced into workspace.
  */
 ZSTD_CDict *ZSTD_initCDict(const void *dictBuffer, size_t dictSize,
-	ZSTD_parameters params, void *workspace, size_t workspaceSize);
+	const ZSTD_parameters *params, void *workspace, size_t workspaceSize);
 
 /**
  * ZSTD_compress_usingCDict() - compress src into dst using a ZSTD_CDict
@@ -552,7 +552,7 @@ typedef struct ZSTD_CStream_s ZSTD_CStream;
  *
  * Return:          The zstd streaming compression context.
  */
-ZSTD_CStream *ZSTD_initCStream(ZSTD_parameters params,
+ZSTD_CStream *ZSTD_initCStream(const ZSTD_parameters *params,
 	unsigned long long pledgedSrcSize, void *workspace,
 	size_t workspaceSize);
 
@@ -1006,7 +1006,7 @@ size_t ZSTD_compressBegin(ZSTD_CCtx *cctx, int compressionLevel);
 size_t ZSTD_compressBegin_usingDict(ZSTD_CCtx *cctx, const void *dict,
 	size_t dictSize, int compressionLevel);
 size_t ZSTD_compressBegin_advanced(ZSTD_CCtx *cctx, const void *dict,
-	size_t dictSize, ZSTD_parameters params,
+	size_t dictSize, const ZSTD_parameters *params,
 	unsigned long long pledgedSrcSize);
 size_t ZSTD_copyCCtx(ZSTD_CCtx *cctx, const ZSTD_CCtx *preparedCCtx,
 	unsigned long long pledgedSrcSize);
diff --git a/lib/zstd/compress.c b/lib/zstd/compress.c
index 5e0b670..306e31b 100644
--- a/lib/zstd/compress.c
+++ b/lib/zstd/compress.c
@@ -206,18 +206,21 @@ ZSTD_compressionParameters ZSTD_adjustCParams(ZSTD_compressionParameters cPar, u
 	return cPar;
 }
 
-static U32 ZSTD_equivalentParams(ZSTD_parameters param1, ZSTD_parameters param2)
+static U32 ZSTD_equivalentParams(const ZSTD_parameters *param1, const ZSTD_parameters *param2)
 {
-	return (param1.cParams.hashLog == param2.cParams.hashLog) & (param1.cParams.chainLog == param2.cParams.chainLog) &
-	       (param1.cParams.strategy == param2.cParams.strategy) & ((param1.cParams.searchLength == 3) == (param2.cParams.searchLength == 3));
+	return  (param1->cParams.hashLog == param2->cParams.hashLog) &&
+		(param1->cParams.chainLog == param2->cParams.chainLog) &&
+		(param1->cParams.strategy == param2->cParams.strategy) &&
+		(param1->cParams.searchLength == 3) &&
+		(param1->cParams.searchLength == param2->cParams.searchLength);
 }
 
 /*! ZSTD_continueCCtx() :
 	reuse CCtx without reset (note : requires no dictionary) */
-static size_t ZSTD_continueCCtx(ZSTD_CCtx *cctx, ZSTD_parameters params, U64 frameContentSize)
+static size_t ZSTD_continueCCtx(ZSTD_CCtx *cctx, const ZSTD_parameters *params, U64 frameContentSize)
 {
 	U32 const end = (U32)(cctx->nextSrc - cctx->base);
-	cctx->params = params;
+	cctx->params = *params;
 	cctx->frameContentSize = frameContentSize;
 	cctx->lowLimit = end;
 	cctx->dictLimit = end;
@@ -239,23 +242,23 @@ typedef enum { ZSTDcrp_continue, ZSTDcrp_noMemset, ZSTDcrp_fullReset } ZSTD_comp
 
 /*! ZSTD_resetCCtx_advanced() :
 	note : `params` must be validated */
-static size_t ZSTD_resetCCtx_advanced(ZSTD_CCtx *zc, ZSTD_parameters params, U64 frameContentSize, ZSTD_compResetPolicy_e const crp)
+static size_t ZSTD_resetCCtx_advanced(ZSTD_CCtx *zc, const ZSTD_parameters *params, U64 frameContentSize, ZSTD_compResetPolicy_e const crp)
 {
 	if (crp == ZSTDcrp_continue)
-		if (ZSTD_equivalentParams(params, zc->params)) {
+		if (ZSTD_equivalentParams(params, &zc->params)) {
 			zc->flagStaticTables = 0;
 			zc->flagStaticHufTable = HUF_repeat_none;
 			return ZSTD_continueCCtx(zc, params, frameContentSize);
 		}
 
 	{
-		size_t const blockSize = MIN(ZSTD_BLOCKSIZE_ABSOLUTEMAX, (size_t)1 << params.cParams.windowLog);
-		U32 const divider = (params.cParams.searchLength == 3) ? 3 : 4;
+		size_t const blockSize = MIN(ZSTD_BLOCKSIZE_ABSOLUTEMAX, (size_t)1 << params->cParams.windowLog);
+		U32 const divider = (params->cParams.searchLength == 3) ? 3 : 4;
 		size_t const maxNbSeq = blockSize / divider;
 		size_t const tokenSpace = blockSize + 11 * maxNbSeq;
-		size_t const chainSize = (params.cParams.strategy == ZSTD_fast) ? 0 : (1 << params.cParams.chainLog);
-		size_t const hSize = ((size_t)1) << params.cParams.hashLog;
-		U32 const hashLog3 = (params.cParams.searchLength > 3) ? 0 : MIN(ZSTD_HASHLOG3_MAX, params.cParams.windowLog);
+		size_t const chainSize = (params->cParams.strategy == ZSTD_fast) ? 0 : (1 << params->cParams.chainLog);
+		size_t const hSize = ((size_t)1) << params->cParams.hashLog;
+		U32 const hashLog3 = (params->cParams.searchLength > 3) ? 0 : MIN(ZSTD_HASHLOG3_MAX, params->cParams.windowLog);
 		size_t const h3Size = ((size_t)1) << hashLog3;
 		size_t const tableSpace = (chainSize + hSize + h3Size) * sizeof(U32);
 		void *ptr;
@@ -265,7 +268,7 @@ static size_t ZSTD_resetCCtx_advanced(ZSTD_CCtx *zc, ZSTD_parameters params, U64
 			size_t const optSpace = ((MaxML + 1) + (MaxLL + 1) + (MaxOff + 1) + (1 << Litbits)) * sizeof(U32) +
 						(ZSTD_OPT_NUM + 1) * (sizeof(ZSTD_match_t) + sizeof(ZSTD_optimal_t));
 			size_t const neededSpace = tableSpace + (256 * sizeof(U32)) /* huffTable */ + tokenSpace +
-						   (((params.cParams.strategy == ZSTD_btopt) || (params.cParams.strategy == ZSTD_btopt2)) ? optSpace : 0);
+						   (((params->cParams.strategy == ZSTD_btopt) || (params->cParams.strategy == ZSTD_btopt2)) ? optSpace : 0);
 			if (zc->workSpaceSize < neededSpace) {
 				ZSTD_free(zc->workSpace, zc->customMem);
 				zc->workSpace = ZSTD_malloc(neededSpace, zc->customMem);
@@ -294,7 +297,7 @@ static size_t ZSTD_resetCCtx_advanced(ZSTD_CCtx *zc, ZSTD_parameters params, U64
 		zc->dictBase = NULL;
 		zc->dictLimit = 0;
 		zc->lowLimit = 0;
-		zc->params = params;
+		zc->params = *params;
 		zc->blockSize = blockSize;
 		zc->frameContentSize = frameContentSize;
 		{
@@ -303,7 +306,7 @@ static size_t ZSTD_resetCCtx_advanced(ZSTD_CCtx *zc, ZSTD_parameters params, U64
 				zc->rep[i] = repStartValue[i];
 		}
 
-		if ((params.cParams.strategy == ZSTD_btopt) || (params.cParams.strategy == ZSTD_btopt2)) {
+		if ((params->cParams.strategy == ZSTD_btopt) || (params->cParams.strategy == ZSTD_btopt2)) {
 			zc->seqStore.litFreq = (U32 *)ptr;
 			zc->seqStore.litLengthFreq = zc->seqStore.litFreq + (1 << Litbits);
 			zc->seqStore.matchLengthFreq = zc->seqStore.litLengthFreq + (MaxLL + 1);
@@ -354,7 +357,7 @@ size_t ZSTD_copyCCtx(ZSTD_CCtx *dstCCtx, const ZSTD_CCtx *srcCCtx, unsigned long
 	{
 		ZSTD_parameters params = srcCCtx->params;
 		params.fParams.contentSizeFlag = (pledgedSrcSize > 0);
-		ZSTD_resetCCtx_advanced(dstCCtx, params, pledgedSrcSize, ZSTDcrp_noMemset);
+		ZSTD_resetCCtx_advanced(dstCCtx, &params, pledgedSrcSize, ZSTDcrp_noMemset);
 	}
 
 	/* copy tables */
@@ -2428,16 +2431,16 @@ static size_t ZSTD_compress_generic(ZSTD_CCtx *cctx, void *dst, size_t dstCapaci
 	return op - ostart;
 }
 
-static size_t ZSTD_writeFrameHeader(void *dst, size_t dstCapacity, ZSTD_parameters params, U64 pledgedSrcSize, U32 dictID)
+static size_t ZSTD_writeFrameHeader(void *dst, size_t dstCapacity, ZSTD_parameters *params, U64 pledgedSrcSize, U32 dictID)
 {
 	BYTE *const op = (BYTE *)dst;
 	U32 const dictIDSizeCode = (dictID > 0) + (dictID >= 256) + (dictID >= 65536); /* 0-3 */
-	U32 const checksumFlag = params.fParams.checksumFlag > 0;
-	U32 const windowSize = 1U << params.cParams.windowLog;
-	U32 const singleSegment = params.fParams.contentSizeFlag && (windowSize >= pledgedSrcSize);
-	BYTE const windowLogByte = (BYTE)((params.cParams.windowLog - ZSTD_WINDOWLOG_ABSOLUTEMIN) << 3);
+	U32 const checksumFlag = params->fParams.checksumFlag > 0;
+	U32 const windowSize = 1U << params->cParams.windowLog;
+	U32 const singleSegment = params->fParams.contentSizeFlag && (windowSize >= pledgedSrcSize);
+	BYTE const windowLogByte = (BYTE)((params->cParams.windowLog - ZSTD_WINDOWLOG_ABSOLUTEMIN) << 3);
 	U32 const fcsCode =
-	    params.fParams.contentSizeFlag ? (pledgedSrcSize >= 256) + (pledgedSrcSize >= 65536 + 256) + (pledgedSrcSize >= 0xFFFFFFFFU) : 0; /* 0-3 */
+	    params->fParams.contentSizeFlag ? (pledgedSrcSize >= 256) + (pledgedSrcSize >= 65536 + 256) + (pledgedSrcSize >= 0xFFFFFFFFU) : 0; /* 0-3 */
 	BYTE const frameHeaderDecriptionByte = (BYTE)(dictIDSizeCode + (checksumFlag << 2) + (singleSegment << 5) + (fcsCode << 6));
 	size_t pos;
 
@@ -2496,7 +2499,7 @@ static size_t ZSTD_compressContinue_internal(ZSTD_CCtx *cctx, void *dst, size_t
 		return ERROR(stage_wrong); /* missing init (ZSTD_compressBegin) */
 
 	if (frame && (cctx->stage == ZSTDcs_init)) {
-		fhSize = ZSTD_writeFrameHeader(dst, dstCapacity, cctx->params, cctx->frameContentSize, cctx->dictID);
+		fhSize = ZSTD_writeFrameHeader(dst, dstCapacity, &cctx->params, cctx->frameContentSize, cctx->dictID);
 		if (ZSTD_isError(fhSize))
 			return fhSize;
 		dstCapacity -= fhSize;
@@ -2735,7 +2738,7 @@ static size_t ZSTD_compress_insertDictionary(ZSTD_CCtx *cctx, const void *dict,
 
 /*! ZSTD_compressBegin_internal() :
 *   @return : 0, or an error code */
-static size_t ZSTD_compressBegin_internal(ZSTD_CCtx *cctx, const void *dict, size_t dictSize, ZSTD_parameters params, U64 pledgedSrcSize)
+static size_t ZSTD_compressBegin_internal(ZSTD_CCtx *cctx, const void *dict, size_t dictSize, const ZSTD_parameters *params, U64 pledgedSrcSize)
 {
 	ZSTD_compResetPolicy_e const crp = dictSize ? ZSTDcrp_fullReset : ZSTDcrp_continue;
 	CHECK_F(ZSTD_resetCCtx_advanced(cctx, params, pledgedSrcSize, crp));
@@ -2744,17 +2747,17 @@ static size_t ZSTD_compressBegin_internal(ZSTD_CCtx *cctx, const void *dict, siz
 
 /*! ZSTD_compressBegin_advanced() :
 *   @return : 0, or an error code */
-size_t ZSTD_compressBegin_advanced(ZSTD_CCtx *cctx, const void *dict, size_t dictSize, ZSTD_parameters params, unsigned long long pledgedSrcSize)
+size_t ZSTD_compressBegin_advanced(ZSTD_CCtx *cctx, const void *dict, size_t dictSize, const ZSTD_parameters *params, unsigned long long pledgedSrcSize)
 {
 	/* compression parameters verification and optimization */
-	CHECK_F(ZSTD_checkCParams(params.cParams));
+	CHECK_F(ZSTD_checkCParams(params->cParams));
 	return ZSTD_compressBegin_internal(cctx, dict, dictSize, params, pledgedSrcSize);
 }
 
 size_t ZSTD_compressBegin_usingDict(ZSTD_CCtx *cctx, const void *dict, size_t dictSize, int compressionLevel)
 {
 	ZSTD_parameters const params = ZSTD_getParams(compressionLevel, 0, dictSize);
-	return ZSTD_compressBegin_internal(cctx, dict, dictSize, params, 0);
+	return ZSTD_compressBegin_internal(cctx, dict, dictSize, &params, 0);
 }
 
 size_t ZSTD_compressBegin(ZSTD_CCtx *cctx, int compressionLevel) { return ZSTD_compressBegin_usingDict(cctx, NULL, 0, compressionLevel); }
@@ -2773,7 +2776,7 @@ static size_t ZSTD_writeEpilogue(ZSTD_CCtx *cctx, void *dst, size_t dstCapacity)
 
 	/* special case : empty frame */
 	if (cctx->stage == ZSTDcs_init) {
-		fhSize = ZSTD_writeFrameHeader(dst, dstCapacity, cctx->params, 0, 0);
+		fhSize = ZSTD_writeFrameHeader(dst, dstCapacity, &cctx->params, 0, 0);
 		if (ZSTD_isError(fhSize))
 			return fhSize;
 		dstCapacity -= fhSize;
@@ -2816,19 +2819,19 @@ size_t ZSTD_compressEnd(ZSTD_CCtx *cctx, void *dst, size_t dstCapacity, const vo
 }
 
 static size_t ZSTD_compress_internal(ZSTD_CCtx *cctx, void *dst, size_t dstCapacity, const void *src, size_t srcSize, const void *dict, size_t dictSize,
-				     ZSTD_parameters params)
+				     const ZSTD_parameters *params)
 {
 	CHECK_F(ZSTD_compressBegin_internal(cctx, dict, dictSize, params, srcSize));
 	return ZSTD_compressEnd(cctx, dst, dstCapacity, src, srcSize);
 }
 
 size_t ZSTD_compress_usingDict(ZSTD_CCtx *ctx, void *dst, size_t dstCapacity, const void *src, size_t srcSize, const void *dict, size_t dictSize,
-			       ZSTD_parameters params)
+			       const ZSTD_parameters *params)
 {
 	return ZSTD_compress_internal(ctx, dst, dstCapacity, src, srcSize, dict, dictSize, params);
 }
 
-size_t ZSTD_compressCCtx(ZSTD_CCtx *ctx, void *dst, size_t dstCapacity, const void *src, size_t srcSize, ZSTD_parameters params)
+size_t ZSTD_compressCCtx(ZSTD_CCtx *ctx, void *dst, size_t dstCapacity, const void *src, size_t srcSize, const ZSTD_parameters *params)
 {
 	return ZSTD_compress_internal(ctx, dst, dstCapacity, src, srcSize, NULL, 0, params);
 }
@@ -2844,7 +2847,7 @@ struct ZSTD_CDict_s {
 
 size_t ZSTD_CDictWorkspaceBound(ZSTD_compressionParameters cParams) { return ZSTD_CCtxWorkspaceBound(cParams) + ZSTD_ALIGN(sizeof(ZSTD_CDict)); }
 
-static ZSTD_CDict *ZSTD_createCDict_advanced(const void *dictBuffer, size_t dictSize, unsigned byReference, ZSTD_parameters params, ZSTD_customMem customMem)
+static ZSTD_CDict *ZSTD_createCDict_advanced(const void *dictBuffer, size_t dictSize, unsigned byReference, const ZSTD_parameters *params, ZSTD_customMem customMem)
 {
 	if (!customMem.customAlloc || !customMem.customFree)
 		return NULL;
@@ -2890,7 +2893,7 @@ static ZSTD_CDict *ZSTD_createCDict_advanced(const void *dictBuffer, size_t dict
 	}
 }
 
-ZSTD_CDict *ZSTD_initCDict(const void *dict, size_t dictSize, ZSTD_parameters params, void *workspace, size_t workspaceSize)
+ZSTD_CDict *ZSTD_initCDict(const void *dict, size_t dictSize, const ZSTD_parameters *params, void *workspace, size_t workspaceSize)
 {
 	ZSTD_customMem const stackMem = ZSTD_initStack(workspace, workspaceSize);
 	return ZSTD_createCDict_advanced(dict, dictSize, 1, params, stackMem);
@@ -2918,7 +2921,7 @@ size_t ZSTD_compressBegin_usingCDict(ZSTD_CCtx *cctx, const ZSTD_CDict *cdict, u
 	else {
 		ZSTD_parameters params = cdict->refContext->params;
 		params.fParams.contentSizeFlag = (pledgedSrcSize > 0);
-		CHECK_F(ZSTD_compressBegin_advanced(cctx, NULL, 0, params, pledgedSrcSize));
+		CHECK_F(ZSTD_compressBegin_advanced(cctx, NULL, 0, &params, pledgedSrcSize));
 	}
 	return 0;
 }
@@ -3031,7 +3034,7 @@ static size_t ZSTD_resetCStream_internal(ZSTD_CStream *zcs, unsigned long long p
 	if (zcs->cdict)
 		CHECK_F(ZSTD_compressBegin_usingCDict(zcs->cctx, zcs->cdict, pledgedSrcSize))
 	else
-		CHECK_F(ZSTD_compressBegin_advanced(zcs->cctx, NULL, 0, zcs->params, pledgedSrcSize));
+		CHECK_F(ZSTD_compressBegin_advanced(zcs->cctx, NULL, 0, &zcs->params, pledgedSrcSize));
 
 	zcs->inToCompress = 0;
 	zcs->inBuffPos = 0;
@@ -3052,11 +3055,11 @@ size_t ZSTD_resetCStream(ZSTD_CStream *zcs, unsigned long long pledgedSrcSize)
 	return ZSTD_resetCStream_internal(zcs, pledgedSrcSize);
 }
 
-static size_t ZSTD_initCStream_advanced(ZSTD_CStream *zcs, const void *dict, size_t dictSize, ZSTD_parameters params, unsigned long long pledgedSrcSize)
+static size_t ZSTD_initCStream_advanced(ZSTD_CStream *zcs, const void *dict, size_t dictSize, const ZSTD_parameters *params, unsigned long long pledgedSrcSize)
 {
 	/* allocate buffers */
 	{
-		size_t const neededInBuffSize = (size_t)1 << params.cParams.windowLog;
+		size_t const neededInBuffSize = (size_t)1 << params->cParams.windowLog;
 		if (zcs->inBuffSize < neededInBuffSize) {
 			zcs->inBuffSize = neededInBuffSize;
 			ZSTD_free(zcs->inBuff, zcs->customMem);
@@ -3083,13 +3086,13 @@ static size_t ZSTD_initCStream_advanced(ZSTD_CStream *zcs, const void *dict, siz
 	} else
 		zcs->cdict = NULL;
 
-	zcs->checksum = params.fParams.checksumFlag > 0;
-	zcs->params = params;
+	zcs->checksum = params->fParams.checksumFlag > 0;
+	zcs->params = *params;
 
 	return ZSTD_resetCStream_internal(zcs, pledgedSrcSize);
 }
 
-ZSTD_CStream *ZSTD_initCStream(ZSTD_parameters params, unsigned long long pledgedSrcSize, void *workspace, size_t workspaceSize)
+ZSTD_CStream *ZSTD_initCStream(const ZSTD_parameters *params, unsigned long long pledgedSrcSize, void *workspace, size_t workspaceSize)
 {
 	ZSTD_customMem const stackMem = ZSTD_initStack(workspace, workspaceSize);
 	ZSTD_CStream *const zcs = ZSTD_createCStream_advanced(stackMem);
@@ -3105,7 +3108,7 @@ ZSTD_CStream *ZSTD_initCStream(ZSTD_parameters params, unsigned long long pledge
 ZSTD_CStream *ZSTD_initCStream_usingCDict(const ZSTD_CDict *cdict, unsigned long long pledgedSrcSize, void *workspace, size_t workspaceSize)
 {
 	ZSTD_parameters const params = ZSTD_getParamsFromCDict(cdict);
-	ZSTD_CStream *const zcs = ZSTD_initCStream(params, pledgedSrcSize, workspace, workspaceSize);
+	ZSTD_CStream *const zcs = ZSTD_initCStream(&params, pledgedSrcSize, workspace, workspaceSize);
 	if (zcs) {
 		zcs->cdict = cdict;
 		if (ZSTD_isError(ZSTD_resetCStream_internal(zcs, pledgedSrcSize))) {
-- 
2.7.4

