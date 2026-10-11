Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B1B4582FC;
	Sun, 11 Oct 2026 15:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791731702; cv=none; b=YL1NwGmPjdKD7i0wuxAwRL0Dz9WMt1wsDq7zONwetvqOKif1prfDWi/+3k4P1rpTY0rliWYesUC8d8ZB+FepA1JFpacLpH821d7SWuwX3TY/bD9ehU3Qsnivs/Fk6qwzqfz+RTU7dUr6udWNnaRflOccAp0h7BhC015X5td511k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791731702; c=relaxed/simple;
	bh=umG5WIzXpwL9a99Crx0GEoTewFz2ZyPwbGY3LmJ+aP0=;
	h=From:To:Cc:Subject:Mime-Version:Content-Type:Date:Message-ID:
	 References:In-Reply-To; b=dZV9uyEpRL0Zkael43MoiO/dUcEb4bt+iUzBIKZ3idzUa9gfedV7ym130BeMGYD4+OpkZyCoO9+YYGZWmg5eBX0Za5XTEDza1Ui+ySnTt8e83yursaSsk5E1pl7u7DXHtXtygF6MxEhSyETcUt+FIJQFXbUEEXbVjriJ4rPdZU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=e0J3kxoL; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="e0J3kxoL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1791731648;
	bh=umG5WIzXpwL9a99Crx0GEoTewFz2ZyPwbGY3LmJ+aP0=;
	h=From:To:Subject:Mime-Version:Date:Message-ID;
	b=e0J3kxoLvvcJzrgNhxEjjkSWi4Q+pmMpOe1+Qd21xW5rrtM5o/lYSKI2puXNIeYYt
	 WXS4FSEeZlh3fwpXsDHIYW4eNzjlrWU7wY985cjhFOnuOwdaxytFmudGd1XVKAreAb
	 9OaEP2J95WvEkztYJpqGrqGj2uFWcpmO5HB+h0O4=
EX-QQ-RecipientCnt: 9
X-QQ-GoodBg: 1
X-QQ-SSF: 00400000000000F0
X-QQ-FEAT: D4aqtcRDiqQnft7kyUuJbd/1GndRJklzmB5VJlBX//o=
X-QQ-BUSINESS-ORIGIN: 2
X-QQ-Originating-IP: YsSo2C4G5DLDMG+5jLL6P1G05aArSwsnpYEoDW398vk=
X-QQ-STYLE: 
X-QQ-mid: lv3gz7b-6t1791731642t19bc117f
From: "=?utf-8?B?V2VudGFvIEd1YW4=?=" <guanwentao@uniontech.com>
To: "=?utf-8?B?RXJpYyBCaWdnZXJz?=" <ebiggers@kernel.org>, "=?utf-8?B?SHVhY2FpIENoZW4=?=" <chenhuacai@loongson.cn>
Cc: "=?utf-8?B?Y2hlbmh1YWNhaQ==?=" <chenhuacai@kernel.org>, "=?utf-8?B?QXJkIEJpZXNoZXV2ZWw=?=" <ardb@kernel.org>, "=?utf-8?B?bGludXgtY3J5cHRv?=" <linux-crypto@vger.kernel.org>, "=?utf-8?B?V0FORyBYdWVydWk=?=" <kernel@xen0n.name>, "=?utf-8?B?bG9vbmdhcmNo?=" <loongarch@lists.linux.dev>, "=?utf-8?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>, "=?utf-8?B?VGlhbnlhbmcgWmhhbmc=?=" <zhangtianyang@loongson.cn>
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
Date: Sun, 11 Oct 2026 23:14:02 +0800
X-Priority: 3
Message-ID: <tencent_4750F9C704AA3CFA1E7309B7@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
References: <20261011142930.492999-1-chenhuacai@loongson.cn>
	<20261011150052.GA168780@quark>
