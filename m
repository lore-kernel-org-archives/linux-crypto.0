From: "yashpal.dutta@freescale.com" <yashpal.dutta@freescale.com>
Subject: RE: [PATCH v3] crypto: caam - power management support for caam
 job-ring
Date: Sat, 22 Mar 2014 17:35:41 +0000
Message-ID: <111265ae51f946ac9b96dde8e0501fb9@BY2PR03MB458.namprd03.prod.outlook.com>
References: <1395341456-60542-1-git-send-email-yashpal.dutta@freescale.com>
 <1395505456.2770.70.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Horia.Geanta@freescale.com" <Horia.Geanta@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:31787
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751058AbaCVRuT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 22 Mar 2014 13:50:19 -0400
In-Reply-To: <1395505456.2770.70.camel@deadeye.wl.decadent.org.uk>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

SSB0cmllZCB0byByZWR1Y2UgdGhlIHBhdGNoIHRvIHNtYWxsZXN0IHBvc3NpYmxlIHNpemUgd2hp
Y2ggcmVzdWx0ZWQgaW4gY3VycmVudCBwYXRjaC4gDQoNCkkgZGlkbuKAmXQgZmluZCBhIHdheSB0
byBjb21wcmVzcyBvciBicmVhayBpdCBmdXJ0aGVyIHRvIGxpbWl0IG9mIHN0YWJsZSB0cmVlIHBh
dGNoIGV4cGVjdGF0aW9ucy4NCg0KWWFzaA0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZy
b206IEJlbiBIdXRjaGluZ3MgW21haWx0bzpiZW5AZGVjYWRlbnQub3JnLnVrXSANClNlbnQ6IFNh
dHVyZGF5LCBNYXJjaCAyMiwgMjAxNCA5OjU0IFBNDQpUbzogRHV0dGEgWWFzaHBhbC1CMDU0NTYN
CkNjOiBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBHZWFudGEgTmVhZyBIb3JpYSBJb2Fu
LUIwNTQ3MTsgR2FyZyBWYWt1bC1CMTYzOTQ7IEd1cHRhIFJ1Y2hpa2EtUjY2NDMxOyBzdGFibGVA
dmdlci5rZXJuZWwub3JnDQpTdWJqZWN0OiBSZTogW1BBVENIIHYzXSBjcnlwdG86IGNhYW0gLSBw
b3dlciBtYW5hZ2VtZW50IHN1cHBvcnQgZm9yIGNhYW0gam9iLXJpbmcNCg0KT24gRnJpLCAyMDE0
LTAzLTIxIGF0IDAwOjM1ICswNTQ1LCBZYXNocGFsIER1dHRhIHdyb3RlOg0KPiBKb2IgcmluZyBp
cyBzdXNwZW5kZWQgZ3JhY2VmdWxseSBhbmQgcmVzdW1lIGFmcmVzaC4NCj4gDQo+IEJvdGggU2xl
ZXAgKHdoZXJlIGRldmljZSB3aWxsIHJlbWFpbiBwb3dlcmVkLW9uKSBhbmQgRGVlcC1zbGVlcCAo
d2hlcmUgDQo+IGRldmljZSB3aWxsIGJlIHBvd2VyZWQtZG93biBhcmUgaGFuZGxlZCBncmFjZWZ1
bGx5LiBQZXJzaXN0YW5jZSANCj4gc2Vzc2lvbnMgYXJlIG5vdCBzdXBwb3J0ZWQgYWNyb3NzIGRl
ZXAtc2xlZXAuDQo+IA0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTaWduZWQtb2Zm
LWJ5OiBZYXNocGFsIER1dHRhIDx5YXNocGFsLmR1dHRhQGZyZWVzY2FsZS5jb20+DQo+IC0tLQ0K
PiAgZHJpdmVycy9jcnlwdG8vY2FhbS9pbnRlcm4uaCB8ICAgMiArDQo+ICBkcml2ZXJzL2NyeXB0
by9jYWFtL2pyLmMgICAgIHwgMjU3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0t
LS0tLS0tLS0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgMTkwIGluc2VydGlvbnMoKyksIDY5IGRlbGV0
aW9ucygtKQ0KWy4uLl0NCg0KVGhpcyBpcyB0b28gYmlnIGZvciBzdGFibGU7IGlzIGEgc2ltcGxl
ciBmaXggcG9zc2libGU/DQoNCkJlbi4NCg0KLS0NCkJlbiBIdXRjaGluZ3MNCkknbSBub3QgYSBy
ZXZlcnNlIHBzeWNob2xvZ2ljYWwgdmlydXMuICBQbGVhc2UgZG9uJ3QgY29weSBtZSBpbnRvIHlv
dXIgc2lnLg0K
