Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB5041A542;
	Mon, 12 Oct 2026 11:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791803531; cv=none; b=MiThqZE5RDuPYakW98LBppx/Bp1X1M7xH6d2h0svWhn8os44I7TDcQXKOnsq5kQh2b2APY7R7CDGYS9vbXze0M3ahxicL2SAyA8CrzzEs3WQL+xatJ1/N0xPU7kOBWqdvcMzP/WVl5hlehgxNi4ZDGmCEF0wJ6iZs1Ow5Pot9Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791803531; c=relaxed/simple;
	bh=nZs3kj2lNaalH1+p3+RR3O6jeaNUBusYsGw6zgy3TYM=;
	h=From:To:Cc:Subject:Mime-Version:Content-Type:Date:Message-ID:
	 References:In-Reply-To; b=L3UnROqUlyi0AJsd85bTS7So8fJkIL2VgsQIgi7ttuNZX/b2X3UqpMng7+ayIzq0ldyqg6NWPBiZzNCHflnP6k2NcHWicFwAwFmdONHgRj46zuKKU6WQe02QIM9InNjZ6EQVYfbqvcRnHetSmnhyNPwsaBBMRroPPv5pWgQu4dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=j78RixCl; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="j78RixCl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1791803470;
	bh=nZs3kj2lNaalH1+p3+RR3O6jeaNUBusYsGw6zgy3TYM=;
	h=From:To:Subject:Mime-Version:Date:Message-ID;
	b=j78RixClS3ozVS2UXxJmzMEtNEAQSmCEM6wu7WWotzufIkOy7aBFS6ZrglaIySgOh
	 c54KVy4AJlVGOmm9rfvpTT6B9gX06WTVdGnmvb6F0gMeNBngXIRJwSGQcQpZPhyXMU
	 IX0hcasD09p/AZxKQnMtTFDNDBMHe2jEQLkayYLw=
EX-QQ-RecipientCnt: 9
X-QQ-GoodBg: 1
X-QQ-SSF: 00400000000000F0
X-QQ-FEAT: D4aqtcRDiqQnft7kyUuJbd/1GndRJklzmB5VJlBX//o=
X-QQ-BUSINESS-ORIGIN: 2
X-QQ-Originating-IP: KqBQrdTSqcq3t7jmzfl59pNSB+M2WPNNwagki+MOhVI=
X-QQ-STYLE: 
X-QQ-mid: lv3gz7b-6t1791803463t0f97a533
From: "=?utf-8?B?V2VudGFvIEd1YW4=?=" <guanwentao@uniontech.com>
To: "=?utf-8?B?RXJpYyBCaWdnZXJz?=" <ebiggers@kernel.org>, "=?utf-8?B?Y2hlbmh1YWNhaQ==?=" <chenhuacai@kernel.org>
Cc: "=?utf-8?B?SHVhY2FpIENoZW4=?=" <chenhuacai@loongson.cn>, "=?utf-8?B?QXJkIEJpZXNoZXV2ZWw=?=" <ardb@kernel.org>, "=?utf-8?B?bGludXgtY3J5cHRv?=" <linux-crypto@vger.kernel.org>, "=?utf-8?B?V0FORyBYdWVydWk=?=" <kernel@xen0n.name>, "=?utf-8?B?bG9vbmdhcmNo?=" <loongarch@lists.linux.dev>, "=?utf-8?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>, "=?utf-8?B?VGlhbnlhbmcgWmhhbmc=?=" <zhangtianyang@loongson.cn>
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
Date: Mon, 12 Oct 2026 19:11:02 +0800
X-Priority: 3
Message-ID: <tencent_339CC94656CDACB222608A27@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
References: <20261011142930.492999-1-chenhuacai@loongson.cn>
	<20261011150052.GA168780@quark>
	<tencent_4750F9C704AA3CFA1E7309B7@qq.com>
	<CAAhV-H59DV-qF98M1Uu=Y4k1a8YNw0_RnP_nH-yr8fZu-jnFXQ@mail.gmail.com>
	<20261012072200.GA828441@google.com>
In-Reply-To: <20261012072200.GA828441@google.com>
X-QQ-ReplyHash: 2622650919
X-BIZMAIL-ID: 4090006467155062447
X-Address-Ticket:version=;type=;ticket_id=;id_list=;display_name=;session_id=;
X-QQ-SENDSIZE: 520
Received: from qq.com (unknown [127.0.0.1])
	by smtp.qq.com (ESMTP) with SMTP
	id ; Mon, 12 Oct 2026 19:11:03 +0800 (CST)
