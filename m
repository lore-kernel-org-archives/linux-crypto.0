From: Thomas Garnier <thgarnie@google.com>
Subject: [RFC 10/22] x86/CPU: Adapt assembly for PIE support
Date: Tue, 18 Jul 2017 15:33:21 -0700
Message-ID: <20170718223333.110371-11-thgarnie@google.com>
References: <20170718223333.110371-1-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-arch@vger.kernel.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org,
 x86@kernel.org, linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
 linux-crypto@vger.kernel.org, kernel-hardening@lists.openwall.com,
 xen-devel@lists.xenproject.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
 Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>,
 Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
 Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>,
 Borislav Petkov <bp@alien8.de>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@suse.de>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <20170718223333.110371-1-thgarnie@google.com>
List-Unsubscribe: <https://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <https://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xen.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xen.org>
List-Id: linux-crypto.vger.kernel.org

Q2hhbmdlIHRoZSBhc3NlbWJseSBjb2RlIHRvIHVzZSBvbmx5IHJlbGF0aXZlIHJlZmVyZW5jZXMg
b2Ygc3ltYm9scyBmb3IgdGhlCmtlcm5lbCB0byBiZSBQSUUgY29tcGF0aWJsZS4gVXNlIHRoZSBu
ZXcgX0FTTV9HRVRfUFRSIG1hY3JvIGluc3RlYWQgb2YKdGhlICdtb3YgJHN5bWJvbCwgJWRzdCcg
Y29uc3RydWN0IHRvIG5vdCBoYXZlIGFuIGFic29sdXRlIHJlZmVyZW5jZS4KClBvc2l0aW9uIElu
ZGVwZW5kZW50IEV4ZWN1dGFibGUgKFBJRSkgc3VwcG9ydCB3aWxsIGFsbG93IHRvIGV4dGVuZGVk
IHRoZQpLQVNMUiByYW5kb21pemF0aW9uIHJhbmdlIGJlbG93IHRoZSAtMkcgbWVtb3J5IGxpbWl0
LgoKU2lnbmVkLW9mZi1ieTogVGhvbWFzIEdhcm5pZXIgPHRoZ2FybmllQGdvb2dsZS5jb20+Ci0t
LQogYXJjaC94ODYvaW5jbHVkZS9hc20vcHJvY2Vzc29yLmggfCA4ICsrKysrLS0tCiAxIGZpbGUg
Y2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL3Byb2Nlc3Nvci5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcHJv
Y2Vzc29yLmgKaW5kZXggMDI4MjQ1ZTFjNDJiLi4xYWRlYThjNDQzNmUgMTAwNjQ0Ci0tLSBhL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL3Byb2Nlc3Nvci5oCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNt
L3Byb2Nlc3Nvci5oCkBAIC00Nyw3ICs0Nyw3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCAqY3VycmVu
dF90ZXh0X2FkZHIodm9pZCkKIHsKIAl2b2lkICpwYzsKIAotCWFzbSB2b2xhdGlsZSgibW92ICQx
ZiwgJTA7IDE6IjoiPXIiIChwYykpOworCWFzbSB2b2xhdGlsZShfQVNNX0dFVF9QVFIoMWYsICUw
KSAiOyAxOiI6Ij1yIiAocGMpKTsKIAogCXJldHVybiBwYzsKIH0KQEAgLTY4Miw2ICs2ODIsNyBA
QCBzdGF0aWMgaW5saW5lIHZvaWQgc3luY19jb3JlKHZvaWQpCiAJCTogIityIiAoX19zcCkgOiA6
ICJtZW1vcnkiKTsKICNlbHNlCiAJdW5zaWduZWQgaW50IHRtcDsKKwl1bnNpZ25lZCBsb25nIHRt
cDI7CiAKIAlhc20gdm9sYXRpbGUgKAogCQkibW92ICUlc3MsICUwXG5cdCIKQEAgLTY5MSwxMCAr
NjkyLDExIEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBzeW5jX2NvcmUodm9pZCkKIAkJInB1c2hmcVxu
XHQiCiAJCSJtb3YgJSVjcywgJTBcblx0IgogCQkicHVzaHEgJXEwXG5cdCIKLQkJInB1c2hxICQx
ZlxuXHQiCisJCSJsZWFxIDFmKCUlcmlwKSwgJTFcblx0IgorCQkicHVzaHEgJTFcblx0IgogCQki
aXJldHFcblx0IgogCQkiMToiCi0JCTogIj0mciIgKHRtcCksICIrciIgKF9fc3ApIDogOiAiY2Mi
LCAibWVtb3J5Iik7CisJCTogIj0mciIgKHRtcCksICI9JnIiICh0bXAyKSwgIityIiAoX19zcCkg
OiA6ICJjYyIsICJtZW1vcnkiKTsKICNlbmRpZgogfQogCi0tIAoyLjEzLjIuOTMyLmc3NDQ5ZTk2
NGMtZ29vZwoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Clhlbi1kZXZlbCBtYWlsaW5nIGxpc3QKWGVuLWRldmVsQGxpc3RzLnhlbi5vcmcKaHR0cHM6Ly9s
aXN0cy54ZW4ub3JnL3hlbi1kZXZlbAo=
