From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [HIFN 00/03]: RNG support v2
Date: Mon, 19 Nov 2007 13:34:28 +0300
Message-ID: <20071119103428.GB2048@2ka.mipt.ru>
References: <20071118213241.9217.7696.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	mb@bu3sch.de, linux-kernel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:49854 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbXKSKfQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Nov 2007 05:35:16 -0500
Content-Disposition: inline
In-Reply-To: <20071118213241.9217.7696.sendpatchset@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Patrick.

On Sun, Nov 18, 2007 at 10:32:52PM +0100, Patrick McHardy (kaber@trash.net) wrote:
> These patches add support for using the HIFN rng.

> Patrick McHardy (3):
>       [HWRNG]: move status polling loop to data_present callbacks
>       [HIFN]: Improve PLL initialization
>       [HIFN]: Add support for using the random number generator

Thanks a lot for your patches.
Ack for all three.

-- 
	Evgeniy Polyakov
