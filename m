Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B9C2C0F6D;
	Thu,  4 Sep 2025 15:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001469; cv=none; b=NSVqGSATbnzsIrHmQUgYRD2HO0oB7z1J5LXcisBfRfivxQDTb7CydwBPwjyLlNtrjE25Nf0H8t5ZRkJ3/VwgGfWzhZPZ8ShwBkId+SBg6DFIPpLUhq3FxAFGjz2ktHNXYuLoAkUFjraYqjsyC1infkYvENL+nHIu3Ps5ChiUrL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001469; c=relaxed/simple;
	bh=leg72RIn/UUgVaGDXtPLoEyGCRPm73O4w3W+tlcEqOg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qbN6kpP8U3hch3dgtAIEy61QWPZjSUHXERWiEGHa2hGROEcxK0NMlePo9cnH2kqLFXxTq1hIT9hGEFWUZwfin5uW0G5+tCyaZO61tvP1p6GpO3WvnzIyfEyoaU1sGhT+hTD3EK5daK8H6JpRzxCn5taqSa6xSpggZ2OLY5ow39Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hj88ApV0; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hj88ApV0"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Furcb004119;
	Thu, 4 Sep 2025 15:57:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=RKSiL
	9CXeniMWr1piHthK34YuY/t0h9RXSn7nK7OIGo=; b=hj88ApV0UUYwIto2lcd7z
	QytxcsUBw3eVUDBi1ZVerzK4SExEKNTwaDz95p5IDqATbWSAochSmCaKSpYVLm0F
	1Bws3BYKMI7IrAXlMi+i2oIvNZRMXlBsD4Or8yWCshaEtiHLXhGoiMBx3D2hkLD9
	8CWNN/aID8EORZvkfen4mjG8pwWrQEoGeJcyFQ8w9OhpbJdQn5JUMF3O6eoH9y5r
	UDWNfv40+Hpzgf1dQC2CRr1bF9qpGJMYl9k75Cg85QWl6wZ80KJOPYqSLJhlSSnk
	PIEJ9nmlHhZyX6Fj01K0GA3R6QnD4KPZFwWKpLaKJNnvNNUowfxiSGUPIubKdsuV
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydun001e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584EPF0r040051;
	Thu, 4 Sep 2025 15:57:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtnk2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:02 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5s000707;
	Thu, 4 Sep 2025 15:57:02 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-34;
	Thu, 04 Sep 2025 15:57:01 +0000
From: Vegard Nossum <vegard.nossum@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
        Daniel Gomez <da.gomez@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
        Vladis Dronov <vdronov@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Sami Tolvanen <samitolvanen@google.com>, linux-modules@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH RFC 033/104] crypto: fips140: convert crypto/algapi.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:05 +0200
Message-Id: <20250904155216.460962-34-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250904155216.460962-1-vegard.nossum@oracle.com>
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040156
X-Proofpoint-ORIG-GUID: qE7Bl9T46V3yyN2E2BDi_l8Q7rWnWN4s
X-Proofpoint-GUID: qE7Bl9T46V3yyN2E2BDi_l8Q7rWnWN4s
X-Authority-Analysis: v=2.4 cv=cfXSrmDM c=1 sm=1 tr=0 ts=68b9b6ee b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=eGYVPBJRNnn_TLuWl0cA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX4DoLP4IqbDMY
 kOj2q2wUKrgMmQtnCZK+lEd3SsYitRjNWXbFxuVHVYfr9Mg8tD7Uh2z6hYsgNPjw2FBggQUgkGj
 kREcA+3TuFIYeLsKDm7kyrbP28Wt6HVWCIPemzSJ0eiMDEybXJg70eS9JsgXjH3Xe6EvBd8A7b8
 bj+r/Z7UdJMSxgE3IGaQ41ulDU7MGt4baXkkGZKr3HtyTCYbcny0WYpquNrArZhzj1x+Pm2F6aF
 UyN1Kzx6QNJX/wBU3dEhIf+iCMriWkkCSHQdfB7h7hf0L2WE0VRy4WQ6OtH5Rd9XFON0DGXlTMR
 aVsNNzDjZi3/BOn70DcS7PegxXSvTkgYsb8yzi9TlVTZDvOgg/B8I6RLromqtmCzwDlpOT0z3An
 rlpvor03lR+s1sDx9E2tFdxynxdf4g==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_ALGAPI2 --source crypto/algapi.c --header include/crypto/algapi.h crypto/internal.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/algapi.c         | 128 ++++++++++++++++++++--------------------
 crypto/fips140-api.c    |  44 ++++++++++++++
 crypto/internal.h       |  25 +++++---
 include/crypto/algapi.h | 117 +++++++++++++++++++++++++-----------
 4 files changed, 207 insertions(+), 107 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 8b4a1903557e..f24fca384a88 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -174,7 +174,7 @@ static void crypto_remove_instance(struct crypto_instance *inst,
  * that is depended on by nalg.  This is useful when nalg itself
  * depends on alg.
  */
-void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
+void CRYPTO_API(crypto_remove_spawns)(struct crypto_alg *alg, struct list_head *list,
 			  struct crypto_alg *nalg)
 {
 	u32 new_type = (nalg ?: alg)->cra_flags;
@@ -252,7 +252,7 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 			crypto_remove_instance(spawn->inst, list);
 	}
 }
