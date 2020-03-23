Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2496CC4332B
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 13:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADFA620735
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 13:32:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbgCWNcL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 09:32:11 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.66]:47835 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728355AbgCWNcK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 09:32:10 -0400
Received: from [100.112.198.122] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-b.eu-west-1.aws.symcld.net id 4E/C6-43335-85AB87E5; Mon, 23 Mar 2020 13:32:08 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRWlGSWpSXmKPExsVyU+ECq274roo
  4g63PrSzu3/vJ5MDo8XmTXABjFGtmXlJ+RQJrxsu+pILjqhVTVi5ibGDsUO1i5OIQEtjHKHF+
  7U92COcso8TPrlOMXYycHGwCWhIztk4Fs0UEAiU6Nz9gAiliFvjMKHH/6CRWkISwgJPEkQ+f2
  CCKnCU6fu9hhrCtJE48WQJWwyKgKtF3ZSfYIF4BX4kXT9rA4kIC8RJT9v5nAbE5BWwlvrycAF
  bDKCAr8WjlL3YQm1lAXOLWk/lMILaEgIDEkj3nmSFsUYmXj/+xQtgGEluX7mOBsBUllp3eCtT
  LAWRbS9x4wA9iMgtoSqzfpQ8xUVFiSvdDdohrBCVOznzCMoFRbBaSZbMQOmYh6ZiFpGMBI8sq
  Roukosz0jJLcxMwcXUMDA11DQyNdQ0szXUNjc73EKt0kvdRS3fLU4hJdQ73E8mK94src5JwUv
  bzUkk2MwAhLKTjSuYPx95r3eocYJTmYlER5g3ZUxAnxJeWnVGYkFmfEF5XmpBYfYpTh4FCS4I
  3fCZQTLEpNT61Iy8wBRjtMWoKDR0mElw2klbe4IDG3ODMdInWK0Z5jwsu5i5g5dh6dByQPgsk
  jc5cuYhZiycvPS5US570J0iYA0pZRmgc3FJacLjHKSgnzMjIwMAjxFKQW5WaWoMq/YhTnYFQS
  5lUBmcKTmVcCt/sV0FlMQGelzyoHOaskESEl1cA0ZWfL6xNOVxVOplZJnT4gvG4W83SFqSIX9
  mzR35KXezbCp2mVUJ9uEH+7j+Wjm8feHflzqfzEphXbwn4sTl6+Z6mH1/UpX5mftD1MmfBEpD
  Zpm8e93VnhocWPX1k8+Mzo5td+QratbMKeu4fqGoyYb6+zqZbdsd1yz+X9h8zq5SaJZ4nbfLz
  +wfllxJGLygc0PKe/Wu947uiqR8IFSXtXvLxu3xzFnj//aOujbRnsa9fZvb9zaGfCTt6yic5u
  QVzbZmTt/m691EJTTI1hXmn57xi+nXW3qqJX/l574rzw7q/CZfnxZw4UhN7a2i2ubODZuu3R1
  kUfL5/UP9G6ZxK7XynbvEql5R5Le6O3dnPHvVJiKc5INNRiLipOBAAbOrHRyQMAAA==
X-Env-Sender: david.kim@ncipher.com
X-Msg-Ref: server-4.tower-284.messagelabs.com!1584970327!1994402!2
X-Originating-IP: [217.32.208.5]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 15151 invoked from network); 23 Mar 2020 13:32:07 -0000
Received: from unknown (HELO exukdagfar02.INTERNAL.ROOT.TES) (217.32.208.5)
  by server-4.tower-284.messagelabs.com with ECDHE-RSA-AES256-SHA384 encrypted SMTP; 23 Mar 2020 13:32:07 -0000
Received: from exukdagfar01.INTERNAL.ROOT.TES (10.194.2.70) by
 exukdagfar02.INTERNAL.ROOT.TES (10.194.2.71) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 23 Mar 2020 13:32:07 +0000
Received: from exukdagfar01.INTERNAL.ROOT.TES ([fe80::695f:f3db:5a02:b9d7]) by
 exukdagfar01.INTERNAL.ROOT.TES ([fe80::695f:f3db:5a02:b9d7%14]) with mapi id
 15.00.1497.000; Mon, 23 Mar 2020 13:32:07 +0000
