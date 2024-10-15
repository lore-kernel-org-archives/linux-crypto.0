Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAC31D2F40;
	Tue, 15 Oct 2024 11:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728990101; cv=none; b=KYfyNcfAItS6UbLNAYUd+Vtdqfla0bWr8QzVdO8k6FXp7J2OBnm2N95NGcjZEb24b48FEXXPpNVLFITLkVoMxprdQ/qLlGKva086ifinGmAjI1Fp5ojo+aLOu2w9m8F7Zzeb+NZJlecB7e5M8kEtBcCJCjbAht2YdSWVhCyXfc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728990101; c=relaxed/simple;
	bh=7XhF8sLA70VTgAOREkJ4xOtXSDoUgK1wbm+FSs76mJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I2JyEDNBl7NPAo9qqvZxjIws0bN+5T4JUIbWLYyKSOFXE1fVhu2cUbRS30xskxpgToC1j+ZdO+eUukxbeJ41sVHvh51j5NyTBRTobeeIM8X0Lm9aMTVyZE6z4reuLqkL+EpgyHIhZPMguJQThoA7ZxG4vlzoFx3o426+omU95Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QDYfLvVt; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QDYfLvVt"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49F9t14A030685;
	Tue, 15 Oct 2024 10:56:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=LB7FsJPHDA9rdk+4dKBXnIGSzRIi5liTlRKzH/4/n
	cU=; b=QDYfLvVtbTCXEAVj649bpIuroNr6bXtbQQkjwPE2oJm246L/+uhvxUNQ8
	gTjRSZctmAgCvPqNadCAGqg+uCK/O5SBVaEKuQ5XtjXgetOYIsF1vms6bT9NDqe2
	CCnNaRMVaeYycfWVxOUlxHS77OivI14Zvrl4I0tMvKpt8C/omfth3kszISa4JXpA
	w7mUFsYe5+RxdPWmUdk+w5qUx5auxW6rU2/EkHmIGPpNUwX2JgUfcdInaEbiXsx0
	zm8xxXwNyYqH4r+XMIYjQK3S3i4vQChvFlz5tNXJ0vRYRKSV2Ku6RuS28I3U/LPX
	lNFEnEZvd/Kcy4mqzWJywXko3dyDQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429p6d092k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 10:56:24 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49FAuNdR017447;
	Tue, 15 Oct 2024 10:56:23 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429p6d092c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 10:56:23 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49F7WVeK002408;
	Tue, 15 Oct 2024 10:56:22 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4284emkc5p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 10:56:22 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49FAuHrs50856252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 10:56:17 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A0D3A20063;
	Tue, 15 Oct 2024 10:56:17 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3057320040;
	Tue, 15 Oct 2024 10:56:15 +0000 (GMT)
Received: from vishalc-ibm.ibmuc.com (unknown [9.39.24.36])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 15 Oct 2024 10:56:14 +0000 (GMT)
From: Vishal Chourasia <vishalc@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, mpe@ellerman.id.au, npiggin@gmail.com,
        christophe.leroy@csgroup.eu, naveen@kernel.org, maddy@linux.ibm.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Vishal Chourasia <vishalc@linux.ibm.com>
Subject: [v2 PATCH 1/2] crypto/nx: Rename devdata_mutex to devdata_spinlock
Date: Tue, 15 Oct 2024 16:25:51 +0530
Message-ID: <20241015105551.1817348-2-vishalc@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HKfRnHAqL1xiFkXwLc3bSU4HDEzsYXU-
X-Proofpoint-ORIG-GUID: nU97NAV6X78iUj4JyH_ltF9gpyi0-IwX
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 malwarescore=0 adultscore=0
 impostorscore=0 phishscore=0 mlxlogscore=928 spamscore=0
 lowpriorityscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2409260000 definitions=main-2410150072

Rename devdata_mutex to devdata_spinlock to accurately reflect its
implementation as a spinlock.

[1] v1 https://lore.kernel.org/all/ZwyqD-w5hEhrnqTB@linux.ibm.com

Signed-off-by: Vishal Chourasia <vishalc@linux.ibm.com>
---
 drivers/crypto/nx/nx-common-pseries.c | 34 +++++++++++++--------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
index 35f2d0d8507ed..a0eb900383af7 100644
--- a/drivers/crypto/nx/nx-common-pseries.c
+++ b/drivers/crypto/nx/nx-common-pseries.c
@@ -133,7 +133,7 @@ struct nx842_devdata {
 };
 
 static struct nx842_devdata __rcu *devdata;
-static DEFINE_SPINLOCK(devdata_mutex);
+static DEFINE_SPINLOCK(devdata_spinlock);
 
 #define NX842_COUNTER_INC(_x) \
 static inline void nx842_inc_##_x( \
@@ -750,15 +750,15 @@ static int nx842_OF_upd(struct property *new_prop)
 	if (!new_devdata)
 		return -ENOMEM;
 
