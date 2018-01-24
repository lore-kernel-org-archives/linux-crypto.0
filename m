From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH 1/3] UAPI: Introduce 128-bit types and byteswap operations
Date: Wed, 24 Jan 2018 12:05:17 +0300
Message-ID: <20180124090519.6680-2-ynorov@caviumnetworks.com>
References: <20180124090519.6680-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Yury Norov <ynorov@caviumnetworks.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Pinski <Andrew.Pinski@cavium.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Geethasowjanya Akula <Geethasowjanya.Akula@cavium.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Laura Abbott <labbott@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Sunil Goutham <Sunil.Goutham@cavium.com>,
        Will Deacon <will.deacon@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0056.outbound.protection.outlook.com ([104.47.33.56]:6706
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932356AbeAXJFw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Jan 2018 04:05:52 -0500
In-Reply-To: <20180124090519.6680-1-ynorov@caviumnetworks.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Architectures like arm64 support 128-bit integer types and
operations. This patch introduces corresponding types and
__swab128() operation for be/le conversions.

They are required to implement 128-bit access to the memory,
in following patches.

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
---
 include/linux/byteorder/generic.h            |  8 ++++++++
 include/uapi/asm-generic/int-ll64.h          |  8 ++++++++
 include/uapi/linux/byteorder/big_endian.h    |  4 ++++
 include/uapi/linux/byteorder/little_endian.h |  8 ++++++++
 include/uapi/linux/swab.h                    | 22 ++++++++++++++++++++++
 include/uapi/linux/types.h                   |  4 ++++
 6 files changed, 54 insertions(+)

diff --git a/include/linux/byteorder/generic.h b/include/linux/byteorder/generic.h
index 451aaa0786ae..aa61662ee3dc 100644
--- a/include/linux/byteorder/generic.h
+++ b/include/linux/byteorder/generic.h
@@ -85,12 +85,20 @@
 
 #define cpu_to_le64 __cpu_to_le64
 #define le64_to_cpu __le64_to_cpu
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+#define cpu_to_le128 __cpu_to_le128
+#define le128_to_cpu __le128_to_cpu
+#endif
 #define cpu_to_le32 __cpu_to_le32
 #define le32_to_cpu __le32_to_cpu
 #define cpu_to_le16 __cpu_to_le16
 #define le16_to_cpu __le16_to_cpu
 #define cpu_to_be64 __cpu_to_be64
 #define be64_to_cpu __be64_to_cpu
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+#define cpu_to_be128 __cpu_to_be128
+#define be128_to_cpu __be128_to_cpu
+#endif
 #define cpu_to_be32 __cpu_to_be32
 #define be32_to_cpu __be32_to_cpu
 #define cpu_to_be16 __cpu_to_be16
diff --git a/include/uapi/asm-generic/int-ll64.h b/include/uapi/asm-generic/int-ll64.h
index 1ed06964257c..4bc2241988a9 100644
--- a/include/uapi/asm-generic/int-ll64.h
+++ b/include/uapi/asm-generic/int-ll64.h
@@ -29,9 +29,17 @@ typedef unsigned int __u32;
 #ifdef __GNUC__
 __extension__ typedef __signed__ long long __s64;
 __extension__ typedef unsigned long long __u64;
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+__extension__ typedef __int128_t __s128;
+__extension__ typedef __uint128_t __u128;
+#endif
 #else
 typedef __signed__ long long __s64;
 typedef unsigned long long __u64;
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+typedef __int128_t __s128;
+typedef __uint128_t __u128;
+#endif
 #endif
 
 #endif /* __ASSEMBLY__ */
diff --git a/include/uapi/linux/byteorder/big_endian.h b/include/uapi/linux/byteorder/big_endian.h
index 2199adc6a6c2..28a69ec10dd2 100644
--- a/include/uapi/linux/byteorder/big_endian.h
+++ b/include/uapi/linux/byteorder/big_endian.h
@@ -30,6 +30,10 @@
 #define __constant_be16_to_cpu(x) ((__force __u16)(__be16)(x))
 #define __cpu_to_le64(x) ((__force __le64)__swab64((x)))
 #define __le64_to_cpu(x) __swab64((__force __u64)(__le64)(x))
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+#define __cpu_to_le128(x) ((__force __le128)__swab128((x)))
+#define __le128_to_cpu(x) __swab128((__force __u128)(__le128)(x))
+#endif
 #define __cpu_to_le32(x) ((__force __le32)__swab32((x)))
 #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
 #define __cpu_to_le16(x) ((__force __le16)__swab16((x)))
diff --git a/include/uapi/linux/byteorder/little_endian.h b/include/uapi/linux/byteorder/little_endian.h
index 601c904fd5cd..15365bd0fe29 100644
--- a/include/uapi/linux/byteorder/little_endian.h
+++ b/include/uapi/linux/byteorder/little_endian.h
@@ -18,6 +18,10 @@
 #define __constant_ntohs(x) ___constant_swab16((__force __be16)(x))
 #define __constant_cpu_to_le64(x) ((__force __le64)(__u64)(x))
 #define __constant_le64_to_cpu(x) ((__force __u64)(__le64)(x))
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+#define __constant_cpu_to_le128(x) ((__force __le128)(__u128)(x))
+#define __constant_le128_to_cpu(x) ((__force __u128)(__le128)(x))
+#endif
 #define __constant_cpu_to_le32(x) ((__force __le32)(__u32)(x))
 #define __constant_le32_to_cpu(x) ((__force __u32)(__le32)(x))
 #define __constant_cpu_to_le16(x) ((__force __le16)(__u16)(x))
@@ -30,6 +34,10 @@
 #define __constant_be16_to_cpu(x) ___constant_swab16((__force __u16)(__be16)(x))
 #define __cpu_to_le64(x) ((__force __le64)(__u64)(x))
 #define __le64_to_cpu(x) ((__force __u64)(__le64)(x))
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+#define __cpu_to_le128(x) ((__force __le128)(__u128)(x))
+#define __le128_to_cpu(x) ((__force __u128)(__le128)(x))
+#endif
 #define __cpu_to_le32(x) ((__force __le32)(__u32)(x))
 #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
 #define __cpu_to_le16(x) ((__force __le16)(__u16)(x))
diff --git a/include/uapi/linux/swab.h b/include/uapi/linux/swab.h
index 23cd84868cc3..a7e97eb06a3e 100644
--- a/include/uapi/linux/swab.h
+++ b/include/uapi/linux/swab.h
@@ -75,6 +75,20 @@ static inline __attribute_const__ __u64 __fswab64(__u64 val)
 #endif
 }
 
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+static inline __attribute_const__ __u128 __fswab128(__u128 val)
+{
+#if defined(__arch_swab128)
+	return __arch_swab128(val);
+#else
+	__u64 h = (__u64) (val >> 64);
+	__u64 l = (__u64) val;
+
+	return (((__u128)__fswab64(l)) << 64) | (__u128)(__fswab64(h));
+#endif
+}
+#endif
+
 static inline __attribute_const__ __u32 __fswahw32(__u32 val)
 {
 #ifdef __arch_swahw32
@@ -132,6 +146,14 @@ static inline __attribute_const__ __u32 __fswahb32(__u32 val)
 	__fswab64(x))
 #endif
 
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+/**
+ * __swab128 - return a byteswapped 128-bit value
+ * @x: value to byteswap
+ */
+#define __swab128(x)	__fswab128(x)
+#endif
+
 /**
  * __swahw32 - return a word-swapped 32-bit value
  * @x: value to wordswap
diff --git a/include/uapi/linux/types.h b/include/uapi/linux/types.h
index cd4f0b897a48..a4500baaccd6 100644
--- a/include/uapi/linux/types.h
+++ b/include/uapi/linux/types.h
@@ -32,6 +32,10 @@ typedef __u32 __bitwise __le32;
 typedef __u32 __bitwise __be32;
 typedef __u64 __bitwise __le64;
 typedef __u64 __bitwise __be64;
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+typedef __u128 __bitwise __le128;
+typedef __u128 __bitwise __be128;
+#endif
 
 typedef __u16 __bitwise __sum16;
 typedef __u32 __bitwise __wsum;
-- 
2.11.0
