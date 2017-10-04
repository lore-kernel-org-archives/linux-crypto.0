From: Thomas Garnier <thgarnie@google.com>
Subject: [RFC v3 02/27] x86: Use symbol name on bug table for
	PIE support
Date: Wed,  4 Oct 2017 14:19:38 -0700
Message-ID: <20171004212003.28296-3-thgarnie@google.com>
References: <20171004212003.28296-1-thgarnie@google.com>
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
 Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>,
 Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>,
 Matthias Kaehlcke <mka@chromium.org>,
 Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>,
 Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
 Juergen Gross <jgross@suse.com>, Chris Wright <chrisw@sous-sol.org>,
 Alok Kataria <akataria@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
 Bor
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <20171004212003.28296-1-thgarnie@google.com>
List-Unsubscribe: <https://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <https://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xen.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xen.org>
List-Id: linux-crypto.vger.kernel.org

UmVwbGFjZSB0aGUgJWMgY29uc3RyYWludCB3aXRoICVQLiBUaGUgJWMgaXMgaW5jb21wYXRpYmxl
IHdpdGggUElFCmJlY2F1c2UgaXQgaW1wbGllcyBhbiBpbW1lZGlhdGUgdmFsdWUgd2hlcmVhcyAl
UCByZWZlcmVuY2UgYSBzeW1ib2wuCgpQb3NpdGlvbiBJbmRlcGVuZGVudCBFeGVjdXRhYmxlIChQ
SUUpIHN1cHBvcnQgd2lsbCBhbGxvdyB0byBleHRlbmRlZCB0aGUKS0FTTFIgcmFuZG9taXphdGlv
biByYW5nZSBiZWxvdyB0aGUgLTJHIG1lbW9yeSBsaW1pdC4KClNpZ25lZC1vZmYtYnk6IFRob21h
cyBHYXJuaWVyIDx0aGdhcm5pZUBnb29nbGUuY29tPgotLS0KIGFyY2gveDg2L2luY2x1ZGUvYXNt
L2J1Zy5oIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9u
KC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vYnVnLmggYi9hcmNoL3g4Ni9p
bmNsdWRlL2FzbS9idWcuaAppbmRleCBhYTZiMjAyM2Q4ZjguLjEyMTBkMjJhZDU0NyAxMDA2NDQK
LS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vYnVnLmgKKysrIGIvYXJjaC94ODYvaW5jbHVkZS9h
c20vYnVnLmgKQEAgLTM3LDcgKzM3LDcgQEAgZG8gewkJCQkJCQkJCVwKIAlhc20gdm9sYXRpbGUo
IjE6XHQiIGlucyAiXG4iCQkJCQlcCiAJCSAgICAgIi5wdXNoc2VjdGlvbiBfX2J1Z190YWJsZSxc
ImF3XCJcbiIJCVwKIAkJICAgICAiMjpcdCIgX19CVUdfUkVMKDFiKSAiXHQjIGJ1Z19lbnRyeTo6
YnVnX2FkZHJcbiIJXAotCQkgICAgICJcdCIgIF9fQlVHX1JFTCglYzApICJcdCMgYnVnX2VudHJ5
OjpmaWxlXG4iCVwKKwkJICAgICAiXHQiICBfX0JVR19SRUwoJVAwKSAiXHQjIGJ1Z19lbnRyeTo6
ZmlsZVxuIglcCiAJCSAgICAgIlx0LndvcmQgJWMxIiAgICAgICAgIlx0IyBidWdfZW50cnk6Omxp
bmVcbiIJXAogCQkgICAgICJcdC53b3JkICVjMiIgICAgICAgICJcdCMgYnVnX2VudHJ5OjpmbGFn
c1xuIglcCiAJCSAgICAgIlx0Lm9yZyAyYislYzNcbiIJCQkJCVwKLS0gCjIuMTQuMi45MjAuZ2Nm
MGM2Nzk3OWMtZ29vZwoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fClhlbi1kZXZlbCBtYWlsaW5nIGxpc3QKWGVuLWRldmVsQGxpc3RzLnhlbi5vcmcKaHR0
cHM6Ly9saXN0cy54ZW4ub3JnL3hlbi1kZXZlbAo=
