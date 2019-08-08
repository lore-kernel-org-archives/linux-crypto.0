Return-Path: <SRS0=IdBJ=WE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D1AC433FF
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 13:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27F9F2184E
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 13:11:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lw9P/Ahs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732912AbfHHNLP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 09:11:15 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:39146 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732645AbfHHNLO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 09:11:14 -0400
Received: by mail-wm1-f53.google.com with SMTP id u25so2368419wmc.4
        for <linux-crypto@vger.kernel.org>; Thu, 08 Aug 2019 06:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H9YOmFmn+dobIgV9UHgPg756iVEpHTNA5mVXaVj8BrA=;
        b=Lw9P/Ahs3xvyfSma97fMbcUcEqmVMndFpmFuzJ5zYLss3gBnE4wWeDP+hgFR26tYcx
         Gt5QIbaQf+4/mzdLVgxmyGPwOcMwVCuns8eoQeaNxeRQOyUfWLrvGZclIIdcN5hn0qPV
         uEzc9nCHKxCX1+t8VmAHnLsM5xSznrpTNMJo8l8Ub7983vA4OdXNFfOJ2CSLyQsBYMfH
         rouRr34PYompL8naiXqtfdn8/ONdVSyT8FrGR9nucc8YzRlxk5C/j5Rp//Rx8C2vR5pT
         lII46+EV66hL3nVTT+gq8t4OuyUd5Ilts6snyT6XBD1MlCsnyNt2WZDCrzmMqK0RsRjx
         zZ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H9YOmFmn+dobIgV9UHgPg756iVEpHTNA5mVXaVj8BrA=;
        b=d6IS+q43k6puOVH87+0iENfEtEdbcZbPxwKIUlbO/flxCYEAK5RshuuOj0qVbOHZlA
         2e4a04Z5FXttp8xtXUXNSyez2db+dvwYsZBJvoQ60YBfluN/vBKlXFeDPvcDyNVkhZDC
         IA2I36RXlZG7QBsDR0r4PSYyVZiz/wzCLAhpLJyVp2CsJKsRccchC2mavhSh9GOrk6UO
         T7JAxNStVLWqKpsCSk5Ln+Ym1mJgDmYYISvQY2Ua2WSSpiazVZl+HTjzlh+iVTHJi3Fo
         dE4idqnEyLQXAqT4iHSaimb+plrM8mreooZJQAFYgk90luQQqQtuCu+akcTyFcXC1E+u
         V3ig==
X-Gm-Message-State: APjAAAWgrH2oM+VH4np0Ou/ArOOPNN7Z1VRJSpzi8LJk3v/Qt5TpHjNW
        i7rR3AuAraZ/7Gf9FEgU9Uxmt7n+Mcg=
X-Google-Smtp-Source: APXvYqwHfFNzx8+f/kqP6Vo4vUxL+tvMJAW+KHyol8pT5rz4M6TRJDw92OaG69IFJKHG7Nobir8mTw==
X-Received: by 2002:a05:600c:2218:: with SMTP id z24mr4402430wml.84.1565269872766;
        Thu, 08 Aug 2019 06:11:12 -0700 (PDT)
Received: from [10.43.17.10] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 4sm220376865wro.78.2019.08.08.06.11.11
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 06:11:12 -0700 (PDT)
Subject: Re: [PATCHv2] crypto: xts - Add support for Cipher Text Stealing
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
References: <1565245094-8584-1-git-send-email-pvanleeuwen@verimatrix.com>
 <CAKv+Gu_r+iF=gWk_sMesKSyxSZB5Z5pC6jNQmi8uf+0cY7K-6g@mail.gmail.com>
 <CH2PR20MB296824F38C44E32D8C82D0B8CAD70@CH2PR20MB2968.namprd20.prod.outlook.com>
 <CAKv+Gu_uzt-cQF9ZPuM=4zot7UTogifWk3Pjr7Rcz1QWnqKaog@mail.gmail.com>
 <MN2PR20MB297393DA81B7FFE9C1B904DBCAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-vT2tf-UEyxMSE2kRsWEYy+ab6T+37pF23jy_0+M-z2Q@mail.gmail.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <1353558c-ea2f-b94b-a570-4ca8f3a653ee@gmail.com>
Date:   Thu, 8 Aug 2019 15:11:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu-vT2tf-UEyxMSE2kRsWEYy+ab6T+37pF23jy_0+M-z2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 08/08/2019 12:37, Ard Biesheuvel wrote:
>>> True. Which is another historical mistake imo, since XTS is only
>>> specified for AES, but I digress ... :-)
>>>
>> Yes, I was also surprised by the use of XTS with other blockciphers.
>> It sort of violates the don't roll your own crypto paradigm ...
>> (although some might argue that XTS is supposed to be secure if the
>> underlying blockcipher is, regardless of what that cipher actually is)
>>
> 
> That doesn't really matter. What matters is that nobody took a careful
> look whether XTS combined with other ciphers is a good idea before
> throwing it out into the world.

Couldn't resist, but tell that to TrueCrypt authors (if you know them :)

They used XTS for other AES candidates (Serpent, Twofish, also in
chained modes together).

Older versions used LRW mode, doing the same.
Even implementing LRW over Blowfish that has 8-byte block size, so you
need GF(2^64) operations - that is luckily not implemented in Linux kernel
crypto API :-)

VeraCrypt continued the tradition, adding the Camellia and
Kuznyetchik (actually discussed GOST standard) to the XTS mix.

But without sarcasm, I do want to support this for users,
we can map (but not create) such images in cryptsetup, and it is partially
reason I want dm-crypt to be fully configurable...

Milan