In-Reply-To: <20261011150052.GA168780@quark>
X-QQ-ReplyHash: 1864047915
X-BIZMAIL-ID: 10742750840368666225
X-Address-Ticket:version=;type=;ticket_id=;id_list=;display_name=;session_id=;
X-QQ-SENDSIZE: 520
Received: from qq.com (unknown [127.0.0.1])
	by smtp.qq.com (ESMTP) with SMTP
	id ; Sun, 11 Oct 2026 23:14:03 +0800 (CST)
Feedback-ID: lv:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: Mi3rtMkLCwwyL08wiR6l/C387V6HHrIoJqhS/itirFwaLoMWtXQtVXjs
	iQG1dgaX+yE/dzwtGQwGy6Z1Dpx+Or1VpIBaXhzjFHuU9jTY9qTMIu2ngo7/VPOUA6OSPxW
	KxgdKKHMG4nVBWjyHa8Y4aB/tRVwzM8whzYe/vBTVdS4E1eE1p15Q7ZbxyAywC6SUHU0rbp
	7EJv5oMHs/+eqatugJj9ucPxhr//YrByUoFLfnc6PJ/f9EGXtEP7oKy+9khX164FA5Q8tfM
	DTVtw4NzCYSxEsed4g/aLgbBbVrn79p5odY/0GyDRS0GNbIGQJ5wSRFa3snVQA8TfZ8penp
	Wr+UviYdJmfZuK/CjYNUhO+eahZLx6jAZphFfOFOSSxY6aJhZEacJlgzHkwVvHNPJ4/Xas+
	C33lM+BRsQ64Xsw+KwquxA7grxFgBlTw+n0GEoRWVkbXWxBz0RibQ23puVDoi3JJA/Oyw/d
	oMlU/LN8Fdyc5xHkYjmdgwu010N7x7WB/A8ug0P0Ll5PQt5Bz4BrRaBzV1TX6r0lcAs5u5V
	Q8CF1S5wksWKxcwn+cpxF69i06bRtY8Yqxkl2ipJp3BmQTAjumQX0Xw332qWsLQ0kzX9wXt
	W+ncK6YExEsY9ar+5Enxlzcrt09i60p+bw/uW9/0mOzJdwLordZsLbuG1tPWQ3/7ZadKGc4
	xJ+n4Nr7v1v3KLOa2DyrLLrH/sz1uQeJyXaiJEwTBEidio3Ynd3E+H8fU4StZrdLEQao/ht
	xuLhKLt2YxunPoL1dV3CjL7VDnUvPH2v/gYom4nkMhAiR0IL1We/IJD8iZudbZCp0u04y0B
	46kGYkqrcDpm8dh5UOGYue+RkCYZvs7Ygq4UMoB4Fqmd5mPPemZ8QIk3+sHfY8+0gQLClzO
	yzSYeQtkq1eqCgSkb8Cr2SGacfJdZN+e9T291e03bdKnnpKQGaglZFHwMNj60OS+V2ogAOJ
	hbrM0v7sV0rdwcDuQd0Sl2ZSCCkceUB7t1aDJ+9SxZPhTCItNRdrmiOPgXdiMQel4SNSXzT
	SUVRh0LcoEWtJy9jWF4d5ukkgJS8A9aV3Yg5D/guoDYFtsPPFqbvkI04CnMJF1b4CKXqmQr
	z8HAUewPpQCKmbDghYnOTRbVrH7HNInlF50RYq6CWNRAwwS5fPimhDkzJWakx1NHI9xBVph
	HekxtMKyYIZrAkEUPIZw/Qsy9Q==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0

