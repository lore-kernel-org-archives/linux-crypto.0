Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83C61C433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 08:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ED8461369
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 08:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhDMI0y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Apr 2021 04:26:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52160 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229379AbhDMI0r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Apr 2021 04:26:47 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13D89Ufi089203;
        Tue, 13 Apr 2021 04:26:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=u2psfaRpCQvaOO6Fp+kP6fY8T51Wi7PJY0UCHTFsbkY=;
 b=XfipyiClgdHGAscE90W3niO1hIniBA/XJ2pPvTS1dFrXGpQ6/RWVh8t3KC4+cyv7cDrm
 b+XyDvuHKo4ouJDv4DrNeQEO51jeQ3rJyTsKtiWE/gV+fXOCuvU+E94tIXLTiqSXlqXW
 wzFm0qTo3Se7zmVNQAKd2k2/ql3wDxHOoIRgd1zs+yFhe2dTwERemPSvan1U/OHb4yRZ
 0+icC7RJwd6CO5wyRbuyUXhKhUxRZa3EK7b1K9SEbJic9GeSnJVQZAebZE9SrK4dfwEf
 Q6meIZ/k1n843L2msvMxtUsOeapbpqocUCJvq0zqoZqUDW0/Nca0Of75RX3Reeh67MS3 zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vkdktk2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 04:26:21 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13D89ed0089849;
        Tue, 13 Apr 2021 04:26:21 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vkdktk1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 04:26:21 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13D8NfC4018617;
        Tue, 13 Apr 2021 08:26:20 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02wdc.us.ibm.com with ESMTP id 37u3n9q46t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 08:26:20 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13D8QJXY24903978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 08:26:19 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2465B6A04D;
        Tue, 13 Apr 2021 08:26:19 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E862C6A047;
        Tue, 13 Apr 2021 08:26:17 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.232.48])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 13 Apr 2021 08:26:17 +0000 (GMT)
Message-ID: <e40d9c03775da9fcfb000dc3f2c32cf6dbc03522.camel@linux.ibm.com>
Subject: [V2 PATCH 10/16] powerpc/pseries/vas: Integrate API with open/close
 windows
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com
Date:   Tue, 13 Apr 2021 01:26:15 -0700
In-Reply-To: <68aa9f2860f9acffa41469d3858883c938634722.camel@linux.ibm.com>
References: <68aa9f2860f9acffa41469d3858883c938634722.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _96OI1npgQKWv4KOkjdK5seh0hqNpNn9
X-Proofpoint-GUID: bSsaG8N2NIUr81u0C1sklxamgzwS9b_T
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_03:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 phishscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015 spamscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130055
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


This patch adds VAS window allocatioa/close with the corresponding
HCALLs. Also changes to integrate with the existing user space VAS
API and provide register/unregister functions to NX pseries driver.

The driver register function is used to create the user space
interface (/dev/crypto/nx-gzip) and unregister to remove this entry.

The user space process opens this device node and makes an ioctl
to allocate VAS window. The close interface is used to deallocate
window.

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
---
 arch/powerpc/include/asm/vas.h          |   5 +
 arch/powerpc/platforms/Kconfig          |   2 +-
 arch/powerpc/platforms/pseries/Makefile |   1 +
 arch/powerpc/platforms/pseries/vas.c    | 212 ++++++++++++++++++++++++
 4 files changed, 219 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/vas.h
index d15784506a54..aa1974aba27e 100644
--- a/arch/powerpc/include/asm/vas.h
+++ b/arch/powerpc/include/asm/vas.h
@@ -270,6 +270,11 @@ struct vas_all_capabs {
 	u64     feat_type;
 };
 
