Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25504C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Oct 2022 04:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiJNECM convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Oct 2022 00:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiJNECL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Oct 2022 00:02:11 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A767DED9BE
        for <linux-crypto@vger.kernel.org>; Thu, 13 Oct 2022 21:02:10 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-401-gxuhFJcYOv-EzyJDmGZ9AA-1; Fri, 14 Oct 2022 05:02:04 +0100
X-MC-Unique: gxuhFJcYOv-EzyJDmGZ9AA-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Fri, 14 Oct
 2022 05:02:03 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Fri, 14 Oct 2022 05:02:03 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Robert Elliott' <elliott@hpe.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>,
        "ap420073@gmail.com" <ap420073@gmail.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 05/19] crypto: x86/crc - limit FPU preemption
Thread-Topic: [PATCH v2 05/19] crypto: x86/crc - limit FPU preemption
Thread-Index: AQHY3oYZ7LB/MaiZeEeC/a2xezfdB64NQsbA
Date:   Fri, 14 Oct 2022 04:02:03 +0000
Message-ID: <85a029f30048495b963ae0ee0308853f@AcuMS.aculab.com>
References: <20221006223151.22159-1-elliott@hpe.com>
 <20221012215931.3896-1-elliott@hpe.com>
 <20221012215931.3896-6-elliott@hpe.com>
In-Reply-To: <20221012215931.3896-6-elliott@hpe.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Robert Elliott
> Sent: 12 October 2022 22:59
> 
> As done by the ECB and CBC helpers in arch/x86/crypt/ecb_cbc_helpers.h,
> limit the number of bytes processed between kernel_fpu_begin() and
> kernel_fpu_end() calls.
> 
> Those functions call preempt_disable() and preempt_enable(), so
> the CPU core is unavailable for scheduling while running, leading to:
>     rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: ...

How long were the buffers being processed when the rcu stall was reported?
It looks like you are adding kernel_fpu_end(); kernel_fpu_begin()
pairs every 4096 bytes.
I'd guess the crc instruction runs at 4 bytes/clock
(or at least gets somewhere near that).
So you are talking of few thousand clocks at most.
A pci read from a device can easily take much longer than that.
So I'm surprised you need to do such small buffers to avoid
rcu stalls.

The kernel_fpu_end(); kernel_fpu_begin() pair pair will also cost.
(Maybe not as much as the first kernel_fpu_begin() ?)

Some performance figures might be enlightening.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

