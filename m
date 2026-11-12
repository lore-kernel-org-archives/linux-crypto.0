Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.118.77.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794484208;
	b=qRZSthehiICNPVprnN0gHqkaNggBaj1x0R6vcY8dxGVXF3xKQXWat+tSayw/FRx6ooig
	 UvFUXd1ryz0VrRV3Wp7URGxN5zWH1Uu5HlS2skRQbndRo5JM1WAcBJ02fd2ahKycmRUuU
	 Pcg1sYEJGq2aqHed1ALQDzGgojDtXcGKSYWbYeNK3K/27QfqLmUY+sjf9gPvlXcv3lybW
	 nblr0FKk+9mleVhqk2ZOx4cNYMVb+2h2Ul7ibRg5Fs/Eu4qrIkAvPvv/wE7/fTJtKXOjn
	 agIFXd6x5wzPFcNlpKMIrph966+32RNIKlMd/Jsx+5Qj0EzIS+LwPAfW75rrDPsWuBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794484208;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 Content-Language:From:In-Reply-To:Content-Transfer-Encoding:
	 X-CMS-MailID:X-Msg-Generator:Content-Type:X-RootMTR:X-EPHeader:
	 X-CMS-RootMailID:References;
	bh=Y1DkdK48Xnp7vfevJCGquLuztwnwhnHgqI63IQ/k7p8=;
	b=wD3Orkf72OAdd6Uh3LzTaRUuMZqJ9+taLtFoItTsPjEuPhpp/Hyve+pTvoyHwMoc0R3d
	 2Lxhs4ea3UPMpGEEYlu5LnmHE8Af9Qar6n6qA/tBDEG9w4yTxlSCVOpX2n/Sh0+RO0y5Z
	 Z1QQGsEFWtDDkQu7pf7ojCtMMf9geYaSHjq0NjdDSi+paPFgUTAlWXaHkSimMdBvV8eB6
	 DZ69Pi6JxpttTKpEixGxCGZMHpoUD56CPlDdx++gLK0gZJTP6tBvcl4uQRJRm00Tiw8Fa
	 OrK84LjKT+zmA6D3KJwrNtgvHoXwx4xwZwqZZ7hg0EDdI55QN5zUW9I44cs0XC8ANVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=RvQ68wl1;
	arc=none smtp.remote-ip=210.118.77.11
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26A7606A321;
	Thu, 12 Nov 2026 11:50:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E26A7606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=RvQ68wl1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261112115004euoutp01097292e7ae21e5e37f1087780829ed90~nSeBx9XPu3249632496euoutp01n;
	Thu, 12 Nov 2026 11:50:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261112115004euoutp01097292e7ae21e5e37f1087780829ed90~nSeBx9XPu3249632496euoutp01n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794484204;
	bh=Y1DkdK48Xnp7vfevJCGquLuztwnwhnHgqI63IQ/k7p8=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=RvQ68wl1U3qESoNVCuQUGyiyIfaNWCHYP1CNXcF+brxHCVeBy6KR97gpchCpx9iJq
	 90l1wzn0qYwPoNTXMO0DMbwDiHQ4Uw1U/7fDn5TPgan/wGVnhM5Eh4ZwWx+Gs6kMfH
	 c1VN7qorE8gyJMvtqMBWKPxW6bm4RYU6F9gNrCHA=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261112115004eucas1p1ef74480795d4b0447b2f5fc9b5d9e528~nSeBeNxz42728927289eucas1p1f;
	Thu, 12 Nov 2026 11:50:04 +0000 (GMT)
Received: from [192.168.1.44] (unknown [106.210.136.40]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261112115003eusmtip2a3ff1ea0c43c9febebf9d2d008bea473~nSeAHeWqa3153931539eusmtip2g;
	Thu, 12 Nov 2026 11:50:03 +0000 (GMT)
Message-ID: <92566ded-cc28-4cc6-9899-cf2421045455@samsung.com>
Date: Thu, 12 Nov 2026 12:50:02 +0100
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
Subject: Re: [PATCH v2 03/15] zram: lz4hc: reset the dictionary stream once,
 not per page
To: Sergey Senozhatsky <senozhatsky@chromium.org>,
	sashiko-reviews@lists.linux.dev
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
	linux-s390@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>, Nick
	Terrell <terrelln@meta.com>, Gao Xiang <xiang@kernel.org>, Chao Yu
	<chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Eric Biggers
	<ebiggers@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, David
	Laight <david.laight.linux@gmail.com>, Sungguk <sungguk.na@samsung.com>,
	Jaehoon Chung <jh80.chung@samsung.com>, Marek Szyprowski
	<m.szyprowski@samsung.com>, linux-crypto@vger.kernel.org
Content-Language: en-US
From: Michal Wilczynski <m.wilczynski@samsung.com>
In-Reply-To: <avKrj0h8fBNSrfCi@google.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261112115004eucas1p1ef74480795d4b0447b2f5fc9b5d9e528
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261106144252eucas1p272c9e37d66ad385db070f941879aecb1
X-EPHeader: CA
X-CMS-RootMailID: 20261106144252eucas1p272c9e37d66ad385db070f941879aecb1
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
	<CGME20261106144252eucas1p272c9e37d66ad385db070f941879aecb1@eucas1p2.samsung.com>
	<20261106-lz4-vendor-upstream-v2-3-ee04c3f0d7dc@samsung.com>
	<sashiko-outbox-201613@kernel.org> <avKrj0h8fBNSrfCi@google.com>



On 11/10/26 06:31, Sergey Senozhatsky wrote:
> On (26/11/06 14:49), sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found no new issues
>> in this patch, but noticed 1 related pre-existing issue it does not
>> introduce:
>> - [Medium] zram: high-order memory allocation using kzalloc in
>>   lz4hc_create() [1]
>> --
>>
>> commit 2f51683dc7418bdcd0730283cb7003d8754fcd5f
>> Author: Michal Wilczynski <m.wilczynski@samsung.com>
>>
>> zram: lz4hc: reset the dictionary stream once, not per page
>>
>> This commit moves the LZ4_resetStreamHC() call for dictionary-backed
>> streams from lz4hc_compress() to lz4hc_create() so that the stream state is
>> only reset once at creation time rather than on every compressed page.
>>
>>> diff --git a/drivers/block/zram/backend_lz4hc.c b/drivers/block/zram/backend_lz4hc.c
>>> index d8aa01bb258fe..06286c805cf7c 100644
>>> --- a/drivers/block/zram/backend_lz4hc.c
>>> +++ b/drivers/block/zram/backend_lz4hc.c
>>> @@ -72,6 +72,7 @@ static int lz4hc_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
>>>  		zctx->cstrm = kzalloc_obj(*zctx->cstrm);
>>>  		if (!zctx->cstrm)
>>>  			goto error;
>>> +		LZ4_resetStreamHC(zctx->cstrm, params->level);
>>>  	}
>>
>> [Severity: Medium]
>> This problem wasn't introduced by this patch, but should zctx->cstrm be
>> allocated with vmalloc() or kvzalloc() instead of kzalloc_obj() [1]?
> 
> That's how I have it in my local tree - vmalloc(LZ4HC_MEM_COMPRESS).
> Michal, I suppose you don't base the series on top of linux-next or
> Andrew's tree?

No it's based on v7.3-rc4. I'll rebase v3 on linux-next.

> 
> We reset the stream when we setup params, so I don't think we need
> to do anything in lz4hc_create().
> 

Agree your change covers it. I'll drop this patch.

Thank you for having a look.


Best regards,
-- 
Michal Wilczynski <m.wilczynski@samsung.com>
