From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC PATCH v2 19/32] crypto: ccp: Introduce the AMD Secure
 Processor device
Date: Thu, 2 Mar 2017 13:11:04 -0600
Message-ID: <0db0055f-9208-524f-74aa-674894ee90d3@amd.com>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
 <148846777589.2349.11698765767451886038.stgit@brijesh-build-machine>
 <20170302173936.GC11970@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-efi@vger.kernel.org, brijesh.singh@amd.com, labbott@fedoraproject.org,
 kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk,
 linux-pci@vger.kernel.org, linus.walleij@linaro.org, gary.hook@amd.com,
 linux-mm@kvack.org, hpa@zytor.com, cl@linux.com, tglx@linutronix.de,
 aarcange@redhat.com, sfr@canb.auug.org.au, mchehab@kernel.org,
 simon.guinot@sequanux.org, bhe@redhat.com, xemul@parallels.com,
 joro@8bytes.org, x86@kernel.org, peterz@infradead.org, piotr.luc@intel.com,
 mingo@redhat.com, msalter@redhat.com, ross.zwisler@linux.intel.com, bp@suse.de,
 dyoung@redhat.com, thomas.lendacky@amd.com, jroedel@suse.de,
 keescook@chromium.org, arnd@arndb.de, toshi.kani@hpe.com,
 mathieu.desnoyers@efficios.com, luto@kernel.org, pbonzini@redhat.com,
 bhelgaas@google.com, dan.j.williams@intel.com,
 andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org,
 herbert@gondor.ap
To: Mark Rutland <mark.rutland@arm.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170302173936.GC11970@leverpostej>
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

Hi Mark,

On 03/02/2017 11:39 AM, Mark Rutland wrote:
> On Thu, Mar 02, 2017 at 10:16:15AM -0500, Brijesh Singh wrote:
>> The CCP device is part of the AMD Secure Processor. In order to expand the
>> usage of the AMD Secure Processor, create a framework that allows functional
>> components of the AMD Secure Processor to be initialized and handled
>> appropriately.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  drivers/crypto/Kconfig           |   10 +
>>  drivers/crypto/ccp/Kconfig       |   43 +++--
>>  drivers/crypto/ccp/Makefile      |    8 -
>>  drivers/crypto/ccp/ccp-dev-v3.c  |   86 +++++-----
>>  drivers/crypto/ccp/ccp-dev-v5.c  |   73 ++++-----
>>  drivers/crypto/ccp/ccp-dev.c     |  137 +++++++++-------
>>  drivers/crypto/ccp/ccp-dev.h     |   35 ----
>>  drivers/crypto/ccp/sp-dev.c      |  308 ++++++++++++++++++++++++++++++++++++
>>  drivers/crypto/ccp/sp-dev.h      |  140 ++++++++++++++++
>>  drivers/crypto/ccp/sp-pci.c      |  324 ++++++++++++++++++++++++++++++++++++++
>>  drivers/crypto/ccp/sp-platform.c |  268 +++++++++++++++++++++++++++++++
>>  include/linux/ccp.h              |    3
>>  12 files changed, 1240 insertions(+), 195 deletions(-)
>>  create mode 100644 drivers/crypto/ccp/sp-dev.c
>>  create mode 100644 drivers/crypto/ccp/sp-dev.h
>>  create mode 100644 drivers/crypto/ccp/sp-pci.c
>>  create mode 100644 drivers/crypto/ccp/sp-platform.c
>
>> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
>> index 346ceb8..8127e18 100644
>> --- a/drivers/crypto/ccp/Makefile
>> +++ b/drivers/crypto/ccp/Makefile
>> @@ -1,11 +1,11 @@
>> -obj-$(CONFIG_CRYPTO_DEV_CCP_DD) += ccp.o
>> -ccp-objs := ccp-dev.o \
>> +obj-$(CONFIG_CRYPTO_DEV_SP_DD) += ccp.o
>> +ccp-objs := sp-dev.o sp-platform.o
>> +ccp-$(CONFIG_PCI) += sp-pci.o
>> +ccp-$(CONFIG_CRYPTO_DEV_CCP) += ccp-dev.o \
>>  	    ccp-ops.o \
>>  	    ccp-dev-v3.o \
>>  	    ccp-dev-v5.o \
>> -	    ccp-platform.o \
>>  	    ccp-dmaengine.o
>
> It looks like ccp-platform.c has morphed into sp-platform.c (judging by
> the compatible string and general shape of the code), and the original
> ccp-platform.c is no longer built.
>
> Shouldn't ccp-platform.c be deleted by this patch?
>

Good catch. Both ccp-platform.c and ccp-pci.c should have been deleted 
by this patch. I missed deleting it, will fix in next rev.

~ Brijesh
