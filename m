From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH 1/2] crypto: caam - Fix DMA size in descriptor in ahash_digest()
Date: Wed, 27 Feb 2013 18:07:39 +0200
Message-ID: <512E2F4B.1000708@freescale.com>
References: <1357898637-18971-1-git-send-email-vakul@freescale.com> <1357898637-18971-2-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>,
	Steven Cornelius <steve.cornelius@freescale.com>
To: Vakul Garg <vakul@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:34305
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711Ab3B0QHu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Feb 2013 11:07:50 -0500
Received: from mail2-am1 (localhost [127.0.0.1])	by mail2-am1-R.bigfish.com
 (Postfix) with ESMTP id 3D4671A0115	for <linux-crypto@vger.kernel.org>; Wed,
 27 Feb 2013 16:07:48 +0000 (UTC)
Received: from AM1EHSMHS018.bigfish.com (unknown [10.3.201.230])	by
 mail2-am1.bigfish.com (Postfix) with ESMTP id D6EFA20053	for
 <linux-crypto@vger.kernel.org>; Wed, 27 Feb 2013 16:07:46 +0000 (UTC)
In-Reply-To: <1357898637-18971-2-git-send-email-vakul@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

(adding Steve; please Cc patch authors)

On 1/11/2013 12:03 PM, Vakul Garg wrote:
> From: Steve Cornelius <steve.cornelius@freescale.com>
>
> Save of DMA size in extended descriptor was missing.
> Thus crashes could occur during post-request unmapping.

It would be nice to include a traceback in the commit message (btw, the 
2nd patch does that).
Maybe Steve could provide one or tell you how to reproduce the issue.

Regards,
Horia
