From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH 1/2 v4] crypto: sha512 - Move message schedule W[80] to static percpu area
Date: Mon, 8 Dec 2008 03:09:19 +0300
Message-ID: <20081208000919.GA14357@ioremap.net>
References: <20081207113302.GB13736@gondor.apana.org.au> <1228688249887-git-send-email-ken@codelabs.ch> <12286882501412-git-send-email-ken@codelabs.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	steffen.klassert@secunet.com
To: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from netgear.net.ru ([195.178.208.66]:55715 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbYLHAJV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 19:09:21 -0500
Content-Disposition: inline
In-Reply-To: <12286882501412-git-send-email-ken@codelabs.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Sun, Dec 07, 2008 at 11:17:28PM +0100, Adrian-Ken Rueegsegger (ken@codelabs.ch) wrote:
> The message schedule W (u64[80]) is too big for the stack. In order
> for this algorithm to be used with shash it is moved to a static
> percpu area.
> 
> Signed-off-by: Adrian-Ken Rueegsegger <ken@codelabs.ch>



> +static DEFINE_PER_CPU(u64[80], msg_schedule);
> +
>  static inline u64 Ch(u64 x, u64 y, u64 z)
>  {
>          return z ^ (x & (y ^ z));
> @@ -89,11 +90,12 @@ static inline void BLEND_OP(int I, u64 *W)
>  }
>  
>  static void
> -sha512_transform(u64 *state, u64 *W, const u8 *input)
> +sha512_transform(u64 *state, const u8 *input)
>  {
>  	u64 a, b, c, d, e, f, g, h, t1, t2;
>  
>  	int i;
> +	u64 *W = get_cpu_var(msg_schedule);

This should be protected by preempt_disable(), shouldn't it?

-- 
	Evgeniy Polyakov
