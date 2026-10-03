Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A073AEF45;
	Sat,  3 Oct 2026 22:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791067515; cv=none; b=gON947QdjuPuU2zGXsYPF21cOiGZUF+wWISRoUsSBD1FJBj/ZXr1dWxyWTRAShgwZEU+LMODly4dS6sRbMNfU5KqRjM+Z7eYKxUWGU4h8NAwd1KfsbbAmMh7DYlE0PyKM5y25l9tl98NLGdFmoXP4wc5pgaNYfAEqezEiJLDXPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791067515; c=relaxed/simple;
	bh=W21SRaEwpj9rNXOhq+Ty48iMmU1uKpvKeWtWaSSd1JM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=bR9s/8S8Hd7D9keLFi6OXHvF9fI6mclT5+W+Azyuh98MyH74vfpYjz+9KQprVuKTz/dFsQZMtmHPxQhIj0StJ5yN1Xa+YxRzmtaFwPOaqAtww88OSFFPBJO57WLh7aFtyMvRBuegolFTaz+UTuMvDb/4o5ZyckuS43rCpF2pf3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=RLbFDHwu; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RLbFDHwu"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20261003224508euoutp02c41c30b489eaee9363e860f2478d6027~bJmji_WXc2979329793euoutp02u;
	Sat,  3 Oct 2026 22:45:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20261003224508euoutp02c41c30b489eaee9363e860f2478d6027~bJmji_WXc2979329793euoutp02u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791067508;
	bh=vFhGMCg6Ji/JXdFQ3B6wXXIZQgQ9xvpb3HvqRmvxgSk=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=RLbFDHwuh3NRChlB5DbAnpf5fbQ/9VI4LqGu4llTjFUiXPQ562rniZUJozx7F6f0C
	 O998yLIejmOOpMfO2undeRdQGMIbbwvHHW6qvrglXgdLXRekz3Vq8zAZ0mrAGgSxG4
	 yLsO68CPN7a6ZuBi2t//4zMj/AdCV8fhYFGTexlA=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261003224507eucas1p200ece20a05f4aac2eeb0180f041df0fe~bJmigAu1f3080530805eucas1p2D;
	Sat,  3 Oct 2026 22:45:07 +0000 (GMT)
Received: from [192.168.1.44] (unknown [106.210.136.40]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261003224505eusmtip1f6ac4f841c43fd74cce4c31cdfba487f~bJmg3wbbL2072920729eusmtip1D;
	Sat,  3 Oct 2026 22:45:05 +0000 (GMT)
Message-ID: <9c5913c0-11c8-4db8-844b-ea2ef29bf5db@samsung.com>
Date: Sun, 4 Oct 2026 00:45:05 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 9/9] MAINTAINERS: add an entry for the LZ4
 compression library
To: Eric Biggers <ebiggers@kernel.org>
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
	"H. Peter Anvin" <hpa@zytor.com>, Minchan Kim <minchan@kernel.org>, Sergey
	Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, Andrew
	Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-block@vger.kernel.org, Yann Collet
	<yann.collet.73@gmail.com>, Nick Terrell <terrelln@meta.com>, Gao Xiang
	<xiang@kernel.org>, Chao Yu <chao@kernel.org>, Jaegeuk Kim
	<jaegeuk@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, Phillip
	Lougher <phillip@squashfs.org.uk>, Sungguk <sungguk.na@samsung.com>, Jaehoon
	Chung <jh80.chung@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-crypto@vger.kernel.org
Content-Language: en-US
From: Michal Wilczynski <m.wilczynski@samsung.com>
In-Reply-To: <20260925213926.GA1903@quark>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261003224507eucas1p200ece20a05f4aac2eeb0180f041df0fe
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260925113507eucas1p2ddb94f2077b679426aa86dd1d492eaf3
X-EPHeader: CA
X-CMS-RootMailID: 20260925113507eucas1p2ddb94f2077b679426aa86dd1d492eaf3
References: <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
	<CGME20260925113507eucas1p2ddb94f2077b679426aa86dd1d492eaf3@eucas1p2.samsung.com>
	<20260925-lz4-vendor-upstream-v1-9-1c7ffbe21c4b@samsung.com>
	<20260925213926.GA1903@quark>



On 9/25/26 23:39, Eric Biggers wrote:
> On Fri, Sep 25, 2026 at 01:27:39PM +0200, Michal Wilczynski wrote:
>> lib/lz4/ has never had one: get_maintainer.pl returns only the LKML
>> fallback for every file in it, including include/linux/lz4.h, which eight
>> subsystems build against.
>>
>> This matters more now than it did. With the previous patches lib/lz4 is
>> vendored upstream sources, and someone has to bump them to new upstream
>> releases and decide what the kernel-side glue may do. I am willing to do
>> that, so add myself as its maintainer.
>>
>> Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
>> ---
>>  MAINTAINERS | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index cc3cae2e378b34aeb705cef654c720ca9f2ba223..989e1b5fab21432dd7042d1e60c4bbad85beb925 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -15606,6 +15606,12 @@ S:	Supported
>>  F:	drivers/net/pcs/pcs-lynx.c
>>  F:	include/linux/pcs-lynx.h
>>  
>> +LZ4 COMPRESSION LIBRARY
>> +M:	Michal Wilczynski <m.wilczynski@samsung.com>
>> +S:	Maintained
>> +F:	include/linux/lz4.h
>> +F:	lib/lz4/
>> +
> 
> Should this entry cover lib/decompress_unlz4.c and
> include/linux/decompress/unlz4.h as well?

Yes I'll add both in v2.
Thanks a lot for looking at the series as a whole.

> 
> - Eric
> 

Best regards,
-- 
Michal Wilczynski <m.wilczynski@samsung.com>
