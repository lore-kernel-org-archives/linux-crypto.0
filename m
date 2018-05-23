From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v3 13/27] x86/boot/64: Build head64.c as mcmodel
 large when PIE is enabled
Date: Wed, 23 May 2018 12:54:07 -0700
Message-ID: <20180523195421.180248-14-thgarnie@google.com>
References: <20180523195421.180248-1-thgarnie@google.com>
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
 Thomas Garnier <thgarnie@google.com>,
 Philippe Ombredanne <pombredanne@nexb.com>,
 Kate Stewart <kstewart@linuxfoundation.org>,
 Arnaldo Carvalho de Melo <acme@redhat.com>, Yonghong Song <yhs@fb.com>,
 Andrey Ryabinin <aryabinin@virtuozzo.com>,
 Kees Cook <keescook@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>,
 Dominik Brodowski <linux@dominikbrodowski.net>,
 Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
 "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len
Return-path: <xen-devel-bounces@lists.xenproject.org>
In-Reply-To: <20180523195421.180248-1-thgarnie@google.com>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
List-Id: linux-crypto.vger.kernel.org

VGhlIF9fc3RhcnR1cF82NCBmdW5jdGlvbiBhc3N1bWVzIGFsbCBzeW1ib2xzIGhhdmUgcmVsb2Nh
dGVkIGFkZHJlc3NlcwppbnN0ZWFkIG9mIHRoZSBjdXJyZW50IGJvb3QgdmlydHVhbCBhZGRyZXNz
LiBQSUUgZ2VuZXJhdGVkIGNvZGUgZmF2b3IKcmVsYXRpdmUgYWRkcmVzc2VzIG1ha2luZyBhbGwg
dmlydHVhbCBhbmQgcGh5c2ljYWwgYWRkcmVzcyBtYXRoIGluY29ycmVjdC4KSWYgUElFIGlzIGVu
YWJsZWQsIGJ1aWxkIGhlYWQ2NC5jIGFzIG1jbW9kZWwgbGFyZ2UgaW5zdGVhZCB0byBlbnN1cmUg
YWJzb2x1dGUKcmVmZXJlbmNlcyBvbiBhbGwgbWVtb3J5IGFjY2Vzcy4gQWRkIGEgZ2xvYmFsIF9f
Zm9yY2Vfb3JkZXIgdmFyaWFibGUgcmVxdWlyZWQKd2hlbiB1c2luZyBhIGxhcmdlIG1vZGVsIHdp
dGggcmVhZF9jciogZnVuY3Rpb25zLgoKVG8gYnVpbGQgaGVhZDY0LmMgYXMgbWNtb2RlbD1sYXJn
ZSwgZGlzYWJsZSB0aGUgcmV0cG9saW5lIGdjYyBmbGFncy4KVGhpcyBjb2RlIGlzIHVzZWQgYXQg
ZWFybHkgYm9vdCBhbmQgcmVtb3ZlZCBsYXRlciwgaXQgZG9lc24ndCBuZWVkCnJldHBvbGluZSBt
aXRpZ2F0aW9uLgoKUG9zaXRpb24gSW5kZXBlbmRlbnQgRXhlY3V0YWJsZSAoUElFKSBzdXBwb3J0
IHdpbGwgYWxsb3cgdG8gZXh0ZW5kZWQgdGhlCktBU0xSIHJhbmRvbWl6YXRpb24gcmFuZ2UgYmVs
b3cgdGhlIC0yRyBtZW1vcnkgbGltaXQuCgpTaWduZWQtb2ZmLWJ5OiBUaG9tYXMgR2FybmllciA8
dGhnYXJuaWVAZ29vZ2xlLmNvbT4KLS0tCiBhcmNoL3g4Ni9rZXJuZWwvTWFrZWZpbGUgfCA2ICsr
KysrKwogYXJjaC94ODYva2VybmVsL2hlYWQ2NC5jIHwgMyArKysKIDIgZmlsZXMgY2hhbmdlZCwg
OSBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL01ha2VmaWxlIGIv
YXJjaC94ODYva2VybmVsL01ha2VmaWxlCmluZGV4IDAyZDZmNWNmNGU3MC4uMGY2ZGE0YjIxNmUw
IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvTWFrZWZpbGUKKysrIGIvYXJjaC94ODYva2Vy
bmVsL01ha2VmaWxlCkBAIC0yMiw2ICsyMiwxMiBAQCBDRkxBR1NfUkVNT1ZFX2Vhcmx5X3ByaW50
ay5vID0gLXBnCiBDRkxBR1NfUkVNT1ZFX2hlYWQ2NC5vID0gLXBnCiBlbmRpZgogCitpZmRlZiBD
T05GSUdfWDg2X1BJRQorIyBSZW1vdmUgUElFIGFuZCByZXRwb2xpbmUgZmxhZ3MgdGhhdCBhcmUg
aW5jb21wYXRpYmxlIHdpdGggbWNtb2RlbD1sYXJnZQorQ0ZMQUdTX1JFTU9WRV9oZWFkNjQubyAr
PSAtZlBJRSAtbWluZGlyZWN0LWJyYW5jaD10aHVuay1leHRlcm4gLW1pbmRpcmVjdC1icmFuY2gt
cmVnaXN0ZXIKK0NGTEFHU19oZWFkNjQubyA9IC1tY21vZGVsPWxhcmdlCitlbmRpZgorCiBLQVNB
Tl9TQU5JVElaRV9oZWFkJChCSVRTKS5vCQkJCTo9IG4KIEtBU0FOX1NBTklUSVpFX2R1bXBzdGFj
ay5vCQkJCTo9IG4KIEtBU0FOX1NBTklUSVpFX2R1bXBzdGFja18kKEJJVFMpLm8JCQk6PSBuCmRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvaGVhZDY0LmMgYi9hcmNoL3g4Ni9rZXJuZWwvaGVh
ZDY0LmMKaW5kZXggMmQyOWU0N2MwNTZlLi5mYTY2MWZiOTcxMjcgMTAwNjQ0Ci0tLSBhL2FyY2gv
eDg2L2tlcm5lbC9oZWFkNjQuYworKysgYi9hcmNoL3g4Ni9rZXJuZWwvaGVhZDY0LmMKQEAgLTY0
LDYgKzY0LDkgQEAgRVhQT1JUX1NZTUJPTCh2bWVtbWFwX2Jhc2UpOwogCiAjZGVmaW5lIF9faGVh
ZAlfX3NlY3Rpb24oLmhlYWQudGV4dCkKIAorLyogUmVxdWlyZWQgZm9yIHJlYWRfY3IzIHdoZW4g
YnVpbGRpbmcgYXMgUElFICovCit1bnNpZ25lZCBsb25nIF9fZm9yY2Vfb3JkZXI7CisKIHN0YXRp
YyB2b2lkIF9faGVhZCAqZml4dXBfcG9pbnRlcih2b2lkICpwdHIsIHVuc2lnbmVkIGxvbmcgcGh5
c2FkZHIpCiB7CiAJcmV0dXJuIHB0ciAtICh2b2lkICopX3RleHQgKyAodm9pZCAqKXBoeXNhZGRy
OwotLSAKMi4xNy4wLjQ0MS5nYjQ2ZmU2MGUxZC1nb29nCgoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4tZGV2
ZWxAbGlzdHMueGVucHJvamVjdC5vcmcKaHR0cHM6Ly9saXN0cy54ZW5wcm9qZWN0Lm9yZy9tYWls
bWFuL2xpc3RpbmZvL3hlbi1kZXZlbA==
