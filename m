From: Thomas Garnier <thgarnie@google.com>
Subject: [RFC 05/22] xen: Adapt assembly for PIE support
Date: Tue, 18 Jul 2017 15:33:16 -0700
Message-ID: <20170718223333.110371-6-thgarnie@google.com>
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

Q2hhbmdlIHRoZSBhc3NlbWJseSBjb2RlIHRvIHVzZSB0aGUgbmV3IF9BU01fR0VUX1BUUiBtYWNy
byB3aGljaCBnZXQgYQpzeW1ib2wgcmVmZXJlbmNlIHdoaWxlIGJlaW5nIFBJRSBjb21wYXRpYmxl
LiBNb2RpZnkgdGhlIFJFTE9DIG1hY3JvIHRoYXQKd2FzIHVzaW5nIGFuIGFzc2lnbm1lbnQgZ2Vu
ZXJhdGluZyBhIG5vbi1yZWxhdGl2ZSByZWZlcmVuY2UuCgpQb3NpdGlvbiBJbmRlcGVuZGVudCBF
eGVjdXRhYmxlIChQSUUpIHN1cHBvcnQgd2lsbCBhbGxvdyB0byBleHRlbmRlZCB0aGUKS0FTTFIg
cmFuZG9taXphdGlvbiByYW5nZSBiZWxvdyB0aGUgLTJHIG1lbW9yeSBsaW1pdC4KClNpZ25lZC1v
ZmYtYnk6IFRob21hcyBHYXJuaWVyIDx0aGdhcm5pZUBnb29nbGUuY29tPgotLS0KIGFyY2gveDg2
L3hlbi94ZW4tYXNtLmggIHwgMyArKy0KIGFyY2gveDg2L3hlbi94ZW4taGVhZC5TIHwgOSArKysr
Ky0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2FyY2gveDg2L3hlbi94ZW4tYXNtLmggYi9hcmNoL3g4Ni94ZW4veGVuLWFz
bS5oCmluZGV4IDQ2NTI3NjQ2N2E0Ny4uM2IxYzhhMmU3N2Q4IDEwMDY0NAotLS0gYS9hcmNoL3g4
Ni94ZW4veGVuLWFzbS5oCisrKyBiL2FyY2gveDg2L3hlbi94ZW4tYXNtLmgKQEAgLTIsOCArMiw5
IEBACiAjZGVmaW5lIF9YRU5fWEVOX0FTTV9ICiAKICNpbmNsdWRlIDxsaW51eC9saW5rYWdlLmg+
CisjaW5jbHVkZSA8YXNtL2FzbS5oPgogCi0jZGVmaW5lIFJFTE9DKHgsIHYpCS5nbG9ibCB4IyNf
cmVsb2M7IHgjI19yZWxvYz12CisjZGVmaW5lIFJFTE9DKHgsIHYpCS5nbG9ibCB4IyNfcmVsb2M7
IHgjI19yZWxvYzogX0FTTV9QVFIgdgogI2RlZmluZSBFTkRQQVRDSCh4KQkuZ2xvYmwgeCMjX2Vu
ZDsgeCMjX2VuZD0uCiAKIC8qIFBzZXVkby1mbGFnIHVzZWQgZm9yIHZpcnR1YWwgTk1JLCB3aGlj
aCB3ZSBkb24ndCBpbXBsZW1lbnQgeWV0ICovCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni94ZW4veGVu
LWhlYWQuUyBiL2FyY2gveDg2L3hlbi94ZW4taGVhZC5TCmluZGV4IDcyYThlNmFkZWJlNi4uYWIy
NDYyMzk2YmQ4IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni94ZW4veGVuLWhlYWQuUworKysgYi9hcmNo
L3g4Ni94ZW4veGVuLWhlYWQuUwpAQCAtMjMsMTQgKzIzLDE1IEBAIEVOVFJZKHN0YXJ0dXBfeGVu
KQogCiAJLyogQ2xlYXIgLmJzcyAqLwogCXhvciAlZWF4LCVlYXgKLQltb3YgJF9fYnNzX3N0YXJ0
LCAlX0FTTV9ESQotCW1vdiAkX19ic3Nfc3RvcCwgJV9BU01fQ1gKKwlfQVNNX0dFVF9QVFIoX19i
c3Nfc3RhcnQsICVfQVNNX0RJKQorCV9BU01fR0VUX1BUUihfX2Jzc19zdG9wLCAlX0FTTV9DWCkK
IAlzdWIgJV9BU01fREksICVfQVNNX0NYCiAJc2hyICRfX0FTTV9TRUwoMiwgMyksICVfQVNNX0NY
CiAJcmVwIF9fQVNNX1NJWkUoc3RvcykKIAotCW1vdiAlX0FTTV9TSSwgeGVuX3N0YXJ0X2luZm8K
LQltb3YgJGluaXRfdGhyZWFkX3VuaW9uK1RIUkVBRF9TSVpFLCAlX0FTTV9TUAorCV9BU01fR0VU
X1BUUih4ZW5fc3RhcnRfaW5mbywgJV9BU01fQVgpCisJbW92ICVfQVNNX1NJLCAoJV9BU01fQVgp
CisJX0FTTV9HRVRfUFRSKGluaXRfdGhyZWFkX3VuaW9uK1RIUkVBRF9TSVpFLCAlX0FTTV9TUCkK
IAogCWptcCB4ZW5fc3RhcnRfa2VybmVsCiAKLS0gCjIuMTMuMi45MzIuZzc0NDllOTY0Yy1nb29n
CgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWGVuLWRl
dmVsIG1haWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMueGVuLm9yZwpodHRwczovL2xpc3RzLnhl
bi5vcmcveGVuLWRldmVsCg==
