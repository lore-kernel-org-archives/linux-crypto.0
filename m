Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA641FCCFA
	for <linux-crypto@vger.kernel.org>; Sun, 23 Feb 2025 08:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740300039; cv=none; b=o4UE3GRVVy+PM7n4PFGN7UPpXXZn5ZNPnQg3V2B+guPU3ZicRKxdPNqEJzQZnbXOWGUTKsP2A181I1SSWiEr+017jOlsres9GsU0IlcInTt6VGnXvlS0iIi8QJ9/TyKXTWKHnEJ11PgJg27HXAXXaLPehaJL7iIsLu4jkodGdb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740300039; c=relaxed/simple;
	bh=VMZP75rhMsZKP1h7w7GGsRJbBi7X8HJDlzKN8uf2Gog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lgD9uFnF1Sm9l10HkEw2rWykzhGsGQiGo5d+cpZX3ZiBQgJDo4dzSgCoWJsj955dJpDlYH9YNyGRShtBU2hTr6SrZdBA+bhvp562ySXetYaiEXq/LDzuZpwYLWB3cFkOAj/MzjX1vZEspN60qL4/h8oHMXKgn6jglyspfMnaEec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=TFlyGYS/; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="TFlyGYS/"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-219f8263ae0so71451945ad.0
        for <linux-crypto@vger.kernel.org>; Sun, 23 Feb 2025 00:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1740300037; x=1740904837; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R9gpSGM5f9xtZjGEJveZ4GrzDJH1nRyp6hOrbTNY7Eg=;
        b=TFlyGYS/cq84tJNGn64sC1f7sOES00p4HxprGHbRt5UM8okRfDV/XbvYyBLP4v6cDN
         sMz+Uhs2cpC6Zgzcfjx7RYayAKPm4BuVUgZgne5GK+FX23wZmabtYhGrQTwg4LeDTOSJ
         bt9MTaIfB0fB5a/y/hUT9d66O1gLTVgtg3J9Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740300037; x=1740904837;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R9gpSGM5f9xtZjGEJveZ4GrzDJH1nRyp6hOrbTNY7Eg=;
        b=EhBbjJ//k1xbJAZp55cttCFiUKq6cMm4zGXieK8tn8HqLNY4UdB9nSuu7n7bDCm9kx
         Lta1qkwP7H73zqSVPc/dUIADw1gDOW5yhQpHQfa/qX3gg2/u9vbC+Zq7iokQMzFAug8T
         HZ6Jslv57TnZqDmwvgHK2DVaSjy+xaxTRvtq7IvCFaj4D5gRH5bP3DaSUwoETTYvB6YB
         mj0oxJcx7DjS7BmCVG+rUntwWXGi4lhUT+woYfRl/SpATEoSLrwn7C8JxEom7Nao0LNT
         woWl5rQNb5Fg7xtliaekPATIyQ09zfYrr9uLhzQLjJF2EKT6kEc8CGMGO4/E0ZlFIqWs
         04eA==
X-Gm-Message-State: AOJu0YwZM4Zz2CMOJVwEqKfqlCfnZdkexBbGpKBG7DuZK07WuVvmL2sE
	iuKKyrisLSYrguRAJrCqO3S7hY8do+JNOdPWKrBtAW9KRYQ4jjX9L2TTvwzwfA==
X-Gm-Gg: ASbGncs6LOOlo1H+MP6ojD3it+QWAauixGshyPgTqLDtosRpKd45whvlHONk4AEWyxK
	DQqfpKcO/5IrAlnxcm5oVJmDepgURoDpCCHmufP2s4RJ6hDAiSgIF5SWdu8Db/LeRHy+osSTBQ0
	x+QZ7zPUqOKwWkPGX0WsoUUMudT8XKBhT1Bk5k3VrEyqMlv2NmadqKh20kTg0JfBxloIzSlWreo
	vtXIbeb0WyjHQVa9M4+wQBOP3jwuJKmlRsFvgA95O2YPy8tozj/8+YEjsuAoMTqxWC8RvkrsR4s
	RCLfbVMjGeqJFjNcPLSn6wenWZ8acw==
X-Google-Smtp-Source: AGHT+IHs2bEHHbTZeDzqZuSxzKMbqBVzBNfFwOrRXpSuEs7ai1npp6AoUs79mcwT90M7ZwcPaU4GMQ==
X-Received: by 2002:a05:6a00:c81:b0:725:9f02:489a with SMTP id d2e1a72fcca58-73426d72880mr13450744b3a.17.1740300037559;
        Sun, 23 Feb 2025 00:40:37 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:7eae:f032:eb08:bb00])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73266fd6438sm15247420b3a.142.2025.02.23.00.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2025 00:40:37 -0800 (PST)
Date: Sun, 23 Feb 2025 17:40:31 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Nitin Gupta <nitingupta910@gmail.com>, 
	Richard Purdie <rpurdie@openedhand.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	"Markus F.X.J. Oberhumer" <markus@oberhumer.com>, Dave Rodgman <dave.rodgman@arm.com>
Subject: Re: [PATCH] lib/lzo: Avoid output overruns when compressing
Message-ID: <hymyvszwshcvqngjlomeyltmpghx6gges76muaz23a6cit5oe2@eas2xjgfynnu>
References: <Z7rGXJSX57gEfXPw@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7rGXJSX57gEfXPw@gondor.apana.org.au>

On (25/02/23 14:55), Herbert Xu wrote:
[..]
>  		} else if (m_off <= M3_MAX_OFFSET) {
>  			m_off -= 1;
> +			if (!HAVE_OP(1))
> +				return LZO_E_OUTPUT_OVERRUN;
>  			if (m_len <= M3_MAX_LEN)
>  				*op++ = (M3_MARKER | (m_len - 2));
>  			else {
[..]
>  		} else {
>  			m_off -= 0x4000;
> +			if (!HAVE_OP(1))
> +				return LZO_E_OUTPUT_OVERRUN;
>  			if (m_len <= M4_MAX_LEN)
>  				*op++ = (M4_MARKER | ((m_off >> 11) & 8)
>  						| (m_len - 2));

Made me wonder if HAVE_OP() in these two cases should have been
under if, but it covers both if and else branches, so it's all
right.

[..]
> +++ b/lib/lzo/lzo1x_decompress_safe.c
> @@ -21,7 +21,6 @@
>  #include "lzodefs.h"
>  
>  #define HAVE_IP(x)      ((size_t)(ip_end - ip) >= (size_t)(x))
> -#define HAVE_OP(x)      ((size_t)(op_end - op) >= (size_t)(x))
>  #define NEED_IP(x)      if (!HAVE_IP(x)) goto input_overrun
>  #define NEED_OP(x)      if (!HAVE_OP(x)) goto output_overrun

A bit of a pity that NEED_OP() with "goto output_overrun" is only
for decompression.  It looks equally relevant to the compression
path.  I'm not insisting on doing something similar in compression
tho.

Overall this look right, and kudos to Herbert for doing this.

I did some testing (using my usual zram test scripts, but modified
zram to allocate only one physical page for comp buf and to check
for overrun ret status).  Haven't noticed any problems.

FWIW
Reviewed-and-tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
