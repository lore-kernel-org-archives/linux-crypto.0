From: Zain <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: Re: [PATCH v2 3/4] ARM: dts: rockchip: Add Crypto drivers for rk3288
Date: Fri, 6 Nov 2015 18:27:33 +0800
Message-ID: <563C8095.30905@rock-chips.com>
References: <1446772644-2352-1-git-send-email-zain.wang@rock-chips.com>
 <1446772644-2352-4-git-send-email-zain.wang@rock-chips.com>
 <4509145.eZ7GP0e6gb@phil>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org,
 hl-TNX95d0MmH7DzftRWevZcw@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org,
 mturquette-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
 eddie.cai-TNX95d0MmH7DzftRWevZcw@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
 zhengsq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org
To: Heiko Stuebner <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>
Return-path: <linux-rockchip-bounces+glpar-linux-rockchip=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <4509145.eZ7GP0e6gb@phil>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-rockchip>,
 <mailto:linux-rockchip-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-rockchip/>
List-Post: <mailto:linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-rockchip-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-rockchip>,
 <mailto:linux-rockchip-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-rockchip" <linux-rockchip-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-rockchip-bounces+glpar-linux-rockchip=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

CgpPbiAyMDE15bm0MTHmnIgwNuaXpSAxODoxMiwgSGVpa28gU3R1ZWJuZXIgd3JvdGU6Cj4gQW0g
RnJlaXRhZywgNi4gTm92ZW1iZXIgMjAxNSwgMDk6MTc6MjMgc2NocmllYiBaYWluIFdhbmc6Cj4+
IEFkZCBDcnlwdG8gZHJpdmVycyBmb3IgcmszMjg4IGluY2x1ZGluZyBjcnlwdG8gY29udHJvbGxl
ciBhbmQgZG1hIGNsay4KPj4KPj4gU2lnbmVkLW9mZi1ieTogWmFpbiBXYW5nIDx6YWluLndhbmdA
cm9jay1jaGlwcy5jb20+Cj4+IC0tLQo+Pgo+PiBDaGFuZ2VkIGluIHYyOgo+PiAtIE5vbmUKPj4K
Pj4gQ2hhbmdlZCBpbiB2MToKPj4gLSByZW1vdmUgdGhlIF9jcnlwdG8gc3VmZml4Cj4+IC0gdXNl
ICJyb2NrY2hpcCxyazMyODgtY3J5cHRvIiBpbnN0ZWFkIG9mICJyb2NrY2hpcCxyazMyODgiCj4+
Cj4+ICBhcmNoL2FybS9ib290L2R0cy9yazMyODguZHRzaSB8IDE1ICsrKysrKysrKysrKysrKwo+
PiAgMSBmaWxlIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKykKPj4KPj4gZGlmZiAtLWdpdCBhL2Fy
Y2gvYXJtL2Jvb3QvZHRzL3JrMzI4OC5kdHNpIGIvYXJjaC9hcm0vYm9vdC9kdHMvcmszMjg4LmR0
c2kKPj4gaW5kZXggNmE3OWM5Yy4uN2I3OTE0ZSAxMDA2NDQKPj4gLS0tIGEvYXJjaC9hcm0vYm9v
dC9kdHMvcmszMjg4LmR0c2kKPj4gKysrIGIvYXJjaC9hcm0vYm9vdC9kdHMvcmszMjg4LmR0c2kK
Pj4gQEAgLTE3MCw2ICsxNzAsMjEgQEAKPj4gIAkJfTsKPj4gIAl9Owo+PiAgCj4+ICsJY3J5cHRv
OiBjeXB0by1jb250cm9sbGVyQGZmOGEwMDAwIHsKPj4gKwkJY29tcGF0aWJsZSA9ICJyb2NrY2hp
cCxyazMyODgtY3J5cHRvIjsKPj4gKwkJcmVnID0gPDB4ZmY4YTAwMDAgMHg0MDAwPjsKPj4gKwkJ
aW50ZXJydXB0cyA9IDxHSUNfU1BJIDQ4IElSUV9UWVBFX0xFVkVMX0hJR0g+Owo+PiArCQljbG9j
a3MgPSA8JmNydSBBQ0xLX0NSWVBUTz4sCj4+ICsJCQkgPCZjcnUgSENMS19DUllQVE8+LAo+PiAr
CQkJIDwmY3J1IFNDTEtfQ1JZUFRPPiwKPj4gKwkJCSA8JmNydSBBQ0xLX0RNQUMxPjsKPj4gKwkJ
Y2xvY2stbmFtZXMgPSAiYWNsayIsCj4+ICsJCQkgICAgICAiaGNsayIsCj4+ICsJCQkgICAgICAi
c2NsayIsCj4+ICsJCQkgICAgICAiYXBiX3BjbGsiOwo+PiArCQlzdGF0dXMgPSAib2theSI7Cj4+
ICsJfTsKPj4gKwo+IHBsZWFzZSBtb3ZlIHRoYXQgd2hvbGUgbm9kZSB0byB0aGUgcmlnaHQgbG9j
YXRpb24uIEVudHJpZXMgYXJlIHNvcnRlZCBieSAKPiByZWdpc3RlciBhZGRyZXNzICh0aGUgZmY4
YTAwMDAgc2hvdWxkIHRoZW4gb2YgY291cnNlIGJlIGJlbG93ICBpMnNAZmY4OTAwMDAgCj4gYW5k
IGFib3ZlIHZvcEBmZjkzMDAwMCkKb2shIGRvbmUhCj4KPgo+PiAgCXJlc2VydmVkLW1lbW9yeSB7
Cj4+ICAJCSNhZGRyZXNzLWNlbGxzID0gPDE+Owo+PiAgCQkjc2l6ZS1jZWxscyA9IDwxPjsKPj4K
Pgo+Cj4KCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
TGludXgtcm9ja2NoaXAgbWFpbGluZyBsaXN0CkxpbnV4LXJvY2tjaGlwQGxpc3RzLmluZnJhZGVh
ZC5vcmcKaHR0cDovL2xpc3RzLmluZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1y
b2NrY2hpcAo=
