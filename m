Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AEFDC63777
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 22:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 249422076C
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 22:54:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="r7fyhpkS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388848AbgK3WyU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Nov 2020 17:54:20 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:45312 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388847AbgK3WyT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Nov 2020 17:54:19 -0500
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Nov 2020 17:54:19 EST
Received: from [192.168.254.6] (unknown [50.46.158.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 4709A13C2B0;
        Mon, 30 Nov 2020 14:47:59 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 4709A13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1606776479;
        bh=ouvyFm6PapYOnUiuqySiexyIHG1eqaJbBpaBjVJqLiA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=r7fyhpkSkqZVCcFlJ+vSOlpvIteRUD7VmfSOTbNXmDza74rgLVMZhvojdKaSzaViL
         JjFMnHoXUv4Uek5JYNv6oBzoNYq70MT+9n1/dC22ZzRf76ZITrNxGNEzeX9nC8VrUR
         dCNDbppOygrAgceAz3EC+fj0HuPT5vIAE2qGYCus=
Subject: Re: [PATCH] crypto: aesni - add ccm(aes) algorithm implementation
To:     Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Steve deRosier <derosier@cal-sierra.com>
References: <20201129182035.7015-1-ardb@kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <4e850713-af8b-f81f-bf3d-f4ee5185d99f@candelatech.com>
Date:   Mon, 30 Nov 2020 14:47:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201129182035.7015-1-ardb@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/29/20 10:20 AM, Ard Biesheuvel wrote:
> From: Steve deRosier <ardb@kernel.org>
> 
> Add ccm(aes) implementation from linux-wireless mailing list (see
> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/126679).
> 
> This eliminates FPU context store/restore overhead existing in more
> general ccm_base(ctr(aes-aesni),aes-aesni) case in MAC calculation.
> 
> Suggested-by: Ben Greear <greearb@candelatech.com>
> Co-developed-by: Steve deRosier <derosier@cal-sierra.com>
> Signed-off-by: Steve deRosier <derosier@cal-sierra.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> Ben,
> 
> This is almost a rewrite of the original patch, switching to the new
> skcipher API, using the existing SIMD helper, and drop numerous unrelated
> changes. The basic approach is almost identical, though, so I expect this
> to perform on par or perhaps slightly faster than the original.
> 
> Could you please confirm with some numbers?

I tried this on my apu2 platform, here is perf top during a TCP download using
rx-sw-crypt (ie, the aesni cpu decrypt path):

   18.77%  [kernel]                            [k] acpi_idle_enter
   14.68%  [kernel]                            [k] kernel_fpu_begin
    4.45%  [kernel]                            [k] __crypto_xor
    3.46%  [kernel]                            [k] _aesni_enc1

Total throughput is 127Mbps or so.  This is with your patch applied to 5.8.0+
kernel (it applied clean with 'git am')

Is there a good way to verify at runtime that I've properly applied your patch?

On my 5.4 kernel with the old version of the patch installed, I see 253Mbps throughput,
and perf-top shows:

   13.33%  [kernel]                            [k] acpi_idle_do_entry
    9.21%  [kernel]                            [k] _aesni_enc1
    4.49%  [unknown]                           [.] 0x00007fbc3f00adb6
    4.34%  [unknown]                           [.] 0x00007fbc3f00adba
    3.85%  [kernel]                            [k] memcpy


So, new patch is not working that well for me...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
