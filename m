From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 4/8] s390: replace zfcp_qdio_sbale_count by sg_nents
Date: Fri, 18 Sep 2015 14:57:12 +0200
Message-ID: <1442581036-23789-5-git-send-email-clabbe.montjoie@gmail.com>
References: <1442581036-23789-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-s390@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	heiko.carstens@de.ibm.com, maier@linux.vnet.ibm.com,
	schwidefsky@de.ibm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442581036-23789-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The zfcp_qdio_sbale_count function do the same work than sg_nents().
So replace it by sg_nents() for removing duplicate code.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/s390/scsi/zfcp_fsf.c  |  3 +--
 drivers/s390/scsi/zfcp_qdio.h | 15 ---------------
 2 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 522a633..edc137a 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -985,8 +985,7 @@ static int zfcp_fsf_setup_ct_els_sbals(struct zfcp_fsf_req *req,
 		if (zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req, sg_resp))
 			return -EIO;
 
-		zfcp_qdio_set_data_div(qdio, &req->qdio_req,
-					zfcp_qdio_sbale_count(sg_req));
+		zfcp_qdio_set_data_div(qdio, &req->qdio_req, sg_nents(sg_req));
 		zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 		zfcp_qdio_set_scount(qdio, &req->qdio_req);
 		return 0;
diff --git a/drivers/s390/scsi/zfcp_qdio.h b/drivers/s390/scsi/zfcp_qdio.h
index 497cd37..85cdb82 100644
--- a/drivers/s390/scsi/zfcp_qdio.h
+++ b/drivers/s390/scsi/zfcp_qdio.h
@@ -225,21 +225,6 @@ void zfcp_qdio_set_data_div(struct zfcp_qdio *qdio,
 }
 
 /**
- * zfcp_qdio_sbale_count - count sbale used
- * @sg: pointer to struct scatterlist
- */
-static inline
-unsigned int zfcp_qdio_sbale_count(struct scatterlist *sg)
-{
-	unsigned int count = 0;
-
-	for (; sg; sg = sg_next(sg))
-		count++;
-
-	return count;
-}
-
-/**
  * zfcp_qdio_real_bytes - count bytes used
  * @sg: pointer to struct scatterlist
  */
-- 
2.4.6
