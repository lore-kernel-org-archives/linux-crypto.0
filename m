Return-Path: <SRS0=DGAQ=5B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D469C0044D
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 10:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A1002051A
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 10:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbgCPKov (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Mar 2020 06:44:51 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.3]:60906 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730478AbgCPKov (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Mar 2020 06:44:51 -0400
Received: from [100.112.192.43] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-a.eu-west-1.aws.symcld.net id A6/F8-44403-0A85F6E5; Mon, 16 Mar 2020 10:44:48 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRWlGSWpSXmKPExsVyU+ECq+6CiPw
  4g3UfhC3u3/vJ5MDo8XmTXABjFGtmXlJ+RQJrxqmzB5kLDvJUrD6l1sC4hqeLkYtDSGAfo8Tk
  X5/YIJyzjBJrfi5n6mLk5GAT0JKYsXUqI4gtIqAh8fLoLRaQImaBK4wSPdsmghUJCzhJHPkA0
  g1S5CzR8XsPcxcjB5BtJbGxOwskzCKgKtH15joLiM0r4CvxsP0RWKuQQLDEztcvwFo5BQwlji
  1eygpiMwrISjxa+YsdxGYWEJe49WQ+WL2EgIDEkj3nmSFsUYmXj/+xQtgGEluX7mOBsBUllp3
  eyg5ygoSAtcSNB/wgJrOApsT6XfoQExUlpnQ/ZIe4RlDi5MwnLBMYxWYhWTYLoWMWko5ZSDoW
  MLKsYjRPKspMzyjJTczM0TU0MNA1NDTSNbQ0BtJ6iVW6iXqppbrlqcUlukBuebFecWVuck6KX
  l5qySZGYHSlFBzk3sH4Yu17vUOMkhxMSqK8Iq75cUJ8SfkplRmJxRnxRaU5qcWHGGU4OJQkeF
  NCgXKCRanpqRVpmTnASIdJS3DwKInwBocBpXmLCxJzizPTIVKnGO05Jrycu4iZY+fReUDyIJg
  8MnfpImYhlrz8vFQpcd6NIG0CIG0ZpXlwQ2GJ6RKjrJQwLyMDA4MQT0FqUW5mCar8K0ZxDkYl
  Yd5DIFN4MvNK4Ha/AjqLCegs993ZIGeVJCKkpBqYtDhXLhc1Y4hYw5W7/l9R4cveGdvUGv5l3
  eQ47TInS0En8VbjuUP2s8oOsRrUfv7U6FxRHHyCddu+eR1dORr8U37kcC8RF3fR3tmm5aQj2m
  vOI6xSKzDvWMqdxzOmXFI6He9+NsVPZSHLkqXxU7bO/Wq2eWYHY8kK36nyId97j57v7nkuZmD
  i+0GaP7KVZ9/+OXZHS3PPzEzctFGt70xAKkP+tZwFvXcNZe5PtShddrF8YvXE18fjVFy/5u8/
  +tjwbL+Rr4m8xsLH37T3zPJ5en3dWWMF+Qupq2KX5Qcvef6h4f4pJdPU5x5nfZK6ilhEtSp2m
  iydupbjh+8+BoedTac2n6jMO3mud2Zum9JnJZbijERDLeai4kQAuzGtZMcDAAA=
X-Env-Sender: david.kim@ncipher.com
X-Msg-Ref: server-23.tower-264.messagelabs.com!1584355487!1992305!2
X-Originating-IP: [217.32.208.5]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 31858 invoked from network); 16 Mar 2020 10:44:48 -0000
Received: from unknown (HELO exukdagfar01.INTERNAL.ROOT.TES) (217.32.208.5)
  by server-23.tower-264.messagelabs.com with ECDHE-RSA-AES256-SHA384 encrypted SMTP; 16 Mar 2020 10:44:48 -0000
Received: from exukdagfar01.INTERNAL.ROOT.TES (10.194.2.70) by
 exukdagfar01.INTERNAL.ROOT.TES (10.194.2.70) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 16 Mar 2020 10:44:47 +0000
Received: from exukdagfar01.INTERNAL.ROOT.TES ([fe80::695f:f3db:5a02:b9d7]) by
 exukdagfar01.INTERNAL.ROOT.TES ([fe80::695f:f3db:5a02:b9d7%14]) with mapi id
 15.00.1497.000; Mon, 16 Mar 2020 10:44:47 +0000
