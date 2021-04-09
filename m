Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F89C433B4
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 16:56:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 005CD610CC
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 16:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbhDIQ4Y convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Apr 2021 12:56:24 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:47292 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234174AbhDIQ4X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Apr 2021 12:56:23 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-227-DriuMqMLOW-eHfKXrEcolA-1; Fri, 09 Apr 2021 17:56:06 +0100
X-MC-Unique: DriuMqMLOW-eHfKXrEcolA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Fri, 9 Apr 2021 17:56:05 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.012; Fri, 9 Apr 2021 17:56:05 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Chris von Recklinghausen' <crecklin@redhat.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "simo@redhat.com" <simo@redhat.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "decui@microsoft.com" <decui@microsoft.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 1/1] use crc32 instead of md5 for hibernation e820
 integrity check
Thread-Topic: [PATCH v4 1/1] use crc32 instead of md5 for hibernation e820
 integrity check
Thread-Index: AQHXLGR5Apl1dLUk2U+lDfr8mZtTlqqsaSNw
Date:   Fri, 9 Apr 2021 16:56:05 +0000
Message-ID: <6be63531313d46caa7161697bf240dfc@AcuMS.aculab.com>
References: <20210408104629.31357-1-crecklin@redhat.com>
In-Reply-To: <20210408104629.31357-1-crecklin@redhat.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Chris von Recklinghausen
> Sent: 08 April 2021 11:46
> 
> Suspend fails on a system in fips mode because md5 is used for the e820
> integrity check and is not available. Use crc32 instead.
> 
> Prior to this patch, MD5 is used only to create a digest to ensure integrity of
> the region, no actual encryption is done. This patch set changes the integrity
> check to use crc32 instead of md5 since crc32 is available in both FIPS and
> non-FIPS modes.
> 
> Note that the digest is only used as an integrity check. No actual encryption
> is done.

If crc32 is good enough, would a 1's compliment sum be good enough?
It is likely to be faster to calculate and not need special
functions be built into the kernel at all.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