PiBPbiBTdW4sIE9jdCAxMSwgMjAyNiBhdCAxMDoyOToyOVBNICswODAwLCBIdWFjYWkgQ2hl
biB3cm90ZToNCj4gPiArc3RhdGljIGlubGluZSB1MzIgZ2V0X2xlMzIoY29uc3Qgdm9pZCAq
cCkNCj4gPiArew0KPiA+ICsgaWYgKHN0YXRpY19icmFuY2hfbGlrZWx5KCZoYXZlX3VhbCkp
DQo+ID4gKyByZXR1cm4gKigoX19sZTMyICopcCk7DQo+ID4gKyBlbHNlDQo+ID4gKyByZXR1
cm4gZ2V0X3VuYWxpZ25lZF9sZTMyKHApOw0KPiA+ICt9DQo+IA0KPiBObywgdGhpcyBpcyBq
dXN0IGJyb2tlbi4gIFRoZSBiYXJlIG1pc2FsaWduZWQgYWNjZXNzIGlzIHVuZGVmaW5lZA0K
PiBiZWhhdmlvciBpbiBDLiAgQWxzbywgZXZlcnkgb3RoZXIgdXNlIG9mIHtnZXQscHV0fV91
bmFsaWduZWRfKiBpbiB0aGUNCj4ga2VybmVsIHdvdWxkIG5lZWQgdGhpczsgaXQgaXMgbm90
IHNwZWNpZmljIHRvIHRoZSBDUkMgY29kZS4gIEFsc28sIGl0IGlzDQpSaWdodCwgSSBnb3Qg
eW91ciB0aG91Z2h0LiBJdCBub3QgYmVsb25nIHRvIENSQyBsZXZlbC4NCg0KPiBpbmVmZmlj
aWVudCB0byBjb21waWxlIGJvdGggY29kZSBwYXRocyBpbnRvIHRoZSBiaW5hcnkuDQo+IA0K
PiBUaGUgb25seSB3YXkgdGhhdCByZWFsaXN0aWNhbGx5IHdvcmtzLCBhcyB3ZSBrbm93IGZy
b20gdGhlIG90aGVyDQo+IGFyY2hpdGVjdHVyZXMsIGlzIGZvciB0aGUgdW5hbGlnbmVkIGFj
Y2VzcyBzdXBwb3J0IHRvIGJlIGtub3duIGF0DQo+IGNvbXBpbGUgdGltZSwgYW5kIHRvIGhh
dmUge2dldCxwdXR9X3VuYWxpZ25lZF8qIGRvIHRoZSByaWdodCB0aGluZw0KPiBhY2NvcmRp
bmdseS4NClNvIHRoZSBvcHRpbWl6ZSBpdCBjYW4gYmUgbW92ZSB0byB7Z2V0LHB1dH1fdW5h
bGlnbmVkXyogY29kZT8NCg0KPiANCj4gU2luY2UgbG9vbmdhcmNoIG1hZGUgdGhlIGluY29y
cmVjdCBkZWNpc2lvbiB0byBub3Qgc3BlY2lmeSB1bmFsaWduZWQNCj4gYWNjZXNzIHVuY29u
ZGl0aW9uYWxseSwgc2ltaWxhciB0byBSSVNDLVYgaXQgY2FuIGJlIHdvcmtlZCBhcm91bmQg
b25seQ0KPiBieSBvdmVycmlkaW5nIHRoYXQgaW4gdGhlIGtjb25maWcuICBGb3IgbG9vbmdh
cmNoIHRoYXQgYXBwZWFycyB0aGF0DQo+IGFscmVhZHkgYmUgaW1wbGVtZW50ZWQ7IGp1c3Qg
dW5zZXQgQ09ORklHX0FSQ0hfU1RSSUNUX0FMSUdOIHdoZW4geW91DQo+IGtub3cgdGhlIGtl
cm5lbCB3aWxsIHJ1biBvbmx5IG9uIENQVXMgdGhhdCBoYXZlIGZpeGVkIHRoaXMgYnVnLg0K
SSB0aGluayB0aGF0IHdlIGhhdmUgdGhlIHVzZSBjYXNlcyB0byBwcm92aWRlIHRoZSBnZW5l
cmFsIGtlcm5lbCBpbnN0ZWFkIG9mIHRoZSB0d28ga2VybmVsIHdpdGgNCmRpZmZlcmVudCBj
b25maWcsIHNvIHRoZSBpbWFnZSBpbmNyZWFzZSB3aWxsIGJlIHRvbGVyYXRlZC4NCg0KQlJz
DQpXZW50YW8gR3Vhbg==

