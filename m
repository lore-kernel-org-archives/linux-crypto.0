From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 0/5] fs/seq_file: introduce seq_hex_dump() helper
Date: Wed,  9 Jul 2014 18:24:25 +0300
Message-ID: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Helge Deller <deller@gmx.de>,
	Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
	linux390@de.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	linux-media@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This introduces a new helper and switches current users to use it.

parisc and s390 weren't tested anyhow, the other are compile tested.

Andy Shevchenko (5):
  seq_file: provide an analogue of print_hex_dump()
  saa7164: convert to seq_hex_dump()
  crypto: qat - use seq_hex_dump() to dump buffers
  parisc: use seq_hex_dump() to dump buffers
  [S390] zcrypt: use seq_hex_dump() to dump buffers

 .../crypto/qat/qat_common/adf_transport_debug.c    | 16 ++--------
 drivers/media/pci/saa7164/saa7164-core.c           | 31 +++----------------
 drivers/parisc/ccio-dma.c                          | 14 ++-------
 drivers/parisc/sba_iommu.c                         | 11 ++-----
 drivers/s390/crypto/zcrypt_api.c                   | 10 +------
 fs/seq_file.c                                      | 35 ++++++++++++++++++++++
 include/linux/seq_file.h                           |  4 +++
 7 files changed, 52 insertions(+), 69 deletions(-)

-- 
2.0.1