-	spin_lock_irqsave(&devdata_mutex, flags);
+	spin_lock_irqsave(&devdata_spinlock, flags);
 	old_devdata = rcu_dereference_check(devdata,
-			lockdep_is_held(&devdata_mutex));
+			lockdep_is_held(&devdata_spinlock));
 	if (old_devdata)
 		of_node = old_devdata->dev->of_node;
 
 	if (!old_devdata || !of_node) {
 		pr_err("%s: device is not available\n", __func__);
-		spin_unlock_irqrestore(&devdata_mutex, flags);
+		spin_unlock_irqrestore(&devdata_spinlock, flags);
 		kfree(new_devdata);
 		return -ENODEV;
 	}
@@ -810,7 +810,7 @@ static int nx842_OF_upd(struct property *new_prop)
 			old_devdata->max_sg_len);
 
 	rcu_assign_pointer(devdata, new_devdata);
-	spin_unlock_irqrestore(&devdata_mutex, flags);
+	spin_unlock_irqrestore(&devdata_spinlock, flags);
 	synchronize_rcu();
 	dev_set_drvdata(new_devdata->dev, new_devdata);
 	kfree(old_devdata);
@@ -821,13 +821,13 @@ static int nx842_OF_upd(struct property *new_prop)
 		dev_info(old_devdata->dev, "%s: device disabled\n", __func__);
 		nx842_OF_set_defaults(new_devdata);
 		rcu_assign_pointer(devdata, new_devdata);
-		spin_unlock_irqrestore(&devdata_mutex, flags);
+		spin_unlock_irqrestore(&devdata_spinlock, flags);
 		synchronize_rcu();
 		dev_set_drvdata(new_devdata->dev, new_devdata);
 		kfree(old_devdata);
 	} else {
 		dev_err(old_devdata->dev, "%s: could not update driver from hardware\n", __func__);
-		spin_unlock_irqrestore(&devdata_mutex, flags);
+		spin_unlock_irqrestore(&devdata_spinlock, flags);
 	}
 
 	if (!ret)
@@ -1045,9 +1045,9 @@ static int nx842_probe(struct vio_dev *viodev,
 		return -ENOMEM;
 	}
 
-	spin_lock_irqsave(&devdata_mutex, flags);
+	spin_lock_irqsave(&devdata_spinlock, flags);
 	old_devdata = rcu_dereference_check(devdata,
-			lockdep_is_held(&devdata_mutex));
+			lockdep_is_held(&devdata_spinlock));
 
 	if (old_devdata && old_devdata->vdev != NULL) {
 		dev_err(&viodev->dev, "%s: Attempt to register more than one instance of the hardware\n", __func__);
@@ -1062,7 +1062,7 @@ static int nx842_probe(struct vio_dev *viodev,
 	nx842_OF_set_defaults(new_devdata);
 
 	rcu_assign_pointer(devdata, new_devdata);
-	spin_unlock_irqrestore(&devdata_mutex, flags);
+	spin_unlock_irqrestore(&devdata_spinlock, flags);
 	synchronize_rcu();
 	kfree(old_devdata);
 
@@ -1101,7 +1101,7 @@ static int nx842_probe(struct vio_dev *viodev,
 	return 0;
 
 error_unlock:
-	spin_unlock_irqrestore(&devdata_mutex, flags);
+	spin_unlock_irqrestore(&devdata_spinlock, flags);
 	if (new_devdata)
 		kfree(new_devdata->counters);
 	kfree(new_devdata);
@@ -1122,12 +1122,12 @@ static void nx842_remove(struct vio_dev *viodev)
 
 	crypto_unregister_alg(&nx842_pseries_alg);
 
-	spin_lock_irqsave(&devdata_mutex, flags);
+	spin_lock_irqsave(&devdata_spinlock, flags);
 	old_devdata = rcu_dereference_check(devdata,
-			lockdep_is_held(&devdata_mutex));
+			lockdep_is_held(&devdata_spinlock));
 	of_reconfig_notifier_unregister(&nx842_of_nb);
 	RCU_INIT_POINTER(devdata, NULL);
-	spin_unlock_irqrestore(&devdata_mutex, flags);
+	spin_unlock_irqrestore(&devdata_spinlock, flags);
 	synchronize_rcu();
 	dev_set_drvdata(&viodev->dev, NULL);
 	if (old_devdata)
@@ -1257,11 +1257,11 @@ static void __exit nx842_pseries_exit(void)
 
 	crypto_unregister_alg(&nx842_pseries_alg);
 
-	spin_lock_irqsave(&devdata_mutex, flags);
+	spin_lock_irqsave(&devdata_spinlock, flags);
 	old_devdata = rcu_dereference_check(devdata,
-			lockdep_is_held(&devdata_mutex));
+			lockdep_is_held(&devdata_spinlock));
 	RCU_INIT_POINTER(devdata, NULL);
-	spin_unlock_irqrestore(&devdata_mutex, flags);
+	spin_unlock_irqrestore(&devdata_spinlock, flags);
 	synchronize_rcu();
 	if (old_devdata && old_devdata->dev)
 		dev_set_drvdata(old_devdata->dev, NULL);
-- 
2.47.0

