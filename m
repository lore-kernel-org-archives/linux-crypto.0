From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [RFC PATCH v2 19/32] crypto: ccp: Introduce the AMD Secure
 Processor device
Date: Fri, 03 Mar 2017 15:55:18 +0200
Message-ID: <1488549318.20145.76.camel@linux.intel.com>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
	 <148846777589.2349.11698765767451886038.stgit@brijesh-build-machine>
	 <20170302173936.GC11970@leverpostej>
	 <0db0055f-9208-524f-74aa-674894ee90d3@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: simon.guinot@sequanux.org, linux-efi@vger.kernel.org,
 kvm@vger.kernel.org,  rkrcmar@redhat.com, matt@codeblueprint.co.uk,
 linux-pci@vger.kernel.org,  linus.walleij@linaro.org, gary.hook@amd.com,
 linux-mm@kvack.org,  paul.gortmaker@windriver.com, hpa@zytor.com,
 cl@linux.com,  dan.j.williams@intel.com, aarcange@redhat.com,
 sfr@canb.auug.org.au,  herbert@gondor.apana.org.au, bhe@redhat.com,
 xemul@parallels.com, joro@8bytes.org,  x86@kernel.org,
 peterz@infradead.org, piotr.luc@intel.com, mingo@redhat.com,
 msalter@redhat.com, ross.zwisler@linux.intel.com, bp@suse.de,
 dyoung@redhat.com,  thomas.lendacky@amd.com, jroedel@suse.de,
 keescook@chromium.org, arnd@arndb.de,  toshi.kani@hpe.com,
 mathieu.desnoyers@efficios.com, luto@kernel.org,
 devel@linuxdriverproject.org, bhelgaas@google.com, tglx@linutronix.de,
 mchehab@kernel.org, iamjoonsoo.kim@lge.com, labbott@fedoraproject.org,
To: Brijesh Singh <brijesh.singh@amd.com>, Mark Rutland
 <mark.rutland@arm.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <0db0055f-9208-524f-74aa-674894ee90d3@amd.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 2017-03-02 at 13:11 -0600, Brijesh Singh wrote:
> Hi Mark,
> 
> On 03/02/2017 11:39 AM, Mark Rutland wrote:
> > On Thu, Mar 02, 2017 at 10:16:15AM -0500, Brijesh Singh wrote:

> > > 
> > > +ccp-$(CONFIG_CRYPTO_DEV_CCP) += ccp-dev.o \
> > >  	    ccp-ops.o \
> > >  	    ccp-dev-v3.o \
> > >  	    ccp-dev-v5.o \
> > > -	    ccp-platform.o \
> > >  	    ccp-dmaengine.o
> > 
> > It looks like ccp-platform.c has morphed into sp-platform.c (judging
> > by
> > the compatible string and general shape of the code), and the
> > original
> > ccp-platform.c is no longer built.
> > 
> > Shouldn't ccp-platform.c be deleted by this patch?
> > 
> 
> Good catch. Both ccp-platform.c and ccp-pci.c should have been
> deleted 
> by this patch. I missed deleting it, will fix in next rev.

Don't forget to use -M -C when preparing / sending patches.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
