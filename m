Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B487C64E7B
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 22:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E9202087C
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 22:13:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="i4VX172q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbgLAWNQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 17:13:16 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:60172 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgLAWNP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 17:13:15 -0500
Received: from [192.168.254.6] (unknown [50.46.158.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 1FB0713C2B0;
        Tue,  1 Dec 2020 14:12:35 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 1FB0713C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1606860755;
        bh=EYdaU8TB/xYzI6TH3iL0D/59oHns+NQcBxEZll2OYF4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=i4VX172qFGQ5CvK3nsXXVgrpMVOgd1S2+nnUwlwVB93wj0zVMnW1X4b+Xai979dDp
         Po1jJzuw32X2STwKROkgaOMRjyxlFL41phdimhJ5THPrkHhFOmR5rg1klhp0MrrsJz
         lo94Nt+jkeiYal2Pg50dGtcPjODSdpd9xpwlrsvw=
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Steve deRosier <derosier@cal-sierra.com>
References: <20201201194556.5220-1-ardb@kernel.org>
 <20201201215722.GA31941@gondor.apana.org.au>
 <CAMj1kXHb27ugTWuQZhPD0DvjtgYC8t_pj+igqK7dNfh+WsUS4w@mail.gmail.com>
 <20201201220431.GA32072@gondor.apana.org.au>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <acdaf933-e7a3-e30b-28c3-a324fe957979@candelatech.com>
Date:   Tue, 1 Dec 2020 14:12:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201201220431.GA32072@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/1/20 2:04 PM, Herbert Xu wrote:
> On Tue, Dec 01, 2020 at 11:01:57PM +0100, Ard Biesheuvel wrote:
>>
>> This is not the first time this has come up. The point is that CCMP in
>> the wireless stack is not used in 99% of the cases, given that any
>> wifi hardware built in the last ~10 years can do it in hardware. Only
>> in exceptional cases, such as Ben's, is there a need for exercising
>> this interface.
> 
> Either it matters or it doesn't.  If it doesn't matter why are we
> having this dicussion at all? If it does then fixing just one
> direction makes no sense.
> 
>> Also, care to explain why we have synchronous AEADs in the first place
>> if they are not supposed to be used?
> 
> Sync AEADs would make sense if you were dealing with a very small
> amount of data, e.g., one block.

Sure, I bet some part of the kernel does this.  So let the patch in to
handle that case.  It will just be happy luck that it improves some other
problems as well.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
