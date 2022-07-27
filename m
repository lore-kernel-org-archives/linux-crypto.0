Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B4CC04A68
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Jul 2022 12:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbiG0MuL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Jul 2022 08:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbiG0MuK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Jul 2022 08:50:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9978ADF3
        for <linux-crypto@vger.kernel.org>; Wed, 27 Jul 2022 05:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658926208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u3tWNZoM0SHgJT357NmowYOc/14fIdjywuVCaJBZfBY=;
        b=SGcFBqiw37SJEce3iXhMfe5g3motm1cZbiOL7OzA6OEY+Wk+rMKkwV7Vz83DE7KtF1c4+L
        ZuI1UYXka1LGYjtSjplAmWP0xx668sg1rGLELkse8ewfTefuXsUpStLpODa12aOmDVpeym
        GTTT+SE4PYmXWOibWOgGxa+J3wdwPl8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-oATUdNq-NaeacgLetjm8rA-1; Wed, 27 Jul 2022 08:50:01 -0400
X-MC-Unique: oATUdNq-NaeacgLetjm8rA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0889B85A589;
        Wed, 27 Jul 2022 12:50:01 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.39.192.67])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 11AE6492CA2;
        Wed, 27 Jul 2022 12:49:58 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Rich Felker <dalias@libc.org>,
        Yann Droneaud <ydroneaud@opteya.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, libc-alpha@sourceware.org,
        linux-crypto@vger.kernel.org, Michael@phoronix.com, jann@thejh.net
Subject: Re: arc4random - are you sure we want these?
In-Reply-To: <YuEwR0bJhOvRtmFe@mit.edu> (Theodore Ts'o's message of "Wed, 27
        Jul 2022 08:32:07 -0400")
References: <YtwgTySJyky0OcgG@zx2c4.com> <Ytwg8YEJn+76h5g9@zx2c4.com>
        <6bf352e9-1312-40de-4733-3219721b343c@linaro.org>
        <20220725153303.GF7074@brightrain.aerifal.cx>
        <878rohp2ll.fsf@oldenburg.str.redhat.com>
        <20220725174430.GI7074@brightrain.aerifal.cx>
        <CAPBLoAe89Pwt=F_jcZirVXQA7JtugV+5+BWHBt0RaZka1y0K=g@mail.gmail.com>
        <20220725184929.GJ7074@brightrain.aerifal.cx>
        <YuCa1lDqoxdnZut/@mit.edu>
        <a5b6307d-6811-61b6-c13d-febaa6ad1e48@linaro.org>
        <YuEwR0bJhOvRtmFe@mit.edu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Date:   Wed, 27 Jul 2022 14:49:57 +0200
Message-ID: <87v8rid8ju.fsf@oldenburg.str.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

* Theodore Ts'o:

> But even if you didn't take the latest kernels, I think you will find
> that if you actually benchmark how many queries per second a real-life
> secure web server or VPN gateway, even the original 5.15.0 /dev/random
> driver was plenty fast enough for real world cryptographic use cases.

The idea is to that arc4random() is suitable in pretty much all places
that have historically used random() (outside of deterministic
simulations).  Straight calls to getrandom are much, much slower than
random(), and it's not even the system call overhead.

Thanks,
Florian

