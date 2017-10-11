From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v1 06/27] x86/entry/64: Adapt assembly for PIE
	support
Date: Wed, 11 Oct 2017 13:30:06 -0700
Message-ID: <20171011203027.11248-7-thgarnie@google.com>
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

Q2hhbmdlIHRoZSBhc3NlbWJseSBjb2RlIHRvIHVzZSBvbmx5IHJlbGF0aXZlIHJlZmVyZW5jZXMg
b2Ygc3ltYm9scyBmb3IgdGhlCmtlcm5lbCB0byBiZSBQSUUgY29tcGF0aWJsZS4KClBvc2l0aW9u
IEluZGVwZW5kZW50IEV4ZWN1dGFibGUgKFBJRSkgc3VwcG9ydCB3aWxsIGFsbG93IHRvIGV4dGVu
ZGVkIHRoZQpLQVNMUiByYW5kb21pemF0aW9uIHJhbmdlIGJlbG93IHRoZSAtMkcgbWVtb3J5IGxp
bWl0LgoKU2lnbmVkLW9mZi1ieTogVGhvbWFzIEdhcm5pZXIgPHRoZ2FybmllQGdvb2dsZS5jb20+
Ci0tLQogYXJjaC94ODYvZW50cnkvZW50cnlfNjQuUyB8IDIyICsrKysrKysrKysrKysrKy0tLS0t
LS0KIDEgZmlsZSBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L2VudHJ5L2VudHJ5XzY0LlMgYi9hcmNoL3g4Ni9lbnRyeS9lbnRy
eV82NC5TCmluZGV4IDQ5MTY3MjU4ZDU4Ny4uMTViZDU1MzBkMmFlIDEwMDY0NAotLS0gYS9hcmNo
L3g4Ni9lbnRyeS9lbnRyeV82NC5TCisrKyBiL2FyY2gveDg2L2VudHJ5L2VudHJ5XzY0LlMKQEAg
LTE5NCwxMiArMTk0LDE1IEBAIGVudHJ5X1NZU0NBTExfNjRfZmFzdHBhdGg6CiAJamEJMWYJCQkJ
LyogcmV0dXJuIC1FTk9TWVMgKGFscmVhZHkgaW4gcHRfcmVncy0+YXgpICovCiAJbW92cQklcjEw
LCAlcmN4CiAKKwkvKiBFbnN1cmVzIHRoZSBjYWxsIGlzIHBvc2l0aW9uIGluZGVwZW5kZW50ICov
CisJbGVhcQlzeXNfY2FsbF90YWJsZSglcmlwKSwgJXIxMQorCiAJLyoKIAkgKiBUaGlzIGNhbGwg
aW5zdHJ1Y3Rpb24gaXMgaGFuZGxlZCBzcGVjaWFsbHkgaW4gc3R1Yl9wdHJlZ3NfNjQuCiAJICog
SXQgbWlnaHQgZW5kIHVwIGp1bXBpbmcgdG8gdGhlIHNsb3cgcGF0aC4gIElmIGl0IGp1bXBzLCBS
QVgKIAkgKiBhbmQgYWxsIGFyZ3VtZW50IHJlZ2lzdGVycyBhcmUgY2xvYmJlcmVkLgogCSAqLwot
CWNhbGwJKnN5c19jYWxsX3RhYmxlKCwgJXJheCwgOCkKKwljYWxsCSooJXIxMSwgJXJheCwgOCkK
IC5MZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9mYXN0cGF0aF9jYWxsOgogCiAJbW92cQklcmF4LCBS
QVgoJXJzcCkKQEAgLTMzNCw3ICszMzcsOCBAQCBFTlRSWShzdHViX3B0cmVnc182NCkKIAkgKiBS
QVggc3RvcmVzIGEgcG9pbnRlciB0byB0aGUgQyBmdW5jdGlvbiBpbXBsZW1lbnRpbmcgdGhlIHN5
c2NhbGwuCiAJICogSVJRcyBhcmUgb24uCiAJICovCi0JY21wcQkkLkxlbnRyeV9TWVNDQUxMXzY0
X2FmdGVyX2Zhc3RwYXRoX2NhbGwsICglcnNwKQorCWxlYXEJLkxlbnRyeV9TWVNDQUxMXzY0X2Fm
dGVyX2Zhc3RwYXRoX2NhbGwoJXJpcCksICVyMTEKKwljbXBxCSVyMTEsICglcnNwKQogCWpuZQkx
ZgogCiAJLyoKQEAgLTExNzIsNyArMTE3Niw4IEBAIEVOVFJZKGVycm9yX2VudHJ5KQogCW1vdmwJ
JWVjeCwgJWVheAkJCS8qIHplcm8gZXh0ZW5kICovCiAJY21wcQklcmF4LCBSSVArOCglcnNwKQog
CWplCS5MYnN0ZXBfaXJldAotCWNtcHEJJC5MZ3NfY2hhbmdlLCBSSVArOCglcnNwKQorCWxlYXEJ
Lkxnc19jaGFuZ2UoJXJpcCksICVyY3gKKwljbXBxCSVyY3gsIFJJUCs4KCVyc3ApCiAJam5lCS5M
ZXJyb3JfZW50cnlfZG9uZQogCiAJLyoKQEAgLTEzODMsMTAgKzEzODgsMTAgQEAgRU5UUlkobm1p
KQogCSAqIHJlc3VtZSB0aGUgb3V0ZXIgTk1JLgogCSAqLwogCi0JbW92cQkkcmVwZWF0X25taSwg
JXJkeAorCWxlYXEJcmVwZWF0X25taSglcmlwKSwgJXJkeAogCWNtcHEJOCglcnNwKSwgJXJkeAog
CWphCTFmCi0JbW92cQkkZW5kX3JlcGVhdF9ubWksICVyZHgKKwlsZWFxCWVuZF9yZXBlYXRfbm1p
KCVyaXApLCAlcmR4CiAJY21wcQk4KCVyc3ApLCAlcmR4CiAJamEJbmVzdGVkX25taV9vdXQKIDE6
CkBAIC0xNDQwLDcgKzE0NDUsOCBAQCBuZXN0ZWRfbm1pOgogCXB1c2hxCSVyZHgKIAlwdXNoZnEK
IAlwdXNocQkkX19LRVJORUxfQ1MKLQlwdXNocQkkcmVwZWF0X25taQorCWxlYXEJcmVwZWF0X25t
aSglcmlwKSwgJXJkeAorCXB1c2hxCSVyZHgKIAogCS8qIFB1dCBzdGFjayBiYWNrICovCiAJYWRk
cQkkKDYqOCksICVyc3AKQEAgLTE0NzksNyArMTQ4NSw5IEBAIGZpcnN0X25taToKIAlhZGRxCSQ4
LCAoJXJzcCkJLyogRml4IHVwIFJTUCAqLwogCXB1c2hmcQkJCS8qIFJGTEFHUyAqLwogCXB1c2hx
CSRfX0tFUk5FTF9DUwkvKiBDUyAqLwotCXB1c2hxCSQxZgkJLyogUklQICovCisJcHVzaHEJJXJh
eAkJLyogU3VwcG9ydCBQb3NpdGlvbiBJbmRlcGVuZGVudCBDb2RlICovCisJbGVhcQkxZiglcmlw
KSwgJXJheAkvKiBSSVAgKi8KKwl4Y2hncQklcmF4LCAoJXJzcCkJLyogUmVzdG9yZSBSQVgsIHB1
dCAxZiAqLwogCUlOVEVSUlVQVF9SRVRVUk4JLyogY29udGludWVzIGF0IHJlcGVhdF9ubWkgYmVs
b3cgKi8KIAlVTldJTkRfSElOVF9JUkVUX1JFR1MKIDE6Ci0tIAoyLjE1LjAucmMwLjI3MS5nMzZi
NjY5ZWRjYy1nb29nCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMueGVuLm9yZwpodHRw
czovL2xpc3RzLnhlbi5vcmcveGVuLWRldmVsCg==
