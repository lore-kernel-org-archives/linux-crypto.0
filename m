From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Date: Tue, 09 Aug 2016 11:56:08 +0200
Message-ID: <12791731.pG3fmEhvyp@tauon.atsec.com>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org> <1645997.7cVzaEi3NG@tauon.atsec.com> <20160809094656.GB6529@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>,
	Matt Mackall <mpm@selenic.com>,
	"miaoqing@codeaurora.org" <miaoqing@codeaurora.org>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"jason@lakedaemon.net" <jason@lakedaemon.net>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34318 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbcHIJ4O (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 05:56:14 -0400
In-Reply-To: <20160809094656.GB6529@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 9. August 2016, 17:46:56 CEST schrieb Herbert Xu:

Hi Herbert,
> 
> You're supposed to tweak the quality of the input.  In any case,

How is that tweak supposed to happen? The rngd does not allow changing the 
amount of read data relative to the assumed entropy.

> this is not affected by whether we whiten the result.

I understand that.

Ciao
Stephan
