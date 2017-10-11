From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v1 04/27] x86: Add macro to get symbol address
	for PIE support
Date: Wed, 11 Oct 2017 13:30:04 -0700
Message-ID: <20171011203027.11248-5-thgarnie@google.com>
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

QWRkIGEgbmV3IF9BU01fR0VUX1BUUiBtYWNybyB0byBmZXRjaCBhIHN5bWJvbCBhZGRyZXNzLiBJ
dCB3aWxsIGJlIHVzZWQKdG8gcmVwbGFjZSAiX0FTTV9NT1YgJDxzeW1ib2w+LCAlZHN0IiBjb2Rl
IGNvbnN0cnVjdCB0aGF0IGFyZSBub3QgY29tcGF0aWJsZQp3aXRoIFBJRS4KClNpZ25lZC1vZmYt
Ynk6IFRob21hcyBHYXJuaWVyIDx0aGdhcm5pZUBnb29nbGUuY29tPgotLS0KIGFyY2gveDg2L2lu
Y2x1ZGUvYXNtL2FzbS5oIHwgMTMgKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDEzIGlu
c2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9hc20uaCBiL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL2FzbS5oCmluZGV4IGIwZGM5MWY0YmVkYy4uNmRlMzY1YjhlM2Zk
IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9hc20uaAorKysgYi9hcmNoL3g4Ni9p
bmNsdWRlL2FzbS9hc20uaApAQCAtNTcsNiArNTcsMTkgQEAKICMgZGVmaW5lIENDX09VVChjKSBb
X2NjXyAjIyBjXSAiPXFtIgogI2VuZGlmCiAKKy8qIE1hY3JvcyB0byBnZXQgYSBnbG9iYWwgdmFy
aWFibGUgYWRkcmVzcyB3aXRoIFBJRSBzdXBwb3J0IG9uIDY0LWJpdCAqLworI2lmZGVmIENPTkZJ
R19YODZfMzIKKyNkZWZpbmUgX19BU01fR0VUX1BUUl9QUkUoX3NyYykgX19BU01fRk9STV9DT01N
QShtb3ZsICQjI19zcmMpCisjZWxzZQorI2lmZGVmIF9fQVNTRU1CTFlfXworI2RlZmluZSBfX0FT
TV9HRVRfUFRSX1BSRShfc3JjKSBfX0FTTV9GT1JNX0NPTU1BKGxlYXEgKF9zcmMpKCVyaXApKQor
I2Vsc2UKKyNkZWZpbmUgX19BU01fR0VUX1BUUl9QUkUoX3NyYykgX19BU01fRk9STV9DT01NQShs
ZWFxIChfc3JjKSglJXJpcCkpCisjZW5kaWYKKyNlbmRpZgorI2RlZmluZSBfQVNNX0dFVF9QVFIo
X3NyYywgX2RzdCkgXAorCQlfX0FTTV9HRVRfUFRSX1BSRShfc3JjKSBfX0FTTV9GT1JNKF9kc3Qp
CisKIC8qIEV4Y2VwdGlvbiB0YWJsZSBlbnRyeSAqLwogI2lmZGVmIF9fQVNTRU1CTFlfXwogIyBk
ZWZpbmUgX0FTTV9FWFRBQkxFX0hBTkRMRShmcm9tLCB0bywgaGFuZGxlcikJCQlcCi0tIAoyLjE1
LjAucmMwLjI3MS5nMzZiNjY5ZWRjYy1nb29nCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlz
dHMueGVuLm9yZwpodHRwczovL2xpc3RzLnhlbi5vcmcveGVuLWRldmVsCg==
