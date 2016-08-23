From: Michael McKay <mmckay@vmware.com>
Subject: Problems with cbc(aes) and do_alg0test()
Date: Tue, 23 Aug 2016 22:44:39 +0000
Message-ID: <1887F274-344C-4810-B2DD-DD6551CC4980@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:12054 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753619AbcHWWpA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Aug 2016 18:45:00 -0400
Received: from EX13-CAS-005.vmware.com (ex13-cas-005.vmware.com [10.113.191.55])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 8FAF1186B1
        for <linux-crypto@vger.kernel.org>; Tue, 23 Aug 2016 15:44:42 -0700 (PDT)
Content-Language: en-US
Content-ID: <AF185860A866DB43BEA8A0201A4E443A@namprd05.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

V2UgYXJlIHdyaXRpbmcgYSBkZXZpY2UgZHJpdmVyIHdpdGgga2VybmVsIHYzLjE0LCBhbmQgdHJ5
aW5nIHRvIGVuY3J5cHQgc29tZSBkYXRhIHVzaW5nIHRoZSBMaW51eCBrZXJuZWwgYWxnb3JpdGht
IOKAnGNiYyhhZXMp4oCdLiBPdXIgL3Byb2MvY3J5cHRvIHNob3dzIHRoZSBmb2xsb3dpbmcgaXMg
bG9hZGVkOiBkcml2ZXIg4oCcY2JjLWFlcy1hZXNuaeKAnSwgbW9kdWxlIOKAnGFlc25pX2ludGVs
4oCdLCBhbmQgdHlwZSDigJxhYmxrY2lwaGVy4oCdLiBCdXQgY3J5cHRvX2hhc19hbGcoKSBnaXZl
cyB1cyBhbiBlcnJvciBpbmRpY2F0aW5nIHRoZSBhbGdvIGlzIG5vdCBsb2FkZWQuIFNvIGtub3dp
bmcgd2UgaGF2ZSB0aGUgYWxnbyBzdHJpbmcgY29ycmVjdCwgbW9zdCBsaWtlbHkgdGhlIHByb2Js
ZW0gaXMgd2l0aCB0aGUgdHdvIG90aGVyIGlucHV0IHZhcmlhYmxlczogbWFzayBvciB0eXBlLg0K
IA0KU2luY2UgQUVTTkkgaXMgaW4gdXNlLCB3ZSBoYXZlIGEgZGVjZW50IGd1ZXNzIGF0IHRoZSB0
eXBlcyBieSBsb29raW5nIGF0IHRoZSAuY3JhX2ZsYWdzIGZpZWxkIGluIGFlbnNpLUludGVsX2ds
dWUuYyAod2hpY2ggaGFzIOKAnENSWVBUT19BTEdfVFlQRV9BQkxLQ0lQSEVSIHwgQ1JZUFRPX0FM
R19BU1lOQ+KAnSkuIFRoYXQgbGVhdmVzIGp1c3QgYSBmZXcgbWFzayBmaWVsZHMgdG8gZ3Vlc3Mg
YXQsIGJ1dCBDUllQVE9fQUxHX1RZUEVfQkxLQ0lQSEVSX01BU0sgYW5kIENSWVBUT19BTEdfVFlQ
RV9NQVNLIGRvbuKAmXQgd29yayAobm90IGRvZXMgT1LigJlpbmcgdGhlbSB0b2dldGhlcikuIA0K
DQpXaGF0IGFyZSB0aGUgY29ycmVjdCBtYXNrIGFuZCB0eXBlIHZhbHVlcyBmb3IgQUVTTkksIGFu
ZCBjYW4geW91IHBvaW50IG1lIHRvIGFueSBkb2N1bWVudGF0aW9uPyBXaGF0IGVsc2UgbWlnaHQg
d2UgYmUgZG9pbmcgd3Jvbmc/IElzIC9wcm9jL2NyeXB0byBnaXZpbmcgdXMgcmVsZXZhbnQgaW5m
b3JtYXRpb24/IFRoYW5rcywNCg0KTWljaGFlbCBNY0theQ0KbW1ja2F5QHZtd2FyZS5jb20NCg0K
DQo=
