From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH v2 05/32] x86: Use encrypted access of BOOT related
 data with SEV
Date: Thu, 16 Mar 2017 14:03:58 -0500
Message-ID: <8715da04-2d25-d1f2-3082-f45750c4f2d9@amd.com>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
 <148846757895.2349.561582698953591240.stgit@brijesh-build-machine>
 <20170307110925.zmo7gsflxhui4k7e@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <simon.guinot@sequanux.org>, <linux-efi@vger.kernel.org>,
	<kvm@vger.kernel.org>, <rkrcmar@redhat.com>, <matt@codeblueprint.co.uk>,
	<linux-pci@vger.kernel.org>, <linus.walleij@linaro.org>, <gary.hook@amd.com>,
	<linux-mm@kvack.org>, <paul.gortmaker@windriver.com>, <hpa@zytor.com>,
	<cl@linux.com>, <dan.j.williams@intel.com>, <aarcange@redhat.com>,
	<sfr@canb.auug.org.au>, <andriy.shevchenko@linux.intel.com>,
	<herbert@gondor.apana.org.au>, <bhe@redhat.com>, <xemul@parallels.com>,
	<joro@8bytes.org>, <x86@kernel.org>, <peterz@infradead.org>,
	<piotr.luc@intel.com>, <mingo@redhat.com>, <msalter@redhat.com>,
	<ross.zwisler@linux.intel.com>, <dyoung@redhat.com>, <jroedel@suse.de>,
	<keescook@chromium.org>, <arnd@arndb.de>, <toshi.kani@hpe.com>,
	<mathieu.desnoyers@efficios.com>, <luto@kernel.org>,
	<devel@linuxdriverproject.org>, <bhelgaas@google.com>, <tglx@linutronix.de>,
	<mchehab@ke
To: Borislav Petkov <bp@suse.de>, Brijesh Singh <brijesh.singh@amd.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170307110925.zmo7gsflxhui4k7e@pd.tnic>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On 3/7/2017 5:09 AM, Borislav Petkov wrote:
> On Thu, Mar 02, 2017 at 10:12:59AM -0500, Brijesh Singh wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> When Secure Encrypted Virtualization (SEV) is active, BOOT data (such as
>> EFI related data, setup data) is encrypted and needs to be accessed as
>> such when mapped. Update the architecture override in early_memremap to
>> keep the encryption attribute when mapping this data.
>
> This could also explain why persistent memory needs to be accessed
> decrypted with SEV.

I'll add some comments about why persistent memory needs to be accessed
decrypted (because the encryption key changes across reboots) for both
SME and SEV.

>
> In general, what the difference in that aspect is in respect to SME. And
> I'd write that in the comment over the function. And not say "E820 areas
> are checked in making this determination." because that is visible but
> say *why* we need to check those ranges and determine access depending
> on their type.

Will do.

Thanks,
Tom

>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
