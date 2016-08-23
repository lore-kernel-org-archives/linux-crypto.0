From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH v1 18/28] crypto: add AMD Platform Security Processor
 driver
Date: Tue, 23 Aug 2016 15:14:58 +0800
Message-ID: <20160823071458.GC392@gondor.apana.org.au>
References: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
 <147190844204.9523.14931918358168729826.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: simon.guinot@sequanux.org, linux-efi@vger.kernel.org,
	kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk,
	linus.walleij@linaro.org, linux-mm@kvack.org,
	paul.gortmaker@windriver.com, hpa@zytor.com,
	dan.j.williams@intel.com, aarcange@redhat.com, sfr@canb.auug.org.au,
	andriy.shevchenko@linux.intel.com, bhe@redhat.com,
	xemul@parallels.com, joro@8bytes.org, x86@kernel.org,
	mingo@redhat.com, msalter@redhat.com, ross.zwisler@linux.intel.com,
	bp@suse.de, dyoung@redhat.com, thomas.lendacky@amd.com,
	jroedel@suse.de, keescook@chromium.org, toshi.kani@hpe.com,
	mathieu.desnoyers@efficios.com, devel@linuxdriverproject.org,
	tglx@linutronix.de, mchehab@kernel.org, iamjoonsoo.kim@lge.com,
	labbott@fedoraproject.org, tony.luck@intel.com,
	alexandre.bounine@idt.com, kuleshovmail@gmail.com,
	linux-kernel@vger.kernel.org, mcgrof@kernel.org,
	linux-crypto@vger.kernel.org, pbonzin
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <147190844204.9523.14931918358168729826.stgit@brijesh-build-machine>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 22, 2016 at 07:27:22PM -0400, Brijesh Singh wrote:
> The driver to communicate with Secure Encrypted Virtualization (SEV)
> firmware running within the AMD secure processor providing a secure key
> management interface for SEV guests.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>

This driver doesn't seem to hook into the Crypto API at all, is
there any reason why it should be in drivers/crypto?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
