Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C05445ADB;
	Thu, 24 Sep 2026 09:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790241605; cv=none; b=mGlrym2vucsaL/0B1DJKZ7BNX3ZR4LJ9A2lrdw/sXJ0hMxIsnvLgBfwzPQ2cGTNglQdUHQfhXT6KpEV/6HNhbISesnxFGQNxHww6PPBxII4aiSlhTLw6atu59eDIqZPRFXLYtKnm7/6RoFc49kOVgP1oAQul8HAD7mZmtXl3AFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790241605; c=relaxed/simple;
	bh=AgL7mhgob02QeXaZar9RlUIpm/kXZd8JEkEsJkJLOmw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=nQkaCTBSNik8JJiHmm4Aa6ytJhXHprh65MiCUKCGAyiQE3hDUwBoF+xtXXuQMT91Uj90C9A+Zgdm2KOMCucxTgJrhmtWRjrUr09pYKtHFwBzfZJ/5hDt8k6vdpgQCCu5O52uZVdU0M3hdyqdIrA6261FnKQ33G7CvUhcikoGq7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=bYYG2YN2; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="bYYG2YN2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=AgL7mhgob02QeXaZar9RlUIpm/kXZd8JEkEsJkJLOmw=; b=b
	YYG2YN2SFqAKV2WBNiXCSWz4B9ocnaUK8TNabPPpuaMvcUARpXuYOfyuscpimksQ
	OJ8eTjHluaU+hHhYYPE7dJ7jorm0hyKDIuxtMSjwLa8OT1Ruo/G4n4bRjelk5iUO
	h7Yv53daLo56N9UNTAHb7x62iz0325JVIzkJJm6V+U=
Date: Thu, 24 Sep 2026 17:19:35 +0800 (CST)
From: "jiale yao" <19888972804@163.com>
To: "Tom Lendacky" <thomas.lendacky@amd.com>,
	"John Allen" <john.allen@amd.com>,
	"Herbert Xu" <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Gary R Hook" <gary.hook@amd.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: Re:[PATCH] crypto: ccp: drain v5 IRQ tasklet during teardown
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <20260924090537.173532-1-yaojiale02@163.com>
References: <20260924090537.173532-1-yaojiale02@163.com>
X-NTES-SC: AL_Qu2SAv6fvk0s4ySRZOkcn08ShO49XMOyvfoi2YFTc/0EswLK8D4sfmZiMFTwwtOINxGjmiOvXxNvy/t1f4ddp0/wz9pp6wxP+8kZG5z/DA==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <6bd9f4f5.88e0.1a0d2b6924b.Coremail.19888972804@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:cygvCgD3n5An67Rq11VOAA--.1305W
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7wfLBmq06ycjFwAA3D
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

