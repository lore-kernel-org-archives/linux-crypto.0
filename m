Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80BC3C48BE8
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Jun 2021 03:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59A8A61284
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Jun 2021 03:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbhFSDYW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Jun 2021 23:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235603AbhFSDYW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jun 2021 23:24:22 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463AFC061574
        for <linux-crypto@vger.kernel.org>; Fri, 18 Jun 2021 20:22:12 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id t9so9412371pgn.4
        for <linux-crypto@vger.kernel.org>; Fri, 18 Jun 2021 20:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=3T7Odnlsnem8BkJlC2xSfftmUKp4jKXmmLUMcPJbBEA=;
        b=Idn92CI+h8pY9q7HPYIz/0jW5jkAufr8GnNY7FFeQORmQ9SmvmYuuchs68QAnUofxU
         j642JXTnUvarg9FzIqNT/YOT2fQI3R9Vtura966K0T4HlNM7dtsb10gmwK6VcTMp3+UH
         N3woyo0zlsbbqlXbiO6+9V/oLRxLtbCUU8bVcVwbj7h2lf9RNRXweiUkKF3GCEmHaSSH
         KafqbdAdbLJrLdIdcEZ2Kf4sRBTBdRNTPtfl5EytC4bp713rC04HrKsQeisymGVv+1GK
         5TyTIo1xfYdMRjh1/PaiAJ+KAoPzLTmFKNIQW+sBfs9FFviPd9f1vFvzcH2M65Vbtjlk
         DdcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=3T7Odnlsnem8BkJlC2xSfftmUKp4jKXmmLUMcPJbBEA=;
        b=QdaNksWKkASAEYHnXtBYPxcbZIsUOUNlQ7AV7blAVp9+veeXiSu1LPP9bQqa6FniGg
         50al2+5e3Gj9oDyE8zz8d8zXJjD2iF/tF3mtjKDCDwyOEm1TQRsEhyA5tvVZ4zteVjpV
         BrBnqu8wO4uy5dCKTX8U4DsUAH5ht7bovt0aHr4/F8KC4eDkjxlUX8ILV+nWVZfS3EeK
         Py1ltSkIDWMemhTxnctewI/3HoGdC5XUKFKX0+xknUMP0x3/3GJhibrEoKJsYihhUbQ6
         HE0Mgp12Wt/WPWUxesbRI3VAnAo9og/PfhppobNO92dvGCa1KVhUmVHNofmPxp4VZerc
         Uv6g==
X-Gm-Message-State: AOAM533id6PFNuLN8pOAOStOl6U/l8ZfbtqQlb5Ybr2XWRsHrbKIFVLM
        Wu/t4jA1ze+YEp6QDiKrT9A=
X-Google-Smtp-Source: ABdhPJxXGfqiBU57ZsFrW4SrZNw5czQwAVUp1ykENVQ7Brhf201hESYNXZjgUGMvo2czRDaZpX0NhQ==
X-Received: by 2002:a63:ef44:: with SMTP id c4mr12840074pgk.162.1624072931781;
        Fri, 18 Jun 2021 20:22:11 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id h8sm8736847pjf.7.2021.06.18.20.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 20:22:11 -0700 (PDT)
Date:   Sat, 19 Jun 2021 13:22:05 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v6 12/17] powerpc/pseries/vas: Integrate API with
 open/close windows
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <827bf56dce09620ebecd8a00a5f97105187a6205.camel@linux.ibm.com>
        <e8d956bace3f182c4d2e66e343ff37cb0391d1fd.camel@linux.ibm.com>
        <1623971609.844odc55aw.astroid@bobo.none>
        <0d6ca1ec553a61b219f42ebf6699dd6c56e2e978.camel@linux.ibm.com>
In-Reply-To: <0d6ca1ec553a61b219f42ebf6699dd6c56e2e978.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1624072607.4axs4cpe7w.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of June 18, 2021 5:49 pm:
> On Fri, 2021-06-18 at 09:22 +1000, Nicholas Piggin wrote:
>> Excerpts from Haren Myneni's message of June 18, 2021 6:36 am:
>> > This patch adds VAS window allocatioa/close with the corresponding
>> > hcalls. Also changes to integrate with the existing user space VAS
>> > API and provide register/unregister functions to NX pseries driver.
>> >=20
>> > The driver register function is used to create the user space
>> > interface (/dev/crypto/nx-gzip) and unregister to remove this
>> > entry.
>> >=20
>> > The user space process opens this device node and makes an ioctl
>> > to allocate VAS window. The close interface is used to deallocate
>> > window.
>> >=20
>> > Signed-off-by: Haren Myneni <haren@linux.ibm.com>
>>=20
>> Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
>>=20
>> Unless there is some significant performance reason it might be
>> simplest
>> to take the mutex for the duration of the allocate and frees rather
>> than=20
>> taking it several times, covering the atomic with the lock instead.
>>=20
>> You have a big lock, might as well use it and not have to wonder what
>> if=20
>> things race here or there.
>=20
> Using mutex to protect allocate/deallocate window and setup/free IRQ,
> also to protect updating the list. We do not need lock for modify
> window hcall and other things. Hence taking mutex several times.

Right, at which point you have to consider what happens with=20
interleaving allocates and deallocates. I'm not saying it's wrong, just=20
that if you do credential allocation, hcall allocation, irq allocation,=20
and list insertion all under the one lock, and remoe it all under the=20
one lock, concurrency requires less attention.


> Also
> used atomic for counters (used_lpar_creds) which can be exported in
> sysfs (this patch will be added later in next enhancement seris).=20

That's okay you can use mutexes for that too if that's how you're
protecting them.

>=20
> Genarlly applications open window initially, do continuous copy/paste
> operations and close window later. But possible that the library /
> application to open/close window for each request. Also may be opening
> or closing multiple windows (say 1000 depends on cores on the system)
> at the same time. These cases may affect the application performance.

It definitely could if you have a lot of concurrent open/close, but
the code as is won't handle it all that well either, so there's the
question of what is reasonable to do and what is reasonable to add
concurrency complexity for.

As I said, you've got it working and seem to have covered all cases now=20
so let's get the series in first. But something to consider changing
IMO.

Thanks,
Nick
