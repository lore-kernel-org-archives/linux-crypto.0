Return-Path: <SRS0=chSI=24=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BCDAC33C8C
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jan 2020 15:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B8222081E
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jan 2020 15:47:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="aJSd5AeS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgAGPrD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jan 2020 10:47:03 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:51573 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728052AbgAGPrD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jan 2020 10:47:03 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f13bbd2b;
        Tue, 7 Jan 2020 14:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=STpGJlE3haWjP4hkEME1yCbG+Xs=; b=aJSd5A
        eS3JOws3qnhogmwPbY3qOtt7gnXBiiu76k/AOm9do/0nN/lfg1cO5tQLvUwZj3lT
        jxmOueTp7z2nJ/iy6aNhEJYZ6zEPTQYHWa8eoUxVwWMiZbhw6lkAIEBfw3IydYvw
        5Gx7oOLTNY8o1+bpIFk4+NFr5ymSt1MWbQTYdhUvcKzBQBrnaAVfSX7R6KVEi7bg
        hguD1kEZFNXqSiypDMUdRrEpcMP/ri9VSmD9feKk77T7Cy9AhQv6GWUMNppGJsCU
        oCOkisC9Cn+FCAr0DpvwtQ0kjhAowKwzAfT7L5AtNInZW6832py2OWIiD6tAhoyI
        DnwRBuWiQ6ihocvA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 778a8bc4 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 7 Jan 2020 14:47:52 +0000 (UTC)
Received: by mail-ot1-f49.google.com with SMTP id i15so355044oto.2;
        Tue, 07 Jan 2020 07:47:01 -0800 (PST)
X-Gm-Message-State: APjAAAUdaBzmu+2WUKKyFCnYFYh0oTjVuDn1jQYBeWPnHSnVhR8EbSWS
        vAJl5gmQq7j6WF7xD4GwBtJkmJKYBlfkz1ejp0s=
X-Google-Smtp-Source: APXvYqxrn57lfDdimB37X/3Mf4MpTtckpLCKQ6UbFZATFglmq3D4mD4FXLGRNZoUal7WtkQDN40+mitQHF+xEN8TLPk=
X-Received: by 2002:a9d:1e88:: with SMTP id n8mr335962otn.369.1578412020553;
 Tue, 07 Jan 2020 07:47:00 -0800 (PST)
MIME-Version: 1.0
References: <20200107133547.44000-1-yuehaibing@huawei.com>
In-Reply-To: <20200107133547.44000-1-yuehaibing@huawei.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 7 Jan 2020 10:46:49 -0500
X-Gmail-Original-Message-ID: <CAHmME9pg4KWw1zNVybxn1WLGusyGCjqeAHLQXY=Dr4zznUM82g@mail.gmail.com>
Message-ID: <CAHmME9pg4KWw1zNVybxn1WLGusyGCjqeAHLQXY=Dr4zznUM82g@mail.gmail.com>
Subject: Re: [PATCH -next] crypto: curve25519 - Fix selftests build error
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thanks for catching this. While the pattern of adding the test here
followed the already-working pattern used by the blake2s
implementation, curve25519's wiring differs in one way: the arch code
is not related to any of the generic machinery. So this seems like an
okay way of fixing this for the time being.

Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
