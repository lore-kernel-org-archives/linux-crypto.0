Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD8138A700
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 15:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777390559; cv=none; b=O55gZXN6exKxaJzVmVvxdBoYOuYaf/v2eYF9oSlOHqYvoSFodnXlIY2U4NdRlSkcsgoO10Mn8pchX0NO1VpSrUH1rssux9uTfOyUUq7XbqEXbWXcxVME9QufqviwL0C8ehjJ9Bey07fg8LRYDcm8lcsoOAZhdBWxpY3kyJoGQMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777390559; c=relaxed/simple;
	bh=G10OdTj5uGoKjMrSmDwKHW0y+AArB76+PtZcnNoU1cA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dpqZb+x8WWhC8jdOZsnU5Ksae2iLV0dXzVIMID1IkPejx6R2BgZfRKQOUo/oBu6d8jeLDHjQke/BLjCbH75pZXeSHCAb7YAXvVEc3fpuYZ5ZaK4J3oB0HIBcmSDKkFs6QfVBV1F3wOgGNZ6h245XEv3gvWISFcj2fqa81wLu0P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Jp4pZC7o; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Jp4pZC7o"
Date: Tue, 28 Apr 2026 17:35:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777390545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jR4cgZeFLErX6+TlH0KG8dQlhjBaSWwePuNo/GcLCsA=;
	b=Jp4pZC7obK8gwHpXdnaTYj+czm/TyoII1x9VN4A2dnIhI/VIfvHEK8lswoKbUTzybWJ6oL
	54aHUafH8ghtSxf9FiCdEJUwNiv21yGyEb59SnFHu1n0RJxmudL/QkdAUPaE0ZA+u0YlwA
	ItXj0N9aeOpfCNVss3Yg4xtr/MPlP1A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Lothar Rubusch <l.rubusch@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev, ardb@kernel.org, linusw@kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] crypto: atmel-sha204a - fix truncated 32-byte
 blocking read
Message-ID: <afDTzL9zsSTaZtZD@linux.dev>
References: <20260422210936.20095-1-l.rubusch@gmail.com>
 <20260422210936.20095-3-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422210936.20095-3-l.rubusch@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 22, 2026 at 09:09:35PM +0000, Lothar Rubusch wrote:
> The ATSHA204A returns a 35-byte packet consisting of a 1-byte count,
> 32 bytes of entropy, and a 2-byte CRC. The current blocking read
> implementation was incorrectly copying data starting from the
> count byte, leading to offset data and truncated entropy.
> 
> Additionally, the chip requires significant execution time to
> generate random numbers, going by the datasheet. Reading the I2C bus
> too early results in the chip NACK-ing or returning a partial buffer
> followed by zeros.
> 
> Verification:
> Tests before showed repeadetly reading only 8 bytes of entropy:
> $ head -c 32 /dev/hwrng | hexdump -C
> 00000000  02 28 85 b3 47 40 f2 ee  00 00 00 00 00 00 00 00  |.(..G@..........|
> 00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 00000020
> 
> After this patch applied, the result will be as follows:
> $ head -c 32 /dev/hwrng | hexdump -C
> 00000000  5a fc 3f 13 14 68 fe 06  68 0a bd 04 83 6e 09 69  |Z.?..h..h....n.i|
> 00000010  75 ff cf 87 10 84 3b c9  c1 df ae eb 45 53 4c c3  |u.....;.....ESL.|
> 00000020
> 
> Fix these issues by:
> Increase cmd.msecs to 30ms to provide sufficient execution time. Then
> set cmd.rxsize to RANDOM_RSP_SIZE (35 bytes) to capture the entire
> hardware response. Eventually, correct the memcpy() offset to index 1 of
> the data buffer to skip the count byte and retrieve exactly 32 bytes of
> entropy.
> 
> Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
> ---
>  drivers/crypto/atmel-sha204a.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
> index 19720bdd446d..f7dc00d0f4cd 100644
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -19,6 +19,9 @@
>  #include <linux/workqueue.h>
>  #include "atmel-i2c.h"
>  
> +#define ATMEL_RNG_BLOCK_SIZE 32
> +#define ATMEL_RNG_EXEC_TIME 30

Maybe I missed it, but how did you arrive at 30 ms from the datasheet?

Thanks,
Thorsten
