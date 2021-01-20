Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C01C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 13:46:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A54A82336D
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 13:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389843AbhATMgz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 07:36:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732874AbhATL6q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 06:58:46 -0500
Received: from smtp-bc0c.mail.infomaniak.ch (smtp-bc0c.mail.infomaniak.ch [IPv6:2001:1600:4:17::bc0c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1CBC0613C1
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jan 2021 03:57:58 -0800 (PST)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4DLPD51qGvzMprhY;
        Wed, 20 Jan 2021 12:57:57 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4DLPD41QBczlppyj;
        Wed, 20 Jan 2021 12:57:56 +0100 (CET)
Subject: Re: [PATCH v3 08/10] certs: Check that builtin blacklist hashes are
 valid
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        James Morris <jmorris@namei.org>,
        =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "Serge E . Hallyn" <serge@hallyn.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
References: <20210114151909.2344974-1-mic@digikod.net>
 <20210114151909.2344974-9-mic@digikod.net> <YAe9egzT5D7B0swR@kernel.org>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <11ce77c9-7b43-e2a0-55bc-c0035bf3d681@digikod.net>
Date:   Wed, 20 Jan 2021 12:57:55 +0100
User-Agent: 
MIME-Version: 1.0
In-Reply-To: <YAe9egzT5D7B0swR@kernel.org>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 20/01/2021 06:19, Jarkko Sakkinen wrote:
> On Thu, Jan 14, 2021 at 04:19:07PM +0100, Mickaël Salaün wrote:
>> From: Mickaël Salaün <mic@linux.microsoft.com>
>>
>> Add and use a check-blacklist-hashes.awk script to make sure that the
>> builtin blacklist hashes will be approved by the run time blacklist
>> description checks.  This is useful to debug invalid hash formats, and
>> it make sure that previous hashes which could have been loaded in the
>> kernel (but ignored) are now noticed and deal with by the user.
>>
>> Cc: David Howells <dhowells@redhat.com>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
>> Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> I get this with a self-signed cert:
> 
> certs/Makefile:18: *** target pattern contains no '%'.  Stop.
> 
> CONFIG_SYSTEM_BLACKLIST_HASH_LIST="tbs:8eed1340eef37c1dc84d996406ad05c7dbb3eade19132d688408ca2f63904869"

As said in the Kconfig documentation for
CONFIG_SYSTEM_BLACKLIST_HASH_LIST, you need to provide a file with the
list, not to set the string directly in the configuration variable. This
patch series didn't change this behavior. The same kind of macros are
used for CONFIG_MODULE_SIG_KEY.

> 
> I used the script in 10/10 to test this, which is another
> reamark: the patches are in invalid order, as you need to
> apply 10/10 before you can test  8/10.

I'll move patch 10/10 earlier but this kind of formatting was already
required (but silently ignored) for this option to be really taken into
account. Only the kernel code was available to understand how to
effectively create such hash.

> 
> /Jarkko
> 
