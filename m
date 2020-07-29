Return-Path: <SRS0=Hj06=BI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C234C433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jul 2020 12:27:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C7E02070B
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jul 2020 12:27:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="GVJTOTZb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgG2M1I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Jul 2020 08:27:08 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:60750 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgG2M1I (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Jul 2020 08:27:08 -0400
Received: from [192.168.254.5] (unknown [50.34.202.127])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id B6F7013C2B0;
        Wed, 29 Jul 2020 05:27:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com B6F7013C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1596025627;
        bh=LXc+nfjOtCqCwK3G7cBypWRehRtXELH1bBgp7z3d0/s=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=GVJTOTZb4zdl/2H3GJYiS8K8USmFlJgXNkDRgmCUdD5DgDW8TTINAfuSZ9FpHLeOh
         FibPQCkemNMRPePY+Q2xJ9qyn3cns4KBnN7zvK5AOjuK0GtL1Ob94WOJkduc+kjj3D
         ViZkxRSBw0wQI3DdkYIfit3tXiYGv/4ZWPgQrdGs=
Subject: Re: Help getting aesni crypto patch upstream
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <2a55b661-512b-9479-9fff-0f2e2a581765@candelatech.com>
 <CAMj1kXFwPPDfm1hvW+LgnfuPO-wfguTZ0NcLyeyesGeBcuDKGQ@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <04d8e7e3-700b-44b2-e8f2-5126abf21a62@candelatech.com>
Date:   Wed, 29 Jul 2020 05:27:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXFwPPDfm1hvW+LgnfuPO-wfguTZ0NcLyeyesGeBcuDKGQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/28/20 11:06 PM, Ard Biesheuvel wrote:
> On Wed, 29 Jul 2020 at 01:03, Ben Greear <greearb@candelatech.com> wrote:
>>
>> Hello,
>>
>> As part of my wifi test tool, I need to do decrypt AES on the CPU, and the only way this
>> performs well is to use aesni.  I've been using a patch for years that does this, but
>> recently somewhere between 5.4 and 5.7, the API I've been using has been removed.
>>
>> Would anyone be interested in getting this support upstream?  I'd be happy to pay for
>> the effort.
>>
>> Here is the patch in question:
>>
>> https://github.com/greearb/linux-ct-5.7/blob/master/wip/0001-crypto-aesni-add-ccm-aes-algorithm-implementation.patch
>>
>> Please keep me in CC, I'm not subscribed to this list.
>>
> 
> Hi Ben,
> 
> Recently, the x86 FPU handling was improved to remove the overhead of
> preserving/restoring of the register state, so the issue that this
> patch fixes may no longer exist. Did you try?
> 
> In any case, according to the commit log on that patch, the problem is
> in the MAC generation, so it might be better to add a cbcmac(aes)
> implementation only, and not duplicate all the CCM boilerplate.
> 

Hello,

I don't know all of the details, and do not understand the crypto subsystem,
but I am pretty sure that I need at least some of this patch.

If you can suggest a patch to try I'll be happy to test it to see how it
performs.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
