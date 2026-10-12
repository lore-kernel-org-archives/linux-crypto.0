Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087BC48CD7B;
	Mon, 12 Oct 2026 14:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791816715; cv=none; b=iIWrFa60uyJRkcJOFAI4ZSqg8/Pt41Nijb4OBjPQxfGff1qPXgmt3/v1QKkt3k8udfuWK/cMoCNGgobKmA+k7rbZ5W3jQK7ZPXD3VxxEtN/Xn/wEqJSnXMzQXdfeN6IxnXHOQtSRynF8Npv2rPXVGVJLuRy+aYHN+LryqSZmQtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791816715; c=relaxed/simple;
	bh=QUBp1UxhO/vVw9XOAKqgoyXDLPzTSJIZisKnjA6euus=;
	h=From:To:Cc:Subject:Mime-Version:Content-Type:Date:Message-ID:
	 References:In-Reply-To; b=ACHDWTpQnz2rcBZDRkqPfRQcabh6WyZrzFtVlsuMN6LZkpcHpdaIT+Nvxby3GdIsY5RNeC38xstGQ7MO1R+D2I7uJMFRg27tXpkH+5Z7f7TAysiKLyf4YMSZPwvmqs1M2K2go7Q77NLSi+RWRFiJfHLgQ7r4rhQ9AJ9R+fbglA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=MZ6RVf2n; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="MZ6RVf2n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1791816650;
	bh=QUBp1UxhO/vVw9XOAKqgoyXDLPzTSJIZisKnjA6euus=;
	h=From:To:Subject:Mime-Version:Date:Message-ID;
	b=MZ6RVf2nPv9EKwqiK3caa3/wqcOcrllrmxVy1dxBcXaDx8M2Oxdzjz84jwZuSkZSK
	 UzzRqhaSxacglGSRSMLbWG2oG+tFBbhEDw/J3erEfcC/9a5ubsLl7PHq3SNTZzAGTi
	 5t8nbIFY7lGp27jTNWavkZjlVOQnH3cJbeEgR1Ag=
EX-QQ-RecipientCnt: 10
X-QQ-GoodBg: 1
X-QQ-SSF: 00400000000000F0
X-QQ-FEAT: D4aqtcRDiqQnft7kyUuJbd/1GndRJklzmB5VJlBX//o=
X-QQ-BUSINESS-ORIGIN: 2
X-QQ-Originating-IP: F6fiQjb4gg3A2PhMTlx/61hsUi4NpEGYKmB2f1u3Ezs=
X-QQ-STYLE: 
X-QQ-mid: lv3gz7b-6t1791816648t33d73367
From: "=?utf-8?B?V2VudGFvIEd1YW4=?=" <guanwentao@uniontech.com>
To: "=?utf-8?B?RGF2aWQgTGFpZ2h0?=" <david.laight.linux@gmail.com>
Cc: "=?utf-8?B?RXJpYyBCaWdnZXJz?=" <ebiggers@kernel.org>, "=?utf-8?B?Y2hlbmh1YWNhaQ==?=" <chenhuacai@kernel.org>, "=?utf-8?B?SHVhY2FpIENoZW4=?=" <chenhuacai@loongson.cn>, "=?utf-8?B?QXJkIEJpZXNoZXV2ZWw=?=" <ardb@kernel.org>, "=?utf-8?B?bGludXgtY3J5cHRv?=" <linux-crypto@vger.kernel.org>, "=?utf-8?B?V0FORyBYdWVydWk=?=" <kernel@xen0n.name>, "=?utf-8?B?bG9vbmdhcmNo?=" <loongarch@lists.linux.dev>, "=?utf-8?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>, "=?utf-8?B?VGlhbnlhbmcgWmhhbmc=?=" <zhangtianyang@loongson.cn>
Subject: Re: [PATCH 1/2] lib/crc: loongarch: Use hardware unaligned load in CRC32(C) loops
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64
Date: Mon, 12 Oct 2026 22:50:48 +0800
X-Priority: 3
Message-ID: <tencent_52C5E0AD1187B69B562F19A5@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
References: <20261011142930.492999-1-chenhuacai@loongson.cn>
	<20261011150052.GA168780@quark>
	<tencent_4750F9C704AA3CFA1E7309B7@qq.com>
	<CAAhV-H59DV-qF98M1Uu=Y4k1a8YNw0_RnP_nH-yr8fZu-jnFXQ@mail.gmail.com>
	<20261012072200.GA828441@google.com>
	<tencent_339CC94656CDACB222608A27@qq.com>
	<20261012140802.267c293a@pumpkin>
