Received: from mail.servus.at (mail.servus.at [193.170.194.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD3518950A;
	Mon, 24 Feb 2025 16:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.170.194.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740414413; cv=none; b=YKM9sxI+lAMder/kG8vbClKhY5zxmVK8jPtZtGWJOLp9wIWzYbjEbvRt5g3YrOuuyC5gromwJlaLznyjsevI2ywLFtP4YHGHsEww2+bK0hZ9/KNfxAH0lyE7J8gxcEFQRjxp6WThPlBEiUCs8859LqzgGJY8LQGA1pvzmZsI2t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740414413; c=relaxed/simple;
	bh=jCYb+d7G1reO0vaUQ96m458H4rRW2Evdk3/qIlZD0oc=;
	h=Subject:To:References:Cc:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=h3JYVP7fwmQpMI+kStvyws/pn5elRNRB9ZRr/TbN6w+/YMG9R7fkrT4samXBnHw5Y8piAKZQMQMm+8f/BWprpPSor+KZq5tu8K5olTXHO4Wzrv3KQmYGtfoqMv/seVm2bY2tpPTIm63JE4+rbF5WqHslw3tyWak+iZx/mUraqdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=oberhumer.com; spf=none smtp.mailfrom=oberhumer.com; dkim=pass (1024-bit key) header.d=oberhumer.com header.i=@oberhumer.com header.b=kzUfOmPp; arc=none smtp.client-ip=193.170.194.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=oberhumer.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=oberhumer.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oberhumer.com header.i=@oberhumer.com header.b="kzUfOmPp"
Received: from localhost (localhost [127.0.0.1])
	by mail.servus.at (Postfix) with ESMTP id 2A66778926;
	Mon, 24 Feb 2025 17:21:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=oberhumer.com; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:mime-version:user-agent:date:date:message-id:organization:from
	:from:references:subject:subject:received:received; s=main; t=
	1740414058; x=1742228459; bh=jCYb+d7G1reO0vaUQ96m458H4rRW2Evdk3/
	qIlZD0oc=; b=kzUfOmPp9OgoaAWcX1oq6cBTRWEW/ZAVBkY5I5k2GoosSyD8ICq
	rnYGEy+ntkp3cE9zg/IFAW8s9WwdYPTMqfnrEJL29L3dMS+S0LKApQrvH8pD9S0i
	SDw6066ix8+DU7DeUKF8F+sBVzh8eIrk+nSkSmiXVwQrMQ/sj0OjH6Tk=
X-Virus-Scanned: amavis at servus.at
Received: from mail.servus.at ([127.0.0.1])
 by localhost (mail.servus.at [127.0.0.1]) (amavis, port 10024) with ESMTP
 id PhpXsMLSR3C6; Mon, 24 Feb 2025 17:20:58 +0100 (CET)
Received: from [192.168.216.53] (unknown [81.10.228.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: oh_markus)
	by mail.servus.at (Postfix) with ESMTPSA id F269F5A771;
	Mon, 24 Feb 2025 17:20:56 +0100 (CET)
Subject: Re: [PATCH] lib/lzo: Avoid output overruns when compressing
To: Herbert Xu <herbert@gondor.apana.org.au>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <Z7rGXJSX57gEfXPw@gondor.apana.org.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Nitin Gupta <nitingupta910@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Dave Rodgman <dave.rodgman@arm.com>
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Organization: oberhumer.com
Message-ID: <67BC9C68.5090300@oberhumer.com>
Date: Mon, 24 Feb 2025 17:20:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.3.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <Z7rGXJSX57gEfXPw@gondor.apana.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

LZO declares "*out_len" as output parameter because

  #define lzo1x_worst_compress(x) ((x) + ((x) / 16) + 64 + 3 + 2)

~Markus


On 2025-02-23 07:55, Herbert Xu wrote:
> The compression code in LZO never checked for output overruns.
> Fix this by checking for end of buffer before each write.
> 
> Fixes: 64c70b1cf43d ("Add LZO1X algorithm to the kernel")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/lib/lzo/lzo1x_compress.c b/lib/lzo/lzo1x_compress.c
> index 47d6d43ea957..5d2f2f851694 100644
> --- a/lib/lzo/lzo1x_compress.c
> +++ b/lib/lzo/lzo1x_compress.c
> @@ -18,10 +18,10 @@
>  #include <linux/lzo.h>
>  #include "lzodefs.h"
>  
> -static noinline size_t
> +static noinline int
>  lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
> -		    unsigned char *out, size_t *out_len,
> -		    size_t ti, void *wrkmem, signed char *state_offset,
> +		    unsigned char **out, unsigned char *op_end,
> +		    size_t *tp, void *wrkmem, signed char *state_offset,
>  		    const unsigned char bitstream_version)
>  {
>  	const unsigned char *ip;
> @@ -30,8 +30,9 @@ lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
>  	const unsigned char * const ip_end = in + in_len - 20;
>  	const unsigned char *ii;
>  	lzo_dict_t * const dict = (lzo_dict_t *) wrkmem;
> +	size_t ti = *tp;
>  
> -	op = out;
> +	op = *out;
>  	ip = in;
>  	ii = ip;
>  	ip += ti < 4 ? 4 - ti : 0;
> @@ -116,25 +117,41 @@ lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
>  		if (t != 0) {
>  			if (t <= 3) {
>  				op[*state_offset] |= t;
> +				if (!HAVE_OP(4))
> +					return LZO_E_OUTPUT_OVERRUN;
>  				COPY4(op, ii);
>  				op += t;
>  			} else if (t <= 16) {
> +				if (!HAVE_OP(1))
> +					return LZO_E_OUTPUT_OVERRUN;
>  				*op++ = (t - 3);
> +				if (!HAVE_OP(16))
> +					return LZO_E_OUTPUT_OVERRUN;
>  				COPY8(op, ii);
>  				COPY8(op + 8, ii + 8);
>  				op += t;
>  			} else {
>  				if (t <= 18) {
> +					if (!HAVE_OP(1))
> +						return LZO_E_OUTPUT_OVERRUN;
>  					*op++ = (t - 3);
>  				} else {
>  					size_t tt = t - 18;
> +					if (!HAVE_OP(1))
> +						return LZO_E_OUTPUT_OVERRUN;
>  					*op++ = 0;
>  					while (unlikely(tt > 255)) {
>  						tt -= 255;
> +						if (!HAVE_OP(1))
> +							return LZO_E_OUTPUT_OVERRUN;
>  						*op++ = 0;
>  					}
> +					if (!HAVE_OP(1))
> +						return LZO_E_OUTPUT_OVERRUN;
>  					*op++ = tt;
>  				}
> +				if (!HAVE_OP(t))
> +					return LZO_E_OUTPUT_OVERRUN;
>  				do {
>  					COPY8(op, ii);
>  					COPY8(op + 8, ii + 8);
> @@ -151,6 +168,8 @@ lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
>  		if (unlikely(run_length)) {
>  			ip += run_length;
>  			run_length -= MIN_ZERO_RUN_LENGTH;
> +			if (!HAVE_OP(4))
> +				return LZO_E_OUTPUT_OVERRUN;
>  			put_unaligned_le32((run_length << 21) | 0xfffc18
>  					   | (run_length & 0x7), op);
>  			op += 4;
> @@ -243,10 +262,14 @@ lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
>  		ip += m_len;
>  		if (m_len <= M2_MAX_LEN && m_off <= M2_MAX_OFFSET) {
>  			m_off -= 1;
> +			if (!HAVE_OP(2))
> +				return LZO_E_OUTPUT_OVERRUN;
>  			*op++ = (((m_len - 1) << 5) | ((m_off & 7) << 2));
>  			*op++ = (m_off >> 3);
>  		} else if (m_off <= M3_MAX_OFFSET) {
>  			m_off -= 1;
> +			if (!HAVE_OP(1))
> +				return LZO_E_OUTPUT_OVERRUN;
>  			if (m_len <= M3_MAX_LEN)
>  				*op++ = (M3_MARKER | (m_len - 2));
>  			else {
> @@ -254,14 +277,22 @@ lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
>  				*op++ = M3_MARKER | 0;
>  				while (unlikely(m_len > 255)) {
>  					m_len -= 255;
> +					if (!HAVE_OP(1))
> +						return LZO_E_OUTPUT_OVERRUN;
>  					*op++ = 0;
>  				}
> +				if (!HAVE_OP(1))
> +					return LZO_E_OUTPUT_OVERRUN;
>  				*op++ = (m_len);
>  			}
> +			if (!HAVE_OP(2))
> +				return LZO_E_OUTPUT_OVERRUN;
>  			*op++ = (m_off << 2);
>  			*op++ = (m_off >> 6);
>  		} else {
>  			m_off -= 0x4000;
> +			if (!HAVE_OP(1))
> +				return LZO_E_OUTPUT_OVERRUN;
>  			if (m_len <= M4_MAX_LEN)
>  				*op++ = (M4_MARKER | ((m_off >> 11) & 8)
>  						| (m_len - 2));
> @@ -282,11 +313,17 @@ lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
>  				m_len -= M4_MAX_LEN;
>  				*op++ = (M4_MARKER | ((m_off >> 11) & 8));
>  				while (unlikely(m_len > 255)) {
> +					if (!HAVE_OP(1))
> +						return LZO_E_OUTPUT_OVERRUN;
>  					m_len -= 255;
>  					*op++ = 0;
>  				}
> +				if (!HAVE_OP(1))
> +					return LZO_E_OUTPUT_OVERRUN;
>  				*op++ = (m_len);
>  			}
> +			if (!HAVE_OP(2))
> +				return LZO_E_OUTPUT_OVERRUN;
>  			*op++ = (m_off << 2);
>  			*op++ = (m_off >> 6);
>  		}
> @@ -295,14 +332,16 @@ lzo1x_1_do_compress(const unsigned char *in, size_t in_len,
>  		ii = ip;
>  		goto next;
>  	}
> -	*out_len = op - out;
> -	return in_end - (ii - ti);
> +	*out = op;
> +	*tp = in_end - (ii - ti);
> +	return LZO_E_OK;
>  }
>  
>  static int lzogeneric1x_1_compress(const unsigned char *in, size_t in_len,
>  		     unsigned char *out, size_t *out_len,
>  		     void *wrkmem, const unsigned char bitstream_version)
>  {
> +	unsigned char * const op_end = out + *out_len;
>  	const unsigned char *ip = in;
>  	unsigned char *op = out;
>  	unsigned char *data_start;
> @@ -326,14 +365,17 @@ static int lzogeneric1x_1_compress(const unsigned char *in, size_t in_len,
>  	while (l > 20) {
>  		size_t ll = min_t(size_t, l, m4_max_offset + 1);
>  		uintptr_t ll_end = (uintptr_t) ip + ll;
> +		int err;
> +
>  		if ((ll_end + ((t + ll) >> 5)) <= ll_end)
>  			break;
>  		BUILD_BUG_ON(D_SIZE * sizeof(lzo_dict_t) > LZO1X_1_MEM_COMPRESS);
>  		memset(wrkmem, 0, D_SIZE * sizeof(lzo_dict_t));
> -		t = lzo1x_1_do_compress(ip, ll, op, out_len, t, wrkmem,
> -					&state_offset, bitstream_version);
> +		err = lzo1x_1_do_compress(ip, ll, &op, op_end, &t, wrkmem,
> +					  &state_offset, bitstream_version);
> +		if (err != LZO_E_OK)
> +			return err;
>  		ip += ll;
> -		op += *out_len;
>  		l  -= ll;
>  	}
>  	t += l;
> @@ -342,20 +384,32 @@ static int lzogeneric1x_1_compress(const unsigned char *in, size_t in_len,
>  		const unsigned char *ii = in + in_len - t;
>  
>  		if (op == data_start && t <= 238) {
> +			if (!HAVE_OP(1))
> +				return LZO_E_OUTPUT_OVERRUN;
>  			*op++ = (17 + t);
>  		} else if (t <= 3) {
>  			op[state_offset] |= t;
>  		} else if (t <= 18) {
> +			if (!HAVE_OP(1))
> +				return LZO_E_OUTPUT_OVERRUN;
>  			*op++ = (t - 3);
>  		} else {
>  			size_t tt = t - 18;
> +			if (!HAVE_OP(1))
> +				return LZO_E_OUTPUT_OVERRUN;
>  			*op++ = 0;
>  			while (tt > 255) {
>  				tt -= 255;
> +				if (!HAVE_OP(1))
> +					return LZO_E_OUTPUT_OVERRUN;
>  				*op++ = 0;
>  			}
> +			if (!HAVE_OP(1))
> +				return LZO_E_OUTPUT_OVERRUN;
>  			*op++ = tt;
>  		}
> +		if (!HAVE_OP(t))
> +			return LZO_E_OUTPUT_OVERRUN;
>  		if (t >= 16) do {
>  			COPY8(op, ii);
>  			COPY8(op + 8, ii + 8);
> @@ -368,6 +422,8 @@ static int lzogeneric1x_1_compress(const unsigned char *in, size_t in_len,
>  		} while (--t > 0);
>  	}
>  
> +	if (!HAVE_OP(3))
> +		return LZO_E_OUTPUT_OVERRUN;
>  	*op++ = M4_MARKER | 1;
>  	*op++ = 0;
>  	*op++ = 0;
> diff --git a/lib/lzo/lzo1x_decompress_safe.c b/lib/lzo/lzo1x_decompress_safe.c
> index c94f4928e188..4d5a1b58a4a0 100644
> --- a/lib/lzo/lzo1x_decompress_safe.c
> +++ b/lib/lzo/lzo1x_decompress_safe.c
> @@ -21,7 +21,6 @@
>  #include "lzodefs.h"
>  
>  #define HAVE_IP(x)      ((size_t)(ip_end - ip) >= (size_t)(x))
> -#define HAVE_OP(x)      ((size_t)(op_end - op) >= (size_t)(x))
>  #define NEED_IP(x)      if (!HAVE_IP(x)) goto input_overrun
>  #define NEED_OP(x)      if (!HAVE_OP(x)) goto output_overrun
>  #define TEST_LB(m_pos)  if ((m_pos) < out) goto lookbehind_overrun
> diff --git a/lib/lzo/lzodefs.h b/lib/lzo/lzodefs.h
> index b60851fcf6ce..8b1a46993acf 100644
> --- a/lib/lzo/lzodefs.h
> +++ b/lib/lzo/lzodefs.h
> @@ -19,6 +19,7 @@
>   */
>  #define LZO_VERSION 1
>  
> +#define HAVE_OP(x)      ((size_t)(op_end - op) >= (size_t)(x))
>  #define COPY4(dst, src)	\
>  		put_unaligned(get_unaligned((const u32 *)(src)), (u32 *)(dst))
>  #if defined(CONFIG_X86_64) || defined(CONFIG_ARM64)
> 

-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/
