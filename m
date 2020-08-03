Return-Path: <SRS0=sEgb=BN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10DDAC433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Aug 2020 07:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC7A52072A
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Aug 2020 07:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbgHCH7r (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Aug 2020 03:59:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:45602 "EHLO
        mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgHCH7q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Aug 2020 03:59:46 -0400
Received: from ALA-HCB.corp.ad.wrs.com (ala-hcb.corp.ad.wrs.com [147.11.189.41])
        by mail.windriver.com (8.15.2/8.15.2) with ESMTPS id 0737xK0d029246
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Mon, 3 Aug 2020 00:59:21 -0700 (PDT)
Received: from pek-lpggp3.wrs.com (128.224.153.76) by ALA-HCB.corp.ad.wrs.com
 (147.11.189.41) with Microsoft SMTP Server id 14.3.487.0; Mon, 3 Aug 2020
 00:59:01 -0700
From:   Liwei Song <liwei.song@windriver.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <liwei.song@windriver.com>
Subject: [PATCH] crypto: ccp - zero the cmd data after use it
Date:   Mon, 3 Aug 2020 15:58:58 +0800
Message-ID: <20200803075858.3561-1-liwei.song@windriver.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

exist the following assignment in ccp(ignore the force
convert of the struct) by list_del in ccp_dequeue_cmd():
req->__ctx->cmd->entry->next = LIST_POISON1;

after use the req, kzfree(req) can not zero the entry
entry->next = LIST_POISON1 of the ccp_cmd(cmd) struct
when this address available as slub freelist pointer, this will cause
the following "general protection fault" error if some process meet
this LIST_POISON1 value address when request memory:

general protection fault: 0000 1 PREEMPT SMP NOPTI
CPU: 13 PID: 111282 Comm: msgstress03 Not tainted 5.2.45-yocto-standard #1
Hardware name: AMD Corporation Wallaby/Wallaby, BIOS WWB7713N 07/11/2017
RIP: 0010:__kmalloc_node+0x106/0x2f0
RSP: 0018:ffffaa6dd83ffdc8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000033e0cd
RDX: 000000000033e08d RSI: 000000000033e08d RDI: 000000000002c180
RBP: ffffaa6dd83ffe00 R08: 00000000000000d4 R09: ffff966c9dc07180
R10: dead000000000100 R11: 0000000000000000 R12: 0000000000000cc0
R13: 0000000000000100 R14: 00000000ffffffff R15: ffff966c9dc07180
FS: 00007f83bb756600(0000) GS:ffff966c9e340000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f83bb6917e0 CR3: 000000080b794000 CR4: 00000000003406e0
Call Trace:
? kvmalloc_node+0x7b/0x90
kvmalloc_node+0x7b/0x90
newque+0x32/0x1a0
ipcget+0x27a/0x2c0
ksys_msgget+0x51/0x70
__x64_sys_msgget+0x16/0x20
do_syscall_64+0x4d/0x130
entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f83bb6917e7

Fix it by zero cmd struct after finished use it.

Signed-off-by: Liwei Song <liwei.song@windriver.com>
---
 drivers/crypto/ccp/ccp-dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index edefa669153f..75a6418d541d 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -409,6 +409,7 @@ static void ccp_do_cmd_complete(unsigned long data)
 	cmd->callback(cmd->data, cmd->ret);
 
 	complete(&tdata->completion);
+	memset(cmd, 0, sizeof(*cmd));
 }
 
 /**
-- 
2.17.1

