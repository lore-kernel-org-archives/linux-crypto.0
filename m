Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC37535F5E4;
	Thu, 16 Apr 2026 21:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776373849; cv=none; b=VG1Unz8Ua3wSwgqoSq1AV6Edf1kn5qi++RXFg5EwEt6uN5IrVAq5jDH7PZIecUSqZxVqObg3Hc5lFrw5SsMP1DGH6SrtvO5UndLuPWMo0xpZ4ABvmLdPbFHGs7rBJdWEmpcE3l5GAERdj+WUomwDpZtvkK4KWnlgi6IQhu2nOL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776373849; c=relaxed/simple;
	bh=tK+Us+60ypdY+8xy5NOzQFC4IGCqHJkoia9xZDAS33s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B3uhsZYRKMVldKCP0gLJ67djskyO4Bxj0oonFH+pPBn1s4amtodhfFVQ/wNsXF6y20eqfVYu+XWKpEbF1oBcZeA1WYsy8dZIGAD9pQDdznHavZh9ybaP6HZ3G6ZO0HXDIk9T8wsKX3JcgDnKwnwgMdOBiha67q9Vg1mIDmbvJeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dqnX6oTM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dqnX6oTM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=pF+hcvOM+pTk5+aFxrJQ1Z7u1BA1J9lewId/mfJhv9E=; b=dqnX6oTMdHn41jQw2G4I273stF
	o56JClDlwBgxP2oSZVA0wzadjEHwaZk03eXaAihQuBInpeJ6tb/80sZ+RbWSdXjk87ded4A1pWFna
	DNJO0swuxArVAEF7YbVeEs3SXvV3VtAdnNdm+x/MZ7a1r5t6XaPpKyCh01uv6B8S1hUzxHIEQ/jyi
	0oGnFS9cb1GB9CFSV/os9rNnkkbowU6kG31EDPPqX0OqBZBqoHV1LLBAm8HhZxCG44G9t9imQYSP0
	9CsWRFFcc1ej4SA2EmAffaOvtrLkjb4C2V3UtSqpz009qqXubJkPsGiGfeAHglqcuFXxgR5mBxYJd
	sJRzq/Fw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wDTz0-000000033AF-1ZYy;
	Thu, 16 Apr 2026 21:10:42 +0000
Message-ID: <491d3249-1995-4499-9dc2-150e0fd2acef@infradead.org>
Date: Thu, 16 Apr 2026 14:10:40 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: staging: fix various typos and grammar issues
To: Zhang Xiaolei <zxl434815272@gmail.com>, corbet@lwn.net,
 ebiggers@kernel.org, andersson@kernel.org, mathieu.poirier@linaro.org
Cc: ardb@kernel.org, skhan@linuxfoundation.org, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-remoteproc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260416105854.788-1-zxl434815272@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260416105854.788-1-zxl434815272@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/16/26 3:58 AM, Zhang Xiaolei wrote:
> Fix a few typographical and grammatical issues across several
> staging documentation files to improve readability:
> - crc32.rst: replace "decide in" with "decide on"
> - lzo.rst: replace "independent on" with "independent of"
> - remoteproc.rst: fix word order in dependent clause
> - static-keys.rst: add hyphen to "low-level"
> 
> Signed-off-by: Zhang Xiaolei <zxl434815272@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

> ---
>  Documentation/staging/crc32.rst       | 2 +-
>  Documentation/staging/lzo.rst         | 2 +-
>  Documentation/staging/remoteproc.rst  | 2 +-
>  Documentation/staging/static-keys.rst | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/staging/crc32.rst b/Documentation/staging/crc32.rst
> index 64f3dd430a6c..fc0d9564b99c 100644
> --- a/Documentation/staging/crc32.rst
> +++ b/Documentation/staging/crc32.rst
> @@ -119,7 +119,7 @@ the byte-at-a-time table method, popularized by Dilip V. Sarwate,
>  v.31 no.8 (August 1988) p. 1008-1013.
>  
>  Here, rather than just shifting one bit of the remainder to decide
> -in the correct multiple to subtract, we can shift a byte at a time.
> +on the correct multiple to subtract, we can shift a byte at a time.
>  This produces a 40-bit (rather than a 33-bit) intermediate remainder,
>  and the correct multiple of the polynomial to subtract is found using
>  a 256-entry lookup table indexed by the high 8 bits.
> diff --git a/Documentation/staging/lzo.rst b/Documentation/staging/lzo.rst
> index f65b51523014..2d48b2667dd2 100644
> --- a/Documentation/staging/lzo.rst
> +++ b/Documentation/staging/lzo.rst
> @@ -75,7 +75,7 @@ Description
>       are called under the assumption that a certain number of bytes follow
>       because it has already been guaranteed before parsing the instructions.
>       They just have to "refill" this credit if they consume extra bytes. This
> -     is an implementation design choice independent on the algorithm or
> +     is an implementation design choice independent of the algorithm or
>       encoding.
>  
>  Versions
> diff --git a/Documentation/staging/remoteproc.rst b/Documentation/staging/remoteproc.rst
> index 5c226fa076d6..c117b060e76c 100644
> --- a/Documentation/staging/remoteproc.rst
> +++ b/Documentation/staging/remoteproc.rst
> @@ -24,7 +24,7 @@ handlers, and then all rpmsg drivers will then just work
>  (for more information about the virtio-based rpmsg bus and its drivers,
>  please read Documentation/staging/rpmsg.rst).
>  Registration of other types of virtio devices is now also possible. Firmwares
> -just need to publish what kind of virtio devices do they support, and then
> +just need to publish what kind of virtio devices they support, and then
>  remoteproc will add those devices. This makes it possible to reuse the
>  existing virtio drivers with remote processor backends at a minimal development
>  cost.
> diff --git a/Documentation/staging/static-keys.rst b/Documentation/staging/static-keys.rst
> index b0a519f456cf..e8dc3a87c381 100644
> --- a/Documentation/staging/static-keys.rst
> +++ b/Documentation/staging/static-keys.rst
> @@ -90,7 +90,7 @@ out-of-line true branch. Thus, changing branch direction is expensive but
>  branch selection is basically 'free'. That is the basic tradeoff of this
>  optimization.
>  
> -This lowlevel patching mechanism is called 'jump label patching', and it gives
> +This low-level patching mechanism is called 'jump label patching', and it gives
>  the basis for the static keys facility.
>  
>  Static key label API, usage and examples

-- 
~Randy
