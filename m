From: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
Subject: RE: [PATCH 2/2] ath9k: disable RNG by default
Date: Tue, 9 Aug 2016 07:35:33 +0000
Message-ID: <69af156ac93a4fe6ab1844dfcc35c266@aptaiexm02f.ap.qualcomm.com>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
 <1470726147-30095-2-git-send-email-miaoqing@codeaurora.org>
 <4627645.oz3l49ICL3@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"jason@lakedaemon.net" <jason@lakedaemon.net>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>
To: Stephan Mueller <smueller@chronox.de>,
	"miaoqing@codeaurora.org" <miaoqing@codeaurora.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12727 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbcHIHfj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 03:35:39 -0400
In-Reply-To: <4627645.oz3l49ICL3@tauon.atsec.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

So your suggestion is to use HW Random framework ?   Actually, which was done by the commit 6301566e0b2d ("ath9k: export HW random number generator"), but it was reverted, you can refer to https://www.mail-archive.com/linux-crypto%40vger.kernel.org/msg15483.html for more information.

--
Miaoqing


-----Original Message-----
From: Stephan Mueller [mailto:smueller@chronox.de] 
Sent: Tuesday, August 09, 2016 3:15 PM
To: miaoqing@codeaurora.org
Cc: Valo, Kalle <kvalo@qca.qualcomm.com>; linux-wireless@vger.kernel.org; ath9k-devel <ath9k-devel@qca.qualcomm.com>; linux-crypto@vger.kernel.org; jason@lakedaemon.net; Sepehrdad, Pouyan <pouyans@qti.qualcomm.com>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default

Am Dienstag, 9. August 2016, 15:02:27 CEST schrieb miaoqing@codeaurora.org:

Hi Miaoqing,

> From: Miaoqing Pan <miaoqing@codeaurora.org>
> 
> ath9k RNG will dominates all the noise sources from the real HW RNG, 
> disable it by default. But we strongly recommand to enable it if the 
> system without HW RNG, especially on embedded systems.
> 
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>

As a short term solution:

Acked-by: Stephan Mueller <smueller@chronox.de>

But as Jason outlined, there should be nothing that prevents using this code with the HW Random framework. This framework also has logic to limit the rate of injection and allows the setting of the entropy threshold at runtime.

> ---
>  drivers/net/wireless/ath/ath9k/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/Kconfig
> b/drivers/net/wireless/ath/ath9k/Kconfig index f68cb00..8f231c6 100644
> --- a/drivers/net/wireless/ath/ath9k/Kconfig
> +++ b/drivers/net/wireless/ath/ath9k/Kconfig
> @@ -180,7 +180,7 @@ config ATH9K_HTC_DEBUGFS  config ATH9K_HWRNG
>  	bool "Random number generator support"
>  	depends on ATH9K && (HW_RANDOM = y || HW_RANDOM = ATH9K)
> -	default y
> +	default n
>  	---help---
>  	  This option incorporates the ADC register output as a source of
>  	  randomness into Linux entropy pool (/dev/urandom and /dev/random)



Ciao
Stephan
