From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 03/10] lib: add software 842 compression/decompression
Date: Thu,  7 May 2015 13:49:14 -0400
Message-ID: <1431020961-22285-4-git-send-email-ddstreet@ieee.org>
References: <1431020961-22285-1-git-send-email-ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>,
	Robert Jennings <rob@pochix.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431020961-22285-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add 842-format software compression and decompression functions.
Update the MAINTAINERS 842 section to include the new files.

The 842 compression function can compress any input data into the 842
compression format.  The 842 decompression function can decompress any
standard-format 842 compressed data - specifically, either a compressed
data buffer created by the 842 software compression function, or a
compressed data buffer created by the 842 hardware compressor (located
in PowerPC coprocessors).

The 842 compressed data format is explained in the header comments.

This is used in a later patch to provide a full software 842 compression
and decompression crypto interface.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 MAINTAINERS              |   2 +
 include/linux/sw842.h    |  12 +
 lib/842/842.h            | 127 ++++++++++
 lib/842/842_compress.c   | 626 +++++++++++++++++++++++++++++++++++++++++++++++
 lib/842/842_debugfs.h    |  52 ++++
 lib/842/842_decompress.c | 405 ++++++++++++++++++++++++++++++
 lib/842/Makefile         |   2 +
 lib/Kconfig              |   6 +
 lib/Makefile             |   2 +
 9 files changed, 1234 insertions(+)
 create mode 100644 include/linux/sw842.h
 create mode 100644 lib/842/842.h
 create mode 100644 lib/842/842_compress.c
 create mode 100644 lib/842/842_debugfs.h
 create mode 100644 lib/842/842_decompress.c
 create mode 100644 lib/842/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index 781e099..116af01 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4872,6 +4872,8 @@ M:	Dan Streetman <ddstreet@us.ibm.com>
 S:	Supported
 F:	drivers/crypto/nx/nx-842.c
 F:	include/linux/nx842.h
+F:	include/linux/sw842.h
+F:	lib/842/
 
 IBM Power Linux RAID adapter
 M:	Brian King <brking@us.ibm.com>
