Return-Path: <SRS0=xZqV=TK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D9ADC04AB3
	for <linux-crypto@archiver.kernel.org>; Fri, 10 May 2019 12:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B34182177B
	for <linux-crypto@archiver.kernel.org>; Fri, 10 May 2019 12:57:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Bo51Jj8F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfEJM56 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 May 2019 08:57:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10519 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727258AbfEJM55 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 May 2019 08:57:57 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20190510125754epoutp04ffc64f0db06fcaa2cfde322e186aff6d~dU7L3RadF1937019370epoutp04I
        for <linux-crypto@vger.kernel.org>; Fri, 10 May 2019 12:57:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20190510125754epoutp04ffc64f0db06fcaa2cfde322e186aff6d~dU7L3RadF1937019370epoutp04I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1557493074;
        bh=2DveG//NYi3/ltOw3BQ0Xy4l8PONQrquWUDJcBvcFRk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=Bo51Jj8Fc8qSainx2RiKmtXckybqiUGw4q0TRinNVXRgGkSrGBH5eKu5hWdFNvj4u
         YUIfHnzxV1rDnNbTEgxohVOuVe0j2pUmp0BlLb/ONZ8j/8KMcBphTkD2xHZkpo0wa/
         8Rac5s4eFRMIeGM8MrckAwzBLp6lWRNI6EhW1dUI=
