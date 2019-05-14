Return-Path: <SRS0=wJ3R=TO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6FBC04AB4
	for <linux-crypto@archiver.kernel.org>; Tue, 14 May 2019 17:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BC7A20879
	for <linux-crypto@archiver.kernel.org>; Tue, 14 May 2019 17:35:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="d1hrQP6H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfENRf5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 May 2019 13:35:57 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33421 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbfENRf5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 May 2019 13:35:57 -0400
Received: by mail-pl1-f194.google.com with SMTP id y3so8601802plp.0
        for <linux-crypto@vger.kernel.org>; Tue, 14 May 2019 10:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=ZTRncmxtDxlV1F7umKPD+uG9W2QsyoTTFP+CjuiFaiU=;
        b=d1hrQP6HgUD01+7GWOVBzOQ5PTUN/qhB4jZMcGO/Pd+k4zKMHgoXcd+1fx31QklV7i
         6BNhtNz3/WojLe294pPvIjAaip2059gJ2Ql2EITwg9Cpc2zE8yxq+RzOmtBf14B55RgX
         r8EpWbSI34USzzL8RF0SpbroLrAQ4pb50Nfzs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ZTRncmxtDxlV1F7umKPD+uG9W2QsyoTTFP+CjuiFaiU=;
        b=LCe+bT2PN+Zc+MTgTlj55ehZHNdsCq2aQsLl7UGWspr7ER7EGz8KlXSada7VHZXfgK
         6xnonDYhuGRsMX0eBPr8G5Sl71/18EcZwVlcSKqhiQacYXkNJ2Wpicu5GgPRLBIR6515
         84wlinfPr6iKIb1iSYHAhubD7BEYKLK+8VOeGOk2TL9Y2cBJxVfzifhIROp4Gd2nqnwo
         nHEAXNSQ0DFMQbg5/CaIQ9up7JAU+/yzpMV6gC4qziiO3aLhnPkrO69HFYFOBk4khYiu
         ha4TgVCAiaaE8LnS9uJEBJUBSGpG1ilvI4HDZqaMHGvxSsGDJ2Ot3QPrTfhtBRsNoDyB
         thgg==
X-Gm-Message-State: APjAAAVhvfqdMBGPb1EENxVO9k+UnbQ0910Ag9aCNOZiKkXvieeGLRad
        V2Xba0IBlglGzYGsAqsAy+CesYuxtCM=
X-Google-Smtp-Source: APXvYqxCO66J3FmsHeZHkJs4q9kftmYeVs7T9n3Dd/MZ8iMbZu1RqUSoi9RyfgWX3G41jaR2cflEpA==
X-Received: by 2002:a17:902:24a:: with SMTP id 68mr37701250plc.250.1557855355801;
        Tue, 14 May 2019 10:35:55 -0700 (PDT)
Received: from localhost (124-171-102-38.dyn.iinet.net.au. [124.171.102.38])
        by smtp.gmail.com with ESMTPSA id y16sm13035325pfo.133.2019.05.14.10.35.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 10:35:54 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Nayna <nayna@linux.vnet.ibm.com>, leo.barbosa@canonical.com,
        Stephan Mueller <smueller@chronox.de>, nayna@linux.ibm.com,
        omosnacek@gmail.com, leitao@debian.org, pfsmorigo@gmail.com,
        linux-crypto@vger.kernel.org, marcelo.cerri@canonical.com,
        George Wilson <gcwilson@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] crypto: vmx - fix copy-paste error in CTR mode
In-Reply-To: <87pnomtwgh.fsf@concordia.ellerman.id.au>
References: <20190315020901.16509-1-dja@axtens.net> <20190315022414.GA1671@sol.localdomain> <875zsku5mk.fsf@dja-thinkpad.axtens.net> <20190315043433.GC1671@sol.localdomain> <8736nou2x5.fsf@dja-thinkpad.axtens.net> <20190410070234.GA12406@sol.localdomain> <87imvkwqdh.fsf@dja-thinkpad.axtens.net> <2c8b042f-c7df-cb8b-3fcd-15d6bb274d08@linux.vnet.ibm.com> <8736mmvafj.fsf@concordia.ellerman.id.au> <20190506155315.GA661@sol.localdomain> <20190513005901.tsop4lz26vusr6o4@gondor.apana.org.au> <87pnomtwgh.fsf@concordia.ellerman.id.au>
Date:   Wed, 15 May 2019 03:35:51 +1000
Message-ID: <877eat0wi0.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Michael Ellerman <mpe@ellerman.id.au> writes:

> Herbert Xu <herbert@gondor.apana.org.au> writes:
>> On Mon, May 06, 2019 at 08:53:17AM -0700, Eric Biggers wrote:
>>>
>>> Any progress on this?  Someone just reported this again here:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=203515
>>
>> Guys if I don't get a fix for this soon I'll have to disable CTR
>> in vmx.
>
> No objection from me.
>
> I'll try and debug it at some point if no one else does, but I can't
> make it my top priority sorry.

I'm a bit concerned that this will end up filtering down to distros and
tanking crypto performance for the entire lifespan of the releases, so
I'd rather fix it if I can.

A quick additional test reveals an issue in the uneven misaligned
splits. (the may-sleep may reveal an extra bug, but there's at least one
with uneven/misaligned.)

By all means disable vmx ctr if I don't get an answer to you in a
timeframe you are comfortable with, but I am going to at least try to
have a look.

Regards,
Daniel

>
> cheers