UGF0Y2hlZCBpbiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvYXJPVXNtdzJkd2V1U1Z6cUBn
b25kb3IuYXBhbmEub3JnLmF1LwppZ25vcmUgdGhpcywgc29ycnkuCgoKCkF0IDIwMjYtMDktMjQg
MTc6MDU6MzcsICJKaWFsZSBZYW8iIDx5YW9qaWFsZTAyQDE2My5jb20+IHdyb3RlOgo+T24gUENJ
IGRldmljZXMgdXNpbmcgTVNJLVgsIGNjcDVfaXJxX2hhbmRsZXIoKSBkaXNhYmxlcyB0aGUgcXVl
dWUKPmludGVycnVwdHMgYW5kIHNjaGVkdWxlcyBjY3AtPmlycV90YXNrbGV0LiBUaGUgdGFza2xl
dCBjYWxscwo+Y2NwNV9pcnFfYmgoKSwgd2hpY2ggYWNjZXNzZXMgcmVnaXN0ZXJzIGFuZCB3YWl0
IHF1ZXVlcyB0aHJvdWdoCj5jY3AtPmNtZF9xLgo+Cj5Cb3RoIHRoZSBjY3A1X2luaXQoKSBlcnJv
ciBwYXRoIGFuZCBjY3A1X2Rlc3Ryb3koKSBmcmVlIHRoZSBDQ1AgSVJRCj5iZWZvcmUgdGhlIGNv
bW1hbmQgcXVldWVzIGFuZCB0aGUgZGV2aWNlLW1hbmFnZWQgY2NwIGFsbG9jYXRpb24gYXJlCj5y
ZWxlYXNlZC4gc3BfZnJlZV9jY3BfaXJxKCkgcHJldmVudHMgYW5vdGhlciBoYXJkIElSUSBhbmQg
d2FpdHMgZm9yIGFuCj5pbi1mbGlnaHQgaGFuZGxlciwgYnV0IGl0IGRvZXMgbm90IGRyYWluIGEg
dGFza2xldCB0aGF0IHRoZSBoYW5kbGVyCj5hbHJlYWR5IHNjaGVkdWxlZC4gVGhlIHRhc2tsZXQg
Y2FuIHRoZXJlZm9yZSBhY2Nlc3MgY2NwLT5jbWRfcSBhZnRlcgo+aXRzIGJhY2tpbmcgYWxsb2Nh
dGlvbiBoYXMgYmVlbiByZWxlYXNlZC4KPgo+S2lsbCB0aGUgdGFza2xldCBhZnRlciBzcF9mcmVl
X2NjcF9pcnEoKSwgd2hlbiBubyBoYW5kbGVyIGNhbiBzY2hlZHVsZQo+aXQgYWdhaW4sIGFuZCBi
ZWZvcmUgdGhlIGNvbW1hbmQgcXVldWVzIG9yIGNjcCBjYW4gYmUgcmVsZWFzZWQuIENoZWNrCj5j
Y3AtPnVzZV90YXNrbGV0IGJlY2F1c2UgdGhlIHRhc2tsZXQgaXMgaW5pdGlhbGl6ZWQgb25seSBm
b3IgTVNJLVguCj4KPkZpeGVzOiA2MjYzYjUxZWIzMTkgKCJjcnlwdG86IGNjcCAtIENoYW5nZSBJ
U1IgaGFuZGxlciBtZXRob2QgZm9yIGEgdjUgQ0NQIikKPkNjOiBzdGFibGVAdmdlci5rZXJuZWwu
b3JnCj5TaWduZWQtb2ZmLWJ5OiBKaWFsZSBZYW8gPHlhb2ppYWxlMDJAMTYzLmNvbT4KPi0tLQo+
IGRyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZGV2LXY1LmMgfCA0ICsrKysKPiAxIGZpbGUgY2hhbmdl
ZCwgNCBpbnNlcnRpb25zKCspCj4KPmRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9jY3AvY2Nw
LWRldi12NS5jIGIvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYtdjUuYwo+aW5kZXggZGNkNmFh
YjUxZTQ3Li5kYWNkZTk2MTRlOGEgMTAwNjQ0Cj4tLS0gYS9kcml2ZXJzL2NyeXB0by9jY3AvY2Nw
LWRldi12NS5jCj4rKysgYi9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi12NS5jCj5AQCAtOTk1
LDYgKzk5NSw4IEBAIHN0YXRpYyBpbnQgY2NwNV9pbml0KHN0cnVjdCBjY3BfZGV2aWNlICpjY3Ap
Cj4gCj4gZV9pcnE6Cj4gCXNwX2ZyZWVfY2NwX2lycShjY3AtPnNwLCBjY3ApOwo+KwlpZiAoY2Nw
LT51c2VfdGFza2xldCkKPisJCXRhc2tsZXRfa2lsbCgmY2NwLT5pcnFfdGFza2xldCk7Cj4gCj4g
ZV9wb29sOgo+IAlmb3IgKGkgPSAwOyBpIDwgY2NwLT5jbWRfcV9jb3VudDsgaSsrKQo+QEAgLTEw
NDYsNiArMTA0OCw4IEBAIHN0YXRpYyB2b2lkIGNjcDVfZGVzdHJveShzdHJ1Y3QgY2NwX2Rldmlj
ZSAqY2NwKQo+IAkJCWt0aHJlYWRfc3RvcChjY3AtPmNtZF9xW2ldLmt0aHJlYWQpOwo+IAo+IAlz
cF9mcmVlX2NjcF9pcnEoY2NwLT5zcCwgY2NwKTsKPisJaWYgKGNjcC0+dXNlX3Rhc2tsZXQpCj4r
CQl0YXNrbGV0X2tpbGwoJmNjcC0+aXJxX3Rhc2tsZXQpOwo+IAo+IAkvKiBGbHVzaCB0aGUgY21k
IGFuZCBiYWNrbG9nIHF1ZXVlICovCj4gCXdoaWxlICghbGlzdF9lbXB0eSgmY2NwLT5jbWQpKSB7
Cj4tLSAKPjIuMzQuMQo=
