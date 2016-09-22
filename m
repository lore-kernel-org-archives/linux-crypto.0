From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH v1 09/28] x86/efi: Access EFI data as encrypted when
 SEV is active
Date: Thu, 22 Sep 2016 19:27:32 +0200
Message-ID: <20160922172732.egjvbivmf5vmcetk@pd.tnic>
References: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
 <147190832511.9523.10850626471583956499.stgit@brijesh-build-machine>
 <20160922143545.3kl7khff6vqk7b2t@pd.tnic>
 <464461b7-1efb-0af1-dd3e-eb919a2578e9@redhat.com>
 <20160922145947.52v42l7p7dl7u3r4@pd.tnic>
 <938ee0cf-85e6-eefa-7df9-9d5e09ed7a9d@redhat.com>
 <20160922170718.34d4ppockeurrg25@pd.tnic>
 <c1a609f0-307e-9c6c-ce33-b562ca5c0624@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-efi@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>,
 kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk,
 linus.walleij@linaro.org, paul.gortmaker@windriver.com, hpa@zytor.com,
 tglx@linutronix.de, aarcange@redhat.com, sfr@canb.auug.org.au,
 mchehab@kernel.org, simon.guinot@sequanux.org, bhe@redhat.com,
 xemul@parallels.com, joro@8bytes.org, x86@kernel.org, mingo@redhat.com,
 msalter@redhat.com, ross.zwisler@linux.intel.com, labbott@fedoraproject.org,
 dyoung@redhat.com, thomas.lendacky@amd.com, jroedel@suse.de,
 keescook@chromium.org, toshi.kani@hpe.com, mathieu.desnoyers@efficios.com,
 dan.j.williams@intel.com, andriy.shevchenko@linux.intel.com,
 akpm@linux-foundation.org, herbert@gondor.apana.org.au, tony.luck@intel.com,
 linux-mm@kvack.org, kuleshovmail@gmail.com, linux-kernel@vger.kernel.org,
 mcgrof@kernel.org, linux-crypto@vger.kernel.org, devel@li
To: Paolo Bonzini <pbonzini@redhat.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <c1a609f0-307e-9c6c-ce33-b562ca5c0624@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

T24gVGh1LCBTZXAgMjIsIDIwMTYgYXQgMDc6MDg6NTBQTSArMDIwMCwgUGFvbG8gQm9uemluaSB3
cm90ZToKPiBUaGF0J3Mgbm90IGhvdyBJIHJlYWQgaXQuICBJIGp1c3QgZmlndXJlZCB0aGF0IHRo
ZSBCSU9TIGhhcyBzb21lIG1hZ2ljCj4gdGhpbmdzIGhpZ2ggaW4gdGhlIHBoeXNpY2FsIGFkZHJl
c3Mgc3BhY2UgYW5kIGlmIHlvdSByZWR1Y2UgdGhlIHBoeXNpY2FsCj4gYWRkcmVzcyBzcGFjZSB0
aGUgQklPUyAod2hpY2ggaXMgY2FsbGVkIGZyb20gZS5nLiBFRkkgcnVudGltZSBzZXJ2aWNlcykK
PiB3b3VsZCBoYXZlIHByb2JsZW1zIHdpdGggdGhhdC4KClllYWgsIEkgaGFkIHRvIGFzayBhYm91
dCB0aGF0IG15c2VsZiBhbmQgVG9tIHdpbGwgaGF2ZSBpdCBleHBsYWluZWQKYmV0dGVyIGluIHRo
ZSBuZXh0IHZlcnNpb24uCgpUaGUgcmVkdWN0aW9uIGluIHBoeXNpY2FsIGFkZHJlc3Mgc3BhY2Ug
aGFwcGVucyB3aGVuIFNNRSBlbmFibGVkIGJlY2F1c2UKeW91IG5lZWQgYSBjb3VwbGUgb2YgYml0
cyBpbiB0aGUgUFRFIHdpdGggd2hpY2ggdG8gc2F5IHdoaWNoIGtleSBoYXMKZW5jcnlwdGVkIHRo
YXQgcGFnZS4gU28gaXQgaXMgYW4gaW5kZWxpYmxlIHBhcnQgb2YgdGhlIFNNRSBtYWNoaW5lcnku
CgpCdHcsIHNlY3Rpb24gIjcuMTAgU2VjdXJlIE1lbW9yeSBFbmNyeXB0aW9uIiBoYXMgYW4gaW5p
dGlhbCB3cml0ZXVwOgoKaHR0cDovL3N1cHBvcnQuYW1kLmNvbS9UZWNoRG9jcy8yNDU5My5wZGYK
Ck5vdyB0aGF0IEkgc2tpbSBvdmVyIGl0LCBpdCBkb2Vzbid0IG1lbnRpb24gdGhlIEJJT1MgdGhp
bmcgYnV0IHRoYXQnbGwKYmUgdXBkYXRlZC4KCkhUSC4KCi0tIApSZWdhcmRzL0dydXNzLAogICAg
Qm9yaXMuCgpTVVNFIExpbnV4IEdtYkgsIEdGOiBGZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21p
dGhhcmQsIEdyYWhhbSBOb3J0b24sIEhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQotLSAKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZGV2ZWwgbWFpbGluZyBs
aXN0CmRldmVsQGxpbnV4ZHJpdmVycHJvamVjdC5vcmcKaHR0cDovL2RyaXZlcmRldi5saW51eGRy
aXZlcnByb2plY3Qub3JnL21haWxtYW4vbGlzdGluZm8vZHJpdmVyZGV2LWRldmVsCg==
