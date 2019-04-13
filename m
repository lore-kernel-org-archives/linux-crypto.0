Return-Path: <SRS0=4IwG=SP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39646C10F0E
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Apr 2019 03:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E7B420848
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Apr 2019 03:41:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfDMDlj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 23:41:39 -0400
Received: from ozlabs.org ([203.11.71.1]:44647 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726913AbfDMDlj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 23:41:39 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44h0tR58h4z9s4V;
        Sat, 13 Apr 2019 13:41:35 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Nayna <nayna@linux.vnet.ibm.com>, Daniel Axtens <dja@axtens.net>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     leo.barbosa@canonical.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>, nayna@linux.ibm.com,
        omosnacek@gmail.com, leitao@debian.org, pfsmorigo@gmail.com,
        linux-crypto@vger.kernel.org, marcelo.cerri@canonical.com,
        George Wilson <gcwilson@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] crypto: vmx - fix copy-paste error in CTR mode
In-Reply-To: <2c8b042f-c7df-cb8b-3fcd-15d6bb274d08@linux.vnet.ibm.com>
References: <20190315020901.16509-1-dja@axtens.net> <20190315022414.GA1671@sol.localdomain> <875zsku5mk.fsf@dja-thinkpad.axtens.net> <20190315043433.GC1671@sol.localdomain> <8736nou2x5.fsf@dja-thinkpad.axtens.net> <20190410070234.GA12406@sol.localdomain> <87imvkwqdh.fsf@dja-thinkpad.axtens.net> <2c8b042f-c7df-cb8b-3fcd-15d6bb274d08@linux.vnet.ibm.com>
Date:   Sat, 13 Apr 2019 13:41:36 +1000
Message-ID: <8736mmvafj.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Nayna <nayna@linux.vnet.ibm.com> writes:

> On 04/11/2019 10:47 AM, Daniel Axtens wrote:
>> Eric Biggers <ebiggers@kernel.org> writes:
>>
>>> Are you still planning to fix the remaining bug?  I booted a ppc64le VM, and I
>>> see the same test failure (I think) you were referring to:
>>>
>>> alg: skcipher: p8_aes_ctr encryption test failed (wrong result) on test vector 3, cfg="uneven misaligned splits, may sleep"
>>>
>> Yes, that's the one I saw. I don't have time to follow it up at the
>> moment, but Nayna is aware of it.
>>
>
> Yes Eric, we identified this as a separate issue of misalignment and 
> plan to post a separate patch to address it.

I also wrote it down in my write-only TODO list here:

  https://github.com/linuxppc/issues/issues/238


cheers
