Return-Path: <SRS0=OEQJ=RW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F979C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Mar 2019 00:53:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7A5920989
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Mar 2019 00:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfCSAxB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Mar 2019 20:53:01 -0400
Received: from ozlabs.org ([203.11.71.1]:57607 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbfCSAxB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Mar 2019 20:53:01 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44NZKN0nzvz9s70;
        Tue, 19 Mar 2019 11:52:56 +1100 (AEDT)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Eric Biggers <ebiggers@kernel.org>, Daniel Axtens <dja@axtens.net>,
        leo.barbosa@canonical.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>, nayna@linux.ibm.com,
        omosnacek@gmail.com, leitao@debian.org, pfsmorigo@gmail.com,
        "open list\:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, marcelo.cerri@canonical.com,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] crypto: vmx - fix copy-paste error in CTR mode
In-Reply-To: <CAKv+Gu_w_d5AbkYu=fdK1ver97G4O_rqu9o9tNy_-zNaAOnkkA@mail.gmail.com>
References: <20190315020901.16509-1-dja@axtens.net> <20190315022414.GA1671@sol.localdomain> <875zsku5mk.fsf@dja-thinkpad.axtens.net> <20190315043433.GC1671@sol.localdomain> <87pnqo7ewp.fsf@concordia.ellerman.id.au> <CAKv+Gu_w_d5AbkYu=fdK1ver97G4O_rqu9o9tNy_-zNaAOnkkA@mail.gmail.com>
Date:   Tue, 19 Mar 2019 11:52:55 +1100
Message-ID: <87bm277kig.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel@linaro.org> writes:
> On Mon, 18 Mar 2019 at 09:41, Michael Ellerman <mpe@ellerman.id.au> wrote:
...
>>
>> I don't understand how the crypto core chooses which crypto_alg to use,
>> but I didn't expect enabling the tests to change it?
>
> This is not entirely unexpected. Based on the tests, algos that are
> found to be broken are disregarded for further use, and you should see
> a warning in the kernel log about this.

Ah right that makes sense then. I wasn't looking at the kernel log, just
rerunning the kcapi reproducer. Thanks for clarifying.

cheers
