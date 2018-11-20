Return-Path: <SRS0=vxh5=N7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12D39C43441
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Nov 2018 05:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C364820685
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Nov 2018 05:47:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="p4jGt7IN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C364820685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731786AbeKTQOV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Nov 2018 11:14:21 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34424 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbeKTQOV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 11:14:21 -0500
Received: by mail-wr1-f65.google.com with SMTP id j2so593528wrw.1
        for <linux-crypto@vger.kernel.org>; Mon, 19 Nov 2018 21:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7kzKPNIihbMNTWm722YEOBTDCnKQ7HDU6hQ3FTufTWI=;
        b=p4jGt7INtLEPr/p1p8diwE87M9R3HchNJm5APcR13NzZPqPDVtgyaddP8V3GB0/3fu
         3sF4qXcP9GgsbhG5ZhN71cJPkooPvAP7ybTqAmn0j8U2IqoFYqpDdFkCTGu+gg0woHG5
         K0JlLd9E/trUyXZitzS2X7siMaEPpEqFgbV8bX0R/kN/8Yza9eHbsJsAXf9yMZ7XS+cN
         cjrBBI0LVh157X56ICuGlR8Dvo6foBSC4REku87Pn3cv22T5V5ph5KQVVxacctP5G77K
         vvVmxEvm+xgAmn9UdYswBTztKQwHmjlPpbuSIb3Z59TTN+unI6NOKVOqI8dBk4VX42oZ
         bffg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7kzKPNIihbMNTWm722YEOBTDCnKQ7HDU6hQ3FTufTWI=;
        b=O1O6StGKCn87udLELcQyCBwZr0z+Irmvh9WeUg6v9KeUUf1XbrT9Y4vMczjVisA+N/
         43YCvSTADQt26tPhOBvlnxBKHtbN8yP2TVwr7l4bxB1YVRkLqo/FWjy85aPFvKCmOtSC
         E4NHAz121HpQ0bL5CFXZEUTlsNBlW600X4D3iGancgO9nn9RieATFuZ0pSFZygO2oMaV
         IvCLUrgBsP4VQ1PjM823gXnBfbmw42kqPiO1EGLRFWuC5OHUs2SKJDzA1S6yGb7ihiDP
         L/Mz16fRfozg5Dm76NGh8Ue+3IogjUwmkDxGItk1ZhkJ6MvCU/cVkT/5KwFgPn2OT/rS
         oorA==
X-Gm-Message-State: AA+aEWYV2Zfp7zHzQzylIs6S9QTNFh6ssdf+mqHYKDSlS0fvvVmM5KGE
        duBDnDEfv7bAkdv7+NNlgqUNiQ==
X-Google-Smtp-Source: AFSGD/V6xPD7CXrbWV67MGBanWNbQR910EchuZ3Rl5RHCTJxi4IOjT+ZW1MGO6JkgHnkXEDkCty1wQ==
X-Received: by 2002:adf:f504:: with SMTP id q4mr554168wro.321.1542692822126;
        Mon, 19 Nov 2018 21:47:02 -0800 (PST)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id b18sm11022401wrw.83.2018.11.19.21.47.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Nov 2018 21:47:01 -0800 (PST)
Date:   Tue, 20 Nov 2018 06:46:59 +0100
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>, nhorman@tuxdriver.com,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/11] crypto: move crypto_alg_get/crypto_alg_put to
 linux/crypto.h
Message-ID: <20181120054659.GA12679@Red>
References: <1542657210-37739-1-git-send-email-clabbe@baylibre.com>
 <1542657210-37739-2-git-send-email-clabbe@baylibre.com>
 <CAKv+Gu80ArVHwBOmD3qjKUEP=LsbOEfZrCyO-rPDtpX3AbykoA@mail.gmail.com>
 <20181120031047.diqgmbluclbbkhav@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <20181120031047.diqgmbluclbbkhav@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181120054659.kl2DoW_o4w2gIyXebRX45Fvam9UqykpAksGkprY3b3U@z>

On Tue, Nov 20, 2018 at 11:10:47AM +0800, Herbert Xu wrote:
> On Mon, Nov 19, 2018 at 12:25:10PM -0800, Ard Biesheuvel wrote:
> > On Mon, 19 Nov 2018 at 11:53, Corentin Labbe <clabbe@baylibre.com> wrote:
> > >
> > > Since we will need crypto_alg_get/crypto_alg_put for "locking"
> > > crypto_alg when updating stats, we need it to be via linux/crypto.h
> > >
> > 
> > This seems backwards to me. Surely, crypto stats are permitted to use
> > the internal crypto API?
> 
> I agree.
> 

I dont understand what is backwards ? moving or using ?
What do you suggest for "locking" crypto_alg ?

Regards
