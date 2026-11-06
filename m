Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.118.77.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793976176;
	b=nuIZ9tMiW9nuZxSIciB0aACF3AkOFR5UP1xEG9zPpXosCnKCFr3qjj/Lnc/wdKCByJHz
	 fX36FZoBWQ/41rLFT0HFl+cmLL6oeDz16fUc2ePIHUKL5eZWohPP8fafwc9E10mDfx5uH
	 iZhloB//TVWEnQGa2JTtSkthmTh8SO0zdSBSMRKvmMDcoiLJ9azY5Dpa/S/O+8oQZQUit
	 KVTF9ODdq8U4jCDiCxL4WoeU6s0dfd9WS2Xr/xlXDnxEvVMNXGpmGDc8OOxRNx/n8cugD
	 lPs4xTjY5oIpqvHxkBctYhWx0dpo83NpMf0zBQG8rqx2Cm+GQC4jN7Y0m07LfDhmTVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793976176;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 From:Date:Subject:MIME-Version:Content-Transfer-Encoding:Message-Id:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-CMS-MailID:X-Msg-Generator:Content-Type:X-RootMTR:X-EPHeader:
	 X-CMS-RootMailID:References;
	bh=Rj8Y5qafYFutHkOlAoJ29LhMDQuxrVln4aCNYyECpsA=;
	b=1MVDk/HQ9tbacEwE4TqYZDoA4T1qxNERLJqveGt5tCO7x6NmxNm0Vicmn732ee/YUuIH
	 nGkzcYzwkbHoA/57zR+ih8TCgf7KrjD9QmK1alNfNA/HLTd2LSMO5grPuG9pEWGUetzyq
	 X204cAu1ashH3CtcBVte7km3ANO9gTtg7g3RO7EM2r+DYXyGuBCMvopR7tBfxUiGmeTjg
	 lLviYJdx6/gMEUYsMWrGg0mmbx3jBmMOIXfSiOZUvzkgvVDLIYb0+V8mLkrnTF9C9oaDV
	 aSl9wIpyhwcAsEFpiuu2plEEKIYSRxKWORN6CiUwobDodveeWTtiQO+syQ4PYajt72A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=BwI5Raqt;
	arc=none smtp.remote-ip=210.118.77.11
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC4C606A331;
	Fri,  6 Nov 2026 14:42:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1FC4C606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=BwI5Raqt
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261106144253euoutp01c796104744657935f58418ab7ccdf555~le9Ma35rb2317823178euoutp01R;
	Fri,  6 Nov 2026 14:42:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261106144253euoutp01c796104744657935f58418ab7ccdf555~le9Ma35rb2317823178euoutp01R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793976173;
	bh=Rj8Y5qafYFutHkOlAoJ29LhMDQuxrVln4aCNYyECpsA=;
	h=From:Date:Subject:In-Reply-To:To:Cc:References:From;
	b=BwI5RaqtVBatHQ9FvOJ55uoIz+fe2relbWKFywd/iJ7UxbiAUExJDGgQBwVqMgvPP
	 UdvBd8K2ekwzyndtRORpmlbATxLqEG3g6AEgKFZhuL/6kzMA4waA9KfpwPcfkUWCJj
	 a5io1KFq5kFQHiWaTDkEAwAoTjw/BLEsdPnf7/6o=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261106144252eucas1p272c9e37d66ad385db070f941879aecb1~le9MI3J6I2474624746eucas1p2Q;
	Fri,  6 Nov 2026 14:42:52 +0000 (GMT)
Received: from AMDC4942.eu.corp.samsungelectronics.net (unknown
	[106.210.136.40]) by eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261106144250eusmtip1dcd97a2c5f23d834ade7b24072cbbacb~le9KHGP180491304913eusmtip1T;
	Fri,  6 Nov 2026 14:42:50 +0000 (GMT)
