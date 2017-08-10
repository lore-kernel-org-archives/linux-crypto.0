From: Thomas Garnier <thgarnie@google.com>
Subject: [RFC v2 02/23] x86: Use symbol name on bug table for
	PIE support
Date: Thu, 10 Aug 2017 10:25:54 -0700
Message-ID: <20170810172615.51965-3-thgarnie@google.com>
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
c1xuIglcCiAJCSAgICAgIlx0Lm9yZyAyYislYzNcbiIJCQkJCVwKLS0gCjIuMTQuMC40MzQuZzk4
MDk2ZmQ3YTgtZ29vZwoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fClhlbi1kZXZlbCBtYWlsaW5nIGxpc3QKWGVuLWRldmVsQGxpc3RzLnhlbi5vcmcKaHR0
cHM6Ly9saXN0cy54ZW4ub3JnL3hlbi1kZXZlbAo=
