From: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Subject: [PATCH 0/2] crypto: vmx - fix vmx failures by changing fallback to
 skcipher
Date: Wed, 22 Feb 2017 14:58:20 -0300
Message-ID: <20170222175822.24040-1-pfsmorigo@linux.vnet.ibm.com>
Cc: herbert@gondor.apana.org.au, paulus@samba.org, linux-crypto@vger.kernel.org,
 Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
 linuxppc-dev@lists.ozlabs.org, davem@davemloft.net
To: linux-kernel@vger.kernel.org
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

Currently, neither cbc or xts are working with upstream kernel due to a failure
in the fallback allocation. This can be fixed by changing the fallback to
skcipher.

Paulo Flabiano Smorigo (2):
  crypto: vmx - Use skcipher for cbc fallback
  crypto: vmx - Use skcipher for xts fallback

 drivers/crypto/vmx/aes_cbc.c | 41 ++++++++++++++++++++---------------------
 drivers/crypto/vmx/aes_xts.c | 32 ++++++++++++++++++--------------
 2 files changed, 38 insertions(+), 35 deletions(-)

-- 
2.9.3
