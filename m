From: Kenneth Lee <nek.in.cn@gmail.com>
Subject: [PATCH 7/7] vfio/sdmdev: add user sample
Date: Mon,  3 Sep 2018 08:52:04 +0800
Message-ID: <20180903005204.26041-8-nek.in.cn@gmail.com>
References: <20180903005204.26041-1-nek.in.cn@gmail.com>
Cc: linuxarm@huawei.com
To: Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Hao Fang <fanghao11@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-accelerators@lists.ozlabs.org,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Sanjay Kumar <sanjay.k.kumar@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180903005204.26041-1-nek.in.cn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Kenneth Lee <liguozhu@hisilicon.com>

This is the sample code to demostrate how WrapDrive user application
should be.

It contains:

1. wd.[ch], the common library to provide WrapDrive interface.
2. drv/*, the user driver to access the hardware upon spimdev
3. test/*, the test application to use WrapDrive interface to access the
   hardware queue(s) of the accelerator.

The Hisilicon HIP08 ZIP accelerator is used in this sample.

Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
Signed-off-by: Hao Fang <fanghao11@huawei.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 samples/warpdrive/AUTHORS              |   2 +
 samples/warpdrive/ChangeLog            |   1 +
 samples/warpdrive/Makefile.am          |   9 +
 samples/warpdrive/NEWS                 |   1 +
 samples/warpdrive/README               |  32 +++
 samples/warpdrive/autogen.sh           |   3 +
 samples/warpdrive/cleanup.sh           |  13 ++
 samples/warpdrive/configure.ac         |  52 +++++
 samples/warpdrive/drv/hisi_qm_udrv.c   | 223 ++++++++++++++++++
 samples/warpdrive/drv/hisi_qm_udrv.h   |  53 +++++
 samples/warpdrive/test/Makefile.am     |   7 +
 samples/warpdrive/test/comp_hw.h       |  23 ++
 samples/warpdrive/test/test_hisi_zip.c | 206 +++++++++++++++++
 samples/warpdrive/wd.c                 | 309 +++++++++++++++++++++++++
 samples/warpdrive/wd.h                 | 154 ++++++++++++
 samples/warpdrive/wd_adapter.c         |  74 ++++++
 samples/warpdrive/wd_adapter.h         |  43 ++++
 17 files changed, 1205 insertions(+)
 create mode 100644 samples/warpdrive/AUTHORS
 create mode 100644 samples/warpdrive/ChangeLog
 create mode 100644 samples/warpdrive/Makefile.am
 create mode 100644 samples/warpdrive/NEWS
 create mode 100644 samples/warpdrive/README
 create mode 100755 samples/warpdrive/autogen.sh
 create mode 100755 samples/warpdrive/cleanup.sh
 create mode 100644 samples/warpdrive/configure.ac
 create mode 100644 samples/warpdrive/drv/hisi_qm_udrv.c
 create mode 100644 samples/warpdrive/drv/hisi_qm_udrv.h
 create mode 100644 samples/warpdrive/test/Makefile.am
 create mode 100644 samples/warpdrive/test/comp_hw.h
 create mode 100644 samples/warpdrive/test/test_hisi_zip.c
 create mode 100644 samples/warpdrive/wd.c
 create mode 100644 samples/warpdrive/wd.h
 create mode 100644 samples/warpdrive/wd_adapter.c
 create mode 100644 samples/warpdrive/wd_adapter.h

diff --git a/samples/warpdrive/AUTHORS b/samples/warpdrive/AUTHORS
new file mode 100644
index 000000000000..fe7dc2413b0d
--- /dev/null
+++ b/samples/warpdrive/AUTHORS
@@ -0,0 +1,2 @@
+Kenneth Lee<liguozhu@hisilicon.com>
+Zaibo Xu<xuzaibo@huawei.com>
diff --git a/samples/warpdrive/ChangeLog b/samples/warpdrive/ChangeLog
new file mode 100644
index 000000000000..b1b716105590
--- /dev/null
+++ b/samples/warpdrive/ChangeLog
@@ -0,0 +1 @@
+init
diff --git a/samples/warpdrive/Makefile.am b/samples/warpdrive/Makefile.am
new file mode 100644
index 000000000000..41154a880a97
--- /dev/null
+++ b/samples/warpdrive/Makefile.am
@@ -0,0 +1,9 @@
+ACLOCAL_AMFLAGS = -I m4
+AUTOMAKE_OPTIONS = foreign subdir-objects
+AM_CFLAGS=-Wall -O0 -fno-strict-aliasing
+
+lib_LTLIBRARIES=libwd.la
+libwd_la_SOURCES=wd.c wd_adapter.c wd.h wd_adapter.h \
+		 drv/hisi_qm_udrv.c drv/hisi_qm_udrv.h
+
+SUBDIRS=. test
diff --git a/samples/warpdrive/NEWS b/samples/warpdrive/NEWS
new file mode 100644
index 000000000000..b1b716105590
--- /dev/null
+++ b/samples/warpdrive/NEWS
@@ -0,0 +1 @@
+init
diff --git a/samples/warpdrive/README b/samples/warpdrive/README
new file mode 100644
index 000000000000..3adf66b112fc
--- /dev/null
+++ b/samples/warpdrive/README
@@ -0,0 +1,32 @@
+WD User Land Demonstration
+==========================
+
+This directory contains some applications and libraries to demonstrate how a
+
+WrapDrive application can be constructed.
+
+
+As a demo, we try to make it simple and clear for understanding. It is not
+
+supposed to be used in business scenario.
+
+
+The directory contains the following elements:
+
+wd.[ch]
+	A demonstration WrapDrive fundamental library which wraps the basic
+	operations to the WrapDrive-ed device.
+
+wd_adapter.[ch]
+	User driver adaptor for wd.[ch]
+
+wd_utils.[ch]
+	Some utitlities function used by WD and its drivers
+
+drv/*
+	User drivers. It helps to fulfill the semantic of wd.[ch] for
+	particular hardware
+
+test/*
+	Test applications to use the wrapdrive library
+
diff --git a/samples/warpdrive/autogen.sh b/samples/warpdrive/autogen.sh
new file mode 100755
index 000000000000..58deaf49de2a
--- /dev/null
+++ b/samples/warpdrive/autogen.sh
@@ -0,0 +1,3 @@
+#!/bin/sh -x
+
+autoreconf -i -f -v
diff --git a/samples/warpdrive/cleanup.sh b/samples/warpdrive/cleanup.sh
new file mode 100755
index 000000000000..c5f3d21e5dc1
--- /dev/null
+++ b/samples/warpdrive/cleanup.sh
@@ -0,0 +1,13 @@
+#!/bin/sh
+
+if [ -r Makefile ]; then
+	make distclean
+fi
+
+FILES="aclocal.m4 autom4te.cache compile config.guess config.h.in config.log \
+       config.status config.sub configure cscope.out depcomp install-sh      \
+       libsrc/Makefile libsrc/Makefile.in libtool ltmain.sh Makefile         \
+       ar-lib m4 \
+       Makefile.in missing src/Makefile src/Makefile.in test/Makefile.in"
+
+rm -vRf $FILES
diff --git a/samples/warpdrive/configure.ac b/samples/warpdrive/configure.ac
new file mode 100644
index 000000000000..53262f3197c2
--- /dev/null
+++ b/samples/warpdrive/configure.ac
@@ -0,0 +1,52 @@
+AC_PREREQ([2.69])
+AC_INIT([wrapdrive], [0.1], [liguozhu@hisilicon.com])
+AC_CONFIG_SRCDIR([wd.c])
+AM_INIT_AUTOMAKE([1.10 no-define])
+
+AC_CONFIG_MACRO_DIR([m4])
+AC_CONFIG_HEADERS([config.h])
+
+# Checks for programs.
+AC_PROG_CXX
+AC_PROG_AWK
+AC_PROG_CC
+AC_PROG_CPP
+AC_PROG_INSTALL
+AC_PROG_LN_S
+AC_PROG_MAKE_SET
+AC_PROG_RANLIB
+
+AM_PROG_AR
+AC_PROG_LIBTOOL
+AM_PROG_LIBTOOL
+LT_INIT
+AM_PROG_CC_C_O
+
+AC_DEFINE([HAVE_SVA], [0], [enable SVA support])
+AC_ARG_ENABLE([sva],
+	      [ --enable-sva 	enable to support sva feature],
+	      AC_DEFINE([HAVE_SVA], [1]))
+
+# Checks for libraries.
+
+# Checks for header files.
+AC_CHECK_HEADERS([fcntl.h stdint.h stdlib.h string.h sys/ioctl.h sys/time.h unistd.h])
+
+# Checks for typedefs, structures, and compiler characteristics.
+AC_CHECK_HEADER_STDBOOL
+AC_C_INLINE
+AC_TYPE_OFF_T
+AC_TYPE_SIZE_T
+AC_TYPE_UINT16_T
+AC_TYPE_UINT32_T
+AC_TYPE_UINT64_T
+AC_TYPE_UINT8_T
+
+# Checks for library functions.
+AC_FUNC_MALLOC
+AC_FUNC_MMAP
+AC_CHECK_FUNCS([memset munmap])
+
+AC_CONFIG_FILES([Makefile
+                 test/Makefile])
+AC_OUTPUT
diff --git a/samples/warpdrive/drv/hisi_qm_udrv.c b/samples/warpdrive/drv/hisi_qm_udrv.c
new file mode 100644
index 000000000000..777e2e3cff18
--- /dev/null
+++ b/samples/warpdrive/drv/hisi_qm_udrv.c
@@ -0,0 +1,223 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdlib.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <sys/mman.h>
+#include <assert.h>
+#include <string.h>
+#include <stdint.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <sys/epoll.h>
+#include <sys/eventfd.h>
+
+#include "hisi_qm_udrv.h"
+
+#if __AARCH64EL__ == 1
+#define mb() {asm volatile("dsb sy" : : : "memory"); }
+#else
+#warning "this file need to be used on AARCH64EL mode"
+#define mb()
+#endif
+
+#define QM_SQE_SIZE		128
+#define QM_CQE_SIZE		16
+#define QM_EQ_DEPTH		1024
+
+/* cqe shift */
+#define CQE_PHASE(cq)	(((*((__u32 *)(cq) + 3)) >> 16) & 0x1)
+#define CQE_SQ_NUM(cq)	((*((__u32 *)(cq) + 2)) >> 16)
+#define CQE_SQ_HEAD_INDEX(cq)	((*((__u32 *)(cq) + 2)) & 0xffff)
+
+#define QM_IOMEM_SIZE		4096
+
+#define QM_DOORBELL_OFFSET	0x340
+
+struct cqe {
+	__le32 rsvd0;
+	__le16 cmd_id;
+	__le16 rsvd1;
+	__le16 sq_head;
+	__le16 sq_num;
+	__le16 rsvd2;
+	__le16 w7; /* phase, status */
+};
+
+struct hisi_qm_queue_info {
+	void *sq_base;
+	void *cq_base;
+	void *doorbell_base;
+	__u16 sq_tail_index;
+	__u16 sq_head_index;
+	__u16 cq_head_index;
+	__u16 sqn;
+	bool cqc_phase;
+	void *req_cache[QM_EQ_DEPTH];
+	int is_sq_full;
+};
+
+int hacc_db(struct hisi_qm_queue_info *q, __u8 cmd, __u16 index, __u8 priority)
+{
+	void *base = q->doorbell_base;
+	__u16 sqn = q->sqn;
+	__u64 doorbell = 0;
+
+	doorbell = (__u64)sqn | ((__u64)cmd << 16);
+	doorbell |= ((__u64)index | ((__u64)priority << 16)) << 32;
+
+	*((__u64 *)base) = doorbell;
+
+	return 0;
+}
+
+static int hisi_qm_fill_sqe(void *msg, struct hisi_qm_queue_info *info, __u16 i)
+{
+	struct hisi_qm_msg *sqe = (struct hisi_qm_msg *)info->sq_base + i;
+	memcpy((void *)sqe, msg, sizeof(struct hisi_qm_msg));
+	assert(!info->req_cache[i]);
+	info->req_cache[i] = msg;
+
+	return 0;
+}
+
+static int hisi_qm_recv_sqe(struct hisi_qm_msg *sqe, struct hisi_qm_queue_info *info, __u16 i)
+{
+	__u32 status = sqe->dw3 & 0xff;
+	__u32 type = sqe->dw9 & 0xff;
+
+	if (status != 0 && status != 0x0d) {
+		fprintf(stderr, "bad status (s=%d, t=%d)\n", status, type);
+		return -EIO;
+	}
+
+	assert(info->req_cache[i]);
+	memcpy((void *)info->req_cache[i], sqe, sizeof(struct hisi_qm_msg));
+	return 0;
+}
+
+int hisi_qm_set_queue_dio(struct wd_queue *q)
+{
+	struct hisi_qm_queue_info *info;
+	void *vaddr;
+	int ret;
+
+	alloc_obj(info);
+	if (!info)
+		return -1;
+
+	q->priv = info;
+
+	vaddr = mmap(NULL,
+		QM_SQE_SIZE * QM_EQ_DEPTH + QM_CQE_SIZE * QM_EQ_DEPTH,
+		PROT_READ | PROT_WRITE, MAP_SHARED, q->mdev, 4096);
+	if (vaddr <= 0) {
+		ret = (intptr_t)vaddr;
+		goto err_with_info;
+	}
+	info->sq_base = vaddr;
+	info->cq_base = vaddr + QM_SQE_SIZE * QM_EQ_DEPTH;
+
+	vaddr = mmap(NULL, QM_IOMEM_SIZE,
+		PROT_READ | PROT_WRITE, MAP_SHARED, q->mdev, 0);
+	if (vaddr <= 0) {
+		ret = (intptr_t)vaddr;
+		goto err_with_scq;
+	}
+	info->doorbell_base = vaddr + QM_DOORBELL_OFFSET;
+	info->sq_tail_index = 0;
+	info->sq_head_index = 0;
+	info->cq_head_index = 0;
+	info->cqc_phase = 1;
+
+	info->is_sq_full = 0;
+
+	return 0;
+
+err_with_scq:
+	munmap(info->sq_base,
+		QM_SQE_SIZE * QM_EQ_DEPTH + QM_CQE_SIZE * QM_EQ_DEPTH);
+err_with_info:
+	free(info);
+	return ret;
+}
+
+void hisi_qm_unset_queue_dio(struct wd_queue *q)
+{
+	struct hisi_qm_queue_info *info = (struct hisi_qm_queue_info *)q->priv;
+
+	munmap(info->doorbell_base - QM_DOORBELL_OFFSET, QM_IOMEM_SIZE);
+	munmap(info->cq_base, QM_CQE_SIZE * QM_EQ_DEPTH);
+	munmap(info->sq_base, QM_SQE_SIZE * QM_EQ_DEPTH);
+	free(info);
+	q->priv = NULL;
+}
+
+int hisi_qm_add_to_dio_q(struct wd_queue *q, void *req)
+{
+	struct hisi_qm_queue_info *info = (struct hisi_qm_queue_info *)q->priv;
+	__u16 i;
+
+	if (info->is_sq_full)
+		return -EBUSY;
+
+	i = info->sq_tail_index;
+
+	hisi_qm_fill_sqe(req, q->priv, i);
+
+	mb();
+
+	if (i == (QM_EQ_DEPTH - 1))
+		i = 0;
+	else
+		i++;
+
+	hacc_db(info, DOORBELL_CMD_SQ, i, 0);
+
+	info->sq_tail_index = i;
+
+	if (i == info->sq_head_index)
+		info->is_sq_full = 1;
+
+	return 0;
+}
+
+int hisi_qm_get_from_dio_q(struct wd_queue *q, void **resp)
+{
+	struct hisi_qm_queue_info *info = (struct hisi_qm_queue_info *)q->priv;
+	__u16 i = info->cq_head_index;
+	struct cqe *cq_base = info->cq_base;
+	struct hisi_qm_msg *sq_base = info->sq_base;
+	struct cqe *cqe = cq_base + i;
+	struct hisi_qm_msg *sqe;
+	int ret;
+
+	if (info->cqc_phase == CQE_PHASE(cqe)) {
+		sqe = sq_base + CQE_SQ_HEAD_INDEX(cqe);
+		ret = hisi_qm_recv_sqe(sqe, info, i);
+		if (ret < 0)
+			return -EIO;
+
+		if (info->is_sq_full)
+			info->is_sq_full = 0;
+	} else {
+		return -EAGAIN;
+	}
+
+	*resp = info->req_cache[i];
+	info->req_cache[i] = NULL;
+
+	if (i == (QM_EQ_DEPTH - 1)) {
+		info->cqc_phase = !(info->cqc_phase);
+		i = 0;
+	} else
+		i++;
+
+	hacc_db(info, DOORBELL_CMD_CQ, i, 0);
+
+	info->cq_head_index = i;
+	info->sq_head_index = i;
+
+
+	return ret;
+}
diff --git a/samples/warpdrive/drv/hisi_qm_udrv.h b/samples/warpdrive/drv/hisi_qm_udrv.h
new file mode 100644
index 000000000000..6a7a06a089c9
--- /dev/null
+++ b/samples/warpdrive/drv/hisi_qm_udrv.h
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef __HZIP_DRV_H__
+#define __HZIP_DRV_H__
+
+#include <linux/types.h>
+#include "../wd.h"
+
+/* this is unnecessary big, the hardware should optimize it */
+struct hisi_qm_msg {
+	__u32 consumed;
+	__u32 produced;
+	__u32 comp_date_length;
+	__u32 dw3;
+	__u32 input_date_length;
+	__u32 lba_l;
+	__u32 lba_h;
+	__u32 dw7; /* ... */
+	__u32 dw8; /* ... */
+	__u32 dw9; /* ... */
+	__u32 dw10; /* ... */
+	__u32 priv_info;
+	__u32 dw12; /* ... */
+	__u32 tag;
+	__u32 dest_avail_out;
+	__u32 rsvd0;
+	__u32 comp_head_addr_l;
+	__u32 comp_head_addr_h;
+	__u32 source_addr_l;
+	__u32 source_addr_h;
+	__u32 dest_addr_l;
+	__u32 dest_addr_h;
+	__u32 stream_ctx_addr_l;
+	__u32 stream_ctx_addr_h;
+	__u32 cipher_key1_addr_l;
+	__u32 cipher_key1_addr_h;
+	__u32 cipher_key2_addr_l;
+	__u32 cipher_key2_addr_h;
+	__u32 rsvd1[4];
+};
+
+struct hisi_acc_qm_sqc {
+	__u16 sqn;
+};
+
+#define DOORBELL_CMD_SQ		0
+#define DOORBELL_CMD_CQ		1
+
+int hisi_qm_set_queue_dio(struct wd_queue *q);
+void hisi_qm_unset_queue_dio(struct wd_queue *q);
+int hisi_qm_add_to_dio_q(struct wd_queue *q, void *req);
+int hisi_qm_get_from_dio_q(struct wd_queue *q, void **resp);
+
+#endif
diff --git a/samples/warpdrive/test/Makefile.am b/samples/warpdrive/test/Makefile.am
new file mode 100644
index 000000000000..ad80e80a47d7
--- /dev/null
+++ b/samples/warpdrive/test/Makefile.am
@@ -0,0 +1,7 @@
+AM_CFLAGS=-Wall -O0 -fno-strict-aliasing
+
+bin_PROGRAMS=test_hisi_zip
+
+test_hisi_zip_SOURCES=test_hisi_zip.c
+
+test_hisi_zip_LDADD=../.libs/libwd.a
diff --git a/samples/warpdrive/test/comp_hw.h b/samples/warpdrive/test/comp_hw.h
new file mode 100644
index 000000000000..79328fd0c1a0
--- /dev/null
+++ b/samples/warpdrive/test/comp_hw.h
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ * This file is shared bewteen user and kernel space Wrapdrive which is
+ * including algorithm attibutions that both user and driver are caring for
+ */
+
+#ifndef __VFIO_WDEV_COMP_H
+#define __VFIO_WDEV_COMP_H
+
+/* De-compressing algorithms' parameters */
+struct vfio_wdev_comp_param {
+	__u32 window_size;
+	__u32 comp_level;
+	__u32 mode;
+	__u32 alg;
+};
+
+/* WD defines all the De-compressing algorithm names here */
+#define VFIO_WDEV_ZLIB			"zlib"
+#define VFIO_WDEV_GZIP			"gzip"
+#define VFIO_WDEV_LZ4			"lz4"
+
+#endif
diff --git a/samples/warpdrive/test/test_hisi_zip.c b/samples/warpdrive/test/test_hisi_zip.c
new file mode 100644
index 000000000000..5bf90c6d0e81
--- /dev/null
+++ b/samples/warpdrive/test/test_hisi_zip.c
@@ -0,0 +1,206 @@
+// SPDX-License-Identifier: GPL-2.0+
+#include <stdio.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/time.h>
+#include <unistd.h>
+#include "../wd.h"
+#include "comp_hw.h"
+#include "../drv/hisi_qm_udrv.h"
+
+#if defined(MSDOS) || defined(OS2) || defined(WIN32) || defined(__CYGWIN__)
+#  include <fcntl.h>
+#  include <io.h>
+#  define SET_BINARY_MODE(file) setmode(fileno(file), O_BINARY)
+#else
+#  define SET_BINARY_MODE(file)
+#endif
+
+#define PAGE_SHIFT	12
+#define PAGE_SIZE	(1 << PAGE_SHIFT)
+
+#define ASIZE (8*512*4096)	/*16MB*/
+
+#define SYS_ERR_COND(cond, msg)		\
+do {					\
+	if (cond) {			\
+		perror(msg);		\
+		exit(EXIT_FAILURE);	\
+	}				\
+} while (0)
+
+#define ZLIB 0
+#define GZIP 1
+
+#define CHUNK 65535
+
+
+int hizip_deflate(FILE *source, FILE *dest,  int type)
+{
+	__u64 in, out;
+	struct wd_queue q;
+	struct hisi_qm_msg *msg, *recv_msg;
+	void *a, *b;
+	char *src, *dst;
+	int ret, total_len;
+	int output_num;
+	int fd, file_msize;
+
+	memset(&q, 0, sizeof(q));
+	q.container = -1;
+	q.mdev_name = "22e09922-7a82-11e8-9cf6-d74cffa9e87b";
+	q.vfio_group_path = "/dev/vfio/10"; //fixme to the right path
+	q.iommu_ext_path = "/sys/class/sdmdev/0000:75:00.0/device/params/iommu_type";
+	q.dmaflag_ext_path = "/sys/class/sdmdev/0000:75:00.0/device/params/dma_flag";
+	q.device_api_path = "/sys/class/sdmdev/0000:75:00.0/device/mdev_supported_types/hisi_zip-hisi_zip/device_api";
+	ret = wd_request_queue(&q);
+	SYS_ERR_COND(ret, "wd_request_queue");
+
+	fprintf(stderr, "pasid=%d, dma_flag=%d\n", q.pasid, q.dma_flag);
+	fd = fileno(source);
+	struct stat s;
+
+	if (fstat(fd, &s) < 0) {
+		close(fd);
+		perror("fd error\n");
+		return -1;
+	}
+	total_len = s.st_size;
+
+	if (!total_len) {
+		ret = -EINVAL;
+		SYS_ERR_COND(ret, "input file length zero");
+	}
+	if (total_len > 16*1024*1024) {
+		fputs("error, input file size too large(<16MB)!\n", stderr);
+		goto release_q;
+	}
+	file_msize = !(total_len%PAGE_SIZE) ? total_len :
+			(total_len/PAGE_SIZE+1)*PAGE_SIZE;
+	/* mmap file and  DMA mapping */
+	a = mmap((void *)0x0, file_msize, PROT_READ | PROT_WRITE,
+		 MAP_PRIVATE, fd, 0);
+	if (!a) {
+		fputs("mmap file fail!\n", stderr);
+		goto release_q;
+	}
+	ret = wd_mem_share(&q, a, file_msize, 0);
+	if (ret) {
+		fprintf(stderr, "wd_mem_share dma a buf fail!err=%d\n", -errno);
+		goto unmap_file;
+	}
+	/* Allocate some space and setup a DMA mapping */
+	b = mmap((void *)0x0, ASIZE, PROT_READ | PROT_WRITE,
+		 MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
+	if (!b) {
+		fputs("mmap b fail!\n", stderr);
+		goto unshare_file;
+	}
+	memset(b, 0, ASIZE);
+	ret = wd_mem_share(&q, b, ASIZE, 0);
+	if (ret) {
+		fputs("wd_mem_share dma b buf fail!\n", stderr);
+		goto unmap_mem;
+	}
+	src = (char *)a;
+	dst = (char *)b;
+
+	msg = malloc(sizeof(*msg));
+	if (!msg) {
+		fputs("alloc msg fail!\n", stderr);
+		goto alloc_msg_fail;
+	}
+	memset((void *)msg, 0, sizeof(*msg));
+	msg->input_date_length = total_len;
+	if (type == ZLIB)
+		msg->dw9 = 2;
+	else
+		msg->dw9 = 3;
+	msg->dest_avail_out = 0x800000;
+
+	in = (__u64)src;
+	out = (__u64)dst;
+
+	msg->source_addr_l = in & 0xffffffff;
+	msg->source_addr_h = in >> 32;
+	msg->dest_addr_l = out & 0xffffffff;
+	msg->dest_addr_h = out >> 32;
+
+	ret = wd_send(&q, msg);
+
+	if (ret == -EBUSY) {
+		usleep(1);
+		goto recv_again;
+	}
+	SYS_ERR_COND(ret, "send fail!\n");
+recv_again:
+	ret = wd_recv(&q, (void **)&recv_msg);
+	if (ret == -EIO) {
+		fputs(" wd_recv fail!\n", stderr);
+		goto alloc_msg_fail;
+	/* synchronous mode, if get none, then get again */
+	} else if (ret == -EAGAIN)
+		goto recv_again;
+
+	output_num = recv_msg->produced;
+	/* add zlib compress head and write head + compressed date to a file */
+	char zip_head[2] = {0x78, 0x9c};
+
+	fwrite(zip_head, 1, 2, dest);
+	fwrite((char *)out, 1, output_num, dest);
+	fclose(dest);
+
+	free(msg);
+alloc_msg_fail:
+	wd_mem_unshare(&q, b, ASIZE);
+unmap_mem:
+	munmap(b, ASIZE);
+unshare_file:
+	wd_mem_unshare(&q, a, file_msize);
+unmap_file:
+	munmap(a, file_msize);
+release_q:
+	wd_release_queue(&q);
+
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	int alg_type = 0;
+
+	/* avoid end-of-line conversions */
+	SET_BINARY_MODE(stdin);
+	SET_BINARY_MODE(stdout);
+
+	if (!argv[1]) {
+		fputs("<<use ./test_hisi_zip -h get more details>>\n", stderr);
+		goto EXIT;
+	}
+
+	if (!strcmp(argv[1], "-z"))
+		alg_type = ZLIB;
+	else if (!strcmp(argv[1], "-g")) {
+		alg_type = GZIP;
+	} else if (!strcmp(argv[1], "-h")) {
+		fputs("[version]:1.0.2\n", stderr);
+		fputs("[usage]: ./test_hisi_zip [type] <src_file> dest_file\n",
+			stderr);
+		fputs("     [type]:\n", stderr);
+		fputs("            -z  = zlib\n", stderr);
+		fputs("            -g  = gzip\n", stderr);
+		fputs("            -h  = usage\n", stderr);
+		fputs("Example:\n", stderr);
+		fputs("./test_hisi_zip -z < test.data > out.data\n", stderr);
+		goto EXIT;
+	} else {
+		fputs("Unknow option\n", stderr);
+		fputs("<<use ./test_comp_iommu -h get more details>>\n",
+			stderr);
+		goto EXIT;
+	}
+
+	hizip_deflate(stdin, stdout, alg_type);
+EXIT:
+	return EXIT_SUCCESS;
+}
diff --git a/samples/warpdrive/wd.c b/samples/warpdrive/wd.c
new file mode 100644
index 000000000000..8df071637341
--- /dev/null
+++ b/samples/warpdrive/wd.c
@@ -0,0 +1,309 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "config.h"
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/queue.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <errno.h>
+#include <sys/mman.h>
+#include <string.h>
+#include <assert.h>
+#include <dirent.h>
+#include <sys/poll.h>
+#include "wd.h"
+#include "wd_adapter.h"
+
+#if (defined(HAVE_SVA) & HAVE_SVA)
+static int _wd_bind_process(struct wd_queue *q)
+{
+	struct bind_data {
+		struct vfio_iommu_type1_bind bind;
+		struct vfio_iommu_type1_bind_process data;
+	} wd_bind;
+	int ret;
+	__u32 flags = 0;
+
+	if (q->dma_flag & VFIO_SDMDEV_DMA_MULTI_PROC_MAP)
+		flags = VFIO_IOMMU_BIND_PRIV;
+	else if (q->dma_flag & VFIO_SDMDEV_DMA_SVM_NO_FAULT)
+		flags = VFIO_IOMMU_BIND_NOPF;
+
+	wd_bind.bind.flags = VFIO_IOMMU_BIND_PROCESS;
+	wd_bind.bind.argsz = sizeof(wd_bind);
+	wd_bind.data.flags = flags;
+	ret = ioctl(q->container, VFIO_IOMMU_BIND, &wd_bind);
+	if (ret)
+		return ret;
+	q->pasid = wd_bind.data.pasid;
+	return ret;
+}
+
+static int _wd_unbind_process(struct wd_queue *q)
+{
+	struct bind_data {
+		struct vfio_iommu_type1_bind bind;
+		struct vfio_iommu_type1_bind_process data;
+	} wd_bind;
+	__u32 flags = 0;
+
+	if (q->dma_flag & VFIO_SDMDEV_DMA_MULTI_PROC_MAP)
+		flags = VFIO_IOMMU_BIND_PRIV;
+	else if (q->dma_flag & VFIO_SDMDEV_DMA_SVM_NO_FAULT)
+		flags = VFIO_IOMMU_BIND_NOPF;
+
+	wd_bind.bind.flags = VFIO_IOMMU_BIND_PROCESS;
+	wd_bind.data.pasid = q->pasid;
+	wd_bind.data.flags = flags;
+	wd_bind.bind.argsz = sizeof(wd_bind);
+
+	return ioctl(q->container, VFIO_IOMMU_UNBIND, &wd_bind);
+}
+#endif
+
+int wd_request_queue(struct wd_queue *q)
+{
+	struct vfio_group_status group_status = {
+		.argsz = sizeof(group_status) };
+	int iommu_ext;
+	int ret;
+
+	if (!q->vfio_group_path ||
+		!q->device_api_path ||
+		!q->dmaflag_ext_path ||
+		!q->iommu_ext_path) {
+		WD_ERR("please set vfio_group_path, dmaflag_ext_path, "
+		"device_api_path, and iommu_ext_path before call %s", __func__);
+		return -EINVAL;
+	}
+
+	q->hw_type_id = 0; /* this can be set according to the device api_version in the future */
+
+	q->group = open(q->vfio_group_path, O_RDWR);
+	if (q->group < 0) {
+		WD_ERR("open vfio group(%s) fail, errno=%d\n",
+			q->vfio_group_path, errno);
+		return -errno;
+	}
+
+	if (q->container <= 0) {
+		q->container = open("/dev/vfio/vfio", O_RDWR);
+		if (q->container < 0) {
+			WD_ERR("Create VFIO container fail!\n");
+			ret = -ENODEV;
+			goto err_with_group;
+		}
+	}
+
+	if (ioctl(q->container, VFIO_GET_API_VERSION) != VFIO_API_VERSION) {
+		WD_ERR("VFIO version check fail!\n");
+		ret = -EINVAL;
+		goto err_with_container;
+	}
+
+	q->dma_flag = _get_attr_int(q->dmaflag_ext_path);
+	if (q->dma_flag == INT_MIN) {
+		ret = -EINVAL;
+		goto err_with_container;
+	}
+
+	iommu_ext = _get_attr_int(q->iommu_ext_path);
+	if (iommu_ext == INT_MIN) {
+		ret = -EINVAL;
+		goto err_with_container;
+	}
+
+	ret = ioctl(q->container, VFIO_CHECK_EXTENSION, iommu_ext);
+	if (!ret) {
+		WD_ERR("VFIO iommu check (%d) fail (%d)!\n", iommu_ext, ret);
+		goto err_with_container;
+	}
+
+	ret = _get_attr_str(q->device_api_path, q->hw_type);
+	if (ret)
+		goto err_with_container;
+
+	ret = ioctl(q->group, VFIO_GROUP_GET_STATUS, &group_status);
+	if (!(group_status.flags & VFIO_GROUP_FLAGS_VIABLE)) {
+		WD_ERR("VFIO group is not viable\n");
+		goto err_with_container;
+	}
+
+	ret = ioctl(q->group, VFIO_GROUP_SET_CONTAINER, &q->container);
+	if (ret) {
+		WD_ERR("VFIO group fail on VFIO_GROUP_SET_CONTAINER\n");
+		goto err_with_container;
+	}
+
+	ret = ioctl(q->container, VFIO_SET_IOMMU, iommu_ext);
+	if (ret) {
+		WD_ERR("VFIO fail on VFIO_SET_IOMMU(%d)\n", iommu_ext);
+		goto err_with_container;
+	}
+
+	q->mdev = ioctl(q->group, VFIO_GROUP_GET_DEVICE_FD, q->mdev_name);
+	if (q->mdev < 0) {
+		WD_ERR("VFIO fail on VFIO_GROUP_GET_DEVICE_FD (%d)\n", q->mdev);
+		ret = q->mdev;
+		goto err_with_container;
+	}
+
+#if (defined(HAVE_SVA) & HAVE_SVA)
+	if (!(q->dma_flag & (VFIO_SDMDEV_DMA_PHY | VFIO_SDMDEV_DMA_SINGLE_PROC_MAP))) {
+		ret = _wd_bind_process(q);
+		if (ret) {
+			close(q->mdev);
+			WD_ERR("VFIO fails to bind process!\n");
+			goto err_with_mdev;
+
+		}
+	}
+
+	ret = ioctl(q->mdev, VFIO_SDMDEV_CMD_BIND_PASID, (unsigned long)q->pasid);
+	if (ret < 0) {
+		WD_ERR("fail to bind paisd to device,ret=%d\n", errno);
+		goto err_with_mdev;
+	}
+#endif
+
+	ret = drv_open(q);
+	if (ret)
+		goto err_with_mdev;
+
+	return 0;
+
+err_with_mdev:
+	close(q->mdev);
+err_with_container:
+	close(q->container);
+err_with_group:
+	close(q->group);
+	return ret;
+}
+
+void wd_release_queue(struct wd_queue *q)
+{
+	drv_close(q);
+
+#if (defined(HAVE_SVA) & HAVE_SVA)
+	if (!(q->dma_flag & (VFIO_SDMDEV_DMA_PHY | VFIO_SDMDEV_DMA_SINGLE_PROC_MAP))) {
+		if (q->pasid <= 0) {
+			WD_ERR("Wd queue pasid ! pasid=%d\n", q->pasid);
+			return;
+		}
+		if (_wd_unbind_process(q)) {
+			WD_ERR("VFIO fails to unbind process!\n");
+			return;
+		}
+	}
+#endif
+
+	close(q->mdev);
+	close(q->container);
+	close(q->group);
+}
+
+int wd_send(struct wd_queue *q, void *req)
+{
+	return drv_send(q, req);
+}
+
+int wd_recv(struct wd_queue *q, void **resp)
+{
+	return drv_recv(q, resp);
+}
+
+static int wd_flush_and_wait(struct wd_queue *q, int ms)
+{
+	wd_flush(q);
+	return ioctl(q->mdev, VFIO_SDMDEV_CMD_WAIT, ms);
+}
+
+int wd_recv_sync(struct wd_queue *q, void **resp, __u16 ms)
+{
+	int ret;
+
+	while (1) {
+		ret = wd_recv(q, resp);
+		if (ret == -EBUSY) {
+			ret = wd_flush_and_wait(q, ms);
+			if (ret)
+				return ret;
+		} else
+			return ret;
+	}
+}
+
+void wd_flush(struct wd_queue *q)
+{
+	drv_flush(q);
+}
+
+static int _wd_mem_share_type1(struct wd_queue *q, const void *addr,
+			       size_t size, int flags)
+{
+	struct vfio_iommu_type1_dma_map dma_map;
+
+	if (q->dma_flag & VFIO_SDMDEV_DMA_SVM_NO_FAULT)
+		return mlock(addr, size);
+
+#if (defined(HAVE_SVA) & HAVE_SVA)
+	else if ((q->dma_flag & VFIO_SDMDEV_DMA_MULTI_PROC_MAP) &&
+		 (q->pasid > 0))
+		dma_map.pasid = q->pasid;
+#endif
+	else if ((q->dma_flag & VFIO_SDMDEV_DMA_SINGLE_PROC_MAP))
+		; //todo
+	else
+		return -1;
+
+	dma_map.vaddr = (__u64)addr;
+	dma_map.size = size;
+	dma_map.iova = (__u64)addr;
+	dma_map.flags =
+		VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE | flags;
+	dma_map.argsz = sizeof(dma_map);
+
+	return ioctl(q->container, VFIO_IOMMU_MAP_DMA, &dma_map);
+}
+
+static void _wd_mem_unshare_type1(struct wd_queue *q, const void *addr,
+				  size_t size)
+{
+#if (defined(HAVE_SVA) & HAVE_SVA)
+	struct vfio_iommu_type1_dma_unmap dma_unmap;
+#endif
+
+	if (q->dma_flag & VFIO_SDMDEV_DMA_SVM_NO_FAULT) {
+		(void)munlock(addr, size);
+		return;
+	}
+
+#if (defined(HAVE_SVA) & HAVE_SVA)
+	dma_unmap.iova = (__u64)addr;
+	if ((q->dma_flag & VFIO_SDMDEV_DMA_MULTI_PROC_MAP) && (q->pasid > 0))
+		dma_unmap.flags = 0;
+		dma_unmap.size = size;
+		dma_unmap.argsz = sizeof(dma_unmap);
+		ioctl(q->container, VFIO_IOMMU_UNMAP_DMA, &dma_unmap);
+#endif
+}
+
+int wd_mem_share(struct wd_queue *q, const void *addr, size_t size, int flags)
+{
+	if (drv_can_do_mem_share(q))
+		return drv_share(q, addr, size, flags);
+	else
+		return _wd_mem_share_type1(q, addr, size, flags);
+}
+
+void wd_mem_unshare(struct wd_queue *q, const void *addr, size_t size)
+{
+	if (drv_can_do_mem_share(q))
+		drv_unshare(q, addr, size);
+	else
+		_wd_mem_unshare_type1(q, addr, size);
+}
+
diff --git a/samples/warpdrive/wd.h b/samples/warpdrive/wd.h
new file mode 100644
index 000000000000..eccf43dc034d
--- /dev/null
+++ b/samples/warpdrive/wd.h
@@ -0,0 +1,154 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef __WD_H
+#define __WD_H
+#include <stdlib.h>
+#include <errno.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <stdint.h>
+#include <unistd.h>
+#include <limits.h>
+#include "../../include/uapi/linux/vfio.h"
+#include "../../include/uapi/linux/vfio_sdmdev.h"
+
+#define SYS_VAL_SIZE		16
+#define PATH_STR_SIZE 		256
+#define WD_NAME_SIZE 		64
+#define WD_MAX_MEMLIST_SZ 	128
+
+
+#ifndef dma_addr_t
+#define dma_addr_t __u64
+#endif
+
+typedef int bool;
+
+#ifndef true
+#define true 1
+#endif
+
+#ifndef false
+#define false 0
+#endif
+
+/* the flags used by wd_capa->flags, the high 16bits are for algorithm
+ * and the low 16bits are for Framework
+ */
+#define WD_FLAGS_FW_PREFER_LOCAL_ZONE 1
+
+#define WD_FLAGS_FW_MASK 0x0000FFFF
+#ifndef WD_ERR
+#define WD_ERR(format, args...) fprintf(stderr, format, ##args)
+#endif
+
+/* Default page size should be 4k size */
+#define WDQ_MAP_REGION(region_index)	((region_index << 12) & 0xf000)
+#define WDQ_MAP_Q(q_index)		((q_index << 16) & 0xffff0000)
+
+static inline void wd_reg_write(void *reg_addr, uint32_t value)
+{
+	*((volatile uint32_t *)reg_addr) = value;
+}
+
+static inline uint32_t wd_reg_read(void *reg_addr)
+{
+	uint32_t temp;
+
+	temp = *((volatile uint32_t *)reg_addr);
+
+	return temp;
+}
+
+static inline int _get_attr_str(const char *path, char value[PATH_STR_SIZE])
+{
+	int fd, ret;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		WD_ERR("get_attr_str: open %s fail\n", path);
+		return fd;
+	}
+	memset(value, 0, PATH_STR_SIZE);
+	ret = read(fd, value, PATH_STR_SIZE);
+	if (ret > 0) {
+		close(fd);
+		return 0;
+	}
+	close(fd);
+
+	WD_ERR("read nothing from %s\n", path);
+	return -EINVAL;
+}
+
+static inline int _get_attr_int(const char *path)
+{
+	char value[PATH_STR_SIZE];
+	if (_get_attr_str(path, value))
+		return INT_MIN;
+	else
+		return atoi(value);
+}
+
+/* Memory in accelerating message can be different */
+enum wd_addr_flags {
+	WD_AATTR_INVALID = 0,
+
+	 /* Common user virtual memory */
+	_WD_AATTR_COM_VIRT = 1,
+
+	 /* Physical address*/
+	_WD_AATTR_PHYS = 2,
+
+	/* I/O virtual address*/
+	_WD_AATTR_IOVA = 4,
+
+	/* SGL, user cares for */
+	WD_AATTR_SGL = 8,
+};
+
+#define WD_CAPA_PRIV_DATA_SIZE	64
+
+#define alloc_obj(objp) do { \
+	objp = malloc(sizeof(*objp)); \
+	memset(objp, 0, sizeof(*objp)); \
+}while(0)
+#define free_obj(objp) if (objp)free(objp)
+
+struct wd_queue {
+	const char *mdev_name;
+	char hw_type[PATH_STR_SIZE];
+	int hw_type_id;
+	int dma_flag;
+	void *priv; /* private data used by the drv layer */
+	int container;
+	int group;
+	int mdev;
+	int pasid;
+	int iommu_type;
+	char *vfio_group_path;
+	char *iommu_ext_path;
+	char *dmaflag_ext_path;
+	char *device_api_path;
+};
+
+extern int wd_request_queue(struct wd_queue *q);
+extern void wd_release_queue(struct wd_queue *q);
+extern int wd_send(struct wd_queue *q, void *req);
+extern int wd_recv(struct wd_queue *q, void **resp);
+extern void wd_flush(struct wd_queue *q);
+extern int wd_recv_sync(struct wd_queue *q, void **resp, __u16 ms);
+extern int wd_mem_share(struct wd_queue *q, const void *addr,
+			size_t size, int flags);
+extern void wd_mem_unshare(struct wd_queue *q, const void *addr, size_t size);
+
+/* for debug only */
+extern int wd_dump_all_algos(void);
+
+/* this is only for drv used */
+extern int wd_set_queue_attr(struct wd_queue *q, const char *name,
+				char *value);
+extern int __iommu_type(struct wd_queue *q);
+#endif
diff --git a/samples/warpdrive/wd_adapter.c b/samples/warpdrive/wd_adapter.c
new file mode 100644
index 000000000000..d8d55b75e99a
--- /dev/null
+++ b/samples/warpdrive/wd_adapter.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdio.h>
+#include <string.h>
+#include <dirent.h>
+
+
+#include "wd_adapter.h"
+#include "./drv/hisi_qm_udrv.h"
+
+static struct wd_drv_dio_if hw_dio_tbl[] = { {
+		.hw_type = "hisi_qm_v1",
+		.open = hisi_qm_set_queue_dio,
+		.close = hisi_qm_unset_queue_dio,
+		.send = hisi_qm_add_to_dio_q,
+		.recv = hisi_qm_get_from_dio_q,
+	},
+	/* Add other drivers direct IO operations here */
+};
+
+/* todo: there should be some stable way to match the device and the driver */
+#define MAX_HW_TYPE (sizeof(hw_dio_tbl) / sizeof(hw_dio_tbl[0]))
+
+int drv_open(struct wd_queue *q)
+{
+	int i;
+
+	//todo: try to find another dev if the user driver is not avaliable
+	for (i = 0; i < MAX_HW_TYPE; i++) {
+		if (!strcmp(q->hw_type,
+			hw_dio_tbl[i].hw_type)) {
+			q->hw_type_id = i;
+			return hw_dio_tbl[q->hw_type_id].open(q);
+		}
+	}
+	WD_ERR("No matching driver to use!\n");
+	errno = ENODEV;
+	return -ENODEV;
+}
+
+void drv_close(struct wd_queue *q)
+{
+	hw_dio_tbl[q->hw_type_id].close(q);
+}
+
+int drv_send(struct wd_queue *q, void *req)
+{
+	return hw_dio_tbl[q->hw_type_id].send(q, req);
+}
+
+int drv_recv(struct wd_queue *q, void **req)
+{
+	return hw_dio_tbl[q->hw_type_id].recv(q, req);
+}
+
+int drv_share(struct wd_queue *q, const void *addr, size_t size, int flags)
+{
+	return hw_dio_tbl[q->hw_type_id].share(q, addr, size, flags);
+}
+
+void drv_unshare(struct wd_queue *q, const void *addr, size_t size)
+{
+	hw_dio_tbl[q->hw_type_id].unshare(q, addr, size);
+}
+
+bool drv_can_do_mem_share(struct wd_queue *q)
+{
+	return hw_dio_tbl[q->hw_type_id].share != NULL;
+}
+
+void drv_flush(struct wd_queue *q)
+{
+	if (hw_dio_tbl[q->hw_type_id].flush)
+		hw_dio_tbl[q->hw_type_id].flush(q);
+}
diff --git a/samples/warpdrive/wd_adapter.h b/samples/warpdrive/wd_adapter.h
new file mode 100644
index 000000000000..bb3ab3ec112a
--- /dev/null
+++ b/samples/warpdrive/wd_adapter.h
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+/* the common drv header define the unified interface for wd */
+#ifndef __WD_ADAPTER_H__
+#define __WD_ADAPTER_H__
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+
+
+#include "wd.h"
+
+struct wd_drv_dio_if {
+	char *hw_type;
+	int (*open)(struct wd_queue *q);
+	void (*close)(struct wd_queue *q);
+	int (*set_pasid)(struct wd_queue *q);
+	int (*unset_pasid)(struct wd_queue *q);
+	int (*send)(struct wd_queue *q, void *req);
+	int (*recv)(struct wd_queue *q, void **req);
+	void (*flush)(struct wd_queue *q);
+	int (*share)(struct wd_queue *q, const void *addr,
+		size_t size, int flags);
+	int (*unshare)(struct wd_queue *q, const void *addr, size_t size);
+};
+
+extern int drv_open(struct wd_queue *q);
+extern void drv_close(struct wd_queue *q);
+extern int drv_send(struct wd_queue *q, void *req);
+extern int drv_recv(struct wd_queue *q, void **req);
+extern void drv_flush(struct wd_queue *q);
+extern int drv_share(struct wd_queue *q, const void *addr,
+	size_t size, int flags);
+extern void drv_unshare(struct wd_queue *q, const void *addr, size_t size);
+extern bool drv_can_do_mem_share(struct wd_queue *q);
+
+#endif
-- 
2.17.1
