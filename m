Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C37B485502;
	Mon, 19 Oct 2026 06:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392165; cv=none; b=jEvdAxPuXIFjRDGehiIGuTFSaidS79PV4ZYE7kn8l++aL2JNt6cSBK3InbB6wcqgWIV8hWm/Y3Ki9Mz2ScDxfFCDEbJCgu06LmHa3YHNtpk8ptGW1te3ECea7YEICw4jBQSf8L/GKTbVP+/Vcx0/llC6O6mSYC7o6YlzHU68YHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392165; c=relaxed/simple;
	bh=mG0ssjMFAqzBF8Nmuf2BLS/qbjtCpjzqJbiwQCoLYB8=;
	h=Date:From:To:Cc:Subject:References:Mime-Version:Message-ID:
	 Content-Type; b=Dg9b+YqaXz6iODHFYol/KS5Cs15inMsU5ItQY5KLJYPo0ch/uRPsZy89JHPLnYivfZXWnmltnndffv6fK9SCsKEICQYSdFu+oi7mD/cQE2zVnQrVg2s8CrL/4+8GoW0JP4oJA+fmM9DtwgPauNFzwDy9YBMM7lmoUzwETrh8REM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=iqxCGKaQ; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="iqxCGKaQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1792392110;
	bh=mG0ssjMFAqzBF8Nmuf2BLS/qbjtCpjzqJbiwQCoLYB8=;
	h=Date:From:To:Subject:Mime-Version:Message-ID;
	b=iqxCGKaQ+kEKq3DeKjS7A37YJuOoPKMFc67+kcwN+T1C6S4+9s7ZMuJp/3AVWhFBP
	 sgayQYJlEzHl82rIRIsKAR+uQXL5dOnTed0scLUt+Eku9HOV4bgmcrVeY+8r0pgY2I
	 Rmpg2H8Lq4GDo0jN26CatkmpLQ76UTtc+QOoiGgE=
X-QQ-mid: esmtpsz19t1792392103t79caaa3a
X-QQ-Originating-IP: 4FLorRqvu9ksBRu2FZoUp74sIwk0o+b3lTnhR8E8luQ=
Received: from PEN002676 ( [1.202.39.170])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 19 Oct 2026 14:41:40 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 18404627450710380155
Date: Mon, 19 Oct 2026 14:41:41 +0800
From: =?GB2312?B?1dS98MP3?= <zhaojinming@uniontech.com>
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: brgl <brgl@kernel.org>, 
	herbert <herbert@gondor.apana.org.au>, 
	davem <davem@davemloft.net>, 
	thara.gopinath <thara.gopinath@linaro.org>, 
	linux-crypto <linux-crypto@vger.kernel.org>, 
	linux-arm-msm <linux-arm-msm@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	stable <stable@vger.kernel.org>
Subject: Re: [PATCH 0/3] crypto: qce - fix CCM AAD buffer leak and the AEAD error paths
References: <20261016-fix-qce-ccm-adata-leak-v1-0-f54a82af2de0@uniontech.com>, 
	<20261016155628.GA3947801@google.com>
X-Priority: 3
X-GUID: 9191DB10-C88B-4DAC-A051-F800609F7DC6
X-Has-Attach: no
X-Mailer: Foxmail 7.2.25.375[cn]
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <CA7A5103C91FA945+2026101914414023542111@uniontech.com>
Content-Type: text/plain;
	charset="GB2312"
