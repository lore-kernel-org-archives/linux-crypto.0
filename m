Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7087AC43334
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Jul 2022 02:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbiGACyI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jun 2022 22:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbiGACyH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jun 2022 22:54:07 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E2D5C941
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jun 2022 19:54:06 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id m2so1108702plx.3
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jun 2022 19:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=GLMQpIWkkm7sR/k0chK/u6zd+kQLtQ2ql+w+EaC3crs=;
        b=sH6eE+4YBsMDGwzfKMUcw2sdWOGSUtfi3WgeLD8CINpM+QAZsZNKUpY7bnmzbphq9Z
         0ob1HO5vlOPb+Kx0SqBHVIgK4Fr5kUtb3k71xI9TEG4o9Y7MCqceYbqlVh7FUcR5GB4f
         T5PVrG6WkRD2VWDkqGQ3q7EscEBsfOTlwXhbMw3LjO78wwNiGwM8/y6mbLqAaJr7upvA
         xvURof8t0I0WqYMCRTDfWpHB8gT6g3uWV+6XPanoIiQBynqhPMaL6/X2FrQMteh3YPeF
         /rti1PdrKrTcUeQlAs40YDqGqZa6zeXjCjzv6DDMGuVf4xHI8tjtD3Mr+G8aWHEcjw1g
         v3gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GLMQpIWkkm7sR/k0chK/u6zd+kQLtQ2ql+w+EaC3crs=;
        b=L8wfJnz4J+v6sxqxf6vF2eCuyG1G+2Of0zBXBDumHjWY99GigICJVd1s/dXMXi024J
         VUhbD6fBfxP5WP5uKu5kz3vtoS2bv+7pGZBZfRYjWaaesESMvXsI7jMuF7oBVy8+H0AC
         3o/KN+YtKx2ah9A0HqqUWnq+Bch81Pxy6KZ4EuX6BkcV5U/nqsU81KzY6kwKijrazepD
         KMjOeo7uJYyug+OIzMngoGCeGV+G6hBTJoY9aKbOUkehIlw/1gk3s/JDL8+m9oluZvxN
         wpXn1n8Lh6Bx8MTXtw3GFKxrxmS/dAlmJgX0ycZycFDmXF6nL3JJTLbLZ1U9JadAU9Y/
         W9gQ==
X-Gm-Message-State: AJIora9D6WLTdlWNHnMuZkBUQ1ZM3AkFDaCx1lVT6FT0FuGFPTdpVxa2
        wA+oZyH5QxtKbh3DzC5MvnFHBA==
X-Google-Smtp-Source: AGRyM1s0OUFNbQK6YNX9w9TiO9NMraFJYAXIzZhtQSsThAo3DWvP+Jq5H/L6ob17WI93c0LpUwbkcw==
X-Received: by 2002:a17:902:d2d0:b0:16b:b955:9b46 with SMTP id n16-20020a170902d2d000b0016bb9559b46mr2902952plc.125.1656644046400;
        Thu, 30 Jun 2022 19:54:06 -0700 (PDT)
Received: from [10.4.63.220] ([139.177.225.239])
        by smtp.gmail.com with ESMTPSA id i4-20020a17090332c400b0016a214e4afasm14317749plr.125.2022.06.30.19.54.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 19:54:05 -0700 (PDT)
Message-ID: <347d724a-c411-229f-7b13-a0cde1b2f518@bytedance.com>
Date:   Fri, 1 Jul 2022 10:54:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [External] Re: [PATCH v2 0/4] virtio-crypto: support ECDSA
 algorithm
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, berrange@redhat.com,
        pizhenwei@bytedance.com
References: <20220623070550.82053-1-helei.sig11@bytedance.com>
 <Yr1JvG1aJUp4I/fP@gondor.apana.org.au>
 <C7191BC8-5BE0-47CB-A302-735BBD1CBED0@bytedance.com>
 <Yr1TuPM8yvJUoV9r@gondor.apana.org.au>
 <CC761178-556D-44F6-9479-5151C69476C8@bytedance.com>
 <CACXcFmmxDVBrnp3_0UzN+VbAjDaUSNtoUBz5fM1Y4u5yqL89qA@mail.gmail.com>
From:   Lei He <helei.sig11@bytedance.com>
In-Reply-To: <CACXcFmmxDVBrnp3_0UzN+VbAjDaUSNtoUBz5fM1Y4u5yqL89qA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/1/2022 7:12 AM, Sandy Harris wrote:
> On Thu, Jun 30, 2022 at 4:37 PM Lei He <helei.sig11@bytedance.com> wrote:
> 
>> I have explained above why we need a driver that supports ECDSA, ...
> 
> I do not think we do. There are some security concerns.
> https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm#Security

But since tls1.0, the ECDSA algorithm has been retained to the current 
1.3 version.
https://en.wikipedia.org/wiki/Transport_Layer_Security#Algorithms

Best regards,
Lei He
--
helei.sig11@bytedance.com

