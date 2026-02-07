Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3539B3385A5
	for <linux-crypto@vger.kernel.org>; Sat,  7 Feb 2026 10:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770461494; cv=none; b=dq7fgI0hkwCc4+ydSo5Vyx3/mG/cgJXLihlDLnMIpezMoIdghqHWCmTVj+UFz8tQsIgC3Hxl1la3/4BkakJ/oHXmY/3YcGfpWtj7ZWyMaHMFBFJh+dS0qr+C7iuwx/E5aQw2p1AyDg5pG0sWC13qRX4+KExLLmU3ywvfAq1lKJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770461494; c=relaxed/simple;
	bh=A0+LTYwmCZ5W+zWmCdj1Npm0Zc4Pqtj1TsfF0hQZTTE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EL0XPqGp3wxeMMmKF/kboUS3RxM38cCp+6BRsbE47FlEhFJCtIjqOeniJxyX2uQdJ5myaRMCFy7VOz0DM9ekuoXRjSyO4cmuwOK4olkss0CFVGTS41GrAJygTEOdMdHF+wgvnW3TOXcat0CoLU4OEQQOffnOCIDANG13R70hABY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i67EnGop; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i67EnGop"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48039fdc8aeso18699985e9.3
        for <linux-crypto@vger.kernel.org>; Sat, 07 Feb 2026 02:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770461492; x=1771066292; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fs1tDxIIOk0nugOD7PhyByb/8VSovdwAxjrX3UDxXC4=;
        b=i67EnGopS7UZNEh5p6ydzxPUSa9LDHRzSB2r0gRkb9XUENehPDiczm1eLDGXF9sjl+
         PuvDiKbt2iVDIbkOg0v4CTPkgJ84e3GHQYM9UINTW8Fu7PNhBalUy+IlzwF5PKiecRm7
         SItpto1zCuuaJrMHYgcObAXXGMfsz4sS+rfqMHRJFno5h6NxSv2/jucHF17Q3q7xPDZ+
         aJ/8bGfgmTMl9n9xqT6P/FbFsmUDLHM5w/4qcIWpW3/zT9/inA2aX866XyjQOr1sPpc7
         SKUWCdKtnuEFDfzR27hClXaTptucjDGR5kcfyztODu7VdoM7I1d7ELcHr8Fyu90OfBOj
         XTjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770461492; x=1771066292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fs1tDxIIOk0nugOD7PhyByb/8VSovdwAxjrX3UDxXC4=;
        b=iFG/XKWES6WEEfxnRi+jCKWukTMlu/93L9IRhEM9hQ5YdlyxOZ7cdfXSB4z9K+T6i0
         8AItb1cQV0J2gIjyGTEN9yXJGmE0LMDHntHWoo7uddW0NKF9kgyseIsWNwCkRUUNlbKo
         67sGEDLFlTD7BNoAb7P3ezySPkiiVZSBM/BECocr0D3GL1SPmq3pc1ia7LBqM1SuAqTK
         VB25karq/I/2HlbF1PuF928glBtrCMvwFlOP37fAeIGRuEN7MzXYGDR9hLldDhun+Vpn
         ISIT/T2IKAyD8DRjV0iw2f4GZiv9ei4zqFgTDyTzmuxxzrXZCyPSjZGrATJ0Hq1S4Vr2
         1Q0A==
X-Forwarded-Encrypted: i=1; AJvYcCUmH8uHvckFmVVQxwSgqZ9pajLibNx7VzlEyQWQyJxMVKnvA8Dk0KT1xRdmCT+0eems9Y7fbuQ/oGcGPrA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2LJ+A63tgnJWt455G2RYs4oLK5YTLwlk/AIxao0eYIcUlJs+/
	pzxVtpnLIOFd2adCNPiFMt3RYZNlxdJprrrgguwjoWyoM7rlqIF2m9D8
X-Gm-Gg: AZuq6aIG83EB6QppQt8z7FWaRNuojBSoC3k2euwgmcWTg7oSIIgXzzcrqtbczJazdo8
	qaBv6NJOWcnfUL8IBuCXDDCrGC8+Sjoj9mnk3jZa1eI1ci1iJmpquaIVbeNmxDqNn95GqxvnyCq
	taI8x1BYyO0mPGQk/IfJpzGh2uQvpxzWhrygyYH1p/7H1kjLb+tqZUQX8pJ5Bo54kn9knwnhcfM
	Z2Pzg6cVr+ECbxmQZU4ZMRuVShqyvNU9AMacywx0uxhCJ2UWGuF8iI1u0m2j/X3hDlOHJdAa5G/
	EuJZ4atQgCSSqTiincJE6eNKh7tEnUeHmhtHi8dXloO3YLFMKjlepq3bc+E0gzBVsZmT1FIXWHG
	4rs9iglU24bA0bV1s5IMy9vsirR2vwN+sUF4ry2jzv+B9vD1r0BsGnGdqLA6liI/Qh6lFsuGFjl
	4DoJt89X6wz5aivH0u7ISDGOlJYZiY/aKIAkRlAyAoYGuEstzgfwWY
