From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v1 08/27] x86/CPU: Adapt assembly for PIE support
Date: Wed, 11 Oct 2017 13:30:08 -0700
Message-ID: <20171011203027.11248-9-thgarnie@google.com>
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

Q2hhbmdlIHRoZSBhc3NlbWJseSBjb2RlIHRvIHVzZSBvbmx5IHJlbGF0aXZlIHJlZmVyZW5jZXMg
b2Ygc3ltYm9scyBmb3IgdGhlCmtlcm5lbCB0byBiZSBQSUUgY29tcGF0aWJsZS4gVXNlIHRoZSBu
ZXcgX0FTTV9HRVRfUFRSIG1hY3JvIGluc3RlYWQgb2YKdGhlICdtb3YgJHN5bWJvbCwgJWRzdCcg
Y29uc3RydWN0IHRvIG5vdCBoYXZlIGFuIGFic29sdXRlIHJlZmVyZW5jZS4KClBvc2l0aW9uIElu
ZGVwZW5kZW50IEV4ZWN1dGFibGUgKFBJRSkgc3VwcG9ydCB3aWxsIGFsbG93IHRvIGV4dGVuZGVk
IHRoZQpLQVNMUiByYW5kb21pemF0aW9uIHJhbmdlIGJlbG93IHRoZSAtMkcgbWVtb3J5IGxpbWl0
LgoKU2lnbmVkLW9mZi1ieTogVGhvbWFzIEdhcm5pZXIgPHRoZ2FybmllQGdvb2dsZS5jb20+Ci0t
LQogYXJjaC94ODYvaW5jbHVkZS9hc20vcHJvY2Vzc29yLmggfCA5ICsrKysrKy0tLQogMSBmaWxl
IGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9pbmNsdWRlL2FzbS9wcm9jZXNzb3IuaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3By
b2Nlc3Nvci5oCmluZGV4IGI0NDZjNWEwODJhZC4uYjA5YmQ1MGIwNmM3IDEwMDY0NAotLS0gYS9h
cmNoL3g4Ni9pbmNsdWRlL2FzbS9wcm9jZXNzb3IuaAorKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS9wcm9jZXNzb3IuaApAQCAtNDksNyArNDksNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgKmN1cnJl
bnRfdGV4dF9hZGRyKHZvaWQpCiB7CiAJdm9pZCAqcGM7CiAKLQlhc20gdm9sYXRpbGUoIm1vdiAk
MWYsICUwOyAxOiI6Ij1yIiAocGMpKTsKKwlhc20gdm9sYXRpbGUoX0FTTV9HRVRfUFRSKDFmLCAl
MCkgIjsgMToiOiI9ciIgKHBjKSk7CiAKIAlyZXR1cm4gcGM7CiB9CkBAIC02OTUsNiArNjk1LDcg
QEAgc3RhdGljIGlubGluZSB2b2lkIHN5bmNfY29yZSh2b2lkKQogCQk6IEFTTV9DQUxMX0NPTlNU
UkFJTlQgOiA6ICJtZW1vcnkiKTsKICNlbHNlCiAJdW5zaWduZWQgaW50IHRtcDsKKwl1bnNpZ25l
ZCBsb25nIHRtcDI7CiAKIAlhc20gdm9sYXRpbGUgKAogCQlVTldJTkRfSElOVF9TQVZFCkBAIC03
MDUsMTEgKzcwNiwxMyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgc3luY19jb3JlKHZvaWQpCiAJCSJw
dXNoZnFcblx0IgogCQkibW92ICUlY3MsICUwXG5cdCIKIAkJInB1c2hxICVxMFxuXHQiCi0JCSJw
dXNocSAkMWZcblx0IgorCQkibGVhcSAxZiglJXJpcCksICUxXG5cdCIKKwkJInB1c2hxICUxXG5c
dCIKIAkJImlyZXRxXG5cdCIKIAkJVU5XSU5EX0hJTlRfUkVTVE9SRQogCQkiMToiCi0JCTogIj0m
ciIgKHRtcCksIEFTTV9DQUxMX0NPTlNUUkFJTlQgOiA6ICJjYyIsICJtZW1vcnkiKTsKKwkJOiAi
PSZyIiAodG1wKSwgIj0mciIgKHRtcDIpLCBBU01fQ0FMTF9DT05TVFJBSU5UCisJCTogOiAiY2Mi
LCAibWVtb3J5Iik7CiAjZW5kaWYKIH0KIAotLSAKMi4xNS4wLnJjMC4yNzEuZzM2YjY2OWVkY2Mt
Z29vZwoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClhl
bi1kZXZlbCBtYWlsaW5nIGxpc3QKWGVuLWRldmVsQGxpc3RzLnhlbi5vcmcKaHR0cHM6Ly9saXN0
cy54ZW4ub3JnL3hlbi1kZXZlbAo=