From: Michal Wilczynski <m.wilczynski@samsung.com>
Date: Fri, 06 Nov 2026 15:42:43 +0100
Subject: [PATCH v2 03/15] zram: lz4hc: reset the dictionary stream once, not
 per page
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-lz4-vendor-upstream-v2-3-ee04c3f0d7dc@samsung.com>
In-Reply-To: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
To: Michal Wilczynski <m.wilczynski@samsung.com>,  Nathan Chancellor
	<nathan@kernel.org>,  Nick Desaulniers <ndesaulniers@google.com>,  Bill
	Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,  Russell
	King <linux@armlinux.org.uk>,  Thomas Bogendoerfer
	<tsbogend@alpha.franken.de>,  "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,  Helge Deller <deller@gmx.de>,
	Heiko Carstens <hca@linux.ibm.com>,  Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>,  Christian Borntraeger
	<borntraeger@linux.ibm.com>,  Sven Schnelle <svens@linux.ibm.com>, Thomas
	Gleixner <tglx@kernel.org>,  Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>,  Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Minchan Kim <minchan@kernel.org>,  Sergey
	Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, 
	linux-block@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>,  Nick
	Terrell <terrelln@meta.com>, Gao Xiang <xiang@kernel.org>,  Chao Yu
	<chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,  Eric Biggers
	<ebiggers@kernel.org>,  Herbert Xu <herbert@gondor.apana.org.au>,  David
	Laight <david.laight.linux@gmail.com>,  Sungguk <sungguk.na@samsung.com>,
	Jaehoon Chung <jh80.chung@samsung.com>,  Marek Szyprowski
	<m.szyprowski@samsung.com>, linux-erofs@lists.ozlabs.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1522;
	i=m.wilczynski@samsung.com; h=from:subject:message-id;
	bh=gf0d0kp9GnHtSKcTtEhuhYTslttbHXb7E32RSfsFkrk=;
	b=owGbwMvMwCGWumv6zndzRCIZT6slMWS9fZ5ySyUrfX9+cLNFzLn3MVV/N4i6Nzut7uWYFaCyg
	Kc99EZURykLgxgHg6yYIsvZjdFGkv8YnpYff/wLZg4rE8gQBi5OAZhI/SSG/1kvExcURfNONrvu
	ra3M/fXc+ijtu01371vME1PUVXXQZ2dkOLuw/PC7Sw6c1RFJLws3fLXnv6L+4+/39Xt/Bfx8EiS
	lwg0A
X-Developer-Key: i=m.wilczynski@samsung.com; a=openpgp;
	fpr=CDB15B3219FE00E577C7E3FA65BA97B9EE9C1459
X-CMS-MailID: 20261106144252eucas1p272c9e37d66ad385db070f941879aecb1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261106144252eucas1p272c9e37d66ad385db070f941879aecb1
X-EPHeader: CA
X-CMS-RootMailID: 20261106144252eucas1p272c9e37d66ad385db070f941879aecb1
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
	<CGME20261106144252eucas1p272c9e37d66ad385db070f941879aecb1@eucas1p2.samsung.com>

With a dictionary, lz4hc_compress() calls LZ4_resetStreamHC() and then
LZ4_loadDictHC() for every page. LZ4_loadDictHC() re-initialises the
stream itself and keeps the level, so one reset at creation is enough.

The reset is cheap today, but upstream LZ4, which lib/lz4 moves to later
in this series, clears the whole 256K state in both calls. Reset once in
lz4hc_create() instead.

Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
---
 drivers/block/zram/backend_lz4hc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/zram/backend_lz4hc.c b/drivers/block/zram/backend_lz4hc.c
index d8aa01bb258fec760b597a88296dfaa4e0049693..06286c805cf7c56bd760f460cc854dc4014f293b 100644
--- a/drivers/block/zram/backend_lz4hc.c
+++ b/drivers/block/zram/backend_lz4hc.c
@@ -72,6 +72,7 @@ static int lz4hc_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
 		zctx->cstrm = kzalloc_obj(*zctx->cstrm);
 		if (!zctx->cstrm)
 			goto error;
+		LZ4_resetStreamHC(zctx->cstrm, params->level);
 	}
 
 	return 0;
@@ -92,8 +93,7 @@ static int lz4hc_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 				      req->dst_len, params->level,
 				      zctx->mem);
 	} else {
-		/* Cstrm needs to be reset */
-		LZ4_resetStreamHC(zctx->cstrm, params->level);
+		/* Reloading the dict resets cstrm and keeps its level */
 		ret = LZ4_loadDictHC(zctx->cstrm, params->dict,
 				     params->dict_sz);
 		if (ret != params->dict_sz)

-- 
2.34.1

