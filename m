Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EEC9C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 11 May 2022 10:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiEKKtK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 May 2022 06:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235380AbiEKKtK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 May 2022 06:49:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBA556C22
        for <linux-crypto@vger.kernel.org>; Wed, 11 May 2022 03:49:09 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1nojtn-0005qR-7n; Wed, 11 May 2022 12:48:55 +0200
Message-ID: <e49920e6-0852-ad3d-5758-604655591671@pengutronix.de>
Date:   Wed, 11 May 2022 12:48:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v9 7/7] MAINTAINERS: add KEYS-TRUSTED-CAAM
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
        Michael Walle <michael@walle.cc>,
        Sumit Garg <sumit.garg@linaro.org>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
References: <20220506062553.1068296-1-a.fatoum@pengutronix.de>
 <20220506062553.1068296-8-a.fatoum@pengutronix.de> <YnbH2Fgn/JFOU3Rf@iki.fi>
 <YnbIiJynQq/tcFa2@iki.fi>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <YnbIiJynQq/tcFa2@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 07.05.22 21:29, Jarkko Sakkinen wrote:
>>> +KEYS-TRUSTED-CAAM
>>> +M:	Ahmad Fatoum <a.fatoum@pengutronix.de>
>>> +R:	Pengutronix Kernel Team <kernel@pengutronix.de>
>>> +L:	linux-integrity@vger.kernel.org
>>> +L:	keyrings@vger.kernel.org
>>> +S:	Maintained
>>> +F:	include/keys/trusted_caam.h
>>> +F:	security/keys/trusted-keys/trusted_caam.c
>>> +
>>>  KEYS/KEYRINGS
>>>  M:	David Howells <dhowells@redhat.com>
>>>  M:	Jarkko Sakkinen <jarkko@kernel.org>
>>> -- 
>>> 2.30.2
>>>
>>
>> Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> 3/7 would probably need tested-by. Other than that this starts to look
> good...

It has been tested by me on an i.MX6 (era < 10 with blobbing support)
and by Michael on a LS1028A (era >= 10, both with and without blobbing
support).

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
