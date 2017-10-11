From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v1 13/27] x86/boot/64: Use _text in a global for
	PIE support
Date: Wed, 11 Oct 2017 13:30:13 -0700
Message-ID: <20171011203027.11248-14-thgarnie@google.com>
References: <20171011203027.11248-1-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-arch@vger.kernel.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org,
 x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-sparse@vger.kernel.org,
 linux-crypto@vger.kernel.org, kernel-hardening@lists.openwall.com,
 xen-devel@lists.xenproject.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
 Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
 Thomas Garnier <thgarnie@google.com>, Kees Cook <keescook@chromium.org>,
 Andrey Ryabinin <aryabinin@virtuozzo.com>,
 Matthias Kaehlcke <mka@chromium.org>,
 Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>,
 Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
 Juergen Gross <jgross@suse.com>, Chris Wright <chrisw@sous-sol.org>,
 Alok Kataria <akataria@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
 Tejun Heo <tj@kernel.
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <20171011203027.11248-1-thgarnie@google.com>
List-Unsubscribe: <https://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <https://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xen.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xen.org>
List-Id: linux-crypto.vger.kernel.org

QnkgZGVmYXVsdCBQSUUgZ2VuZXJhdGVkIGNvZGUgY3JlYXRlIG9ubHkgcmVsYXRpdmUgcmVmZXJl
bmNlcyBzbyBfdGV4dApwb2ludHMgdG8gdGhlIHRlbXBvcmFyeSB2aXJ0dWFsIGFkZHJlc3MuIElu
c3RlYWQgdXNlIGEgZ2xvYmFsIHZhcmlhYmxlCnNvIHRoZSByZWxvY2F0aW9uIGlzIGRvbmUgYXMg
ZXhwZWN0ZWQuCgpQb3NpdGlvbiBJbmRlcGVuZGVudCBFeGVjdXRhYmxlIChQSUUpIHN1cHBvcnQg
d2lsbCBhbGxvdyB0byBleHRlbmRlZCB0aGUKS0FTTFIgcmFuZG9taXphdGlvbiByYW5nZSBiZWxv
dyB0aGUgLTJHIG1lbW9yeSBsaW1pdC4KClNpZ25lZC1vZmYtYnk6IFRob21hcyBHYXJuaWVyIDx0
aGdhcm5pZUBnb29nbGUuY29tPgotLS0KIGFyY2gveDg2L2tlcm5lbC9oZWFkNjQuYyB8IDEyICsr
KysrKysrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvaGVhZDY0LmMgYi9hcmNoL3g4Ni9rZXJu
ZWwvaGVhZDY0LmMKaW5kZXggYmFiNGZhNTc5NDUwLi42NzVmMWRiYTNiMjEgMTAwNjQ0Ci0tLSBh
L2FyY2gveDg2L2tlcm5lbC9oZWFkNjQuYworKysgYi9hcmNoL3g4Ni9rZXJuZWwvaGVhZDY0LmMK
QEAgLTQ1LDggKzQ1LDE0IEBAIHN0YXRpYyB2b2lkIF9faGVhZCAqZml4dXBfcG9pbnRlcih2b2lk
ICpwdHIsIHVuc2lnbmVkIGxvbmcgcGh5c2FkZHIpCiAJcmV0dXJuIHB0ciAtICh2b2lkICopX3Rl
eHQgKyAodm9pZCAqKXBoeXNhZGRyOwogfQogCi11bnNpZ25lZCBsb25nIF9faGVhZCBfX3N0YXJ0
dXBfNjQodW5zaWduZWQgbG9uZyBwaHlzYWRkciwKLQkJCQkgIHN0cnVjdCBib290X3BhcmFtcyAq
YnApCisvKgorICogVXNlIGEgZ2xvYmFsIHZhcmlhYmxlIHRvIHByb3Blcmx5IGNhbGN1bGF0ZSBf
dGV4dCBkZWx0YSBvbiBQSUUuIEJ5IGRlZmF1bHQKKyAqIGEgUElFIGJpbmFyeSBkbyBhIFJJUCBy
ZWxhdGl2ZSBkaWZmZXJlbmNlIGluc3RlYWQgb2YgdGhlIHJlbG9jYXRlZCBhZGRyZXNzLgorICov
Cit1bnNpZ25lZCBsb25nIF90ZXh0X29mZnNldCA9ICh1bnNpZ25lZCBsb25nKShfdGV4dCAtIF9f
U1RBUlRfS0VSTkVMX21hcCk7CisKK3Vuc2lnbmVkIGxvbmcgX19oZWFkIG5vdHJhY2UgX19zdGFy
dHVwXzY0KHVuc2lnbmVkIGxvbmcgcGh5c2FkZHIsCisJCQkJCSAgc3RydWN0IGJvb3RfcGFyYW1z
ICpicCkKIHsKIAl1bnNpZ25lZCBsb25nIGxvYWRfZGVsdGEsICpwOwogCXVuc2lnbmVkIGxvbmcg
cGd0YWJsZV9mbGFnczsKQEAgLTY1LDcgKzcxLDcgQEAgdW5zaWduZWQgbG9uZyBfX2hlYWQgX19z
dGFydHVwXzY0KHVuc2lnbmVkIGxvbmcgcGh5c2FkZHIsCiAJICogQ29tcHV0ZSB0aGUgZGVsdGEg
YmV0d2VlbiB0aGUgYWRkcmVzcyBJIGFtIGNvbXBpbGVkIHRvIHJ1biBhdAogCSAqIGFuZCB0aGUg
YWRkcmVzcyBJIGFtIGFjdHVhbGx5IHJ1bm5pbmcgYXQuCiAJICovCi0JbG9hZF9kZWx0YSA9IHBo
eXNhZGRyIC0gKHVuc2lnbmVkIGxvbmcpKF90ZXh0IC0gX19TVEFSVF9LRVJORUxfbWFwKTsKKwls
b2FkX2RlbHRhID0gcGh5c2FkZHIgLSBfdGV4dF9vZmZzZXQ7CiAKIAkvKiBJcyB0aGUgYWRkcmVz
cyBub3QgMk0gYWxpZ25lZD8gKi8KIAlpZiAobG9hZF9kZWx0YSAmIH5QTURfUEFHRV9NQVNLKQot
LSAKMi4xNS4wLnJjMC4yNzEuZzM2YjY2OWVkY2MtZ29vZwoKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fClhlbi1kZXZlbCBtYWlsaW5nIGxpc3QKWGVuLWRl
dmVsQGxpc3RzLnhlbi5vcmcKaHR0cHM6Ly9saXN0cy54ZW4ub3JnL3hlbi1kZXZlbAo=
