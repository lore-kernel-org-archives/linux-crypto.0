Return-Path: <SRS0=WqbL=AT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C3FC433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 11:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09F63206E9
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 11:01:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EE3TJ5We"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgGHLBl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jul 2020 07:01:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51013 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728385AbgGHLBk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jul 2020 07:01:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594206099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7mpwcBcVOqWo2vWhK3ZHzCBKqd/c7GeCFs8iwgkkI1Y=;
        b=EE3TJ5WeC+RalkIyh1XUUWGBFOaeP5t/zclKYlyDQtC4lx/feGiGOcn0BmdeSgJh9iceWe
        vrTM07rlwI/hSx9A56hCXQjtOr6rtULXDL9KvO7YPUuOYGNNpZT3ec92oOK3meDBK7svLV
        ZEFKQYVZGW5fo2HXuGU3cOWg5k6dCek=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-nwd-k0FvP8CooNetnBce4Q-1; Wed, 08 Jul 2020 07:01:37 -0400
X-MC-Unique: nwd-k0FvP8CooNetnBce4Q-1
Received: by mail-ed1-f71.google.com with SMTP id v8so51861221edj.4
        for <linux-crypto@vger.kernel.org>; Wed, 08 Jul 2020 04:01:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7mpwcBcVOqWo2vWhK3ZHzCBKqd/c7GeCFs8iwgkkI1Y=;
        b=TibICvBMzOgzl3T+vGPRd8wfB7Xvou+Kv92YrlRK8oSqYFe7CgJ9ZI5y5Uc/G0w6aS
         TwKcF63zeea/SgXtIJjRpp1ByEIS0lacLpCOXZpVyGZsLDhMkHt2OgvlKJ4e6lazxUpk
         fuzhMvh3bwN41Nl9/5SBiSCHT6lDFut32onveIk2CDfCbuGuS2yXalAJaCREd/sblZn5
         NmvYStwdstUXQ3zIXhNMDPts7AaWYyqXe8QIw40UjWsJVlzO6TA7gVyZffKnh9wHQxdv
         YmKUgvZCU8yvIpTIzJuOOlSLnHYzhw/Wbq3RH1P5mMW7xb0DU2WQm8Z3KRs9cCh+CEEa
         BoTQ==
X-Gm-Message-State: AOAM531v8vyLgT+FjRtp4tcKhqrboum4OvF4joCnvUA4psXP0Wyn+sUP
        nYJs4GoYlFBoLO2fCPNEjsw/4DLEAY5q9JM1BG2sQfRbjDf1ZnWzQPjPwV2qUbxETvGStUUvtrG
        z1ufA8IK/rJM6wwRjyTW9WGDy
X-Received: by 2002:a05:6402:543:: with SMTP id i3mr45729410edx.182.1594206096366;
        Wed, 08 Jul 2020 04:01:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQYOwlXd9z9b5GX8vCI0fodR5ilbW7iNNKfVwmUo6weDMlbUb4GtDXfKFHOnZT9ZrFR1YyRw==
X-Received: by 2002:a05:6402:543:: with SMTP id i3mr45729373edx.182.1594206096112;
        Wed, 08 Jul 2020 04:01:36 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id dt22sm1881261ejc.104.2020.07.08.04.01.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 04:01:35 -0700 (PDT)
Subject: Re: [PATCH 0/4] crypto: add sha256() function
To:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     alsa-devel@alsa-project.org, Ard Biesheuvel <ardb@kernel.org>,
        Cheng-Yi Chiang <cychiang@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Guenter Roeck <groeck@chromium.org>, linux-efi@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        mptcp@lists.01.org, Tzung-Bi Shih <tzungbi@google.com>
References: <20200707185818.80177-1-ebiggers@kernel.org>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <7b5617f4-905f-5f27-9caf-3c842cbdb0d8@redhat.com>
Date:   Wed, 8 Jul 2020 13:01:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200707185818.80177-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 7/7/20 8:58 PM, Eric Biggers wrote:
> This series adds a function sha256() to the sha256 library so that users
> who want to compute a hash in one step can just call sha256() instead of
> sha256_init() + sha256_update() + sha256_final().
> 
> Patches 2-4 then convert some users to use it.
> 
> Eric Biggers (4):
>    crypto: lib/sha256 - add sha256() function
>    efi: use sha256() instead of open coding
>    mptcp: use sha256() instead of open coding
>    ASoC: cros_ec_codec: use sha256() instead of open coding
> 
>   drivers/firmware/efi/embedded-firmware.c |  9 +++-----
>   include/crypto/sha.h                     |  1 +
>   lib/crypto/sha256.c                      | 10 +++++++++
>   net/mptcp/crypto.c                       | 15 +++----------
>   sound/soc/codecs/cros_ec_codec.c         | 27 ++----------------------
>   5 files changed, 19 insertions(+), 43 deletions(-)
> 
> 
> base-commit: 57c8aa43b9f272c382c253573c82be5cb68fe22d

I've done some quick tests on this series to make sure that
the efi embedded-firmware support did not regress.
That still works fine, so this series is;

Tested-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans

