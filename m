Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150C129B200;
	Thu, 27 Nov 2025 02:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764212222; cv=none; b=RNfJwxmuXR4xzwPt7r5OXAVXWZv1jCYvBXQognL0ckaTweTNj1p2EP7UbxVwAxij8i+QMbrxQxFgJjSeSfx6EtNpyqoDgQXRUbzNm6oKJN+THdk+CvWbKTlJa+QRSzI26VulotR6GPn0zCGti0ZERRCxMqBjvtV0gm9f2WtYAp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764212222; c=relaxed/simple;
	bh=Y7BxDbg4bdv4BDzf7rAkIcpMiEXK+EOaT5aAFRhGzKw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iHmbsGDwA0rubiD0kVTCCaGcTlVYJH/JoKl/GeaKSSmc7Z9btQZlKxZiqxvZ4aqh5PJjIFypXRu0SwZ487SsozS39QQ2bq4ods1HnwUDqKaNL5ICxh//2tWcwWpWoo2MT1nvFzCYT+b9Gd6ok17N6qaLtzui9deXoz/BHStnEz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=vtlbnpr7; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="vtlbnpr7"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Y7BxDbg4bdv4BDzf7rAkIcpMiEXK+EOaT5aAFRhGzKw=;
	b=vtlbnpr79vyLMfCWa3osxg5KQ0eywVNabCQb0hdJzsQ9KOO6GqDftXzubHsStWDitU02+LgWv
	RWutGRlHR+6V2F4N4uFbCh9UIWV50hFqriQLyP4TFTuBXcodqrMWAJ7BjlvPNuwC6UGRJlIp2VA
	z6AhgD0RVL19Tky0RW+NZDw=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4dH1Hq29xKz1cyQN;
	Thu, 27 Nov 2025 10:55:03 +0800 (CST)
Received: from kwepemf500018.china.huawei.com (unknown [7.202.181.5])
	by mail.maildlp.com (Postfix) with ESMTPS id 0BDA41A016C;
	Thu, 27 Nov 2025 10:56:52 +0800 (CST)
Received: from dggpemf200006.china.huawei.com (7.185.36.61) by
 kwepemf500018.china.huawei.com (7.202.181.5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 27 Nov 2025 10:56:51 +0800
Received: from dggpemf200006.china.huawei.com ([7.185.36.61]) by
 dggpemf200006.china.huawei.com ([7.185.36.61]) with mapi id 15.02.1544.011;
 Thu, 27 Nov 2025 10:56:51 +0800
From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
To: Bibo Mao <maobibo@loongson.cn>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	linux-kernel <linux-kernel@vger.kernel.org>, QEMU devel
	<qemu-devel@nongnu.org>
Subject: RE: virtio-crypto: Inquiry about virtio crypto
Thread-Topic: virtio-crypto: Inquiry about virtio crypto
Thread-Index: AQHcXz+QGuy/j9piuEGQ/DhWNYsWN7UF0tvg
Date: Thu, 27 Nov 2025 02:56:51 +0000
Message-ID: <027ff08db97d414da0ccc24a439e75d0@huawei.com>
References: <d4258604-e678-f975-0733-71190cf4067d@loongson.cn>
In-Reply-To: <d4258604-e678-f975-0733-71190cf4067d@loongson.cn>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmlibyBNYW8gPG1h
b2JpYm9AbG9vbmdzb24uY24+DQo+IFNlbnQ6IFRodXJzZGF5LCBOb3ZlbWJlciAyNywgMjAyNSA5
OjQzIEFNDQo+IFRvOiBHb25nbGVpIChBcmVpKSA8YXJlaS5nb25nbGVpQGh1YXdlaS5jb20+DQo+
IENjOiBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyB2aXJ0dWFsaXphdGlvbkBsaXN0cy5s
aW51eC5kZXY7IGxpbnV4LWtlcm5lbA0KPiA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47
IFFFTVUgZGV2ZWwgPHFlbXUtZGV2ZWxAbm9uZ251Lm9yZz4NCj4gU3ViamVjdDogdmlydGlvLWNy
eXB0bzogSW5xdWlyeSBhYm91dCB2aXJ0aW8gY3J5cHRvDQo+IA0KPiBIaSBnb25nbGVpLA0KPiAN
Cj4gICAgIEkgYW0gaW52ZXN0aWdhdGluZyBob3cgdG8gdXNlIEhXIGNyeXB0byBhY2NlbGVyYXRv
ciBpbiBWTS4gSXQgc2VlbXMgdGhhdA0KPiB2aXJ0aW8tY3J5cHRvIGlzIG9uZSBvcHRpb24sIGhv
d2V2ZXIgb25seSBhZXMgc2tjaXBoZXIgYWxnbyBpcyBzdXBwb3J0ZWQgYW5kDQoNCkFjdHVhbGx5
IGFrY2lwaGVyIHNlcnZpY2UgaGFkIGJlZW4gc3VwcG9ydGVkIGJ5IHZpcnRpby1jcnlwdG8gaW4g
MjAyMi4NCg0KPiB2aXJ0aW8tY3J5cHRvIGRldmljZSBpcyBub3Qgc3VnZ2VzdGVkIGJ5IFJIRUwg
MTAuDQo+IA0KPiBodHRwczovL2RvY3MucmVkaGF0LmNvbS9lbi9kb2N1bWVudGF0aW9uL3JlZF9o
YXRfZW50ZXJwcmlzZV9saW51eC8xMC9odG1sDQo+IC9jb25maWd1cmluZ19hbmRfbWFuYWdpbmdf
bGludXhfdmlydHVhbF9tYWNoaW5lcy9mZWF0dXJlLXN1cHBvcnQtYW5kLWxpbWl0DQo+IGF0aW9u
cy1pbi1yaGVsLTEwLXZpcnR1YWxpemF0aW9uDQo+IA0KPiAgICBJIHdhbnQgdG8ga25vdyB3aGF0
IGlzIHRoZSBwb3RlbnRpYWwgaXNzdWVkIHdpdGggdmlydGlvLWNyeXB0by4NCj4gDQoNClRoaXMg
cXVlc3Rpb24gaXMgdG9vIGJpZywgbWF5YmUgeW91J2QgYmV0dGVyIGFzayBSSEVMIGd1eXMuIDoo
DQoNClJlZ2FyZHMsDQotR29uZ2xlaQ0KDQo+IFJlZ2FyZHMNCj4gQmlibyBNYW8NCg0KDQo=