Feedback-ID: lv:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: OKtLSpNs8ToSZKHt+nifouT4Rm94oxgaSlhKKpObqDQemN9yC6e/Bde+
	+/jeAsDo2it+diCEkjmYmBqaejRqruK7s5YjuTMPdq3bQdPy1AgOydY2NQ6ye4PGy5+Px1A
	IIpHhhZSJGWb27TIptty0fWu6/MLiqi93KuJoBRWRTRmeZiLWp35yCUvh69JOdwjUL9M4Id
	MdFfdmgYrLVat46HJcgk5zOzAMW6PXfPxoikvk64b2HX/brQD35A1YxU5Z4s9o+2cdkgXCv
	axlJbtcxj85MG5TqFoNMrn8b4ioKxRAew8NGwOvaz1QCKV5fAnWviQuDLkL/Hre0LCMUe2J
	qHSbupLwrJcjkjOtb+fes6weZ7DDnTQNwD0onASWz+gSiVeX038rPFbZUeh4Q21HH2UEtRL
	wWKLNu+lLwzTrU/xKQ87SsA1Q5w6Kw4ejzmRMRCzbWK2kJWLC0mICZWup6BPdk42HlGt/bf
	bis0vw+4KxjUJXcYRkecOCkddejBsrQ64m2wtJSk/hPROoxN1s/u1sxIvCpv5G9jMf1fwNz
	oUyu9SFhIKDZWk869I7FOVGxoWsBBnQoD3VyDwd1OhFP9uWGwlz1wo0hp1G+1pu9EH1INKl
	+WgKO090AgfmPg75J/XGFnxD+73ZT3g2QnchtpKMyTz6SujNNirHFoGloQsKg0Elp7PASs6
	nAP2pMdA1KOPMCB8k+rybVDyY/yxL3DliCvrVxjAcIhFIKFZHQFyzEEw1gsPcfNTBqU13ZU
	HnNsCrZW/VTScQuT1Fad4dzcqVNoKRibw8VjA3yuiREQr32m7xOODLSviZTuaiGGNnN+Nx2
	ApicplIxElpm2kiD0mEwk8lK8rVXI+qWqYkrfDVFHFrC3c/Dv4lc595q586UiOOKwaKav2D
	f25og0Itml9UEgLEU6lMBKDMog1HICH2ykJTKmgSYfE2ijnUGUW5jl0EoP7dtXzlQ/ZoZ8u
	4o+4x0i90Hi3WKhJTUzgBsY/VgozwK20dJyb4JQVx6S17PVG1IyBtpkHacAMTimbKyf98E8
	eNUTLcPNMzcfRB098nz6BiOqEgJ3jtM2oDpMxfMDZyeRQ3591GYEzkNHBHVT6XkLKLUuHTA
	k82Ud3UWSGRC73kVYfeOqRhWD0JFpaKTKCE7oeV1UVC
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

