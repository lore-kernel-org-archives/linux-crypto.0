From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v3 24/27] x86/mm: Make the x86 GOT read-only
Date: Wed, 23 May 2018 12:54:18 -0700
Message-ID: <20180523195421.180248-25-thgarnie@google.com>
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

VGhlIEdPVCBpcyBjaGFuZ2VkIGR1cmluZyBlYXJseSBib290IHdoZW4gcmVsb2NhdGlvbnMgYXJl
IGFwcGxpZWQuIE1ha2UKaXQgcmVhZC1vbmx5IGRpcmVjdGx5LiBUaGlzIHRhYmxlIGV4aXN0cyBv
bmx5IGZvciBQSUUgYmluYXJ5LgoKUG9zaXRpb24gSW5kZXBlbmRlbnQgRXhlY3V0YWJsZSAoUElF
KSBzdXBwb3J0IHdpbGwgYWxsb3cgdG8gZXh0ZW5kZWQgdGhlCktBU0xSIHJhbmRvbWl6YXRpb24g
cmFuZ2UgYmVsb3cgdGhlIC0yRyBtZW1vcnkgbGltaXQuCgpTaWduZWQtb2ZmLWJ5OiBUaG9tYXMg
R2FybmllciA8dGhnYXJuaWVAZ29vZ2xlLmNvbT4KLS0tCiBpbmNsdWRlL2FzbS1nZW5lcmljL3Zt
bGludXgubGRzLmggfCAxMiArKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRp
b25zKCspCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9hc20tZ2VuZXJpYy92bWxpbnV4Lmxkcy5oIGIv
aW5jbHVkZS9hc20tZ2VuZXJpYy92bWxpbnV4Lmxkcy5oCmluZGV4IGUzNzNlMmUxMGY2YS4uZTVi
MDcxMGZlNjkzIDEwMDY0NAotLS0gYS9pbmNsdWRlL2FzbS1nZW5lcmljL3ZtbGludXgubGRzLmgK
KysrIGIvaW5jbHVkZS9hc20tZ2VuZXJpYy92bWxpbnV4Lmxkcy5oCkBAIC0zMTQsNiArMzE0LDE3
IEBACiAJX19lbmRfcm9fYWZ0ZXJfaW5pdCA9IC47CiAjZW5kaWYKIAorI2lmZGVmIENPTkZJR19Y
ODZfUElFCisjZGVmaW5lIFJPX0dPVF9YODYJCQkJCQkJXAorCS5nb3QgICAgICAgIDogQVQoQURE
UiguZ290KSAtIExPQURfT0ZGU0VUKSB7CQkJXAorCQlWTUxJTlVYX1NZTUJPTChfX3N0YXJ0X2dv
dCkgPSAuOwkJCVwKKwkJKiguZ290KTsJCQkJCQlcCisJCVZNTElOVVhfU1lNQk9MKF9fZW5kX2dv
dCkgPSAuOwkJCQlcCisJfQorI2Vsc2UKKyNkZWZpbmUgUk9fR09UX1g4NgorI2VuZGlmCisKIC8q
CiAgKiBSZWFkIG9ubHkgRGF0YQogICovCkBAIC0zNzAsNiArMzgxLDcgQEAKIAkJX19lbmRfYnVp
bHRpbl9mdyA9IC47CQkJCQlcCiAJfQkJCQkJCQkJXAogCQkJCQkJCQkJXAorCVJPX0dPVF9YODYJ
CQkJCQkJXAogCVRSQUNFREFUQQkJCQkJCQlcCiAJCQkJCQkJCQlcCiAJLyogS2VybmVsIHN5bWJv
bCB0YWJsZTogTm9ybWFsIHN5bWJvbHMgKi8JCQlcCi0tIAoyLjE3LjAuNDQxLmdiNDZmZTYwZTFk
LWdvb2cKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpY
ZW4tZGV2ZWwgbWFpbGluZyBsaXN0Clhlbi1kZXZlbEBsaXN0cy54ZW5wcm9qZWN0Lm9yZwpodHRw
czovL2xpc3RzLnhlbnByb2plY3Qub3JnL21haWxtYW4vbGlzdGluZm8veGVuLWRldmVs
