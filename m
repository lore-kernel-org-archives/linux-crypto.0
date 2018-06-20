From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 01/11] crypto: shash: Remove VLA usage
Date: Wed, 20 Jun 2018 13:42:41 -0700
Message-ID: <CAGXu5jJe4k6ijfr9nk-uTZmuhZ+WxGnGBG_sh5ZqJQOuTcDpTQ@mail.gmail.com>
References: <20180620190408.45104-1-keescook@chromium.org>
	<20180620190408.45104-2-keescook@chromium.org>
	<638faf05-946a-1345-dda4-f75fee5b07d9@c-s.fr>
	<CAGXu5jKmZ2jn1V8rd3B5BcS0z_WOj0x4eThSG=DYdxSj+fnd2g@mail.gmail.com>
	<073a8f9e-8ad5-6fd5-e9b8-33e2c9a65e37@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	qat-linux@intel.com, LKML <linux-kernel@vger.kernel.org>,
	dm-devel@redhat.com, linux-crypto <linux-crypto@vger.kernel.org>,
	Lars Persson <larper@axis.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>, Alasdair Kergon <agk@redhat.com>,
	Rabin Vincent <rabinv@axis.com>
To: Christophe LEROY <christophe.leroy@c-s.fr>, Arnd Bergmann <arnd@arndb.de>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <073a8f9e-8ad5-6fd5-e9b8-33e2c9a65e37@c-s.fr>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

