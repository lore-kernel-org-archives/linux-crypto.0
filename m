Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.118.77.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794487245;
	b=OMZsIhOMTuAOJS4rdJVjLhFQWcJDivEE/9IQQDeDPl9ALqXZCchVMlXqtlBiURWALRRR
	 dWTaWv5fL3EtXvU0N6xEPsXrFWltjMc945pNI6k0IeDjeK8h7LCtOdtHdb9uR+/P2fCIV
	 6Jv296htKdJ5Gmag/k4wbezhKCmu0hbgVF89SfVcd9FU5OSuHg6eptuLApzB6XYsh5qWe
	 B9iypnwa5kjHmEGV6akn/Bcd0rIB5MSvle3/LY8RunlUWBY0t64tL1pt/K0PnYoW3gLdl
	 YRmnR+juUqsDHEpOpTya5cDIXBS5nWrUaRQmT/S4YkLD3QrZsrSuhesB0tW/6e1LxfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794487245;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Content-Language:
	 From:In-Reply-To:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-RootMTR:X-EPHeader:X-CMS-RootMailID:
	 References;
	bh=I9X4XD5ud4JHTzb58pE9cFq0Gp7fU1CTG2I9JiABR6U=;
	b=Y63C27GrfjWQgk6AZlbZAh1ocb758KREBXLmULKtgELdYlkUw0Esg6i0kaCrZAP7PbPK
	 RugYyE1OmjzKXNPBNxuhCnmnBb7OaGI1Y9Nglvm+wPZ2Fo+QQr+jwKpfvmdUunLa21pCV
	 w91nkhVedf5Qtv99e39EX7OGTf+Gr0dOM4sePn/+0aHT+czg8zS/dmlflZeRLcPaVaIoj
	 +N35hcxtkJ2jKhpPx/tedf++E5WHSxkyZbzBNnfYSUiYWk5jNpNglET6URJ5vFqAcwvHr
	 BkOBBMr1vsvOL7S8esn95l4fHWl6+sa/xai02++8dpxcFIaVeBFP51BqtCSn/G1y+pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b="res/twsR";
	arc=none smtp.remote-ip=210.118.77.11
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B68606A32D;
	Thu, 12 Nov 2026 12:40:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18B68606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=res/twsR
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261112124042euoutp01e70ce1178d26db6b7c248a8e4494b386~nTKOYIdlg2545925459euoutp01N;
	Thu, 12 Nov 2026 12:40:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261112124042euoutp01e70ce1178d26db6b7c248a8e4494b386~nTKOYIdlg2545925459euoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794487242;
	bh=I9X4XD5ud4JHTzb58pE9cFq0Gp7fU1CTG2I9JiABR6U=;
	h=Date:Subject:To:From:In-Reply-To:References:From;
	b=res/twsRekcb00rl0hpigdDQU49wJT9sewqF9AZUfNVtehuVCXJxiXNmMChvBTE4G
	 eET/M3Ndk/cN+pz1L0w+/FpjnaGKptZRpIyBuWJJY/P+4a8RF1Bcj0RGmLHmGYIVpi
	 4s1s/PiyRviToazDh7OQfOe5aoNIe42v3Wv4p1io=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261112124041eucas1p2e0fefb8eb4e504a6bbf86fc3bbd57b3b~nTKOBqqaA1051410514eucas1p21;
	Thu, 12 Nov 2026 12:40:41 +0000 (GMT)
Received: from [192.168.1.44] (unknown [106.210.136.40]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261112124039eusmtip15ffbafa2efefdb32bf4f0155ad33cff7~nTKMZv7ec1174711747eusmtip1g;
	Thu, 12 Nov 2026 12:40:39 +0000 (GMT)
Message-ID: <52c54fdf-0879-4dda-9eac-822180f811bc@samsung.com>
Date: Thu, 12 Nov 2026 13:40:39 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/15] lib/lz4: widen LZ4_DECOMPRESS_INPLACE_MARGIN
 for the fast decode loop
To: Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers
	<ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, Justin Stitt
	<justinstitt@google.com>, Russell King <linux@armlinux.org.uk>, Thomas
	Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, Helge Deller <deller@gmx.de>, Heiko
	Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander
	Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger
	<borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Thomas
	Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Minchan Kim <minchan@kernel.org>, Sergey
	Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, Andrew
	Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-block@vger.kernel.org, Yann Collet
	<yann.collet.73@gmail.com>, Nick Terrell <terrelln@meta.com>, Gao Xiang
	<xiang@kernel.org>, Chao Yu <chao@kernel.org>, Jaegeuk Kim
	<jaegeuk@kernel.org>, Eric Biggers <ebiggers@kernel.org>, Herbert Xu
	<herbert@gondor.apana.org.au>, David Laight <david.laight.linux@gmail.com>,
	Sungguk <sungguk.na@samsung.com>, Jaehoon Chung <jh80.chung@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>, linux-erofs@lists.ozlabs.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org
Content-Language: en-US
From: Michal Wilczynski <m.wilczynski@samsung.com>
In-Reply-To: <avTmC_1I59FKA1FN@MacBookPro.fritz.box>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261112124041eucas1p2e0fefb8eb4e504a6bbf86fc3bbd57b3b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261106144309eucas1p2a9bfcc1cf81779d473fb073e7d9139b7
X-EPHeader: CA
X-CMS-RootMailID: 20261106144309eucas1p2a9bfcc1cf81779d473fb073e7d9139b7
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
	<CGME20261106144309eucas1p2a9bfcc1cf81779d473fb073e7d9139b7@eucas1p2.samsung.com>
	<20261106-lz4-vendor-upstream-v2-12-ee04c3f0d7dc@samsung.com>
	<avTmC_1I59FKA1FN@MacBookPro.fritz.box>



On 11/11/26 23:02, Gao Xiang wrote:
> Hi Michal,
> 
> On Fri, Nov 06, 2026 at 03:42:52PM +0100, Michal Wilczynski wrote:
>> erofs decompresses a pcluster in place when the slack after the output
>> is at least LZ4_DECOMPRESS_INPLACE_MARGIN(compressed size), upstream's
>> (compressedSize >> 8) + 32.
>>
>> That holds for the fork, which overshoots its output by at most 8
>> bytes. Upstream's LZ4_FAST_DEC_LOOP, which the next patch brings in for
>> x86 and arm64, copies in 32-byte steps and can overwrite input it has
>> not read yet: of 172410 valid streams laid out as erofs does at exactly
>> that margin, 3660 fail to decode, none with the fork. The worst needs
>> (compressedSize >> 8) + 33. Images mkfs.erofs built did not hit this,
>> but nothing in the format rules it out.
>>
>> Use (compressedSize >> 8) + (compressedSize >> 15) + 36, which takes a
>> 4K pcluster's margin from 48 to 52 bytes. Upstream's lz4.h defines the
>> macro too, so undefine it first.
>>
>> Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
> 
> First, I really think kernel LZ4 should be updated for many years, so
> thanks for this!
> 
> But my personal thought is that could you just fold this patch into
> the next one ("lib/lz4: switch the decompressor to the vendored sources")?
> Because this one should be part of the fast loop update.
> 
> Although the current patch order is also fine, but my potential concern
> is that people don't know the details maybe pick the random ones for
> backporting, which is what I'd like to avoid so I hope this patch could
> be just part of it, otherwise the inplace decompression could be broken.
> 

Make sense I'll fold it into the decompressor switch in v3 so the
wider margin and the fast loop can't be picked up separately.

Thanks for the review and the kind words

Best regards,
-- 
Michal Wilczynski <m.wilczynski@samsung.com>
