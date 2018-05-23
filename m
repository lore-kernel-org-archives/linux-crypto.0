From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v3 04/27] x86: Add macro to get symbol address
 for PIE support
Date: Wed, 23 May 2018 12:53:58 -0700
Message-ID: <20180523195421.180248-5-thgarnie@google.com>
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

QWRkIGEgbmV3IF9BU01fTU9WQUJTIG1hY3JvIHRvIGZldGNoIGEgc3ltYm9sIGFkZHJlc3MuIEl0
IHdpbGwgYmUgdXNlZAp0byByZXBsYWNlICJfQVNNX01PViAkPHN5bWJvbD4sICVkc3QiIGNvZGUg
Y29uc3RydWN0IHRoYXQgYXJlIG5vdCBjb21wYXRpYmxlCndpdGggUElFLgoKU2lnbmVkLW9mZi1i
eTogVGhvbWFzIEdhcm5pZXIgPHRoZ2FybmllQGdvb2dsZS5jb20+Ci0tLQogYXJjaC94ODYvaW5j
bHVkZS9hc20vYXNtLmggfCAxICsKIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQoKZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2FzbS5oIGIvYXJjaC94ODYvaW5jbHVkZS9h
c20vYXNtLmgKaW5kZXggMjE5ZmFhZWM1MWRmLi40NDkyYTM1ZmFkNjkgMTAwNjQ0Ci0tLSBhL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL2FzbS5oCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2FzbS5o
CkBAIC0zMCw2ICszMCw3IEBACiAjZGVmaW5lIF9BU01fQUxJR04JX19BU01fU0VMKC5iYWxpZ24g
NCwgLmJhbGlnbiA4KQogCiAjZGVmaW5lIF9BU01fTU9WCV9fQVNNX1NJWkUobW92KQorI2RlZmlu
ZSBfQVNNX01PVkFCUwlfX0FTTV9TRUwobW92bCwgbW92YWJzcSkKICNkZWZpbmUgX0FTTV9JTkMJ
X19BU01fU0laRShpbmMpCiAjZGVmaW5lIF9BU01fREVDCV9fQVNNX1NJWkUoZGVjKQogI2RlZmlu
ZSBfQVNNX0FERAlfX0FTTV9TSVpFKGFkZCkKLS0gCjIuMTcuMC40NDEuZ2I0NmZlNjBlMWQtZ29v
ZwoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClhlbi1k
ZXZlbCBtYWlsaW5nIGxpc3QKWGVuLWRldmVsQGxpc3RzLnhlbnByb2plY3Qub3JnCmh0dHBzOi8v
bGlzdHMueGVucHJvamVjdC5vcmcvbWFpbG1hbi9saXN0aW5mby94ZW4tZGV2ZWw=
