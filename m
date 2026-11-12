Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.118.77.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794485218;
	b=ageX1cOpBdd4p/KIz+nIzsiZpfwJjlqASMo0x2cp31P0nwlB6S0QfUwlhPt4k/KuVFET
	 R65/ssM064qJsF2dSBFqr0uYjmoFeyhEmHQ4lw5XdRYQ/TBP2aS9x+X6X333jFx6sNaD9
	 Aw+AgtqSxp+GrBDCgQhT03dyS9a72rQtwBKOPD9duLH0pHDecdXuOxKxtUtC55/YJnEWX
	 90svn6T/Sok1kcOu6U+wGaRDo9bvwYAsGLDU+1Kg6p3uCUSuHTylxFr7v0i1pEU9Fjtfh
	 dNvn8CuVbo7b4O/AQ27A35eTzoES8gNy2TV85pTAOvzuB63UnmiMmm2hH+Hrlxy6zkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794485218;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 Content-Language:From:In-Reply-To:Content-Transfer-Encoding:
	 X-CMS-MailID:X-Msg-Generator:Content-Type:X-RootMTR:X-EPHeader:
	 X-CMS-RootMailID:References;
	bh=3Ng2wYSW6+d3+F9nDyhML8DvJgaVLNMXoO8xfsPtTcI=;
	b=5h6nrvqrCeWQ+gixQ1bLjJQGULNi7AH6kmzXpjPzsuMnGjxmdftRluaQPT4xDCoTqIlV
	 sq3DEfYdUWqadsUIi+nx7cpeHyvSaIKeemfvoOOHdA03uGLi55015j2++mO/BribqMhuD
	 wgj7eiYf8VT9+ODvhqca9eSWiTA/zxbzvD9TfhDUpjiXHfNCOhXnnkhi6sJawUguG/cN2
	 xXVadnP4YwDlTW2p3LZMuPgeghrd8/DjG3+c9TvVankcPxLGsALnxhAv2sYpLuSIQVkXe
	 3RiIymFHYiODImMJocf3yAaPQY+6saJZ5Tij1gTJ20SR0xPXsX6E8zRF4yU6mqzffxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=nR+r+VBD;
	arc=none smtp.remote-ip=210.118.77.12
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E234A606A327;
	Thu, 12 Nov 2026 12:06:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E234A606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=nR+r+VBD
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20261112120650euoutp023394506fcbdf2a5d3fc56ab466d5f422~nSsqNDOqh0675106751euoutp02X;
	Thu, 12 Nov 2026 12:06:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20261112120650euoutp023394506fcbdf2a5d3fc56ab466d5f422~nSsqNDOqh0675106751euoutp02X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794485210;
	bh=3Ng2wYSW6+d3+F9nDyhML8DvJgaVLNMXoO8xfsPtTcI=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=nR+r+VBDOV4dVPVZ6tVQVAV+2ufcN1J8T2VQozNQKBTjeh1k71ccWpdHsHNgI8C7r
	 CM7J2sePfPZZOiXnXMfytIDh2ES0EF9kB9rcJXE5tsaTcDudkOHHpGSzUVEgKo5+QX
	 Epi4ngn19K3aDJSY4rfpKYKsTXWEmx79MdJPM+6M=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261112120649eucas1p2065df671e614cc14e86e0a5504215744~nSspZAxiA2721327213eucas1p2v;
	Thu, 12 Nov 2026 12:06:49 +0000 (GMT)
Received: from [192.168.1.44] (unknown [106.210.136.40]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261112120647eusmtip1e71d40cb998922386d7f896a16ce37a9~nSsnwl8x91412914129eusmtip15;
	Thu, 12 Nov 2026 12:06:47 +0000 (GMT)
Message-ID: <450cbb3b-6118-4b1d-9a71-7f0ea98030ed@samsung.com>
Date: Thu, 12 Nov 2026 13:06:47 +0100
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
Subject: Re: [PATCH v2 13/15] lib/lz4: switch the decompressor to the
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
	<chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Eric Biggers
	<ebiggers@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, David
	Laight <david.laight.linux@gmail.com>, Sungguk <sungguk.na@samsung.com>,
	Jaehoon Chung <jh80.chung@samsung.com>, Marek Szyprowski
	<m.szyprowski@samsung.com>, linux-erofs@lists.ozlabs.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org
Content-Language: en-US
From: Michal Wilczynski <m.wilczynski@samsung.com>
In-Reply-To: <avKtyCOOmK3AH0xy@google.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261112120649eucas1p2065df671e614cc14e86e0a5504215744
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261106144310eucas1p1d60fe5c2e0170c49f38a3142bb1d8f94
X-EPHeader: CA
X-CMS-RootMailID: 20261106144310eucas1p1d60fe5c2e0170c49f38a3142bb1d8f94
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
	<CGME20261106144310eucas1p1d60fe5c2e0170c49f38a3142bb1d8f94@eucas1p1.samsung.com>
	<20261106-lz4-vendor-upstream-v2-13-ee04c3f0d7dc@samsung.com>
	<avKtyCOOmK3AH0xy@google.com>



On 11/10/26 06:39, Sergey Senozhatsky wrote:
> On (26/11/06 15:42), Michal Wilczynski wrote:
> [..]
>> diff --git a/drivers/block/zram/backend_lz4.c b/drivers/block/zram/backend_lz4.c
>> index 50265e3ce256490994cb6dae32a45da376e408e0..b9b8a5f678c155442fa3fd2c1984e45182e6fc38 100644
>> --- a/drivers/block/zram/backend_lz4.c
>> +++ b/drivers/block/zram/backend_lz4.c
>> @@ -84,7 +84,7 @@ static int lz4_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
>>  		if (!zctx->mem)
>>  			goto error;
>>  	} else {
>> -		zctx->dstrm = kzalloc_obj(*zctx->dstrm);
>> +		zctx->dstrm = kzalloc(LZ4_MEM_DECOMPRESS, GFP_KERNEL);
>>  		if (!zctx->dstrm)
>>  			goto error;
>>  
>> diff --git a/drivers/block/zram/backend_lz4hc.c b/drivers/block/zram/backend_lz4hc.c
>> index e7ee3740219852f079d1e0866da6b213a3f3a583..1e09c93016264259c149e2913b2819571b56fab6 100644
>> --- a/drivers/block/zram/backend_lz4hc.c
>> +++ b/drivers/block/zram/backend_lz4hc.c
>> @@ -65,7 +65,7 @@ static int lz4hc_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
>>  		if (!zctx->mem)
>>  			goto error;
>>  	} else {
>> -		zctx->dstrm = kzalloc_obj(*zctx->dstrm);
>> +		zctx->dstrm = kzalloc(LZ4_MEM_DECOMPRESS, GFP_KERNEL);
>>  		if (!zctx->dstrm)
>>  			goto error;
> 
> Ditto, outdated zram code.
> 
> My ask would be to not squash zram changes with lz4 changes, when (iff)
> possible.
> 

Will do.
The zram changes will go into a separate zram patch ahead of the lib/lz4
ones.

Best regards,
-- 
Michal Wilczynski <m.wilczynski@samsung.com>