X-Received: by 2002:a05:600c:1388:b0:47b:e2a9:2bd7 with SMTP id 5b1f17b1804b1-48320216126mr65696695e9.19.1770461492491;
        Sat, 07 Feb 2026 02:51:32 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48317d3e245sm195442315e9.8.2026.02.07.02.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Feb 2026 02:51:32 -0800 (PST)
Date: Sat, 7 Feb 2026 10:51:30 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>, Vijay Sundar
 Selvamani <vijay.sundar.selvamani@intel.com>, George Abraham P
 <george.abraham.p@intel.com>, qat-linux@intel.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Marco Elver <elver@google.com>, Will Deacon <will@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH next] crypto: qat - replace avg_array() with a better
 function
Message-ID: <20260207105130.4af50ce1@pumpkin>
In-Reply-To: <20260206210940.315817-1-david.laight.linux@gmail.com>
References: <20260206210940.315817-1-david.laight.linux@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  6 Feb 2026 21:09:40 +0000
david.laight.linux@gmail.com wrote:

Cc the people discussing unqual_scalar_typeof() for arm64 LTO READ_ONCE().

> From: David Laight <david.laight.linux@gmail.com>
> 
> avg_array() is defined as a 'type independant' #define.
> However the algorithm is only valid for unsigned types and the
> implementation is only valid for u64.
> All the callers pass temporary kmalloc() allocated arrays of u64.
> 
> Replace with a function that takes a pointer to a u64 array.
> 
> Change the implementation to sum the low and high 32bits of each
> value separately and then compute the average.
> This will be massively faster as it does two divisions rather than
> one for each element.
> 
> Also removes some very pointless __unqual_scalar_typeof().
> They could be 'auto _x = 0 ? x + 0 : 0;' even if the types weren't fixed.
> 
> Only compile tested.
> 
> Signed-off-by: David Laight <david.laight.linux@gmail.com>
> ---
>  .../intel/qat/qat_common/adf_tl_debugfs.c     | 38 ++++++++-----------
>  1 file changed, 15 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c b/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c
> index b81f70576683..a084437a2631 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c
> @@ -77,32 +77,24 @@ static int tl_collect_values_u64(struct adf_telemetry *telemetry,
>   * @len: Number of elements.
>   *
>   * This algorithm computes average of an array without running into overflow.
> + * (Provided len is less than 2 << 31.)
>   *
>   * Return: average of values.
>   */
> -#define avg_array(array, len) (				\
> -{							\
> -	typeof(&(array)[0]) _array = (array);		\
> -	__unqual_scalar_typeof(_array[0]) _x = 0;	\
> -	__unqual_scalar_typeof(_array[0]) _y = 0;	\
> -	__unqual_scalar_typeof(_array[0]) _a, _b;	\
> -	typeof(len) _len = (len);			\
> -	size_t _i;					\
> -							\
> -	for (_i = 0; _i < _len; _i++) {			\
> -		_a = _array[_i];			\
> -		_b = do_div(_a, _len);			\
> -		_x += _a;				\
> -		if (_y >= _len - _b) {			\
> -			_x++;				\
> -			_y -= _len - _b;		\
> -		} else {				\
> -			_y += _b;			\
> -		}					\
> -	}						\
> -	do_div(_y, _len);				\
> -	(_x + _y);					\
> -})
> +static u64 avg_array(const u64 *array, size_t len)
> +{
> +	u64 sum_hi = 0, sum_lo = 0;
> +	size_t i;
> +
> +	for (i = 0; i < len; i++) {
> +		sum_hi += array[i] >> 32;
> +		sum_lo += (u32)array[i];
> +	}
> +
> +	sum_lo += (u64)do_div(sum_hi, len) << 32;
> +
> +	return (sum_hi << 32) + div_u64(sum_lo, len);
> +}
>  
>  /* Calculation function for simple counter. */
>  static int tl_calc_count(struct adf_telemetry *telemetry,

