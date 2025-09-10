Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1111E1798F;
	Wed, 10 Sep 2025 06:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.29.241.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757487538; cv=none; b=ogPJvlqLBFzttsItbNzC8sMJ5FOyO3syClbFXkbA15HlMFYrc6gxL4bScHAIZ2Ta09KxlzvKFGTyM/1qPpY+1OZ/a66VITfWPhI67utaWUTHWALvndkcFgHMhJife3iyei/+ikMPROwePzeWe2tDWHyOZFSwVK7cFe1/q7IqsbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757487538; c=relaxed/simple;
	bh=KtbgRtg//fqWfjWdTmRs7c1F/bK6SAHJGEEEnummDn4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AQykZ3UOIu5tOgJ/f5UpBtmZsabXC3dsXFlmsOK6idNOaXaScOYx8hjHqG8orsmF3QfamO2JPB58HhZ3/WX0nKeaHM0+WL8wnT8MImjUUsuGuHXlBJpB/3V3GDc6bfKDjXeaxEB2y/U4/nXysPjrhSNUHAw+my7cUp4zbxsNOPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codeconstruct.com.au; spf=pass smtp.mailfrom=codeconstruct.com.au; dkim=pass (2048-bit key) header.d=codeconstruct.com.au header.i=@codeconstruct.com.au header.b=NkFW3CiV; arc=none smtp.client-ip=203.29.241.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codeconstruct.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codeconstruct.com.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codeconstruct.com.au header.i=@codeconstruct.com.au header.b="NkFW3CiV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=codeconstruct.com.au; s=2022a; t=1757487534;
	bh=KtbgRtg//fqWfjWdTmRs7c1F/bK6SAHJGEEEnummDn4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=NkFW3CiVPTwd0wTpMajw9sGYLPA6GzaOFZrdG6scboFuIUzmRb5nZAlcTptUZynta
	 UyGNdUUDSJPeerKSdsIH6NdXx3jvs+5TrzZnT3bL+yVHAD0XLOu7JsmdkbXppxIgU5
	 5wOx6xH6lkE7XPOy3sknrTy3RHq+f2kSBsJn0xLstyvKHXuG8vr/lSMGXK6oeaeHgs
	 OFj0aTU3RbWIGpUiB3Tj3jIfyGqT9NRs32kZC+CpJs1I1iiiHC6+z2OtK0j5MrI3Qp
	 cD40/Ot5ji962Nx43M4FJW7ev58n6TC3fjcjpPamLxqkg/u/a9YJO3WDY6wpOZ0juH
	 D5HVjxJCP30IQ==
Received: from [192.168.68.113] (unknown [180.150.112.213])
	by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 2B54E6443C;
	Wed, 10 Sep 2025 14:58:53 +0800 (AWST)
Message-ID: <8d7b13b2eb51929ca2c1c3040b9fcf9f7dd16412.camel@codeconstruct.com.au>
Subject: Re: [PATCH] crypto: aspeed - Fix dma_unmap_sg() direction
From: Andrew Jeffery <andrew@codeconstruct.com.au>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: stable@vger.kernel.org, Neal Liu <neal_liu@aspeedtech.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 Joel Stanley <joel@jms.id.au>, Dhananjay Phadke
 <dphadke@linux.microsoft.com>, Johnny Huang <johnny_huang@aspeedtech.com>,
 linux-aspeed@lists.ozlabs.org,  linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,  linux-kernel@vger.kernel.org
Date: Wed, 10 Sep 2025 16:28:42 +0930
In-Reply-To: <20250905115112.26309-2-fourier.thomas@gmail.com>
References: <20250905115112.26309-2-fourier.thomas@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gRnJpLCAyMDI1LTA5LTA1IGF0IDEzOjUxICswMjAwLCBUaG9tYXMgRm91cmllciB3cm90ZToK
PiBJdCBzZWVtcyBsaWtlIGV2ZXJ5d2hlcmUgaW4gdGhpcyBmaWxlLCB3aGVuIHRoZSByZXF1ZXN0
IGlzIG5vdAo+IGJpZGlyZWN0aW9uYWwsIHJlcS0+c3JjIGlzIG1hcHBlZCB3aXRoIERNQV9UT19E
RVZJQ0XCoAo+IAoKT2theSwgaG93ZXZlcjoKCj4gYW5kIHJlcS0+c3JjIGlzCj4gbWFwcGVkIHdp
dGggRE1BX0ZST01fREVWSUNFLgoKQnkgdGhlIHBhdGNoIGl0c2VsZiwgb25lIHNob3VsZCByZWZl
ciB0byByZXEtPmRzdD8KCkFuZHJldwoKPiAKPiBGaXhlczogNjJmNThiMTYzN2I3ICgiY3J5cHRv
OiBhc3BlZWQgLSBhZGQgSEFDRSBjcnlwdG8gZHJpdmVyIikKPiBDYzogPHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmc+Cj4gU2lnbmVkLW9mZi1ieTogVGhvbWFzIEZvdXJpZXIgPGZvdXJpZXIudGhvbWFz
QGdtYWlsLmNvbT4KPiAtLS0KPiDCoGRyaXZlcnMvY3J5cHRvL2FzcGVlZC9hc3BlZWQtaGFjZS1j
cnlwdG8uYyB8IDIgKy0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxl
dGlvbigtKQo+IAo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9hc3BlZWQvYXNwZWVkLWhh
Y2UtY3J5cHRvLmMgYi9kcml2ZXJzL2NyeXB0by9hc3BlZWQvYXNwZWVkLWhhY2UtY3J5cHRvLmMK
PiBpbmRleCBhNzJkZmViYzUzZmYuLmZhMjAxZGFlMWY4MSAxMDA2NDQKPiAtLS0gYS9kcml2ZXJz
L2NyeXB0by9hc3BlZWQvYXNwZWVkLWhhY2UtY3J5cHRvLmMKPiArKysgYi9kcml2ZXJzL2NyeXB0
by9hc3BlZWQvYXNwZWVkLWhhY2UtY3J5cHRvLmMKPiBAQCAtMzQ2LDcgKzM0Niw3IEBAIHN0YXRp
YyBpbnQgYXNwZWVkX3NrX3N0YXJ0X3NnKHN0cnVjdCBhc3BlZWRfaGFjZV9kZXYgKmhhY2VfZGV2
KQo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoH0gZWxzZSB7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBkbWFfdW5tYXBfc2coaGFjZV9kZXYtPmRldiwgcmVxLT5kc3QsIHJjdHgtPmRz
dF9uZW50cywKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIERNQV9UT19ERVZJQ0UpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgRE1BX0ZST01fREVWSUNFKTsKPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRtYV91bm1hcF9zZyhoYWNlX2Rldi0+ZGV2LCByZXEtPnNy
YywgcmN0eC0+c3JjX25lbnRzLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIERNQV9UT19ERVZJQ0UpOwo+IMKgwqDCoMKgwqDCoMKgwqB9
Cgo=

