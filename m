Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4DFDC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jun 2022 06:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbiF0GQq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jun 2022 02:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiF0GQp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jun 2022 02:16:45 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CCF5F4E
        for <linux-crypto@vger.kernel.org>; Sun, 26 Jun 2022 23:16:44 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id b2so264258plx.7
        for <linux-crypto@vger.kernel.org>; Sun, 26 Jun 2022 23:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=r/J3Po9NeFpqV5rxVhYICc6jfeaTIZBxOHc9ImOjXzU=;
        b=YeeXTY/RvaVAcHkwII82KReoOt8gA6Mmao5gmcStFvupvyF6g3M6LmID31PyZiSmtb
         Ba45TwMV7kTkCYmx+YLMur41feLQYqsn/kMGRpLa6zc1GBF+Rp744hxd+g5Gczk+N4XB
         FzJOE+hsm/HIvvPnMvOwu2xD5ZTlIe4ksfvqb+n6tagMiF9SuT7qzmJKybzED8qrwv2p
         LWCzLr2In6JKbT91kFPAQECTYXch5zuwZMl1pM3bSqHax3C8tpLe+HalNKf8KfkXzHmy
         r1KHoVgcXmGLmBs3HlPyTiiDFDHNoKEhl3V1NeVRa417SyKfW799tqGob5UeYi00bHPZ
         fJSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=r/J3Po9NeFpqV5rxVhYICc6jfeaTIZBxOHc9ImOjXzU=;
        b=7ExsqubvI11CMCtFTUk9qskax1DmPlBidCReL5aQj6xRiUoX1XCYy7sqlIM7iL6ezl
         QGBadpDrxm4qknfPqYzB6MEohFVJKbwPnCDGQ1hXAF793V9fzc/VU1a+gvCKGrm7WFBT
         TgDtANmJj606F6odcVAdJtA5uKqtdRqbKEHrux2A9DJW4LnSPMNTwoANTlC4iZSjQWsN
         pZ2P7reIQa+N9Vp8G+mnDXyU2D0+0Md3q5zMCyH1A1LozEaHvWVQnNePwA0ONEkqlZEQ
         Gsoj/4nG50ACscZSMgZa8UM4ffoeJmXGRlCZDTEVU6Mnfy11XShCWQaB3ssg6YNc5ok2
         ifKA==
X-Gm-Message-State: AJIora9TnqvlUSQiGsqMEHHIl+O4ETn3K6mvxO7f6pNIR7W2fTMex9li
        o9IKDasK23p7ICI3/zlUUPw9pw==
X-Google-Smtp-Source: AGRyM1sC3cz7TkCvxRBI6Hsw3b0ldlXmIdIOndojHMDcGUWcV+frU1IvBfhiulmJuWA1LoghhAwAAQ==
X-Received: by 2002:a17:902:ecd1:b0:16a:6b2e:2a76 with SMTP id a17-20020a170902ecd100b0016a6b2e2a76mr13203916plh.90.1656310604051;
        Sun, 26 Jun 2022 23:16:44 -0700 (PDT)
Received: from [10.76.43.148] ([61.120.150.78])
        by smtp.gmail.com with ESMTPSA id w8-20020a1709026f0800b00168c523032fsm6204952plk.269.2022.06.26.23.16.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jun 2022 23:16:43 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [External] PING: [PATCH] crypto: testmgr - fix version number of
 RSA tests
From:   Lei He <helei.sig11@bytedance.com>
In-Reply-To: <YrZXly80TZhO6lBE@gondor.apana.org.au>
Date:   Mon, 27 Jun 2022 14:16:35 +0800
Cc:     Lei He <helei.sig11@bytedance.com>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        pizhenwei@bytedance.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <9C9200B6-FDF8-4DB3-A3E7-0C6BA65D69D2@bytedance.com>
References: <20220615091317.36995-1-helei.sig11@bytedance.com>
 <0610F5ED-98B5-49AD-9D58-4D5960EFB3A8@bytedance.com>
 <YrV7uo9E/5aegAny@gondor.apana.org.au>
 <062CAA76-7229-4E4F-A9A5-A2A9A47A1C61@bytedance.com>
 <YrZXly80TZhO6lBE@gondor.apana.org.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> On Jun 25, 2022, at 8:32 AM, Herbert Xu <herbert@gondor.apana.org.au> =
wrote:
>=20
> On Fri, Jun 24, 2022 at 06:29:29PM +0800, =E4=BD=95=E7=A3=8A wrote:
>>=20
>>=20
>>> On Jun 24, 2022, at 4:54 PM, Herbert Xu =
<herbert@gondor.apana.org.au> wrote:
>>>=20
>>> On Fri, Jun 24, 2022 at 09:53:02AM +0800, =E4=BD=95=E7=A3=8A wrote:
>>>> PING=EF=BC=81
>>>=20
>>> Please resubmit.
>>>=20
>>=20
>> Thanks a lot for your reply, a new patch has been sent.
>> By the way, why this patch needs to be resubmitted. Please let me =
know if I have made any mistakes.
>=20
> You first sent a subsequent version that superceded the
> original patch.  That subsequent patch was then dismissed because
> you replied in the thread saying that it needed changes.
>=20
> Please be more careful in how you send patches and thread them.

Thanks for the explanation, now all patches have been resubmitted. Sorry=20=

for the extra trouble, I'll be more careful in the future.

>=20
> Cheers,
> --=20
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

