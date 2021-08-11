Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36DD8C4338F
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Aug 2021 05:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1578960F22
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Aug 2021 05:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbhHKF6A (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Aug 2021 01:58:00 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36784 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234443AbhHKF6A (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Aug 2021 01:58:00 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DB69B20107;
        Wed, 11 Aug 2021 05:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628661454; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3oVlfmojhP1VKbUc1oJoNsFUWAdYnTN2i6sVfH7jUz0=;
        b=hd3+O3kSdPcSNYP4w9t3VogbYZB23QtnFEnyhGj+qNZUKBc1nzq9/vXNy0STKyjItZ+bv2
        9PxbkX7KDaWHUn+ep5uey8ieS/x+0AVkLvc03DpEjYlD3CnPHlVv2zG8wtYIcSh6pGzZiU
        ED11s29jZZpsh5k5q7pnw10KixMPHtw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628661454;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3oVlfmojhP1VKbUc1oJoNsFUWAdYnTN2i6sVfH7jUz0=;
        b=JSkV3FFcnOtD9EdLnT74bkcchYXL9SCc5lWjc3+U6YFbzNkDyIkU/O3SlwG3ZmmAGjHoFD
        oQfMPjzKrn7clTBw==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 62D74137DA;
        Wed, 11 Aug 2021 05:57:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id x0N8Fs5mE2GoTgAAGKfGzw
        (envelope-from <hare@suse.de>); Wed, 11 Aug 2021 05:57:34 +0000
Subject: Re: [PATCH 04/13] lib/base64: RFC4648-compliant base64 encoding
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210810124230.12161-1-hare@suse.de>
 <20210810124230.12161-5-hare@suse.de> <YRLP5JuQrF/SJPBt@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <f3fc5af2-835c-4cb4-4715-9c95a359002c@suse.de>
Date:   Wed, 11 Aug 2021 07:57:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YRLP5JuQrF/SJPBt@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/10/21 9:13 PM, Eric Biggers wrote:
> On Tue, Aug 10, 2021 at 02:42:21PM +0200, Hannes Reinecke wrote:
>> Add RFC4648-compliant base64 encoding and decoding routines.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   include/linux/base64.h |  16 ++++++
>>   lib/Makefile           |   2 +-
>>   lib/base64.c           | 115 +++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 132 insertions(+), 1 deletion(-)
>>   create mode 100644 include/linux/base64.h
>>   create mode 100644 lib/base64.c
>>
>> diff --git a/include/linux/base64.h b/include/linux/base64.h
>> new file mode 100644
>> index 000000000000..660d4cb1ef31
>> --- /dev/null
>> +++ b/include/linux/base64.h
>> @@ -0,0 +1,16 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * base64 encoding, lifted from fs/crypto/fname.c.
>> + */
> 
> As I mentioned previously, please make it very clear which variant of Base64 it
> is (including whether padding is included and required or not), and update all
> the comments accordingly.  I've done so in fs/crypto/fname.c with
> https://lkml.kernel.org/r/20210718000125.59701-1-ebiggers@kernel.org.  It would
> probably be best to start over with a copy of that and modify it accordingly to
> implement the desired variant of Base64.
> 
Hmm. Looking into it.

>> +/**
>> + * base64_decode() - base64-decode some bytes
>> + * @src: the base64-encoded string to decode
>> + * @len: number of bytes to decode
>> + * @dst: (output) the decoded bytes.
> 
> "@len: number of bytes to decode" is ambiguous as it could refer to either @src
> or @dst.  I've fixed this in the fs/crypto/fname.c version.
> 

Ok, will be updating.

>> + *
>> + * Decodes the base64-encoded bytes @src according to RFC 4648.
>> + *
>> + * Return: number of decoded bytes
>> + */
> 
> Shouldn't this return an error if the string is invalid?  Again, see the latest
> fs/crypto/fname.c version.
> 

Indeed, it should. Will be fixing it up.

>> +int base64_decode(const char *src, int len, u8 *dst)
>> +{
>> +        int i, bits = 0, pad = 0;
>> +        u32 ac = 0;
>> +        size_t dst_len = 0;
>> +
>> +        for (i = 0; i < len; i++) {
>> +                int c, p = -1;
>> +
>> +                if (src[i] == '=') {
>> +                        pad++;
>> +                        if (i + 1 < len && src[i + 1] == '=')
>> +                                pad++;
>> +                        break;
>> +                }
>> +                for (c = 0; c < strlen(lookup_table); c++) {
> 
> strlen() shouldn't be used in a loop condition like this.
> 
Why not?
'lookup_table' is pretty much static, so where't the problem?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
