Return-Path: <SRS0=HUI/=VJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CADD8C742B0
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jul 2019 09:00:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F7F321670
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jul 2019 09:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfGLI75 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Jul 2019 04:59:57 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:38493 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbfGLI75 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jul 2019 04:59:57 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1N4Qbu-1iVbzR3VIc-011OpO; Fri, 12 Jul 2019 10:59:39 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH] crypto: ccp - Reduce maximum stack usage
Date:   Fri, 12 Jul 2019 10:59:24 +0200
Message-Id: <20190712085937.4157934-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Kt7iHIJWTD2G3ZP7f3E2Ekz43XUmhSis8pfRbUBqvqmKY1ev+bq
 B2vyuXP2z+t/wzjoOMQfdx/a5aAbVb1khAMxuQDdLE4LtpQZsATlljn8YdzVvN8cGyRLyRj
 P9QXaanE1g63g6FjIdW8gZ2mOah9QbmWbwmx3u7lPjt/8ePhbMx/FSG6FffXIJiRBTR6gdu
 fRXmal2pdtKLGdS8kG7Iw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:CCo7Fc+q2h0=:rfuJA/iKw/fHc5K6vbfK8J
 1AUtVqIpCK2SL5xZXEhEhv1BEjU5DBfTaSJHJ6vEaRGUfmFIIt5fdbbopMI9oqzC6Nevqta2P
 1O2sAVw3J/vqEFosukHdcY9VugwyugamnGy456/W28KlJyqm1jzqCTubTch/3F1cJNHLtc9AN
 ap8nCHddNgrozLpIk9pXvh6rBvtdjVRvctTQ3Rw+dYTmV2DiR5yEIwyzkrJpuwkS2AEt3CZP4
 T4dJBe2TC2xLpLbFh96a/U73I3FMHsWlkOCR7w9q0Xa/zp8kYLFmShVPtQW0QMgTrOm9J1KP2
 RwpOqVB6JZ1uF/OYYHO1232/6DVjM6pJI7+piiXKejBi90V37IiXDpOxqKz8UlywQqczBQo+l
 JaL5pAaRWRRqgADATUukNYBl9VpU9naN5BsbrBoB2epp1NY2hDusbUR+6ztp4YYSr0vc/FQ56
 gkUlMpO00mZYz23fOOmErPi4JE5C9ZZw/MQSReS7CZ0kx+VXAWrDa3Rl4xANHPq21Bx5VqQo4
 gkE4aYZjZhg1lHQZuPiXTBSsElcPD0il6BNfYHG38ioUhEv34kg4q/Ydb/eoQLuOXCJftfcrF
 skgn2ypCCTIIw7o0Zye3YZAnKCYLAtBaKYOrH+imxGgm4Z1fIjrO9RvyTTDSegHneO20c6xKv
 N/M0Px853cuFYqfS0WvwnehnMYxd6tWFgeQl/HHN1sOnoCnIehYNkDxWT1jTJgFrumjNsCZ47
 uLQH0waVFB/+nu5jp6MhZgFf2QahwPIOn+dkgg==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Each of the operations in ccp_run_cmd() needs several hundred
bytes of kernel stack. Depending on the inlining, these may
need separate stack slots that add up to more than the warning
limit, as shown in this clang based build:

drivers/crypto/ccp/ccp-ops.c:871:12: error: stack frame size of 1164 bytes in function 'ccp_run_aes_cmd' [-Werror,-Wframe-larger-than=]
static int ccp_run_aes_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)

The problem may also happen when there is no warning, e.g. in the
ccp_run_cmd()->ccp_run_aes_cmd()->ccp_run_aes_gcm_cmd() call chain with
over 2000 bytes.

Mark each individual function as 'noinline_for_stack' to prevent
this from happening, and move the calls to the two special cases for aes
into the top-level function. This will keep the actual combined stack
usage to the mimimum: 828 bytes for ccp_run_aes_gcm_cmd() and
at most 524 bytes for each of the other cases.

Fixes: 63b945091a07 ("crypto: ccp - CCP device driver and interface support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/ccp/ccp-ops.c | 52 +++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 866b2e05ca77..97293d05a759 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -455,8 +455,8 @@ static int ccp_copy_from_sb(struct ccp_cmd_queue *cmd_q,
 	return ccp_copy_to_from_sb(cmd_q, wa, jobid, sb, byte_swap, true);
 }
 
