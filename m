Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567E5402BBE;
	Tue, 28 Apr 2026 12:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777380983; cv=none; b=DBGMJiYifr91HRRT82FhYrHooJrZ3ui+tw5hlYsNUGjILw9hRxN4w4KqwGFGmmzxvpyHb1Cs7RJGTHa36vdR6FfMiAOsG+nwJ5WU3bsBjITsLBCFCcNpIxPo5k2nBNkiPdDcxrjOWzZQXeE2e0GRjcE++BRKM6AO2L69dcuLv/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777380983; c=relaxed/simple;
	bh=3LZCtvQyQQ4G9qvBdWsxGvE48csnHu6g4bVvkSdatkg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tezeiIrwNO/KEAE6QakIR4MEPAwt8rLjcmFJiGkYKiUBYE7Vp2+0nwil3gmPV56Bq4Kjx8NMTYG9bOP/yqkDPprnVzenGuJEAHnzJjSP8+hxGDh9ODbgxUOniy7xObAswdh8cSQ0rnCg14uAx242n82PMYZzYSl0qs7E1HfXQgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=RH9Kh2bI; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="RH9Kh2bI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xry111.site;
	s=default; t=1777380959;
	bh=3LZCtvQyQQ4G9qvBdWsxGvE48csnHu6g4bVvkSdatkg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=RH9Kh2bIgrRUVjMbXmABLFO+Oasyqmsd+cuNpKkwPZYUql3B/uQYIrNt/2R0it3+l
	 KczNBXtbIbn4L3wWejQuDnYB5pp+EjwA2uAyBG1E3DUZm387ZjO5EH4dsft8lVDfW6
	 C044ohcZLZ0T6gjVLhnlmfcIqiyrB6e/YtQLElBA=
Received: from [127.0.0.1] (2607-8700-5500-e873-0000-0000-0000-1001.16clouds.com [IPv6:2607:8700:5500:e873::1001])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (secp384r1) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 60AB565992;
	Tue, 28 Apr 2026 08:55:58 -0400 (EDT)
Message-ID: <197d8afc8c6afe165e60c219b0a08ce6b6698ff9.camel@xry111.site>
Subject: Re: [PATCH v2] mfd: loongson-se: Add multi-node support
From: Xi Ruoyao <xry111@xry111.site>
To: Huacai Chen <chenhuacai@kernel.org>, Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: lee@kernel.org, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 	linux-crypto@vger.kernel.org
Date: Tue, 28 Apr 2026 20:55:56 +0800
In-Reply-To: <CAAhV-H7SYoN49ZoFi+4V=qyctdzJG0hD=WUBBozewkQzKYia5w@mail.gmail.com>
References: <20260427165133.23350-1-zhaoqunqin@loongson.cn>
	 <CAAhV-H7cYTW+6aHHtA9c77XMOhnUrAC_rW25s9d6+xED2oGyAw@mail.gmail.com>
	 <586ee1d1-c1c4-06fe-992f-c8e43cd9c778@loongson.cn>
	 <CAAhV-H7nbnLcYs=74pub6SXXrRRv-xPWTXN78wxaRPyGodUaxg@mail.gmail.com>
	 <9fd34867-9b1d-e097-f800-875efc6c44bd@loongson.cn>
	 <CAAhV-H7SYoN49ZoFi+4V=qyctdzJG0hD=WUBBozewkQzKYia5w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.60.1 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gTW9uLCAyMDI2LTA0LTI3IGF0IDE4OjAyICswODAwLCBIdWFjYWkgQ2hlbiB3cm90ZToKPiBP
