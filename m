From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH v4 3/5] io-64-nonatomic: add io{read|write}64[be]{_lo_hi|_hi_lo} macros
Date: Tue, 18 Jul 2017 10:55:26 -0600
Message-ID: <20170718165528.7383-4-logang@deltatee.com>
References: <20170718165528.7383-1-logang@deltatee.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20170718165528.7383-1-logang@deltatee.com>
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds generic io{read|write}64[be]{_lo_hi|_hi_lo} macros if
they are not already defined by the architecture. (As they are provided
by the generic iomap library).

The patch also points io{read|write}64[be] to the variant specified by the
header name.

This is because new drivers are encouraged to use ioreadXX, et al instead
of readX[1], et al -- and mixing ioreadXX with readq is pretty ugly.

[1] ldd3: section 9.4.2

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
cc: Christoph Hellwig <hch@lst.de>
cc: Arnd Bergmann <arnd@arndb.de>
cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io-64-nonatomic-hi-lo.h | 60 +++++++++++++++++++++++++++++++++++
 include/linux/io-64-nonatomic-lo-hi.h | 60 +++++++++++++++++++++++++++++++++++
 2 files changed, 120 insertions(+)

diff --git a/include/linux/io-64-nonatomic-hi-lo.h b/include/linux/io-64-nonatomic-hi-lo.h
index defcc4644ce3..31d28e981299 100644
--- a/include/linux/io-64-nonatomic-hi-lo.h
+++ b/include/linux/io-64-nonatomic-hi-lo.h
@@ -54,4 +54,64 @@ static inline void hi_lo_writeq_relaxed(__u64 val, volatile void __iomem *addr)
 #define writeq_relaxed hi_lo_writeq_relaxed
 #endif
 
+#ifndef ioread64_hi_lo
+#define ioread64_hi_lo ioread64_hi_lo
+static inline u64 ioread64_hi_lo(void __iomem *addr)
+{
+	u32 low, high;
+
+	high = ioread32(addr + sizeof(u32));
+	low = ioread32(addr);
+
+	return low + ((u64)high << 32);
+}
+#endif
+
+#ifndef iowrite64_hi_lo
+#define iowrite64_hi_lo iowrite64_hi_lo
+static inline void iowrite64_hi_lo(u64 val, void __iomem *addr)
+{
+	iowrite32(val >> 32, addr + sizeof(u32));
+	iowrite32(val, addr);
+}
+#endif
+
+#ifndef ioread64be_hi_lo
+#define ioread64be_hi_lo ioread64be_hi_lo
+static inline u64 ioread64be_hi_lo(void __iomem *addr)
+{
+	u32 low, high;
+
+	high = ioread32be(addr);
+	low = ioread32be(addr + sizeof(u32));
+
+	return low + ((u64)high << 32);
+}
+#endif
+
+#ifndef iowrite64be_hi_lo
+#define iowrite64be_hi_lo iowrite64be_hi_lo
+static inline void iowrite64be_hi_lo(u64 val, void __iomem *addr)
+{
+	iowrite32be(val >> 32, addr);
+	iowrite32be(val, addr + sizeof(u32));
+}
+#endif
+
+#ifndef ioread64
+#define ioread64 ioread64_hi_lo
+#endif
+
+#ifndef iowrite64
+#define iowrite64 iowrite64_hi_lo
+#endif
+
+#ifndef ioread64be
+#define ioread64be ioread64be_hi_lo
+#endif
+
+#ifndef iowrite64be
+#define iowrite64be iowrite64be_hi_lo
+#endif
+
 #endif	/* _LINUX_IO_64_NONATOMIC_HI_LO_H_ */
diff --git a/include/linux/io-64-nonatomic-lo-hi.h b/include/linux/io-64-nonatomic-lo-hi.h
index 084461a4e5ab..437a34f20f5a 100644
--- a/include/linux/io-64-nonatomic-lo-hi.h
+++ b/include/linux/io-64-nonatomic-lo-hi.h
@@ -54,4 +54,64 @@ static inline void lo_hi_writeq_relaxed(__u64 val, volatile void __iomem *addr)
 #define writeq_relaxed lo_hi_writeq_relaxed
 #endif
 
+#ifndef ioread64_lo_hi
+#define ioread64_lo_hi ioread64_lo_hi
+static inline u64 ioread64_lo_hi(void __iomem *addr)
+{
+	u32 low, high;
+
+	low = ioread32(addr);
+	high = ioread32(addr + sizeof(u32));
+
+	return low + ((u64)high << 32);
+}
+#endif
+
+#ifndef iowrite64_lo_hi
+#define iowrite64_lo_hi iowrite64_lo_hi
+static inline void iowrite64_lo_hi(u64 val, void __iomem *addr)
+{
+	iowrite32(val, addr);
+	iowrite32(val >> 32, addr + sizeof(u32));
+}
+#endif
+
+#ifndef ioread64be_lo_hi
+#define ioread64be_lo_hi ioread64be_lo_hi
+static inline u64 ioread64be_lo_hi(void __iomem *addr)
+{
+	u32 low, high;
+
+	low = ioread32be(addr + sizeof(u32));
+	high = ioread32be(addr);
+
+	return low + ((u64)high << 32);
+}
+#endif
+
+#ifndef iowrite64be_lo_hi
+#define iowrite64be_lo_hi iowrite64be_lo_hi
+static inline void iowrite64be_lo_hi(u64 val, void __iomem *addr)
+{
+	iowrite32be(val, addr + sizeof(u32));
+	iowrite32be(val >> 32, addr);
+}
+#endif
+
+#ifndef ioread64
+#define ioread64 ioread64_lo_hi
+#endif
+
+#ifndef iowrite64
+#define iowrite64 iowrite64_lo_hi
+#endif
+
+#ifndef ioread64be
+#define ioread64be ioread64be_lo_hi
+#endif
+
+#ifndef iowrite64be
+#define iowrite64be iowrite64be_lo_hi
+#endif
+
 #endif	/* _LINUX_IO_64_NONATOMIC_LO_HI_H_ */
-- 
2.11.0
