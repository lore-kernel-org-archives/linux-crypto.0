From: Thomas Garnier <thgarnie@google.com>
Subject: [RFC 15/22] x86/boot/64: Use _text in a global for PIE
	support
Date: Tue, 18 Jul 2017 15:33:26 -0700
Message-ID: <20170718223333.110371-16-thgarnie@google.com>
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

QnkgZGVmYXVsdCBQSUUgZ2VuZXJhdGVkIGNvZGUgY3JlYXRlIG9ubHkgcmVsYXRpdmUgcmVmZXJl
bmNlcyBzbyBfdGV4dApwb2ludHMgdG8gdGhlIHRlbXBvcmFyeSB2aXJ0dWFsIGFkZHJlc3MuIElu
c3RlYWQgdXNlIGEgZ2xvYmFsIHZhcmlhYmxlCnNvIHRoZSByZWxvY2F0aW9uIGlzIGRvbmUgYXMg
ZXhwZWN0ZWQuCgpQb3NpdGlvbiBJbmRlcGVuZGVudCBFeGVjdXRhYmxlIChQSUUpIHN1cHBvcnQg
d2lsbCBhbGxvdyB0byBleHRlbmRlZCB0aGUKS0FTTFIgcmFuZG9taXphdGlvbiByYW5nZSBiZWxv
dyB0aGUgLTJHIG1lbW9yeSBsaW1pdC4KClNpZ25lZC1vZmYtYnk6IFRob21hcyBHYXJuaWVyIDx0
aGdhcm5pZUBnb29nbGUuY29tPgotLS0KIGFyY2gveDg2L2tlcm5lbC9oZWFkNjQuYyB8IDEwICsr
KysrKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2hlYWQ2NC5jIGIvYXJjaC94ODYva2VybmVs
L2hlYWQ2NC5jCmluZGV4IDQ2YzNjNzNlN2Y0My4uNDEwM2U5MGZmMTI4IDEwMDY0NAotLS0gYS9h
cmNoL3g4Ni9rZXJuZWwvaGVhZDY0LmMKKysrIGIvYXJjaC94ODYva2VybmVsL2hlYWQ2NC5jCkBA
IC00NSw3ICs0NSwxMyBAQCBzdGF0aWMgdm9pZCBfX2hlYWQgKmZpeHVwX3BvaW50ZXIodm9pZCAq
cHRyLCB1bnNpZ25lZCBsb25nIHBoeXNhZGRyKQogCXJldHVybiBwdHIgLSAodm9pZCAqKV90ZXh0
ICsgKHZvaWQgKilwaHlzYWRkcjsKIH0KIAotdm9pZCBfX2hlYWQgX19zdGFydHVwXzY0KHVuc2ln
bmVkIGxvbmcgcGh5c2FkZHIpCisvKgorICogVXNlIGEgZ2xvYmFsIHZhcmlhYmxlIHRvIHByb3Bl
cmx5IGNhbGN1bGF0ZSBfdGV4dCBkZWx0YSBvbiBQSUUuIEJ5IGRlZmF1bHQKKyAqIGEgUElFIGJp
bmFyeSBkbyBhIFJJUCByZWxhdGl2ZSBkaWZmZXJlbmNlIGluc3RlYWQgb2YgdGhlIHJlbG9jYXRl
ZCBhZGRyZXNzLgorICovCit1bnNpZ25lZCBsb25nIF90ZXh0X29mZnNldCA9ICh1bnNpZ25lZCBs
b25nKShfdGV4dCAtIF9fU1RBUlRfS0VSTkVMX21hcCk7CisKK3ZvaWQgX19oZWFkIG5vdHJhY2Ug
X19zdGFydHVwXzY0KHVuc2lnbmVkIGxvbmcgcGh5c2FkZHIpCiB7CiAJdW5zaWduZWQgbG9uZyBs
b2FkX2RlbHRhLCAqcDsKIAlwZ2R2YWxfdCAqcGdkOwpAQCAtNjIsNyArNjgsNyBAQCB2b2lkIF9f
aGVhZCBfX3N0YXJ0dXBfNjQodW5zaWduZWQgbG9uZyBwaHlzYWRkcikKIAkgKiBDb21wdXRlIHRo
ZSBkZWx0YSBiZXR3ZWVuIHRoZSBhZGRyZXNzIEkgYW0gY29tcGlsZWQgdG8gcnVuIGF0CiAJICog
YW5kIHRoZSBhZGRyZXNzIEkgYW0gYWN0dWFsbHkgcnVubmluZyBhdC4KIAkgKi8KLQlsb2FkX2Rl
bHRhID0gcGh5c2FkZHIgLSAodW5zaWduZWQgbG9uZykoX3RleHQgLSBfX1NUQVJUX0tFUk5FTF9t
YXApOworCWxvYWRfZGVsdGEgPSBwaHlzYWRkciAtIF90ZXh0X29mZnNldDsKIAogCS8qIElzIHRo
ZSBhZGRyZXNzIG5vdCAyTSBhbGlnbmVkPyAqLwogCWlmIChsb2FkX2RlbHRhICYgflBNRF9QQUdF
X01BU0spCi0tIAoyLjEzLjIuOTMyLmc3NDQ5ZTk2NGMtZ29vZwoKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClhlbi1kZXZlbCBtYWlsaW5nIGxpc3QKWGVu
LWRldmVsQGxpc3RzLnhlbi5vcmcKaHR0cHM6Ly9saXN0cy54ZW4ub3JnL3hlbi1kZXZlbAo=
