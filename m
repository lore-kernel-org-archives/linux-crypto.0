From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH 1/2] PCI/IOV: Add function to allow Function Dependency
 Link override.
Date: Mon, 22 Aug 2016 11:14:54 -0500
Message-ID: <20160822161454.GA23221@localhost>
References: <1471645933-3643-1-git-send-email-okhaliq@caviumnetworks.com>
 <1471645933-3643-2-git-send-email-okhaliq@caviumnetworks.com>
 <20160822143637.GA18628@localhost>
 <57BB10E5.1050506@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Omer Khaliq <okhaliq@caviumnetworks.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@vger.kernel.org,
        bhelgaas@google.com, mpm@selenic.com, herbert@gondor.apana.org.au,
        Ananth.Jasty@cavium.com, david.daney@cavium.com
To: David Daney <ddaney@caviumnetworks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57BB10E5.1050506@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 22, 2016 at 07:49:09AM -0700, David Daney wrote:
> On 08/22/2016 07:36 AM, Bjorn Helgaas wrote:
> >Hi David & Omer,
> >
> >On Fri, Aug 19, 2016 at 03:32:12PM -0700, Omer Khaliq wrote:
> >>From: David Daney <david.daney@cavium.com>
> >>
> >>Some hardware presents an incorrect SR-IOV Function Dependency Link,
> >>add a function to allow this to be overridden in the PF driver for
> >>such devices.
> >>
> >>Signed-off-by: David Daney <david.daney@cavium.com>
> >>Signed-off-by: Omer Khaliq <okhaliq@caviumnetworks.com>
> >>---
> >>  drivers/pci/iov.c   | 14 ++++++++++++++
> >>  include/linux/pci.h |  1 +
> >>  2 files changed, 15 insertions(+)
> >>
> >>diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> >>index 2194b44..81f0672 100644
> >>--- a/drivers/pci/iov.c
> >>+++ b/drivers/pci/iov.c
> >>@@ -640,6 +640,20 @@ int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn)
> >>  EXPORT_SYMBOL_GPL(pci_enable_sriov);
> >>
> >>  /**
> >>+ * pci_sriov_fdl_override - fix incorrect Function Dependency Link
> >>+ * @dev: the PCI device
> >>+ * @fdl: the corrected Function Dependency Link value
> >>+ *
> >>+ * For hardware presenting an incorrect Function Dependency Link in
> >>+ * the SR-IOV Extended Capability, allow a driver to override it.
> >>+ */
> >>+void pci_sriov_fdl_override(struct pci_dev *dev, u8 fdl)
> >>+{
> >>+	dev->sriov->link = fdl;
> >>+}
> >>+EXPORT_SYMBOL_GPL(pci_sriov_fdl_override);
> >
> >We usually use quirks to work around problems in config space.  That's
> >a nice mechanism because we don't have to add new PCI core interfaces
> >and it makes it clear that we're working around a hardware problem.
> >
> >Can you use a quirk here?  We allocate dev->sriov in the
> >pci_init_capabilities() path, so it looks like a pci_fixup_final quirk
> >should work.
> >
> 
> The struct pci_sriov definition is private to drivers/pci, so in
> order to use a quirk to fix this, we would have to put it in
> drivers/pci/quirks.c.  I was trying to keep this very device
> specific code in the driver, which requires an accessor to be able
> to manipulate the dev->sriov->link field.
> 
> If you prefer a quirk in drivers/pci/quirks.c, we can certainly do
> that instead.

Oh, I didn't notice that pci_sriov was declared in drivers/pci/pci.h
instead of linux/pci.h.  I do think I would prefer a quirk, and I
think it's fine to put it in drivers/pci/quirks.c.

Bjorn
