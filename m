Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 447EFC4332B
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 13:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F40FB23371
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 13:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389835AbhATMgu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 07:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389481AbhATL2p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 06:28:45 -0500
Received: from smtp-1908.mail.infomaniak.ch (smtp-1908.mail.infomaniak.ch [IPv6:2001:1600:4:17::1908])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EAFC061796
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jan 2021 03:27:59 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4DLNTf3RKYzMqYtx;
        Wed, 20 Jan 2021 12:24:38 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4DLNTd4lTqzlh8Th;
        Wed, 20 Jan 2021 12:24:37 +0100 (CET)
Subject: Re: [PATCH v3 09/10] certs: Allow root user to append signed hashes
 to the blacklist keyring
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
 <20210114151909.2344974-10-mic@digikod.net> <YAe+PZHadpJcR0oc@kernel.org>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <958b2ea4-7b31-da90-2efd-019166a6029b@digikod.net>
Date:   Wed, 20 Jan 2021 12:24:36 +0100
User-Agent: 
MIME-Version: 1.0
In-Reply-To: <YAe+PZHadpJcR0oc@kernel.org>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 20/01/2021 06:23, Jarkko Sakkinen wrote:
> On Thu, Jan 14, 2021 at 04:19:08PM +0100, Mickaël Salaün wrote:
>> From: Mickaël Salaün <mic@linux.microsoft.com>
>>
>> Add a kernel option SYSTEM_BLACKLIST_AUTH_UPDATE to enable the root user
>> to dynamically add new keys to the blacklist keyring.  This enables to
>> invalidate new certificates, either from being loaded in a keyring, or
>> from being trusted in a PKCS#7 certificate chain.  This also enables to
>> add new file hashes to be denied by the integrity infrastructure.
>>
>> Being able to untrust a certificate which could have normaly been
>> trusted is a sensitive operation.  This is why adding new hashes to the
>> blacklist keyring is only allowed when these hashes are signed and
>> vouched by the builtin trusted keyring.  A blacklist hash is stored as a
>> key description.  The PKCS#7 signature of this description must be
>> provided as the key payload.
>>
>> Marking a certificate as untrusted should be enforced while the system
>> is running.  It is then forbiden to remove such blacklist keys.
>>
>> Update blacklist keyring and blacklist key access rights:
>> * allows the root user to search for a specific blacklisted hash, which
>>   make sense because the descriptions are already viewable;
>> * forbids key update;
>> * restricts kernel rights on the blacklist keyring to align with the
>>   root user rights.
>>
>> See the help in tools/certs/print-cert-tbs-hash.sh provided by a
>> following commit.
> 
> Please re-order patches in a way that print-cert-tbs-hash.sh is
> available before this. That way we get rid of this useless remark.

OK

> 
>> Cc: David Howells <dhowells@redhat.com>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
> 
> /Jarkko
> 
