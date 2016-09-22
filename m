From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v1 09/28] x86/efi: Access EFI data as encrypted when
 SEV is active
Date: Thu, 22 Sep 2016 20:23:36 +0200
Message-ID: <45a56110-95e9-e1f3-83ab-e777b48bf79a@redhat.com>
References: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
 <147190832511.9523.10850626471583956499.stgit@brijesh-build-machine>
 <20160922143545.3kl7khff6vqk7b2t@pd.tnic>
 <443d06f5-2db5-5107-296f-94fabd209407@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com,
 matt@codeblueprint.co.uk, linus.walleij@linaro.org,
 paul.gortmaker@windriver.com, hpa@zytor.com, tglx@linutronix.de,
 aarcange@redhat.com, sfr@canb.auug.org.au, mchehab@kernel.org,
 simon.guinot@sequanux.org, bhe@redhat.com, xemul@parallels.com,
 joro@8bytes.org, x86@kernel.org, mingo@redhat.com, msalter@redhat.com,
 ross.zwisler@linux.intel.com, labbott@fedoraproject.org, dyoung@redhat.com,
 jroedel@suse.de, keescook@chromium.org, toshi.kani@hpe.com,
 mathieu.desnoyers@efficios.com, dan.j.williams@intel.com,
 andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org,
 herbert@gondor.apana.org.au, tony.luck@intel.com, linux-mm@kvack.org,
 kuleshovmail@gmail.com, linux-kernel@vger.kernel.org, mcgrof@kernel.org,
 linux-crypto@vger.kernel.org, devel@linuxdriverproject.org,
 iamjoonsoo.kim@lge.com, alexandre.bounine
To: Tom Lendacky <thomas.lendacky@amd.com>, Borislav Petkov <bp@suse.de>,
 Brijesh Singh <brijesh.singh@amd.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <443d06f5-2db5-5107-296f-94fabd209407@amd.com>
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



On 22/09/2016 19:46, Tom Lendacky wrote:
>> > Do you mean, it is encrypted here because we're in the guest kernel?
> Yes, the idea is that the SEV guest will be running encrypted from the
> start, including the BIOS/UEFI, and so all of the EFI related data will
> be encrypted.

Unless this is part of some spec, it's easier if things are the same in
SME and SEV.

Paolo
