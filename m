From: Joe Perches <joe@perches.com>
Subject: Bad MAINTAINERS pattern in section 'IBM Power in-Nest Crypto Acceleration'
Date: Fri, 28 Sep 2018 14:53:15 -0700
Message-ID: <20180928215315.29365-1-joe@perches.com>
Cc: "Leonidas S . Barbosa" <leosilva@linux.vnet.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Please fix this defect appropriately.

linux-next MAINTAINERS section:

	6894	IBM Power in-Nest Crypto Acceleration
	6895	M:	Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
	6896	M:	Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
	6897	L:	linux-crypto@vger.kernel.org
	6898	S:	Supported
	6899	F:	drivers/crypto/nx/Makefile
	6900	F:	drivers/crypto/nx/Kconfig
	6901	F:	drivers/crypto/nx/nx-aes*
	6902	F:	drivers/crypto/nx/nx-sha*
	6903	F:	drivers/crypto/nx/nx.*
	6904	F:	drivers/crypto/nx/nx_csbcpb.h
-->	6905	F:	drivers/crypto/nx/nx_debugfs.h

Commit that introduced this:

commit 28bceeaaf81140d69647acd0eb7dc9312f27844a
 Author: Dan Streetman <ddstreet@ieee.org>
 Date:   Thu Jun 18 12:28:32 2015 -0400
 
     MAINTAINERS: clarify drivers/crypto/nx/ file ownership
     
     Update the "IBM Power in-Nest Crypto Acceleration" and
     "IBM Power 842 compression accelerator" sections to specify the correct
     files.
     
     The "IBM Power in-Nest Crypto Acceleration" was originally the only
     NX driver, and so its section listed all drivers/crypto/nx/ files,
     but now there is also the 842 driver which has its own section.  This
     lists explicitly what files are owned by the Crypto driver and which
     files are owned by the 842 compression driver.
     
     Signed-off-by: Dan Streetman <ddstreet@ieee.org>
     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
 
  MAINTAINERS | 10 +++++++++-
  1 file changed, 9 insertions(+), 1 deletion(-)

No commit with drivers/crypto/nx/nx_debugfs.h found