-EXPORT_SYMBOL_GPL(crypto_remove_spawns);
+DEFINE_CRYPTO_API(crypto_remove_spawns);
 
 static void crypto_alg_finish_registration(struct crypto_alg *alg,
 					   struct list_head *algs_to_put)
@@ -366,7 +366,7 @@ __crypto_register_alg(struct crypto_alg *alg, struct list_head *algs_to_put)
 	goto out;
 }
 
-void crypto_alg_tested(struct crypto_alg *alg, int err)
+void CRYPTO_API(crypto_alg_tested)(struct crypto_alg *alg, int err)
 {
 	struct crypto_larval *test;
 	struct crypto_alg *q;
@@ -412,9 +412,9 @@ void crypto_alg_tested(struct crypto_alg *alg, int err)
 	crypto_alg_put(&test->alg);
 	crypto_remove_final(&list);
 }
-EXPORT_SYMBOL_GPL(crypto_alg_tested);
+DEFINE_CRYPTO_API(crypto_alg_tested);
 
-void crypto_remove_final(struct list_head *list)
+void CRYPTO_API(crypto_remove_final)(struct list_head *list)
 {
 	struct crypto_alg *alg;
 	struct crypto_alg *n;
@@ -424,7 +424,7 @@ void crypto_remove_final(struct list_head *list)
 		crypto_alg_put(alg);
 	}
 }
-EXPORT_SYMBOL_GPL(crypto_remove_final);
+DEFINE_CRYPTO_API(crypto_remove_final);
 
 static void crypto_free_alg(struct crypto_alg *alg)
 {
@@ -435,7 +435,7 @@ static void crypto_free_alg(struct crypto_alg *alg)
 	kfree(p);
 }
 
