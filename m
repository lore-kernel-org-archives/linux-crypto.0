From: Thomas Garnier <thgarnie@google.com>
Subject: [RFC 03/22] x86: Use symbol name in jump table for PIE
	support
Date: Tue, 18 Jul 2017 15:33:14 -0700
Message-ID: <20170718223333.110371-4-thgarnie@google.com>
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
L2p1bXBfbGFiZWwuaCB8IDggKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMo
KyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vanVt
cF9sYWJlbC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vanVtcF9sYWJlbC5oCmluZGV4IGFkYzU0
YzEyY2JkMS4uNmU1NThlNDUyNGRjIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9q
dW1wX2xhYmVsLmgKKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vanVtcF9sYWJlbC5oCkBAIC0z
Niw5ICszNiw5IEBAIHN0YXRpYyBfX2Fsd2F5c19pbmxpbmUgYm9vbCBhcmNoX3N0YXRpY19icmFu
Y2goc3RydWN0IHN0YXRpY19rZXkgKmtleSwgYm9vbCBicmFuCiAJCSIuYnl0ZSAiIF9fc3RyaW5n
aWZ5KFNUQVRJQ19LRVlfSU5JVF9OT1ApICJcblx0IgogCQkiLnB1c2hzZWN0aW9uIF9fanVtcF90
YWJsZSwgIFwiYXdcIiBcblx0IgogCQlfQVNNX0FMSUdOICJcblx0IgotCQlfQVNNX1BUUiAiMWIs
ICVsW2xfeWVzXSwgJWMwICsgJWMxIFxuXHQiCisJCV9BU01fUFRSICIxYiwgJWxbbF95ZXNdLCAl
UDAgXG5cdCIKIAkJIi5wb3BzZWN0aW9uIFxuXHQiCi0JCTogOiAgImkiIChrZXkpLCAiaSIgKGJy
YW5jaCkgOiA6IGxfeWVzKTsKKwkJOiA6ICAiWCIgKCYoKGNoYXIgKilrZXkpW2JyYW5jaF0pIDog
OiBsX3llcyk7CiAKIAlyZXR1cm4gZmFsc2U7CiBsX3llczoKQEAgLTUyLDkgKzUyLDkgQEAgc3Rh
dGljIF9fYWx3YXlzX2lubGluZSBib29sIGFyY2hfc3RhdGljX2JyYW5jaF9qdW1wKHN0cnVjdCBz
dGF0aWNfa2V5ICprZXksIGJvb2wKIAkJIjI6XG5cdCIKIAkJIi5wdXNoc2VjdGlvbiBfX2p1bXBf
dGFibGUsICBcImF3XCIgXG5cdCIKIAkJX0FTTV9BTElHTiAiXG5cdCIKLQkJX0FTTV9QVFIgIjFi
LCAlbFtsX3llc10sICVjMCArICVjMSBcblx0IgorCQlfQVNNX1BUUiAiMWIsICVsW2xfeWVzXSwg
JVAwIFxuXHQiCiAJCSIucG9wc2VjdGlvbiBcblx0IgotCQk6IDogICJpIiAoa2V5KSwgImkiIChi
cmFuY2gpIDogOiBsX3llcyk7CisJCTogOiAgIlgiICgmKChjaGFyICopa2V5KVticmFuY2hdKSA6
IDogbF95ZXMpOwogCiAJcmV0dXJuIGZhbHNlOwogbF95ZXM6Ci0tIAoyLjEzLjIuOTMyLmc3NDQ5
ZTk2NGMtZ29vZwoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fClhlbi1kZXZlbCBtYWlsaW5nIGxpc3QKWGVuLWRldmVsQGxpc3RzLnhlbi5vcmcKaHR0cHM6
Ly9saXN0cy54ZW4ub3JnL3hlbi1kZXZlbAo=
