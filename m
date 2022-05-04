Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42EA7C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  4 May 2022 04:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344621AbiEDFCD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 May 2022 01:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237376AbiEDFCC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 May 2022 01:02:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AD92DAAA
        for <linux-crypto@vger.kernel.org>; Tue,  3 May 2022 21:58:25 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1nm75D-0005zB-6B; Wed, 04 May 2022 06:57:51 +0200
Message-ID: <0044fa04-aa85-f27a-3224-839c848d54ef@pengutronix.de>
Date:   Wed, 4 May 2022 06:57:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v8 6/6] MAINTAINERS: add myself as CAAM trusted key
 maintainer
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     James Bottomley <jejb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        David Howells <dhowells@redhat.com>, kernel@pengutronix.de,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Jan Luebbe <j.luebbe@pengutronix.de>,
        David Gstir <david@sigma-star.at>,
        Richard Weinberger <richard@nod.at>,
        Franck LENORMAND <franck.lenormand@nxp.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Sumit Garg <sumit.garg@linaro.org>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
References: <20220428140145.870527-1-a.fatoum@pengutronix.de>
 <20220428140145.870527-7-a.fatoum@pengutronix.de>
 <YnIAEmUKfFxoGlwr@kernel.org>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <YnIAEmUKfFxoGlwr@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 04.05.22 06:24, Jarkko Sakkinen wrote:
> "MAINTAINERS: add KEYS-TRUSTED-CAAM"

I assume that's your preferred commit message title? I can change it.

> On Thu, Apr 28, 2022 at 04:01:45PM +0200, Ahmad Fatoum wrote:
>> Add myself as maintainer for the just added trusted key integration
>> with the NXP Cryptographic Acceleration and Assurance Module.
> 
> Please, remove "just added". Also what the heck is this integration
> in this context? It's afaik a process and not any sort of asset.

It's glue code between CAAM driver and trusted keys, so it's an integration
of the former with the latter.

> Maybe rephrase the whole paragraph simply:
> 
> "Create a maintainer entry for CAAM trusted keys in the Linux keyring."

Sure, can do for v9.

Cheers,
Ahmad

> 
> BR, Jarkko
> 


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
