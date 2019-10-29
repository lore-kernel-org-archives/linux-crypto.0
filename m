Return-Path: <SRS0=WkI6=YW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C8B1CA9EAE
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Oct 2019 09:19:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1920F20830
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Oct 2019 09:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572340791;
	bh=zl1P46j7VLTxaA1nHq9YSTjOkJ+meMpTFNCHAgimeyE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=AGwcRxPDTm7ATL1hqHKsrWhGH+6kxD5m5CA81ZKbK30u0Z9jAU8BVNwnuiR53wj74
	 1Co31/L/q34XPMd62qooGXr95xPDNonCM/hIsZm8VCv4Gxdpd3zDd7W6ZXwDwLzFXw
	 TK8kdFl/l2OdwHqoBPcfRV0BiKfkoN/CN2xueEDc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbfJ2JTq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Oct 2019 05:19:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:60226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727228AbfJ2JTq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Oct 2019 05:19:46 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6387520717;
        Tue, 29 Oct 2019 09:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572340785;
        bh=zl1P46j7VLTxaA1nHq9YSTjOkJ+meMpTFNCHAgimeyE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QpBq8nhFYVFXZia+EJOHKHZwqk5F5lGyWOQMZN/0CskDdcVjVp3wL0BF+lnuNq+b7
         JSre38HMinoYbXjRE7SFTPyOHSB7j4M0VBKFsYdusSp/dVxBAzG6OuTALdOzAGpvhR
         HTXpckj4aGFBTfMer/llZvSOC0M05zba47xLyl2Q=
Date:   Tue, 29 Oct 2019 05:19:43 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.19 063/100] crypto: arm/aes-ce - add dependency
 on AES library
Message-ID: <20191029091943.GL1554@sasha-vm>
References: <20191018220525.9042-1-sashal@kernel.org>
 <20191018220525.9042-63-sashal@kernel.org>
 <CAKv+Gu_6vzE-Je4G-ZZ=jU1qAWnCcADr7cJ_MG8m+tPzcC0QBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_6vzE-Je4G-ZZ=jU1qAWnCcADr7cJ_MG8m+tPzcC0QBw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 21, 2019 at 08:08:02AM +0200, Ard Biesheuvel wrote:
>On Sat, 19 Oct 2019 at 00:07, Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>
>> [ Upstream commit f703964fc66804e6049f2670fc11045aa8359b1a ]
>>
>> The ARM accelerated AES driver depends on the new AES library for
>> its non-SIMD fallback so express this in its Kconfig declaration.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Please drop this, it doesn't belong in -stable.

I've dropped it, thank you.

-- 
Thanks,
Sasha