-int crypto_register_alg(struct crypto_alg *alg)
+int CRYPTO_API(crypto_register_alg)(struct crypto_alg *alg)
 {
 	struct crypto_larval *larval;
 	bool test_started = false;
@@ -490,7 +490,7 @@ int crypto_register_alg(struct crypto_alg *alg)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(crypto_register_alg);
+DEFINE_CRYPTO_API(crypto_register_alg);
 
 static int crypto_remove_alg(struct crypto_alg *alg, struct list_head *list)
 {
@@ -505,7 +505,7 @@ static int crypto_remove_alg(struct crypto_alg *alg, struct list_head *list)
 	return 0;
 }
 
-void crypto_unregister_alg(struct crypto_alg *alg)
+void CRYPTO_API(crypto_unregister_alg)(struct crypto_alg *alg)
 {
 	int ret;
 	LIST_HEAD(list);
@@ -522,9 +522,9 @@ void crypto_unregister_alg(struct crypto_alg *alg)
 	list_add(&alg->cra_list, &list);
 	crypto_remove_final(&list);
 }
-EXPORT_SYMBOL_GPL(crypto_unregister_alg);
+DEFINE_CRYPTO_API(crypto_unregister_alg);
 
-int crypto_register_algs(struct crypto_alg *algs, int count)
+int CRYPTO_API(crypto_register_algs)(struct crypto_alg *algs, int count)
 {
 	int i, ret;
 
@@ -542,18 +542,18 @@ int crypto_register_algs(struct crypto_alg *algs, int count)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(crypto_register_algs);
+DEFINE_CRYPTO_API(crypto_register_algs);
 
-void crypto_unregister_algs(struct crypto_alg *algs, int count)
+void CRYPTO_API(crypto_unregister_algs)(struct crypto_alg *algs, int count)
 {
 	int i;
 
 	for (i = 0; i < count; i++)
 		crypto_unregister_alg(&algs[i]);
 }
-EXPORT_SYMBOL_GPL(crypto_unregister_algs);
+DEFINE_CRYPTO_API(crypto_unregister_algs);
 
-int crypto_register_template(struct crypto_template *tmpl)
+int CRYPTO_API(crypto_register_template)(struct crypto_template *tmpl)
 {
 	struct crypto_template *q;
 	int err = -EEXIST;
@@ -581,9 +581,9 @@ int crypto_register_template(struct crypto_template *tmpl)
 	up_write(&crypto_alg_sem);
 	return err;
 }
-EXPORT_SYMBOL_GPL(crypto_register_template);
+DEFINE_CRYPTO_API(crypto_register_template);
 
-int crypto_register_templates(struct crypto_template *tmpls, int count)
+int CRYPTO_API(crypto_register_templates)(struct crypto_template *tmpls, int count)
 {
 	int i, err;
 
@@ -599,9 +599,9 @@ int crypto_register_templates(struct crypto_template *tmpls, int count)
 		crypto_unregister_template(&tmpls[i]);
 	return err;
 }
-EXPORT_SYMBOL_GPL(crypto_register_templates);
+DEFINE_CRYPTO_API(crypto_register_templates);
 
-void crypto_unregister_template(struct crypto_template *tmpl)
+void CRYPTO_API(crypto_unregister_template)(struct crypto_template *tmpl)
 {
 	struct crypto_instance *inst;
 	struct hlist_node *n;
@@ -630,16 +630,16 @@ void crypto_unregister_template(struct crypto_template *tmpl)
 
 	flush_work(&tmpl->free_work);
 }
-EXPORT_SYMBOL_GPL(crypto_unregister_template);
+DEFINE_CRYPTO_API(crypto_unregister_template);
 
-void crypto_unregister_templates(struct crypto_template *tmpls, int count)
+void CRYPTO_API(crypto_unregister_templates)(struct crypto_template *tmpls, int count)
 {
 	int i;
 
 	for (i = count - 1; i >= 0; --i)
 		crypto_unregister_template(&tmpls[i]);
 }
-EXPORT_SYMBOL_GPL(crypto_unregister_templates);
+DEFINE_CRYPTO_API(crypto_unregister_templates);
 
 static struct crypto_template *__crypto_lookup_template(const char *name)
 {
@@ -660,14 +660,14 @@ static struct crypto_template *__crypto_lookup_template(const char *name)
 	return tmpl;
 }
 
-struct crypto_template *crypto_lookup_template(const char *name)
+struct crypto_template *CRYPTO_API(crypto_lookup_template)(const char *name)
 {
 	return try_then_request_module(__crypto_lookup_template(name),
 				       "crypto-%s", name);
 }
-EXPORT_SYMBOL_GPL(crypto_lookup_template);
+DEFINE_CRYPTO_API(crypto_lookup_template);
 
-int crypto_register_instance(struct crypto_template *tmpl,
+int CRYPTO_API(crypto_register_instance)(struct crypto_template *tmpl,
 			     struct crypto_instance *inst)
 {
 	struct crypto_larval *larval;
@@ -748,9 +748,9 @@ int crypto_register_instance(struct crypto_template *tmpl,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(crypto_register_instance);
+DEFINE_CRYPTO_API(crypto_register_instance);
 
-void crypto_unregister_instance(struct crypto_instance *inst)
+void CRYPTO_API(crypto_unregister_instance)(struct crypto_instance *inst)
 {
 	LIST_HEAD(list);
 
@@ -763,9 +763,9 @@ void crypto_unregister_instance(struct crypto_instance *inst)
 
 	crypto_remove_final(&list);
 }
-EXPORT_SYMBOL_GPL(crypto_unregister_instance);
+DEFINE_CRYPTO_API(crypto_unregister_instance);
 
-int crypto_grab_spawn(struct crypto_spawn *spawn, struct crypto_instance *inst,
+int CRYPTO_API(crypto_grab_spawn)(struct crypto_spawn *spawn, struct crypto_instance *inst,
 		      const char *name, u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
@@ -799,9 +799,9 @@ int crypto_grab_spawn(struct crypto_spawn *spawn, struct crypto_instance *inst,
 		crypto_mod_put(alg);
 	return err;
 }
-EXPORT_SYMBOL_GPL(crypto_grab_spawn);
+DEFINE_CRYPTO_API(crypto_grab_spawn);
 
-void crypto_drop_spawn(struct crypto_spawn *spawn)
+void CRYPTO_API(crypto_drop_spawn)(struct crypto_spawn *spawn)
 {
 	if (!spawn->alg) /* not yet initialized? */
 		return;
@@ -814,7 +814,7 @@ void crypto_drop_spawn(struct crypto_spawn *spawn)
 	if (!spawn->registered)
 		crypto_mod_put(spawn->alg);
 }
-EXPORT_SYMBOL_GPL(crypto_drop_spawn);
+DEFINE_CRYPTO_API(crypto_drop_spawn);
 
 static struct crypto_alg *crypto_spawn_alg(struct crypto_spawn *spawn)
 {
@@ -841,7 +841,7 @@ static struct crypto_alg *crypto_spawn_alg(struct crypto_spawn *spawn)
 	return alg;
 }
 
-struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
+struct crypto_tfm *CRYPTO_API(crypto_spawn_tfm)(struct crypto_spawn *spawn, u32 type,
 				    u32 mask)
 {
 	struct crypto_alg *alg;
@@ -865,9 +865,9 @@ struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
 	crypto_mod_put(alg);
 	return tfm;
 }
-EXPORT_SYMBOL_GPL(crypto_spawn_tfm);
+DEFINE_CRYPTO_API(crypto_spawn_tfm);
 
-void *crypto_spawn_tfm2(struct crypto_spawn *spawn)
+void *CRYPTO_API(crypto_spawn_tfm2)(struct crypto_spawn *spawn)
 {
 	struct crypto_alg *alg;
 	struct crypto_tfm *tfm;
@@ -886,21 +886,21 @@ void *crypto_spawn_tfm2(struct crypto_spawn *spawn)
 	crypto_mod_put(alg);
 	return tfm;
 }
-EXPORT_SYMBOL_GPL(crypto_spawn_tfm2);
+DEFINE_CRYPTO_API(crypto_spawn_tfm2);
 
-int crypto_register_notifier(struct notifier_block *nb)
+int CRYPTO_API(crypto_register_notifier)(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_register(&crypto_chain, nb);
 }
-EXPORT_SYMBOL_GPL(crypto_register_notifier);
+DEFINE_CRYPTO_API(crypto_register_notifier);
 
-int crypto_unregister_notifier(struct notifier_block *nb)
+int CRYPTO_API(crypto_unregister_notifier)(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_unregister(&crypto_chain, nb);
 }
-EXPORT_SYMBOL_GPL(crypto_unregister_notifier);
+DEFINE_CRYPTO_API(crypto_unregister_notifier);
 
-struct crypto_attr_type *crypto_get_attr_type(struct rtattr **tb)
+struct crypto_attr_type *CRYPTO_API(crypto_get_attr_type)(struct rtattr **tb)
 {
 	struct rtattr *rta = tb[0];
 	struct crypto_attr_type *algt;
@@ -916,7 +916,7 @@ struct crypto_attr_type *crypto_get_attr_type(struct rtattr **tb)
 
 	return algt;
 }
-EXPORT_SYMBOL_GPL(crypto_get_attr_type);
+DEFINE_CRYPTO_API(crypto_get_attr_type);
 
 /**
  * crypto_check_attr_type() - check algorithm type and compute inherited mask
@@ -934,7 +934,7 @@ EXPORT_SYMBOL_GPL(crypto_get_attr_type);
  *
  * Return: 0 on success; -errno on failure
  */
-int crypto_check_attr_type(struct rtattr **tb, u32 type, u32 *mask_ret)
+int CRYPTO_API(crypto_check_attr_type)(struct rtattr **tb, u32 type, u32 *mask_ret)
 {
 	struct crypto_attr_type *algt;
 
@@ -948,9 +948,9 @@ int crypto_check_attr_type(struct rtattr **tb, u32 type, u32 *mask_ret)
 	*mask_ret = crypto_algt_inherited_mask(algt);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(crypto_check_attr_type);
+DEFINE_CRYPTO_API(crypto_check_attr_type);
 
-const char *crypto_attr_alg_name(struct rtattr *rta)
+const char *CRYPTO_API(crypto_attr_alg_name)(struct rtattr *rta)
 {
 	struct crypto_attr_alg *alga;
 
@@ -966,9 +966,9 @@ const char *crypto_attr_alg_name(struct rtattr *rta)
 
 	return alga->name;
 }
-EXPORT_SYMBOL_GPL(crypto_attr_alg_name);
+DEFINE_CRYPTO_API(crypto_attr_alg_name);
 
-int __crypto_inst_setname(struct crypto_instance *inst, const char *name,
+int CRYPTO_API(__crypto_inst_setname)(struct crypto_instance *inst, const char *name,
 			  const char *driver, struct crypto_alg *alg)
 {
 	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME, "%s(%s)", name,
@@ -981,18 +981,18 @@ int __crypto_inst_setname(struct crypto_instance *inst, const char *name,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(__crypto_inst_setname);
+DEFINE_CRYPTO_API(__crypto_inst_setname);
 
-void crypto_init_queue(struct crypto_queue *queue, unsigned int max_qlen)
+void CRYPTO_API(crypto_init_queue)(struct crypto_queue *queue, unsigned int max_qlen)
 {
 	INIT_LIST_HEAD(&queue->list);
 	queue->backlog = &queue->list;
 	queue->qlen = 0;
 	queue->max_qlen = max_qlen;
 }
-EXPORT_SYMBOL_GPL(crypto_init_queue);
+DEFINE_CRYPTO_API(crypto_init_queue);
 
-int crypto_enqueue_request(struct crypto_queue *queue,
+int CRYPTO_API(crypto_enqueue_request)(struct crypto_queue *queue,
 			   struct crypto_async_request *request)
 {
 	int err = -EINPROGRESS;
@@ -1013,9 +1013,9 @@ int crypto_enqueue_request(struct crypto_queue *queue,
 out:
 	return err;
 }
-EXPORT_SYMBOL_GPL(crypto_enqueue_request);
+DEFINE_CRYPTO_API(crypto_enqueue_request);
 
-void crypto_enqueue_request_head(struct crypto_queue *queue,
+void CRYPTO_API(crypto_enqueue_request_head)(struct crypto_queue *queue,
 				 struct crypto_async_request *request)
 {
 	if (unlikely(queue->qlen >= queue->max_qlen))
@@ -1024,9 +1024,9 @@ void crypto_enqueue_request_head(struct crypto_queue *queue,
 	queue->qlen++;
 	list_add(&request->list, &queue->list);
 }
-EXPORT_SYMBOL_GPL(crypto_enqueue_request_head);
+DEFINE_CRYPTO_API(crypto_enqueue_request_head);
 
-struct crypto_async_request *crypto_dequeue_request(struct crypto_queue *queue)
+struct crypto_async_request *CRYPTO_API(crypto_dequeue_request)(struct crypto_queue *queue)
 {
 	struct list_head *request;
 
@@ -1043,7 +1043,7 @@ struct crypto_async_request *crypto_dequeue_request(struct crypto_queue *queue)
 
 	return list_entry(request, struct crypto_async_request, list);
 }
-EXPORT_SYMBOL_GPL(crypto_dequeue_request);
+DEFINE_CRYPTO_API(crypto_dequeue_request);
 
 static inline void crypto_inc_byte(u8 *a, unsigned int size)
 {
@@ -1058,7 +1058,7 @@ static inline void crypto_inc_byte(u8 *a, unsigned int size)
 	}
 }
 
-void crypto_inc(u8 *a, unsigned int size)
+void CRYPTO_API(crypto_inc)(u8 *a, unsigned int size)
 {
 	__be32 *b = (__be32 *)(a + size);
 	u32 c;
@@ -1074,16 +1074,16 @@ void crypto_inc(u8 *a, unsigned int size)
 
 	crypto_inc_byte(a, size);
 }
-EXPORT_SYMBOL_GPL(crypto_inc);
+DEFINE_CRYPTO_API(crypto_inc);
 
-unsigned int crypto_alg_extsize(struct crypto_alg *alg)
+unsigned int CRYPTO_API(crypto_alg_extsize)(struct crypto_alg *alg)
 {
 	return alg->cra_ctxsize +
 	       (alg->cra_alignmask & ~(crypto_tfm_ctx_alignment() - 1));
 }
-EXPORT_SYMBOL_GPL(crypto_alg_extsize);
+DEFINE_CRYPTO_API(crypto_alg_extsize);
 
-int crypto_type_has_alg(const char *name, const struct crypto_type *frontend,
+int CRYPTO_API(crypto_type_has_alg)(const char *name, const struct crypto_type *frontend,
 			u32 type, u32 mask)
 {
 	int ret = 0;
@@ -1096,7 +1096,7 @@ int crypto_type_has_alg(const char *name, const struct crypto_type *frontend,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(crypto_type_has_alg);
+DEFINE_CRYPTO_API(crypto_type_has_alg);
 
 static void __init crypto_start_tests(void)
 {
@@ -1166,8 +1166,8 @@ static void __exit crypto_algapi_exit(void)
  * We run this at late_initcall so that all the built-in algorithms
  * have had a chance to register themselves first.
  */
-late_initcall(crypto_algapi_init);
-module_exit(crypto_algapi_exit);
+crypto_late_initcall(crypto_algapi_init);
+crypto_module_exit(crypto_algapi_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Cryptographic algorithms API");
diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 3c3445523803..1c7907b5e1dc 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -223,3 +223,47 @@ DEFINE_CRYPTO_API_STUB(akcipher_register_instance);
 
 #endif
 
+/*
+ * crypto/algapi.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_ALGAPI2)
+
+#include <crypto/algapi.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_register_alg);
+DEFINE_CRYPTO_API_STUB(crypto_unregister_alg);
+DEFINE_CRYPTO_API_STUB(crypto_register_algs);
+DEFINE_CRYPTO_API_STUB(crypto_unregister_algs);
+DEFINE_CRYPTO_API_STUB(crypto_register_template);
+DEFINE_CRYPTO_API_STUB(crypto_register_templates);
+DEFINE_CRYPTO_API_STUB(crypto_unregister_template);
+DEFINE_CRYPTO_API_STUB(crypto_unregister_templates);
+DEFINE_CRYPTO_API_STUB(crypto_lookup_template);
+DEFINE_CRYPTO_API_STUB(crypto_register_instance);
+DEFINE_CRYPTO_API_STUB(crypto_unregister_instance);
+DEFINE_CRYPTO_API_STUB(crypto_grab_spawn);
+DEFINE_CRYPTO_API_STUB(crypto_drop_spawn);
+DEFINE_CRYPTO_API_STUB(crypto_spawn_tfm);
+DEFINE_CRYPTO_API_STUB(crypto_spawn_tfm2);
+DEFINE_CRYPTO_API_STUB(crypto_get_attr_type);
+DEFINE_CRYPTO_API_STUB(crypto_check_attr_type);
+DEFINE_CRYPTO_API_STUB(crypto_attr_alg_name);
+DEFINE_CRYPTO_API_STUB(__crypto_inst_setname);
+DEFINE_CRYPTO_API_STUB(crypto_init_queue);
+DEFINE_CRYPTO_API_STUB(crypto_enqueue_request);
+DEFINE_CRYPTO_API_STUB(crypto_enqueue_request_head);
+DEFINE_CRYPTO_API_STUB(crypto_dequeue_request);
+DEFINE_CRYPTO_API_STUB(crypto_inc);
+DEFINE_CRYPTO_API_STUB(crypto_register_notifier);
+DEFINE_CRYPTO_API_STUB(crypto_unregister_notifier);
+
+#include <crypto/internal.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_alg_tested);
+DEFINE_CRYPTO_API_STUB(crypto_remove_spawns);
+DEFINE_CRYPTO_API_STUB(crypto_remove_final);
+DEFINE_CRYPTO_API_STUB(crypto_alg_extsize);
+DEFINE_CRYPTO_API_STUB(crypto_type_has_alg);
+
+#endif
+
diff --git a/crypto/internal.h b/crypto/internal.h
index 1000ce8de06c..d823931fd0e2 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -8,6 +8,7 @@
 #ifndef _CRYPTO_INTERNAL_H
 #define _CRYPTO_INTERNAL_H
 
+#include <crypto/api.h>
 #include <crypto/algapi.h>
 #include <linux/completion.h>
 #include <linux/err.h>
@@ -114,11 +115,16 @@ struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask);
 
 struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask);
 void crypto_schedule_test(struct crypto_larval *larval);
-void crypto_alg_tested(struct crypto_alg *alg, int err);
-
-void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
-			  struct crypto_alg *nalg);
-void crypto_remove_final(struct list_head *list);
+DECLARE_CRYPTO_API(crypto_alg_tested, void,
+	(struct crypto_alg *alg, int err),
+	(alg, err));
+
+DECLARE_CRYPTO_API(crypto_remove_spawns, void,
+	(struct crypto_alg *alg, struct list_head *list, struct crypto_alg *nalg),
+	(alg, list, nalg));
+DECLARE_CRYPTO_API(crypto_remove_final, void,
+	(struct list_head *list),
+	(list));
 void crypto_shoot_alg(struct crypto_alg *alg);
 struct crypto_tfm *__crypto_alloc_tfmgfp(struct crypto_alg *alg, u32 type,
 					 u32 mask, gfp_t gfp);
@@ -151,10 +157,13 @@ static inline void *crypto_alloc_tfm(const char *alg_name,
 
 int crypto_probing_notify(unsigned long val, void *v);
 
-unsigned int crypto_alg_extsize(struct crypto_alg *alg);
+DECLARE_CRYPTO_API(crypto_alg_extsize, unsigned int,
+	(struct crypto_alg *alg),
+	(alg));
 
-int crypto_type_has_alg(const char *name, const struct crypto_type *frontend,
-			u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_type_has_alg, int,
+	(const char *name, const struct crypto_type *frontend, u32 type, u32 mask),
+	(name, frontend, type, mask));
 
 static inline struct crypto_alg *crypto_alg_get(struct crypto_alg *alg)
 {
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index fc4574940636..9d7505b7f029 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -7,6 +7,7 @@
 #ifndef _CRYPTO_ALGAPI_H
 #define _CRYPTO_ALGAPI_H
 
+#include <crypto/api.h>
 #include <crypto/utils.h>
 #include <linux/align.h>
 #include <linux/cache.h>
@@ -119,35 +120,69 @@ struct crypto_attr_type {
 /*
  * Algorithm registration interface.
  */
-int crypto_register_alg(struct crypto_alg *alg);
-void crypto_unregister_alg(struct crypto_alg *alg);
-int crypto_register_algs(struct crypto_alg *algs, int count);
-void crypto_unregister_algs(struct crypto_alg *algs, int count);
+DECLARE_CRYPTO_API(crypto_register_alg, int,
+	(struct crypto_alg *alg),
+	(alg));
+DECLARE_CRYPTO_API(crypto_unregister_alg, void,
+	(struct crypto_alg *alg),
+	(alg));
+DECLARE_CRYPTO_API(crypto_register_algs, int,
+	(struct crypto_alg *algs, int count),
+	(algs, count));
+DECLARE_CRYPTO_API(crypto_unregister_algs, void,
+	(struct crypto_alg *algs, int count),
+	(algs, count));
 
 void crypto_mod_put(struct crypto_alg *alg);
 
-int crypto_register_template(struct crypto_template *tmpl);
-int crypto_register_templates(struct crypto_template *tmpls, int count);
-void crypto_unregister_template(struct crypto_template *tmpl);
-void crypto_unregister_templates(struct crypto_template *tmpls, int count);
-struct crypto_template *crypto_lookup_template(const char *name);
-
-int crypto_register_instance(struct crypto_template *tmpl,
-			     struct crypto_instance *inst);
-void crypto_unregister_instance(struct crypto_instance *inst);
-
-int crypto_grab_spawn(struct crypto_spawn *spawn, struct crypto_instance *inst,
-		      const char *name, u32 type, u32 mask);
-void crypto_drop_spawn(struct crypto_spawn *spawn);
-struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
-				    u32 mask);
-void *crypto_spawn_tfm2(struct crypto_spawn *spawn);
-
-struct crypto_attr_type *crypto_get_attr_type(struct rtattr **tb);
-int crypto_check_attr_type(struct rtattr **tb, u32 type, u32 *mask_ret);
-const char *crypto_attr_alg_name(struct rtattr *rta);
-int __crypto_inst_setname(struct crypto_instance *inst, const char *name,
-			  const char *driver, struct crypto_alg *alg);
+DECLARE_CRYPTO_API(crypto_register_template, int,
+	(struct crypto_template *tmpl),
+	(tmpl));
+DECLARE_CRYPTO_API(crypto_register_templates, int,
+	(struct crypto_template *tmpls, int count),
+	(tmpls, count));
+DECLARE_CRYPTO_API(crypto_unregister_template, void,
+	(struct crypto_template *tmpl),
+	(tmpl));
+DECLARE_CRYPTO_API(crypto_unregister_templates, void,
+	(struct crypto_template *tmpls, int count),
+	(tmpls, count));
+DECLARE_CRYPTO_API(crypto_lookup_template, struct crypto_template *,
+	(const char *name),
+	(name));
+
+DECLARE_CRYPTO_API(crypto_register_instance, int,
+	(struct crypto_template *tmpl, struct crypto_instance *inst),
+	(tmpl, inst));
+DECLARE_CRYPTO_API(crypto_unregister_instance, void,
+	(struct crypto_instance *inst),
+	(inst));
+
+DECLARE_CRYPTO_API(crypto_grab_spawn, int,
+	(struct crypto_spawn *spawn, struct crypto_instance *inst, const char *name, u32 type, u32 mask),
+	(spawn, inst, name, type, mask));
+DECLARE_CRYPTO_API(crypto_drop_spawn, void,
+	(struct crypto_spawn *spawn),
+	(spawn));
+DECLARE_CRYPTO_API(crypto_spawn_tfm, struct crypto_tfm *,
+	(struct crypto_spawn *spawn, u32 type, u32 mask),
+	(spawn, type, mask));
+DECLARE_CRYPTO_API(crypto_spawn_tfm2, void *,
+	(struct crypto_spawn *spawn),
+	(spawn));
+
+DECLARE_CRYPTO_API(crypto_get_attr_type, struct crypto_attr_type *,
+	(struct rtattr **tb),
+	(tb));
+DECLARE_CRYPTO_API(crypto_check_attr_type, int,
+	(struct rtattr **tb, u32 type, u32 *mask_ret),
+	(tb, type, mask_ret));
+DECLARE_CRYPTO_API(crypto_attr_alg_name, const char *,
+	(struct rtattr *rta),
+	(rta));
+DECLARE_CRYPTO_API(__crypto_inst_setname, int,
+	(struct crypto_instance *inst, const char *name, const char *driver, struct crypto_alg *alg),
+	(inst, name, driver, alg));
 
 #define crypto_inst_setname(inst, name, ...) \
 	CONCATENATE(crypto_inst_setname_, COUNT_ARGS(__VA_ARGS__))( \
@@ -157,18 +192,26 @@ int __crypto_inst_setname(struct crypto_instance *inst, const char *name,
 #define crypto_inst_setname_2(inst, name, driver, alg) \
 	__crypto_inst_setname(inst, name, driver, alg)
 
-void crypto_init_queue(struct crypto_queue *queue, unsigned int max_qlen);
-int crypto_enqueue_request(struct crypto_queue *queue,
-			   struct crypto_async_request *request);
-void crypto_enqueue_request_head(struct crypto_queue *queue,
-				 struct crypto_async_request *request);
-struct crypto_async_request *crypto_dequeue_request(struct crypto_queue *queue);
+DECLARE_CRYPTO_API(crypto_init_queue, void,
+	(struct crypto_queue *queue, unsigned int max_qlen),
+	(queue, max_qlen));
+DECLARE_CRYPTO_API(crypto_enqueue_request, int,
+	(struct crypto_queue *queue, struct crypto_async_request *request),
+	(queue, request));
+DECLARE_CRYPTO_API(crypto_enqueue_request_head, void,
+	(struct crypto_queue *queue, struct crypto_async_request *request),
+	(queue, request));
+DECLARE_CRYPTO_API(crypto_dequeue_request, struct crypto_async_request *,
+	(struct crypto_queue *queue),
+	(queue));
 static inline unsigned int crypto_queue_len(struct crypto_queue *queue)
 {
 	return queue->qlen;
 }
 
-void crypto_inc(u8 *a, unsigned int size);
+DECLARE_CRYPTO_API(crypto_inc, void,
+	(u8 *a, unsigned int size),
+	(a, size));
 
 static inline void *crypto_tfm_ctx(struct crypto_tfm *tfm)
 {
@@ -242,8 +285,12 @@ static inline u32 crypto_algt_inherited_mask(struct crypto_attr_type *algt)
 	return crypto_requires_off(algt, CRYPTO_ALG_INHERITED_FLAGS);
 }
 
-int crypto_register_notifier(struct notifier_block *nb);
-int crypto_unregister_notifier(struct notifier_block *nb);
+DECLARE_CRYPTO_API(crypto_register_notifier, int,
+	(struct notifier_block *nb),
+	(nb));
+DECLARE_CRYPTO_API(crypto_unregister_notifier, int,
+	(struct notifier_block *nb),
+	(nb));
 
 /* Crypto notification events. */
 enum {
-- 
2.39.3