-static int ccp_run_aes_cmac_cmd(struct ccp_cmd_queue *cmd_q,
-				struct ccp_cmd *cmd)
+static noinline_for_stack int
+ccp_run_aes_cmac_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 {
 	struct ccp_aes_engine *aes = &cmd->u.aes;
 	struct ccp_dm_workarea key, ctx;
@@ -611,8 +611,8 @@ static int ccp_run_aes_cmac_cmd(struct ccp_cmd_queue *cmd_q,
 	return ret;
 }
 
-static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q,
-			       struct ccp_cmd *cmd)
+static noinline_for_stack int
+ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 {
 	struct ccp_aes_engine *aes = &cmd->u.aes;
 	struct ccp_dm_workarea key, ctx, final_wa, tag;
@@ -868,7 +868,8 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q,
 	return ret;
 }
 
-static int ccp_run_aes_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+static noinline_for_stack int
+ccp_run_aes_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 {
 	struct ccp_aes_engine *aes = &cmd->u.aes;
 	struct ccp_dm_workarea key, ctx;
@@ -878,12 +879,6 @@ static int ccp_run_aes_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	bool in_place = false;
 	int ret;
 
-	if (aes->mode == CCP_AES_MODE_CMAC)
-		return ccp_run_aes_cmac_cmd(cmd_q, cmd);
-
-	if (aes->mode == CCP_AES_MODE_GCM)
-		return ccp_run_aes_gcm_cmd(cmd_q, cmd);
-
 	if (!((aes->key_len == AES_KEYSIZE_128) ||
 	      (aes->key_len == AES_KEYSIZE_192) ||
 	      (aes->key_len == AES_KEYSIZE_256)))
@@ -1050,8 +1045,8 @@ static int ccp_run_aes_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	return ret;
 }
 
-static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
-			       struct ccp_cmd *cmd)
+static noinline_for_stack int
+ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 {
 	struct ccp_xts_aes_engine *xts = &cmd->u.xts;
 	struct ccp_dm_workarea key, ctx;
@@ -1250,7 +1245,8 @@ static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
 	return ret;
 }
 
-static int ccp_run_des3_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+static noinline_for_stack int
+ccp_run_des3_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 {
 	struct ccp_des3_engine *des3 = &cmd->u.des3;
 
@@ -1446,7 +1442,8 @@ static int ccp_run_des3_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	return ret;
 }
 
-static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+static noinline_for_stack int
+ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 {
 	struct ccp_sha_engine *sha = &cmd->u.sha;
 	struct ccp_dm_workarea ctx;
@@ -1790,7 +1787,8 @@ static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	return ret;
 }
 
-static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+static noinline_for_stack int
+ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 {
 	struct ccp_rsa_engine *rsa = &cmd->u.rsa;
 	struct ccp_dm_workarea exp, src, dst;
@@ -1921,8 +1919,8 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	return ret;
 }
 
-static int ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q,
-				struct ccp_cmd *cmd)
+static noinline_for_stack int
+ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 {
 	struct ccp_passthru_engine *pt = &cmd->u.passthru;
 	struct ccp_dm_workarea mask;
@@ -2053,7 +2051,8 @@ static int ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q,
 	return ret;
 }
 
-static int ccp_run_passthru_nomap_cmd(struct ccp_cmd_queue *cmd_q,
+static noinline_for_stack int
+ccp_run_passthru_nomap_cmd(struct ccp_cmd_queue *cmd_q,
 				      struct ccp_cmd *cmd)
 {
 	struct ccp_passthru_nomap_engine *pt = &cmd->u.passthru_nomap;
@@ -2394,7 +2393,8 @@ static int ccp_run_ecc_pm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	return ret;
 }
 
-static int ccp_run_ecc_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+static noinline_for_stack int
+ccp_run_ecc_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 {
 	struct ccp_ecc_engine *ecc = &cmd->u.ecc;
 
@@ -2431,7 +2431,17 @@ int ccp_run_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 
 	switch (cmd->engine) {
 	case CCP_ENGINE_AES:
-		ret = ccp_run_aes_cmd(cmd_q, cmd);
+		switch (cmd->u.aes.mode) {
+		case CCP_AES_MODE_CMAC:
+			ret = ccp_run_aes_cmac_cmd(cmd_q, cmd);
+			break;
+		case CCP_AES_MODE_GCM:
+			ret = ccp_run_aes_gcm_cmd(cmd_q, cmd);
+			break;
+		default:
+			ret = ccp_run_aes_cmd(cmd_q, cmd);
+			break;
+		}
 		break;
 	case CCP_ENGINE_XTS_AES_128:
 		ret = ccp_run_xts_aes_cmd(cmd_q, cmd);
-- 
2.20.0

