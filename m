Return-Path: <SRS0=Ahx1=BA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40BB7C433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 17:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1490B206C1
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 17:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgGURte (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jul 2020 13:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgGURte (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jul 2020 13:49:34 -0400
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8421C061794;
        Tue, 21 Jul 2020 10:49:33 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 5EC01BC1AC;
        Tue, 21 Jul 2020 17:49:28 +0000 (UTC)
Subject: Re: [PATCH for v5.9] ARM: STM32: Replace HTTP links with HTTPS ones
To:     Alexandre Torgue <alexandre.torgue@st.com>, linux@armlinux.org.uk,
        mcoquelin.stm32@gmail.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20200719094948.57487-1-grandmaster@al2klimov.de>
 <43c11c7a-269e-cc41-6934-0d2e0dec3226@st.com>
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
Message-ID: <219075a0-d7cf-a699-21d7-fabc6f077f95@al2klimov.de>
Date:   Tue, 21 Jul 2020 19:49:27 +0200
MIME-Version: 1.0
In-Reply-To: <43c11c7a-269e-cc41-6934-0d2e0dec3226@st.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Am 21.07.20 um 10:49 schrieb Alexandre Torgue:
> Hi Alexander
> 
> On 7/19/20 11:49 AM, Alexander A. Klimov wrote:
>> Rationale:
>> Reduces attack surface on kernel devs opening the links for MITM
>> as HTTPS traffic is much harder to manipulate.
>>
>> Deterministic algorithm:
>> For each file:
>>    If not .svg:
>>      For each line:
>>        If doesn't contain `\bxmlns\b`:
>>          For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
>>       If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
>>              If both the HTTP and HTTPS versions
>>              return 200 OK and serve the same content:
>>                Replace HTTP with HTTPS.
>>
>> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
> 
> This patch touch 2 different subsystems. Can you please split it ?
I can. But don't all files belong to the subsystem this patch is for?

➜  linux git:(autogen/1029) git show arch/arm/mach-stm32/Makefile.boot 
|perl scripts/get_maintainer.pl --nogit{,-fallback}
Russell King <linux@armlinux.org.uk> (odd fixer:ARM PORT)
Maxime Coquelin <mcoquelin.stm32@gmail.com> (maintainer:ARM/STM32 
ARCHITECTURE)
Alexandre Torgue <alexandre.torgue@st.com> (maintainer:ARM/STM32 
ARCHITECTURE)
linux-arm-kernel@lists.infradead.org (moderated list:ARM SUB-ARCHITECTURES)
linux-stm32@st-md-mailman.stormreply.com (moderated list:ARM/STM32 
ARCHITECTURE)
linux-kernel@vger.kernel.org (open list)
➜  linux git:(autogen/1029) git show crypto/testmgr.h |perl 
scripts/get_maintainer.pl --nogit{,-fallback}
Herbert Xu <herbert@gondor.apana.org.au> (maintainer:CRYPTO API)
"David S. Miller" <davem@davemloft.net> (maintainer:CRYPTO API)
Maxime Coquelin <mcoquelin.stm32@gmail.com> (maintainer:ARM/STM32 
ARCHITECTURE)
Alexandre Torgue <alexandre.torgue@st.com> (maintainer:ARM/STM32 
ARCHITECTURE)
linux-crypto@vger.kernel.org (open list:CRYPTO API)
linux-stm32@st-md-mailman.stormreply.com (moderated list:ARM/STM32 
ARCHITECTURE)
linux-arm-kernel@lists.infradead.org (moderated list:ARM/STM32 ARCHITECTURE)
linux-kernel@vger.kernel.org (open list)
➜  linux git:(autogen/1029)

> 
> Regards
> Alex
> 
> 
>> ---
>>   Continuing my work started at 93431e0607e5.
>>   See also: git log --oneline '--author=Alexander A. Klimov 
>> <grandmaster@al2klimov.de>' v5.7..master
>>   (Actually letting a shell for loop submit all this stuff for me.)
>>
>>   If there are any URLs to be removed completely
>>   or at least not (just) HTTPSified:
>>   Just clearly say so and I'll *undo my change*.
>>   See also: https://lkml.org/lkml/2020/6/27/64
>>
>>   If there are any valid, but yet not changed URLs:
>>   See: https://lkml.org/lkml/2020/6/26/837
>>
>>   If you apply the patch, please let me know.
>>
>>   Sorry again to all maintainers who complained about subject lines.
>>   Now I realized that you want an actually perfect prefixes,
>>   not just subsystem ones.
>>   I tried my best...
>>   And yes, *I could* (at least half-)automate it.
>>   Impossible is nothing! :)
>>
>>
>>   arch/arm/mach-stm32/Makefile.boot | 2 +-
>>   crypto/testmgr.h                  | 6 +++---
>>   2 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm/mach-stm32/Makefile.boot 
>> b/arch/arm/mach-stm32/Makefile.boot
>> index cec195d4fcba..5dde7328a7a9 100644
>> --- a/arch/arm/mach-stm32/Makefile.boot
>> +++ b/arch/arm/mach-stm32/Makefile.boot
>> @@ -1,4 +1,4 @@
>>   # SPDX-License-Identifier: GPL-2.0-only
>>   # Empty file waiting for deletion once Makefile.boot isn't needed 
>> any more.
>>   # Patch waits for application at
>> -# 
>> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7889/1 .
>> +# 
>> https://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7889/1 .
>> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
>> index d29983908c38..cdcf0d2fe40d 100644
>> --- a/crypto/testmgr.h
>> +++ b/crypto/testmgr.h
>> @@ -16231,7 +16231,7 @@ static const struct cipher_testvec 
>> aes_lrw_tv_template[] = {
>>                 "\xe9\x5d\x48\x92\x54\x63\x4e\xb8",
>>           .len    = 48,
>>       }, {
>> -/* 
>> http://www.mail-archive.com/stds-p1619@listserv.ieee.org/msg00173.html */
>> +/* 
>> https://www.mail-archive.com/stds-p1619@listserv.ieee.org/msg00173.html */ 
>>
>>           .key    = "\xf8\xd4\x76\xff\xd6\x46\xee\x6c"
>>                 "\x23\x84\xcb\x1c\x77\xd6\x19\x5d"
>>                 "\xfe\xf1\xa9\xf3\x7b\xbc\x8d\x21"
>> @@ -21096,7 +21096,7 @@ static const struct aead_testvec 
>> aegis128_tv_template[] = {
>>   /*
>>    * All key wrapping test vectors taken from
>> - * http://csrc.nist.gov/groups/STM/cavp/documents/mac/kwtestvectors.zip
>> + * https://csrc.nist.gov/groups/STM/cavp/documents/mac/kwtestvectors.zip
>>    *
>>    * Note: as documented in keywrap.c, the ivout for encryption is the 
>> first
>>    * semiblock of the ciphertext from the test vector. For decryption, 
>> iv is
>> @@ -22825,7 +22825,7 @@ static const struct cipher_testvec 
>> xeta_tv_template[] = {
>>    * FCrypt test vectors
>>    */
>>   static const struct cipher_testvec fcrypt_pcbc_tv_template[] = {
>> -    { /* 
>> http://www.openafs.org/pipermail/openafs-devel/2000-December/005320.html 
>> */
>> +    { /* 
>> https://www.openafs.org/pipermail/openafs-devel/2000-December/005320.html 
>> */
>>           .key    = "\x00\x00\x00\x00\x00\x00\x00\x00",
>>           .klen    = 8,
>>           .iv    = "\x00\x00\x00\x00\x00\x00\x00\x00",
>>
