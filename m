From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v1 12/27] x86/paravirt: Adapt assembly for PIE
	support
Date: Wed, 11 Oct 2017 13:30:12 -0700
Message-ID: <20171011203027.11248-13-thgarnie@google.com>
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

aWYgUElFIGlzIGVuYWJsZWQsIHN3aXRjaCB0aGUgcGFyYXZpcnQgYXNzZW1ibHkgY29uc3RyYWlu
dHMgdG8gYmUKY29tcGF0aWJsZS4gVGhlICVjL2kgY29uc3RyYWlucyBnZW5lcmF0ZSBzbWFsbGVy
IGNvZGUgc28gaXMga2VwdCBieQpkZWZhdWx0LgoKUG9zaXRpb24gSW5kZXBlbmRlbnQgRXhlY3V0
YWJsZSAoUElFKSBzdXBwb3J0IHdpbGwgYWxsb3cgdG8gZXh0ZW5kZWQgdGhlCktBU0xSIHJhbmRv
bWl6YXRpb24gcmFuZ2UgYmVsb3cgdGhlIC0yRyBtZW1vcnkgbGltaXQuCgpTaWduZWQtb2ZmLWJ5
OiBUaG9tYXMgR2FybmllciA8dGhnYXJuaWVAZ29vZ2xlLmNvbT4KLS0tCiBhcmNoL3g4Ni9pbmNs
dWRlL2FzbS9wYXJhdmlydF90eXBlcy5oIHwgMTIgKysrKysrKysrKy0tCiAxIGZpbGUgY2hhbmdl
ZCwgMTAgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS9wYXJhdmlydF90eXBlcy5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcGFy
YXZpcnRfdHlwZXMuaAppbmRleCAyODBkOTRjMzZkYWQuLmU2OTYxZjhhNzRhYSAxMDA2NDQKLS0t
IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vcGFyYXZpcnRfdHlwZXMuaAorKysgYi9hcmNoL3g4Ni9p
bmNsdWRlL2FzbS9wYXJhdmlydF90eXBlcy5oCkBAIC0zMzUsOSArMzM1LDE3IEBAIGV4dGVybiBz
dHJ1Y3QgcHZfbG9ja19vcHMgcHZfbG9ja19vcHM7CiAjZGVmaW5lIFBBUkFWSVJUX1BBVENIKHgp
CQkJCQlcCiAJKG9mZnNldG9mKHN0cnVjdCBwYXJhdmlydF9wYXRjaF90ZW1wbGF0ZSwgeCkgLyBz
aXplb2Yodm9pZCAqKSkKIAorI2lmZGVmIENPTkZJR19YODZfUElFCisjZGVmaW5lIHBhcmF2aXJ0
X29wcHRyX2NhbGwgImEiCisjZGVmaW5lIHBhcmF2aXJ0X29wcHRyX3R5cGUgInAiCisjZWxzZQor
I2RlZmluZSBwYXJhdmlydF9vcHB0cl9jYWxsICJjIgorI2RlZmluZSBwYXJhdmlydF9vcHB0cl90
eXBlICJpIgorI2VuZGlmCisKICNkZWZpbmUgcGFyYXZpcnRfdHlwZShvcCkJCQkJXAogCVtwYXJh
dmlydF90eXBlbnVtXSAiaSIgKFBBUkFWSVJUX1BBVENIKG9wKSksCVwKLQlbcGFyYXZpcnRfb3Bw
dHJdICJpIiAoJihvcCkpCisJW3BhcmF2aXJ0X29wcHRyXSBwYXJhdmlydF9vcHB0cl90eXBlICgm
KG9wKSkKICNkZWZpbmUgcGFyYXZpcnRfY2xvYmJlcihjbG9iYmVyKQkJXAogCVtwYXJhdmlydF9j
bG9iYmVyXSAiaSIgKGNsb2JiZXIpCiAKQEAgLTM5MSw3ICszOTksNyBAQCBpbnQgcGFyYXZpcnRf
ZGlzYWJsZV9pb3NwYWNlKHZvaWQpOwogICogb2Zmc2V0IGludG8gdGhlIHBhcmF2aXJ0X3BhdGNo
X3RlbXBsYXRlIHN0cnVjdHVyZSwgYW5kIGNhbiB0aGVyZWZvcmUgYmUKICAqIGZyZWVseSBjb252
ZXJ0ZWQgYmFjayBpbnRvIGEgc3RydWN0dXJlIG9mZnNldC4KICAqLwotI2RlZmluZSBQQVJBVklS
VF9DQUxMCSJjYWxsIColY1twYXJhdmlydF9vcHB0cl07IgorI2RlZmluZSBQQVJBVklSVF9DQUxM
CSJjYWxsIColIiBwYXJhdmlydF9vcHB0cl9jYWxsICJbcGFyYXZpcnRfb3BwdHJdOyIKIAogLyoK
ICAqIFRoZXNlIG1hY3JvcyBhcmUgaW50ZW5kZWQgdG8gd3JhcCBjYWxscyB0aHJvdWdoIG9uZSBv
ZiB0aGUgcGFyYXZpcnQKLS0gCjIuMTUuMC5yYzAuMjcxLmczNmI2NjllZGNjLWdvb2cKCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpYZW4tZGV2ZWwgbWFp
bGluZyBsaXN0Clhlbi1kZXZlbEBsaXN0cy54ZW4ub3JnCmh0dHBzOi8vbGlzdHMueGVuLm9yZy94
ZW4tZGV2ZWwK
