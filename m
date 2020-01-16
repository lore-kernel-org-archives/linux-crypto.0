Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B77C33CB1
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 13:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34404214AF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 13:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgAPNye (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 08:54:34 -0500
Received: from mail1.bemta26.messagelabs.com ([85.158.142.114]:41889 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729137AbgAPNy0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 08:54:26 -0500
Received: from [85.158.142.199] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-b.eu-central-1.aws.symcld.net id BC/D0-07000-01B602E5; Thu, 16 Jan 2020 13:54:24 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRWlGSWpSXmKPExsVyU+ECq65AtkK
  cwYnJahb37/1kcmD0+LxJLoAxijUzLym/IoE1o/1VM1tBI1fF/rk3WBsYP3B2MXJxCAnsY5S4
  vHUCK4RzllHi2ult7F2MnBxsAloSM7ZOZQSxRQQcJbqnbmIEKWIW2MUo8W/qOVaQhLCAlUTj5
  jY2iCJ7iXvrl7FC2HoSe/bdYwKxWQRUJTa0TACzeQV0JTquXgKrYRSQlXi08hfYMmYBcYlbT+
  aD1UgICEgs2XOeGcIWlXj5+B8rhG0gsXXpPhYIW1Hi2vwTQAdxANnWEjce8IOYzAKaEut36UN
  MVJSY0v2QHWKroMTJmU9YJjCKzEKybBZCxywkHbOQdCxgZFnFaJlUlJmeUZKbmJmja2hgoGto
  aKxrpmtoaqmXWKWbpJdaqpucmldSlAiU1UssL9YrrsxNzknRy0st2cQIjJqUQrb5Oxjn/3ynd
  4hRkoNJSZRXZI9snBBfUn5KZUZicUZ8UWlOavEhRhkODiUJ3mdpCnFCgkWp6akVaZk5wAiGSU
  tw8CiJ8L7IAErzFhck5hZnpkOkTjEac0x4OXcRM8eRuUsXMQux5OXnpUqJ83JmApUKgJRmlOb
  BDYIllkuMslLCvIwMDAxCPAWpRbmZJajyrxjFORiVhHkFQKbwZOaVwO17BXQKE9ApE5zlQE4p
  SURISTUw9XdWfeXJVWSx6rflEIk4yDPva19vx437nX0m8XzKN+1+J68qcmPa6GLkwcF2xXLr2
  WOtRapp/43sd7E4Rm76efBcQFC+vO77t6YOqkc1/y3zXmCw613hnyrt5osc55oTT/Zdmr/79u
  Plm2pdLXWi5vmcFAq4os+4RON0e8mMVMuLEbpnZDOm/+bc8vH3kcmrT2nKc+hfrfxc1zE7eo2
  XnkNnlHeolJPedRvmRWWHD0/1b0rriPQIPH0t9MadO3bM/ovyWhy/7rB5KH0w6MW7VQt+rpy1
  +OIb7uifUlbMM06sm3JK5kUhRzV/q/je/vRm9fefw5cYWnvb2ZTeXV+tlcg4Perp1DUmPLZ/g
  6SVWIozEg21mIuKEwGhl6c8pwMAAA==
X-Env-Sender: david.kim@ncipher.com
X-Msg-Ref: server-20.tower-244.messagelabs.com!1579182864!34681!2
X-Originating-IP: [217.32.208.5]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.44.25; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 28004 invoked from network); 16 Jan 2020 13:54:24 -0000
Received: from unknown (HELO exukdagfar02.INTERNAL.ROOT.TES) (217.32.208.5)
  by server-20.tower-244.messagelabs.com with ECDHE-RSA-AES256-SHA384 encrypted SMTP; 16 Jan 2020 13:54:24 -0000
Received: from exukdagfar01.INTERNAL.ROOT.TES (10.194.2.70) by
 exukdagfar02.INTERNAL.ROOT.TES (10.194.2.71) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 16 Jan 2020 13:54:23 +0000
Received: from exukdagfar01.INTERNAL.ROOT.TES ([fe80::48de:aa33:fc4c:d1f5]) by
 exukdagfar01.INTERNAL.ROOT.TES ([fe80::48de:aa33:fc4c:d1f5%14]) with mapi id
 15.00.1497.000; Thu, 16 Jan 2020 13:54:23 +0000
From:   "Kim, David" <david.kim@ncipher.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Magee, Tim" <tim.magee@ncipher.com>
Subject: Feedback request on nCipher HSM driver submission
Thread-Topic: Feedback request on nCipher HSM driver submission
Thread-Index: AQHVzHNLGhaTD/19VkW+gxijFp3LlA==
Date:   Thu, 16 Jan 2020 13:54:23 +0000
Message-ID: <1579182863430.79006@ncipher.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.23.136.54]
x-exclaimer-md-config: 7ae4f661-56ee-4cc7-9363-621ce9eeb65f
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgRGF2aWQgYW5kIEhlcmJlcnQsDQoNCkFwb2xvZ2llcyBmb3IgdGhlIHByZXZpb3VzIGF0dGVt
cHRzIGF0IHNlbmRpbmcgdGhpcy4gSSBiZWVuIHN0cnVnZ2xpbmcgd2l0aCBvdXRsb29rDQpzZXR0
aW5ncyBhbmQgdGhlIG1haWxpbmcgbGlzdCBidXQgaG9wZWZ1bGx5IHRoaXMgdGltZSBJJ20gc3Vj
Y2Vzc2Z1bCBhdCBnZXR0aW5nIHRoaXMgb250bw0KdGhlIGNyeXB0byBsaXN0Lg0KDQpXZSBhcmUg
dHJ5aW5nIHRvIHVwc3RyZWFtIG91ciBIU00gZHJpdmVyIGludG8gZHJpdmVycy9taXNjIGFuZCBH
cmVnIEtIIGhhcw0KcmVxdWVzdGVkIHRoYXQgd2UgY29udGFjdCB5b3UgZm9yIHlvdXIgYXBwcm92
YWwgYmVmb3JlIGhlIGNhbiBtYWtlIGEgZGVjaXNpb24NCm9uIG91ciBjb2RlLg0KDQpXZSBhcmUg
Y3VycmVudGx5IGF0IHBhdGNoIHYyIGFuZCB0aGUgc3VibWlzc2lvbiBlbWFpbCBpcyBoZXJlOg0K
aHR0cHM6Ly9tYXJjLmluZm8vP2w9bGludXgta2VybmVsJm09MTU3Njg1Njg5NjI1OTg3Jnc9Mg0K
DQpHcmVnIGhhZCByYWlzZWQgYSBjb3VwbGUgaW5pdGlhbCBjb21tZW50cyBhbmQgd2UgYWRkcmVz
c2VkIHRoZW0gaW4gdGhlc2UgZW1haWxzOg0KaHR0cHM6Ly9tYXJjLmluZm8vP2w9bGludXgta2Vy
bmVsJm09MTU3ODM4NzA2MDA2ODE3Jnc9Mg0KaHR0cHM6Ly9tYXJjLmluZm8vP2w9bGludXgta2Vy
bmVsJm09MTU3ODU2MTg0MzI0MzM5Jnc9Mg0KDQpJIHdvdWxkIGJlIGdyYXRlZnVsIGZvciB5b3Vy
IGlucHV0IGFuZCB0aGFuayB5b3UgaW4gYWR2YW5jZSBmb3IgeW91ciBoZWxwLg0KDQpSZWdhcmRz
LA0KRGF2ZQ0KDQoNCkRhdmlkIEtpbQ0KU2VuaW9yIFNvZnR3YXJlIEVuZ2luZWVyDQpUZWw6ICs0
NCAxMjIzIDcwMzQ0OQ0KDQpuQ2lwaGVyIFNlY3VyaXR5DQpPbmUgU3RhdGlvbiBTcXVhcmUNCkNh
bWJyaWRnZSBDQjEgMkdBDQpVbml0ZWQgS2luZ2RvbQ0KDQo=
