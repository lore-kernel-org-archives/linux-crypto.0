From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v2 24/27] x86/mm: Make the x86 GOT read-only
Date: Tue, 13 Mar 2018 13:59:42 -0700
Message-ID: <20180313205945.245105-25-thgarnie@google.com>
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

VGhlIEdPVCBpcyBjaGFuZ2VkIGR1cmluZyBlYXJseSBib290IHdoZW4gcmVsb2NhdGlvbnMgYXJl
IGFwcGxpZWQuIE1ha2UKaXQgcmVhZC1vbmx5IGRpcmVjdGx5LiBUaGlzIHRhYmxlIGV4aXN0cyBv
bmx5IGZvciBQSUUgYmluYXJ5LgoKUG9zaXRpb24gSW5kZXBlbmRlbnQgRXhlY3V0YWJsZSAoUElF
KSBzdXBwb3J0IHdpbGwgYWxsb3cgdG8gZXh0ZW5kZWQgdGhlCktBU0xSIHJhbmRvbWl6YXRpb24g
cmFuZ2UgYmVsb3cgdGhlIC0yRyBtZW1vcnkgbGltaXQuCgpTaWduZWQtb2ZmLWJ5OiBUaG9tYXMg
R2FybmllciA8dGhnYXJuaWVAZ29vZ2xlLmNvbT4KLS0tCiBpbmNsdWRlL2FzbS1nZW5lcmljL3Zt
bGludXgubGRzLmggfCAxMiArKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRp
b25zKCspCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9hc20tZ2VuZXJpYy92bWxpbnV4Lmxkcy5oIGIv
aW5jbHVkZS9hc20tZ2VuZXJpYy92bWxpbnV4Lmxkcy5oCmluZGV4IDFhYjBlNTIwZDZmYy4uODkz
OThkMDQyZjc4IDEwMDY0NAotLS0gYS9pbmNsdWRlL2FzbS1nZW5lcmljL3ZtbGludXgubGRzLmgK
KysrIGIvaW5jbHVkZS9hc20tZ2VuZXJpYy92bWxpbnV4Lmxkcy5oCkBAIC0yOTUsNiArMjk1LDE3
IEBACiAJVk1MSU5VWF9TWU1CT0woX19lbmRfcm9fYWZ0ZXJfaW5pdCkgPSAuOwogI2VuZGlmCiAK
KyNpZmRlZiBDT05GSUdfWDg2X1BJRQorI2RlZmluZSBST19HT1RfWDg2CQkJCQkJCVwKKwkuZ290
ICAgICAgICA6IEFUKEFERFIoLmdvdCkgLSBMT0FEX09GRlNFVCkgewkJCVwKKwkJVk1MSU5VWF9T
WU1CT0woX19zdGFydF9nb3QpID0gLjsJCQlcCisJCSooLmdvdCk7CQkJCQkJXAorCQlWTUxJTlVY
X1NZTUJPTChfX2VuZF9nb3QpID0gLjsJCQkJXAorCX0KKyNlbHNlCisjZGVmaW5lIFJPX0dPVF9Y
ODYKKyNlbmRpZgorCiAvKgogICogUmVhZCBvbmx5IERhdGEKICAqLwpAQCAtMzUxLDYgKzM2Miw3
IEBACiAJCVZNTElOVVhfU1lNQk9MKF9fZW5kX2J1aWx0aW5fZncpID0gLjsJCQlcCiAJfQkJCQkJ
CQkJXAogCQkJCQkJCQkJXAorCVJPX0dPVF9YODYJCQkJCQkJXAogCVRSQUNFREFUQQkJCQkJCQlc
CiAJCQkJCQkJCQlcCiAJLyogS2VybmVsIHN5bWJvbCB0YWJsZTogTm9ybWFsIHN5bWJvbHMgKi8J
CQlcCi0tIAoyLjE2LjIuNjYwLmc3MDk4ODc5NzFiLWdvb2cKCgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwpYZW4tZGV2ZWwgbWFpbGluZyBsaXN0Clhlbi1k
ZXZlbEBsaXN0cy54ZW5wcm9qZWN0Lm9yZwpodHRwczovL2xpc3RzLnhlbnByb2plY3Qub3JnL21h
aWxtYW4vbGlzdGluZm8veGVuLWRldmVs
