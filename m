From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v2 12/27] x86/paravirt: Adapt assembly for PIE
	support
Date: Tue, 13 Mar 2018 13:59:30 -0700
Message-ID: <20180313205945.245105-13-thgarnie@google.com>
References: <20180313205945.245105-1-thgarnie@google.com>
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
 Josh Poimboeuf <jpoimboe@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Kate Stewart <kstewart@linuxfoundation.org>,
 Thomas Garnier <thgarnie@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Philippe Ombredanne <pombredanne@nexb.com>,
 Arnaldo Carvalho de Melo <acme@redhat.com>,
 Andrey Ryabinin <aryabinin@virtuozzo.com>,
 Matthias Kaehlcke <mka@chromium.org>, Kees Cook <keescook@chromium.org>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>,
 Dominik Brodowski <linux@dominikbrodowski.net>,
 Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
 "Raf
Return-path: <xen-devel-bounces@lists.xenproject.org>
In-Reply-To: <20180313205945.245105-1-thgarnie@google.com>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
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
YXZpcnRfdHlwZXMuaAppbmRleCAxODBiYzBiZmYwZmIuLjE0MDc0N2E5OGQ5NCAxMDA2NDQKLS0t
IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vcGFyYXZpcnRfdHlwZXMuaAorKysgYi9hcmNoL3g4Ni9p
bmNsdWRlL2FzbS9wYXJhdmlydF90eXBlcy5oCkBAIC0zMzcsOSArMzM3LDE3IEBAIGV4dGVybiBz
dHJ1Y3QgcHZfbG9ja19vcHMgcHZfbG9ja19vcHM7CiAjZGVmaW5lIFBBUkFWSVJUX1BBVENIKHgp
CQkJCQlcCiAJKG9mZnNldG9mKHN0cnVjdCBwYXJhdmlydF9wYXRjaF90ZW1wbGF0ZSwgeCkgLyBz
aXplb2Yodm9pZCAqKSkKIAorI2lmZGVmIENPTkZJR19YODZfUElFCisjZGVmaW5lIHBhcmF2aXJ0
X29wcHRyX2NhbGwgImEiCisjZGVmaW5lIHBhcmF2aXJ0X29wcHRyX3R5cGUgInAiCisjZWxzZQor
I2RlZmluZSBwYXJhdmlydF9vcHB0cl9jYWxsICJjIgorI2RlZmluZSBwYXJhdmlydF9vcHB0cl90
eXBlICJpIgorI2VuZGlmCisKICNkZWZpbmUgcGFyYXZpcnRfdHlwZShvcCkJCQkJXAogCVtwYXJh
dmlydF90eXBlbnVtXSAiaSIgKFBBUkFWSVJUX1BBVENIKG9wKSksCVwKLQlbcGFyYXZpcnRfb3Bw
dHJdICJpIiAoJihvcCkpCisJW3BhcmF2aXJ0X29wcHRyXSBwYXJhdmlydF9vcHB0cl90eXBlICgm
KG9wKSkKICNkZWZpbmUgcGFyYXZpcnRfY2xvYmJlcihjbG9iYmVyKQkJXAogCVtwYXJhdmlydF9j
bG9iYmVyXSAiaSIgKGNsb2JiZXIpCiAKQEAgLTM5NSw3ICs0MDMsNyBAQCBpbnQgcGFyYXZpcnRf
ZGlzYWJsZV9pb3NwYWNlKHZvaWQpOwogICovCiAjZGVmaW5lIFBBUkFWSVJUX0NBTEwJCQkJCVwK
IAlBTk5PVEFURV9SRVRQT0xJTkVfU0FGRQkJCQlcCi0JImNhbGwgKiVjW3BhcmF2aXJ0X29wcHRy
XTsiCisJImNhbGwgKiUiIHBhcmF2aXJ0X29wcHRyX2NhbGwgIltwYXJhdmlydF9vcHB0cl07Igog
CiAvKgogICogVGhlc2UgbWFjcm9zIGFyZSBpbnRlbmRlZCB0byB3cmFwIGNhbGxzIHRocm91Z2gg
b25lIG9mIHRoZSBwYXJhdmlydAotLSAKMi4xNi4yLjY2MC5nNzA5ODg3OTcxYi1nb29nCgoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWGVuLWRldmVsIG1h
aWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMueGVucHJvamVjdC5vcmcKaHR0cHM6Ly9saXN0cy54
ZW5wcm9qZWN0Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL3hlbi1kZXZlbA==