From:   "Kim, David" <david.kim@ncipher.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Magee, Tim" <tim.magee@ncipher.com>, Arnd Bergmann <arnd@arndb.de>
Subject: RE: nCipher HSM kernel driver submission feedback request
Thread-Topic: nCipher HSM kernel driver submission feedback request
Thread-Index: AQHV+Rp4QokDxpwiMEuvFqQ47k+kiqhVzFKAgAA4hcA=
Date:   Mon, 23 Mar 2020 13:32:06 +0000
Message-ID: <c34d5419ad38444d951f7cbb29b5c7ae@exukdagfar01.INTERNAL.ROOT.TES>
References: <1584092894266.92323@ncipher.com>
 <9644fcdd-1453-616a-f607-4a1f39f433ff@zx2c4.com>
In-Reply-To: <9644fcdd-1453-616a-f607-4a1f39f433ff@zx2c4.com>
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

SGkgSmFzb24sDQoNClRoYW5rcyBmb3IgeW91ciByZXBseSBhbmQgaGVscGZ1bCBzdW1tYXJ5IG9m
IHRoZSBjdXJyZW50IGRpc2N1c3Npb24uDQoNCj4NCj4gSXQgbG9va3MgbGlrZSB0aGlzIGlzIHNv
bWUgc29ydCBvZiBQQ0llIEhTTSBkZXZpY2UuIEFzIGZhciBhcyBJIGtub3csIExpbnV4DQo+IGRv
ZXNuJ3QgaGF2ZSBhIHN0YW5kYXJkaXplZCBBUEkgZm9yIEhTTSBkZXZpY2VzIChzb21lYm9keSBj
b3JyZWN0IG1lIGlmDQo+IEknbSB3cm9uZyksIGFuZCBwcm9iYWJseSB0aGF0IGRvZXNuJ3QgcXVp
dGUgbWFrZSBzZW5zZSwgZWl0aGVyLCBzZWVpbmcgYXMNCj4gbW9zdCBIU01zIGFyZSBhY2Nlc3Nl
ZCBhbnl3YXkgdGhyb3VnaCB1c2Vyc3BhY2UgImRyaXZlcnMiIC0tIHRoYXQgaXMsIHZpYQ0KPiBs
aWJ1c2Igb3Igb3ZlciBzb21lIG5ldHdvcmtpbmcgcHJvdG9jb2wsIG9yIHNvbWV0aGluZyBlbHNl
Lg0KPiBZb3VyIHNpdHVhdGlvbiBpcyBkaWZmZXJlbnQgaW4gdGhhdCBpdCB1c2VzIFBDSWUsIHNv
IHlvdSBuZWVkIHNvbWUga2VybmVsDQo+IG1lZGlhdGlvbiBpbiBvcmRlciB0byBnaXZlIGFjY2Vz
cyB0byB5b3VyIHVzZXJzcGFjZSBjb21wb25lbnRzLg0KPiBBbmQsIGRpZmZlcmVudCBtYW51ZmFj
dHVyZXJzJyBIU01zIGV4cG9zZSB2ZXJ5IGRpZmZlcmVudCBwaWVjZXMgb2YNCj4gZnVuY3Rpb25h
bGl0eSwgYW5kIEknbSBub3Qgc3VyZSBhIHVuaWZpZWQgQVBJIGZvciB0aGVtIHdvdWxkIGV2ZW4g
bWFrZQ0KPiBzZW5zZS4NCg0KWWVzLCB0aGF0J3MgY29ycmVjdC4gVGhlcmUgYXJlIGN1cnJlbnRs
eSBubyBzdGFuZGFyZGlzZWQgQVBJcyBmb3IgSFNNIGRldmljZXMgaW4NCkxpbnV4IGFuZCBvdXIg
UENJZSBkZXZpY2UgbmVlZHMgdGhlIGtlcm5lbCB0byBmYWNpbGl0YXRlIG9wZXJhdGlvbi4NCg0K
Pg0KPiBJdCBsb29rcyBsaWtlIHRoaXMgZHJpdmVyIGV4cG9zZXMgc29tZSBkZXZpY2UgZmlsZSwg
d2l0aCBhIGZldyBJT0NUTHMgYW5kIHRoZW4NCj4gc3VwcG9ydCBmb3IgcmVhZGluZyBhbmQgd3Jp
dGluZyBmcm9tIGFuZCB0byB0aGUgZGV2aWNlLiBCZXNpZGVzIHNvbWUgZHJpdmVyDQo+IGNvbnRy
b2wgdGhpbmdzLCB3aGF0IGFjdHVhbGx5IGdvZXMgaW50byB0aGUgZGV2aWNlIC0tIHRoYXQgaXMs
IHRoZSBwcm90b2NvbCBvbmUNCj4gbXVzdCB1c2UgdG8gdGFsayB0byB0aGUgdGhpbmcgLS0gaXNu
J3QgYWN0dWFsbHkgZGVzY3JpYmVkIGJ5IHRoZSBkcml2ZXIuIFlvdSdyZQ0KPiBqdXN0IHNodWZm
bGluZyBieXRlcyBpbiBhbmQgb3V0IHdpdGggc29tZSBtZWRpYXRpb24gYXJvdW5kIHRoYXQuDQo+
DQo+IENhbiB5b3UgY29uZmlybSB0byBtZSB3aGV0aGVyIG9yIG5vdCB0aGUgYWJvdmUgaXMgYWNj
dXJhdGU/DQoNClllcywgdGhpcyBpcyBhY2N1cmF0ZS4NCg0KPg0KPiBJZiBzbywgdGhlbiBJJ20g
bm90IHN1cmUgdGhpcyBiZWxvbmdzIGluIHRoZSBwdXJ2aWV3IG9mIHRoZSBjcnlwdG8gbGlzdCBv
ciBoYXMNCj4gYW55dGhpbmcgbXVjaCB0byBkbyB3aXRoIExpbnV4IGNyeXB0by4gVGhpcyBpcyBh
IFBDSWUgZHJpdmVyIGZvciBzb21lDQo+IGhhcmR3YXJlIHRoYXQgdXNlcnNwYWNlIGhhcyB0byB0
YWxrIHRvIGluIG9yZGVyIHRvIGRvIHNvbWUgc3R1ZmYgd2l0aCBpdC4NCg0KQWdhaW4sIHlvdSBh
cmUgY29ycmVjdC4gQWx0aG91Z2ggaXQgaXMgY3J5cHRvZ3JhcGhpYyBoYXJkd2FyZSwgdGhlIGRy
aXZlciBjb2RlDQpkb2VzIG5vdCBkbyBhbnl0aGluZyBjcnlwdG9ncmFwaGljLiBJdCBpcyBqdXN0
IGEgUENJZSBkcml2ZXIuDQoNCj4NCj4gSG93ZXZlciwgdGhlcmUncyBzb21ldGhpbmcgZWxzZSB0
aGF0IHlvdSB3cm90ZSB0aGF0IG1pZ2h0IG1ha2UgcGVvcGxlDQo+IGxlc3MgaW5jbGluZWQgdG8g
bWVyZ2UgdGhpczoNCj4NCj4gID4gT3VyIGRyaXZlciBjb2RlIGlzIGp1c3QgYSB0dWJlIGJldHdl
ZW4gcHJvcHJpZXRhcnkgY29kZSBvbiB0aGUgaG9zdA0KPiBtYWNoaW5lIGFuZCBwcm9wcmlldGFy
eSBjb2RlIG9uIHRoZSBIU00uDQo+DQo+IEl0IHNvdW5kcyBsaWtlIHlvdSBuZWVkIHRoZSBrZXJu
ZWwgdG8gZXhwb3NlIHlvdXIgUENJZSBkZXZpY2UgaW4gYSB3YXkNCj4gdXNlcnNwYWNlIGNhbiBh
Y2Nlc3MsIHNvIHRoYXQgeW91IGNhbiB0YWxrIHRvIGl0IHVzaW5nIHByb3ByaWV0YXJ5IGNvZGUu
DQo+IEluIG90aGVyIHdvcmRzLCB0aGlzIGlzIGEga2VybmVsIGRyaXZlciB0aGF0IGV4aXN0cyBv
bmx5IHRvIHN1cHBvcnQgY2xvc2VkIHNvdXJjZQ0KPiBjb21wb25lbnRzLiBJIGhhdmUgbm8gaWRl
YSBhYm91dCAib2ZmaWNpYWwgcG9saWN5IiBvbiB0aGlzIG1hdHRlciwgYnV0IEkgY291bGQNCj4g
aW1hZ2luZSBzb21lIHBlb3BsZSBob3dsaW5nIGFib3V0IGl0LiBPbiB0aGUgb3RoZXIgaGFuZCwg
dGhlIGRyaXZlciBfaXNfDQo+IGRvaW5nIHNvbWV0aGluZywgYW5kIGl0IHNlZW1zIGxpa2UgeW91
ciBoYXJkd2FyZSBpcyBzb21ld2hhdCBjb21wbGljYXRlZA0KPiB0byBpbnRlcmZhY2Ugd2l0aCwg
YW5kIHdobyB3b3VsZG4ndCB3YW50IGFuIG9wZW4gc291cmNlIGRyaXZlciBmb3IgdGhhdCwNCj4g
ZXZlbiBpZiBpdCdzIGp1c3QgdGhlIGxvdy1sZXZlbCBrZXJuZWwvUENJZSBjb21wb25lbnRzPw0K
DQpZZXMsIHdlIGV4cGVjdCB0aGVyZSB0byBiZSBzb21lIGRpc2N1c3Npb24gYWJvdXQgdGhlIGRy
aXZlciBiZWluZyB1c2VmdWwgaW4gdGhlDQprZXJuZWwgYnV0IG5lZWQgdG8gcmVzb2x2ZSB0aGlz
IGRpc2N1c3Npb24gcmVnYXJkaW5nIHRoZSBMaW51eCBjcnlwdG8gQVBJIGZpcnN0Lg0KDQo+DQo+
IEFueXdheSwgaWYgbXkgc3VwcG9zaXRpb25zIGFib3ZlIGFyZSBpbmRlZWQgY29ycmVjdCwgSSdk
IGVuY291cmFnZSB5b3UgdG8NCj4gc3VibWl0IHlvdXIgZHJpdmVyIHRvIHdob2V2ZXIgbWFpbnRh
aW5zIGRyaXZlcnMvbWlzYy8gKEdyZWcgYW5kIEFybmQsIElJUkMpLA0KPiBhbmQgaWdub3JlIHRo
ZSBmYWN0IHRoYXQgeW91ciBoYXJkd2FyZSBoYXMgc29tZXRoaW5nIHRvIGRvIHdpdGgNCj4gY3J5
cHRvZ3JhcGh5ICh0aG91Z2ggbGl0dGxlIHRvIGRvIHdpdGggdGhlIExpbnV4IGNyeXB0byBBUEkn
cyByYW5nZSBvZg0KPiByZXNwb25zaWJpbGl0aWVzKS4NCg0KWWVzLCB3ZSBzdWJtaXR0ZWQgb3Vy
IGRyaXZlciBjb2RlIHRvIEdyZWcgYW5kIGRyaXZlcnMvbWlzYyBidXQgaGUgcmVxdWVzdGVkDQpm
ZWVkYmFjayBmcm9tIHRoZSBjcnlwdG8gbWFpbnRhaW5lcnMgcmVnYXJkaW5nIHBvdGVudGlhbCBj
aGFuZ2VzIHRvIHRoZSBMaW51eA0KY3J5cHRvIEFQSS4gV2UgZG8gbm90IGludGVuZCB0byB0YXJn
ZXQgb3VyIGRyaXZlciBzdWJtaXNzaW9uIHRvIGRyaXZlcnMvY3J5cHRvIGFuZA0KYXJlbid0IHVz
aW5nIGFueSBvZiB0aGUgTGludXggY3J5cHRvIEFQSXMuDQoNClJlZ2FyZHMsDQpEYXZlDQoNCg0K
RGF2aWQgS2ltDQpTZW5pb3IgU29mdHdhcmUgRW5naW5lZXINClRlbDogKzQ0IDEyMjMgNzAzNDQ5
DQoNCm5DaXBoZXIgU2VjdXJpdHkNCk9uZSBTdGF0aW9uIFNxdWFyZQ0KQ2FtYnJpZGdlIENCMSAy
R0ENClVuaXRlZCBLaW5nZG9tDQoNCg==
