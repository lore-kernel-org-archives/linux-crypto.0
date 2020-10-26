Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5248C388F9
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 19:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D0682085B
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 19:13:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t8GeCQ8Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404216AbgJZTNS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 15:13:18 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45200 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1735309AbgJZTET (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 15:04:19 -0400
Received: by mail-wr1-f68.google.com with SMTP id e17so13919665wru.12;
        Mon, 26 Oct 2020 12:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vv8QX0mXek+iVwa0PLmBZRi4t6g6SQqpZZ7vrfZ8LxM=;
        b=t8GeCQ8YvzAivbqfQO+3MRLLzvwgvvHV4+49F67htNXPgFVWZwyejS/cqBRttKYG7Q
         3MThZmh0WRGcOEAXHnSG1TGeI0a6GKa7ciFimqyMPMjNSwTVVcaLoElxdu0E2PuXRiqW
         g2RbceWU+CGpJHRvM/A579Rk9LSo5sIC1YkdjJ6VeL2RJRmP+PHzNVNgb1t3cDB350V7
         erzHBbq6hsqDaCHk+WbZJPjuKR5AABK+2dbBDF3hP76YxNRUDkqqeGmrEspaOXbv7QZA
         D3DLGpOEp6bN08ZuOXn0vFzidNiP7DsFZKRLGIfXg5+trni10fQKtapZ5y7i/VoQXGkR
         xPRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vv8QX0mXek+iVwa0PLmBZRi4t6g6SQqpZZ7vrfZ8LxM=;
        b=Be4oKO5VNFjmxUbjUwQpqIu2JaQ55NHL1IrBHTPOebtsbQTXQ+JaAp1oCOE93Awt5d
         c2wQKR+PNYYkciKDJ8GZsSicWG9B0ndvWFwe6ZJPCJfuBHsUjKQO8NA69GTQ+8CITLRx
         uZOLHLUGOdb8eRPNLBJSrCDAj8TyKPvEXQw7eudpQj8UCiERLUx4vVZbL6bP3HhcYkBe
         DHUKhR5MWHTmTHkW6noDpwGa5uAMYa66gnnIjGQHMI4s6U7YQHzfxZCXmrwOparBu3Ru
         XdRhlejM3tkTlzHlKyZxKOpU3wbCxlkm56LHZENdMjK+8ie7og1xl3YQMLuh/iCsunvd
         K/sQ==
X-Gm-Message-State: AOAM531UtLcyr+y+Esp71FFhAGI14GkYiXBWrbWv5+WtUW2VtACaMtLY
        /ChB99sNO3rnTrucqtX78xcvjlHyUEkP1g==
X-Google-Smtp-Source: ABdhPJwxym73bt0NMXBaGG36oenzzsBNpxOTH9eF4YGx66Xb2iNsnijSuHGwKn8KQsb4LS1YGxys8w==
X-Received: by 2002:a5d:4010:: with SMTP id n16mr18635180wrp.97.1603739055074;
        Mon, 26 Oct 2020 12:04:15 -0700 (PDT)
Received: from [192.168.2.28] (39.35.broadband4.iol.cz. [85.71.35.39])
        by smtp.gmail.com with ESMTPSA id t62sm22625877wmf.22.2020.10.26.12.04.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2020 12:04:14 -0700 (PDT)
Subject: Re: [PATCH 3/4] dm crypt: switch to EBOIV crypto API template
To:     Eric Biggers <ebiggers@kernel.org>,
        Milan Broz <gmazyland@gmail.com>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Song Liu <song@kernel.org>, Ofir Drang <ofir.drang@arm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org
References: <20201026130450.6947-1-gilad@benyossef.com>
 <20201026130450.6947-4-gilad@benyossef.com>
 <20201026175231.GG858@sol.localdomain>
 <d07b062c-1405-4d72-b907-1c4dfa97aecb@gmail.com>
 <20201026183936.GJ858@sol.localdomain>
From:   Milan Broz <gmazyland@gmail.com>
Message-ID: <fd5e46ce-a4bf-8025-05ea-e20d35485446@gmail.com>
Date:   Mon, 26 Oct 2020 20:04:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201026183936.GJ858@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 26/10/2020 19:39, Eric Biggers wrote:
> On Mon, Oct 26, 2020 at 07:29:57PM +0100, Milan Broz wrote:
>> On 26/10/2020 18:52, Eric Biggers wrote:
>>> On Mon, Oct 26, 2020 at 03:04:46PM +0200, Gilad Ben-Yossef wrote:
>>>> Replace the explicit EBOIV handling in the dm-crypt driver with calls
>>>> into the crypto API, which now possesses the capability to perform
>>>> this processing within the crypto subsystem.
>>>>
>>>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>>>>
>>>> ---
>>>>  drivers/md/Kconfig    |  1 +
>>>>  drivers/md/dm-crypt.c | 61 ++++++++++++++-----------------------------
>>>>  2 files changed, 20 insertions(+), 42 deletions(-)
>>>>
>>>> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
>>>> index 30ba3573626c..ca6e56a72281 100644
>>>> --- a/drivers/md/Kconfig
>>>> +++ b/drivers/md/Kconfig
>>>> @@ -273,6 +273,7 @@ config DM_CRYPT
>>>>  	select CRYPTO
>>>>  	select CRYPTO_CBC
>>>>  	select CRYPTO_ESSIV
>>>> +	select CRYPTO_EBOIV
>>>>  	help
>>>>  	  This device-mapper target allows you to create a device that
>>>>  	  transparently encrypts the data on it. You'll need to activate
>>>
>>> Can CRYPTO_EBOIV please not be selected by default?  If someone really wants
>>> Bitlocker compatibility support, they can select this option themselves.
>>
>> Please no! Until this move of IV to crypto API, we can rely on
>> support in dm-crypt (if it is not supported, it is just a very old kernel).
>> (Actually, this was the first thing I checked in this patchset - if it is
>> unconditionally enabled for compatibility once dmcrypt is selected.)
>>
>> People already use removable devices with BitLocker.
>> It was the whole point that it works out-of-the-box without enabling anything.
>>
>> If you insist on this to be optional, please better keep this IV inside dmcrypt.
>> (EBOIV has no other use than for disk encryption anyway.)
>>
>> Or maybe another option would be to introduce option under dm-crypt Kconfig that
>> defaults to enabled (like support for foreign/legacy disk encryption schemes) and that
>> selects these IVs/modes.
>> But requiring some random switch in crypto API will only confuse users.
> 
> CONFIG_DM_CRYPT can either select every weird combination of algorithms anyone
> can ever be using, or it can select some defaults and require any other needed
> algorithms to be explicitly selected.
> 
> In reality, dm-crypt has never even selected any particular block ciphers, even
> AES.  Nor has it ever selected XTS.  So it's actually always made users (or
> kernel distributors) explicitly select algorithms.  Why the Bitlocker support
> suddenly different?
> 
> I'd think a lot of dm-crypt users don't want to bloat their kernels with random
> legacy algorithms.

Yes, but IV is in reality not a cryptographic algorithm, it is kind-of a configuration
"option" of sector encryption mode here.

We had all of disk-IV inside dmcrypt before - but once it is partially moved into crypto API
(ESSIV, EBOIV for now), it becomes much more complicated for user to select what he needs.

I think we have no way to check that IV is available from userspace - it
will report the same error as if block cipher is not available, not helping user much
with the error.

But then I also think we should add abstract dm-crypt options here (Legacy TrueCrypt modes,
Bitlocker modes) that will select these crypto API configuration switches.
Otherwise it will be only a complicated matrix of crypto API options...

Milan
