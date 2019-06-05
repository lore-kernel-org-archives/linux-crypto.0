Return-Path: <SRS0=VkFO=UE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B4DC28D18
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Jun 2019 16:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EA702075C
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Jun 2019 16:07:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="Esh4MHGf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbfFEQHd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Jun 2019 12:07:33 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:32336 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728421AbfFEQHc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Jun 2019 12:07:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559750852; x=1591286852;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Z+5gkqiGLrc1+ckzFfGnbs6e2GkIHGZDRzA+b4QtS/Y=;
  b=Esh4MHGf3yH3oElus5kS42LeZz+r97xBFxa+le2P5GYWVcz0wPTw03Z6
   hLJxruIVRjf2G+mX9S4VucuaQAZL3lgh/8A3lu7QvClozSrWtmCXkPiqm
   RgY5c1EH+KfE+hhGNLHZvi7GWHzKF3/iso2g8lHn8MrdqS4CCM1kpXbOJ
   Y=;
X-IronPort-AV: E=Sophos;i="5.60,550,1549929600"; 
   d="scan'208";a="678327978"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 05 Jun 2019 16:07:26 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 87368241DA6;
        Wed,  5 Jun 2019 16:07:23 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 5 Jun 2019 16:07:22 +0000
Received: from EX13D02UWC004.ant.amazon.com (10.43.162.236) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 5 Jun 2019 16:07:22 +0000
Received: from EX13D02UWC004.ant.amazon.com ([10.43.162.236]) by
 EX13D02UWC004.ant.amazon.com ([10.43.162.236]) with mapi id 15.00.1367.000;
 Wed, 5 Jun 2019 16:07:21 +0000
From:   "Saidi, Ali" <alisaidi@amazon.com>
To:     Mark Rutland <mark.rutland@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Matt Mackall" <mpm@selenic.com>,
        Will Deacon <will.deacon@arm.com>,
        "Rindjunsky, Ron" <ronrindj@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/3] arm64: export acpi_psci_use_hvc
Thread-Topic: [PATCH 2/3] arm64: export acpi_psci_use_hvc
Thread-Index: AQHVGxR9cfXbpWZUwE2BXRlhLfgFYKaMz0WAgAAQPwCAAAgCAA==
Date:   Wed, 5 Jun 2019 16:07:21 +0000
Message-ID: <8C0E3CF9-36FD-439A-8D65-0FC688BD5C80@amazon.com>
References: <20190604203100.15050-1-alisaidi@amazon.com>
 <20190604203100.15050-3-alisaidi@amazon.com>
 <20190605094031.GB28613@e107155-lin>
 <20190605103840.GA30925@lakrids.cambridge.arm.com>
In-Reply-To: <20190605103840.GA30925@lakrids.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.161.148]
Content-Type: text/plain; charset="utf-8"
Content-ID: <11CAE4E330D68C43AF225BE971716552@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCu+7v09uIDYvNS8xOSwgNTo0MCBBTSwgIk1hcmsgUnV0bGFuZCIgPG1hcmsucnV0bGFuZEBh
cm0uY29tPiB3cm90ZToNCg0KICAgIEFsaSwgSSBhc3N1bWUgeW91ciBmaXJtd2FyZSBoYXMgU01D
Q0N2MS4xKy4gSXMgdGhhdCB0aGUgY2FzZT8NCiAgICANCg0KWWVzLCBpdCBkb2VzLiBJJ20gaGFw
cHkgdG8gYmUgYWJsZSB0byBjYWxsIGEgZ2VuZXJpYyBmdW5jdGlvbiBpbnN0ZWFkIG9mIGhhdmlu
ZyB0byBmaWd1cmUgb3V0IHdoaWNoIGNvbmR1aXQgdG8gdXNlLg0KDQpBbGkNCg0KICAgIA0KDQo=
