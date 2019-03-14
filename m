Return-Path: <SRS0=KizA=RR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C154C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Mar 2019 00:53:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D803D217F5
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Mar 2019 00:53:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="TIiuGPRf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbfCNAxc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Mar 2019 20:53:32 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35194 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbfCNAxc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Mar 2019 20:53:32 -0400
Received: by mail-pg1-f195.google.com with SMTP id e17so2756700pgd.2
        for <linux-crypto@vger.kernel.org>; Wed, 13 Mar 2019 17:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=K11thIZxmNt9fMugDgK3Awc8dl/lwXPNdW2lxXs/fLY=;
        b=TIiuGPRfDG9rYm5tL5wIv67p4cfPfVcaHJZReBlFxT4ogfaYTOehaod0TFWrP3U86f
         wlltIVZs4dFr9cT9kG14l30/JZi2KPbGcR4iYXR32dOd/35Fv3dV4U64MFNqUKUVbBDf
         /KhtFrCOqNrLNnJvAplu1hi9YVhaQeobzkszA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=K11thIZxmNt9fMugDgK3Awc8dl/lwXPNdW2lxXs/fLY=;
        b=iZG1s0WtP8BK6cZqo0V4wbKnuLuFHtyi+MfZt3kpFjCorbfTsKmEvdWfhAfz/bGOQZ
         V6KcsxZHUWseEki+z+RrsRPHmIR3jQgvv5xPx/A7Z5sHQLSlthhaOKWD1shZeuJnbeVP
         2yS1qrMEmP5R+SNcqQR9PhbkrYIMf51NWSSEjV8zMd5dBn8M5Hl5Tb1K4lmeJQvPxRvi
         jN3HNJ9O83FYvsr6RrI0PxeQUUCVrKUaWi3qcRf7VpgRKsakt398kkelN+9TCiLThG6w
         x6JEWP03rMF50gcUX6qT8lVxmSBTf+Ljoad9L5OclAJHTUmK7pXpuQ5ut5SrCY/7LufV
         /uFw==
X-Gm-Message-State: APjAAAXNzIi8MTFCvaJBGprWbMh7nhVt/9RbNvV3aKq+aKVEDwFk6iqZ
        WcGtbXMAGTs7jh1Ay9EcdULLtQ==
X-Google-Smtp-Source: APXvYqyc834u9MoIPvajZWU3C2E+ZTOCEpZr59tseUn6RqTKV+XioMWD4Y8ln5KSGbBeCMtefiN1NA==
X-Received: by 2002:a17:902:e192:: with SMTP id cd18mr49544659plb.309.1552524811482;
        Wed, 13 Mar 2019 17:53:31 -0700 (PDT)
Received: from localhost (124-171-209-25.dyn.iinet.net.au. [124.171.209.25])
        by smtp.gmail.com with ESMTPSA id p187sm8701035pfg.64.2019.03.13.17.53.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 Mar 2019 17:53:30 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     leo.barbosa@canonical.com, Stephan Mueller <smueller@chronox.de>,
        nayna@linux.ibm.com, marcelo.cerri@canonical.com,
        pfsmorigo@gmail.com, leitao@debian.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: BUG: p8_aes_ctr randomly returns wrong results
In-Reply-To: <CAAUqJDuegy=zw3SwQ1UsV881DjLSvZ9X3joFt89HkBy7y9=7pg@mail.gmail.com>
References: <CAAUqJDtsx6Sdv=6xAb1VWWjDF08y8wh2nsAypR8_x_e99a1Uwg@mail.gmail.com> <CAAUqJDuegy=zw3SwQ1UsV881DjLSvZ9X3joFt89HkBy7y9=7pg@mail.gmail.com>
Date:   Thu, 14 Mar 2019 11:53:27 +1100
Message-ID: <87bm2etgxk.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ondrej,

I can confirm this on a ppc64le VM, at least as far back as 4.18, and am
investigating. Thanks for the reproducer.

Regards,
Daniel
