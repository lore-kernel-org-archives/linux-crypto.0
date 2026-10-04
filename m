Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62EE32C8B;
	Sun,  4 Oct 2026 00:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791072315; cv=none; b=Ved6bSJYPXRlRAg9/TqgirAXNCVvqmEFaltxf+F8uyy/T6Fc7qcNwpAkTOXvBZbHLIXlDTNu+iYoF8mga55Tr+F5BGSePCqvJWes2WemxXvSFVMtYHEfMwyzrtK3pRjFri6VJUEtvLeQwEQv4RCCLpMHBXWYqBNSWQ3IRmVp4fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791072315; c=relaxed/simple;
	bh=wUOiMs0DspmDIltKjRve6iQy32gxZsqIXTx3Sugvn/Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=QVjDccg+Tipw6U0ZBFTv7K4NO3TKVn4+qjhW2LwhToYkWsXIC38dTQCTCHmvOIjwtjdxv1eFLy9b6V2QyLBY2n+Wd/5m//rofbwL8pN2dk6Th2NI/raG5puYhqEbil8RWxhWcnyiSome5yXmnwXfEttkJPxO2MWDlJXeh1uxz+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=KFP5LNkz; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KFP5LNkz"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261004000510euoutp013ee4f267ec7b07e822726f0b5d88d0fa~bKsbKQ__B2163921639euoutp01V;
	Sun,  4 Oct 2026 00:05:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261004000510euoutp013ee4f267ec7b07e822726f0b5d88d0fa~bKsbKQ__B2163921639euoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791072310;
	bh=ZJZTrL5SQnYa6gvVNuN2LjMawlbBBC4EWuE7TxWcKx8=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=KFP5LNkza8OoBtj5HTuawzDRYYYBZ/WrfFMAfjXatZRd5ZwpmRtkrpGNteNnFAcFW
	 a+pvo77kefjxlg+J0Kbo3aGXfUJFkeO4mBIkzt4cVg0+G6B7j2sqT1cGqS4uI3Kd2H
	 +7VeWQwlvnZ97NOV2yx7DRYeXvD3SKk6JpL6yeyc=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261004000509eucas1p12b906a44a576ad1b1bf6f8099f081cdd~bKsaNgMf72285022850eucas1p1h;
	Sun,  4 Oct 2026 00:05:09 +0000 (GMT)
Received: from [192.168.1.44] (unknown [106.210.136.40]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261004000507eusmtip2934e51491ae1d0ccbd9db1e873d1df61~bKsYgse7o0742707427eusmtip2n;
	Sun,  4 Oct 2026 00:05:07 +0000 (GMT)
Message-ID: <ff30763b-d39b-450f-82ef-cba10d221ae6@samsung.com>
Date: Sun, 4 Oct 2026 02:05:06 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 3/9] lib/lz4: add the build environment for the
 vendored sources
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers
	<ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, Justin Stitt
	<justinstitt@google.com>, Russell King <linux@armlinux.org.uk>, Thomas
	Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley"
	<James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, Heiko
	Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander
	Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger
	<borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Thomas
	Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Minchan Kim <minchan@kernel.org>, Jens
	Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-block@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>, Nick
	Terrell <terrelln@meta.com>, Gao Xiang <xiang@kernel.org>, Chao Yu
	<chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Herbert Xu
	<herbert@gondor.apana.org.au>, Phillip Lougher <phillip@squashfs.org.uk>,
	Sungguk <sungguk.na@samsung.com>, Jaehoon Chung <jh80.chung@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>, linux-erofs@lists.ozlabs.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org
Content-Language: en-US
From: Michal Wilczynski <m.wilczynski@samsung.com>
In-Reply-To: <arn9tK5MxxxfH7OW@google.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261004000509eucas1p12b906a44a576ad1b1bf6f8099f081cdd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260925113456eucas1p136c3cd1f08be7201ad6b3f7b0e8ff02d
X-EPHeader: CA
X-CMS-RootMailID: 20260925113456eucas1p136c3cd1f08be7201ad6b3f7b0e8ff02d
References: <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
	<CGME20260925113456eucas1p136c3cd1f08be7201ad6b3f7b0e8ff02d@eucas1p1.samsung.com>
	<20260925-lz4-vendor-upstream-v1-3-1c7ffbe21c4b@samsung.com>
	<arn9tK5MxxxfH7OW@google.com>



On 9/28/26 07:48, Sergey Senozhatsky wrote:
> On (26/09/25 13:27), Michal Wilczynski wrote:
> [..]
>> +
>> +/* LZ4_decompress_fast() and LZ4_resetStream() are still kernel API. */
>> +#define LZ4_DISABLE_DEPRECATE_WARNINGS 1
> 
> Is this upstream code?  As far as I understand it, LZ4_decompress_fast*()
> deprecated upstream and are strongly discouraged.  Do we want to suppress
> deprecation warnings?
> 

It's ours lz4_deps.h but upstream's lz4.c sets the same switch for
itself lz4.c, since its own code calls deprecated functions. We
include lz4.h before lz4.c, so we have to set it first.

I agree on the direction. The only in-tree _fast() user is the pre boot
path of lib/decompress_unlz4.c, so as a follow-up I'd move it to
LZ4_decompress_safe_partial() and drop the three _fast exports.

Best regards,
-- 
Michal Wilczynski <m.wilczynski@samsung.com>
