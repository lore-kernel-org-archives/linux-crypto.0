Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D8E6C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 18:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C7492083B
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 18:05:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="Ogopxp/q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfF1SFQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 14:05:16 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:4619 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbfF1SFP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 14:05:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1561745114; x=1593281114;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=J+7jeQfzr9Moq8Agn+ISSYlrytYaSGG1qD4Mlh6TYn8=;
  b=Ogopxp/quGZatCOVgERjpBsbBW24yLLc6a0IGf2x9AVeh6fJ+RgTRzOq
   AzLeuyuQs7u9tVvpA07iisB35nWj48OXa23ah0EkUKCd3wt/Sqpguz3To
   ZFtlmiiwA8E44EAYDemsb2qcn0IVBMbkxDKMu8SuFhTjuUGto7++X+q1o
   4=;
X-IronPort-AV: E=Sophos;i="5.62,428,1554768000"; 
   d="scan'208";a="813347880"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 28 Jun 2019 18:05:13 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 72AC2A18E5;
        Fri, 28 Jun 2019 18:05:12 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.96) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 28 Jun 2019 18:05:12 +0000
Received: from EX13D02UWC004.ant.amazon.com (10.43.162.236) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 28 Jun 2019 18:05:11 +0000
Received: from EX13D02UWC004.ant.amazon.com ([10.43.162.236]) by
 EX13D02UWC004.ant.amazon.com ([10.43.162.236]) with mapi id 15.00.1367.000;
 Fri, 28 Jun 2019 18:05:10 +0000
From:   "Saidi, Ali" <alisaidi@amazon.com>
To:     Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
CC:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rindjunsky, Ron" <ronrindj@amazon.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/3] Add support for Graviton TRNG
Thread-Topic: [PATCH 0/3] Add support for Graviton TRNG
Thread-Index: AQHVGxR9rewpsnhufE+Qj7iDYwflKaaM+/mAgALbeQCAIVaegA==
Date:   Fri, 28 Jun 2019 18:05:10 +0000
Message-ID: <3104F396-094F-454C-8308-BF651FAB99AB@amazon.com>
References: <20190604203100.15050-1-alisaidi@amazon.com>
 <20190605122031.GK15030@fuggles.cambridge.arm.com>
 <7EC45708-38A1-4826-BC82-298EFAAE30B1@amazon.com>
In-Reply-To: <7EC45708-38A1-4826-BC82-298EFAAE30B1@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.161.147]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9B45E3D979865C468A2C17E957CEA6B4@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNi83LzE5LCA3OjU5IEFNLCAiIEFsaSBTYWlkaSIgPGFsaXNhaWRpQGFtYXpvbi5jb20+IHdy
b3RlOg0KDQogICAgDQogICAgDQogICAgT24gNi81LzE5LCA3OjIwIEFNLCAiV2lsbCBEZWFjb24i
IDx3aWxsLmRlYWNvbkBhcm0uY29tPiB3cm90ZToNCiAgICANCiAgICAgICAgT24gVHVlLCBKdW4g
MDQsIDIwMTkgYXQgMDg6MzA6NTdQTSArMDAwMCwgQWxpIFNhaWRpIHdyb3RlOg0KICAgICAgICA+
IEFXUyBHcmF2aXRvbiBiYXNlZCBzeXN0ZW1zIHByb3ZpZGUgYW4gQXJtIFNNQyBjYWxsIGluIHRo
ZSB2ZW5kb3IgZGVmaW5lZA0KICAgICAgICA+IGh5cGVydmlzb3IgcmVnaW9uIHRvIHJlYWQgcmFu
ZG9tIG51bWJlcnMgZnJvbSBhIEhXIFRSTkcgYW5kIHJldHVybiB0aGVtIHRvIHRoZQ0KICAgICAg
ICA+IGd1ZXN0LiANCiAgICAgICAgPiANCiAgICAgICAgPiBXZSd2ZSBvYnNlcnZlZCBzbG93ZXIg
Z3Vlc3QgYm9vdCBhbmQgZXNwZWNpYWxseSByZWJvb3QgdGltZXMgZHVlIHRvIGxhY2sgb2YNCiAg
ICAgICAgPiBlbnRyb3B5IGFuZCBwcm92aWRpbmcgYWNjZXNzIHRvIGEgVFJORyBpcyBtZWFudCB0
byBhZGRyZXNzIHRoaXMuIA0KICAgICAgICANCiAgICAgICAgQ3VyaW91cywgYnV0IHdoeSB0aGlz
IG92ZXIgc29tZXRoaW5nIGxpa2UgdmlydGlvLXJuZz8NCiAgICAgICAgDQogICAgVGhpcyBpbnRl
cmZhY2UgYWxsb3dzIHVzIHRvIHByb3ZpZGUgdGhlIGZ1bmN0aW9uYWxpdHkgZnJvbSBib3RoIEVM
MiBhbmQgRUwzIGFuZCBzdXBwb3J0IG11bHRpcGxlIGRpZmZlcmVudCB0eXBlcyBvZiBvdXIgaW5z
dGFuY2VzIHdoaWNoIHdlIHVuZm9ydHVuYXRlbHkgY2FuJ3QgZG8gd2l0aCB2aXJ0LWlvLg0KICAg
IA0KV2lsbCwNCg0KQW55IGFkZGl0aW9uYWwgY29tbWVudHM/DQoNCk1hcmssDQoNCkRvIHlvdSBr
bm93IHdoZW4geW91J2xsIGhhdmUgYSBjaGFuY2UgdG8gcmViYXNlIGFybTY0L3NtY2NjLWNsZWFu
dXA/DQoNClRoYW5rcywNCkFsaQ0KDQoNCg==
