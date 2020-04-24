Return-Path: <SRS0=W4lJ=6I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F528C55192
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 03:23:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D5752075A
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 03:23:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="DMkHr9Ib"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgDXDX2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Apr 2020 23:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725884AbgDXDX1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Apr 2020 23:23:27 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30BEC09B044;
        Thu, 23 Apr 2020 20:23:26 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 497fdQ6pKKz9sRN;
        Fri, 24 Apr 2020 13:23:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1587698604;
        bh=yAIc2uyPXVcFRboAmVKyaSV3odWtXIhpZa+qqsow4dA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=DMkHr9Ib5eFf1mzjIT4DzxDSLbh72Pn7BbspM1HinsZ2dwkB1bHihTX/atx1lPDR7
         L/DO8BCuJk/xhYEpHMGj0VfHgShVz+asYSha7A6fbfJyBx+79gmUGf9DpBQvv/xhJG
         Sppljqu27EM7c9vuIOg3W5lWL1GZTdDW49hfAsMfsmFrmn1Ine+aWf0PqDiVEUkgX4
         J84RwLxbd4OkPPp22INlAbVYpjhTHe1NGzB3TOrR+6hKihlWqa+37o7JeEUdxCsgFV
         AyAnOZRee+MlzV13oOX2NUsxhfZkDw+f+uPd1UEI1U3nCO6HL7ysy+4CLA4+lVnFSi
         HoFd8CYzwUmNQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] lib/mpi: Fix building for powerpc with clang
In-Reply-To: <20200423163602.GA18872@ubuntu-s3-xlarge-x86>
References: <20200413195041.24064-1-natechancellor@gmail.com> <20200414135731.GA8766@gondor.apana.org.au> <20200423163602.GA18872@ubuntu-s3-xlarge-x86>
Date:   Fri, 24 Apr 2020 13:23:37 +1000
Message-ID: <87eesdh8hy.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Nathan Chancellor <natechancellor@gmail.com> writes:
> On Tue, Apr 14, 2020 at 11:57:31PM +1000, Herbert Xu wrote:
>> On Mon, Apr 13, 2020 at 12:50:42PM -0700, Nathan Chancellor wrote:
>> > 0day reports over and over on an powerpc randconfig with clang:
>> > 
>> > lib/mpi/generic_mpih-mul1.c:37:13: error: invalid use of a cast in a
>> > inline asm context requiring an l-value: remove the cast or build with
>> > -fheinous-gnu-extensions
>> > 
>> > Remove the superfluous casts, which have been done previously for x86
>> > and arm32 in commit dea632cadd12 ("lib/mpi: fix build with clang") and
>> > commit 7b7c1df2883d ("lib/mpi/longlong.h: fix building with 32-bit
>> > x86").
>> > 
>> > Reported-by: kbuild test robot <lkp@intel.com>
>> > Link: https://github.com/ClangBuiltLinux/linux/issues/991
>> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
>> 
>> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
>> -- 
>> Email: Herbert Xu <herbert@gondor.apana.org.au>
>> Home Page: http://gondor.apana.org.au/~herbert/
>> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
> Might be better for you to take this instead. 0day just tripped over
> this again.

Sorry I missed the ack. Will pick it up today.

cheers
