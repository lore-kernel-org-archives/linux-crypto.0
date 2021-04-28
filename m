Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C008CC433ED
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Apr 2021 07:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E5B6613F3
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Apr 2021 07:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhD1HeZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:34:25 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:44646 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbhD1HeY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Apr 2021 03:34:24 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d41 with ME
        id y7Zf2400A21Fzsu037ZfFS; Wed, 28 Apr 2021 09:33:39 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 28 Apr 2021 09:33:39 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     gcherian@marvell.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] crypto: cavium - Use 'hlist_for_each_entry' to simplify code
Date:   Wed, 28 Apr 2021 09:33:37 +0200
Message-Id: <5a7692aa1d2ffb81e981fdf87b060db7e55956b8.1619593010.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use 'hlist_for_each_entry' instead of hand writing it.
This saves a few lines of code.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only
---
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
index 4fe7898c8561..feb0f76783dd 100644
--- a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
+++ b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
@@ -244,11 +244,7 @@ static int send_cpt_command(struct cpt_vf *cptvf, union cpt_inst_s *cmd,
 	memcpy(ent, (void *)cmd, qinfo->cmd_size);
 
 	if (++queue->idx >= queue->qhead->size / 64) {
-		struct hlist_node *node;
-
-		hlist_for_each(node, &queue->chead) {
-			chunk = hlist_entry(node, struct command_chunk,
-					    nextchunk);
+		hlist_for_each_entry(chunk, &queue->chead, nextchunk) {
 			if (chunk == queue->qhead) {
 				continue;
 			} else {
-- 
2.30.2

