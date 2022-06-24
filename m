Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6244C43334
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jun 2022 10:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiFXK3j (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Jun 2022 06:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiFXK3g (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Jun 2022 06:29:36 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936807C510
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jun 2022 03:29:35 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id g186so2033499pgc.1
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jun 2022 03:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=KatmNFegpiHa4XcFnF/ycDsax8Ii/xreUk8t49K2md4=;
        b=aaB4GepycXY4qHK+rOH6fucojuXePHoKBEowfFS+oDZJaFBxnn2KUyBsIb5M7HaFGM
         KTR2N4HLlP57VXQXi85kAZyNKUyfHk30Ny6PDlgCApycVDZHSUyFzOZ7SkFAFIIt5HcW
         QTrE9DlJ/lybVdxWyL9m1Nm8x9hxzBgVUoeHQyX2Zv485tPkN93XcwwkObYXhwNcDMxt
         uQs1ki/P7A7Wulr7VHCmtpda53NO0xnZmoPrU6iDTgRf5qA0CHawrVPGDCR5ohKqsxAC
         QZ+Ax/oPgb0fJPG6/Fqw1iptxYQuythDCfpwKbDLMQoyPgvVxl04pi278TUfo1pIMH0u
         vutQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=KatmNFegpiHa4XcFnF/ycDsax8Ii/xreUk8t49K2md4=;
        b=mu2hdh24QINBM0PimjaONdJAv1BzOFFi2dYgedU/ainLAvFbX0PmKYbAQRbWhLSART
         Gsc0svlQMOno+lWlzzRK5zVkeXqwCrC5sprNf+EhoPsyO8i8G4wJKqb8O5XAhvkZV+u2
         OL5McAJ5aOp5UNHpaYuEzBoYtFb6D7++/40CMt+iVQmFOlINxuy32YpS52v9Zl884e3p
         WNtdTiS69gqkxy7HTGoE96efzlv2GwLSokYfY7nndZWtSJan1X/236LCYIle5G6bAQJe
         efdOnY/HV4Vl1SF/+xmkIUOIga/Mf8pm/Z8e4oGU36Do3fQIIU+QwfDnW94mzID/FkZV
         LfNQ==
X-Gm-Message-State: AJIora/miiHaWIN9cr/QYvHB/3ng2jo+jZ4ZmQNVJpTSNQ4HNKAY++Tj
        bZOWehMyMpc/wp13Iu9EkDJ8/Q==
X-Google-Smtp-Source: AGRyM1uKAAQZaYk8U8ySGqwrKTZUdSq6BaGRIvxvarOfo5pOTr/Qxgw7qufyOu4fB677SeTEt0X5+g==
X-Received: by 2002:a63:7448:0:b0:40c:7d4b:e7c6 with SMTP id e8-20020a637448000000b0040c7d4be7c6mr11415665pgn.140.1656066575139;
        Fri, 24 Jun 2022 03:29:35 -0700 (PDT)
Received: from n254-073-104.byted.org ([139.177.225.250])
        by smtp.gmail.com with ESMTPSA id ay19-20020a056a00301300b0052527b01b61sm1343699pfb.145.2022.06.24.03.29.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jun 2022 03:29:34 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [External] PING: [PATCH] crypto: testmgr - fix version number of
 RSA tests
From:   =?utf-8?B?5L2V56OK?= <helei.sig11@bytedance.com>
In-Reply-To: <YrV7uo9E/5aegAny@gondor.apana.org.au>
Date:   Fri, 24 Jun 2022 18:29:29 +0800
Cc:     =?utf-8?B?5L2V56OK?= <helei.sig11@bytedance.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, pizhenwei@bytedance.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <062CAA76-7229-4E4F-A9A5-A2A9A47A1C61@bytedance.com>
References: <20220615091317.36995-1-helei.sig11@bytedance.com>
 <0610F5ED-98B5-49AD-9D58-4D5960EFB3A8@bytedance.com>
 <YrV7uo9E/5aegAny@gondor.apana.org.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> On Jun 24, 2022, at 4:54 PM, Herbert Xu <herbert@gondor.apana.org.au> =
wrote:
>=20
> On Fri, Jun 24, 2022 at 09:53:02AM +0800, =E4=BD=95=E7=A3=8A wrote:
>> PING=EF=BC=81
>=20
> Please resubmit.
>=20

Thanks a lot for your reply, a new patch has been sent.
By the way, why this patch needs to be resubmitted. Please let me know =
if I have made any mistakes.

> Thanks,
> --=20
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

