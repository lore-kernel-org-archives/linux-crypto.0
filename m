Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3017CC4332F
	for <linux-crypto@archiver.kernel.org>; Wed, 11 May 2022 12:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242907AbiEKM7Q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 May 2022 08:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242909AbiEKM7O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 May 2022 08:59:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C50C195DE9
        for <linux-crypto@vger.kernel.org>; Wed, 11 May 2022 05:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652273952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P3pmuNFV/ptflpHqQQDwwf4tEA/mscwqGqx/YTI6DC4=;
        b=S6BT2UOos8aiCNb9QyWzgryLSMuFe+bATzKNCvYQuSMsbHiqGNQWawV0nDRSy1lzoWL5Ns
        ws72iv+w+lfquOITGSAYPCgbfr8/UpMf9RRpUwQP6PiATxiRQzMlKOHABdLmtfvismERuE
        L6hOSGArAdmWBO6pgumV3bHsITSPCMI=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-3Ohi9LKrMfK808LuASAVAA-1; Wed, 11 May 2022 08:59:09 -0400
X-MC-Unique: 3Ohi9LKrMfK808LuASAVAA-1
Received: by mail-qt1-f199.google.com with SMTP id a24-20020ac81098000000b002e1e06a72aeso1523134qtj.6
        for <linux-crypto@vger.kernel.org>; Wed, 11 May 2022 05:59:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=P3pmuNFV/ptflpHqQQDwwf4tEA/mscwqGqx/YTI6DC4=;
        b=iI0EJmNP5MlBY8H9Hi+bE9mQx9gGn/9Bgood8gIkyCJAUptOFukidpJBlh61ViMfHg
         H8GYfJPNUpoq0IlMcAGohgiMyJpjvVezd+BDlvNX2Hmzdi5MKUM/WAZapWRSuBE1+7Ah
         5jPE265rT9tthtXb7a/bw9RprHIjzIZbD0RN0N6pxDfSJVEpVktggWP3WLX5gtUCxn1G
         Hll+tmedw0vtBA7zLs/J+Bum4QplzNGU1Gz7ObLWpE14nIT2qM8UWiTx/3I+/ukCGrc7
         fIBLxfMghoHXPmcQrbvG8cqjfUzv1ER2P+9iW2s7qjDoGFCXsHDVwtOesCpzWOeq8CGy
         rEDQ==
X-Gm-Message-State: AOAM533rdRGf4ze5UMuo/uGyHiJgpyl+TNcKtRcuUxD0M86h0xXa+wOV
        xdfNMlorC+DzXNvdhoBHnNbhl7WduC5ZvIEwXID+BOZuZ9ysAIO8H6T5wqmt1ua4OvAI4cJ817C
        ekFcLAGwd24rQNPej2AM4kVLu
X-Received: by 2002:a05:620a:2412:b0:6a0:5f8e:c050 with SMTP id d18-20020a05620a241200b006a05f8ec050mr13739695qkn.462.1652273949358;
        Wed, 11 May 2022 05:59:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwI9z5WG7k9Nn2llTyyAOt4aUQjwE2gb23qqkGrh6jwCoQSAYhq0zfpk66qWA9cYV8vY6Vjmw==
X-Received: by 2002:a05:620a:2412:b0:6a0:5f8e:c050 with SMTP id d18-20020a05620a241200b006a05f8ec050mr13739677qkn.462.1652273949082;
        Wed, 11 May 2022 05:59:09 -0700 (PDT)
Received: from m8.users.ipa.redhat.com (cpe-158-222-141-151.nyc.res.rr.com. [158.222.141.151])
        by smtp.gmail.com with ESMTPSA id bk29-20020a05620a1a1d00b0069fca79fa3asm1244537qkb.62.2022.05.11.05.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 05:59:08 -0700 (PDT)
Message-ID: <f6a4a5ccb126053534bebe4b070fc1384839e919.camel@redhat.com>
Subject: Re: [PATCH 2/2] random: add fork_event sysctl for polling VM forks
From:   Simo Sorce <simo@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Alexander Graf <graf@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Torben Hansen <htorben@amazon.co.uk>,
        Jann Horn <jannh@google.com>
Date:   Wed, 11 May 2022 08:59:07 -0400
In-Reply-To: <YnsO1JGQm5FEkbJt@zx2c4.com>
References: <20220502140602.130373-1-Jason@zx2c4.com>
         <20220502140602.130373-2-Jason@zx2c4.com>
         <8f305036248cae1d158c4e567191a957a1965ad1.camel@redhat.com>
         <YnsO1JGQm5FEkbJt@zx2c4.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jason,

On Wed, 2022-05-11 at 03:18 +0200, Jason A. Donenfeld wrote:
> My proposal here is made with nonce reuse in mind, for things like
> session keys that use sequential nonces.

Although this makes sense the problem is that changing applications to
do the right thing based on which situation they are in will never be
done right or soon enough. So I would focus on a solution that makes
the CSPRNGs in crypto libraries safe.

> A different issue is random nonces. For these, it seems like a call to
> getrandom() for each nonce is probably the best bet. But it sounds like
> you're interested in a userspace RNG, akin to OpenBSD's arc4random(3). I
> hope you saw these threads:
> 
> - https://lore.kernel.org/lkml/YnA5CUJKvqmXJxf2@zx2c4.com/
> - https://lore.kernel.org/lkml/Yh4+9+UpanJWAIyZ@zx2c4.com/
> - https://lore.kernel.org/lkml/CAHmME9qHGSF8w3DoyCP+ud_N0MAJ5_8zsUWx=rxQB1mFnGcu9w@mail.gmail.com/

4c does sound like a decent solution, it is semantically identical to
an epoch vmgenid, all the library needs to do is to create such a mmap
region, stick a value on  it, verify it is not zero after computing the
next random value but before returning it to the caller.
This reduces the race to a very small window when the machine is frozen
right after the random value is returned to the caller but before it is
used, but hopefully this just means that the two machines will just
make parallel computations that yield the exact same value, so no
catastrophic consequence will arise (there is the odd case where two
random values are sought and the split happens between the two are
retrieved and this has bad consequences, I think we can ignore that).

> Each one of those touches on vDSO things quite a bit. Basically, the
> motivation for doing that is for making userspace RNGs safe and
> promoting their use with a variety of kernel enhancements to make that
> easy. And IF we are to ship a vDSO RNG, then certainly this vmgenid
> business should be exposed that way, over and above other mechanisms.
> It'd make the most sense...IF we're going to ship a vDSO RNG.
> 
> So the question really is: should we ship a vDSO RNG? I could work on
> designing that right. But I'm a little bit skeptical generally of the
> whole userspace RNG concept. By and large they always turn out to be
> less safe and more complex than the kernel one. So if we're to go that
> way, I'd like to understand what the strongest arguments for it are.

I am not entirely sure how a vDSO RNG would work, I think exposing the
epoch(or whatever indicator) is enough, crypto libraries have pretty
good PRNGs, what they require is simply a good source of entropy for
the initial seeding and this safety mechanism to avoid state
duplication on machine cloning.
All the decent libraries already support detecting process forks.

Simo.

-- 
Simo Sorce
RHEL Crypto Team
Red Hat, Inc



