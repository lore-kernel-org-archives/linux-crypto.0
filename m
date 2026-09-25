Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E053A7593;
	Fri, 25 Sep 2026 21:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790372370; cv=none; b=p14oiv40vGTADF2MCDf89gemNgQRRjexRh5nYMev36Mcujtbh/Cctsv5QUzncftpagW5IhWbkAEJ/QHAFQqh2z+txDW3i3kcP3VjR968BuTZRNmlryBp6/I9g6QopWd+cuDQ7+JZhlb9pRMarCP1XTiQQx1bKeMCN+geYETiM2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790372370; c=relaxed/simple;
	bh=3BiBwcUDkbh+FbP7ofxpEUfVhiDKAwkXAcXzUYOr06U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GL4R13lzTgNPhZoc8xSXmQeNJ4NZlY4wnmx33j3/VC5PQevoPchBY1KMbXjj+N7qUqTn8bVtnv24b6fuT396aiGktZP9Eli5I9gFw8omTFc1ZT7+sIfKlYyRkEDNT5+5rWPaCt4MkUqwXin6KHn/Etw8EGVS8SrVsp8QKIIHJFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uq3jK6lz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uq3jK6lz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CA41F000FF;
	Fri, 25 Sep 2026 21:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790372368;
	bh=qGAVtFU1ZWDmCtLaT+G7B5o5ljsTh3nqCzq4ca6rlME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Uq3jK6lzFPBk2mUB+21kzIEJ3e7xo6lES0MeUECU8KDNeBmretRa77Q3OlwhtoQmE
	 JG8Dx0lTEjtjm2k8juBgSTzHaF2rroNVk1zww7OONmnk0v+x0FA56wC0MjZCrNSV/e
	 H2pVr0Zo24UJv/vG9L8beZRRHMlmE7YAN/RF7/BIf3sCxDQZGCKJr+E+v3UjzyyNbI
	 MirHao5U2KikMGzvv4h38MAzkcRcWP7PU8EZ2aiQo71N4cAbsRUfMEcbTXCJ/xYXPz
	 HyiCZr2awcrNsxXI7Kdq8YVAeSXWzjieQzGLgVnG89GGjnkOohpJbH4QMHQxQzDjRf
	 Ccal7IQ4ASL7g==
Date: Fri, 25 Sep 2026 14:39:26 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Michal Wilczynski <m.wilczynski@samsung.com>
Cc: Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Russell King <linux@armlinux.org.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-block@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>,
	Nick Terrell <terrelln@meta.com>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Sungguk <sungguk.na@samsung.com>,
	Jaehoon Chung <jh80.chung@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-erofs@lists.ozlabs.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH RFC 9/9] MAINTAINERS: add an entry for the LZ4
 compression library
Message-ID: <20260925213926.GA1903@quark>
References: <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
 <CGME20260925113507eucas1p2ddb94f2077b679426aa86dd1d492eaf3@eucas1p2.samsung.com>
 <20260925-lz4-vendor-upstream-v1-9-1c7ffbe21c4b@samsung.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925-lz4-vendor-upstream-v1-9-1c7ffbe21c4b@samsung.com>

On Fri, Sep 25, 2026 at 01:27:39PM +0200, Michal Wilczynski wrote:
> lib/lz4/ has never had one: get_maintainer.pl returns only the LKML
> fallback for every file in it, including include/linux/lz4.h, which eight
> subsystems build against.
> 
> This matters more now than it did. With the previous patches lib/lz4 is
> vendored upstream sources, and someone has to bump them to new upstream
> releases and decide what the kernel-side glue may do. I am willing to do
> that, so add myself as its maintainer.
> 
> Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
> ---
>  MAINTAINERS | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index cc3cae2e378b34aeb705cef654c720ca9f2ba223..989e1b5fab21432dd7042d1e60c4bbad85beb925 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15606,6 +15606,12 @@ S:	Supported
>  F:	drivers/net/pcs/pcs-lynx.c
>  F:	include/linux/pcs-lynx.h
>  
> +LZ4 COMPRESSION LIBRARY
> +M:	Michal Wilczynski <m.wilczynski@samsung.com>
> +S:	Maintained
> +F:	include/linux/lz4.h
> +F:	lib/lz4/
> +

Should this entry cover lib/decompress_unlz4.c and
include/linux/decompress/unlz4.h as well?

- Eric
