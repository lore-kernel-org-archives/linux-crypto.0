Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8041C6FA8F
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Aug 2023 18:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240246AbjH3SoO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242297AbjH3HzD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Aug 2023 03:55:03 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC99193
        for <linux-crypto@vger.kernel.org>; Wed, 30 Aug 2023 00:54:59 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RbGjV64ZnzVkWn;
        Wed, 30 Aug 2023 15:52:30 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemi500008.china.huawei.com
 (7.221.188.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Wed, 30 Aug
 2023 15:54:56 +0800
From:   Jinjie Ruan <ruanjinjie@huawei.com>
To:     <qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
        <damian.muszynski@intel.com>, <andriy.shevchenko@linux.intel.com>,
        <shashank.gupta@intel.com>, <tom.zanussi@linux.intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     <ruanjinjie@huawei.com>
Subject: [PATCH -next] crypto: qat - Use list_for_each_entry() helper
Date:   Wed, 30 Aug 2023 15:54:51 +0800
Message-ID: <20230830075451.293379-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert list_for_each() to list_for_each_entry() so that the list_itr
list_head pointer and list_entry() call are no longer needed, which
can reduce a few lines of code. No functional changed.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 .../crypto/intel/qat/qat_common/adf_init.c    | 24 +++++--------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index 89001fe92e76..79a81e25de97 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -61,7 +61,6 @@ int adf_service_unregister(struct service_hndl *service)
 static int adf_dev_init(struct adf_accel_dev *accel_dev)
 {
 	struct service_hndl *service;
-	struct list_head *list_itr;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	int ret;
 
@@ -137,8 +136,7 @@ static int adf_dev_init(struct adf_accel_dev *accel_dev)
 	 * This is to facilitate any ordering dependencies between services
 	 * prior to starting any of the accelerators.
 	 */
-	list_for_each(list_itr, &service_table) {
-		service = list_entry(list_itr, struct service_hndl, list);
+	list_for_each_entry(service, &service_table, list) {
 		if (service->event_hld(accel_dev, ADF_EVENT_INIT)) {
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to initialise service %s\n",
@@ -165,7 +163,6 @@ static int adf_dev_start(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct service_hndl *service;
-	struct list_head *list_itr;
 	int ret;
 
 	set_bit(ADF_STATUS_STARTING, &accel_dev->status);
@@ -209,8 +206,7 @@ static int adf_dev_start(struct adf_accel_dev *accel_dev)
 
 	adf_heartbeat_start(accel_dev);
 
-	list_for_each(list_itr, &service_table) {
-		service = list_entry(list_itr, struct service_hndl, list);
+	list_for_each_entry(service, &service_table, list) {
 		if (service->event_hld(accel_dev, ADF_EVENT_START)) {
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to start service %s\n",
@@ -259,7 +255,6 @@ static void adf_dev_stop(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct service_hndl *service;
-	struct list_head *list_itr;
 	bool wait = false;
 	int ret;
 
@@ -280,8 +275,7 @@ static void adf_dev_stop(struct adf_accel_dev *accel_dev)
 	if (!list_empty(&accel_dev->compression_list))
 		qat_comp_algs_unregister();
 
-	list_for_each(list_itr, &service_table) {
-		service = list_entry(list_itr, struct service_hndl, list);
+	list_for_each_entry(service, &service_table, list) {
 		if (!test_bit(accel_dev->accel_id, service->start_status))
 			continue;
 		ret = service->event_hld(accel_dev, ADF_EVENT_STOP);
@@ -318,7 +312,6 @@ static void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct service_hndl *service;
-	struct list_head *list_itr;
 
 	if (!hw_data) {
 		dev_err(&GET_DEV(accel_dev),
@@ -340,8 +333,7 @@ static void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 				  &accel_dev->status);
 	}
 
-	list_for_each(list_itr, &service_table) {
-		service = list_entry(list_itr, struct service_hndl, list);
+	list_for_each_entry(service, &service_table, list) {
 		if (!test_bit(accel_dev->accel_id, service->init_status))
 			continue;
 		if (service->event_hld(accel_dev, ADF_EVENT_SHUTDOWN))
@@ -378,10 +370,8 @@ static void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 int adf_dev_restarting_notify(struct adf_accel_dev *accel_dev)
 {
 	struct service_hndl *service;
-	struct list_head *list_itr;
 
-	list_for_each(list_itr, &service_table) {
-		service = list_entry(list_itr, struct service_hndl, list);
+	list_for_each_entry(service, &service_table, list) {
 		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTING))
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to restart service %s.\n",
@@ -393,10 +383,8 @@ int adf_dev_restarting_notify(struct adf_accel_dev *accel_dev)
 int adf_dev_restarted_notify(struct adf_accel_dev *accel_dev)
 {
 	struct service_hndl *service;
-	struct list_head *list_itr;
 
-	list_for_each(list_itr, &service_table) {
-		service = list_entry(list_itr, struct service_hndl, list);
+	list_for_each_entry(service, &service_table, list) {
 		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTED))
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to restart service %s.\n",
-- 
2.34.1

