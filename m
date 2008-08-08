From: "Loc Ho" <lho@amcc.com>
Subject: RE: OpenSSL patch to support Linux CryptoAPI.
Date: Fri, 8 Aug 2008 15:24:20 -0700
Message-ID: <0CA0A16855646F4FA96D25A158E299D604D28FD5@SDCEXCHANGE01.ad.amcc.com>
References: <DB599F406D04E34389140B7D99C71B1B05D9E002@SDCEXCHANGE01.ad.amcc.com> <20080808210949.GA6535@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: <linux-crypto@vger.kernel.org>,
	"Shasi Pulijala" <spulijala@amcc.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02-ext1.amcc.com ([198.137.200.73]:55170 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763990AbYHHWY0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Aug 2008 18:24:26 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080808210949.GA6535@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

This sound like the only solution to passing more than one pointers from user space is via custom system call - such as (new) crypto_op(...). Am I correct?

-Loc

-----Original Message-----
From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Evgeniy Polyakov
Sent: Friday, August 08, 2008 2:10 PM
To: Shasi Pulijala
Cc: linux-crypto@vger.kernel.org; Loc Ho
Subject: Re: OpenSSL patch to support Linux CryptoAPI.

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
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
