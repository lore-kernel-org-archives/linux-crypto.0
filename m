Return-Path: <SRS0=oFif=NX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from lhrrgout.huawei.com ([185.176.76.210]:32735 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726161AbeKLUUu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Nov 2018 15:20:50 -0500
From: Roberto Sassu <roberto.sassu@huawei.com>
To: <dhowells@redhat.com>, <dwmw2@infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [RFC][PATCH 01/12] mpi: introduce mpi_key_length()
Date: Mon, 12 Nov 2018 11:24:12 +0100
Message-ID: <20181112102423.30415-2-roberto.sassu@huawei.com>
In-Reply-To: <20181112102423.30415-1-roberto.sassu@huawei.com>
References: <20181112102423.30415-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Introduce the new function to get the number of bits and bytes from an MPI.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 include/linux/mpi.h |  2 ++
 lib/mpi/mpicoder.c  | 33 ++++++++++++++++++++++++++-------
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/include/linux/mpi.h b/include/linux/mpi.h
index 7cd1473c64a4..56187bb57c78 100644
--- a/include/linux/mpi.h
+++ b/include/linux/mpi.h
@@ -61,6 +61,8 @@ int mpi_resize(MPI a, unsigned nlimbs);
 
 /*-- mpicoder.c --*/
 MPI mpi_read_raw_data(const void *xbuffer, size_t nbytes);
+int mpi_key_length(const void *xbuffer, unsigned int ret_nread,
+		   unsigned int *nbits_arg, unsigned int *nbytes_arg);
 MPI mpi_read_from_buffer(const void *buffer, unsigned *ret_nread);
 MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int len);
 void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign);
diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index eead4b339466..207cb3b91a51 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -78,22 +78,41 @@ MPI mpi_read_raw_data(const void *xbuffer, size_t nbytes)
 }
 EXPORT_SYMBOL_GPL(mpi_read_raw_data);
 
-MPI mpi_read_from_buffer(const void *xbuffer, unsigned *ret_nread)
+int mpi_key_length(const void *xbuffer, unsigned int ret_nread,
+		   unsigned int *nbits_arg, unsigned int *nbytes_arg)
 {
 	const uint8_t *buffer = xbuffer;
-	unsigned int nbits, nbytes;
-	MPI val;
+	unsigned int nbits;
 
-	if (*ret_nread < 2)
-		return ERR_PTR(-EINVAL);
+	if (ret_nread < 2)
+		return -EINVAL;
 	nbits = buffer[0] << 8 | buffer[1];
 
 	if (nbits > MAX_EXTERN_MPI_BITS) {
 		pr_info("MPI: mpi too large (%u bits)\n", nbits);
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 	}
 
-	nbytes = DIV_ROUND_UP(nbits, 8);
+	if (nbits_arg)
+		*nbits_arg = nbits;
+	if (nbytes_arg)
+		*nbytes_arg = DIV_ROUND_UP(nbits, 8);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpi_key_length);
+
+MPI mpi_read_from_buffer(const void *xbuffer, unsigned *ret_nread)
+{
+	const uint8_t *buffer = xbuffer;
+	unsigned int nbytes;
+	MPI val;
+	int ret;
+
+	ret = mpi_key_length(xbuffer, *ret_nread, NULL, &nbytes);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
 	if (nbytes + 2 > *ret_nread) {
 		pr_info("MPI: mpi larger than buffer nbytes=%u ret_nread=%u\n",
 				nbytes, *ret_nread);
-- 
2.17.1