+int plpar_vas_query_capabilities(const u64 hcall, u8 query_type,
+				 u64 result);
+int vas_register_api_pseries(struct module *mod,
+			     enum vas_cop_type cop_type, const char *name);
+void vas_unregister_api_pseries(void);
 #endif
 
 /*
diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index 1b14dc7343f3..778b9bbc11af 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -71,7 +71,7 @@ config PPC_DT_CPU_FTRS
 
 config PPC_VAS
 	bool "IBM Virtual Accelerator Switchboard (VAS)"
-	depends on PPC_POWERNV && PPC_64K_PAGES
+	depends on (PPC_POWERNV || PPC_PSERIES) && PPC_64K_PAGES
 	default y
 	help
 	  This enables support for IBM Virtual Accelerator Switchboard (VAS).
diff --git a/arch/powerpc/platforms/pseries/Makefile b/arch/powerpc/platforms/pseries/Makefile
index c8a2b0b05ac0..4cda0ef87be0 100644
--- a/arch/powerpc/platforms/pseries/Makefile
+++ b/arch/powerpc/platforms/pseries/Makefile
@@ -30,3 +30,4 @@ obj-$(CONFIG_PPC_SVM)		+= svm.o
 obj-$(CONFIG_FA_DUMP)		+= rtas-fadump.o
 
 obj-$(CONFIG_SUSPEND)		+= suspend.o
+obj-$(CONFIG_PPC_VAS)		+= vas.o
diff --git a/arch/powerpc/platforms/pseries/vas.c b/arch/powerpc/platforms/pseries/vas.c
index 35946fb02995..0ade0d6d728f 100644
--- a/arch/powerpc/platforms/pseries/vas.c
+++ b/arch/powerpc/platforms/pseries/vas.c
@@ -222,6 +222,218 @@ int plpar_vas_query_capabilities(const u64 hcall, u8 query_type,
 		return -EIO;
 	}
 }
+EXPORT_SYMBOL_GPL(plpar_vas_query_capabilities);
+
+/*
+ * Allocate window and setup IRQ mapping.
+ */
+static int allocate_setup_window(struct vas_window *txwin,
+				 u64 *domain, u8 wintype)
+{
+	int rc;
+
+	rc = plpar_vas_allocate_window(txwin, domain, wintype, DEF_WIN_CREDS);
+	if (rc)
+		return rc;
+
+	txwin->wcreds_max = DEF_WIN_CREDS;
+
+	return 0;
+}
+
+static struct vas_window *vas_allocate_window(struct vas_tx_win_open_attr *uattr,
+					      enum vas_cop_type cop_type)
+{
+	long domain[PLPAR_HCALL9_BUFSIZE] = {VAS_DEFAULT_DOMAIN_ID};
+	struct vas_ct_capabs *ct_capab;
+	struct vas_capabs *capabs;
+	struct vas_window *txwin;
+	int rc;
+
+	txwin = kzalloc(sizeof(*txwin), GFP_KERNEL);
+	if (!txwin)
+		return ERR_PTR(-ENOMEM);
+
+	/*
+	 * A VAS window can have many credits which means that many
+	 * requests can be issued simultaneously. But phyp restricts
+	 * one credit per window.
+	 * phyp introduces 2 different types of credits:
+	 * Default credit type (Uses normal priority FIFO):
+	 *	A limited number of credits are assigned to partitions
+	 *	based on processor entitlement. But these credits may be
+	 *	over-committed on a system depends on whether the CPUs
+	 *	are in shared or dedicated modes - that is, more requests
+	 *	may be issued across the system than NX can service at
+	 *	once which can result in paste command failure (RMA_busy).
+	 *	Then the process has to resend requests or fall-back to
+	 *	SW compression.
+	 * Quality of Service (QoS) credit type (Uses high priority FIFO):
+	 *	To avoid NX HW contention, the system admins can assign
+	 *	QoS credits for each LPAR so that this partition is
+	 *	guaranteed access to NX resources. These credits are
+	 *	assigned to partitions via the HMC.
+	 *	Refer PAPR for more information.
+	 *
+	 * Allocate window with QoS credits if user requested. Otherwise
+	 * default credits are used.
+	 */
+	if (uattr->flags & VAS_WIN_QOS_CREDITS)
+		capabs = &vcapabs[VAS_GZIP_QOS_FEAT_TYPE];
+	else
+		capabs = &vcapabs[VAS_GZIP_DEF_FEAT_TYPE];
+
+	ct_capab = &capabs->capab;
+
+	if (atomic_inc_return(&ct_capab->used_lpar_creds) >
+			atomic_read(&ct_capab->target_lpar_creds)) {
+		pr_err("Credits are not available to allocate window\n");
+		rc = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * The user space is requesting to allocate a window on a VAS
+	 * instance (or chip) where the process is executing.
+	 * On powerVM, domain values are passed to pHyp to select chip /
+	 * VAS instance. Useful if the process is affinity to NUMA node.
+	 * pHyp selects VAS instance if VAS_DEFAULT_DOMAIN_ID (-1) is
+	 * passed for domain values.
+	 */
+	if (uattr->vas_id == -1) {
+		/*
+		 * To allocate VAS window, pass same domain values returned
+		 * from this HCALL.
+		 */
+		rc = plpar_hcall9(H_HOME_NODE_ASSOCIATIVITY, domain,
+				  VPHN_FLAG_VCPU, smp_processor_id());
+		if (rc != H_SUCCESS) {
+			pr_err("HCALL(%x): failed with ret(%d)\n",
+			       H_HOME_NODE_ASSOCIATIVITY, rc);
+			goto out;
+		}
+	}
+
+	/*
+	 * Allocate / Deallocate window HCALLs and setup / free IRQs
+	 * have to be protected with mutex. Otherwise, since IRQ is freed
+	 * after deallocate HCALL, may see the case where window ID and
+	 * fault interrupt could be reused before free IRQ (for the old
+	 * window) in kernel. It can result in setup IRQ fail for the
+	 * new window.
+	 */
+	mutex_lock(&vas_pseries_mutex);
+	rc = allocate_setup_window(txwin, (u64 *)&domain[0],
+				   ct_capab->win_type);
+	mutex_unlock(&vas_pseries_mutex);
+	if (rc)
+		goto out;
+
+	/*
+	 * Modify window and it is ready to use.
+	 */
+	rc = plpar_vas_modify_window(txwin);
+	if (!rc)
+		rc = vas_reference_task(&txwin->task);
+	if (rc)
+		goto out_free;
+
+	txwin->lpar.win_type = ct_capab->win_type;
+	mutex_lock(&vas_pseries_mutex);
+	list_add(&txwin->lpar.win_list, &capabs->list);
+	mutex_unlock(&vas_pseries_mutex);
+
+	return txwin;
+
+out_free:
+	plpar_vas_deallocate_window(txwin->winid);
+out:
+	atomic_dec(&ct_capab->used_lpar_creds);
+	kfree(txwin);
+	return ERR_PTR(rc);
+}
+
+static u64 vas_paste_address(void *addr)
+{
+	struct vas_window *win = addr;
+
+	return win->lpar.win_addr;
+}
+
+static int deallocate_free_window(struct vas_window *win)
+{
+	int rc = 0;
+
+	rc = plpar_vas_deallocate_window(win->winid);
+	if (!rc)
+		kfree(win->lpar.name);
+
+	return rc;
+}
+
+static int vas_deallocate_window(void *addr)
+{
+	struct vas_window *win = (struct vas_window *)addr;
+	struct vas_ct_capabs *capabs;
+	int rc = 0;
+
+	if (!win)
+		return -EINVAL;
+
+	/* Should not happen */
+	if (win->lpar.win_type >= VAS_MAX_FEAT_TYPE) {
+		pr_err("Window (%u): Invalid window type %u\n",
+				win->winid, win->lpar.win_type);
+		return -EINVAL;
+	}
+
+	capabs = &vcapabs[win->lpar.win_type].capab;
+	mutex_lock(&vas_pseries_mutex);
+	rc = deallocate_free_window(win);
+	if (rc) {
+		mutex_unlock(&vas_pseries_mutex);
+		return rc;
+	}
+
+	list_del(&win->lpar.win_list);
+	atomic_dec(&capabs->used_lpar_creds);
+	mutex_unlock(&vas_pseries_mutex);
+
+	vas_drop_reference_task(&win->task);
+
+	kfree(win);
+	return 0;
+}
+
+static struct vas_user_win_ops vops_pseries = {
+	.open_win	= vas_allocate_window,	/* Open and configure window */
+	.paste_addr	= vas_paste_address,	/* To do copy/paste */
+	.close_win	= vas_deallocate_window, /* Close window */
+};
+
+/*
+ * Supporting only nx-gzip coprocessor type now, but this API code
+ * extended to other coprocessor types later.
+ */
+int vas_register_api_pseries(struct module *mod, enum vas_cop_type cop_type,
+			     const char *name)
+{
+	int rc;
+
+	if (!copypaste_feat)
+		return -ENOTSUPP;
+
+	rc = vas_register_coproc_api(mod, cop_type, name, &vops_pseries);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(vas_register_api_pseries);
+
+void vas_unregister_api_pseries(void)
+{
+	vas_unregister_coproc_api();
+}
+EXPORT_SYMBOL_GPL(vas_unregister_api_pseries);
 
 /*
  * Get the specific capabilities based on the feature type.
-- 
2.18.2


