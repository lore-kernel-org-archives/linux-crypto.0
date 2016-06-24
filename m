From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 2/3] hw_random: bcm2835: Add support for Broadcom BCM5301x
Date: Fri, 24 Jun 2016 10:30:46 -0700
Message-ID: <576D6E46.5000906@gmail.com>
References: <1466641623-3491-1-git-send-email-f.fainelli@gmail.com>
 <1466641623-3491-3-git-send-email-f.fainelli@gmail.com>
 <20160624133122.GC21111@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, yendapally.reddy@broadcom.com,
	eric@anholt.net, bcm-kernel-feedback-list@broadcom.com,
	devicetre@vger.kernel.org, hauke@hauke-m.de, zajec5@gmail.com,
	mpm@selenic.com, linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:32824 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbcFXRat (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 13:30:49 -0400
In-Reply-To: <20160624133122.GC21111@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/24/2016 06:31 AM, Herbert Xu wrote:
> On Wed, Jun 22, 2016 at 05:27:02PM -0700, Florian Fainelli wrote:
>> The Broadcom BCM5301x SoCs (Northstar) utilize the same random number
>> generator peripheral as Northstar Plus and BCM2835, but just like the
>> NSP SoC, we need to enable the interrupt.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Patch applied.
> 

Thanks! Do you mind taking patch 1 as well? I will take patch 3 via my
arm-soc tree.
-- 
Florian
