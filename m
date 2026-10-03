Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99F5379C5F;
	Sat,  3 Oct 2026 23:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791071447; cv=none; b=Nhuc4A+nOpt4hWs8uLZATEylDml/zGAKTGRwdAtmahT8AY4iAlQw5ktQORmAk8tv8yCFPHZKszRW/myCrmEt7nx29iYSXkPK29Vy8dP/miRn22fmX3cvygyFwlDRHm/dQyvI+shskAwQNTWttUuT6IsAzNnXF4Hg9eM2lANkAcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791071447; c=relaxed/simple;
	bh=8z46ic+dLllQVP0MRANTHmG+pMnHP3qu4phmk3bfrNE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=fU4cwk5p8BbO6pi81YE/iyg8YM87RqLTfg5IIaESPe2z1eSIXpuPGDSD7V8mcLYTocCwRC2kUIy8SCOzzJF/tY3LPeqet/npJ1bkW98BP6aGRmqTG/N8xTIBBxL0IFHysGwG8xrJC53BPsLXjRbgMdgAZnZwuOUCvdBrRw2EQmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=J6UYA23G; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="J6UYA23G"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261003235042euoutp010ae13b921807e43a815feb68ae19742a~bKfy8ONYY1131411314euoutp01C;
	Sat,  3 Oct 2026 23:50:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261003235042euoutp010ae13b921807e43a815feb68ae19742a~bKfy8ONYY1131411314euoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791071442;
	bh=6il4wp6k9x9TZkz/+h7OllEoUNqhyj9iIClTYmBbfBE=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=J6UYA23GbXzSgWDiylsYXmqPqrWmGrxHinr+zo153Mh5xVMO3Fq4093yCW56RM5zv
	 TyAOK++gZXWwfZ1rhR13Mfp5PEywRRMqi6WkuWaomAKaDMbZmHoF11QNolqip1ZlRU
	 w4hnoy1FfOTb+5wYvNiuKO9RUPya9G8Bd3toECJc=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261003235041eucas1p15384f0a3889321f025161bbe2b71bb94~bKfyB3g9T0047100471eucas1p1e;
	Sat,  3 Oct 2026 23:50:41 +0000 (GMT)
Received: from [192.168.1.44] (unknown [106.210.136.40]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261003235039eusmtip254e0d6be44f5a841ebd1c20bd2d1c117~bKfwWPKr40220102201eusmtip2G;
	Sat,  3 Oct 2026 23:50:39 +0000 (GMT)
Message-ID: <fac0f401-bbd3-444b-a755-53cc393673de@samsung.com>
Date: Sun, 4 Oct 2026 01:50:39 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/9] lib/lz4: import upstream LZ4 sources verbatim
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
In-Reply-To: <arn3TC7BgjTXWmdG@google.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261003235041eucas1p15384f0a3889321f025161bbe2b71bb94
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260925113452eucas1p170bfdb34dfbf670a14a6f8f0c2f5094a
X-EPHeader: CA
X-CMS-RootMailID: 20260925113452eucas1p170bfdb34dfbf670a14a6f8f0c2f5094a
References: <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
	<CGME20260925113452eucas1p170bfdb34dfbf670a14a6f8f0c2f5094a@eucas1p1.samsung.com>
	<20260925-lz4-vendor-upstream-v1-1-1c7ffbe21c4b@samsung.com>
	<arn3TC7BgjTXWmdG@google.com>



On 9/28/26 07:19, Sergey Senozhatsky wrote:
> On (26/09/25 13:27), Michal Wilczynski wrote:
> [..]
>> +int LZ4_compress_fast_extState(void* state, const char* source, char* dest, int inputSize, int maxOutputSize, int acceleration)
>> +{
>> +    LZ4_stream_t_internal* const ctx = & LZ4_initStream(state, sizeof(LZ4_stream_t)) -> internal_donotuse;
>> +    assert(ctx != NULL);
> 
> Probably in some other places as well:
> 
> LZ4_initStream() can return NULL, but the code immediately derefs
> the pointer.  The assert() check seems to be misplaced, unless I'm
> missing something.
> 
> I suppose those need to be decoupled.  First LZ4_initStream() call and
> NULL check, then stream->internal_donotuse.

Good catch, this assert() is a noop in the kernel (as any build without
LZ4_DEBUG), so a NULL, undersized or misaligned wrkmem oopses in
LZ4_compress_fast(), and LZ4_compress_destSize() and LZ4_resetStreamHC()
carry on with an uninitialised state.

No in-tree caller hits it (all use kmalloc/vmalloc), and I listed the
alignment requirement as a behaviour change in the cover letter. Still,
the vendored files need to stay verbatim.

So in v2 our own entry points can check alignment with a WARN_ON_ONCE()
and bail out early. It might be something that we can fix upstream as
well.


> 

Best regards,
-- 
Michal Wilczynski <m.wilczynski@samsung.com>
