From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH v2 5/5] crypto: talitos: Add software backlog queue
 handling
Date: Mon, 16 Mar 2015 19:19:35 -0500
Message-ID: <20150316191935.81f89e0dafebbbe76ffcb0c0@freescale.com>
References: <1425388897-5434-1-git-send-email-mort@bork.org>
 <1425388897-5434-6-git-send-email-mort@bork.org>
 <20150303182332.546523088b5891a776880c0f@freescale.com>
 <5506AA4B.303@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Scott Wood <scottwood@freescale.com>, Martin Hicks <mort@bork.org>,
 linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
To: Horia =?UTF-8?B?R2VhbnTEgw==?= <horia.geanta@freescale.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <5506AA4B.303@freescale.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

T24gTW9uLCAxNiBNYXIgMjAxNSAxMjowMjo1MSArMDIwMApIb3JpYSBHZWFudMSDIDxob3JpYS5n
ZWFudGFAZnJlZXNjYWxlLmNvbT4gd3JvdGU6Cgo+IE9uIDMvNC8yMDE1IDI6MjMgQU0sIEtpbSBQ
aGlsbGlwcyB3cm90ZToKPiA+IE9ubHkgcG90ZW50aWFsIHByb2JsZW0gaXMgZ2V0dGluZyB0aGUg
Y3J5cHRvIEFQSSB0byBzZXQgdGhlIEdGUF9ETUEKPiA+IGZsYWcgaW4gdGhlIGFsbG9jYXRpb24g
cmVxdWVzdCwgYnV0IHByZXN1bWFibHkgYQo+ID4gQ1JZUFRPX1RGTV9SRVFfRE1BIGNydF9mbGFn
IGNhbiBiZSBtYWRlIHRvIGhhbmRsZSB0aGF0Lgo+IAo+IFNlZW1zIHRoZXJlIGFyZSBxdWl0ZSBh
IGZldyBwbGFjZXMgdGhhdCBkbyBub3QgdXNlIHRoZQo+IHthZWFkLGFibGtjaXBoZXJfYWhhc2h9
X3JlcXVlc3RfYWxsb2MoKSBBUEkgdG8gYWxsb2NhdGUgY3J5cHRvIHJlcXVlc3RzLgo+IEFtb25n
IHRoZW0sIElQc2VjIGFuZCBkbS1jcnlwdC4KPiBJJ3ZlIGxvb2tlZCBhdCB0aGUgY29kZSBhbmQg
SSBkb24ndCB0aGluayBpdCBjYW4gYmUgY29udmVydGVkIHRvIHVzZQo+IGNyeXB0byBBUEkuCgp3
aHkgbm90PwoKPiBUaGlzIG1lYW5zIHRoYXQgdGhlIENSWVBUT19URk1fUkVRX0RNQSB3b3VsZCBi
ZSB2aXNpYmxlIHRvIGFsbCBvZiB0aGVzZQo+IHBsYWNlcy4gU29tZSBvZiB0aGUgbWFpbnRhaW5l
cnMgZG8gbm90IGFncmVlLCBhcyB5b3UndmUgc2Vlbi4KCndvdWxkIG1vZGlmeWluZyB0aGUgY3J5
cHRvIEFQSSB0byBlaXRoZXIgaGF2ZSBhIGRpZmZlcmVudAoqX3JlcXVlc3RfYWxsb2MoKSBBUEks
IGFuZC9vciBhZGRpbmcgY2FsbHMgdG8gbmVnb3RpYXRlIHRoZSBHRlAgbWFzawpiZXR3ZWVuIGNy
eXB0byB1c2VycyBhbmQgZHJpdmVycywgZS5nLiwgZ2V0L3NldF9nZnBfbWFzaywgd29yaz8KCj4g
QW4gYWx0ZXJuYXRpdmUgd291bGQgYmUgZm9yIHRhbGl0b3MgdG8gdXNlIHRoZSBwYWdlIGFsbG9j
YXRvciB0byBnZXQgMSAvCj4gMiBwYWdlcyBhdCBwcm9iZSB0aW1lICg0IGNoYW5uZWxzIHggMzIg
ZW50cmllcy9jaGFubmVsIHggNjRCL2Rlc2NyaXB0b3IKPiA9IDgga0IpLCBkbWFfbWFwX3BhZ2Ug
dGhlIGFyZWEgYW5kIG1hbmFnZSBpdCBpbnRlcm5hbGx5IGZvciB0YWxpdG9zX2Rlc2MKPiBodyBk
ZXNjcmlwdG9ycy4KPiBXaGF0IGRvIHlvdSB0aGluaz8KClRoZXJlJ3MgYSBjb21tZW50IGluIGVz
cF9hbGxvY190bXAoKTogIlVzZSBzcGFyZSBzcGFjZSBpbiBza2IgZm9yCnRoaXMgd2hlcmUgcG9z
c2libGUsIiB3aGljaCBpcyBpZGVhbGx5IHdoZXJlIHdlJ2Qgd2FudCB0byBiZSAoZXNwLgpiZWNh
dXNlIHRoYXQgbWVtb3J5IGNvdWxkIGFscmVhZHkgYmUgRE1BLWFibGUpLiAgWW91ciBhYm92ZQpz
dWdnZXN0aW9uIHdvdWxkIGJlIGluIHRoZSBvcHBvc2l0ZSBkaXJlY3Rpb24gb2YgdGhhdC4KCktp
bQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eHBw
Yy1kZXYgbWFpbGluZyBsaXN0CkxpbnV4cHBjLWRldkBsaXN0cy5vemxhYnMub3JnCmh0dHBzOi8v
bGlzdHMub3psYWJzLm9yZy9saXN0aW5mby9saW51eHBwYy1kZXY=
