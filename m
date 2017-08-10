From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v8 1/4] crypto: AF_ALG -- add sign/verify API
Date: Thu, 10 Aug 2017 16:06:12 +0200
Message-ID: <2002677.leAxRpiHVk@positron.chronox.de>
References: <26359147.tCiuJ5s8mz@positron.chronox.de> <5164071.4MUeWmsg9v@tauon.chronox.de> <6ebe88ef-58a0-6397-2a37-cdaf0bb9ac07@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58476 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751439AbdHJOGO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2017 10:06:14 -0400
In-Reply-To: <6ebe88ef-58a0-6397-2a37-cdaf0bb9ac07@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 10. August 2017, 15:59:33 CEST schrieb Tudor Ambarus:

Hi Tudor,

> On 08/10/2017 04:03 PM, Stephan Mueller wrote:
> > Is there a style requirement for that? checkpatch.pl does not complain. I
> > thought that one liners in a conditional should not have braces?
> 
> Linux coding style requires braces in both branches when you have a
> branch with a statement and the other with multiple statements.
> 
> Checkpatch complains about this when you run it with --strict option.

Ok, then I will add it.

Thanks

Ciao
Stephan