SGkgRXJpYywNCg0KPiBPbiBNb24sIE9jdCAxMiwgMjAyNiBhdCAwMjo0Mzo0N1BNICswODAw
LCBIdWFjYWkgQ2hlbiB3cm90ZToNCj4gPiBZZXMsIHdlIGNvbnNpZGVyZWQgbW9kaWZ5aW5n
IHtnZXQscHV0fV91bmFsaWduZWRfKiBnbG9iYWxseS4gQnV0IGl0IGlzDQo+ID4gbm90IGFy
Y2gtc3BlY2lmaWMgY29kZSBhbmQgd2UgaGF2ZSBubyB3YXkgdG8gb3ZlcnJpZGUgaXQuDQo+
ID4NCj4gPiBPbiB0aGUgb3RoZXIgaGFuZCwgdGhlIGJ5dGUtdG8tYnl0ZSB7Z2V0LHB1dH1f
dW5hbGlnbmVkXyogaXMgYWx3YXlzDQo+ID4gY29ycmVjdCwgd2UgYXJlIGZyZWUgdG8gb25s
eSBvcHRpbWlzZSB0aGUgaG90IHBhdGggKGxpa2UgY3JjMzIgY29kZSkuDQo+IA0KPiBUaGUg
dW5hbGlnbmVkIGFjY2VzcyBtYWNyb3MgYXJlIHVzZWQgaW4gbG90cyBvZiBvdGhlcg0KPiBw
ZXJmb3JtYW5jZS1jcml0aWNhbCBjb2RlLiAgSGFja3MgaW4gcmFuZG9tIHBsYWNlcyBkb24n
dCBzY2FsZS4NCkFncmVlLCBmcm9tIHRoZWlyIHNpZGUsIHRoZXkgdGhvdWdodCBtYXkgbGlr
ZTogdGhlIGNoYW5nZSBpcyBtaW5pbWFsPw0KTXkgdGhvdWdodCBsaWtlIHdoYXQgb3RoZXIg
YXJjaCBkaWQsIHVzZSBhbHRlcm5hdGl2ZSB0byBwYXRjaCB0aGUge2dldCxwdXR9X3VuYWxp
Z25lZF8qPw0KDQo+ID4gPiA+IFNpbmNlIGxvb25nYXJjaCBtYWRlIHRoZSBpbmNvcnJlY3Qg
ZGVjaXNpb24gdG8gbm90IHNwZWNpZnkgdW5hbGlnbmVkDQo+ID4gPiA+IGFjY2VzcyB1bmNv
bmRpdGlvbmFsbHksIHNpbWlsYXIgdG8gUklTQy1WIGl0IGNhbiBiZSB3b3JrZWQgYXJvdW5k
IG9ubHkNCj4gPiA+ID4gYnkgb3ZlcnJpZGluZyB0aGF0IGluIHRoZSBrY29uZmlnLiAgRm9y
IGxvb25nYXJjaCB0aGF0IGFwcGVhcnMgdGhhdA0KPiA+ID4gPiBhbHJlYWR5IGJlIGltcGxl
bWVudGVkOyBqdXN0IHVuc2V0IENPTkZJR19BUkNIX1NUUklDVF9BTElHTiB3aGVuIHlvdQ0K
PiA+ID4gPiBrbm93IHRoZSBrZXJuZWwgd2lsbCBydW4gb25seSBvbiBDUFVzIHRoYXQgaGF2
ZSBmaXhlZCB0aGlzIGJ1Zy4NCj4gPiA+IEkgdGhpbmsgdGhhdCB3ZSBoYXZlIHRoZSB1c2Ug
Y2FzZXMgdG8gcHJvdmlkZSB0aGUgZ2VuZXJhbCBrZXJuZWwgaW5zdGVhZCBvZiB0aGUgdHdv
IGtlcm5lbCB3aXRoDQo+ID4gPiBkaWZmZXJlbnQgY29uZmlnLCBzbyB0aGUgaW1hZ2UgaW5j
cmVhc2Ugd2lsbCBiZSB0b2xlcmF0ZWQuDQo+ID4gWWVzLCB0aGUgZGVmYXVsdCBjb25maWd1
cmF0aW9uIGlzIHRvIGtlZXAgQ09ORklHX0FSQ0hfU1RSSUNUX0FMSUdOIHNldA0KPiA+IGZv
ciBzaW5nbGUga2VybmVsIGJpbmFyeS4NCj4gDQo+IFNvIGRvbid0IGRvIHRoYXQuICBJdCBk
b2VzIG5vdCB3b3JrIGZvciBkaXZlcmdlbnQgdW5hbGlnbmVkIGFjY2Vzcw0KPiBzdXBwb3J0
LCBhcyB0aGUgb3RoZXIgYXJjaGl0ZWN0dXJlcyBoYXZlIGxlYXJuZWQgbG9uZyBhZ28uDQpG
cm9tIFJJU0MtViB3b3JrYXJvdW5kIGxlYXJuLCB0aGVpciBtb2RlbCBpcyBkaWZmZXJlbnQs
DQp0aGV5IHdhbnQgdG8gZGVmYXVsdCB1bmFsaWduZWQgYWNjZXNzLCBhbmQgdHJhcCBhbmQg
ZW11bGF0ZSB0aGUgYWNjZXNzLg0KDQpUaGlzIExvb25nQXJjaCBtb2RlbCBpcyBwb2ludCB0
byBkZWZhdWx0IHNhZmVseSBhbGlnbmVkIGFjY2VzcywNCmFmdGVyIGRldGVjdGVkIHRoZSB1
bmFsaWduZWQgYWNjZXNzIHN1cHBvcnQsIG5leHQgdG8gdXNlIHRoZSB1bmFsaWduZWQgdG8g
c3BlZWQgdXAuDQpPciBkaWQgYW55dGhpbmcgSSBtaXNzaW5nPw0KDQpCUnMNCldlbnRhbyBH
dWFu

