From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 5/5] PCI: Add quirk for Intel DH895xCC VF PCI config erratum
Date: Fri, 07 Aug 2015 11:34:42 -0700
Message-ID: <20150807183441.630.50653.stgit@tstruk-mobl1>
References: <20150807183414.630.25889.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, bhelgaas@google.com,
	linux-pci@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28135 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946070AbbHGSgB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Aug 2015 14:36:01 -0400
In-Reply-To: <20150807183414.630.25889.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The PCI capabilities list for Intel DH895xCC VFs (device id 0x0443) with
QuickAssist Technology is prematurely terminated in hardware.
Workaround the issue by hard-coding the known expected next capability
pointer and saving the PCIE cap into internal buffer.

Patch generated against cryptodev-2.6

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/pci/quirks.c |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e9fd0e9..6a80f5a 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4008,3 +4008,88 @@ void pci_dev_specific_enable_acs(struct pci_dev *dev)
 		}
 	}
 }
+
+/*
+ * The PCI capabilities list for Intel DH895xCC VFs (device id 0x0443) with
+ * QuickAssist Technology (QAT) is prematurely terminated in hardware.  The
+ * Next Capability pointer in the MSI Capability Structure should point to
+ * the PCIe Capability Structure but is incorrectly hardwired as 0 terminating
+ * the list.
+ */
+static void quirk_intel_qat_vf_cap(struct pci_dev *pdev)
+{
+	int pos, i = 0;
+	u8 next_cap;
+	u16 reg16, *cap;
+	struct pci_cap_saved_state *state;
+
+	/* Bail if the hardware bug is fixed */
+	if (pdev->pcie_cap || pci_find_capability(pdev, PCI_CAP_ID_EXP))
+		return;
+
+	/* Bail if MSI Capability Structure is not found for some reason */
+	pos = pci_find_capability(pdev, PCI_CAP_ID_MSI);
+	if (!pos)
+		return;
+
+	/*
+	 * Bail if Next Capability pointer in the MSI Capability Structure
+	 * is not the expected incorrect 0x00.
+	 */
+	pci_read_config_byte(pdev, pos + 1, &next_cap);
+	if (next_cap)
+		return;
+
+	/*
+	 * PCIe Capability Structure is expected to be at 0x50 and should
+	 * terminate the list (Next Capability pointer is 0x00).  Verify
+	 * Capability Id and Next Capability pointer is as expected.
+	 * Open-code some of set_pcie_port_type() and pci_cfg_space_size_ext()
+	 * to correctly set kernel data structures which have already been
+	 * set incorrectly due to the hardware bug.
+	 */
+	pos = 0x50;
+	pci_read_config_word(pdev, pos, &reg16);
+	if (reg16 == (0x0000 | PCI_CAP_ID_EXP)) {
+		u32 status;
+#ifndef PCI_EXP_SAVE_REGS
+#define PCI_EXP_SAVE_REGS     7
+#endif
+		int size = PCI_EXP_SAVE_REGS * sizeof(u16);
+
+		pdev->pcie_cap = pos;
+		pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
+		pdev->pcie_flags_reg = reg16;
+		pci_read_config_word(pdev, pos + PCI_EXP_DEVCAP, &reg16);
+		pdev->pcie_mpss = reg16 & PCI_EXP_DEVCAP_PAYLOAD;
+
+		pdev->cfg_size = PCI_CFG_SPACE_EXP_SIZE;
+		if (pci_read_config_dword(pdev, PCI_CFG_SPACE_SIZE, &status) !=
+		    PCIBIOS_SUCCESSFUL || (status == 0xffffffff))
+			pdev->cfg_size = PCI_CFG_SPACE_SIZE;
+
+		if (pci_find_saved_cap(pdev, PCI_CAP_ID_EXP))
+			return;
+
+		/*
+		 * Save PCIE cap
+		 */
+		state = kzalloc(sizeof(*state) + size, GFP_KERNEL);
+		if (!state)
+			return;
+
+		state->cap.cap_nr = PCI_CAP_ID_EXP;
+		state->cap.cap_extended = 0;
+		state->cap.size = size;
+		cap = (u16 *)&state->cap.data[0];
+		pcie_capability_read_word(pdev, PCI_EXP_DEVCTL, &cap[i++]);
+		pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &cap[i++]);
+		pcie_capability_read_word(pdev, PCI_EXP_SLTCTL, &cap[i++]);
+		pcie_capability_read_word(pdev, PCI_EXP_RTCTL,  &cap[i++]);
+		pcie_capability_read_word(pdev, PCI_EXP_DEVCTL2, &cap[i++]);
+		pcie_capability_read_word(pdev, PCI_EXP_LNKCTL2, &cap[i++]);
+		pcie_capability_read_word(pdev, PCI_EXP_SLTCTL2, &cap[i++]);
+		hlist_add_head(&state->next, &pdev->saved_cap_space);
+	}
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x443, quirk_intel_qat_vf_cap);
