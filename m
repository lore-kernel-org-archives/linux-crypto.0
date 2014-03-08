From: "McCaffrey, Timothy M" <Timothy.McCaffrey@unisys.com>
Subject: RE: [PATCH 2/2] Crypto: Add support for 192 & 256 bit keys to AESNI
 RFC4106 - fixed whitespace
Date: Fri, 7 Mar 2014 19:56:44 -0600
Message-ID: <62FCA75CAF88C148AA5FC0EC0E4321C70127AA973763@USEA-EXCH7.na.uis.unisys.com>
References: <62FCA75CAF88C148AA5FC0EC0E4321C70127AA6F5222@USEA-EXCH7.na.uis.unisys.com>
	 <1394239315.27116.142.camel@schen9-DESK>
	 <62FCA75CAF88C148AA5FC0EC0E4321C70127AA973760@USEA-EXCH7.na.uis.unisys.com>
 <1394243568.27116.151.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	James Guilford <james.guilford@intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail1.bemta8.messagelabs.com ([216.82.243.203]:15636 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752133AbaCHB5j (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Mar 2014 20:57:39 -0500
In-Reply-To: <1394243568.27116.151.camel@schen9-DESK>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

T2ssIHdpbGwgZ2VuZXJhdGUgYW5vdGhlciBwYXRjaCBmb3IgZ2x1ZS5jLiAgU2luY2UgdGhlIGFz
bSBkb2Vzbid0IHZlcmlmeSB0aGUgYWFkbGVuIG9yIHRhZ2xlbiBlaXRoZXIgKHRoZXkgaGF2ZSBh
IGNvbnN0cmFpbmVkIHNldCBvZiB2YWx1ZXMgYXMgd2VsbCksIHBlcmhhcHMgdGhleSBzaG91bGQg
YmUgdmVyaWZpZWQgYnkgZ2x1ZS5jIGFzIHdlbGw/DQoNCgktIFRpbQ0KDQotLS0tLU9yaWdpbmFs
IE1lc3NhZ2UtLS0tLQ0KRnJvbTogVGltIENoZW4gW21haWx0bzp0aW0uYy5jaGVuQGxpbnV4Lmlu
dGVsLmNvbV0gDQpTZW50OiBGcmlkYXksIE1hcmNoIDA3LCAyMDE0IDg6NTMgUE0NClRvOiBNY0Nh
ZmZyZXksIFRpbW90aHkgTQ0KQ2M6IGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdTsgbGludXgt
Y3J5cHRvQHZnZXIua2VybmVsLm9yZzsgSmFtZXMgR3VpbGZvcmQ7IFZpbm9kaCBHb3BhbA0KU3Vi
amVjdDogUkU6IFtQQVRDSCAyLzJdIENyeXB0bzogQWRkIHN1cHBvcnQgZm9yIDE5MiAmIDI1NiBi
aXQga2V5cyB0byBBRVNOSSBSRkM0MTA2IC0gZml4ZWQgd2hpdGVzcGFjZQ0KDQpPbiBGcmksIDIw
MTQtMDMtMDcgYXQgMTk6NDAgLTA2MDAsIE1jQ2FmZnJleSwgVGltb3RoeSBNIHdyb3RlOg0KPiBZ
b3UgbmVlZCB0byBzZXQgdGhlIGtleSBsZW5ndGggaW4gdGhlIGFlc19rZXlfZXhwYW5kZWQgc3Ry
dWN0dXJlIGVpdGhlciBleHBsaWNpdGx5IG9yIHVzZSB0aGUgYWVzbmlfc2V0X2tleSBmdW5jdGlv
bi4NCj4gDQo+IFRoZSBhc20gY29kZSBleHBlY3RzIG9ubHkgdmFsaWQgdmFsdWVzIGluIHRoZSBz
dHJ1Y3R1cmUgKDE2LCAyNCBvciAzMikuDQo+IA0KPiBJZiB0aGUgZW5jcnlwdC9kZWNyeXB0IGlz
IGNhbGxlZCB3aXRob3V0IHNldHRpbmcgdGhlIGtleSwgeW91IGdldCBnYXJiYWdlIChhbmQgYW4g
ZXJyb3IgaW4gdGhpcyBjYXNlKS4gIFBlcmhhcHMgdGhlIGdsdWUgY29kZSBuZWVkcyB0byBkb3Vi
bGUgY2hlY2sgdGhlIGtleXNpemUgYmVmb3JlIGNhbGxpbmcgdGhlIGFzbSBjb2RlPw0KPiANCj4g
CS0gVGltDQo+IA0KDQpSaWdodCwgeW91ciBuZXcgZnVuY3Rpb24gYWN0dWFsbHkgd2lsbCBsb29r
IGZvciB0aGUga2V5bGVuIHdoaWNoIHdhcyBub3QNCm5lZWRlZCBiZWZvcmUuICANCg0KSSB0aGlu
ayBpdCB3aWxsIGJlIGEgZ29vZCBpZGVhIHRvIGRvdWJsZSBjaGVjayB0aGUga2V5c2l6ZSBoYXMg
dmFsaWQNCnZhbHVlIGJlZm9yZSBjYWxsaW5nIHRoZSBhc20gY29kZSBvciBpbiB0aGUgYXNtIGNv
ZGUgaXRzZWxmLiANCg0KVGltDQoNCg0K
