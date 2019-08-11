Return-Path: <SRS0=+H67=WH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B0A8C433FF
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Aug 2019 11:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D69B2173C
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Aug 2019 11:13:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HDRvEENe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbfHKLNB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 11 Aug 2019 07:13:01 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:32821 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfHKLNB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Aug 2019 07:13:01 -0400
Received: by mail-wm1-f41.google.com with SMTP id p77so9073092wme.0
        for <linux-crypto@vger.kernel.org>; Sun, 11 Aug 2019 04:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mPou2l6/6d60x+ugqGKrLJjTouLAr6zsgM8Vh/aSpGE=;
        b=HDRvEENewEc/2utj964O4FhxALvIRbSd3HAt4ypNU1kJb95B10i61kWpID7R8o25SJ
         pKzBz7A1uVR+linBP7DId3tDeDSuX1CkpqhlJPikMGxMbiG4CaE/iFDkDJZ021e9CfOW
         CnjVzgOE+lUVAztuA4vKxcYAK7jnzWePOWFsb4UTbkMtq6nFxjBGyFpZtFHPyGZN6Gyo
         pBWcSmZVN0m/eOaaYlBqfPq+ROFznOFMjNNeMzf1tX2etiNWjcRyQpMzCqw9M5aVpfOM
         gcrs70cJVy9NfKweFeD5sthiXfhd/ZBPtxcwT1OucPC5Isgx6TxjG5QsEpsytwQPng61
         hFqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mPou2l6/6d60x+ugqGKrLJjTouLAr6zsgM8Vh/aSpGE=;
        b=IfurRUt4dJ3rAqmdlo5J4hj1VWIDoF2HCN9Sptt6IG3oB2badMJYkokbuOHSYd495H
         i3uhGna9T1Sjxeq3ivqIcUqUBnJLlnqN+3yIaAgAp6bJQnkJimczVr9jPAX7AHYqABRJ
         VAeLJxHtgS6L54hs5PBeUmzwqFuAgZx1R4ri3R5edFh8PePQDG7PRgXNQL+zydpi5ZjC
         z4QsAbhAyq2Bdm8th8fBokiCkM2oweSuVvdaMBtk2pWtJPndLAgGjsQpWhv2uRYasuSX
         k878jX/SVf7NQYLHqp2bb5DpmrcgwwJOusjVx/+7c+Xe0ckGz9Il7HGX+BEv49S7UKdk
         dOhg==
X-Gm-Message-State: APjAAAWoIchco8dhQBsY0WyAQkvI7K9FT6VEZsmclQNvEJTDdyA3jZP3
        4NxontGnz/Y/ycUv/oSjnz0tLDD6
X-Google-Smtp-Source: APXvYqyjgzSBdTo0ZTb1B9kBsmp7wBzSVlr+AM34CWJmX2U1bwC66ltBhvfDh8+1WzjkWcCuEEnrsg==
X-Received: by 2002:a7b:ce1a:: with SMTP id m26mr15860345wmc.60.1565521978713;
        Sun, 11 Aug 2019 04:12:58 -0700 (PDT)
Received: from [192.168.8.101] (37-48-59-8.nat.epc.tmcz.cz. [37.48.59.8])
        by smtp.gmail.com with ESMTPSA id x20sm9980012wmc.1.2019.08.11.04.12.57
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Aug 2019 04:12:58 -0700 (PDT)
Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <CAKv+Gu9C2AEbb++W=QTVWbeA_88Fo57NcOwgU5R8HBvzFwXkJw@mail.gmail.com>
 <CAKv+Gu-j-8-bQS2A46-Kf1KHtkoPJ5Htk8WratqzyngnVu-wpw@mail.gmail.com>
 <MN2PR20MB29739591E1A3E54E7A8A8E18CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20f4832e-e3af-e3c2-d946-13bf8c367a60@nxp.com>
 <VI1PR0402MB34856F03FCE57AB62FC2257998D40@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <MN2PR20MB2973127E4C159A8F5CFDD0C9CAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
 <VI1PR0402MB3485689B4B65C879BC1D137398D70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190809024821.GA7186@gondor.apana.org.au>
 <CAKv+Gu9hk=PGpsAWWOU61VrA3mVQd10LudA1qg0LbiX7DG9RjA@mail.gmail.com>
 <VI1PR0402MB3485F94AECC495F133F6B3D798D60@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAKv+Gu-_WObNm+ySXDWjhqe2YPzajX83MofuF-WKPSdLg5t4Ew@mail.gmail.com>
 <MN2PR20MB297361CA3C29C236D6D8F6F4CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-xWxZ58tzyYoH_jDKfJoM+KzOWWpzCeHEmOXQ39Bv15g@mail.gmail.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <d6d0b155-476b-d495-3418-4b171003cdd7@gmail.com>
Date:   Sun, 11 Aug 2019 13:12:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu-xWxZ58tzyYoH_jDKfJoM+KzOWWpzCeHEmOXQ39Bv15g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/08/2019 06:39, Ard Biesheuvel wrote:
> Truncated IVs are a huge issue, since we already expose the correct
> API via AF_ALG (without any restrictions on how many of the IV bits
> are populated), and apparently, if your AF_ALG request for xts(aes)
> happens to be fulfilled by the CAAM driver and your implementation
> uses more than 64 bits for the IV, the top bits get truncated silently
> and your data might get eaten.

Actually, I think we have already serious problem with in in kernel (no AF_ALG needed).

I do not have the hardware, but please could you check that dm-crypt big-endian IV
(plain64be) produces the same output on CAAM?

It is 64bit IV, but big-endian and we use size of cipher block (16bytes) here,
so the first 8 bytes are zero in this case.

I would expect data corruption in comparison to generic implementation,
if it supports only the first 64bit...

Try this:

# create small null device of 8 sectors,  we use zeroes as fixed ciphertext
dmsetup create zero --table "0 8 zero"

# create crypt device on top of it (with some key), using plain64be IV
dmsetup create crypt --table "0 8 crypt aes-xts-plain64be e8cfa3dbfe373b536be43c5637387786c01be00ba5f730aacb039e86f3eb72f3 0 /dev/mapper/zero 0"

# and compare it with and without your driver, this is what I get here:
# sha256sum /dev/mapper/crypt 
532f71198d0d84d823b8e410738c6f43bc3e149d844dd6d37fa5b36d150501e1  /dev/mapper/crypt
# dmsetup remove crypt

You can try little-endian version (plain64), this should always work even with CAAM
dmsetup create crypt --table "0 8 crypt aes-xts-plain64 e8cfa3dbfe373b536be43c5637387786c01be00ba5f730aacb039e86f3eb72f3 0 /dev/mapper/zero 0"

# sha256sum /dev/mapper/crypt 
f17abd27dedee4e539758eabdb6c15fa619464b509cf55f16433e6a25da42857  /dev/mapper/crypt
# dmsetup remove crypt

# dmsetup remove zero


If you get different plaintext in the first case, your driver is actually creating
data corruption in this configuration and it should be fixed!
(Only the first sector must be the same, because it has IV == 0.)

Milan

p.s.
If you ask why we have this IV, it was added per request to allow map some chipset-based
encrypted drives directly. I guess it is used for some data forensic things.