biBNb24sIEFwciAyNywgMjAyNiBhdCA1OjUy4oCvUE0gUXVucWluIFpoYW8gPHpoYW9xdW5xaW5A
bG9vbmdzb24uY24+IHdyb3RlOgo+ID4gCj4gPiAKPiA+IOWcqCAyMDI2LzQvMjcg5LiL5Y2INToz
NywgSHVhY2FpIENoZW4g5YaZ6YGTOgo+ID4gPiBPbiBNb24sIEFwciAyNywgMjAyNiBhdCA1OjI0
4oCvUE0gUXVucWluIFpoYW8gPHpoYW9xdW5xaW5AbG9vbmdzb24uY24+IHdyb3RlOgo+ID4gPiA+
IAo+ID4gPiA+IOWcqCAyMDI2LzQvMjcg5LiL5Y2INTowMiwgSHVhY2FpIENoZW4g5YaZ6YGTOgo+
ID4gPiA+ID4gSGksIFF1bnFpbiwKPiA+ID4gPiA+IAo+ID4gPiA+ID4gT24gTW9uLCBBcHIgMjcs
IDIwMjYgYXQgNDo1NeKAr1BNIFF1bnFpbiBaaGFvCj4gPiA+ID4gPiA8emhhb3F1bnFpbkBsb29u
Z3Nvbi5jbj4gd3JvdGU6Cj4gPiA+ID4gPiA+IE9uIHRoZSBMb29uZ3NvbiBwbGF0Zm9ybSwgZWFj
aCBub2RlIGlzIGVxdWlwcGVkIHdpdGggYQo+ID4gPiA+ID4gPiBzZWN1cml0eSBlbmdpbmUKPiA+
ID4gPiA+ID4gZGV2aWNlLiBIb3dldmVyLCBkdWUgdG8gYSBoYXJkd2FyZSBmbGF3LCBvbmx5IHRo
ZSBkZXZpY2Ugb24KPiA+ID4gPiA+ID4gbm9kZSAwIGNhbgo+ID4gPiA+ID4gPiB0cmlnZ2VyIGlu
dGVycnVwdHMuIFRoZXJlZm9yZSwgaW50ZXJydXB0cyBmcm9tIG90aGVyIG5vZGVzCj4gPiA+ID4g
PiA+IGFyZSBmb3J3YXJkZWQKPiA+ID4gPiA+ID4gYnkgbm9kZSAwLiBXZSBuZWVkIHRvIGNoZWNr
IGluIHRoZSBpbnRlcnJ1cHQgaGFuZGxlciBvZiBub2RlCj4gPiA+ID4gPiA+IDAgd2hldGhlcgo+
ID4gPiA+ID4gPiB0aGlzIGludGVycnVwdCBpcyBpbnRlbmRlZCBmb3Igb3RoZXIgbm9kZXMuCj4g
PiA+ID4gPiBNdWx0aS1ub2RlIG9yIG11bHRpLXBhY2thZ2U/IEluIG15IG9waW5pb24gU0UgaGFz
IG5vCj4gPiA+ID4gPiByZWxhdGlvbnNoaXAgd2l0aAo+ID4gPiA+ID4gTlVNQSBub2RlLCBzbyBt
YXliZSBwYWNrYWdlPwo+ID4gPiA+IEhlcmUgaXMgdGhlIG91dHB1dCBvZiBsc2NwdSBmcm9tIG15
IG1hY2hpbmU6Cj4gPiA+ID4gCj4gPiA+ID4gW2xvb25nc29uQGxvY2FsaG9zdCB+XSQgbHNjcHUK
PiA+ID4gPiBBcmNoaXRlY3R1cmU6wqDCoMKgwqDCoMKgwqDCoMKgIGxvb25nYXJjaDY0Cj4gPiA+
ID4gwqDCoMKgIENQVSBvcC1tb2RlKHMpOsKgwqDCoMKgwqAgMzItYml0LCA2NC1iaXQKPiA+ID4g
PiDCoMKgwqAgQWRkcmVzcyBzaXplczrCoMKgwqDCoMKgwqAgNDggYml0cyBwaHlzaWNhbCwgNDgg
Yml0cyB2aXJ0dWFsCj4gPiA+ID4gwqDCoMKgIEJ5dGUgT3JkZXI6wqDCoMKgwqDCoMKgwqDCoMKg
IExpdHRsZSBFbmRpYW4KPiA+ID4gPiBDUFUocyk6wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIDEyOAo+ID4gPiA+IMKgwqDCoCBPbi1saW5lIENQVShzKSBsaXN0OiAwLTEyNwo+ID4gPiA+
IE1vZGVsIG5hbWU6wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBMb29uZ3Nvbi0zQzYwMDAvRAo+ID4g
PiA+IMKgwqDCoCBDUFUgZmFtaWx5OsKgwqDCoMKgwqDCoMKgwqDCoCBMb29uZ3Nvbi02NGJpdAo+
ID4gPiA+IMKgwqDCoCBNb2RlbDrCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDB4MTEKPiA+
ID4gPiDCoMKgwqAgVGhyZWFkKHMpIHBlciBjb3JlOsKgIDIKPiA+ID4gPiDCoMKgwqAgQ29yZShz
KSBwZXIgc29ja2V0OsKgIDMyCj4gPiA+ID4gwqDCoMKgIFNvY2tldChzKTrCoMKgwqDCoMKgwqDC
oMKgwqDCoCAyCj4gPiA+ID4gwqDCoMKgIEJvZ29NSVBTOsKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
NDIwMC4wMAo+ID4gPiA+IMKgwqDCoCBGbGFnczrCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGNwdWNmZyBsYW0gdWFsIGZwdSBsc3ggbGFzeCBjcmMzMgo+ID4gPiA+IGNvbXBsZXggY3J5cHRv
Cj4gPiA+ID4gbHZ6IGxidF94ODYgbGJ0X2FybSBsYnRfbWlwcwo+ID4gPiA+IENhY2hlcyAoc3Vt
IG9mIGFsbCk6Cj4gPiA+ID4gwqDCoMKgIEwxZDrCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCA0IE1pQiAoNjQgaW5zdGFuY2VzKQo+ID4gPiA+IMKgwqDCoCBMMWk6wqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgNCBNaUIgKDY0IGluc3RhbmNlcykKPiA+ID4gPiDCoMKgwqAg
TDI6wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAxNiBNaUIgKDY0IGluc3RhbmNl
cykKPiA+ID4gPiDCoMKgwqAgTDM6wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAx
MjggTWlCICg0IGluc3RhbmNlcykKPiA+ID4gPiBOVU1BOgo+ID4gPiA+IMKgwqDCoCBOVU1BIG5v
ZGUocyk6wqDCoMKgwqDCoMKgwqAgNAo+ID4gPiA+IMKgwqDCoCBOVU1BIG5vZGUwIENQVShzKTrC
oMKgIDAtMzEKPiA+ID4gPiDCoMKgwqAgTlVNQSBub2RlMSBDUFUocyk6wqDCoCAzMi02Mwo+ID4g
PiA+IMKgwqDCoCBOVU1BIG5vZGUyIENQVShzKTrCoMKgIDY0LTk1Cj4gPiA+ID4gwqDCoMKgIE5V
TUEgbm9kZTMgQ1BVKHMpOsKgwqAgOTYtMTI3Cj4gPiA+ID4gCj4gPiA+ID4gVGhlcmUgYXJlIGZv
dXIgU0UgZGV2aWNlcyBpbiBteSBzeXN0ZW0sIG9uZSBmb3IgZWFjaCBOVU1BIG5vZGUuCj4gPiA+
IEZvciBMb29uZ3Nvbi0zQzYwMDAgbm9kZSBpcyB0aGUgc2FtZSBhcyBwYWNrYWdlLiBZb3Ugc2hv
dWxkCj4gPiA+IGNvbnNpZGVyCj4gPiA+IExvb25nc29uLTNDNTAwMEwsIG9uZSBwYWNrYWdlIGNv
bnRhaW5zIGZvdXIgbm9kZXMuCj4gPiAKPiA+IEkgYW0gbm90IGZhbWlsaWFyIHdpdGggdGhlIFNF
LXJlbGF0ZWQgY29tcG9uZW50cyBvbiB0aGUgM0M1MDAwTCwgYW5kCj4gPiB0aGlzIGRyaXZlciBp
cyBub3QgY29tcGF0aWJsZSB3aXRoIHRoZSA1MDAwIHNlcmllcy4KPiBXaGV0aGVyIGl0IGlzIGNv
bXBhdGlibGUgdG8gTG9vbmdzb24tM0M1MDAwTCBpcyBub3QgaW1wb3J0YW50LiBUaGUKPiBpbXBv
cnRhbmNlIGlzIHBhY2thZ2UgaXMgbm90IGFsd2F5cyBlcXVhbCB0byBub2RlLCBhbmQgd2Ugc2hv
dWxkCj4gY29uc2lkZXIgd2hldGhlciBTRSBpcyBwZXItbm9kZSBvciBwZXItcGFja2FnZS4KCkZv
ciBhICJjb21wYXRpYmxlIiBleGFtcGxlLCAzQzYwMDAvRCBoYXMgdHdvIG5vZGVzIGluIGEgcGFj
a2FnZS4KCi0tIApYaSBSdW95YW8gPHhyeTExMUB4cnkxMTEuc2l0ZT4K

