Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD9BAC4332F
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Apr 2022 18:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbiDQSui (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 17 Apr 2022 14:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234828AbiDQSug (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 17 Apr 2022 14:50:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA8C2DD50
        for <linux-crypto@vger.kernel.org>; Sun, 17 Apr 2022 11:47:56 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1ng9vd-0007dZ-Pm; Sun, 17 Apr 2022 20:47:21 +0200
Message-ID: <4989d998-6ce3-139a-32b5-482234a11b68@pengutronix.de>
Date:   Sun, 17 Apr 2022 20:47:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v7 3/6] crypto: caam - add in-kernel interface for blob
 generator
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     kernel@pengutronix.de, David Gstir <david@sigma-star.at>,
        Tim Harvey <tharvey@gateworks.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Jan Luebbe <j.luebbe@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        Franck LENORMAND <franck.lenormand@nxp.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
References: <20220415205647.46056-1-a.fatoum@pengutronix.de>
 <20220415205647.46056-4-a.fatoum@pengutronix.de>
 <8a5166497604c721583eeafaef49c734ecac623c.camel@kernel.org>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <8a5166497604c721583eeafaef49c734ecac623c.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Jarkko,

On 17.04.22 17:02, Jarkko Sakkinen wrote:
> On Fri, 2022-04-15 at 22:56 +0200, Ahmad Fatoum wrote:
>> +int caam_process_blob(struct caam_blob_priv *priv,
>> +                     struct caam_blob_info *info, bool encap)
> 
> Documentation missing (it's exported).

It's documented in the header.

>> +/** struct caam_blob_info - information for CAAM blobbing
>> + *
> 
> You can remove this extra line, applies to some functions in the patch
> too.

You mean the blank line? Ye, that looks like it doesn't matter.
I just ran scripts/kernel-doc and apparently I need a space before
the struct caam_blob_info part, so it's even registered as a kernel doc.

Will fix for v8.
 
> BR, Jarkko

Thanks for the review.

Cheers,
Ahmad


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
