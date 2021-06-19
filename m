Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE6D2C48BDF
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Jun 2021 03:22:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B92DC61363
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Jun 2021 03:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235603AbhFSDZA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Jun 2021 23:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234943AbhFSDZA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jun 2021 23:25:00 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E70C061574
        for <linux-crypto@vger.kernel.org>; Fri, 18 Jun 2021 20:22:49 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l11so2484159pji.5
        for <linux-crypto@vger.kernel.org>; Fri, 18 Jun 2021 20:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=6TdDLes2Gw5ionLs5FEcoq+qBpg/39isQHw8hmOU2DM=;
        b=DIK4FeNKIz4uCyjknxXRGeur2lOR4V6Rm15a9SC3QuG8+LEAXvJu/F4FUwHaev8Yo8
         ysyUTIRpWZLUXV5rhUDSGKfc0+2GSqtZkhOHf7HHmK4ijX97R3k5mkjCAtUIm/l+/CJN
         mOV+R1jkEWDQiyy4vqqQZXOLJQn1zQj/m9C4lXUXmNFyobuYc/T5CQ8sDPD53x8GNo+O
         BH9v2VW8TlG6JqB/pCd6rtoausxb04nCUwFtvVp4wDKEJoajRDyoXib/2StggY7vD86U
         DMWYrj19QZvxlLJ7aZQTvLrpUOueNo6HthLIfHhFbl8nTXpTvqZh8FzqX+RIoYH+EKPS
         JHoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=6TdDLes2Gw5ionLs5FEcoq+qBpg/39isQHw8hmOU2DM=;
        b=dBjjGDQ3n1wTU7vUoTXRosjUPLiNtMXpN+K9tExPFpZcDG5tx4jX8cK7dHtkQXK5kv
         hz7Al/qDWklHUsSmDr1gbePn2sq3n3uGvZI6P2isIy5iNUrcqYH8sAd2oPJ1FqqL7Zte
         QO64tBCOrwlf+n5hxjML1lnuqYG/sqgBXzoR9O91BxFtUJIL7LZ32W9dlr1TlycUKvgC
         RHiumNssae+4/4ExBqJcIP5KS1KEVqqpOZHKXzCbpZyuT4QgKddSYKsAtfr0F6FoQQSV
         QVpfb+Dk2ReqbQb125teAah8k4z1eMjbblC8fSQk0skeXWwNfK9NWxzpmx5PAzJJFVtA
         SpUw==
X-Gm-Message-State: AOAM531G5dUlqpJ/WeGUsSY04/JHpMww6xY+nbYPiZIYSb276q1WA23K
        5pJgOAwP6EP8A5Z85sVkWsM=
X-Google-Smtp-Source: ABdhPJwOI/w4OXi61+N0pqTaQ2lOXCarNRIDwPwwwOCgihfmzYj4yCU8eDlQ17zFLpoz9uKa3wf7GA==
X-Received: by 2002:a17:902:6904:b029:fb:42b6:e952 with SMTP id j4-20020a1709026904b02900fb42b6e952mr7625233plk.16.1624072969252;
        Fri, 18 Jun 2021 20:22:49 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id q23sm10014316pgm.31.2021.06.18.20.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 20:22:48 -0700 (PDT)
Date:   Sat, 19 Jun 2021 13:22:43 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v6 13/17] powerpc/pseries/vas: Setup IRQ and fault
 handling
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <827bf56dce09620ebecd8a00a5f97105187a6205.camel@linux.ibm.com>
        <b8fc66dcb783d06a099a303e5cfc69087bb3357a.camel@linux.ibm.com>
        <1623972635.u8jj6g26re.astroid@bobo.none>
        <a19e7839316c9ec4f7901e97b551fcf4219de82f.camel@linux.ibm.com>
In-Reply-To: <a19e7839316c9ec4f7901e97b551fcf4219de82f.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1624072930.d9ivbdzz50.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of June 18, 2021 12:09 pm:
> On Fri, 2021-06-18 at 09:34 +1000, Nicholas Piggin wrote:
>> Excerpts from Haren Myneni's message of June 18, 2021 6:37 am:
>> > NX generates an interrupt when sees a fault on the user space
>> > buffer and the hypervisor forwards that interrupt to OS. Then
>> > the kernel handles the interrupt by issuing H_GET_NX_FAULT hcall
>> > to retrieve the fault CRB information.
>> >=20
>> > This patch also adds changes to setup and free IRQ per each
>> > window and also handles the fault by updating the CSB.
>>=20
>> In as much as this pretty well corresponds to the PowerNV code
>> AFAIKS,
>> it looks okay to me.
>>=20
>> Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
>>=20
>> Could you have an irq handler in your ops vector and have=20
>> the core code set up the irq and call your handler, so the Linux irq
>> handling is in one place? Not something for this series, I was just
>> wondering.
>=20
> Not possible to have common core code for IRQ  setup.=20
>=20
> PowerNV: Every VAS instance will be having IRQ and this setup will be
> done during initialization (system boot). A fault FIFO will be assigned
> for each instance and registered to VAS so that VAS/NX writes fault CRB
> into this FIFO. =20
>=20
> PowerVM: Each window will have an IRQ and the setup will be done during
> window open.=20

Yeah, I thought as much. Just wondering.

Thanks,
Nick
