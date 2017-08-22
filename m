From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 01/11] crypto: gcm - add GCM IV size constant
Date: Tue, 22 Aug 2017 10:08:08 +0200
Message-ID: <20170822080818.12486-2-clabbe.montjoie@gmail.com>
References: <20170822080818.12486-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, horia.geanta@nxp.com, dan.douglass@nxp.com,
        thomas.lendacky@amd.com, gary.hook@amd.com, harsh@chelsio.com,
        matthias.bgg@gmail.com, leosilva@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com, benh@kernel.crashing.org,
        paulus@samba.org, mpe@ellerman.id.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170822080818.12486-1-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Many GCM users use directly GCM IV size instead of using some constant.

This patch add all IV size constant used by GCM.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 include/crypto/gcm.h | 8 ++++++++
 1 file changed, 8 insertions(+)
 create mode 100644 include/crypto/gcm.h

diff --git a/include/crypto/gcm.h b/include/crypto/gcm.h
new file mode 100644
index 000000000000..c50e057ea17e
--- /dev/null
+++ b/include/crypto/gcm.h
@@ -0,0 +1,8 @@
+#ifndef _CRYPTO_GCM_H
+#define _CRYPTO_GCM_H
+
+#define GCM_AES_IV_SIZE 12
+#define GCM_RFC4106_IV_SIZE 8
+#define GCM_RFC4543_IV_SIZE 8
+
+#endif
-- 
2.13.0
