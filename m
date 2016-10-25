From: Trond Myklebust <trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: Re: [PATCH] sunrpc: don't pass on-stack memory to sg_set_buf
Date: Tue, 25 Oct 2016 19:34:43 +0000
Message-ID: <A4086E5B-B808-4828-A25D-4AAB2504EC57@primarydata.com>
References: <20161025184538.GA4612@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Cc: List Linux NFS Mailing <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
        Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Fields Bruce James <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161025184538.GA4612-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Content-Language: en-US
Content-ID: <F57A1572A729794EB71092797461E716-Hry67jCOGbCcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

DQo+IE9uIE9jdCAyNSwgMjAxNiwgYXQgMTQ6NDUsIEouIEJydWNlIEZpZWxkcyA8YmZpZWxkc0Bm
aWVsZHNlcy5vcmc+IHdyb3RlOg0KPiANCj4gRnJvbTogIkouIEJydWNlIEZpZWxkcyIgPGJmaWVs
ZHNAcmVkaGF0LmNvbT4NCj4gDQo+IEFzIG9mIGFjNGU5N2FiY2U5YiAic2NhdHRlcmxpc3Q6IHNn
X3NldF9idWYoKSBhcmd1bWVudCBtdXN0IGJlIGluIGxpbmVhcg0KPiBtYXBwaW5nIiwgc2dfc2V0
X2J1ZiBoaXRzIGEgQlVHIHdoZW4gbWFrZV9jaGVja3N1bV92Mi0+eGRyX3Byb2Nlc3NfYnVmLA0K
PiBhbW9uZyBvdGhlciBjYWxsZXJzLCBwYXNzZXMgaXQgbWVtb3J5IG9uIHRoZSBzdGFjay4NCj4g
DQo+IFdlIG9ubHkgbmVlZCBhIHNjYXR0ZXJsaXN0IHRvIHBhc3MgdGhpcyB0byB0aGUgY3J5cHRv
IGNvZGUsIGFuZCBpdCBzZWVtcw0KPiBsaWtlIG92ZXJraWxsIHRvIHJlcXVpcmUga21hbGxvYydk
IG1lbW9yeSBqdXN0IHRvIGVuY3J5cHQgYSBmZXcgYnl0ZXMsDQo+IGJ1dCBmb3Igbm93IHRoaXMg
c2VlbXMgdGhlIGJlc3QgZml4Lg0KPiANCj4gTm90ZSBtYW55IG9mIHRoZXNlIGNhbGxlcnMgYXJl
IGluIHRoZSBORlMgd3JpdGUgcGF0aHMsIHNvIHdlIHNob3VsZG4ndA0KPiByZWFsbHkgYmUgYWxs
b2NhdGluZyBHRlBfS0VSTkVMLiAgQnV0IHdlIGFscmVhZHkgaGF2ZSBvdGhlciBhbGxvY2F0aW9u
cw0KPiBpbiB0aGVzZSBjb2RlIHBhdGhzLiAgQSBsYXJnZXIgcmVkZXNpZ24gbWF5IGJlIG5lY2Vz
c2FyeSB0byBhbGxvdw0KPiBhbGxvY2F0aW9ucyB0byBiZSBkb25lIGVhcmxpZXIuDQoNCk5BQ0vi
gKYgIEkgYWdyZWUgdGhhdCB0aGVyZSBtYXkgYWxyZWFkeSBiZSBib3JrYWdlIGluIFJQQ1NFQ19H
U1MtbGFuZCwgYnV0IHRoYXTigJlzIG5vdCBhIHJlYXNvbiB0byBiZSBhZGRpbmcgdG8gdGhlIHBp
bGUgb2YgdGhpbmdzIHRoYXQgbmVlZCB0byBiZSBmaXhlZOKApiBUaGUgYWxsb2NhdGlvbnMgdGhh
dCBsaWUgaW4gdGhlIFJQQyBjbGllbnTigJlzIGVuY29kZS9kZWNvZGUgcGF0aCBkbyBuZWVkIHRv
IGJlIEdGUF9OT0ZT4oCmLg0KDQo=

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
