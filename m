Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E897CE7A95
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Sep 2023 15:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbjIYPLX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Sep 2023 11:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbjIYPLW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Sep 2023 11:11:22 -0400
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD279103
        for <linux-crypto@vger.kernel.org>; Mon, 25 Sep 2023 08:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1695654676; x=1727190676;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=laqhfkaMk1emxqXbBHQuPhdUTmHi74kih73ISull9rM=;
  b=lp0LVMA7SrRDlBUjaPA/Y4gHJMUulj/OMT7YXdvyiTYWIpt43DqSUnxB
   OE01raI6tc+bWwNvCERDUCvGQ1b9xI3wVsIm0jPFB84oJkpgJla/mgSeF
   F5WbhTE4X5MTbt795SSeSbu5DC1FWrao1QAuBtlNlw3XU0/x+AR70OpnY
   Q=;
X-IronPort-AV: E=Sophos;i="6.03,175,1694736000"; 
   d="scan'208";a="585505402"
Subject: RE: [PATCH 0/3] crypto: jitter - Offer compile-time options
Thread-Topic: [PATCH 0/3] crypto: jitter - Offer compile-time options
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 15:11:14 +0000
Received: from EX19MTAUEA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com (Postfix) with ESMTPS id C052E8A5A3;
        Mon, 25 Sep 2023 15:11:12 +0000 (UTC)
Received: from EX19D030UEC002.ant.amazon.com (10.252.137.180) by
 EX19MTAUEA002.ant.amazon.com (10.252.134.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Mon, 25 Sep 2023 15:11:12 +0000
Received: from EX19D030UEC003.ant.amazon.com (10.252.137.182) by
 EX19D030UEC002.ant.amazon.com (10.252.137.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Mon, 25 Sep 2023 15:11:12 +0000
Received: from EX19D030UEC003.ant.amazon.com ([fe80::6222:63e7:9834:7b89]) by
 EX19D030UEC003.ant.amazon.com ([fe80::6222:63e7:9834:7b89%3]) with mapi id
 15.02.1118.037; Mon, 25 Sep 2023 15:11:12 +0000
From:   "Ospan, Abylay" <aospan@amazon.com>
To:     =?iso-8859-1?Q?Stephan_M=FCller?= <smueller@chronox.de>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Thread-Index: AQHZ7IHXOjhrYWJJlUG53kdcMUz5/7Arpuvg
Date:   Mon, 25 Sep 2023 15:11:11 +0000
Message-ID: <79fe855f99e44c97b6ac3348faac05d3@amazon.com>
References: <2700818.mvXUDI8C0e@positron.chronox.de>
In-Reply-To: <2700818.mvXUDI8C0e@positron.chronox.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.239.32]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

We ran tests with your patches on our bare metal platform (AMD Epyc CPU) an=
d saw an improvement in boot time entropy after analyzing the collected jit=
ter deltas.
Patches looks good to me.
Thanks for your work!

Acked-by: Abylay Ospan <aospan@amazon.com>

-----Original Message-----
From: Stephan M=FCller <smueller@chronox.de>=20
Sent: Thursday, September 21, 2023 7:48 AM
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org; Ospan, Abylay <aospan@amazon.com>
Subject: [EXTERNAL] [PATCH 0/3] crypto: jitter - Offer compile-time options

CAUTION: This email originated from outside of the organization. Do not cli=
ck links or open attachments unless you can confirm the sender and know the=
 content is safe.



Hi,

the following patchset offers a set of compile-time options to accommodate =
different hardware with different entropy rates implied in their timers. Th=
is allows configuring the Jitter RNG in systems which exhibits insufficient=
 entropy with the default parameters. The default parameters defined by the=
 patches, however, are identical to the existing code and thus do not alter=
 the Jitter RNG behavior.

The first patch sets the state by allowing the configuration of different o=
versampling rates. The second patch allows the configuration of different m=
emory sizes and the third allows the configuration of differnet oversamplin=
g rates.

The update of the power up test with the first patch also addresses reports=
 that the Jitter RNG did not initialize due to it detected insufficient ent=
ropy.

Stephan Mueller (3):
  crypto: jitter - add RCT/APT support for different OSRs
  crypto: jitter - Allow configuration of memory size
  crypto: jitter - Allow configuration of oversampling rate

 crypto/Kconfig               |  60 +++++++++
 crypto/jitterentropy-kcapi.c |  17 ++-
 crypto/jitterentropy.c       | 249 ++++++++++++++++++-----------------
 crypto/jitterentropy.h       |   5 +-
 4 files changed, 207 insertions(+), 124 deletions(-)

--
2.42.0




