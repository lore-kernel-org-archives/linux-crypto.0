From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Date: Tue, 09 Aug 2016 10:07:29 +0200
Message-ID: <4731753.YZZKimtrHM@tauon.atsec.com>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org> <4627645.oz3l49ICL3@tauon.atsec.com> <69af156ac93a4fe6ab1844dfcc35c266@aptaiexm02f.ap.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "miaoqing@codeaurora.org" <miaoqing@codeaurora.org>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"jason@lakedaemon.net" <jason@lakedaemon.net>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>
To: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>,
	herbert@gondor.apana.org.au, Matt Mackall <mpm@selenic.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34274 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbcHIIHc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 04:07:32 -0400
In-Reply-To: <69af156ac93a4fe6ab1844dfcc35c266@aptaiexm02f.ap.qualcomm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 9. August 2016, 07:35:33 CEST schrieb Pan, Miaoqing:

Hi Miaoqing, Herbert, Matt,

> Hi Stephan,
> 
> So your suggestion is to use HW Random framework ?   Actually, which was
> done by the commit 6301566e0b2d ("ath9k: export HW random number
> generator"), but it was reverted, you can refer to
> https://www.mail-archive.com/linux-crypto%40vger.kernel.org/msg15483.html
> for more information.

I see, it is the same RNG we talked about earlier. The issue is that the 
suggested rngd per default assumes one bit of entropy with every data bit. 
This is not given with this noise source. This is the basis of my reply last 
time.

Herbert, Matt, should such noise sources be added to the HW random framework? 
The thing is that the in-kernel HW random to input_pool link per default uses 
a more conservative entropy estimate than the user space rngd. I would think 
that the in-kernel link would appropriate for that rng. But the user space 
rngd tool with its default behavior is not really suited here.

Thanks
Stephan
