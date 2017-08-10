From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH v8 1/4] crypto: AF_ALG -- add sign/verify API
Date: Thu, 10 Aug 2017 16:59:33 +0300
Message-ID: <6ebe88ef-58a0-6397-2a37-cdaf0bb9ac07@microchip.com>
References: <26359147.tCiuJ5s8mz@positron.chronox.de>
 <1701667.ajpEH4uy8Y@positron.chronox.de>
 <45021398-1ff4-77af-2fea-92a02b4a33c4@microchip.com>
 <5164071.4MUeWmsg9v@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:26560 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751373AbdHJN7u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2017 09:59:50 -0400
In-Reply-To: <5164071.4MUeWmsg9v@tauon.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 08/10/2017 04:03 PM, Stephan Mueller wrote:
> Is there a style requirement for that? checkpatch.pl does not complain. I
> thought that one liners in a conditional should not have braces?

Linux coding style requires braces in both branches when you have a
branch with a statement and the other with multiple statements.

Checkpatch complains about this when you run it with --strict option.

Cheers,
ta
