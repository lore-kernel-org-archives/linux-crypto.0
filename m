From: Thomas Garnier <thgarnie@google.com>
Subject: [RFC v2 14/23] x86/paravirt: Adapt assembly for PIE
	support
Date: Thu, 10 Aug 2017 10:26:06 -0700
Message-ID: <20170810172615.51965-15-thgarnie@google.com>
References: <20170810172615.51965-1-thgarnie@google.com>
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
 Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
 Thomas Garnier <thgarnie@google.com>, Matthias Kaehlcke <mka@chromium.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
 Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>,
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>,
 Brian Gerst <brgerst@gmail.com>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
 Pavel Machek <pavel@ucw.cz>
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <20170810172615.51965-1-thgarnie@google.com>
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
YXZpcnRfdHlwZXMuaAppbmRleCA5ZmZjMzZiZmU0Y2QuLjZmNjdjMTA2NzJlYyAxMDA2NDQKLS0t
IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vcGFyYXZpcnRfdHlwZXMuaAorKysgYi9hcmNoL3g4Ni9p
bmNsdWRlL2FzbS9wYXJhdmlydF90eXBlcy5oCkBAIC0zNDcsOSArMzQ3LDE3IEBAIGV4dGVybiBz
dHJ1Y3QgcHZfbG9ja19vcHMgcHZfbG9ja19vcHM7CiAjZGVmaW5lIFBBUkFWSVJUX1BBVENIKHgp
CQkJCQlcCiAJKG9mZnNldG9mKHN0cnVjdCBwYXJhdmlydF9wYXRjaF90ZW1wbGF0ZSwgeCkgLyBz
aXplb2Yodm9pZCAqKSkKIAorI2lmZGVmIENPTkZJR19YODZfUElFCisjZGVmaW5lIHBhcmF2aXJ0
X29wcHRyX2NhbGwgImEiCisjZGVmaW5lIHBhcmF2aXJ0X29wcHRyX3R5cGUgInAiCisjZWxzZQor
I2RlZmluZSBwYXJhdmlydF9vcHB0cl9jYWxsICJjIgorI2RlZmluZSBwYXJhdmlydF9vcHB0cl90
eXBlICJpIgorI2VuZGlmCisKICNkZWZpbmUgcGFyYXZpcnRfdHlwZShvcCkJCQkJXAogCVtwYXJh
dmlydF90eXBlbnVtXSAiaSIgKFBBUkFWSVJUX1BBVENIKG9wKSksCVwKLQlbcGFyYXZpcnRfb3Bw
dHJdICJpIiAoJihvcCkpCisJW3BhcmF2aXJ0X29wcHRyXSBwYXJhdmlydF9vcHB0cl90eXBlICgm
KG9wKSkKICNkZWZpbmUgcGFyYXZpcnRfY2xvYmJlcihjbG9iYmVyKQkJXAogCVtwYXJhdmlydF9j
bG9iYmVyXSAiaSIgKGNsb2JiZXIpCiAKQEAgLTQwMyw3ICs0MTEsNyBAQCBpbnQgcGFyYXZpcnRf
ZGlzYWJsZV9pb3NwYWNlKHZvaWQpOwogICogb2Zmc2V0IGludG8gdGhlIHBhcmF2aXJ0X3BhdGNo
X3RlbXBsYXRlIHN0cnVjdHVyZSwgYW5kIGNhbiB0aGVyZWZvcmUgYmUKICAqIGZyZWVseSBjb252
ZXJ0ZWQgYmFjayBpbnRvIGEgc3RydWN0dXJlIG9mZnNldC4KICAqLwotI2RlZmluZSBQQVJBVklS
VF9DQUxMCSJjYWxsIColY1twYXJhdmlydF9vcHB0cl07IgorI2RlZmluZSBQQVJBVklSVF9DQUxM
CSJjYWxsIColIiBwYXJhdmlydF9vcHB0cl9jYWxsICJbcGFyYXZpcnRfb3BwdHJdOyIKIAogLyoK
ICAqIFRoZXNlIG1hY3JvcyBhcmUgaW50ZW5kZWQgdG8gd3JhcCBjYWxscyB0aHJvdWdoIG9uZSBv
ZiB0aGUgcGFyYXZpcnQKLS0gCjIuMTQuMC40MzQuZzk4MDk2ZmQ3YTgtZ29vZwoKCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClhlbi1kZXZlbCBtYWlsaW5n
IGxpc3QKWGVuLWRldmVsQGxpc3RzLnhlbi5vcmcKaHR0cHM6Ly9saXN0cy54ZW4ub3JnL3hlbi1k
ZXZlbAo=
