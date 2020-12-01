Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A7FC8301D
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 22:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B6CA2085B
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 22:01:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="PlFV4j1E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730473AbgLAWBZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 17:01:25 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:59440 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728913AbgLAWBY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 17:01:24 -0500
Received: from [192.168.254.6] (unknown [50.46.158.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 62BA813C2B0;
        Tue,  1 Dec 2020 14:00:42 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 62BA813C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1606860042;
        bh=CAfYLBj18HNt2Sg714B/NrU/02RK2zdhfwkZv6f8Gwo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=PlFV4j1E3BFr4mDg8FRFOvSavT3llcuvXyS8HnDK/qIyIyxNvjswgEWSNFfuQV/Ga
         Cal7R3Fe5a/7NcEbaJJy3xXP8CWquoiJC8xYX3/13YxjuzxxVmi0MrOE212qrhqttK
         MAYMggFdcZkJGKkO0FaZCkAkKkrCV+D1onANloUE=
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Steve deRosier <derosier@cal-sierra.com>
References: <20201201194556.5220-1-ardb@kernel.org>
 <20201201215722.GA31941@gondor.apana.org.au>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <60938181-3c15-9cc0-a4b4-1fa33595c44c@candelatech.com>
Date:   Tue, 1 Dec 2020 14:00:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201201215722.GA31941@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/1/20 1:57 PM, Herbert Xu wrote:
> On Tue, Dec 01, 2020 at 08:45:56PM +0100, Ard Biesheuvel wrote:
>> Add ccm(aes) implementation from linux-wireless mailing list (see
>> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/126679).
>>
>> This eliminates FPU context store/restore overhead existing in more
>> general ccm_base(ctr(aes-aesni),aes-aesni) case in MAC calculation.
>>
>> Suggested-by: Ben Greear <greearb@candelatech.com>
>> Co-developed-by: Steve deRosier <derosier@cal-sierra.com>
>> Signed-off-by: Steve deRosier <derosier@cal-sierra.com>
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>> ---
>> v2: avoid the SIMD helper, as it produces an CRYPTO_ALG_ASYNC aead, which
>>      is not usable by the 802.11 ccmp driver
> 
> Sorry, but this is not the way to go.  Please fix wireless to
> use the async interface instead.

No one wanted to do this for the last 6+ years, so I don't think it is likely
to happen any time soon.  If the patch is better than
existing behaviour, please let it into the kernel.  And it is certainly
better in my test case.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
