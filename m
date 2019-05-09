Return-Path: <SRS0=8ziv=TJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0747BC04AB1
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 14:48:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFF3820644
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 14:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfEIOsz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 May 2019 10:48:55 -0400
Received: from ozlabs.org ([203.11.71.1]:47237 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbfEIOsy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 May 2019 10:48:54 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 450GSL6vWcz9s4Y;
        Fri, 10 May 2019 00:48:50 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>
Cc:     Vakul Garg <vakul.garg@nxp.com>,
        "linux-crypto\@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "linuxppc-dev\@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] crypto: caam/jr - Remove extra memory barrier during job ring dequeue
In-Reply-To: <20190509052352.nje7a4niuc2n6c57@gondor.apana.org.au>
References: <87pnp2aflz.fsf@concordia.ellerman.id.au> <VI1PR0402MB34851F6AB9FE68A2322EB09E98340@VI1PR0402MB3485.eurprd04.prod.outlook.com> <20190509052352.nje7a4niuc2n6c57@gondor.apana.org.au>
Date:   Fri, 10 May 2019 00:48:50 +1000
Message-ID: <87r297vg31.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:
> On Thu, May 02, 2019 at 11:08:55AM +0000, Horia Geanta wrote:
>> >> +
>> >>  static inline void wr_reg32(void __iomem *reg, u32 data)
>> >>  {
>> >>  	if (caam_little_end)
>> > 
>> > This crashes on my p5020ds. Did you test on powerpc?
>> > 
>> > # first bad commit: [bbfcac5ff5f26aafa51935a62eb86b6eacfe8a49] crypto: caam/jr - Remove extra memory barrier during job ring dequeue
>> 
>> Thanks for the report Michael.
>> 
>> Any hint what would be the proper approach here - to have relaxed I/O accessors
>> that would work both for ARM and PPC, and avoid ifdeffery etc.?
>
> Since no fix has been found I'm reverting the commit in question.

Thanks.

Sorry I haven't had time to look into it with everything else going on
during the merge window.

cheers
