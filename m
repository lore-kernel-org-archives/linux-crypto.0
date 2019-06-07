Return-Path: <SRS0=RoO8=UG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99265C2BCA1
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Jun 2019 12:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7344E206BB
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Jun 2019 12:58:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="dwgh7LXl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfFGM6p (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Jun 2019 08:58:45 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:2804 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbfFGM6o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jun 2019 08:58:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559912323; x=1591448323;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yYhblt2+BKiN/5PsebElSxKpyf/1YoPFs0dVvX2+Xww=;
  b=dwgh7LXlGIW2pHbCG1lI5YGA8fyFPKS7VEYqJHmWR1OaolaEMpR6oySw
   i2EifWlnQnYqucbul/iywEBm6rbmEOxjJ2+RVEjKSTj+ND4+QvJR0KcY0
   MINtozzpf0u4kCSXrq4qxjdxUmRSAa2xmx6aWkBF/UEY/htrbezC8aB2O
   g=;
X-IronPort-AV: E=Sophos;i="5.60,563,1549929600"; 
   d="scan'208";a="804170433"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2a-c5104f52.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 07 Jun 2019 12:58:37 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-c5104f52.us-west-2.amazon.com (Postfix) with ESMTPS id 45E57A242C;
        Fri,  7 Jun 2019 12:58:37 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 7 Jun 2019 12:58:36 +0000
Received: from EX13D02UWC004.ant.amazon.com (10.43.162.236) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 7 Jun 2019 12:58:36 +0000
Received: from EX13D02UWC004.ant.amazon.com ([10.43.162.236]) by
 EX13D02UWC004.ant.amazon.com ([10.43.162.236]) with mapi id 15.00.1367.000;
 Fri, 7 Jun 2019 12:58:35 +0000
From:   "Saidi, Ali" <alisaidi@amazon.com>
To:     Will Deacon <will.deacon@arm.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rindjunsky, Ron" <ronrindj@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>
Subject: Re: [PATCH 0/3] Add support for Graviton TRNG
Thread-Topic: [PATCH 0/3] Add support for Graviton TRNG
Thread-Index: AQHVGxR9rewpsnhufE+Qj7iDYwflKaaM+/mAgALbeQA=
Date:   Fri, 7 Jun 2019 12:58:35 +0000
Message-ID: <7EC45708-38A1-4826-BC82-298EFAAE30B1@amazon.com>
References: <20190604203100.15050-1-alisaidi@amazon.com>
 <20190605122031.GK15030@fuggles.cambridge.arm.com>
In-Reply-To: <20190605122031.GK15030@fuggles.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.161.225]
Content-Type: text/plain; charset="utf-8"
Content-ID: <597B470E461AD641A6B2C366CC0A0DD8@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCu+7v09uIDYvNS8xOSwgNzoyMCBBTSwgIldpbGwgRGVhY29uIiA8d2lsbC5kZWFjb25AYXJt
LmNvbT4gd3JvdGU6DQoNCiAgICBPbiBUdWUsIEp1biAwNCwgMjAxOSBhdCAwODozMDo1N1BNICsw
MDAwLCBBbGkgU2FpZGkgd3JvdGU6DQogICAgPiBBV1MgR3Jhdml0b24gYmFzZWQgc3lzdGVtcyBw
cm92aWRlIGFuIEFybSBTTUMgY2FsbCBpbiB0aGUgdmVuZG9yIGRlZmluZWQNCiAgICA+IGh5cGVy
dmlzb3IgcmVnaW9uIHRvIHJlYWQgcmFuZG9tIG51bWJlcnMgZnJvbSBhIEhXIFRSTkcgYW5kIHJl
dHVybiB0aGVtIHRvIHRoZQ0KICAgID4gZ3Vlc3QuIA0KICAgID4gDQogICAgPiBXZSd2ZSBvYnNl
cnZlZCBzbG93ZXIgZ3Vlc3QgYm9vdCBhbmQgZXNwZWNpYWxseSByZWJvb3QgdGltZXMgZHVlIHRv
IGxhY2sgb2YNCiAgICA+IGVudHJvcHkgYW5kIHByb3ZpZGluZyBhY2Nlc3MgdG8gYSBUUk5HIGlz
IG1lYW50IHRvIGFkZHJlc3MgdGhpcy4gDQogICAgDQogICAgQ3VyaW91cywgYnV0IHdoeSB0aGlz
IG92ZXIgc29tZXRoaW5nIGxpa2UgdmlydGlvLXJuZz8NCiAgICANClRoaXMgaW50ZXJmYWNlIGFs
bG93cyB1cyB0byBwcm92aWRlIHRoZSBmdW5jdGlvbmFsaXR5IGZyb20gYm90aCBFTDIgYW5kIEVM
MyBhbmQgc3VwcG9ydCBtdWx0aXBsZSBkaWZmZXJlbnQgdHlwZXMgb2Ygb3VyIGluc3RhbmNlcyB3
aGljaCB3ZSB1bmZvcnR1bmF0ZWx5IGNhbid0IGRvIHdpdGggdmlydC1pby4NCg0KQWxpDQogICAg
DQoNCg==
