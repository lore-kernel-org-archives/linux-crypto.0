Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8157C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7327F64F00
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbhBXQcL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:32:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35307 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234450AbhBXQbF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Feb 2021 11:31:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614184177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CaIS24TekHR2zlXKqWJ9Ayyago1O42H+gYPmc+HqgA8=;
        b=S7FOgFpVwsfxQg0M9Aw4WaWEEKxps2eApXqf/ORUUkQnZOAoATB/xriP6oQhd9BB5TBUkQ
        VYH3tegLfdE1Qg216F0gaVWPCfEGIJHrL2lARHS1dN7sFqyNgOPoXv2XfkkEMbA9UUaBb/
        tw5QnpM8yyKiWsNExKLzl0QSwJZRDsE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-XwQRX8d2P0avaRtWUQawiA-1; Wed, 24 Feb 2021 11:29:35 -0500
X-MC-Unique: XwQRX8d2P0avaRtWUQawiA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83531803F47;
        Wed, 24 Feb 2021 16:29:33 +0000 (UTC)
Received: from treble.redhat.com (ovpn-118-134.rdu2.redhat.com [10.10.118.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49D7260862;
        Wed, 24 Feb 2021 16:29:32 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 01/13] objtool: Support asm jump tables
Date:   Wed, 24 Feb 2021 10:29:14 -0600
Message-Id: <460cf4dc675d64e1124146562cabd2c05aa322e8.1614182415.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1614182415.git.jpoimboe@redhat.com>
References: <cover.1614182415.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Objtool detection of asm jump tables would normally just work, except
for the fact that asm retpolines use alternatives.  Objtool thinks the
alternative code path (a jump to the retpoline) is a sibling call.

Don't treat alternative indirect branches as sibling calls when the
original instruction has a jump table.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 tools/objtool/check.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 080a3d6cbd75..f95e406296f5 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -108,6 +108,18 @@ static struct instruction *prev_insn_same_sym(struct objtool_file *file,
 	for (insn = next_insn_same_sec(file, insn); insn;		\
 	     insn = next_insn_same_sec(file, insn))
 
+static bool is_jump_table_jump(struct instruction *insn)
+{
+	struct alt_group *alt_group = insn->alt_group;
+
+	if (insn->jump_table)
+		return true;
+
+	/* Retpoline alternative for a jump table? */
+	return alt_group && alt_group->orig_group &&
+	       alt_group->orig_group->first_insn->jump_table;
+}
+
 static bool is_sibling_call(struct instruction *insn)
 {
 	/*
@@ -120,7 +132,7 @@ static bool is_sibling_call(struct instruction *insn)
 
 	/* An indirect jump is either a sibling call or a jump to a table. */
 	if (insn->type == INSN_JUMP_DYNAMIC)
-		return list_empty(&insn->alts);
+		return !is_jump_table_jump(insn);
 
 	/* add_jump_destinations() sets insn->call_dest for sibling calls. */
 	return (is_static_jump(insn) && insn->call_dest);
-- 
2.29.2