T24gV2VkLCBKdW4gMjAsIDIwMTggYXQgMTozOSBQTSwgQ2hyaXN0b3BoZSBMRVJPWQo8Y2hyaXN0
b3BoZS5sZXJveUBjLXMuZnI+IHdyb3RlOgo+Cj4KPiBMZSAyMC8wNi8yMDE4IMOgIDIyOjM2LCBL
ZWVzIENvb2sgYSDDqWNyaXQgOgo+Pgo+PiBPbiBXZWQsIEp1biAyMCwgMjAxOCBhdCAxMjozMCBQ
TSwgQ2hyaXN0b3BoZSBMZXJveQo+PiA8Y2hyaXN0b3BoZS5sZXJveUBjLXMuZnI+IHdyb3RlOgo+
Pj4KPj4+Cj4+Pgo+Pj4gT24gMDYvMjAvMjAxOCAwNzowMyBQTSwgS2VlcyBDb29rIHdyb3RlOgo+
Pj4+Cj4+Pj4KPj4+PiBJbiB0aGUgcXVlc3QgdG8gcmVtb3ZlIGFsbCBzdGFjayBWTEEgdXNhZ2Ug
ZnJvbSB0aGUga2VybmVsWzFdLCB0aGlzCj4+Pj4gcmVtb3ZlcyB0aGUgVkxBcyBpbiBTSEFTSF9E
RVNDX09OX1NUQUNLICh2aWEgY3J5cHRvX3NoYXNoX2Rlc2NzaXplKCkpCj4+Pj4gYnkgdXNpbmcg
dGhlIG1heGltdW0gYWxsb3dhYmxlIHNpemUgKHdoaWNoIGlzIG5vdyBtb3JlIGNsZWFybHkgY2Fw
dHVyZWQKPj4+PiBpbiBhIG1hY3JvKS4gU2ltaWxhciBsaW1pdHMgYXJlIHR1cm5lZCBpbnRvIG1h
Y3JvcyBhcyB3ZWxsLgo+Pj4+Cj4+Pj4gWzFdCj4+Pj4KPj4+PiBodHRwczovL2xrbWwua2VybmVs
Lm9yZy9yL0NBKzU1YUZ6Q0ctek5tWndYNEEyRlFwYWRhZkxmRXpLNkNDPXFQWHlkQWFjVTFScVpX
QUBtYWlsLmdtYWlsLmNvbQo+Pj4+Cj4+Pj4gU2lnbmVkLW9mZi1ieTogS2VlcyBDb29rIDxrZWVz
Y29va0BjaHJvbWl1bS5vcmc+Cj4+Pgo+Pj4KPj4+Cj4+PiBHb3QgdGhlIGZvbGxvd2luZyB3YXJu
aW5nczoKPj4+Cj4+PiBjcnlwdG8vdGVzdG1nci5jOiBJbiBmdW5jdGlvbiDigJhhbGdfdGVzdF9j
cmMzMmMucGFydC404oCZOgo+Pj4gY3J5cHRvL3Rlc3RtZ3IuYzoxODk2OjE6IHdhcm5pbmc6IHRo
ZSBmcmFtZSBzaXplIG9mIDIwODggYnl0ZXMgaXMgbGFyZ2VyCj4+PiB0aGFuIDEwMjQgYnl0ZXMg
Wy1XZnJhbWUtbGFyZ2VyLXRoYW49XQo+Pj4gY3J5cHRvL2htYWMuYzogSW4gZnVuY3Rpb24g4oCY
aG1hY19zZXRrZXnigJk6Cj4+PiBjcnlwdG8vaG1hYy5jOjg4OjE6IHdhcm5pbmc6IHRoZSBmcmFt
ZSBzaXplIG9mIDIwODggYnl0ZXMgaXMgbGFyZ2VyIHRoYW4KPj4+IDEwMjQgYnl0ZXMgWy1XZnJh
bWUtbGFyZ2VyLXRoYW49XQo+Pgo+Pgo+PiBBaCB5ZXMuIEkgZGlkbid0IGRvIDMyLWJpdCBidWls
ZHMuIFNvLCBoZXJlJ3MgdGhlIGlzc3VlOiB0aGlzIHVuY292ZXJzCj4+IHRoZSBmcmFtZSBzaXpl
IHByb2JsZW1zIHRoYXQgd2VyZSBoaWRkZW4gYnkgaW4gYmVpbmcgYSBWTEEgYmVmb3JlLiBJdAo+
PiB3YXMgYWx3YXlzIHBvc3NpYmxlIGZvciB0aGUgZnJhbWUgdG8gZ2V0IHRoaXMgYmlnLCBpdCdz
IGp1c3QgdGhhdCB0aGUKPj4gY29tcGlsZXIgY291bGRuJ3Qgc2VlIGl0Lgo+Pgo+PiBGb3IgcWF0
LCBJIHJhaXNlZCB0aGUgLVdmcmFtZS1sYXJnZXItdGhhbiBmbGFnLiBJdCBzZWVtcyB3ZSdsbCBu
ZWVkIHRvCj4+IGRvIHRoaXMgaW4gc29tZSBvdGhlciBwbGFjZXMgdG9vLgo+Cj4KPiBNYXliZSB0
aGUgaXNzdWUgaXMgYmVjYXVzZSBJIGhhdmUgc2VsZWN0ZWQgMTZrIHBhZ2VzID8KClRoYXQgd291
bGQgZG8gaXQhIEFuZCB0aGF0J3MgZXhhY3RseSB0aGUgcHJvYmxlbSBBcm5kIG1lbnRpb25lZC4g
Rm9yCnYyLCBJIHdpbGwgc3dpdGNoIGFsbCB0aGUgUEFHRV9TSVpFLXJlbGF0ZWQgbGltaXRzIHRv
IGFuIGV4cGxpY2l0IDUxMi4KKEFuZCBJJ2xsIGRvIHNvbWUgMzItYml0IGJ1aWxkcyB0b28gdG8g
c2VlIGlmIGFueSBvdGhlciBjYXNlcyBwb3AgdXAKdGhhdCBJIG5lZWQgdG8gbWFzayBvdXQuKQoK
LUtlZXMKCi0tIApLZWVzIENvb2sKUGl4ZWwgU2VjdXJpdHkKCi0tCmRtLWRldmVsIG1haWxpbmcg
bGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9s
aXN0aW5mby9kbS1kZXZlbA==