Received: from epsmges5p3new.samsung.com (unknown [182.195.40.192]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20190510125752epcas5p47cdd6605d0f10aaa15a1ee1c1869f73e~dU7J3LbB81946419464epcas5p4U;
        Fri, 10 May 2019 12:57:52 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7D.15.04067.F4575DC5; Fri, 10 May 2019 21:57:51 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20190510061311epcas5p19e9bf3d08319ac99890e03e0bd59e478~dPZ1FADtH2986829868epcas5p1D;
        Fri, 10 May 2019 06:13:11 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190510061311epsmtrp29c5434277f68a3faf91c57c6b71b7bac~dPZ1ENuS60637906379epsmtrp2s;
        Fri, 10 May 2019 06:13:11 +0000 (GMT)
X-AuditID: b6c32a4b-7a3ff70000000fe3-a9-5cd5754f9dd7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3B.14.03662.77615DC5; Fri, 10 May 2019 15:13:11 +0900 (KST)
Received: from localhost.localdomain (unknown [107.109.224.135]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190510061309epsmtip2223bf325197f0f6ef88e5bd738859b39~dPZy4I-Au1658316583epsmtip2k;
        Fri, 10 May 2019 06:13:09 +0000 (GMT)
From:   Maninder Singh <maninder1.s@samsung.com>
To:     terrelln@fb.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        keescook@chromium.org, gustavo@embeddedor.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        a.sahrawat@samsung.com, pankaj.m@samsung.com,
        Maninder Singh <maninder1.s@samsung.com>,
        Vaneet Narang <v.narang@samsung.com>
Subject: [PATCH 1/2] zstd: pass pointer rathen than structure to functions
Date:   Fri, 10 May 2019 11:41:44 +0530
Message-Id: <1557468704-3014-1-git-send-email-maninder1.s@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRjm287mNCeHZfQ1TeTkCq9t1vQYaoFipxSUiUGh2cF9OGmX085m
        GhWSopkWaVmkpqugUsRS1PJWOrGrVGLeIE0iQcxWNjXUqDY3qX/P+7zP870P7/cKuKLfPLEg
        S2tAei2tJvhuWFuff0BwonE4VXplIZwc7ERk9dsCjGztkpAls97kQImG/Di5zCGHOqr5ZF9t
        IUZOzrVyyNnfI3zS/PIm2LeBqsobxKiWunEO1dgrocryLS5UW4+EutRSDyhrs0+SyxF1pArR
        SqT3RdoMnTJLmxlFxCenx6TLw6SyYFkEGU74amkNiiJiE5KC47LUtniEbzatNtqoJJpliZ3R
        kXqd0YB8VTrWEEUgRqlmZKFMCEtrWKM2MyRDp9kjk0pD5TblMbXq08AEj3lRAXJeWidc8sDi
        6QvAVQDx3bC/qZN/AbgJRHgngD0vyoGj+AFg7VSXs1gC8M51E1i3LNeNOi3dABaU/nKqFgGc
        KZxeU/HxEFjf0YXZsSeeDU3tT3h2ERfvAXDR0sS1NzbiB+H5+6t8O8ZwCWzvesSxYyEeBy0r
        j3iOcT5w/E0x126G+H0+vPb9nYujEQv/jA07M22Es89bnLwYWi3dfIehCMDRGyOYo7gKYPG3
        OqdqL5wa67dhgS2TP3zQsdNBb4UVrxrXUnBxD3hx9TPHwQvh45p1LIEF4w+d6bygdX4ec2AK
        WkoG1jQiPA3OTYxyLoOtlf8mmACoB1sQw2oyEStndmnRyf9/qxms3V5A/GPQ/CbBDHABINyF
        eMZwqohHZ7O5GjOAAi7hKdQHvU8VCZV07imk16XrjWrEmoHctsIyrnhThs52yVpDukweGhYm
        jZDKd5FhMmKzsJxnewfPpA3oOEIM0q/7OAJXcR7IGf30R1ER/S7lQ0nBKqP+8qvI8vlcWUx4
        6euGnqOFkmSsRnzp0OF9lp/f0pRLJu9n984k+vHKAgcDbyt6DU8vV1qmFCleDdRd775+c+0B
        tDDp/lXuHpWj2u7hNz5T02Y6cWub8HvQiNnArCrOnti/pIhrNK5UPbOGjymn84d2DBMYq6Jl
        AVw9S/8FJFyhyJEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsWy7bCSvG652NUYg5tfdC0u7k61mHO+hcVi
        6x5Vi+5XMhZnunMt7t/7yWRxedccNovD89tYLO692cpk8erfNTaLQyfnMjpwe8xuuMjisWXl
        TSaPdQdVPSY2v2P32HZA1aNvyypGj8+b5ALYo7hsUlJzMstSi/TtErgyHp25y1pwYipjxcnP
        d9kbGL/WdDFyckgImEj8XHmdDcQWEtjNKLH3rw1EXFri57/3LBC2sMTKf8/Zuxi5gGo+M0oc
        WrUUrIFNQE9i1a49YEUiAjUSbf+OsoEUMQscY5TYsOA6I0hCWMBLomPFb7AGFgFViZ17tjOB
        2LwCbhLvfm1nhdggJ3HzXCfzBEaeBYwMqxglUwuKc9Nziw0LjPJSy/WKE3OLS/PS9ZLzczcx
        ggNPS2sH44kT8YcYBTgYlXh4LfivxAixJpYVV+YeYpTgYFYS4S3SAQrxpiRWVqUW5ccXleak
        Fh9ilOZgURLnlc8/FikkkJ5YkpqdmlqQWgSTZeLglGpgTK1L8FaqP8Xa9JqvWN9RrePvlxsC
        F7gKmxx5fbcve7WRQ4jF1Onp/fwW99kXtzxqSClM4p08+wlvn+EqrdttjyI2X1lwOtlseVzg
        39AgDvOZF3ove0x4dGCGxxfbeoXQXrkChrk5veeTrMv8y7w+fv19tfgIi0Nmx6vzOq83R/kw
        T/uybc0/JZbijERDLeai4kQArpsFiTgCAAA=
X-CMS-MailID: 20190510061311epcas5p19e9bf3d08319ac99890e03e0bd59e478
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20190510061311epcas5p19e9bf3d08319ac99890e03e0bd59e478
References: <CGME20190510061311epcas5p19e9bf3d08319ac99890e03e0bd59e478@epcas5p1.samsung.com>
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
---
 crypto/zstd.c        |  2 +-
 include/linux/zstd.h | 10 +++----
 lib/zstd/compress.c  | 82 ++++++++++++++++++++++++++--------------------------
 3 files changed, 47 insertions(+), 47 deletions(-)

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
index 5e0b670..a3e0578 100644
--- a/lib/zstd/compress.c
+++ b/lib/zstd/compress.c
@@ -206,18 +206,18 @@ ZSTD_compressionParameters ZSTD_adjustCParams(ZSTD_compressionParameters cPar, u
 	return cPar;
 }
 
-static U32 ZSTD_equivalentParams(ZSTD_parameters param1, ZSTD_parameters param2)
+static U32 ZSTD_equivalentParams(const ZSTD_parameters *param1, const ZSTD_parameters *param2)
 {
-	return (param1.cParams.hashLog == param2.cParams.hashLog) & (param1.cParams.chainLog == param2.cParams.chainLog) &
-	       (param1.cParams.strategy == param2.cParams.strategy) & ((param1.cParams.searchLength == 3) == (param2.cParams.searchLength == 3));
+	return (param1->cParams.hashLog == param2->cParams.hashLog) & (param1->cParams.chainLog == param2->cParams.chainLog) &
+	       (param1->cParams.strategy == param2->cParams.strategy) & ((param1->cParams.searchLength == 3) == (param2->cParams.searchLength == 3));
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
@@ -239,23 +239,23 @@ typedef enum { ZSTDcrp_continue, ZSTDcrp_noMemset, ZSTDcrp_fullReset } ZSTD_comp
 
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
@@ -265,7 +265,7 @@ static size_t ZSTD_resetCCtx_advanced(ZSTD_CCtx *zc, ZSTD_parameters params, U64
 			size_t const optSpace = ((MaxML + 1) + (MaxLL + 1) + (MaxOff + 1) + (1 << Litbits)) * sizeof(U32) +
 						(ZSTD_OPT_NUM + 1) * (sizeof(ZSTD_match_t) + sizeof(ZSTD_optimal_t));
 			size_t const neededSpace = tableSpace + (256 * sizeof(U32)) /* huffTable */ + tokenSpace +
-						   (((params.cParams.strategy == ZSTD_btopt) || (params.cParams.strategy == ZSTD_btopt2)) ? optSpace : 0);
+						   (((params->cParams.strategy == ZSTD_btopt) || (params->cParams.strategy == ZSTD_btopt2)) ? optSpace : 0);
 			if (zc->workSpaceSize < neededSpace) {
 				ZSTD_free(zc->workSpace, zc->customMem);
 				zc->workSpace = ZSTD_malloc(neededSpace, zc->customMem);
@@ -294,7 +294,7 @@ static size_t ZSTD_resetCCtx_advanced(ZSTD_CCtx *zc, ZSTD_parameters params, U64
 		zc->dictBase = NULL;
 		zc->dictLimit = 0;
 		zc->lowLimit = 0;
-		zc->params = params;
+		zc->params = *params;
 		zc->blockSize = blockSize;
 		zc->frameContentSize = frameContentSize;
 		{
@@ -303,7 +303,7 @@ static size_t ZSTD_resetCCtx_advanced(ZSTD_CCtx *zc, ZSTD_parameters params, U64
 				zc->rep[i] = repStartValue[i];
 		}
 
-		if ((params.cParams.strategy == ZSTD_btopt) || (params.cParams.strategy == ZSTD_btopt2)) {
+		if ((params->cParams.strategy == ZSTD_btopt) || (params->cParams.strategy == ZSTD_btopt2)) {
 			zc->seqStore.litFreq = (U32 *)ptr;
 			zc->seqStore.litLengthFreq = zc->seqStore.litFreq + (1 << Litbits);
 			zc->seqStore.matchLengthFreq = zc->seqStore.litLengthFreq + (MaxLL + 1);
@@ -354,7 +354,7 @@ size_t ZSTD_copyCCtx(ZSTD_CCtx *dstCCtx, const ZSTD_CCtx *srcCCtx, unsigned long
 	{
 		ZSTD_parameters params = srcCCtx->params;
 		params.fParams.contentSizeFlag = (pledgedSrcSize > 0);
-		ZSTD_resetCCtx_advanced(dstCCtx, params, pledgedSrcSize, ZSTDcrp_noMemset);
+		ZSTD_resetCCtx_advanced(dstCCtx, &params, pledgedSrcSize, ZSTDcrp_noMemset);
 	}
 
 	/* copy tables */
@@ -2428,16 +2428,16 @@ static size_t ZSTD_compress_generic(ZSTD_CCtx *cctx, void *dst, size_t dstCapaci
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
 
@@ -2496,7 +2496,7 @@ static size_t ZSTD_compressContinue_internal(ZSTD_CCtx *cctx, void *dst, size_t
 		return ERROR(stage_wrong); /* missing init (ZSTD_compressBegin) */
 
 	if (frame && (cctx->stage == ZSTDcs_init)) {
-		fhSize = ZSTD_writeFrameHeader(dst, dstCapacity, cctx->params, cctx->frameContentSize, cctx->dictID);
+		fhSize = ZSTD_writeFrameHeader(dst, dstCapacity, &cctx->params, cctx->frameContentSize, cctx->dictID);
 		if (ZSTD_isError(fhSize))
 			return fhSize;
 		dstCapacity -= fhSize;
@@ -2735,7 +2735,7 @@ static size_t ZSTD_compress_insertDictionary(ZSTD_CCtx *cctx, const void *dict,
 
 /*! ZSTD_compressBegin_internal() :
 *   @return : 0, or an error code */
-static size_t ZSTD_compressBegin_internal(ZSTD_CCtx *cctx, const void *dict, size_t dictSize, ZSTD_parameters params, U64 pledgedSrcSize)
+static size_t ZSTD_compressBegin_internal(ZSTD_CCtx *cctx, const void *dict, size_t dictSize, const ZSTD_parameters *params, U64 pledgedSrcSize)
 {
 	ZSTD_compResetPolicy_e const crp = dictSize ? ZSTDcrp_fullReset : ZSTDcrp_continue;
 	CHECK_F(ZSTD_resetCCtx_advanced(cctx, params, pledgedSrcSize, crp));
@@ -2744,17 +2744,17 @@ static size_t ZSTD_compressBegin_internal(ZSTD_CCtx *cctx, const void *dict, siz
 
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
@@ -2773,7 +2773,7 @@ static size_t ZSTD_writeEpilogue(ZSTD_CCtx *cctx, void *dst, size_t dstCapacity)
 
 	/* special case : empty frame */
 	if (cctx->stage == ZSTDcs_init) {
-		fhSize = ZSTD_writeFrameHeader(dst, dstCapacity, cctx->params, 0, 0);
+		fhSize = ZSTD_writeFrameHeader(dst, dstCapacity, &cctx->params, 0, 0);
 		if (ZSTD_isError(fhSize))
 			return fhSize;
 		dstCapacity -= fhSize;
@@ -2816,19 +2816,19 @@ size_t ZSTD_compressEnd(ZSTD_CCtx *cctx, void *dst, size_t dstCapacity, const vo
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
@@ -2844,7 +2844,7 @@ struct ZSTD_CDict_s {
 
 size_t ZSTD_CDictWorkspaceBound(ZSTD_compressionParameters cParams) { return ZSTD_CCtxWorkspaceBound(cParams) + ZSTD_ALIGN(sizeof(ZSTD_CDict)); }
 
-static ZSTD_CDict *ZSTD_createCDict_advanced(const void *dictBuffer, size_t dictSize, unsigned byReference, ZSTD_parameters params, ZSTD_customMem customMem)
+static ZSTD_CDict *ZSTD_createCDict_advanced(const void *dictBuffer, size_t dictSize, unsigned byReference, const ZSTD_parameters *params, ZSTD_customMem customMem)
 {
 	if (!customMem.customAlloc || !customMem.customFree)
 		return NULL;
@@ -2890,7 +2890,7 @@ static ZSTD_CDict *ZSTD_createCDict_advanced(const void *dictBuffer, size_t dict
 	}
 }
 
-ZSTD_CDict *ZSTD_initCDict(const void *dict, size_t dictSize, ZSTD_parameters params, void *workspace, size_t workspaceSize)
+ZSTD_CDict *ZSTD_initCDict(const void *dict, size_t dictSize, const ZSTD_parameters *params, void *workspace, size_t workspaceSize)
 {
 	ZSTD_customMem const stackMem = ZSTD_initStack(workspace, workspaceSize);
 	return ZSTD_createCDict_advanced(dict, dictSize, 1, params, stackMem);
@@ -2918,7 +2918,7 @@ size_t ZSTD_compressBegin_usingCDict(ZSTD_CCtx *cctx, const ZSTD_CDict *cdict, u
 	else {
 		ZSTD_parameters params = cdict->refContext->params;
 		params.fParams.contentSizeFlag = (pledgedSrcSize > 0);
-		CHECK_F(ZSTD_compressBegin_advanced(cctx, NULL, 0, params, pledgedSrcSize));
+		CHECK_F(ZSTD_compressBegin_advanced(cctx, NULL, 0, &params, pledgedSrcSize));
 	}
 	return 0;
 }
@@ -3031,7 +3031,7 @@ static size_t ZSTD_resetCStream_internal(ZSTD_CStream *zcs, unsigned long long p
 	if (zcs->cdict)
 		CHECK_F(ZSTD_compressBegin_usingCDict(zcs->cctx, zcs->cdict, pledgedSrcSize))
 	else
-		CHECK_F(ZSTD_compressBegin_advanced(zcs->cctx, NULL, 0, zcs->params, pledgedSrcSize));
+		CHECK_F(ZSTD_compressBegin_advanced(zcs->cctx, NULL, 0, &zcs->params, pledgedSrcSize));
 
 	zcs->inToCompress = 0;
 	zcs->inBuffPos = 0;
@@ -3052,11 +3052,11 @@ size_t ZSTD_resetCStream(ZSTD_CStream *zcs, unsigned long long pledgedSrcSize)
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
@@ -3083,13 +3083,13 @@ static size_t ZSTD_initCStream_advanced(ZSTD_CStream *zcs, const void *dict, siz
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
@@ -3105,7 +3105,7 @@ ZSTD_CStream *ZSTD_initCStream(ZSTD_parameters params, unsigned long long pledge
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

