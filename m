From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 0/6] Add bulk skcipher requests to crypto
 API and dm-crypt
Date: Wed, 18 Jan 2017 12:48:28 +0800
Message-ID: <20170118044828.GB4460@gondor.apana.org.au>
References: <cover.1484215956.git.omosnacek@gmail.com>
	<20170113104128.GA23497@gondor.apana.org.au>
	<CAAUqJDtqN-ugcaz4VhuW0fzLbmKt4db8ggrRmaAq_zFvO+9Lvw@mail.gmail.com>
	<20170113142959.GA24258@gondor.apana.org.au>
	<CAAUqJDsrFp2CczN5Gyy=rYLSDKi7=vQTQoyh=pE1kWue=c=fvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Binoy Jayan <binoy.jayan@linaro.org>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
        linux-crypto@vger.kernel.org, Milan Broz <gmazyland@gmail.com>
To: Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAAUqJDsrFp2CczN5Gyy=rYLSDKi7=vQTQoyh=pE1kWue=c=fvw@mail.gmail.com>
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

T24gVHVlLCBKYW4gMTcsIDIwMTcgYXQgMTI6MjA6MDJQTSArMDEwMCwgT25kcmVqIE1vc27DocSN
ZWsgd3JvdGU6Cj4gMjAxNy0wMS0xMyAxNToyOSBHTVQrMDE6MDAgSGVyYmVydCBYdSA8aGVyYmVy
dEBnb25kb3IuYXBhbmEub3JnLmF1PjoKPiA+IFdoYXQgaWYgdGhlIGRyaXZlciBoYWQgaGFyZHdh
cmUgc3VwcG9ydCBmb3IgZ2VuZXJhdGluZyB0aGVzZSBJVnM/Cj4gPiBXaXRoIHlvdXIgc2NoZW1l
IHRoaXMgY2Fubm90IGJlIHN1cHBvcnRlZCBhdCBhbGwuCj4gCj4gVGhhdCdzIHRydWUuLi4gSSdt
IHN0YXJ0aW5nIHRvIHRoaW5rIHRoYXQgdGhpcyBpc24ndCByZWFsbHkgYSBnb29kCj4gaWRlYS4g
SSB3YXMgbWFpbmx5IHRyeWluZyB0byBrZWVwIHRoZSBkb29yIG9wZW4gZm9yIHRoZSByYW5kb20g
SVYKPiBzdXBwb3J0IGFuZCBhbHNvIHRvIGtlZXAgdGhlIG11bHRpLWtleSBzdHVmZiAod2hpY2gg
d2FzIHJlYWxseSBvbmx5Cj4gaW50ZW5kZWQgZm9yIGxvb3AtQUVTIHBhcnRpdGlvbiBzdXBwb3J0
KSBvdXQgb2YgdGhlIGNyeXB0byBBUEksIGJ1dAo+IGJvdGggb2YgdGhlc2UgY2FuIGJlIHByb2Jh
Ymx5IHNvbHZlZCBpbiBhIGJldHRlciB3YXkuLi4KCkFzIHlvdSBzYWlkIHRoYXQgdGhlIG11bHRp
LWtleSBzdHVmZiBpcyBsZWdhY3ktb25seSBJIHRvbyB3b3VsZCBsaWtlCnRvIHNlZSBhIHdheSB0
byBrZWVwIHRoYXQgY29tcGxleGl0eSBvdXQgb2YgdGhlIGNvbW1vbiBwYXRoLgoKPiA+IFdpdGgg
c3VjaCBhIGRlZmluaXRpb24geW91IGNvdWxkIGVpdGhlciBnZW5lcmF0ZSB0aGUgSVZzIGluIGRt
LWNyeXB0Cj4gPiBvciBoYXZlIHRoZW0gZ2VuZXJhdGVkIGluIHRoZSBJViBnZW5lcmF0b3IuCj4g
Cj4gVGhhdCBzZWVtcyBraW5kIG9mIGhhY2t5IHRvIG1lLi4uIGJ1dCBpZiB0aGF0J3Mgd2hhdCB5
b3UgcHJlZmVyLCB0aGVuIHNvIGJlIGl0LgoKSSdtIG9wZW4gdG8gb3RoZXIgcHJvcG9zYWxzLiAg
VGhlIGJhc2ljIHJlcXVpcmVtZW50IGlzIHRvIGJlIGFibGUgdG8KcHJvY2VzcyBtdWx0aXBsZSBi
bG9ja3MgYXMgb25lIGVudGl0eSBhdCB0aGUgZHJpdmVyIGxldmVsLCBwb3RlbnRpYWxseQpnZW5l
cmF0aW5nIHRoZSBJVnMgdGhlcmUgdG9vLgoKSXQncyBlc3NlbnRpYWxseSB0aGUgZXF1aXZhbGVu
dCB0byBmdWxsIElQc2VjIG9mZmxvYWQuCgpUaGFua3MsCi0tIApFbWFpbDogSGVyYmVydCBYdSA8
aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1PgpIb21lIFBhZ2U6IGh0dHA6Ly9nb25kb3IuYXBh
bmEub3JnLmF1L35oZXJiZXJ0LwpQR1AgS2V5OiBodHRwOi8vZ29uZG9yLmFwYW5hLm9yZy5hdS9+
aGVyYmVydC9wdWJrZXkudHh0CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVk
aGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
