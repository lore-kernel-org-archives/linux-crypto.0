From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 1/1] Crypto: [xp ]cbc: use 64bit regs on 64bit machines
Date: Thu, 14 Jun 2007 14:57:45 +0400
Message-ID: <20070614105744.GB24814@2ka.mipt.ru>
References: <20070613222006.GA4585@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:58804 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbXFNK6G (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Jun 2007 06:58:06 -0400
Content-Disposition: inline
In-Reply-To: <20070613222006.GA4585@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 14, 2007 at 12:20:06AM +0200, Sebastian Siewior (linux-crypto@ml.breakpoint.cc) wrote:
>  static void xor_64(u8 *a, const u8 *b, unsigned int bs)
>  {
> +#if BITS_PER_LONG == 64
> +	((u64 *)a)[0] ^= ((u64 *)b)[0];
> +#else
>  	((u32 *)a)[0] ^= ((u32 *)b)[0];
>  	((u32 *)a)[1] ^= ((u32 *)b)[1];
> +#endif
>  }

What about endianess?

-- 
	Evgeniy Polyakov
