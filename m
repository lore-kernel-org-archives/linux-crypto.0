Return-Path: <SRS0=y31I=WC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A476DC433FF
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 19:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75EE0205C9
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 19:19:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="oaIkeSJH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfHFTT3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Aug 2019 15:19:29 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35615 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfHFTT3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Aug 2019 15:19:29 -0400
Received: by mail-ot1-f68.google.com with SMTP id j19so18648192otq.2;
        Tue, 06 Aug 2019 12:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c/Q5ObqyzJaSPg2Xe3lSXX0q6SY0vIcGMlw0bit7lHA=;
        b=oaIkeSJHjTBqWkr+GCgY1KG10x+DGg+H2XpFd2QJ4nAZ0E0F2SiFIB5eLkQ77d8CNf
         WL4q0YcZ8zxKHaFgP7A5UI59RWzRsm2/L4yO3QbHhXky0LdB3a/iPGZXbpT9/bmFb3+M
         WLKF1sKhn4gXF9VWNsgwRaiTTsPP84DJWFo3Ze0+hIOjaFpRYh8Vx2rWuXKwzS9bSQX6
         spSLLGjC0YzOHRRoPFEPd4wE+/fBbmbKmdrRSkiFpuRr2EZPYBI1+lnQ3pLuMAbaCZ92
         F24vdzrYjU57MqXWxtJwRMcAO2ZXMJsuKDQAAASWfsT0PA1f946skCN1bba19YxIV0m3
         ZjYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c/Q5ObqyzJaSPg2Xe3lSXX0q6SY0vIcGMlw0bit7lHA=;
        b=Zf5OEYqqTEjlUq0D1O+RP735qFnmiiwwP1hj6S288bVgBVYvYpPBNTw1Fr0vFL9L19
         16dDZlVLkgKnMEmYv34K2wFMpi1uis22hvPMrnxiPkX6PfKhj4horXE8J9rjVKqPUhEy
         zbXVzUSI8UiS0qdWr2BI28HrPZT3uxdb9TCBp9zn6y9+fpM8VJ4MdSDIPMIdiNoJOg8s
         TVvS65LCGmQs+u5BWT2p6SYq+49tCLgiI3v48rd9vJA0oJZybtH0ZTBUXpVwwwDhkuhC
         E6AXCr0yTtyqfBr5EuLGPUNjLAe0yOECwnH5v/avqf1JuMN9G3oS4wOxLNiP1/udXemL
         Pq+A==
X-Gm-Message-State: APjAAAVT3UlkJHHkvMz5dq/OVEwrX1B5aDDibubvClVGPhNlD3ADmEMJ
        jiVwTuK3u0239lMuJ3vfm9SA5SVDARTcFORc3Hs=
X-Google-Smtp-Source: APXvYqx8+wGIEHcLqq6rnmYE4bdlJ/kknBnIKvT6BBs5vbtN1414sxoJkLwKA2XxJextp82XgKVOdTl4dqrfmxJ2Szs=
X-Received: by 2002:a05:6830:1e5a:: with SMTP id e26mr4111309otj.96.1565119168049;
 Tue, 06 Aug 2019 12:19:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190805120320.32282-1-narmstrong@baylibre.com> <20190805120320.32282-3-narmstrong@baylibre.com>
In-Reply-To: <20190805120320.32282-3-narmstrong@baylibre.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 6 Aug 2019 21:19:17 +0200
Message-ID: <CAFBinCBQLH6-f2s-0GJccJ=7G2iVjnHfvZy=d63TdBjra6wqPw@mail.gmail.com>
Subject: Re: [RFCv2 2/9] dt-bindings: rng: amlogic,meson-rng: convert to yaml
To:     Neil Armstrong <narmstrong@baylibre.com>
Cc:     robh+dt@kernel.org, linux-amlogic@lists.infradead.org,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 5, 2019 at 2:04 PM Neil Armstrong <narmstrong@baylibre.com> wrote:
>
> Now that we have the DT validation in place, let's convert the device tree
> bindings for the Amlogic Random Number generator over to a YAML schemas.
>
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
