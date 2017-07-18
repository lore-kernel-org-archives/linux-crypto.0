From: Thomas Garnier <thgarnie@google.com>
Subject: [RFC 04/22] x86: Add macro to get symbol address for
	PIE support
Date: Tue, 18 Jul 2017 15:33:15 -0700
Message-ID: <20170718223333.110371-5-thgarnie@google.com>
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

QWRkIGEgbmV3IF9BU01fR0VUX1BUUiBtYWNybyB0byBmZXRjaCBhIHN5bWJvbCBhZGRyZXNzLiBJ
dCB3aWxsIGJlIHVzZWQKdG8gcmVwbGFjZSAiX0FTTV9NT1YgJDxzeW1ib2w+LCAlZHN0IiBjb2Rl
IGNvbnN0cnVjdCB0aGF0IGFyZSBub3QgY29tcGF0aWJsZQp3aXRoIFBJRS4KClNpZ25lZC1vZmYt
Ynk6IFRob21hcyBHYXJuaWVyIDx0aGdhcm5pZUBnb29nbGUuY29tPgotLS0KIGFyY2gveDg2L2lu
Y2x1ZGUvYXNtL2FzbS5oIHwgMTMgKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDEzIGlu
c2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9hc20uaCBiL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL2FzbS5oCmluZGV4IDdhOWRmM2JlYjg5Yi4uYmYyODQyY2ZiNTgz
IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9hc20uaAorKysgYi9hcmNoL3g4Ni9p
bmNsdWRlL2FzbS9hc20uaApAQCAtNTUsNiArNTUsMTkgQEAKICMgZGVmaW5lIENDX09VVChjKSBb
X2NjXyAjIyBjXSAiPXFtIgogI2VuZGlmCiAKKy8qIE1hY3JvcyB0byBnZXQgYSBnbG9iYWwgdmFy
aWFibGUgYWRkcmVzcyB3aXRoIFBJRSBzdXBwb3J0IG9uIDY0LWJpdCAqLworI2lmZGVmIENPTkZJ
R19YODZfMzIKKyNkZWZpbmUgX19BU01fR0VUX1BUUl9QUkUoX3NyYykgX19BU01fRk9STV9DT01N
QShtb3ZsICQjI19zcmMpCisjZWxzZQorI2lmZGVmIF9fQVNTRU1CTFlfXworI2RlZmluZSBfX0FT
TV9HRVRfUFRSX1BSRShfc3JjKSBfX0FTTV9GT1JNX0NPTU1BKGxlYXEgKF9zcmMpKCVyaXApKQor
I2Vsc2UKKyNkZWZpbmUgX19BU01fR0VUX1BUUl9QUkUoX3NyYykgX19BU01fRk9STV9DT01NQShs
ZWFxIChfc3JjKSglJXJpcCkpCisjZW5kaWYKKyNlbmRpZgorI2RlZmluZSBfQVNNX0dFVF9QVFIo
X3NyYywgX2RzdCkgXAorCQlfX0FTTV9HRVRfUFRSX1BSRShfc3JjKSBfX0FTTV9GT1JNKF9kc3Qp
CisKIC8qIEV4Y2VwdGlvbiB0YWJsZSBlbnRyeSAqLwogI2lmZGVmIF9fQVNTRU1CTFlfXwogIyBk
ZWZpbmUgX0FTTV9FWFRBQkxFX0hBTkRMRShmcm9tLCB0bywgaGFuZGxlcikJCQlcCi0tIAoyLjEz
LjIuOTMyLmc3NDQ5ZTk2NGMtZ29vZwoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fClhlbi1kZXZlbCBtYWlsaW5nIGxpc3QKWGVuLWRldmVsQGxpc3RzLnhl
bi5vcmcKaHR0cHM6Ly9saXN0cy54ZW4ub3JnL3hlbi1kZXZlbAo=
