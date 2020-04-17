Return-Path: <SRS0=6qCq=6B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB864C2D0EF
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Apr 2020 15:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAD922223D
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Apr 2020 15:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbgDQPMK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Apr 2020 11:12:10 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.3]:57136 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728272AbgDQPMJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Apr 2020 11:12:09 -0400
Received: from [100.112.192.244] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-a.eu-west-1.aws.symcld.net id 42/39-36773-547C99E5; Fri, 17 Apr 2020 15:12:05 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRWlGSWpSXmKPExsVyU+ECq67z8Zl
  xBmuu61rcv/eTyYHR4/MmuQDGKNbMvKT8igTWjJ2NxxkLDvJVHHxwjq2BcQVfFyMXh5DAPkaJ
  z/e/s0A4Zxkl1p47xdTFyMnBJqAlMWPrVEYQW0RAQ+Ll0VtARRwczAIZEr/X1oKEhQWcJI58+
  MQGUeIs0fF7DzOE7SZxd858VhCbRUBV4vfyl+wgNq+Ar8TNrhlMELuOMkp8XbeNBSTBKaAnMW
  3yRLC9jAKyEo9W/gJrYBYQl7j1ZD5YXEJAQGLJnvPMELaoxMvH/1ghbAOJrUv3sUDYihLLTm9
  lB7lTQsBa4sYDfoiTNSXW79KHmKgoMaX7IdQ5ghInZz5hmcAoNgvJslkIHbOQdMxC0rGAkWUV
  o0VSUWZ6RkluYmaOrqGBga6hoZGuoaWxrqGZmV5ilW6iXmqpbnlqcYmuoV5iebFecWVuck6KX
  l5qySZGYISlFBxctoNx1dr3eocYJTmYlER5K2bPjBPiS8pPqcxILM6ILyrNSS0+xCjDwaEkwb
  vnKFBOsCg1PbUiLTMHGO0waQkOHiURXp1jQGne4oLE3OLMdIjUKUZ7jgkv5y5i5th5dB6QPAg
  mj8xduohZiCUvPy9VSpx3PchUAZC2jNI8uKGw5HSJUVZKmJeRgYFBiKcgtSg3swRV/hWjOAej
  kjDvIZApPJl5JXC7XwGdxQR0VrTDdJCzShIRUlINTIzbzxeuOP1keVry1uj43yEdeXbTmdIMj
  ho9PxNnI/z2nyWLlvHDe0HJx7KlewP2TmRpb/mSz7Mk70Dzzd7AZOUVsnpiIQIXfa5q7lZq9a
  m/c6CcW1rtZJ166XXZRxlfLV6az/lafeKxU6NfpVL4tduHFq956bU18lyRXeaXGwn7a++r97h
  XHTogJhmseOynKjvju4dOG2vdJlxU3Fov/YTre8104fYqB3ezpmn/rjfErtVg8NEK1r8YfOJI
  xbJz+86E3syO2h3768qcJedFMj9dntfg+2/ahi9RS1QFus7PSOd4c/pVX5ej2tHIP4ymm1dVv
  HasP3tzNreZiLsf8xrpbCbl3Vrf68xXqa1NUWIpzkg01GIuKk4EAClsGyPJAwAA
X-Env-Sender: david.kim@ncipher.com
X-Msg-Ref: server-2.tower-264.messagelabs.com!1587136323!2628750!1
X-Originating-IP: [217.32.208.5]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 21570 invoked from network); 17 Apr 2020 15:12:03 -0000
Received: from unknown (HELO exukdagfar02.INTERNAL.ROOT.TES) (217.32.208.5)
  by server-2.tower-264.messagelabs.com with ECDHE-RSA-AES256-SHA384 encrypted SMTP; 17 Apr 2020 15:12:03 -0000
Received: from exukdagfar01.INTERNAL.ROOT.TES (10.194.2.70) by
 exukdagfar02.INTERNAL.ROOT.TES (10.194.2.71) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 17 Apr 2020 16:12:03 +0100
Received: from exukdagfar01.INTERNAL.ROOT.TES ([fe80::695f:f3db:5a02:b9d7]) by
 exukdagfar01.INTERNAL.ROOT.TES ([fe80::695f:f3db:5a02:b9d7%14]) with mapi id
 15.00.1497.000; Fri, 17 Apr 2020 16:12:03 +0100
From:   "Kim, David" <david.kim@ncipher.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Magee, Tim" <tim.magee@ncipher.com>
Subject: RE: nCipher HSM kernel driver submission feedback request
Thread-Topic: nCipher HSM kernel driver submission feedback request
Thread-Index: AQHV+Rp4QokDxpwiMEuvFqQ47k+kiqhVzFKAgAA4hcCAAD94AIAnSF/w
Date:   Fri, 17 Apr 2020 15:12:02 +0000
Message-ID: <3b28c21fb1ea4fa7802807bc40da99e4@exukdagfar01.INTERNAL.ROOT.TES>
References: <1584092894266.92323@ncipher.com>
 <9644fcdd-1453-616a-f607-4a1f39f433ff@zx2c4.com>
 <c34d5419ad38444d951f7cbb29b5c7ae@exukdagfar01.INTERNAL.ROOT.TES>
 <20200323135924.GA7768@kroah.com>
