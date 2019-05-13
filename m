Return-Path: <SRS0=12xR=TN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90752C04AA7
	for <linux-crypto@archiver.kernel.org>; Mon, 13 May 2019 11:39:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C2842070D
	for <linux-crypto@archiver.kernel.org>; Mon, 13 May 2019 11:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbfEMLjb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 May 2019 07:39:31 -0400
Received: from ozlabs.org ([203.11.71.1]:42739 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729239AbfEMLjb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 May 2019 07:39:31 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 452f3z2zSzz9s00;
        Mon, 13 May 2019 21:39:27 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Nayna <nayna@linux.vnet.ibm.com>, Daniel Axtens <dja@axtens.net>,
        leo.barbosa@canonical.com, Stephan Mueller <smueller@chronox.de>,
        nayna@linux.ibm.com, omosnacek@gmail.com, leitao@debian.org,
        pfsmorigo@gmail.com, linux-crypto@vger.kernel.org,
        marcelo.cerri@canonical.com,
        George Wilson <gcwilson@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] crypto: vmx - fix copy-paste error in CTR mode
In-Reply-To: <20190513005901.tsop4lz26vusr6o4@gondor.apana.org.au>
References: <20190315020901.16509-1-dja@axtens.net> <20190315022414.GA1671@sol.localdomain> <875zsku5mk.fsf@dja-thinkpad.axtens.net> <20190315043433.GC1671@sol.localdomain> <8736nou2x5.fsf@dja-thinkpad.axtens.net> <20190410070234.GA12406@sol.localdomain> <87imvkwqdh.fsf@dja-thinkpad.axtens.net> <2c8b042f-c7df-cb8b-3fcd-15d6bb274d08@linux.vnet.ibm.com> <8736mmvafj.fsf@concordia.ellerman.id.au> <20190506155315.GA661@sol.localdomain> <20190513005901.tsop4lz26vusr6o4@gondor.apana.org.au>
Date:   Mon, 13 May 2019 21:39:26 +1000
Message-ID: <87pnomtwgh.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:
> On Mon, May 06, 2019 at 08:53:17AM -0700, Eric Biggers wrote:
>>
>> Any progress on this?  Someone just reported this again here:
>> https://bugzilla.kernel.org/show_bug.cgi?id=203515
>
> Guys if I don't get a fix for this soon I'll have to disable CTR
> in vmx.

No objection from me.

I'll try and debug it at some point if no one else does, but I can't
make it my top priority sorry.

cheers
