From: Omer Khaliq <okhaliq@caviumnetworks.com>
Subject: [PATCH v2 0/2] HWRNG/PCI: Add driver for Cavium Thunder RNG
Date: Tue, 23 Aug 2016 16:27:13 -0700
Message-ID: <1471994835-2423-1-git-send-email-okhaliq@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Omer Khaliq <okhaliq@caviumnetworks.com>
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
 <linux-crypto@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <bhelgaas@google.com>, <mpm@selenic.com>, <herbert@gondor.apana.org.au>,
 <Ananth.Jasty@cavium.com>, <David.Daney@cavium.com>,
 <clabbe.montjoie@gmail.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

There is a hardware error rendering the FDL field incorrect for the some
Thunder RNG devices. The first patch adds a PCI quirk to fix the problem.

The second patch adds the driver.

Changes from v1:
	Use PCI quirks as advised.
	Removed unecessary headers
	Format changes as advised

Ananth Jasty (1):
  PCI: quirk fixup for cavium invalid sriov link value.

Omer Khaliq (1):
  HWRNG: thunderx: Add Cavium HWRNG driver for ThunderX SoC.

 drivers/char/hw_random/Kconfig         | 13 +++++
 drivers/char/hw_random/Makefile        |  1 +
 drivers/char/hw_random/cavium-rng-vf.c | 99 ++++++++++++++++++++++++++++++++++
 drivers/char/hw_random/cavium-rng.c    | 94 ++++++++++++++++++++++++++++++++
 drivers/pci/quirks.c                   | 11 ++++
 5 files changed, 218 insertions(+)
 create mode 100644 drivers/char/hw_random/cavium-rng-vf.c
 create mode 100644 drivers/char/hw_random/cavium-rng.c

-- 
1.9.1
