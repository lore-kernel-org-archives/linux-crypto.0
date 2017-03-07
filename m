From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [RFC PATCH v2 06/32] x86/pci: Use memremap when walking setup data
Date: Mon, 6 Mar 2017 18:03:49 -0600
Message-ID: <20170307000349.GC5305@bhelgaas-glaptop.roam.corp.google.com>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
 <148846759008.2349.8274808454274279039.stgit@brijesh-build-machine>
 <20170303204209.GA31767@bhelgaas-glaptop.roam.corp.google.com>
 <df526224-0a4b-abc6-6377-efbca77284b1@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-efi@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>,
 labbott@fedoraproject.org, kvm@vger.kernel.org, rkrcmar@redhat.com,
 matt@codeblueprint.co.uk, linux-pci@vger.kernel.org, linus.walleij@linaro.org,
 gary.hook@amd.com, linux-mm@kvack.org, hpa@zytor.com, cl@linux.com,
 tglx@linutronix.de, aarcange@redhat.com, sfr@canb.auug.org.au,
 mchehab@kernel.org, simon.guinot@sequanux.org, bhe@redhat.com,
 xemul@parallels.com, joro@8bytes.org, x86@kernel.org, peterz@infradead.org,
 piotr.luc@intel.com, mingo@redhat.com, msalter@redhat.com,
 ross.zwisler@linux.intel.com, bp@suse.de, dyoung@redhat.com, jroedel@suse.de,
 keescook@chromium.org, arnd@arndb.de, toshi.kani@hpe.com,
 mathieu.desnoyers@efficios.com, luto@kernel.org, pbonzini@redhat.com,
 bhelgaas@google.com, dan.j.williams@intel.com,
 andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org,
 herbert@gondor.apana.org.a
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <df526224-0a4b-abc6-6377-efbca77284b1@amd.com>
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

On Fri, Mar 03, 2017 at 03:15:34PM -0600, Tom Lendacky wrote:
> On 3/3/2017 2:42 PM, Bjorn Helgaas wrote:
> >On Thu, Mar 02, 2017 at 10:13:10AM -0500, Brijesh Singh wrote:
> >>From: Tom Lendacky <thomas.lendacky@amd.com>
> >>
> >>The use of ioremap will force the setup data to be mapped decrypted even
> >>though setup data is encrypted.  Switch to using memremap which will be
> >>able to perform the proper mapping.
> >
> >How should callers decide whether to use ioremap() or memremap()?
> >
> >memremap() existed before SME and SEV, and this code is used even if
> >SME and SEV aren't supported, so the rationale for this change should
> >not need the decryption argument.
> 
> When SME or SEV is active an ioremap() will remove the encryption bit
> from the pagetable entry when it is mapped.  This allows MMIO, which
> doesn't support SME/SEV, to be performed successfully.  So my take is
> that ioremap() should be used for MMIO and memremap() for pages in RAM.

OK, thanks.  The commit message should say something like "this is
RAM, not MMIO, so we should map it with memremap(), not ioremap()".
That's the part that determines whether the change is correct.

You can mention the encryption part, too, but it's definitely
secondary because the change has to make sense on its own, without
SME/SEV.

The following commits (from https://github.com/codomania/tip/branches)
all do basically the same thing so the changelogs (and summaries)
should all be basically the same:

  cb0d0d1eb0a6 x86: Change early_ioremap to early_memremap for BOOT data
  91acb68b8333 x86/pci: Use memremap when walking setup data
  4f687503e23f x86: Access the setup data through sysfs decrypted
  e90246b8c229 x86: Access the setup data through debugfs decrypted

I would collect them all together and move them to the beginning of
your series, since they don't depend on anything else.

Also, change "x86/pci: " to "x86/PCI" so it matches the previous
convention.

> >>Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> >>---
> >> arch/x86/pci/common.c |    4 ++--
> >> 1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >>diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
> >>index a4fdfa7..0b06670 100644
> >>--- a/arch/x86/pci/common.c
> >>+++ b/arch/x86/pci/common.c
> >>@@ -691,7 +691,7 @@ int pcibios_add_device(struct pci_dev *dev)
> >>
> >> 	pa_data = boot_params.hdr.setup_data;
> >> 	while (pa_data) {
> >>-		data = ioremap(pa_data, sizeof(*rom));
> >>+		data = memremap(pa_data, sizeof(*rom), MEMREMAP_WB);
> >
> >I can't quite connect the dots here.  ioremap() on x86 would do
> >ioremap_nocache().  memremap(MEMREMAP_WB) would do arch_memremap_wb(),
> >which is ioremap_cache().  Is making a cacheable mapping the important
> >difference?
> 
> The memremap(MEMREMAP_WB) will actually check to see if it can perform
> a __va(pa_data) in try_ram_remap() and then fallback to the
> arch_memremap_wb().  So it's actually the __va() vs the ioremap_cache()
> that is the difference.
> 
> Thanks,
> Tom
> 
> >
> >> 		if (!data)
> >> 			return -ENOMEM;
> >>
> >>@@ -710,7 +710,7 @@ int pcibios_add_device(struct pci_dev *dev)
> >> 			}
> >> 		}
> >> 		pa_data = data->next;
> >>-		iounmap(data);
> >>+		memunmap(data);
> >> 	}
> >> 	set_dma_domain_ops(dev);
> >> 	set_dev_domain_options(dev);
> >>
