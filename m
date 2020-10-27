Return-Path: <SRS0=pM9r=EC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7538BC55179
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Oct 2020 13:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EF3422384
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Oct 2020 13:05:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L0tzrZHm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751792AbgJ0NFQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Oct 2020 09:05:16 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50995 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751781AbgJ0NFQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Oct 2020 09:05:16 -0400
Received: by mail-wm1-f68.google.com with SMTP id 13so1315158wmf.0;
        Tue, 27 Oct 2020 06:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=myy/l02Rm8F+X0fdWIlyuf1JwB3VU/GU2tmaR4vsSCk=;
        b=L0tzrZHmCG5QHwZNJaYIFcqmN0Bh3prvAa8X7BcRmDT8OjcUU7g/d2Rmu8z2Lff+JW
         VmCufz/BrOr9plfiItsFEzzCySrBaYylFjqjHfODbtIBIndtvnFvyl65j6AHwppGGscm
         NHYFXfURWElG2ZdBVn5WKT99TrtWvrdbfFiDMvoTepQRGiQocDMDNAv7tuvH7Qcs0QfG
         bzsnP3XqnkmX3oGsHF/xG7pco8j/mfwCIBoNrfbWLh5QBA9XAeDB7aI3MydveTV5rxD3
         7AvxG+r5eX2fHtaxKdzTH/4dU7MhOGNb5trmpdX1gEIxojpRqs87LHa2o+CkT/m56nSd
         uuYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=myy/l02Rm8F+X0fdWIlyuf1JwB3VU/GU2tmaR4vsSCk=;
        b=fCIgtL4n5aEbekgqaZ19H1tkJ3poOCDnQgZY4IXbHOQDO2oZeDTrN4+P/3G2uU+OqY
         qJ/BGPZGjUQE9HCuxfHBqZOqaJ9u0m8ECJJAVjnNpdizovYKiL+a1kgZ36/1LsD/Kvxh
         ksTNekgskzh38mBPiLXD2iygiPrwU54FhZqGQo0fEHsv3tDf1qHCJEVpUyS6N0EkeQCH
         TVcA8S/fxgNd+osw/jyX2WToK0DC6ArkQ3fweHDPlMlFU/bX2tq5GmJo5eYoTZxjbMTT
         K7ry3kmgSSzHYu3R/emZKSMZWAIoq/Yb8jsFcbrW5b26Uo7O1KueVIXi0Z6X1KAbXys9
         e3Qg==
X-Gm-Message-State: AOAM532uMky4DOtQ++RDpn341z2ncFcvvNR+MzVrNK4t1YzbNBpC1PZZ
        6rteqKS7vxrTJzY4fqKLDEZnYYnqwdQcTA==
X-Google-Smtp-Source: ABdhPJw2WkckDLSI9JGvq3GUMLI8ZV6nTEuB/GOGNsDV91M7d1D0A1mFL4txXw9pl279LalTttu+tQ==
X-Received: by 2002:a1c:6643:: with SMTP id a64mr2744990wmc.142.1603803911919;
        Tue, 27 Oct 2020 06:05:11 -0700 (PDT)
Received: from [192.168.2.27] (39.35.broadband4.iol.cz. [85.71.35.39])
        by smtp.gmail.com with ESMTPSA id o3sm1971923wru.15.2020.10.27.06.05.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 06:05:11 -0700 (PDT)
Subject: Re: [PATCH 3/4] dm crypt: switch to EBOIV crypto API template
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Song Liu <song@kernel.org>, Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org
References: <20201026130450.6947-1-gilad@benyossef.com>
 <20201026130450.6947-4-gilad@benyossef.com>
 <20201026175231.GG858@sol.localdomain>
 <d07b062c-1405-4d72-b907-1c4dfa97aecb@gmail.com>
 <20201026183936.GJ858@sol.localdomain>
 <fd5e46ce-a4bf-8025-05ea-e20d35485446@gmail.com>
 <CAOtvUMdatUOnffg90aEGanD0y1LtKc7EeKQ=E+N+W-wpo8Zo3A@mail.gmail.com>
From:   Milan Broz <gmazyland@gmail.com>
Message-ID: <7c8c1453-94b2-23ec-1c93-7674fc8a413b@gmail.com>
Date:   Tue, 27 Oct 2020 14:05:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAOtvUMdatUOnffg90aEGanD0y1LtKc7EeKQ=E+N+W-wpo8Zo3A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 27/10/2020 07:59, Gilad Ben-Yossef wrote:
> On Mon, Oct 26, 2020 at 9:04 PM Milan Broz <gmazyland@gmail.com> wrote:
...
>> We had all of disk-IV inside dmcrypt before - but once it is partially moved into crypto API
>> (ESSIV, EBOIV for now), it becomes much more complicated for user to select what he needs.
>>
>> I think we have no way to check that IV is available from userspace - it
>> will report the same error as if block cipher is not available, not helping user much
>> with the error.
>>
>> But then I also think we should add abstract dm-crypt options here (Legacy TrueCrypt modes,
>> Bitlocker modes) that will select these crypto API configuration switches.
>> Otherwise it will be only a complicated matrix of crypto API options...
> 
> hm... just thinking out loud, but maybe the right say to go is to not
> have a build dependency,
> but add some user assistance code in cryptosetup that parses
> /proc/crypto after failures to
> try and suggest the user with a way forward?
> 
> e.g. if eboiv mapping initiation fails, scan /proc/crypto and either
> warn of a lack of AES
> or, assuming some instance of AES is found, warn of lack of EBOIV.
> It's a little messy
> and heuristic code for sure, but it lives in a user space utility.
> 
> Does that sound sane?

Such an idea (try to parse /proc/crypto) is on my TODO list since 2009 :)
I expected userspace kernel crypto API could help here, but it seems it is not the case.

So yes, I think we need to add something like this in userspace. In combination with
the kernel and dmcrypt target version, we could have a pretty good hint matrix for the user,
instead of (literally) cryptic errors.

(There is also a problem that device-mapper targets are losing detailed error state.
We often end just with -EINVAL during table create ... and no descriptive log entry.
And leaking info about encrypted devices activation failures to syslog is not a good idea either.)

Anyway, this will not fix existing userspace that is not prepared for this kind
of EBOIV missing fail, so Herbert's solution seems like the solution for this particular
problem for now. (But I agree we should perhaps remove these build dependences in future completely...)

Milan