Content-Transfer-Encoding: base64
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: NWLpwLZrMWrIHCw6m4REeHpuAj5h5Im2QmkeMWqQjSWN/KQwphzej+Vc
	LikyNJdugrwl9xe+YTFW1lh9h2oR7yTvSq8bZTW/77ultkE2XsO2ep6PDGPKs20drYR5jno
	VkVYxX5KdULe+u4b2AhnxtuoZanFcM4dvhgbYCdpQXBRO+GC+bmfFZ/FaKJoKwByPyIOUr8
	GymCAeQchuRp+DfgtofuZvP5CZ4modil+TCKy1AnfaVQhKT+4VrgddGFNrzWFbY+ztgya4d
	NT3cdh6G5BxIG02+xmUQ2QspAGh/MkxCyxNIRnzpCXv1u/m3w6xTb5zca5QVTr7sacXwFYS
	vyqtydrJHjBOGBpuRhbCamFWI3d6XmrdAKCKqOF0jwXk62Vnoh0+eM0sap5hvcs+UI5mcMe
	D0YLUtIR39gklHpjVSrkM8hpucEe02It616RoFlLEF4NBVeh3MkdeOmaQDueJoOwMiB542G
	nZCsTaDwVRI5scrEQa+QeFpWpvAY5cK2n6yqQ7Gkf+41eoe3KoOSrQDyJvpw5jr7V44Lpw2
	V3DE2x1k1etGcgZosu8BtlgkB3afAgfliMYpsQkroNnuvg4wsMAnxT6KiJxZurTzByTwxbE
	ul0wylheGEzlPlLxydSLg8Tz7rAiTYV2i09jt0+rDCvSzniJVw5Zw99W8fx7q5DyoM6IIsL
	mqxOC+c7SjdvuwJgjEjGjonngrz40cMcBDUn83Hgv7niXDkh+ujFtF4L0J97stsdzG69nE7
	SDzHNqkoSQsJJnUkBhPO7lnjwNkNlhtQDpyL7mUXBGoU85IATorcbCveQjrTqlJr7rkLaiU
	bDdCf69lRqWxLiEJ5HDWyXuxGAWZtsxLAlVyegDEnRsVPblEwnyfP2eB5MbyGMTSIynLXOD
	Qmvqveaa2mxHpX9dR+MFZle7qXI2FxG+HHdWFLEMKwRWxIkwjVfzJu5zBEq+ub5AoPg4j2L
	Zc8HR1QdO+FvHKzRlZB3GnBBC+SNcBIXzEg6DULqWsROxWKGlRCPdOux/wz0pC/licVS1RN
	emDIOzBvzJcOLu72d89yUaUcThoQTsBK5ISkTw84VA1+LXJnXA2v6VNpiyKCY=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

