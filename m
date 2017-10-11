From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v1 24/27] x86/mm: Make the x86 GOT read-only
Date: Wed, 11 Oct 2017 13:30:24 -0700
Message-ID: <20171011203027.11248-25-thgarnie@google.com>
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

VGhlIEdPVCBpcyBjaGFuZ2VkIGR1cmluZyBlYXJseSBib290IHdoZW4gcmVsb2NhdGlvbnMgYXJl
IGFwcGxpZWQuIE1ha2UKaXQgcmVhZC1vbmx5IGRpcmVjdGx5LiBUaGlzIHRhYmxlIGV4aXN0cyBv
bmx5IGZvciBQSUUgYmluYXJ5LgoKUG9zaXRpb24gSW5kZXBlbmRlbnQgRXhlY3V0YWJsZSAoUElF
KSBzdXBwb3J0IHdpbGwgYWxsb3cgdG8gZXh0ZW5kZWQgdGhlCktBU0xSIHJhbmRvbWl6YXRpb24g
cmFuZ2UgYmVsb3cgdGhlIC0yRyBtZW1vcnkgbGltaXQuCgpTaWduZWQtb2ZmLWJ5OiBUaG9tYXMg
R2FybmllciA8dGhnYXJuaWVAZ29vZ2xlLmNvbT4KLS0tCiBpbmNsdWRlL2FzbS1nZW5lcmljL3Zt
bGludXgubGRzLmggfCAxMiArKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRp
b25zKCspCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9hc20tZ2VuZXJpYy92bWxpbnV4Lmxkcy5oIGIv
aW5jbHVkZS9hc20tZ2VuZXJpYy92bWxpbnV4Lmxkcy5oCmluZGV4IGU1NDliZmY4N2M1Yi4uYTIz
MDFjMjkyZTI2IDEwMDY0NAotLS0gYS9pbmNsdWRlL2FzbS1nZW5lcmljL3ZtbGludXgubGRzLmgK
KysrIGIvaW5jbHVkZS9hc20tZ2VuZXJpYy92bWxpbnV4Lmxkcy5oCkBAIC0yNzksNiArMjc5LDE3
IEBACiAJVk1MSU5VWF9TWU1CT0woX19lbmRfcm9fYWZ0ZXJfaW5pdCkgPSAuOwogI2VuZGlmCiAK
KyNpZmRlZiBDT05GSUdfWDg2X1BJRQorI2RlZmluZSBST19HT1RfWDg2CQkJCQkJCVwKKwkuZ290
ICAgICAgICA6IEFUKEFERFIoLmdvdCkgLSBMT0FEX09GRlNFVCkgewkJCVwKKwkJVk1MSU5VWF9T
WU1CT0woX19zdGFydF9nb3QpID0gLjsJCQlcCisJCSooLmdvdCk7CQkJCQkJXAorCQlWTUxJTlVY
X1NZTUJPTChfX2VuZF9nb3QpID0gLjsJCQkJXAorCX0KKyNlbHNlCisjZGVmaW5lIFJPX0dPVF9Y
ODYKKyNlbmRpZgorCiAvKgogICogUmVhZCBvbmx5IERhdGEKICAqLwpAQCAtMzM1LDYgKzM0Niw3
IEBACiAJCVZNTElOVVhfU1lNQk9MKF9fZW5kX2J1aWx0aW5fZncpID0gLjsJCQlcCiAJfQkJCQkJ
CQkJXAogCQkJCQkJCQkJXAorCVJPX0dPVF9YODYJCQkJCQkJXAogCVRSQUNFREFUQQkJCQkJCQlc
CiAJCQkJCQkJCQlcCiAJLyogS2VybmVsIHN5bWJvbCB0YWJsZTogTm9ybWFsIHN5bWJvbHMgKi8J
CQlcCi0tIAoyLjE1LjAucmMwLjI3MS5nMzZiNjY5ZWRjYy1nb29nCgoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApY
ZW4tZGV2ZWxAbGlzdHMueGVuLm9yZwpodHRwczovL2xpc3RzLnhlbi5vcmcveGVuLWRldmVsCg==
