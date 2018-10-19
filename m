Return-Path: <SRS0=GKHD=M7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CE0ECDE43
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Oct 2018 20:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B527C21470
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Oct 2018 20:31:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="trwa4RN4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B527C21470
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbeJTEii (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Oct 2018 00:38:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbeJTEii (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Oct 2018 00:38:38 -0400
Received: from gmail.com (unknown [104.132.51.88])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A9D32087A;
        Fri, 19 Oct 2018 20:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1539981059;
        bh=X9Lp/Fi++CCKZxramvePOFSOw9Gs65dT+W7a/u58wGg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=trwa4RN40cRw9bRtqWwrJtRiMRtzSJ0ghDtAKrd6m+x/Z50PL/L/3Nek0x9OnoeK2
         9h/prm5U/2ayZTJqUZssEdNvcokTPAz/+PEiqvszAyuA36A0Liw1l96bSJs26VkMVg
         MYKnK837nAAMSYP3oI3CpNXUiwKrl8QF97wxIWAw=
Date:   Fri, 19 Oct 2018 13:30:58 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Paul Crowley <paulcrowley@google.com>
Subject: Re: [PATCH v3 2/2] crypto: arm/aes - add some hardening against
 cache-timing attacks
Message-ID: <20181019203056.GC246441@gmail.com>
References: <20181018043759.7669-1-ebiggers@kernel.org>
 <20181018043759.7669-3-ebiggers@kernel.org>
 <CAKv+Gu9XJ0k82ZNPRirs3Qhda3375CUA8uhJmsK85=1a9VmaNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9XJ0k82ZNPRirs3Qhda3375CUA8uhJmsK85=1a9VmaNQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181019203058.7K0jbcQomQG_tP2SYCMDHzNIg_PV5l6sUP0ZdyFUedM@z>

On Fri, Oct 19, 2018 at 01:41:35PM +0800, Ard Biesheuvel wrote:
> On 18 October 2018 at 12:37, Eric Biggers <ebiggers@kernel.org> wrote:
> > From: Eric Biggers <ebiggers@google.com>
> >
> > Make the ARM scalar AES implementation closer to constant-time by
> > disabling interrupts and prefetching the tables into L1 cache.  This is
> > feasible because due to ARM's "free" rotations, the main tables are only
> > 1024 bytes instead of the usual 4096 used by most AES implementations.
> >
> > On ARM Cortex-A7, the speed loss is only about 5%.  The resulting code
> > is still over twice as fast as aes_ti.c.  Responsiveness is potentially
> > a concern, but interrupts are only disabled for a single AES block.
> >
> 
> So that would be in the order of 700 cycles, based on the numbers you
> shared in v1 of the aes_ti.c patch. Does that sound about right? So
> that would be around 1 microsecond, which is really not a number to
> obsess about imo.
> 

Correct, on ARM Cortex-A7 I'm seeing slightly over 700 cycles per block
encrypted or decrypted, including the prefetching.

- Eric
