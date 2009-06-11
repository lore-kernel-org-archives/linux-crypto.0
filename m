From: Nicolas Pitre <nico@cam.org>
Subject: Re: [PATCH] arm/ts209: init crypto
Date: Thu, 11 Jun 2009 15:22:50 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.0906111518390.31536@xanadu.home>
References: <1244728999-8103-1-git-send-email-arm-kernel@ml.breakpoint.cc>
 <1244728999-8103-4-git-send-email-arm-kernel@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: arm-kernel@ml.breakpoint.cc
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:51057 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbZFKTXI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 15:23:08 -0400
Received: from xanadu.home ([66.131.194.97]) by VL-MH-MR002.ip.videotron.ca
 (Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug  3 2007; 32bit))
 with ESMTP id <0KL300BVL9U2PQX0@VL-MH-MR002.ip.videotron.ca> for
 linux-crypto@vger.kernel.org; Thu, 11 Jun 2009 15:22:50 -0400 (EDT)
In-reply-to: <1244728999-8103-4-git-send-email-arm-kernel@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 11 Jun 2009, arm-kernel@ml.breakpoint.cc wrote:

> From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> 
> use the new driver for the crypto engine
> 
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

Since the crypto engine is part of the SOC, this is not a board specific 
thing.  Hence this should be initialized for all targets and not only 
the TS209, just like the watchdog driver is.



> ---
>  arch/arm/mach-orion5x/ts209-setup.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-orion5x/ts209-setup.c b/arch/arm/mach-orion5x/ts209-setup.c
> index 9d68905..fbea307 100644
> --- a/arch/arm/mach-orion5x/ts209-setup.c
> +++ b/arch/arm/mach-orion5x/ts209-setup.c
> @@ -302,6 +302,7 @@ static void __init qnap_ts209_init(void)
>  	orion5x_uart0_init();
>  	orion5x_uart1_init();
>  	orion5x_xor_init();
> +	orion5x_crypto_init();
>  
>  	platform_device_register(&qnap_ts209_button_device);
>  
> -- 
> 1.6.0.6
> 