In-Reply-To: <20200323135924.GA7768@kroah.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.23.136.79]
x-exclaimer-md-config: 7ae4f661-56ee-4cc7-9363-621ce9eeb65f
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiA+IEFnYWluLCB5b3UgYXJlIGNvcnJlY3QuIEFsdGhvdWdoIGl0IGlzIGNyeXB0b2dyYXBoaWMg
aGFyZHdhcmUsIHRoZQ0KPiA+IGRyaXZlciBjb2RlIGRvZXMgbm90IGRvIGFueXRoaW5nIGNyeXB0
b2dyYXBoaWMuIEl0IGlzIGp1c3QgYSBQQ0llIGRyaXZlci4NCj4NCj4gSWYgdGhpcyBpcyAianVz
dCIgYSBQQ0llIGRyaXZlciwgY2FuIHlvdSB1c2UgdGhlIFVJTyBpbnRlcmZhY2UgYW5kIGp1c3Qg
dGFsayB0bw0KPiB5b3VyIGhhcmR3YXJlIGRpcmVjdGx5IGZyb20gdXNlcnNwYWNlIHdpdGhvdXQg
YW55IGtlcm5lbCBkcml2ZXIgbmVlZGVkPw0KPg0KPiBXaGF0IGV4YWN0bHkgZG9lcyB0aGUga2Vy
bmVsIGRyaXZlciBuZWVkIHRvIGRvIGhlcmU/DQo+DQoNCkhpIEdyZWcsDQoNCkFwb2xvZ2llcyBm
b3IgdGhlIGRlbGF5IGluIHJlc3BvbnNlIGJ1dCB0aGluZ3MgdG9vayBhIGxpdHRsZSBiaXQgdG8g
Z2V0IHRvIHNvbWUNCmtpbmQgb2YgbmV3IG5vcm1hbC4gSG9wZSB0aGluZ3MgYXJlIHdlbGwgZm9y
IHlvdS4NCg0KV2Ugd291bGQgbmVlZCB0byByZS13cml0ZSBvdXIgZHJpdmVyIGNvZGUgaW4gb3Jk
ZXIgdG8gdXNlIHRoZSBVSU8gaW50ZXJmYWNlDQphbmQgYWNjZXNzIHRoZSBoYXJkd2FyZSBkaXJl
Y3RseSBmcm9tIHVzZXJzcGFjZS4gIEJlc2lkZXMgdGhlIGFjdHVhbCB3b3JrDQppbnZvbHZlZCwg
dGhpcyB3b3VsZCBhZGQgZXh0cmEgY29tcGxleGl0eSB0byBvdXIgY29kZSBiYXNlIGFzIHdlIHN1
cHBvcnQNCm90aGVyIG9wZXJhdGluZyBzeXN0ZW1zLCB3aGljaCB3ZSB3b3VsZCBub3QgYmUgcmUt
d3JpdGluZyBvdXIgZHJpdmVycyBmb3IuDQpUaGVyZWZvcmUsIHdyaXRpbmcgYSB1c2Vyc3BhY2Ug
ZHJpdmVyIGlzIG5vdCBzb21ldGhpbmcgd2UgYXJlIHBsYW5uaW5nIHRvIGRvDQphdCB0aGlzIHRp
bWUuDQoNCldlIGhhdmUgd29ya2VkIHRocm91Z2ggYWxsIHRoZSBzdWJtaXNzaW9uIGd1aWRlcyBh
bmQgaGF2ZSBtYWRlIG91ciBleGlzdGluZw0KZHJpdmVyICdzdWJtaXNzaW9uIHJlYWR5JyBhcyBi
ZXN0IHdlIGNhbi4gVGhpcyBpcyB0aGUgY29kZSB3ZSB3b3VsZCBsaWtlIHRvIGJlDQpjb25zaWRl
cmVkIGZvciB1cHN0cmVhbWluZy4gU2hvdWxkIHdlIG1ha2UgaXQgaW50byB0aGUgbGludXggY29k
ZWJhc2UsIHdlIGFyZQ0KY29tbWl0dGVkIHRvIHByb3ZpZGluZyBsb25nIHRlcm0gY29tbXVuaXR5
IHN1cHBvcnQgZm9yIGl0Lg0KDQpSZWdhcmRzLA0KRGF2ZQ0KDQoNCkRhdmlkIEtpbQ0KU2VuaW9y
IFNvZnR3YXJlIEVuZ2luZWVyDQpUZWw6ICs0NCAxMjIzIDcwMzQ0OQ0KDQpuQ2lwaGVyIFNlY3Vy
aXR5DQpPbmUgU3RhdGlvbiBTcXVhcmUNCkNhbWJyaWRnZSBDQjEgMkdBDQpVbml0ZWQgS2luZ2Rv
bQ0KDQo=
