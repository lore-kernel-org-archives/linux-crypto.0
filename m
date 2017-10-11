From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v1 21/27] x86/mm/dump_pagetables: Fix address
	markers index on x86_64
Date: Wed, 11 Oct 2017 13:30:21 -0700
Message-ID: <20171011203027.11248-22-thgarnie@google.com>
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

VGhlIGFkZHJlc3NfbWFya2Vyc19pZHggZW51bSBpcyBub3QgYWxpZ25lZCB3aXRoIHRoZSB0YWJs
ZSB3aGVuIEVGSSBpcwplbmFibGVkLiBBZGQgYW4gRUZJX1ZBX0VORF9OUiBlbnRyeSBpbiB0aGlz
IGNhc2UuCgpTaWduZWQtb2ZmLWJ5OiBUaG9tYXMgR2FybmllciA8dGhnYXJuaWVAZ29vZ2xlLmNv
bT4KLS0tCiBhcmNoL3g4Ni9tbS9kdW1wX3BhZ2V0YWJsZXMuYyB8IDcgKysrKystLQogMSBmaWxl
IGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9tbS9kdW1wX3BhZ2V0YWJsZXMuYyBiL2FyY2gveDg2L21tL2R1bXBfcGFnZXRhYmxl
cy5jCmluZGV4IDVlM2FjNmZlNmM5ZS4uODY5MWE1N2RhNjNlIDEwMDY0NAotLS0gYS9hcmNoL3g4
Ni9tbS9kdW1wX3BhZ2V0YWJsZXMuYworKysgYi9hcmNoL3g4Ni9tbS9kdW1wX3BhZ2V0YWJsZXMu
YwpAQCAtNTIsMTIgKzUyLDE1IEBAIGVudW0gYWRkcmVzc19tYXJrZXJzX2lkeCB7CiAJTE9XX0tF
Uk5FTF9OUiwKIAlWTUFMTE9DX1NUQVJUX05SLAogCVZNRU1NQVBfU1RBUlRfTlIsCi0jaWZkZWYg
Q09ORklHX0tBU0FOCisjIGlmZGVmIENPTkZJR19LQVNBTgogCUtBU0FOX1NIQURPV19TVEFSVF9O
UiwKIAlLQVNBTl9TSEFET1dfRU5EX05SLAotI2VuZGlmCisjIGVuZGlmCiAjIGlmZGVmIENPTkZJ
R19YODZfRVNQRklYNjQKIAlFU1BGSVhfU1RBUlRfTlIsCisjIGVuZGlmCisjIGlmZGVmIENPTkZJ
R19FRkkKKwlFRklfVkFfRU5EX05SLAogIyBlbmRpZgogCUhJR0hfS0VSTkVMX05SLAogCU1PRFVM
RVNfVkFERFJfTlIsCi0tIAoyLjE1LjAucmMwLjI3MS5nMzZiNjY5ZWRjYy1nb29nCgoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWGVuLWRldmVsIG1haWxp
bmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMueGVuLm9yZwpodHRwczovL2xpc3RzLnhlbi5vcmcveGVu
LWRldmVsCg==
