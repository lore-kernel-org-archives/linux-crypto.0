Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Greylist: delayed 1143 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 26 Nov 2023 18:04:34 PST
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1CEA11F;
	Sun, 26 Nov 2023 18:04:34 -0800 (PST)
Received: from dinghao.liu$zju.edu.cn ( [10.190.70.34] ) by
 ajax-webmail-mail-app4 (Coremail) ; Mon, 27 Nov 2023 09:45:15 +0800
 (GMT+08:00)
Date: Mon, 27 Nov 2023 09:45:15 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: dinghao.liu@zju.edu.cn
To: "Tom Lendacky" <thomas.lendacky@amd.com>
Cc: "John Allen" <john.allen@amd.com>, 
	"Herbert Xu" <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp - fix memleak in ccp_init_dm_workarea
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.2-cmXT5 build
 20230825(e13b6a3b) Copyright (c) 2002-2023 www.mailtech.cn
 mispb-4df6dc2c-e274-4d1c-b502-72c5c3dfa9ce-zj.edu.cn
In-Reply-To: <3f033585-91c6-1d70-be1e-f083fc855aed@amd.com>
References: <20231123070337.11600-1-dinghao.liu@zju.edu.cn>
 <3f033585-91c6-1d70-be1e-f083fc855aed@amd.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <4b1593ec.5240.18c0e73be28.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:cS_KCgDHzTWs9GNl3FMYAA--.3571W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgsIBmVfIgMaAQAPsI
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

PiBPbiAxMS8yMy8yMyAwMTowMywgRGluZ2hhbyBMaXUgd3JvdGU6Cj4gPiBXaGVuIGRtYV9tYXBf
c2luZ2xlKCkgZmFpbHMsIHdlIHNob3VsZCBmcmVlIHdhLT5hZGRyZXNzIHRvCj4gPiBwcmV2ZW50
IHBvdGVudGlhbCBtZW1sZWFrLgo+IAo+IFlvdSBzaG91bGQgZXhwYW5kIG9uIHRoaXMgYSBiaXQg
bW9yZS4gVGhlIGNjcF9kbV9mcmVlKCkgZnVuY3Rpb24gaXMgCj4gbm9ybWFsbHkgY2FsbGVkIHRv
IGZyZWUgdGhhdCBtZW1vcnksIGJ1dCBtYW55IG9mIHRoZSBjYWxsIHNwb3RzIGRvbid0IAo+IGV4
cGVjdCB0byBoYXZlIHRvIGNhbGwgY2NwX2RtX2ZyZWUoKSBvbiBhbiBlcnJvciByZXR1cm4gZnJv
bSAKPiBjY3BfaW5pdF9kbV93b3JrYXJlYSgpLiBCZWNhdXNlIG9mIHRoYXQsIHRoZSBtZW1vcnkg
aXMgZnJlZWQgaW4gCj4gY2NwX2luaXRfZG1fd29ya2FyZWEoKS4KPiAKPiBTbyBhIG1vcmUgZGV0
YWlsZWQgY29tbWl0IG1lc3NhZ2UgYWJvdXQgd2h5IHRoaXMgY2hhbmdlIGlzIG5lZWRlZCBzaG91
bGQgCj4gYmUgcHJvdmlkZWQuCgpUaGFua3MgZm9yIHlvdXIgc3VnZ2VzdGlvbiEgSSB3aWxsIHJl
c2VuZCBhIG5ldyBwYXRjaCBzb29uLgoKPiAKPiA+IAo+ID4gRml4ZXM6IDYzYjk0NTA5MWEwNyAo
ImNyeXB0bzogY2NwIC0gQ0NQIGRldmljZSBkcml2ZXIgYW5kIGludGVyZmFjZSBzdXBwb3J0IikK
PiA+IFNpZ25lZC1vZmYtYnk6IERpbmdoYW8gTGl1IDxkaW5naGFvLmxpdUB6anUuZWR1LmNuPgo+
ID4gLS0tCj4gPiAgIGRyaXZlcnMvY3J5cHRvL2NjcC9jY3Atb3BzLmMgfCA0ICsrKy0KPiA+ICAg
MSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQo+ID4gCj4gPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1vcHMuYyBiL2RyaXZlcnMvY3J5cHRv
L2NjcC9jY3Atb3BzLmMKPiA+IGluZGV4IGFhNGUxYTUwMDY5MS4uNDU1NTJhZTYzNDdlIDEwMDY0
NAo+ID4gLS0tIGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1vcHMuYwo+ID4gKysrIGIvZHJpdmVy
cy9jcnlwdG8vY2NwL2NjcC1vcHMuYwo+ID4gQEAgLTE3OSw4ICsxNzksMTAgQEAgc3RhdGljIGlu
dCBjY3BfaW5pdF9kbV93b3JrYXJlYShzdHJ1Y3QgY2NwX2RtX3dvcmthcmVhICp3YSwKPiA+ICAg
Cj4gPiAgIAkJd2EtPmRtYS5hZGRyZXNzID0gZG1hX21hcF9zaW5nbGUod2EtPmRldiwgd2EtPmFk
ZHJlc3MsIGxlbiwKPiA+ICAgCQkJCQkJIGRpcik7Cj4gPiAtCQlpZiAoZG1hX21hcHBpbmdfZXJy
b3Iod2EtPmRldiwgd2EtPmRtYS5hZGRyZXNzKSkKPiA+ICsJCWlmIChkbWFfbWFwcGluZ19lcnJv
cih3YS0+ZGV2LCB3YS0+ZG1hLmFkZHJlc3MpKSB7Cj4gPiArCQkJa2ZyZWUod2EtPmFkZHJlc3Mp
Owo+IAo+IElmIGZ1dHVyZSBjaGFuZ2VzIHNob3VsZCByZXN1bHQgaW4gY2NwX2RtX2ZyZWUoKSBi
ZWluZyBjYWxsZWQgb24gYW4gZXJyb3IgCj4gcmV0dXJuZWQgZnJvbSBjY3BfaW5pdF9kbV93b3Jr
YXJlYSgpLCB5b3Ugc2hvdWxkIGFkZDoKPiAKPiAJCQl3YS0+YWRkcmVzcyA9IE5VTEw7Cj4gCgpJ
IHdpbGwgZml4IHRoaXMgaW4gdGhlIG5ldyBwYXRjaCwgdGhhbmtzIQoKUmVnYXJkcywKRGluZ2hh
bw==
