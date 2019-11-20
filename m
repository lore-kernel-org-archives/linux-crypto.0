Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B964C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 18:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31C962068E
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 18:58:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EOsTY1N2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfKTS6r (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 13:58:47 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53736 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbfKTS6r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 13:58:47 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKIs5vi002497;
        Wed, 20 Nov 2019 18:58:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=sSgfjfplpILRyqeLBHWbrZ2grVum8h5c4h94UoKEwFo=;
 b=EOsTY1N2Mf/iC+R4Ui/Xjy4pL0EJBYibNyK4H0R9oVFwrtOLjnGuQyrXWkNTNJt+Uv/5
 Tlvvf8w/88wtnUGL+WcKXBJfYjyIrhOYgQtpyRSi3MGZCt0wDlhniuVc2eNp1Pv7Z0d4
 JK3R8PBMFlczx2/wp9FL8dBzaJbFeKzdIeXOE7bdXGZI8eUm/fV744WKEkSLR9dXu3To
 HqHVArw41BOkkAIWhJcp0HfA9x7j0BpxauGRfABMhfmZLWyaNfJ1GnEPQwBjjojkkPZj
 gEqXolLmvByLu3QCFU51nMzCFG05jCNghQw8lwtF0/cwRDib/GI+HtKO01GeLdI5pw76 OA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wa9rqqfdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 18:58:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKIrikU139562;
        Wed, 20 Nov 2019 18:56:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wd47vmgte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 18:56:36 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAKIuZu9014903;
        Wed, 20 Nov 2019 18:56:35 GMT
Received: from zissou.us.oracle.com (/10.152.34.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 10:56:34 -0800
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 1/4] padata: update documentation
Date:   Wed, 20 Nov 2019 13:54:09 -0500
Message-Id: <20191120185412.302-2-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191120185412.302-1-daniel.m.jordan@oracle.com>
References: <20191120185412.302-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200156
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove references to unused functions and update to reflect the new
struct padata_shell.

Fixes: 815613da6a67 ("kernel/padata.c: removed unused code")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/padata.txt | 50 +++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/Documentation/padata.txt b/Documentation/padata.txt
index b37ba1eaace3..a03afb1588f9 100644
--- a/Documentation/padata.txt
+++ b/Documentation/padata.txt
@@ -2,7 +2,7 @@
 The padata parallel execution mechanism
 =======================================
 
-:Last updated: for 2.6.36
+:Last updated: for 5.4
 
 Padata is a mechanism by which the kernel can farm work out to be done in
 parallel on multiple CPUs while retaining the ordering of tasks.  It was
@@ -53,27 +53,26 @@ padata cpumask contains no active CPU (flag not set).
 padata_stop clears the flag and blocks until the padata instance
 is unused.
 
-The list of CPUs to be used can be adjusted with these functions::
+Finally, complete padata initialization by allocating a padata_shell object::
+
+   struct padata_shell *padata_alloc_shell(struct padata_instance *pinst);
+
+A padata_shell is used to submit a job to padata and allows a series of such
+jobs to be serialized independently.  A padata_instance may have one or more
+padata_shell objects associated with it, each allowing a separate series of
+jobs.
+
+The list of CPUs to be used can be adjusted with this function::
 
-    int padata_set_cpumasks(struct padata_instance *pinst,
-			    cpumask_var_t pcpumask,
-			    cpumask_var_t cbcpumask);
     int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 			   cpumask_var_t cpumask);
-    int padata_add_cpu(struct padata_instance *pinst, int cpu, int mask);
-    int padata_remove_cpu(struct padata_instance *pinst, int cpu, int mask);
 
 Changing the CPU masks are expensive operations, though, so it should not be
 done with great frequency.
 
-It's possible to change both cpumasks of a padata instance with
-padata_set_cpumasks by specifying the cpumasks for parallel execution (pcpumask)
-and for the serial callback function (cbcpumask). padata_set_cpumask is used to
-change just one of the cpumasks. Here cpumask_type is one of PADATA_CPU_SERIAL,
-PADATA_CPU_PARALLEL and cpumask specifies the new cpumask to use.
-To simply add or remove one CPU from a certain cpumask the functions
-padata_add_cpu/padata_remove_cpu are used. cpu specifies the CPU to add or
-remove and mask is one of PADATA_CPU_SERIAL, PADATA_CPU_PARALLEL.
+padata_set_cpumask is used to change just one of the cpumasks. Here cpumask_type
+is one of PADATA_CPU_SERIAL or PADATA_CPU_PARALLEL, and cpumask specifies the
+new cpumask to use.
 
 If a user is interested in padata cpumask changes, he can register to
 the padata cpumask change notifier::
@@ -117,12 +116,13 @@ momentarily.
 
 The submission of work is done with::
 
-    int padata_do_parallel(struct padata_instance *pinst,
-		           struct padata_priv *padata, int cb_cpu);
+    int padata_do_parallel(struct padata_shell *ps,
+		           struct padata_priv *padata, int *cb_cpu);
 
-The pinst and padata structures must be set up as described above; cb_cpu
-specifies which CPU will be used for the final callback when the work is
-done; it must be in the current instance's CPU mask.  The return value from
+The ps and padata structures must be set up as described above; cb_cpu
+points to the preferred CPU to be used for the final callback when the work is
+done; it must be in the current instance's CPU mask (if not the cb_cpu pointer
+is updated to point to the CPU actually chosen).  The return value from
 padata_do_parallel() is zero on success, indicating that the work is in
 progress. -EBUSY means that somebody, somewhere else is messing with the
 instance's CPU mask, while -EINVAL is a complaint about cb_cpu not being
@@ -154,10 +154,12 @@ Note that this call may be deferred for a while since the padata code takes
 pains to ensure that tasks are completed in the order in which they were
 submitted.
 
-The one remaining function in the padata API should be called to clean up
-when a padata instance is no longer needed::
+Cleaning up a padata instance predictably involves calling the three free
+functions that correspond to the allocation in reverse:
 
+    void padata_free_shell(struct padata_shell *ps);
+    void padata_stop(struct padata_instance *pinst);
     void padata_free(struct padata_instance *pinst);
 
-This function will busy-wait while any remaining tasks are completed, so it
-might be best not to call it while there is work outstanding.
+It is the user's responsibility to ensure all outstanding jobs are complete
+before any of the above are called.
-- 
2.23.0

