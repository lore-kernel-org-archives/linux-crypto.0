From: Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v2] RANDOM: ATH9K RNG delivers zero bits of entropy
Date: Mon, 15 Aug 2016 14:01:09 +0300
Message-ID: <87wpji70ui.fsf@purkki.adurom.net>
References: <34197429.2CvoIfft9B@positron.chronox.de>
	<1654172.XfclnXhRmn@positron.chronox.de>
	<657897b90b8344eeab10d7a0f604988d@aptaiexm02f.ap.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>, Ted Tso <tytso@mit.edu>,
	"Sepehrdad\, Pouyan" <pouyans@qti.qualcomm.com>,
	"herbert\@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto\@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel\@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"Jason Cooper" <jason@lakedaemon.net>
To: "Pan\, Miaoqing" <miaoqing@qti.qualcomm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57480 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbcHOLBQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Aug 2016 07:01:16 -0400
In-Reply-To: <657897b90b8344eeab10d7a0f604988d@aptaiexm02f.ap.qualcomm.com>
	(Miaoqing Pan's message of "Mon, 8 Aug 2016 02:03:36 +0000")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

"Pan, Miaoqing" <miaoqing@qti.qualcomm.com> writes:

> The entropy was evaluated by crypto expert, the analysis report show
> the ADC with at least 10bits and up to 22 bits of min-entropy for a 32
> bits value, we conservatively assume the min-entropy is 10 bits out of
> 32 bits, so that's why set entropy quality to 320/1024 = 10/32. Also
> we have explained in the commit message why can't use the HW RNG
> framework.
>
> Otherwise, your patch will cause high CPU load, as continuously read
> ADC data if entropy bits under write_wakeup_threshold.

Please don't top post, it breaks patchwork which is extremely annoying
for me:

https://patchwork.kernel.org/patch/9266265/

https://patchwork.kernel.org/patch/9266617/

-- 
Kalle Valo