In-Reply-To: <20261012140802.267c293a@pumpkin>
X-QQ-ReplyHash: 3685548821
X-BIZMAIL-ID: 16018066872221435482
X-Address-Ticket:version=;type=;ticket_id=;id_list=;display_name=;session_id=;
X-QQ-SENDSIZE: 520
Received: from qq.com (unknown [127.0.0.1])
	by smtp.qq.com (ESMTP) with SMTP
	id ; Mon, 12 Oct 2026 22:50:49 +0800 (CST)
Feedback-ID: lv:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: NyAwOXzgHijeGcXpcG6JGlQ+NNNGaQPyO4+UsfJlBxNCT6yMMvS7qtXV
	FxqwlR2RMaqH+V9wVLzybsEeIGSp0XafyNvIkAFnjrCtMPb7E28nOwCz338xSq6chRYDR8Y
	e6uPO3lgMmNc5vfDrlvTAmqoMiGRXSKc5mWd/NaUKaHHNe5E428jU01XF6bGmHlAL4Hcppv
	8m9Ww0g3PX9Zb6d0Ui3BF0XjkTFmF1lP9awwMqTR3OJrjcBgb2TJVB0Gqs0EMz0/kTihiL9
	qlEJk3uYameaYagO9BtGvR6SeBF0no+/99zpEeKfxIf2udG0I47W75aRKRvVkGDvxKyPCjs
	0UrwpKZUkJQIlxBYTsXW+aAhimlsyN3mESVzlsJSrvuc1bKq0QE9hW7vCfVse3t4/1iPZh5
	tWO7YaAALPJ2RVt3flPHN1cmJ1hJX2mtQsxTEy9BUT3c4IK8HC3yvc2aQjESmrOK3OogKu7
	Y6xKgVAAmH0s08lh9p65Qiy/qDwamuOJly9VQlatkbvu0NqjMX+nL+chjAO6CXzPHgkYcsx
	cBrBvzY6rZhqEeqkL97wGPU17Y1ISOg80kTY1MtsQtygsitKcUATib1FMYFLVzKAA/5xP/Q
	At1XbkAW59yiBfO/48EfNANcY841X2cZnE/LYN/AX30gkgxJpJgb46OD6B/OMpd+8CGrXOK
	zjixAR25w/kwT462Ad19cqV2u1RsrqIXlE1nrUsT07TjjicQGRGHLBSelHFt+bZ5UVUaSy3
	FlCxYjWoQID+eenb7wQpLf+5gFRHn7+X6l4sZxUsgF3ZYYd4oBDeBTX5w2sBfTuDFhEjvSd
	Qhz91piaVAeHl3255h0avB60UfBwKyadCkaXpzUsIguF/6hXw3b9FDoLw5onsEpNv90OoXS
	6oFjLe/8HXvAC5RZ3rOVGjY/TXfreTbTgyIeG5uWnSpR62KzlnXszSUtputmI569EqbmZwk
	CKxL6u92guMUaNzURTazVGdA1bSToz1kVUTSjJ9bcq438J7SGqececdy1cmG73KGOuO7uOq
	REq1SuK0N4zlbb8ltC7Q67k+vDX+L9ICbM1eun9SbDxvH+ixEJ13j6jTG0gEEiUXeoGAXwu
	LT3ZETxbMwkkpNZI585Fz2Qqd3OOTzR/pp/FDYBwJxYWKolIylGgymL1COcJxYKjw==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

