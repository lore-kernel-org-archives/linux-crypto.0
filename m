Return-Path: <SRS0=RZ7K=U4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D23F1C5B57A
	for <linux-crypto@archiver.kernel.org>; Sat, 29 Jun 2019 11:31:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4FEE20828
	for <linux-crypto@archiver.kernel.org>; Sat, 29 Jun 2019 11:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfF2Lb2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 29 Jun 2019 07:31:28 -0400
Received: from ozlabs.org ([203.11.71.1]:33429 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbfF2Lb1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 Jun 2019 07:31:27 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45bWg127zJz9s3l;
        Sat, 29 Jun 2019 21:31:25 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Haren Myneni <haren@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V2] crypto/NX: Set receive window credits to max number of CRBs in RxFIFO
In-Reply-To: <20190628020715.6qopmtm4q63lsdxm@gondor.apana.org.au>
References: <20190627062610.olw3ojckkwil4jlk@gondor.apana.org.au> <87tvcascwb.fsf@concordia.ellerman.id.au> <20190628020715.6qopmtm4q63lsdxm@gondor.apana.org.au>
Date:   Sat, 29 Jun 2019 21:31:25 +1000
Message-ID: <877e94k4qa.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:
> On Fri, Jun 28, 2019 at 11:43:16AM +1000, Michael Ellerman wrote:
>>
>> No. I assumed you'd take it because it's in drivers/crypto.
>> 
>> If you want me to take it that's fine, just let me know.
>
> No that's fine Michael.  I'll pick it up.

Thanks.

cheers