diff --git a/include/linux/sw842.h b/include/linux/sw842.h
new file mode 100644
index 0000000..109ba04
--- /dev/null
+++ b/include/linux/sw842.h
@@ -0,0 +1,12 @@
+#ifndef __SW842_H__
+#define __SW842_H__
+
+#define SW842_MEM_COMPRESS	(0xf000)
+
+int sw842_compress(const u8 *src, unsigned int srclen,
+		   u8 *dst, unsigned int *destlen, void *wmem);
+
+int sw842_decompress(const u8 *src, unsigned int srclen,
+		     u8 *dst, unsigned int *destlen);
+
+#endif
diff --git a/lib/842/842.h b/lib/842/842.h
new file mode 100644
index 0000000..7c20003
--- /dev/null
+++ b/lib/842/842.h
@@ -0,0 +1,127 @@
+
+#ifndef __842_H__
+#define __842_H__
+
+/* The 842 compressed format is made up of multiple blocks, each of
+ * which have the format:
+ *
+ * <template>[arg1][arg2][arg3][arg4]
+ *
+ * where there are between 0 and 4 template args, depending on the specific
+ * template operation.  For normal operations, each arg is either a specific
+ * number of data bytes to add to the output buffer, or an index pointing
+ * to a previously-written number of data bytes to copy to the output buffer.
+ *
+ * The template code is a 5-bit value.  This code indicates what to do with
+ * the following data.  Template codes from 0 to 0x19 should use the template
+ * table, the static "decomp_ops" table used in decompress.  For each template
+ * (table row), there are between 1 and 4 actions; each action corresponds to
+ * an arg following the template code bits.  Each action is either a "data"
+ * type action, or a "index" type action, and each action results in 2, 4, or 8
+ * bytes being written to the output buffer.  Each template (i.e. all actions
+ * in the table row) will add up to 8 bytes being written to the output buffer.
+ * Any row with less than 4 actions is padded with noop actions, indicated by
+ * N0 (for which there is no corresponding arg in the compressed data buffer).
+ *
+ * "Data" actions, indicated in the table by D2, D4, and D8, mean that the
+ * corresponding arg is 2, 4, or 8 bytes, respectively, in the compressed data
+ * buffer should be copied directly to the output buffer.
+ *
+ * "Index" actions, indicated in the table by I2, I4, and I8, mean the
+ * corresponding arg is an index parameter that points to, respectively, a 2,
+ * 4, or 8 byte value already in the output buffer, that should be copied to
+ * the end of the output buffer.  Essentially, the index points to a position
+ * in a ring buffer that contains the last N bytes of output buffer data.
+ * The number of bits for each index's arg are: 8 bits for I2, 9 bits for I4,
+ * and 8 bits for I8.  Since each index points to a 2, 4, or 8 byte section,
+ * this means that I2 can reference 512 bytes ((2^8 bits = 256) * 2 bytes), I4
+ * can reference 2048 bytes ((2^9 = 512) * 4 bytes), and I8 can reference 2048
+ * bytes ((2^8 = 256) * 8 bytes).  Think of it as a kind-of ring buffer for
+ * each of I2, I4, and I8 that are updated for each byte written to the output
+ * buffer.  In this implementation, the output buffer is directly used for each
+ * index; there is no additional memory required.  Note that the index is into
+ * a ring buffer, not a sliding window; for example, if there have been 260
+ * bytes written to the output buffer, an I2 index of 0 would index to byte 256
+ * in the output buffer, while an I2 index of 16 would index to byte 16 in the
+ * output buffer.
+ *
+ * There are also 3 special template codes; 0x1b for "repeat", 0x1c for
+ * "zeros", and 0x1e for "end".  The "repeat" operation is followed by a 6 bit
+ * arg N indicating how many times to repeat.  The last 8 bytes written to the
+ * output buffer are written again to the output buffer, N + 1 times.  The
+ * "zeros" operation, which has no arg bits, writes 8 zeros to the output
+ * buffer.  The "end" operation, which also has no arg bits, signals the end
+ * of the compressed data.  There may be some number of padding (don't care,
+ * but usually 0) bits after the "end" operation bits, to fill the buffer
+ * length to a specific byte multiple (usually a multiple of 8, 16, or 32
+ * bytes).
+ *
+ * This software implementation also uses one of the undefined template values,
+ * 0x1d as a special "short data" template code, to represent less than 8 bytes
+ * of uncompressed data.  It is followed by a 3 bit arg N indicating how many
+ * data bytes will follow, and then N bytes of data, which should be copied to
+ * the output buffer.  This allows the software 842 compressor to accept input
+ * buffers that are not an exact multiple of 8 bytes long.  However, those
+ * compressed buffers containing this sw-only template will be rejected by
+ * the 842 hardware decompressor, and must be decompressed with this software
+ * library.  The 842 software compression module includes a parameter to
+ * disable using this sw-only "short data" template, and instead simply
+ * reject any input buffer that is not a multiple of 8 bytes long.
+ *
+ * After all actions for each operation code are processed, another template
+ * code is in the next 5 bits.  The decompression ends once the "end" template
+ * code is detected.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/bitops.h>
+#include <asm/unaligned.h>
+
+#include <linux/sw842.h>
+
+/* special templates */
+#define OP_REPEAT	(0x1B)
+#define OP_ZEROS	(0x1C)
+#define OP_END		(0x1E)
+
+/* sw only template - this is not in the hw design; it's used only by this
+ * software compressor and decompressor, to allow input buffers that aren't
+ * a multiple of 8.
+ */
+#define OP_SHORT_DATA	(0x1D)
+
+/* additional bits of each op param */
+#define OP_BITS		(5)
+#define REPEAT_BITS	(6)
+#define SHORT_DATA_BITS	(3)
+#define I2_BITS		(8)
+#define I4_BITS		(9)
+#define I8_BITS		(8)
+
+#define REPEAT_BITS_MAX		(0x3f)
+#define SHORT_DATA_BITS_MAX	(0x7)
+
+/* Arbitrary values used to indicate action */
+#define OP_ACTION	(0x70)
+#define OP_ACTION_INDEX	(0x10)
+#define OP_ACTION_DATA	(0x20)
+#define OP_ACTION_NOOP	(0x40)
+#define OP_AMOUNT	(0x0f)
+#define OP_AMOUNT_0	(0x00)
+#define OP_AMOUNT_2	(0x02)
+#define OP_AMOUNT_4	(0x04)
+#define OP_AMOUNT_8	(0x08)
+
+#define D2		(OP_ACTION_DATA  | OP_AMOUNT_2)
+#define D4		(OP_ACTION_DATA  | OP_AMOUNT_4)
+#define D8		(OP_ACTION_DATA  | OP_AMOUNT_8)
+#define I2		(OP_ACTION_INDEX | OP_AMOUNT_2)
+#define I4		(OP_ACTION_INDEX | OP_AMOUNT_4)
+#define I8		(OP_ACTION_INDEX | OP_AMOUNT_8)
+#define N0		(OP_ACTION_NOOP  | OP_AMOUNT_0)
+
+/* the max of the regular templates - not including the special templates */
+#define OPS_MAX		(0x1a)
+
+#endif
diff --git a/lib/842/842_compress.c b/lib/842/842_compress.c
new file mode 100644
index 0000000..7ce6894
--- /dev/null
+++ b/lib/842/842_compress.c
@@ -0,0 +1,626 @@
+/*
+ * 842 Software Compression
+ *
+ * Copyright (C) 2015 Dan Streetman, IBM Corp
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * See 842.h for details of the 842 compressed format.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#define MODULE_NAME "842_compress"
+
+#include <linux/hashtable.h>
+
+#include "842.h"
+#include "842_debugfs.h"
+
+#define SW842_HASHTABLE8_BITS	(10)
+#define SW842_HASHTABLE4_BITS	(11)
+#define SW842_HASHTABLE2_BITS	(10)
+
+/* By default, we allow compressing input buffers of any length, but we must
+ * use the non-standard "short data" template so the decompressor can correctly
+ * reproduce the uncompressed data buffer at the right length.  However the
+ * hardware 842 compressor will not recognize the "short data" template, and
+ * will fail to decompress any compressed buffer containing it (I have no idea
+ * why anyone would want to use software to compress and hardware to decompress
+ * but that's beside the point).  This parameter forces the compression
+ * function to simply reject any input buffer that isn't a multiple of 8 bytes
+ * long, instead of using the "short data" template, so that all compressed
+ * buffers produced by this function will be decompressable by the 842 hardware
+ * decompressor.  Unless you have a specific need for that, leave this disabled
+ * so that any length buffer can be compressed.
+ */
+static bool sw842_strict;
+module_param_named(strict, sw842_strict, bool, 0644);
+
+static u8 comp_ops[OPS_MAX][5] = { /* params size in bits */
+	{ I8, N0, N0, N0, 0x19 }, /* 8 */
+	{ I4, I4, N0, N0, 0x18 }, /* 18 */
+	{ I4, I2, I2, N0, 0x17 }, /* 25 */
+	{ I2, I2, I4, N0, 0x13 }, /* 25 */
+	{ I2, I2, I2, I2, 0x12 }, /* 32 */
+	{ I4, I2, D2, N0, 0x16 }, /* 33 */
+	{ I4, D2, I2, N0, 0x15 }, /* 33 */
+	{ I2, D2, I4, N0, 0x0e }, /* 33 */
+	{ D2, I2, I4, N0, 0x09 }, /* 33 */
+	{ I2, I2, I2, D2, 0x11 }, /* 40 */
+	{ I2, I2, D2, I2, 0x10 }, /* 40 */
+	{ I2, D2, I2, I2, 0x0d }, /* 40 */
+	{ D2, I2, I2, I2, 0x08 }, /* 40 */
+	{ I4, D4, N0, N0, 0x14 }, /* 41 */
+	{ D4, I4, N0, N0, 0x04 }, /* 41 */
+	{ I2, I2, D4, N0, 0x0f }, /* 48 */
+	{ I2, D2, I2, D2, 0x0c }, /* 48 */
+	{ I2, D4, I2, N0, 0x0b }, /* 48 */
+	{ D2, I2, I2, D2, 0x07 }, /* 48 */
+	{ D2, I2, D2, I2, 0x06 }, /* 48 */
+	{ D4, I2, I2, N0, 0x03 }, /* 48 */
+	{ I2, D2, D4, N0, 0x0a }, /* 56 */
+	{ D2, I2, D4, N0, 0x05 }, /* 56 */
+	{ D4, I2, D2, N0, 0x02 }, /* 56 */
+	{ D4, D2, I2, N0, 0x01 }, /* 56 */
+	{ D8, N0, N0, N0, 0x00 }, /* 64 */
+};
+
+struct sw842_hlist_node8 {
+	struct hlist_node node;
+	u64 data;
+	u8 index;
+};
+
+struct sw842_hlist_node4 {
+	struct hlist_node node;
+	u32 data;
+	u16 index;
+};
+
+struct sw842_hlist_node2 {
+	struct hlist_node node;
+	u16 data;
+	u8 index;
+};
+
+#define INDEX_NOT_FOUND		(-1)
+#define INDEX_NOT_CHECKED	(-2)
+
+struct sw842_param {
+	u8 *in;
+	u8 *instart;
+	u64 ilen;
+	u8 *out;
+	u64 olen;
+	u8 bit;
+	u64 data8[1];
+	u32 data4[2];
+	u16 data2[4];
+	int index8[1];
+	int index4[2];
+	int index2[4];
+	DECLARE_HASHTABLE(htable8, SW842_HASHTABLE8_BITS);
+	DECLARE_HASHTABLE(htable4, SW842_HASHTABLE4_BITS);
+	DECLARE_HASHTABLE(htable2, SW842_HASHTABLE2_BITS);
+	struct sw842_hlist_node8 node8[1 << I8_BITS];
+	struct sw842_hlist_node4 node4[1 << I4_BITS];
+	struct sw842_hlist_node2 node2[1 << I2_BITS];
+};
+
+#define get_input_data(p, o, b)						\
+	be##b##_to_cpu(get_unaligned((__be##b *)((p)->in + (o))))
+
+#define init_hashtable_nodes(p, b)	do {			\
+	int _i;							\
+	hash_init((p)->htable##b);				\
+	for (_i = 0; _i < ARRAY_SIZE((p)->node##b); _i++) {	\
+		(p)->node##b[_i].index = _i;			\
+		(p)->node##b[_i].data = 0;			\
+		INIT_HLIST_NODE(&(p)->node##b[_i].node);	\
+	}							\
+} while (0)
+
+#define find_index(p, b, n)	({					\
+	struct sw842_hlist_node##b *_n;					\
+	p->index##b[n] = INDEX_NOT_FOUND;				\
+	hash_for_each_possible(p->htable##b, _n, node, p->data##b[n]) {	\
+		if (p->data##b[n] == _n->data) {			\
+			p->index##b[n] = _n->index;			\
+			break;						\
+		}							\
+	}								\
+	p->index##b[n] >= 0;						\
+})
+
+#define check_index(p, b, n)			\
+	((p)->index##b[n] == INDEX_NOT_CHECKED	\
+	 ? find_index(p, b, n)			\
+	 : (p)->index##b[n] >= 0)
+
+#define replace_hash(p, b, i, d)	do {				\
+	struct sw842_hlist_node##b *_n = &(p)->node##b[(i)+(d)];	\
+	hash_del(&_n->node);						\
+	_n->data = (p)->data##b[d];					\
+	pr_debug("add hash index%x %x pos %x data %lx\n", b,		\
+		 (unsigned int)_n->index,				\
+		 (unsigned int)((p)->in - (p)->instart),		\
+		 (unsigned long)_n->data);				\
+	hash_add((p)->htable##b, &_n->node, _n->data);			\
+} while (0)
+
+static u8 bmask[8] = { 0x00, 0x80, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc, 0xfe };
+
+static int add_bits(struct sw842_param *p, u64 d, u8 n);
+
+static int __split_add_bits(struct sw842_param *p, u64 d, u8 n, u8 s)
+{
+	int ret;
+
+	if (n <= s)
+		return -EINVAL;
+
+	ret = add_bits(p, d >> s, n - s);
+	if (ret)
+		return ret;
+	return add_bits(p, d & GENMASK_ULL(s - 1, 0), s);
+}
+
+static int add_bits(struct sw842_param *p, u64 d, u8 n)
+{
+	int b = p->bit, bits = b + n, s = round_up(bits, 8) - bits;
+	u64 o;
+	u8 *out = p->out;
+
+	pr_debug("add %u bits %lx\n", (unsigned char)n, (unsigned long)d);
+
+	if (n > 64)
+		return -EINVAL;
+
+	/* split this up if writing to > 8 bytes (i.e. n == 64 && p->bit > 0),
+	 * or if we're at the end of the output buffer and would write past end
+	 */
+	if (bits > 64)
+		return __split_add_bits(p, d, n, 32);
+	else if (p->olen < 8 && bits > 32 && bits <= 56)
+		return __split_add_bits(p, d, n, 16);
+	else if (p->olen < 4 && bits > 16 && bits <= 24)
+		return __split_add_bits(p, d, n, 8);
+
+	if (DIV_ROUND_UP(bits, 8) > p->olen)
+		return -ENOSPC;
+
+	o = *out & bmask[b];
+	d <<= s;
+
+	if (bits <= 8)
+		*out = o | d;
+	else if (bits <= 16)
+		put_unaligned(cpu_to_be16(o << 8 | d), (__be16 *)out);
+	else if (bits <= 24)
+		put_unaligned(cpu_to_be32(o << 24 | d << 8), (__be32 *)out);
+	else if (bits <= 32)
+		put_unaligned(cpu_to_be32(o << 24 | d), (__be32 *)out);
+	else if (bits <= 40)
+		put_unaligned(cpu_to_be64(o << 56 | d << 24), (__be64 *)out);
+	else if (bits <= 48)
+		put_unaligned(cpu_to_be64(o << 56 | d << 16), (__be64 *)out);
+	else if (bits <= 56)
+		put_unaligned(cpu_to_be64(o << 56 | d << 8), (__be64 *)out);
+	else
+		put_unaligned(cpu_to_be64(o << 56 | d), (__be64 *)out);
+
+	p->bit += n;
+
+	if (p->bit > 7) {
+		p->out += p->bit / 8;
+		p->olen -= p->bit / 8;
+		p->bit %= 8;
+	}
+
+	return 0;
+}
+
+static int add_template(struct sw842_param *p, u8 c)
+{
+	int ret, i, b = 0;
+	u8 *t = comp_ops[c];
+	bool inv = false;
+
+	if (c >= OPS_MAX)
+		return -EINVAL;
+
+	pr_debug("template %x\n", t[4]);
+
+	ret = add_bits(p, t[4], OP_BITS);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < 4; i++) {
+		pr_debug("op %x\n", t[i]);
+
+		switch (t[i] & OP_AMOUNT) {
+		case OP_AMOUNT_8:
+			if (b)
+				inv = true;
+			else if (t[i] & OP_ACTION_INDEX)
+				ret = add_bits(p, p->index8[0], I8_BITS);
+			else if (t[i] & OP_ACTION_DATA)
+				ret = add_bits(p, p->data8[0], 64);
+			else
+				inv = true;
+			break;
+		case OP_AMOUNT_4:
+			if (b == 2 && t[i] & OP_ACTION_DATA)
+				ret = add_bits(p, get_input_data(p, 2, 32), 32);
+			else if (b != 0 && b != 4)
+				inv = true;
+			else if (t[i] & OP_ACTION_INDEX)
+				ret = add_bits(p, p->index4[b >> 2], I4_BITS);
+			else if (t[i] & OP_ACTION_DATA)
+				ret = add_bits(p, p->data4[b >> 2], 32);
+			else
+				inv = true;
+			break;
+		case OP_AMOUNT_2:
+			if (b != 0 && b != 2 && b != 4 && b != 6)
+				inv = true;
+			if (t[i] & OP_ACTION_INDEX)
+				ret = add_bits(p, p->index2[b >> 1], I2_BITS);
+			else if (t[i] & OP_ACTION_DATA)
+				ret = add_bits(p, p->data2[b >> 1], 16);
+			else
+				inv = true;
+			break;
+		case OP_AMOUNT_0:
+			inv = (b != 8) || !(t[i] & OP_ACTION_NOOP);
+			break;
+		default:
+			inv = true;
+			break;
+		}
+
+		if (ret)
+			return ret;
+
+		if (inv) {
+			pr_err("Invalid templ %x op %d : %x %x %x %x\n",
+			       c, i, t[0], t[1], t[2], t[3]);
+			return -EINVAL;
+		}
+
+		b += t[i] & OP_AMOUNT;
+	}
+
+	if (b != 8) {
+		pr_err("Invalid template %x len %x : %x %x %x %x\n",
+		       c, b, t[0], t[1], t[2], t[3]);
+		return -EINVAL;
+	}
+
+	if (sw842_template_counts)
+		atomic_inc(&template_count[t[4]]);
+
+	return 0;
+}
+
+static int add_repeat_template(struct sw842_param *p, u8 r)
+{
+	int ret;
+
+	/* repeat param is 0-based */
+	if (!r || --r > REPEAT_BITS_MAX)
+		return -EINVAL;
+
+	ret = add_bits(p, OP_REPEAT, OP_BITS);
+	if (ret)
+		return ret;
+
+	ret = add_bits(p, r, REPEAT_BITS);
+	if (ret)
+		return ret;
+
+	if (sw842_template_counts)
+		atomic_inc(&template_repeat_count);
+
+	return 0;
+}
+
+static int add_short_data_template(struct sw842_param *p, u8 b)
+{
+	int ret, i;
+
+	if (!b || b > SHORT_DATA_BITS_MAX)
+		return -EINVAL;
+
+	ret = add_bits(p, OP_SHORT_DATA, OP_BITS);
+	if (ret)
+		return ret;
+
+	ret = add_bits(p, b, SHORT_DATA_BITS);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < b; i++) {
+		ret = add_bits(p, p->in[i], 8);
+		if (ret)
+			return ret;
+	}
+
+	if (sw842_template_counts)
+		atomic_inc(&template_short_data_count);
+
+	return 0;
+}
+
+static int add_zeros_template(struct sw842_param *p)
+{
+	int ret = add_bits(p, OP_ZEROS, OP_BITS);
+
+	if (ret)
+		return ret;
+
+	if (sw842_template_counts)
+		atomic_inc(&template_zeros_count);
+
+	return 0;
+}
+
+static int add_end_template(struct sw842_param *p)
+{
+	int ret = add_bits(p, OP_END, OP_BITS);
+
+	if (ret)
+		return ret;
+
+	if (sw842_template_counts)
+		atomic_inc(&template_end_count);
+
+	return 0;
+}
+
+static bool check_template(struct sw842_param *p, u8 c)
+{
+	u8 *t = comp_ops[c];
+	int i, match, b = 0;
+
+	if (c >= OPS_MAX)
+		return false;
+
+	for (i = 0; i < 4; i++) {
+		if (t[i] & OP_ACTION_INDEX) {
+			if (t[i] & OP_AMOUNT_2)
+				match = check_index(p, 2, b >> 1);
+			else if (t[i] & OP_AMOUNT_4)
+				match = check_index(p, 4, b >> 2);
+			else if (t[i] & OP_AMOUNT_8)
+				match = check_index(p, 8, 0);
+			else
+				return false;
+			if (!match)
+				return false;
+		}
+
+		b += t[i] & OP_AMOUNT;
+	}
+
+	return true;
+}
+
+static void get_next_data(struct sw842_param *p)
+{
+	p->data8[0] = get_input_data(p, 0, 64);
+	p->data4[0] = get_input_data(p, 0, 32);
+	p->data4[1] = get_input_data(p, 4, 32);
+	p->data2[0] = get_input_data(p, 0, 16);
+	p->data2[1] = get_input_data(p, 2, 16);
+	p->data2[2] = get_input_data(p, 4, 16);
+	p->data2[3] = get_input_data(p, 6, 16);
+}
+
+/* update the hashtable entries.
+ * only call this after finding/adding the current template
+ * the dataN fields for the current 8 byte block must be already updated
+ */
+static void update_hashtables(struct sw842_param *p)
+{
+	u64 pos = p->in - p->instart;
+	u64 n8 = (pos >> 3) % (1 << I8_BITS);
+	u64 n4 = (pos >> 2) % (1 << I4_BITS);
+	u64 n2 = (pos >> 1) % (1 << I2_BITS);
+
+	replace_hash(p, 8, n8, 0);
+	replace_hash(p, 4, n4, 0);
+	replace_hash(p, 4, n4, 1);
+	replace_hash(p, 2, n2, 0);
+	replace_hash(p, 2, n2, 1);
+	replace_hash(p, 2, n2, 2);
+	replace_hash(p, 2, n2, 3);
+}
+
+/* find the next template to use, and add it
+ * the p->dataN fields must already be set for the current 8 byte block
+ */
+static int process_next(struct sw842_param *p)
+{
+	int ret, i;
+
+	p->index8[0] = INDEX_NOT_CHECKED;
+	p->index4[0] = INDEX_NOT_CHECKED;
+	p->index4[1] = INDEX_NOT_CHECKED;
+	p->index2[0] = INDEX_NOT_CHECKED;
+	p->index2[1] = INDEX_NOT_CHECKED;
+	p->index2[2] = INDEX_NOT_CHECKED;
+	p->index2[3] = INDEX_NOT_CHECKED;
+
+	/* check up to OPS_MAX - 1; last op is our fallback */
+	for (i = 0; i < OPS_MAX - 1; i++) {
+		if (check_template(p, i))
+			break;
+	}
+
+	ret = add_template(p, i);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+/**
+ * sw842_compress
+ *
+ * Compress the uncompressed buffer of length @ilen at @in to the output buffer
+ * @out, using no more than @olen bytes, using the 842 compression format.
+ *
+ * Returns: 0 on success, error on failure.  The @olen parameter
+ * will contain the number of output bytes written on success, or
+ * 0 on error.
+ */
+int sw842_compress(const u8 *in, unsigned int ilen,
+		   u8 *out, unsigned int *olen, void *wmem)
+{
+	struct sw842_param *p = (struct sw842_param *)wmem;
+	int ret;
+	u64 last, next, pad, total;
+	u8 repeat_count = 0;
+
+	BUILD_BUG_ON(sizeof(*p) > SW842_MEM_COMPRESS);
+
+	init_hashtable_nodes(p, 8);
+	init_hashtable_nodes(p, 4);
+	init_hashtable_nodes(p, 2);
+
+	p->in = (u8 *)in;
+	p->instart = p->in;
+	p->ilen = ilen;
+	p->out = out;
+	p->olen = *olen;
+	p->bit = 0;
+
+	total = p->olen;
+
+	*olen = 0;
+
+	/* if using strict mode, we can only compress a multiple of 8 */
+	if (sw842_strict && (ilen % 8)) {
+		pr_err("Using strict mode, can't compress len %d\n", ilen);
+		return -EINVAL;
+	}
+
+	/* let's compress at least 8 bytes, mkay? */
+	if (unlikely(ilen < 8))
+		goto skip_comp;
+
+	/* make initial 'last' different so we don't match the first time */
+	last = ~get_unaligned((u64 *)p->in);
+
+	while (p->ilen > 7) {
+		next = get_unaligned((u64 *)p->in);
+
+		/* must get the next data, as we need to update the hashtable
+		 * entries with the new data every time
+		 */
+		get_next_data(p);
+
+		/* we don't care about endianness in last or next;
+		 * we're just comparing 8 bytes to another 8 bytes,
+		 * they're both the same endianness
+		 */
+		if (next == last) {
+			/* repeat count bits are 0-based, so we stop at +1 */
+			if (++repeat_count <= REPEAT_BITS_MAX)
+				goto repeat;
+		}
+		if (repeat_count) {
+			ret = add_repeat_template(p, repeat_count);
+			repeat_count = 0;
+			if (next == last) /* reached max repeat bits */
+				goto repeat;
+		}
+
+		if (next == 0)
+			ret = add_zeros_template(p);
+		else
+			ret = process_next(p);
+
+		if (ret)
+			return ret;
+
+repeat:
+		last = next;
+		update_hashtables(p);
+		p->in += 8;
+		p->ilen -= 8;
+	}
+
+	if (repeat_count) {
+		ret = add_repeat_template(p, repeat_count);
+		if (ret)
+			return ret;
+	}
+
+skip_comp:
+	if (p->ilen > 0) {
+		ret = add_short_data_template(p, p->ilen);
+		if (ret)
+			return ret;
+
+		p->in += p->ilen;
+		p->ilen = 0;
+	}
+
+	ret = add_end_template(p);
+	if (ret)
+		return ret;
+
+	if (p->bit) {
+		p->out++;
+		p->olen--;
+		p->bit = 0;
+	}
+
+	/* pad compressed length to multiple of 8 */
+	pad = (8 - ((total - p->olen) % 8)) % 8;
+	if (pad) {
+		if (pad > p->olen) /* we were so close! */
+			return -ENOSPC;
+		memset(p->out, 0, pad);
+		p->out += pad;
+		p->olen -= pad;
+	}
+
+	if (unlikely((total - p->olen) > UINT_MAX))
+		return -ENOSPC;
+
+	*olen = total - p->olen;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sw842_compress);
+
+static int __init sw842_init(void)
+{
+	if (sw842_template_counts)
+		sw842_debugfs_create();
+
+	return 0;
+}
+module_init(sw842_init);
+
+static void __exit sw842_exit(void)
+{
+	if (sw842_template_counts)
+		sw842_debugfs_remove();
+}
+module_exit(sw842_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Software 842 Compressor");
+MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
diff --git a/lib/842/842_debugfs.h b/lib/842/842_debugfs.h
new file mode 100644
index 0000000..e7f3bff
--- /dev/null
+++ b/lib/842/842_debugfs.h
@@ -0,0 +1,52 @@
+
+#ifndef __842_DEBUGFS_H__
+#define __842_DEBUGFS_H__
+
+#include <linux/debugfs.h>
+
+static bool sw842_template_counts;
+module_param_named(template_counts, sw842_template_counts, bool, 0444);
+
+static atomic_t template_count[OPS_MAX], template_repeat_count,
+	template_zeros_count, template_short_data_count, template_end_count;
+
+static struct dentry *sw842_debugfs_root;
+
+static int __init sw842_debugfs_create(void)
+{
+	umode_t m = S_IRUGO | S_IWUSR;
+	int i;
+
+	if (!debugfs_initialized())
+		return -ENODEV;
+
+	sw842_debugfs_root = debugfs_create_dir(MODULE_NAME, NULL);
+	if (IS_ERR(sw842_debugfs_root))
+		return PTR_ERR(sw842_debugfs_root);
+
+	for (i = 0; i < ARRAY_SIZE(template_count); i++) {
+		char name[32];
+
+		snprintf(name, 32, "template_%02x", i);
+		debugfs_create_atomic_t(name, m, sw842_debugfs_root,
+					&template_count[i]);
+	}
+	debugfs_create_atomic_t("template_repeat", m, sw842_debugfs_root,
+				&template_repeat_count);
+	debugfs_create_atomic_t("template_zeros", m, sw842_debugfs_root,
+				&template_zeros_count);
+	debugfs_create_atomic_t("template_short_data", m, sw842_debugfs_root,
+				&template_short_data_count);
+	debugfs_create_atomic_t("template_end", m, sw842_debugfs_root,
+				&template_end_count);
+
+	return 0;
+}
+
+static void __exit sw842_debugfs_remove(void)
+{
+	if (sw842_debugfs_root && !IS_ERR(sw842_debugfs_root))
+		debugfs_remove_recursive(sw842_debugfs_root);
+}
+
+#endif
diff --git a/lib/842/842_decompress.c b/lib/842/842_decompress.c
new file mode 100644
index 0000000..6b2b45a
--- /dev/null
+++ b/lib/842/842_decompress.c
@@ -0,0 +1,405 @@
+/*
+ * 842 Software Decompression
+ *
+ * Copyright (C) 2015 Dan Streetman, IBM Corp
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * See 842.h for details of the 842 compressed format.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#define MODULE_NAME "842_decompress"
+
+#include "842.h"
+#include "842_debugfs.h"
+
+/* rolling fifo sizes */
+#define I2_FIFO_SIZE	(2 * (1 << I2_BITS))
+#define I4_FIFO_SIZE	(4 * (1 << I4_BITS))
+#define I8_FIFO_SIZE	(8 * (1 << I8_BITS))
+
+static u8 decomp_ops[OPS_MAX][4] = {
+	{ D8, N0, N0, N0 },
+	{ D4, D2, I2, N0 },
+	{ D4, I2, D2, N0 },
+	{ D4, I2, I2, N0 },
+	{ D4, I4, N0, N0 },
+	{ D2, I2, D4, N0 },
+	{ D2, I2, D2, I2 },
+	{ D2, I2, I2, D2 },
+	{ D2, I2, I2, I2 },
+	{ D2, I2, I4, N0 },
+	{ I2, D2, D4, N0 },
+	{ I2, D4, I2, N0 },
+	{ I2, D2, I2, D2 },
+	{ I2, D2, I2, I2 },
+	{ I2, D2, I4, N0 },
+	{ I2, I2, D4, N0 },
+	{ I2, I2, D2, I2 },
+	{ I2, I2, I2, D2 },
+	{ I2, I2, I2, I2 },
+	{ I2, I2, I4, N0 },
+	{ I4, D4, N0, N0 },
+	{ I4, D2, I2, N0 },
+	{ I4, I2, D2, N0 },
+	{ I4, I2, I2, N0 },
+	{ I4, I4, N0, N0 },
+	{ I8, N0, N0, N0 }
+};
+
+struct sw842_param {
+	u8 *in;
+	u8 bit;
+	u64 ilen;
+	u8 *out;
+	u8 *ostart;
+	u64 olen;
+};
+
+#define beN_to_cpu(d, s)					\
+	((s) == 2 ? be16_to_cpu(get_unaligned((__be16 *)d)) :	\
+	 (s) == 4 ? be32_to_cpu(get_unaligned((__be32 *)d)) :	\
+	 (s) == 8 ? be64_to_cpu(get_unaligned((__be64 *)d)) :	\
+	 WARN(1, "pr_debug param err invalid size %x\n", s))
+
+static int next_bits(struct sw842_param *p, u64 *d, u8 n);
+
+static int __split_next_bits(struct sw842_param *p, u64 *d, u8 n, u8 s)
+{
+	u64 tmp = 0;
+	int ret;
+
+	if (n <= s) {
+		pr_debug("split_next_bits invalid n %u s %u\n", n, s);
+		return -EINVAL;
+	}
+
+	ret = next_bits(p, &tmp, n - s);
+	if (ret)
+		return ret;
+	ret = next_bits(p, d, s);
+	if (ret)
+		return ret;
+	*d |= tmp << s;
+	return 0;
+}
+
+static int next_bits(struct sw842_param *p, u64 *d, u8 n)
+{
+	u8 *in = p->in, b = p->bit, bits = b + n;
+
+	if (n > 64) {
+		pr_debug("next_bits invalid n %u\n", n);
+		return -EINVAL;
+	}
+
+	/* split this up if reading > 8 bytes, or if we're at the end of
+	 * the input buffer and would read past the end
+	 */
+	if (bits > 64)
+		return __split_next_bits(p, d, n, 32);
+	else if (p->ilen < 8 && bits > 32 && bits <= 56)
+		return __split_next_bits(p, d, n, 16);
+	else if (p->ilen < 4 && bits > 16 && bits <= 24)
+		return __split_next_bits(p, d, n, 8);
+
+	if (DIV_ROUND_UP(bits, 8) > p->ilen)
+		return -EOVERFLOW;
+
+	if (bits <= 8)
+		*d = *in >> (8 - bits);
+	else if (bits <= 16)
+		*d = be16_to_cpu(get_unaligned((__be16 *)in)) >> (16 - bits);
+	else if (bits <= 32)
+		*d = be32_to_cpu(get_unaligned((__be32 *)in)) >> (32 - bits);
+	else
+		*d = be64_to_cpu(get_unaligned((__be64 *)in)) >> (64 - bits);
+
+	*d &= GENMASK_ULL(n - 1, 0);
+
+	p->bit += n;
+
+	if (p->bit > 7) {
+		p->in += p->bit / 8;
+		p->ilen -= p->bit / 8;
+		p->bit %= 8;
+	}
+
+	return 0;
+}
+
+static int do_data(struct sw842_param *p, u8 n)
+{
+	u64 v;
+	int ret;
+
+	if (n > p->olen)
+		return -ENOSPC;
+
+	ret = next_bits(p, &v, n * 8);
+	if (ret)
+		return ret;
+
+	switch (n) {
+	case 2:
+		put_unaligned(cpu_to_be16((u16)v), (__be16 *)p->out);
+		break;
+	case 4:
+		put_unaligned(cpu_to_be32((u32)v), (__be32 *)p->out);
+		break;
+	case 8:
+		put_unaligned(cpu_to_be64((u64)v), (__be64 *)p->out);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	p->out += n;
+	p->olen -= n;
+
+	return 0;
+}
+
+static int __do_index(struct sw842_param *p, u8 size, u8 bits, u64 fsize)
+{
+	u64 index, offset, total = round_down(p->out - p->ostart, 8);
+	int ret;
+
+	ret = next_bits(p, &index, bits);
+	if (ret)
+		return ret;
+
+	offset = index * size;
+
+	/* a ring buffer of fsize is used; correct the offset */
+	if (total > fsize) {
+		/* this is where the current fifo is */
+		u64 section = round_down(total, fsize);
+		/* the current pos in the fifo */
+		u64 pos = total % fsize;
+
+		/* if the offset is past/at the pos, we need to
+		 * go back to the last fifo section
+		 */
+		if (offset >= pos)
+			section -= fsize;
+
+		offset += section;
+	}
+
+	if (offset + size > total) {
+		pr_debug("index%x %lx points past end %lx\n", size,
+			 (unsigned long)offset, (unsigned long)total);
+		return -EINVAL;
+	}
+
+	pr_debug("index%x to %lx off %lx adjoff %lx tot %lx data %lx\n",
+		 size, (unsigned long)index, (unsigned long)(index * size),
+		 (unsigned long)offset, (unsigned long)total,
+		 (unsigned long)beN_to_cpu(&p->ostart[offset], size));
+
+	memcpy(p->out, &p->ostart[offset], size);
+	p->out += size;
+	p->olen -= size;
+
+	return 0;
+}
+
+int do_index(struct sw842_param *p, u8 n)
+{
+	switch (n) {
+	case 2:
+		return __do_index(p, 2, I2_BITS, I2_FIFO_SIZE);
+	case 4:
+		return __do_index(p, 4, I4_BITS, I4_FIFO_SIZE);
+	case 8:
+		return __do_index(p, 8, I8_BITS, I8_FIFO_SIZE);
+	default:
+		return -EINVAL;
+	}
+}
+
+int do_op(struct sw842_param *p, u8 o)
+{
+	int i, ret = 0;
+
+	if (o >= OPS_MAX)
+		return -EINVAL;
+
+	for (i = 0; i < 4; i++) {
+		u8 op = decomp_ops[o][i];
+
+		pr_debug("op is %x\n", op);
+
+		switch (op & OP_ACTION) {
+		case OP_ACTION_DATA:
+			ret = do_data(p, op & OP_AMOUNT);
+			break;
+		case OP_ACTION_INDEX:
+			ret = do_index(p, op & OP_AMOUNT);
+			break;
+		case OP_ACTION_NOOP:
+			break;
+		default:
+			pr_err("Interal error, invalid op %x\n", op);
+			return -EINVAL;
+		}
+
+		if (ret)
+			return ret;
+	}
+
+	if (sw842_template_counts)
+		atomic_inc(&template_count[o]);
+
+	return 0;
+}
+
+/**
+ * sw842_decompress
+ *
+ * Decompress the 842-compressed buffer of length @ilen at @in
+ * to the output buffer @out, using no more than @olen bytes.
+ *
+ * The compressed buffer must be only a single 842-compressed buffer,
+ * with the standard format described in the comments in 842.h
+ * Processing will stop when the 842 "END" template is detected,
+ * not the end of the buffer.
+ *
+ * Returns: 0 on success, error on failure.  The @olen parameter
+ * will contain the number of output bytes written on success, or
+ * 0 on error.
+ */
+int sw842_decompress(const u8 *in, unsigned int ilen,
+		     u8 *out, unsigned int *olen)
+{
+	struct sw842_param p;
+	int ret;
+	u64 op, rep, tmp, bytes, total;
+
+	p.in = (u8 *)in;
+	p.bit = 0;
+	p.ilen = ilen;
+	p.out = out;
+	p.ostart = out;
+	p.olen = *olen;
+
+	total = p.olen;
+
+	*olen = 0;
+
+	do {
+		ret = next_bits(&p, &op, OP_BITS);
+		if (ret)
+			return ret;
+
+		pr_debug("template is %lx\n", (unsigned long)op);
+
+		switch (op) {
+		case OP_REPEAT:
+			ret = next_bits(&p, &rep, REPEAT_BITS);
+			if (ret)
+				return ret;
+
+			if (p.out == out) /* no previous bytes */
+				return -EINVAL;
+
+			/* copy rep + 1 */
+			rep++;
+
+			if (rep * 8 > p.olen)
+				return -ENOSPC;
+
+			while (rep-- > 0) {
+				memcpy(p.out, p.out - 8, 8);
+				p.out += 8;
+				p.olen -= 8;
+			}
+
+			if (sw842_template_counts)
+				atomic_inc(&template_repeat_count);
+
+			break;
+		case OP_ZEROS:
+			if (8 > p.olen)
+				return -ENOSPC;
+
+			memset(p.out, 0, 8);
+			p.out += 8;
+			p.olen -= 8;
+
+			if (sw842_template_counts)
+				atomic_inc(&template_zeros_count);
+
+			break;
+		case OP_SHORT_DATA:
+			ret = next_bits(&p, &bytes, SHORT_DATA_BITS);
+			if (ret)
+				return ret;
+
+			if (!bytes || bytes > SHORT_DATA_BITS_MAX)
+				return -EINVAL;
+
+			while (bytes-- > 0) {
+				ret = next_bits(&p, &tmp, 8);
+				if (ret)
+					return ret;
+				*p.out = (u8)tmp;
+				p.out++;
+				p.olen--;
+			}
+
+			if (sw842_template_counts)
+				atomic_inc(&template_short_data_count);
+
+			break;
+		case OP_END:
+			if (sw842_template_counts)
+				atomic_inc(&template_end_count);
+
+			break;
+		default: /* use template */
+			ret = do_op(&p, op);
+			if (ret)
+				return ret;
+			break;
+		}
+	} while (op != OP_END);
+
+	if (unlikely((total - p.olen) > UINT_MAX))
+		return -ENOSPC;
+
+	*olen = total - p.olen;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sw842_decompress);
+
+static int __init sw842_init(void)
+{
+	if (sw842_template_counts)
+		sw842_debugfs_create();
+
+	return 0;
+}
+module_init(sw842_init);
+
+static void __exit sw842_exit(void)
+{
+	if (sw842_template_counts)
+		sw842_debugfs_remove();
+}
+module_exit(sw842_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Software 842 Decompressor");
+MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
diff --git a/lib/842/Makefile b/lib/842/Makefile
new file mode 100644
index 0000000..5d24c0b
--- /dev/null
+++ b/lib/842/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_842_COMPRESS) += 842_compress.o
+obj-$(CONFIG_842_DECOMPRESS) += 842_decompress.o
diff --git a/lib/Kconfig b/lib/Kconfig
index 601965a..34e332b 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -212,6 +212,12 @@ config RANDOM32_SELFTEST
 #
 # compression support is select'ed if needed
 #
+config 842_COMPRESS
+	tristate
+
+config 842_DECOMPRESS
+	tristate
+
 config ZLIB_INFLATE
 	tristate
 
diff --git a/lib/Makefile b/lib/Makefile
index 6c37933..ff37c8c 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -78,6 +78,8 @@ obj-$(CONFIG_LIBCRC32C)	+= libcrc32c.o
 obj-$(CONFIG_CRC8)	+= crc8.o
 obj-$(CONFIG_GENERIC_ALLOCATOR) += genalloc.o
 
+obj-$(CONFIG_842_COMPRESS) += 842/
+obj-$(CONFIG_842_DECOMPRESS) += 842/
 obj-$(CONFIG_ZLIB_INFLATE) += zlib_inflate/
 obj-$(CONFIG_ZLIB_DEFLATE) += zlib_deflate/
 obj-$(CONFIG_REED_SOLOMON) += reed_solomon/
-- 
2.1.0
