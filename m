From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH v1 04/28] x86: Secure Encrypted Virtualization (SEV)
 support
Date: Thu, 22 Sep 2016 17:00:20 +0200
Message-ID: <20160922150020.zzfc3w642r2r6cl2@pd.tnic>
References: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
 <147190825949.9523.11406635622434950066.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com,
 matt@codeblueprint.co.uk, linus.walleij@linaro.org,
 paul.gortmaker@windriver.com, hpa@zytor.com, tglx@linutronix.de,
 aarcange@redhat.com, sfr@canb.auug.org.au, mchehab@kernel.org,
 simon.guinot@sequanux.org, bhe@redhat.com, xemul@parallels.com,
 joro@8bytes.org, x86@kernel.org, mingo@redhat.com, msalter@redhat.com,
 ross.zwisler@linux.intel.com, labbott@fedoraproject.org, dyoung@redhat.com,
 thomas.lendacky@amd.com, jroedel@suse.de, keescook@chromium.org,
 toshi.kani@hpe.com, mathieu.desnoyers@efficios.com, pbonzini@redhat.com,
 dan.j.williams@intel.com, andriy.shevchenko@linux.intel.com,
 akpm@linux-foundation.org, herbert@gondor.apana.org.au, tony.luck@intel.com,
 linux-mm@kvack.org, kuleshovmail@gmail.com, linux-kernel@vger.kernel.org,
 mcgrof@kernel.org, linux-crypto@vger.kernel.org, devel@linuxdriverproject.o
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <147190825949.9523.11406635622434950066.stgit@brijesh-build-machine>
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

T24gTW9uLCBBdWcgMjIsIDIwMTYgYXQgMDc6MjQ6MTlQTSAtMDQwMCwgQnJpamVzaCBTaW5naCB3
cm90ZToKPiBGcm9tOiBUb20gTGVuZGFja3kgPHRob21hcy5sZW5kYWNreUBhbWQuY29tPgoKU3Vi
amVjdDogW1JGQyBQQVRDSCB2MSAwNC8yOF0geDg2OiBTZWN1cmUgRW5jcnlwdGVkIFZpcnR1YWxp
emF0aW9uIChTRVYpIHN1cHBvcnQKClBsZWFzZSBzdGFydCBwYXRjaCBjb21taXQgaGVhZGluZyB3
aXRoIGEgdmVyYiwgaS5lLjoKCiJ4ODY6IEFkZCBBTUQgU2VjdXJlIEVuY3J5cHRlZCBWaXJ0dWFs
aXphdGlvbiAoU0VWKSBzdXBwb3J0IgoKLS0gClJlZ2FyZHMvR3J1c3MsCiAgICBCb3Jpcy4KClNV
U0UgTGludXggR21iSCwgR0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgSmFuZSBTbWl0aGFyZCwgR3Jh
aGFtIE5vcnRvbiwgSFJCIDIxMjg0IChBRyBOw7xybmJlcmcpCi0tIApfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpkZXZlbCBtYWlsaW5nIGxpc3QKZGV2ZWxA
bGludXhkcml2ZXJwcm9qZWN0Lm9yZwpodHRwOi8vZHJpdmVyZGV2LmxpbnV4ZHJpdmVycHJvamVj
dC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcml2ZXJkZXYtZGV2ZWwK