CkhpIEVyaWMsCgpUaGFua3MgLSB5b3UncmUgcmlnaHQsIGFuZCBJIHNob3VsZCBoYXZlIGR1ZyB1
cCB0aGUgb3JpZ2luYWwgdGhyZWFkCmZpcnN0LiBUaGUgU2FzaGlrbyByZXZpZXcgb25seSBmbGFn
Z2VkIHRoZXNlIGFzIHByZS1leGlzdGluZzsgeW91CnJlcG9ydGVkIHRoZW0gZmlyc3QuIEknbGwg
Y3JlZGl0IHRoYXQgcHJvcGVybHkgYW5kIHJlc2VuZDoKCiAgICBSZXBvcnRlZC1ieTogRXJpYyBC
aWdnZXJzIDxlYmlnZ2Vyc0BrZXJuZWwub3JnPgogICAgTGluazogaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvbGludXgtY3J5cHRvLzIwMjYwNzIzMTgzNDM4LkdCOTM1MzRAcXVhcmsvCgpJJ2xsIGZv
bGQgdGhvc2UgdHJhaWxlcnMgaW4gYW5kIHNlbmQgYSB2MiBzaG9ydGx5LgoKVGhlIHJlbWFpbmlu
ZyBidWdzIHlvdSBsaXN0ZWQgYXJlIG9uIG15IHJhZGFyOyBJIGNhbiB0YWtlIHRoZW0gYXMKc2Vw
YXJhdGUgZm9sbG93LXVwcyB1bmxlc3MgeW91J2QgcHJlZmVyIG90aGVyd2lzZS4KClRoYW5rcywK
Wmhhb0ppbm1pbmcKCgoKPk9uIEZyaSwgT2N0IDE2LCAyMDI2IGF0IDEwOjA5OjQyQU0gKzA4MDAs
IFpoYW9KaW5taW5nIHdyb3RlOgoKCgo+PiBUaGlzIHNlcmllcyBmaXhlcyBhIG1lbW9yeSBsZWFr
IGluIHRoZSBRQ0UgQUVBRCBkcml2ZXIgdG9nZXRoZXIgd2l0aCB0d28KCgoKPj4gYnVncyBpbiB0
aGUgZXJyb3IgaGFuZGxpbmcgYXJvdW5kIGl0LgoKCgo+PiAKCgoKPj4gcWNlX2FlYWRfY2NtX3By
ZXBhcmVfYnVmX2Fzc29jbGVuKCkgYWxsb2NhdGVzIHJjdHgtPmFkYXRhIGZvciBldmVyeSBDQ00K
CgoKPj4gcmVxdWVzdCB0aGF0IGNhcnJpZXMgYXNzb2NpYXRlZCBkYXRhLCBidXQgdGhlIGJ1ZmZl
ciBpcyBuZXZlciBmcmVlZC4KCgoKPj4gCgoKCj4+IFdoaWxlIHByZXBhcmluZyB0aGF0IGZpeCwg
dHdvIHByb2JsZW1zIGluIHRoZSBlcnJvciBwYXRoIG9mCgoKCj4+IHFjZV9hZWFkX2FzeW5jX3Jl
cV9oYW5kbGUoKSB0dXJuZWQgb3V0IHRvIG1hdHRlcjoKCgoKPj4gCgoKCj4+Pz8gLSBJdCB1bm1h
cHMgcmVxLT5zcmMgYWx0aG91Z2ggcmN0eC0+c3JjX3NnIGlzIHRoZSBzY2F0dGVybGlzdCB0aGF0
IHdhcwoKCgo+Pj8/Pz8gcGFzc2VkIHRvIGRtYV9tYXBfc2coKS4/IEZvciBDQ00gcmVxdWVzdHMg
d2l0aCBhc3NvY2lhdGVkIGRhdGEsCgoKCj4+Pz8/PyByY3R4LT5zcmNfc2cgY2FycmllcyB0aGUg
QUFEIGJ1ZmZlciwgc28gaXRzIG1hcHBpbmcgaXMgbGVha2VkLCBhbmQKCgoKPj4/Pz8/IGZyZWVp
bmcgcmN0eC0+YWRhdGEgdGhlcmUgd291bGQgZnJlZSBtZW1vcnkgdGhhdCBpcyBzdGlsbCBETUEt
bWFwcGVkLgoKCgo+PiAKCgoKPj4/PyAtIEEgZG1hX21hcF9zZygpIGZhaWx1cmUgZm9yIHRoZSBz
b3VyY2Ugc2NhdHRlcmxpc3QgaXMgbm90IGRldGVjdGVkLAoKCgo+Pj8/Pz8gYmVjYXVzZSB0aGUg
cmVzdWx0IGlzIGNoZWNrZWQgZm9yIGEgbmVnYXRpdmUgdmFsdWUgd2hpbGUKCgoKPj4/Pz8/IGRt
YV9tYXBfc2coKSByZXR1cm5zIDAgb24gZmFpbHVyZS4/IFRoZSBlcnJvciBwYXRoIHRoZW4gdW5t
YXBzIGEKCgoKPj4/Pz8/IHNjYXR0ZXJsaXN0IHRoYXQgd2FzIG5ldmVyIG1hcHBlZC4KCgoKPj4g
CgoKCj4+IFBhdGNoIDEgdW5tYXBzIHRoZSBjb3JyZWN0IHNjYXR0ZXJsaXN0LCBwYXRjaCAyIGFk
ZHMgdGhlIG1pc3NpbmcgZnJlZXMKCgoKPj4gYW5kIHBhdGNoIDMgZml4ZXMgdGhlIGRtYV9tYXBf
c2coKSBjaGVjay4KCgoKPj4gCgoKCj4+IEFsbCB0aHJlZSB3ZXJlIHJlcG9ydGVkIGFzIHByZS1l
eGlzdGluZyBpbiB0aGUgU2FzaGlrbyByZXZpZXcgb2YgdGhlIFFDRQoKCgo+PiBCQU0gbG9ja2lu
ZyBzZXJpZXMuPyBUaGV5IHRvdWNoIHRoZSBzYW1lIGZ1bmN0aW9uIHRoYXQgd2FzIHJlY2VudGx5
IGZpeGVkCgoKCj4+IGJ5IGNvbW1pdCA3ZjIzNDVmNDdkZDEgKCJjcnlwdG86IHFjZSAtIGZpeCBD
Q00gQUFEIGJ1ZmZlcgoKCgo+PiB1bmRlcmFsbG9jYXRpb24iKS4KCgoKPgoKCgo+Tm90ZSB0aGF0
IEkgcmVwb3J0ZWQgdGhlc2UgYnVncyAoYW5kIG90aGVycyBzdGlsbCB1bmZpeGVkKSAzIG1vbnRo
cyBhZ286CgoKCj5odHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1jcnlwdG8vMjAyNjA3MjMx
ODM0MzguR0I5MzUzNEBxdWFyay8KCgoKPgoKCgo+LSBFcmljCgoKCj4KCgo=

