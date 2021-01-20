Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4DC8C433E6
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 13:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96FAB23371
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 13:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388668AbhATMgh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 07:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731255AbhATL1G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 06:27:06 -0500
Received: from smtp-8fa8.mail.infomaniak.ch (smtp-8fa8.mail.infomaniak.ch [IPv6:2001:1600:4:17::8fa8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355B9C06179B;
        Wed, 20 Jan 2021 03:24:42 -0800 (PST)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4DLNSf5XhtzMqYtf;
        Wed, 20 Jan 2021 12:23:46 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4DLNSd6gDLzlh8TP;
        Wed, 20 Jan 2021 12:23:45 +0100 (CET)
Subject: Re: [PATCH v3 06/10] certs: Make blacklist_vet_description() more
 strict
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
 <20210114151909.2344974-7-mic@digikod.net> <YAeul+B2x6QK0NVq@kernel.org>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <491f8d01-b525-2bcf-68d8-c28bfc9f1532@digikod.net>
Date:   Wed, 20 Jan 2021 12:23:45 +0100
User-Agent: 
MIME-Version: 1.0
In-Reply-To: <YAeul+B2x6QK0NVq@kernel.org>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 20/01/2021 05:16, Jarkko Sakkinen wrote:
> On Thu, Jan 14, 2021 at 04:19:05PM +0100, Mickaël Salaün wrote:
>> From: Mickaël Salaün <mic@linux.microsoft.com>
>>
>> Before exposing this new key type to user space, make sure that only
>> meaningful blacklisted hashes are accepted.  This is also checked for
>> builtin blacklisted hashes, but a following commit make sure that the
>> user will notice (at built time) and will fix the configuration if it
>> already included errors.
>>
>> Check that a blacklist key description starts with a valid prefix and
>> then a valid hexadecimal string.
>>
>> Cc: David Howells <dhowells@redhat.com>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
>> Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> In this I'm not as worried about ABI, i.e. you don't have any reason
> supply any other data, which doesn't follow these ruels, whereas there
> could very well be a script that does format hex "incorrectly".

I think I answered this comment in patch 2/10: there is no ABI breakage,
it only prepares for safe dynamic key addition. Patch 10/10 enables to
avoid using incorrect/useless/mis-leading hashes and force users to fix
these hashes (that were not taken into account)

> 
> /Jarkko
> 
