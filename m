From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Subject: [PATCH 00/10] Series of fixes for NX driver
Date: Fri, 23 Aug 2013 17:01:04 -0300
Message-ID: <1377288074-18998-1-git-send-email-mhcerri@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

This series of patches contains fixes in several algorithms implemented
by the NX driver. The patches can be separated in three different
categories:

 - Changes to split the data in several hyper calls to respect the
   limits of data that the co-processador can handle. This affects
   all AES modes.
 - Fixes in how the driver handle zero length messages. This affects
   XCBC and GCM.
 - Fixes for SHA-2 when chunks bigger than the block size are provided.

Fionnuala Gunter (2):
  crypto: nx - fix limits to sg lists for AES-XCBC
  crypto: nx - fix limits to sg lists for AES-CCM

Marcelo Cerri (8):
  crypto: nx - add offset to nx_build_sg_lists()
  crypto: nx - fix limits to sg lists for AES-ECB
  crypto: nx - fix limits to sg lists for AES-CBC
  crypto: nx - fix limits to sg lists for AES-CTR
  crypto: nx - fix limits to sg lists for AES-GCM
  crypto: nx - fix XCBC for zero length messages
  crypto: nx - fix GCM for zero length messages
  crypto: nx - fix SHA-2 for chunks bigger than block size

 drivers/crypto/nx/nx-aes-cbc.c  |  50 ++++---
 drivers/crypto/nx/nx-aes-ccm.c  | 297 +++++++++++++++++++++++++++++-----------
 drivers/crypto/nx/nx-aes-ctr.c  |  50 ++++---
 drivers/crypto/nx/nx-aes-ecb.c  |  48 ++++---
 drivers/crypto/nx/nx-aes-gcm.c  | 292 ++++++++++++++++++++++++++++++---------
 drivers/crypto/nx/nx-aes-xcbc.c | 191 +++++++++++++++++++-------
 drivers/crypto/nx/nx-sha256.c   |   2 +-
 drivers/crypto/nx/nx-sha512.c   |   2 +-
 drivers/crypto/nx/nx.c          |   9 +-
 drivers/crypto/nx/nx.h          |   2 +-
 10 files changed, 683 insertions(+), 260 deletions(-)

-- 
1.7.12
