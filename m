Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00904C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Dec 2020 20:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B345D2311A
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Dec 2020 20:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405863AbgLKSgd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Dec 2020 13:36:33 -0500
Received: from smtp-42ad.mail.infomaniak.ch ([84.16.66.173]:40589 "EHLO
        smtp-42ad.mail.infomaniak.ch" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405908AbgLKSf5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Dec 2020 13:35:57 -0500
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Cszwr3JjdzlhGWC;
        Fri, 11 Dec 2020 19:35:08 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Cszwq4QFBzlh8TC;
        Fri, 11 Dec 2020 19:35:07 +0100 (CET)
Subject: Re: [PATCH v1 2/9] certs: Make blacklist_vet_description() more
 strict
To:     David Howells <dhowells@redhat.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "Serge E . Hallyn" <serge@hallyn.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
References: <20201120180426.922572-3-mic@digikod.net>
 <20201120180426.922572-1-mic@digikod.net>
 <113978.1607090965@warthog.procyon.org.uk>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <4362ac88-7514-27d2-f937-1cd405bd2e1a@digikod.net>
Date:   Fri, 11 Dec 2020 19:35:06 +0100
User-Agent: 
MIME-Version: 1.0
In-Reply-To: <113978.1607090965@warthog.procyon.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 04/12/2020 15:09, David Howells wrote:
> Mickaël Salaün <mic@digikod.net> wrote:
> 
>> +	if (*desc)
>> +		/* The hash is greater than MAX_HASH_LEN. */
>> +		return -EINVAL;
> 
> -ENOPKG might be better.  It's not that the string is invalid, it's just that
> it's unsupported at the moment.

Indeed, I'll use that.

> 
> David
> 