SGksDQoNCj4gPiBIaSBFcmljLA0KPiA+DQo+ID4gPiBPbiBNb24sIE9jdCAxMiwgMjAyNiBh
dCAwMjo0Mzo0N1BNICswODAwLCBIdWFjYWkgQ2hlbiB3cm90ZTogDQo+ID4gPiA+IFllcywg
d2UgY29uc2lkZXJlZCBtb2RpZnlpbmcge2dldCxwdXR9X3VuYWxpZ25lZF8qIGdsb2JhbGx5
LiBCdXQgaXQgaXMNCj4gPiA+ID4gbm90IGFyY2gtc3BlY2lmaWMgY29kZSBhbmQgd2UgaGF2
ZSBubyB3YXkgdG8gb3ZlcnJpZGUgaXQuDQo+ID4gPiA+DQo+ID4gPiA+IE9uIHRoZSBvdGhl
ciBoYW5kLCB0aGUgYnl0ZS10by1ieXRlIHtnZXQscHV0fV91bmFsaWduZWRfKiBpcyBhbHdh
eXMNCj4gPiA+ID4gY29ycmVjdCwgd2UgYXJlIGZyZWUgdG8gb25seSBvcHRpbWlzZSB0aGUg
aG90IHBhdGggKGxpa2UgY3JjMzIgY29kZSkuIA0KPiA+ID4NCj4gPiA+IFRoZSB1bmFsaWdu
ZWQgYWNjZXNzIG1hY3JvcyBhcmUgdXNlZCBpbiBsb3RzIG9mIG90aGVyDQo+ID4gPiBwZXJm
b3JtYW5jZS1jcml0aWNhbCBjb2RlLiAgSGFja3MgaW4gcmFuZG9tIHBsYWNlcyBkb24ndCBz
Y2FsZS4gDQo+ID4gQWdyZWUsIGZyb20gdGhlaXIgc2lkZSwgdGhleSB0aG91Z2h0IG1heSBs
aWtlOiB0aGUgY2hhbmdlIGlzIG1pbmltYWw/DQo+ID4gTXkgdGhvdWdodCBsaWtlIHdoYXQg
b3RoZXIgYXJjaCBkaWQsIHVzZSBhbHRlcm5hdGl2ZSB0byBwYXRjaCB0aGUge2dldCxwdXR9
X3VuYWxpZ25lZF8qPw0KPiA+DQo+ID4gPiA+ID4gPiBTaW5jZSBsb29uZ2FyY2ggbWFkZSB0
aGUgaW5jb3JyZWN0IGRlY2lzaW9uIHRvIG5vdCBzcGVjaWZ5IHVuYWxpZ25lZA0KPiA+ID4g
PiA+ID4gYWNjZXNzIHVuY29uZGl0aW9uYWxseSwgc2ltaWxhciB0byBSSVNDLVYgaXQgY2Fu
IGJlIHdvcmtlZCBhcm91bmQgb25seQ0KPiA+ID4gPiA+ID4gYnkgb3ZlcnJpZGluZyB0aGF0
IGluIHRoZSBrY29uZmlnLiAgRm9yIGxvb25nYXJjaCB0aGF0IGFwcGVhcnMgdGhhdA0KPiA+
ID4gPiA+ID4gYWxyZWFkeSBiZSBpbXBsZW1lbnRlZDsganVzdCB1bnNldCBDT05GSUdfQVJD
SF9TVFJJQ1RfQUxJR04gd2hlbiB5b3UNCj4gPiA+ID4gPiA+IGtub3cgdGhlIGtlcm5lbCB3
aWxsIHJ1biBvbmx5IG9uIENQVXMgdGhhdCBoYXZlIGZpeGVkIHRoaXMgYnVnLiANCj4gPiA+
ID4gPiBJIHRoaW5rIHRoYXQgd2UgaGF2ZSB0aGUgdXNlIGNhc2VzIHRvIHByb3ZpZGUgdGhl
IGdlbmVyYWwga2VybmVsIGluc3RlYWQgb2YgdGhlIHR3byBrZXJuZWwgd2l0aA0KPiA+ID4g
PiA+IGRpZmZlcmVudCBjb25maWcsIHNvIHRoZSBpbWFnZSBpbmNyZWFzZSB3aWxsIGJlIHRv
bGVyYXRlZC4gDQo+ID4gPiA+IFllcywgdGhlIGRlZmF1bHQgY29uZmlndXJhdGlvbiBpcyB0
byBrZWVwIENPTkZJR19BUkNIX1NUUklDVF9BTElHTiBzZXQNCj4gPiA+ID4gZm9yIHNpbmds
ZSBrZXJuZWwgYmluYXJ5LiANCj4gPiA+DQo+ID4gPiBTbyBkb24ndCBkbyB0aGF0LiAgSXQg
ZG9lcyBub3Qgd29yayBmb3IgZGl2ZXJnZW50IHVuYWxpZ25lZCBhY2Nlc3MNCj4gPiA+IHN1
cHBvcnQsIGFzIHRoZSBvdGhlciBhcmNoaXRlY3R1cmVzIGhhdmUgbGVhcm5lZCBsb25nIGFn
by4gDQo+ID4NCj4gPiBGcm9tIFJJU0MtViB3b3JrYXJvdW5kIGxlYXJuLCB0aGVpciBtb2Rl
bCBpcyBkaWZmZXJlbnQsDQo+ID4gdGhleSB3YW50IHRvIGRlZmF1bHQgdW5hbGlnbmVkIGFj
Y2VzcywgYW5kIHRyYXAgYW5kIGVtdWxhdGUgdGhlIGFjY2Vzcy4NCj4gDQo+IFdoaWNoIGlz
IGVudGlyZWx5IGJyb2tlbiBmcm9tIGEgcGVyZm9ybWFuY2UgcG9pbnQgb2Ygdmlldy4NCj4g
RXNwZWNpYWxseSBzaW5jZSBzb21lIHN5c3RlbSBoaWRlIHRoZSBlbXVsYXRpb24gZnJvbSB0
aGUga2VybmVsLg0KRW1tbSwgSSBkb25gdCBrbm93IGlmIGl0IGV4aXN0ZWQgaW4gTG9vbmdB
cmNoIHN5c3RlbS4uLg0KDQo+ID4NCj4gPiBUaGlzIExvb25nQXJjaCBtb2RlbCBpcyBwb2lu
dCB0byBkZWZhdWx0IHNhZmVseSBhbGlnbmVkIGFjY2VzcywNCj4gPiBhZnRlciBkZXRlY3Rl
ZCB0aGUgdW5hbGlnbmVkIGFjY2VzcyBzdXBwb3J0LCBuZXh0IHRvIHVzZSB0aGUgdW5hbGln
bmVkIHRvIHNwZWVkIHVwLg0KPiA+IE9yIGRpZCBhbnl0aGluZyBJIG1pc3Npbmc/DQo+IA0K
PiBUaGVyZSBhcmUgdGhyZWUgY2FzZXM6DQo+IDEpIFVuYWxpZ25lZCBhY2Nlc3NlcyBmYXVs
dCBhbmQgbXVzdCBiZSBhdm9pZGVkLg0KPiAyKSBVbmFsaWduZWQgYWNjZXNzZXMgYXJlIGV4
ZWN1dGVkIGJ5IHRoZSBjcHUgYnV0IHRha2UgYSBzbWFsbCBudW1iZXINCj4gICAgb2YgZXh0
cmEgY3ljbGVzLg0KPiAzKSBVbmFsaWduZWQgYWNjZXNzZXMgYXJlIGV4ZWN1dGVkIGJ5IHRo
ZSBjcHUgYW5kIGFyZSAoYWxtb3N0IGFsd2F5cykNCj4gICAgZnJlZS4NCj4gRm9yICgyKSBp
dCBpcyBzdGlsbCB3b3J0aCBhbGlnbmluZyBidWZmZXJzLg0KPiB4ODYgaXMgcHJldHR5IG11
Y2ggaW4gY2FtcCAoMykgLSBJIHN1c3BlY3QgaXQgdXNlcyBieXRlLWVuYWJsZXMgb24gYSA2
NCBieXRlDQo+IHdpZGUgaW50ZXJmYWNlIHRvIHRoZSBjYWNoZS4NCj4gDQo+IElmIHlvdSBh
bGlnbiBidWZmZXJzIHlvdSBkb24ndCBoYXZlIHRvIHdvcnJ5IGFib3V0IHRoaW5ncyBsaWtl
DQo+ICd3b3JkIGF0IGEgdGltZSBzdHJsZW4oKScgcnVubmluZyBvZmYgdGhlIGVuZCBvZiBh
IHBhZ2UuDQpBZ3JlZWQsIGFzIEkga25vd24gc29tZSBob3VycyBhZ28gZm9yIHVuYWxpZ25l
ZCBhY2Nlc3MgZXhpc3RlZCBpbiBMb29uZ0FyY2gNCmRlc2t0b3Avc2VydmVyIGNoaXAsIHNv
IGZvciBtZSBub3cgaXMgbm90IG1vdGl2YXRlZCB0byBkbyB0aGUgY29tcGxleGVkIHdvcmsu
DQoNClRoYW5rcw0KV2VudGFvIEd1YW4=

