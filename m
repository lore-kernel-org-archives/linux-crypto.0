From: Thomas Garnier <thgarnie@google.com>
Subject: [RFC 02/22] x86: Use symbol name on bug table for PIE
	support
Date: Tue, 18 Jul 2017 15:33:13 -0700
Message-ID: <20170718223333.110371-3-thgarnie@google.com>
References: <20170718223333.110371-1-thgarnie@google.com>
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
 Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>,
 Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
 Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>,
 Borislav Petkov <bp@alien8.de>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@suse.de>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <20170718223333.110371-1-thgarnie@google.com>
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
bmNsdWRlL2FzbS9idWcuaAppbmRleCAzOWU3MDJkOTBjZGIuLjIzMDdlMmFjZWIwMCAxMDA2NDQK
LS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vYnVnLmgKKysrIGIvYXJjaC94ODYvaW5jbHVkZS9h
c20vYnVnLmgKQEAgLTM3LDcgKzM3LDcgQEAgZG8gewkJCQkJCQkJCVwKIAlhc20gdm9sYXRpbGUo
IjE6XHQiIGlucyAiXG4iCQkJCQlcCiAJCSAgICAgIi5wdXNoc2VjdGlvbiBfX2J1Z190YWJsZSxc
ImFcIlxuIgkJCVwKIAkJICAgICAiMjpcdCIgX19CVUdfUkVMKDFiKSAiXHQjIGJ1Z19lbnRyeTo6
YnVnX2FkZHJcbiIJXAotCQkgICAgICJcdCIgIF9fQlVHX1JFTCglYzApICJcdCMgYnVnX2VudHJ5
OjpmaWxlXG4iCVwKKwkJICAgICAiXHQiICBfX0JVR19SRUwoJVAwKSAiXHQjIGJ1Z19lbnRyeTo6
ZmlsZVxuIglcCiAJCSAgICAgIlx0LndvcmQgJWMxIiAgICAgICAgIlx0IyBidWdfZW50cnk6Omxp
bmVcbiIJXAogCQkgICAgICJcdC53b3JkICVjMiIgICAgICAgICJcdCMgYnVnX2VudHJ5OjpmbGFn
c1xuIglcCiAJCSAgICAgIlx0Lm9yZyAyYislYzNcbiIJCQkJCVwKLS0gCjIuMTMuMi45MzIuZzc0
NDllOTY0Yy1nb29nCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMueGVuLm9yZwpodHRw
czovL2xpc3RzLnhlbi5vcmcveGVuLWRldmVsCg==
