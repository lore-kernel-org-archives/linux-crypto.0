From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: Re: [PATCH] crypto: caam - don't emit ICV check failures to dmesg
Date: Wed, 21 Jan 2015 10:57:32 +0200
Message-ID: <54BF69FC.9040607@freescale.com>
References: <1414686811-6527-1-git-send-email-tudor.ambarus@freescale.com>
	<1414688107-8196-1-git-send-email-tudor.ambarus@freescale.com>
	<20141106151714.GE4544@gondor.apana.org.au>
	<20141204182245.f352ea22dc61ea6f65d85c62@freescale.com>
	<20141211193018.2465016d545334a76c0f4bab@freescale.com>
 <20150120124310.ba1dd7a6454f65255c1ed713@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: Tudor Ambarus <tudor.ambarus@freescale.com>,
	<linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Marek Vasut <marex@denx.de>,
	Horia Geanta <horia.geanta@freescale.com>,
	<linux-kernel@vger.kernel.org>
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0121.outbound.protection.outlook.com ([65.55.169.121]:52304
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751974AbbAUJMp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Jan 2015 04:12:45 -0500
In-Reply-To: <20150120124310.ba1dd7a6454f65255c1ed713@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Kim,

On 01/20/2015 08:43 PM, Kim Phillips wrote:
> ICV check failures are part of normal operation;
> leave user notification up to the higher levels,
> as is done in s/w algorithm implementations.
> 

Tested on P4080DS.

Tested-by: Cristian Stoica <cristian.stoica@freescale.com>


Thanks,
Cristian S.
