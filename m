Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.118.77.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793976181;
	b=sMSiRQHYf2XObtL66fxuz4DCOatyQJ7H2zEvs8Bmy3wdIOasZfchFEC9SAJRU94e1pNc
	 H9qSIqVCKBsyy/MWDo0+sbn+v4IbbZ6VGjXJf9pTNbeC7/TQIgHiurKVTsr31qEIVstu+
	 rzP3cmV8IleTVY+DhznChDDWYlww2Gd2UwdSP/vqudqo9A0tUTGS1HyUGSiCiUR3my2Ju
	 8tPHIFZoKZemWiEVPBoGOrLzEK/QSUPArdfmQbe/BD9D0c6YqO6R03AKoWkMJJPmTLcZZ
	 T7b9w7cR4bNdYza7mVW4JbyY8FdGjnD8FHMnjUxwmXIjtChNbOUZNE1vhl6yj0aNdSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793976181;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 From:Date:Subject:MIME-Version:Content-Transfer-Encoding:Message-Id:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-CMS-MailID:X-Msg-Generator:Content-Type:X-RootMTR:X-EPHeader:
	 X-CMS-RootMailID:References;
	bh=pvazUZ8GwALVMPvikyd9HIyqQPGJP1xRnMR9Mkuuq5g=;
	b=fSA7uE2kO6Iib4itGV0DuCFSH6PuMRlIOuTEqoiqoAj/pq/MfADRHb67z6h+54I0vpRn
	 YYca+zQSt8I1yyDCFqMNbP0IfBQpUducwdDlkKilh0Pphs+jxzvk3iqluT7hSeE37lQBH
	 5vw4/VHs1CDxdlwRvycMu4/geFNTZ3WOHEuIlBsEVp/RIZMPRkVxuUTdzTBdEHmFiiLn7
	 vHlQWDpVjEY7GmNFoMroEf1JHvtNDRerJJnQ54BNL15NtVvMnH2Uam3MuSPEP6LDMvkRN
	 9qHnmKOhs/HrZ67okwkewKvXZ14/wPa7MiXwOLjA8R5WoF5o6rMheC85+5Pca+sopaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b="Tuy1y/iM";
	arc=none smtp.remote-ip=210.118.77.12
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AED7606A326;
	Fri,  6 Nov 2026 14:43:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AED7606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=Tuy1y/iM
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20261106144258euoutp024896c522eb7cece168675d99790d92fb~le9RabMVi1397013970euoutp02a;
	Fri,  6 Nov 2026 14:42:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20261106144258euoutp024896c522eb7cece168675d99790d92fb~le9RabMVi1397013970euoutp02a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793976178;
	bh=pvazUZ8GwALVMPvikyd9HIyqQPGJP1xRnMR9Mkuuq5g=;
	h=From:Date:Subject:In-Reply-To:To:Cc:References:From;
	b=Tuy1y/iMSKfBZwuXZQwMW5l8JCrFtBgAguab+c2GbqsJNFIR57SDJeNDcX97g+P9g
	 UNkpn0TBtxGRr8tKaA3EYg9/BKL1oM+tZbNb1JrubHXRqM5KrxvNvsZIaYpZRMY7Bp
	 FwekHtiiyhhfFmokD43m3dKmeTG3+Sw3fJxH88Uo=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261106144258eucas1p1f59ead3e337482e074bfb26f4553e70d~le9RDuTy80320903209eucas1p1Z;
	Fri,  6 Nov 2026 14:42:58 +0000 (GMT)
Received: from AMDC4942.eu.corp.samsungelectronics.net (unknown
	[106.210.136.40]) by eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261106144256eusmtip19a7550efce2282b6115acdd561526f25~le9Pf0jgn2998329983eusmtip12;
	Fri,  6 Nov 2026 14:42:56 +0000 (GMT)
From: Michal Wilczynski <m.wilczynski@samsung.com>
Date: Fri, 06 Nov 2026 15:42:46 +0100
Subject: [PATCH v2 06/15] lib/lz4: backport upstream's aarch64 fast decode
 loop enablement
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
Message-Id: <20261106-lz4-vendor-upstream-v2-6-ee04c3f0d7dc@samsung.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1749;
	i=m.wilczynski@samsung.com; h=from:subject:message-id;
	bh=YYDQiSfMdDchGst9Ca1G0wxCAGDujriJSlg8sDF+9gg=;
	b=owGbwMvMwCGWumv6zndzRCIZT6slMWS9fZ6q4zL/9pVfolPi++x/a854xv96Q0qw1tHIG7dN/
	d9s+CMn2FHKwiDGwSArpshydmO0keQ/hqflxx//gpnDygQyhIGLUwAmEu/J8FcgbHruVENh070C
	inX9/h83PHhopfZcV2vr2U+3j85Ov6LLyPDoh9E2Lsvd3AFusSk2P5k4bKxM2O79qPE7VDht27M
	XvqwA
X-Developer-Key: i=m.wilczynski@samsung.com; a=openpgp;
	fpr=CDB15B3219FE00E577C7E3FA65BA97B9EE9C1459
X-CMS-MailID: 20261106144258eucas1p1f59ead3e337482e074bfb26f4553e70d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261106144258eucas1p1f59ead3e337482e074bfb26f4553e70d
X-EPHeader: CA
X-CMS-RootMailID: 20261106144258eucas1p1f59ead3e337482e074bfb26f4553e70d
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
	<CGME20261106144258eucas1p1f59ead3e337482e074bfb26f4553e70d@eucas1p1.samsung.com>

v1.10.0 leaves LZ4_FAST_DEC_LOOP off for aarch64 built with clang, after
a slowdown reported on some Android phones in 2019 (upstream PR #707).
An arm64 kernel built with clang therefore decodes with the slower loop.

Upstream has since enabled it for all aarch64, in three unreleased
commits:

commit 0aa33884faf5 ("[LZ4] Limit disabling LZ4_FAST_DEC_LOOP to aarch64+clang+android")
commit 51f8af506b4a ("Fix missing endif")
commit ed86bc1ed802 ("AArch64: Enable LZ4_FAST_DEC_LOOP for Android")

Arm measured +3.5% to +15.6% on Cortex-A510 to X4 with clang. Take the
lz4.c hunks of all three. This goes away at the next re-sync.

Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
---
 lib/lz4/upstream/lz4.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/lib/lz4/upstream/lz4.c b/lib/lz4/upstream/lz4.c
index 0d474be0236a698d297ab9a430f5082485eb3709..ee69d57aae112f4057c050bbdab4cc0f2d30f9d9 100644
--- a/lib/lz4/upstream/lz4.c
+++ b/lib/lz4/upstream/lz4.c
@@ -478,12 +478,7 @@ static const int      dec64table[8] = {0, 0, 0, -1, -4,  1, 2, 3};
 #ifndef LZ4_FAST_DEC_LOOP
 #  if defined __i386__ || defined _M_IX86 || defined __x86_64__ || defined _M_X64
 #    define LZ4_FAST_DEC_LOOP 1
-#  elif defined(__aarch64__) && defined(__APPLE__)
-#    define LZ4_FAST_DEC_LOOP 1
-#  elif defined(__aarch64__) && !defined(__clang__)
-     /* On non-Apple aarch64, we disable this optimization for clang because
-      * on certain mobile chipsets, performance is reduced with clang. For
-      * more information refer to https://github.com/lz4/lz4/pull/707 */
+#  elif defined(__aarch64__)
 #    define LZ4_FAST_DEC_LOOP 1
 #  else
 #    define LZ4_FAST_DEC_LOOP 0

-- 
2.34.1

