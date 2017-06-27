From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH v2 1/3] io-64-nonatomic: add io{read|write}64[be] macros
Date: Tue, 27 Jun 2017 17:02:02 -0600
Message-ID: <20170627230204.16410-2-logang@deltatee.com>
References: <20170627230204.16410-1-logang@deltatee.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jyri Sarha <jsarha@ti.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170627230204.16410-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds io{read|write}64[be] macros to point to the readq/writeq
in use.

This is because new drivers are encouraged to use ioreadXX, et al instead
of readX[1], et al -- and mixing ioreadXX with readq is pretty ugly.

[1] ldd3: section 9.4.2

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
cc: Christoph Hellwig <hch@lst.de>
cc: Arnd Bergmann <arnd@arndb.de>
cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io-64-nonatomic-hi-lo.h | 16 ++++++++++++++++
 include/linux/io-64-nonatomic-lo-hi.h | 16 ++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/io-64-nonatomic-hi-lo.h b/include/linux/io-64-nonatomic-hi-lo.h
index defcc4644ce3..07a75831244f 100644
--- a/include/linux/io-64-nonatomic-hi-lo.h
+++ b/include/linux/io-64-nonatomic-hi-lo.h
@@ -54,4 +54,20 @@ static inline void hi_lo_writeq_relaxed(__u64 val, volatile void __iomem *addr)
 #define writeq_relaxed hi_lo_writeq_relaxed
 #endif
 
+#ifndef ioread64
+#define ioread64 readq
+#endif
+
+#ifndef iowrite64
+#define iowrite64 writeq
+#endif
+
+#ifndef ioread64be
+#define ioread64be(p) be64_to_cpu(ioread64(p))
+#endif
+
+#ifndef iowrite64be
+#define iowrite64be(v, p) iowrite64(cpu_to_be64(v), (p))
+#endif
+
 #endif	/* _LINUX_IO_64_NONATOMIC_HI_LO_H_ */
diff --git a/include/linux/io-64-nonatomic-lo-hi.h b/include/linux/io-64-nonatomic-lo-hi.h
index 084461a4e5ab..3d0565e67175 100644
--- a/include/linux/io-64-nonatomic-lo-hi.h
+++ b/include/linux/io-64-nonatomic-lo-hi.h
@@ -54,4 +54,20 @@ static inline void lo_hi_writeq_relaxed(__u64 val, volatile void __iomem *addr)
 #define writeq_relaxed lo_hi_writeq_relaxed
 #endif
 
+#ifndef ioread64
+#define ioread64 readq
+#endif
+
+#ifndef iowrite64
+#define iowrite64 writeq
+#endif
+
+#ifndef ioread64be
+#define ioread64be(p) be64_to_cpu(ioread64(p))
+#endif
+
+#ifndef iowrite64be
+#define iowrite64be(v, p) iowrite64(cpu_to_be64(v), (p))
+#endif
+
 #endif	/* _LINUX_IO_64_NONATOMIC_LO_HI_H_ */
-- 
2.11.0