From:   "Kim, David" <david.kim@ncipher.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Magee, Tim" <tim.magee@ncipher.com>
Subject: RE: nCipher HSM kernel driver submission feedback request
Thread-Topic: nCipher HSM kernel driver submission feedback request
Thread-Index: AQHV+Rp4QokDxpwiMEuvFqQ47k+kiqhGTLkAgASroNA=
Date:   Mon, 16 Mar 2020 10:44:46 +0000
Message-ID: <142189d3a42947d4953b22cf7202e327@exukdagfar01.INTERNAL.ROOT.TES>
References: <1584092894266.92323@ncipher.com>
 <20200313100922.GB2161605@kroah.com>
In-Reply-To: <20200313100922.GB2161605@kroah.com>
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

DQo+ID4gVGhlIGRyaXZlciBjb2RlIGZvciB0aGUgaGFyZHdhcmUgaXMgc3RyYWlnaHRmb3J3YXJk
IGFuZCBkb2VzIG5vdA0KPiA+IGNvbnRhaW4gYW55IGNyeXB0b2dyYXBoaWMgY29tcG9uZW50cyBh
cyB0aGUgY3J5cHRvZ3JhcGh5IGlzIGhhbmRsZWQNCj4gPiB3aXRoaW4gdGhlIGhhcmR3YXJlJ3Mg
c2VjdXJlIGJvdW5kYXJ5LiBXZSBoYXZlIG5vIHBsYW5zIHRvIHVzZSB0aGUNCj4gPiBsaW51eCBr
ZXJuZWwgY3J5cHRvIEFQSXMgYXMgb3VyIGN1c3RvbWVycyByZXF1aXJlIGNvbXBsaWFuY2UgdG8g
dGhlIEZJUFMNCj4gMTQwIHN0YW5kYXJkIG9yIHRoZSBlSURBUyByZWd1bGF0aW9ucy4NCj4NCj4g
QnV0IHdoYXQgSSBzYWlkIHdhcywgeW91IE5FRUQgdG8gdXNlIHRoZSBsaW51eCBrZXJuZWwgY3J5
cHRvIGFwaXMgYXMgeW91IG5lZWQNCj4gdG8gbm90IHRyeSB0byBjcmVhdGUgeW91ciBvd24uDQo+
DQo+IEp1c3QgYmVjYXVzZSB0aGlzIGlzIHRoZSB3YXkgeW91IGRpZCBpdCBiZWZvcmUsIGRvZXMg
bm90IG1lYW4gaXQgaXMgdGhlIGNvcnJlY3QNCj4gdGhpbmcgdG8gZG8uDQo+DQo+IFNvIHdoYXQg
aXMgd3JvbmcgaWYgeW91IGRvIHVzZSB0aGUgZXhpc3RpbmcgYXBpcz8gIFdoYXQgaXMgcHJldmVu
dGluZyB5b3UNCj4gZnJvbSBkb2luZyB0aGF0Pw0KPg0KDQpTb3JyeSBHcmVnIGJ1dCBJJ20gbm90
IHVuZGVyc3RhbmRpbmcgd2hhdCB0aGUgaXNzdWUgaXMuIENhbiB5b3UgcGxlYXNlIGV4cGxhaW4g
YQ0KYml0IG1vcmUgd2hhdCB5b3UgbWVhbiB3aXRoIHRoZSBhcGlzPw0KDQpPdXIgZHJpdmVyIGNv
ZGUgaXMganVzdCBhIHR1YmUgYmV0d2VlbiBwcm9wcmlldGFyeSBjb2RlIG9uIHRoZSBob3N0IG1h
Y2hpbmUgYW5kDQpwcm9wcmlldGFyeSBjb2RlIG9uIHRoZSBIU00uIFdlIGFyZSBub3QgdHJ5aW5n
IHRvIGNyZWF0ZSBvdXIgb3duIGxpbnV4IGNyeXB0bw0KYXBpcyBiZWNhdXNlIGFsbCB0aGUgY3J5
cHRvIHN0dWZmIGlzIGhhcHBlbmluZyBpbiB0aGUgZXhpc3RpbmcgcHJvcHJpZXRhcnkgY29kZS4N
Cg0KUmVnYXJkcywNCkRhdmUNCg0KDQpEYXZpZCBLaW0NClNlbmlvciBTb2Z0d2FyZSBFbmdpbmVl
cg0KVGVsOiArNDQgMTIyMyA3MDM0NDkNCg0KbkNpcGhlciBTZWN1cml0eQ0KT25lIFN0YXRpb24g
U3F1YXJlDQpDYW1icmlkZ2UgQ0IxIDJHQQ0KVW5pdGVkIEtpbmdkb20NCg0K
