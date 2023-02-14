Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0389C61DA4
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Feb 2023 08:41:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbjBNIlR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Feb 2023 03:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbjBNIkt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2023 03:40:49 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD711E5F2
        for <linux-crypto@vger.kernel.org>; Tue, 14 Feb 2023 00:40:47 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id cq19so13513193edb.5
        for <linux-crypto@vger.kernel.org>; Tue, 14 Feb 2023 00:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WnAs+yU5HM/pTqKau3Q0Rq84i+KCVbDi2UQjZa+CL2c=;
        b=IOnDLYY+0Elzxf0TfIWC8EQWsEwrMaCKhhOFqgZjFmVvvhT13q/P/HiGs9wvnJZ6rY
         7d/kHBm9tcw/+43TjyyzuBAzTUIBc7WDAyrdRrC3ftUtZ8MWczpGEDshaveZAoXjYStJ
         wXRHEHer6efEIxgXZwwTkp/fpBxcLZOJ2iGpCZ7R9EwapCFs9GD4u2xTmmBCJiFqlVt1
         nyLBu5KZknvt7j46xhFCUjQKWWVilqd0Uy8PqbPkk0z+LsxTGqKxuR/BiP0c3haHKWLN
         A4GZH590+O+wpdwg1L0i4yq5lnBwdrs5BxldDbuxuQjW6y2ri7YeqaXAnlm2/NIjEuZS
         PgIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WnAs+yU5HM/pTqKau3Q0Rq84i+KCVbDi2UQjZa+CL2c=;
        b=lCFui3Iki811vATNdyZ/P4wzrei1MxzmLgzQ8/nW8Vr3V506NvQ5q84Q02GscVeMU9
         X9q2Y+mzsMpws/oB8TDVsKen0ofHJqAdKo8qmxN2Gyp3uULwcSUqxObwb0vsBxYzebYq
         fO0fsHIk2y3+kTr3f65ouRDzNXVELhuUnylyKNNUpjmgMDkkvWGS9fb4LziMX+L1kMVE
         9jexMmv0cDiZQe3H//TB2KXJrYoSInIsIs5ym64Uz+trPOej9VFhigbIjC7YK2d6L9ju
         EToYt+0MmJ9mtSF1XPH2NoOsFhaYkJrC0PgpJMDS4MFxTttmVoneSZFXMQ1ZDq4I7H1F
         2rbg==
X-Gm-Message-State: AO0yUKXW/rkD66BlWAP4xbQXLeGSkgRRhlHg+1Xl3+OfPKk5ZzyZ7wFV
        Uq0gGLfjcWCD30sEi3kSQmMq7mrNM4reaWzMXrVzpA==
X-Google-Smtp-Source: AK7set+g3xZ0aQZ4h4txr/u0AcxLMzhWlvoyxDYAQAAQsRyAwaypYXTVYGXV7RZzLBtT6yY5FlYpLbAehTlxnCXUZ34=
X-Received: by 2002:a50:d097:0:b0:4ab:d0dd:ffac with SMTP id
 v23-20020a50d097000000b004abd0ddffacmr716481edd.4.1676364046326; Tue, 14 Feb
 2023 00:40:46 -0800 (PST)
MIME-Version: 1.0
References: <20230209223811.4993-1-mario.limonciello@amd.com> <20230209223811.4993-3-mario.limonciello@amd.com>
In-Reply-To: <20230209223811.4993-3-mario.limonciello@amd.com>
From:   =?UTF-8?B?SmFuIETEhWJyb8Wb?= <jsd@semihalf.com>
Date:   Tue, 14 Feb 2023 09:40:35 +0100
Message-ID: <CAOtMz3OfGFsiThY7hQYG2oh1=HKg7N56cuA28e+dhB4EtZsz=Q@mail.gmail.com>
Subject: Re: [PATCH 2/6] crypto: ccp: Add a header for multiple drivers to use `__psp_pa`
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Grzegorz Bernacki <gjb@semihalf.com>,
        Thomas Rijo-john <Rijo-john.Thomas@amd.com>,
        Lendacky Thomas <Thomas.Lendacky@amd.com>,
        herbert@gondor.apana.org.au,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        John Allen <john.allen@amd.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>, kvm@vger.kernel.org,
        op-tee@lists.trustedfirmware.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> The TEE subdriver for CCP, the amdtee driver and the i2c-designware-amdpsp
> drivers all include `psp-sev.h` even though they don't use SEV
> functionality.
>
> Move the definition of `__psp_pa` into a common header to be included
> by all of these drivers.
>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>

Reviewed-by: Jan Dabros <jsd@semihalf.com>
