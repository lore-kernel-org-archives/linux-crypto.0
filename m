Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12D61CAA6D;
	Sat,  3 Oct 2026 23:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791070723; cv=none; b=eyBvLkldFMU5vOpbp29Ne67iTVgYbPMNQkfbPILoAwP7/PH3PsoP6Nwy3/iyE2sHOdWHEKEcq+X3bIEF5hU8UgeNAnybOIAK/PHGe4BD3dhx7Fq6szGYULwdNvnLTi/LI4nDEULsoSDuBptSOl0K9XXbsb2vM+2VovTJM6XZ9UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791070723; c=relaxed/simple;
	bh=OFlvWDsasH+ZORS4uWDp2Ut5WBqGn1WpdgT9tuwtkpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=SHeqv1k66Sz52ni6vEl/MpPbxSFCMzacuSKveEi/qOzmP3TvnWPaq/HqsNpc9Bh+hQpFxVqVffZeGUKwveQI373cwGiDduuth3sshGPxUey8OCMjHZxw9isBe52BidsHCNCaUfUMLtU5xtu9o6MQ1nnf9awFjc+eQdFz2f1jGlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=JHm5783m; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JHm5783m"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261003233839euoutp019b93e0a38d74f7844d866dcf976a036b~bKVRYyCTw2859728597euoutp01F;
	Sat,  3 Oct 2026 23:38:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261003233839euoutp019b93e0a38d74f7844d866dcf976a036b~bKVRYyCTw2859728597euoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791070719;
	bh=DCSSTKMktb+HuS50/2vCoVXjx6kQyokLqg66BRCB0B4=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=JHm5783mcsClVTOaAWZXZGUM5Mak3g4ei3h3Phsta5hYe2YrnBr40qBI7wEY0xmvN
	 UMD5Hqg1kFQ/WCC4EuAuxIXk8MsORKJXSu+n5fnbc6nyJUT/p+4BAj2I/JULzrOMYS
	 TIDbvU8ViajQeQ9onvYQmblwNgBjnxB65Btm5B/c=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261003233838eucas1p237c405e495deb98ca1ab7bffb909923a~bKVQa7ruV0031900319eucas1p2V;
	Sat,  3 Oct 2026 23:38:38 +0000 (GMT)
Received: from [192.168.1.44] (unknown [106.210.136.40]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261003233836eusmtip19df22b79e12bcb1dd0f2058e4a99ebb4~bKVO0uuxI2102321023eusmtip1C;
	Sat,  3 Oct 2026 23:38:36 +0000 (GMT)
Message-ID: <d60a30e1-7e9d-4061-a61f-d50909665c19@samsung.com>
Date: Sun, 4 Oct 2026 01:38:36 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 7/9] lib/lz4: switch the decompressor to the
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
In-Reply-To: <arnpj53cgDErAQEz@google.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261003233838eucas1p237c405e495deb98ca1ab7bffb909923a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260925113504eucas1p25e50de59c02681fc1385220be8acd184
X-EPHeader: CA
X-CMS-RootMailID: 20260925113504eucas1p25e50de59c02681fc1385220be8acd184
References: <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
	<CGME20260925113504eucas1p25e50de59c02681fc1385220be8acd184@eucas1p2.samsung.com>
	<20260925-lz4-vendor-upstream-v1-7-1c7ffbe21c4b@samsung.com>
	<arnpj53cgDErAQEz@google.com>



On 9/28/26 06:16, Sergey Senozhatsky wrote:
> On (26/09/25 13:27), Michal Wilczynski wrote:
> [..]
>> -static FORCE_INLINE int LZ4_decompress_generic(
> [..]
>> -			/* Necessarily EOF when !partialDecoding.
>> -			 * When partialDecoding, it is EOF if we've either
>> -			 * filled the output buffer or
>> -			 * can't proceed with reading an offset for following match.
>> -			 */
>> -			if (!partialDecoding || (cpy == oend) || (ip >= (iend - 2)))
>> -				break;
> 
> Worth noting, these lines are downstream commit eafc0a02391b
> (lz4: fix LZ4_decompress_safe_partial read out of bound).
> 
> Is this intended or are we "loosing" some of the downstream fixes?
> 

Yeah it's intended, eafc0a02391b was itself a backport of upstream
c5d6f8a8be39  which is in v1.9.3 and later; its own commit message links
it. The same check is at lib/lz4/upstream/lz4.c in this series.

And upstream's version also clamps a literal run that would read past
the end of the input, which the backport didn't take.

Best regards,
-- 
Michal Wilczynski <m.wilczynski@samsung.com>
