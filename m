Received: from smtp.smtpout.orange.fr (smtp-22.smtpout.orange.fr [80.12.242.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21990231C94;
	Mon, 14 Oct 2024 20:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728937762; cv=none; b=tNft9clRzcctuQsDn/W/23+tA9for6jUedHEGhVwg7NnDcchbRonlZOBoEP7Uhlp2ORtaFck9yhfsJW+XHz+QBTZ4N5JBVNBxPLRDBof1dMfgq4lbFpB6hjyQEWteV43y4H8WBLqQzTd2WiTc7M06F4Ffzktm2Q5c6L4/NrDKKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728937762; c=relaxed/simple;
	bh=XaDIO2IuND1/j9idtykS1sX9MRhoJ+szidhKrSx3ems=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UCaIh/Q3qZU8ixF2+TAKskc/ctdosHzbwXN/VLQVDsNSNNWqGOnmKWhgraS/e+5K2abTDQTOuMQA7RT9UcjmM+/Zmpr8olxoIqvygTntK9VFYkNfBom7i5XxMLjauN+SoiIdb4yvLijLpQ8wVsymWgQ8Ll7+wPx0vkhFxzC+HUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=ryKw7AOS; arc=none smtp.client-ip=80.12.242.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="ryKw7AOS"
Received: from localhost.localdomain ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id 0RA7t2ZE7WNPK0RA7tHNhp; Mon, 14 Oct 2024 21:55:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1728935735;
	bh=hD0vo8WyvWoRZVSSpg8GQUmRbzOmqsIeAIrHbUQl8aQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=ryKw7AOSpn/wl0TBFALbQKCMzujsKExflrgTqF7ZEXTsrRCAQTl5s4ZqIibRF7uah
	 C9ngNMq+wfQW+1s2zt15bLZH3gZTh1JlqP3ZCnt+KrY5GIkPX2tQPcBniGngQ2xVrf
	 /dIu/+1+I61yHh8GDcg0Yd6doVt4Wr7sgk9aV5O5/Fii2hjCyQ+IZ33M7vDxlcnNmU
	 fKvcRscxKLhS10cDzWqFKcgI5/Yxuzk4Udx2CB+YB2+Q3DQAvkylsBVp5BVs4haXFU
	 6yS/MXpVKXIGyhXIb/xFcfz1uFte4pUs43gcsK4lQ+nmwQdYWgYHbHipK24aYeJkPp
	 A2XVNxVOQngYg==
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 14 Oct 2024 21:55:35 +0200
X-ME-IP: 90.11.132.44
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	qat-linux@intel.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: qat - Constify struct pm_status_row
Date: Mon, 14 Oct 2024 21:55:17 +0200
Message-ID: <ab26d264baec1f3233e832c0c2fa723e3be21a04.1728935687.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'struct pm_status_row' are not modified in this driver.

Constifying this structure moves some data to a read-only section, so
increases overall security.

Update the prototype of some functions accordingly.

On a x86_64, with allmodconfig, as an example:
Before:
======
   text	   data	    bss	    dec	    hex	filename
   4400	   1059	      0	   5459	   1553	drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
   5216	    243	      0	   5459	   1553	drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only.
---
 .../intel/qat/qat_common/adf_gen4_pm_debugfs.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c
index ee0b5079de3e..2e4095c4c12c 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c
@@ -42,13 +42,13 @@ struct pm_status_row {
 	const char *key;
 };
 
-static struct pm_status_row pm_fuse_rows[] = {
+static const struct pm_status_row pm_fuse_rows[] = {
 	PM_INFO_REGSET_ENTRY(fusectl0, ENABLE_PM),
 	PM_INFO_REGSET_ENTRY(fusectl0, ENABLE_PM_IDLE),
 	PM_INFO_REGSET_ENTRY(fusectl0, ENABLE_DEEP_PM_IDLE),
 };
 
-static struct pm_status_row pm_info_rows[] = {
+static const struct pm_status_row pm_info_rows[] = {
 	PM_INFO_REGSET_ENTRY(pm.status, CPM_PM_STATE),
 	PM_INFO_REGSET_ENTRY(pm.status, PENDING_WP),
 	PM_INFO_REGSET_ENTRY(pm.status, CURRENT_WP),
@@ -59,7 +59,7 @@ static struct pm_status_row pm_info_rows[] = {
 	PM_INFO_REGSET_ENTRY(pm.main, THR_VALUE),
 };
 
-static struct pm_status_row pm_ssm_rows[] = {
+static const struct pm_status_row pm_ssm_rows[] = {
 	PM_INFO_REGSET_ENTRY(ssm.pm_enable, SSM_PM_ENABLE),
 	PM_INFO_REGSET_ENTRY32(ssm.active_constraint, ACTIVE_CONSTRAINT),
 	PM_INFO_REGSET_ENTRY(ssm.pm_domain_status, DOMAIN_POWER_GATED),
@@ -83,7 +83,7 @@ static struct pm_status_row pm_ssm_rows[] = {
 	PM_INFO_REGSET_ENTRY(ssm.pm_managed_status, WCP_MANAGED_COUNT),
 };
 
-static struct pm_status_row pm_log_rows[] = {
+static const struct pm_status_row pm_log_rows[] = {
 	PM_INFO_REGSET_ENTRY32(event_counters.host_msg, HOST_MSG_EVENT_COUNT),
 	PM_INFO_REGSET_ENTRY32(event_counters.sys_pm, SYS_PM_EVENT_COUNT),
 	PM_INFO_REGSET_ENTRY32(event_counters.local_ssm, SSM_EVENT_COUNT),
@@ -91,7 +91,7 @@ static struct pm_status_row pm_log_rows[] = {
 	PM_INFO_REGSET_ENTRY32(event_counters.unknown, UNKNOWN_EVENT_COUNT),
 };
 
-static struct pm_status_row pm_event_rows[ICP_QAT_NUMBER_OF_PM_EVENTS] = {
+static const struct pm_status_row pm_event_rows[ICP_QAT_NUMBER_OF_PM_EVENTS] = {
 	PM_INFO_REGSET_ENTRY32(event_log[0], EVENT0),
 	PM_INFO_REGSET_ENTRY32(event_log[1], EVENT1),
 	PM_INFO_REGSET_ENTRY32(event_log[2], EVENT2),
@@ -102,14 +102,14 @@ static struct pm_status_row pm_event_rows[ICP_QAT_NUMBER_OF_PM_EVENTS] = {
 	PM_INFO_REGSET_ENTRY32(event_log[7], EVENT7),
 };
 
-static struct pm_status_row pm_csrs_rows[] = {
+static const struct pm_status_row pm_csrs_rows[] = {
 	PM_INFO_REGSET_ENTRY32(pm.fw_init, CPM_PM_FW_INIT),
 	PM_INFO_REGSET_ENTRY32(pm.status, CPM_PM_STATUS),
 	PM_INFO_REGSET_ENTRY32(pm.main, CPM_PM_MASTER_FW),
 	PM_INFO_REGSET_ENTRY32(pm.pwrreq, CPM_PM_PWRREQ),
 };
 
-static int pm_scnprint_table(char *buff, struct pm_status_row *table,
+static int pm_scnprint_table(char *buff, const struct pm_status_row *table,
 			     u32 *pm_info_regs, size_t buff_size, int table_len,
 			     bool lowercase)
 {
@@ -131,7 +131,7 @@ static int pm_scnprint_table(char *buff, struct pm_status_row *table,
 	return wr;
 }
 
-static int pm_scnprint_table_upper_keys(char *buff, struct pm_status_row *table,
+static int pm_scnprint_table_upper_keys(char *buff, const struct pm_status_row *table,
 					u32 *pm_info_regs, size_t buff_size,
 					int table_len)
 {
@@ -139,7 +139,7 @@ static int pm_scnprint_table_upper_keys(char *buff, struct pm_status_row *table,
 				 table_len, false);
 }
 
-static int pm_scnprint_table_lower_keys(char *buff, struct pm_status_row *table,
+static int pm_scnprint_table_lower_keys(char *buff, const struct pm_status_row *table,
 					u32 *pm_info_regs, size_t buff_size,
 					int table_len)
 {
-- 
2.47.0

