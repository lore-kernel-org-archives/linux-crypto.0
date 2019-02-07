Return-Path: <SRS0=Jc5W=QO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FA0C282C2
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Feb 2019 11:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DBEF2080A
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Feb 2019 11:49:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="iY/rfZKu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbfBGLtF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Feb 2019 06:49:05 -0500
Received: from mail.skyhub.de ([5.9.137.197]:55136 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbfBGLtF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Feb 2019 06:49:05 -0500
Received: from zn.tnic (p200300EC2BD1880034901D79874D129C.dip0.t-ipconnect.de [IPv6:2003:ec:2bd1:8800:3490:1d79:874d:129c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A0B821EC01AF;
        Thu,  7 Feb 2019 12:49:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1549540143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=1oaCwids/ogA12gzWD1AZmEg7ljig8TuAyv9JTN29dQ=;
        b=iY/rfZKupPqyX4zuqXt9E8eMfSHn264rs+wqrvwqt6U/tfc1TdZXscujcvskWq8I122m5M
        eLWK3xtpiSvhe08HxMbjx9ssYXVXUfl0rdea79RKGzl8lRqQBkNPrJwr52FNS7mx4DD0Gh
        jYhm6Z6C6EqxSuLT80vFJwv3mIv9rUQ=
Date:   Thu, 7 Feb 2019 12:48:50 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Garnier <thgarnie@chromium.org>
Cc:     kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 01/27] x86/crypto: Adapt assembly for PIE support
Message-ID: <20190207114850.GD2414@zn.tnic>
References: <20190131192533.34130-1-thgarnie@chromium.org>
 <20190131192533.34130-2-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190131192533.34130-2-thgarnie@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 31, 2019 at 11:24:08AM -0800, Thomas Garnier wrote:
> Change the assembly code to use only relative references of symbols for the
> kernel to be PIE compatible.
> 
> Position Independent Executable (PIE) support will allow to extend the
> KASLR randomization range below 0xffffffff80000000.

This sentence is auto-sprinkled in a bunch of commit messages. Sounds to
me it should be rather somewhere in the 0/n message as a justification
for the feature but not in every other commit message...?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
