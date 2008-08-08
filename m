From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: OpenSSL patch to support Linux CryptoAPI.
Date: Sat, 9 Aug 2008 01:09:49 +0400
Message-ID: <20080808210949.GA6535@2ka.mipt.ru>
References: <DB599F406D04E34389140B7D99C71B1B05D9E002@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Loc Ho <lho@amcc.com>
To: Shasi Pulijala <spulijala@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.80.65]:57983 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902AbYHHVJh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Aug 2008 17:09:37 -0400
Content-Disposition: inline
In-Reply-To: <DB599F406D04E34389140B7D99C71B1B05D9E002@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Fri, Aug 08, 2008 at 11:31:58AM -0700, Shasi Pulijala (spulijala@amcc.com) wrote:
>  struct crypt_op {
> -	u_int32_t	ses;
> -	u_int16_t	op;		/* i.e. COP_ENCRYPT */
>  #define COP_NONE	0
>  #define COP_ENCRYPT	1
>  #define COP_DECRYPT	2
> -	u_int16_t	flags;
> -#define	COP_F_BATCH	0x0008		/* Batch op if possible */
> -	u_int		len;
> -	caddr_t		src, dst;	/* become iov[] inside kernel */
> -	caddr_t		mac;		/* must be big enough for chosen MAC */
> -	caddr_t		iv;
> +	__u16		op;		/* i.e. COP_ENCRYPT */
> +	__u16		flags;
> +	__u16		iv_size;
> +	__u16 		assoc_size;
> +	__u32		src_size;
> +	caddr_t		src_data;
> +	caddr_t		dst_data;
> +	__u8		data[0];	/* must be big enough for chosen MAC */
>  };

If above caddr_t is what I thought (i.e. a pointer or long type),
there is no way it can be correct. It is _NOT_ allowed to put
variable sized members into structures shared between kernel
and userspace.

-- 
	Evgeniy Polyakov
