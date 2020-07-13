Return-Path: <SRS0=38jD=AY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE38C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 14:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB363206F0
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 14:06:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GhgqetfW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbgGMOGs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jul 2020 10:06:48 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49238 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729523AbgGMOGr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jul 2020 10:06:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594649205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=cVAnTWhIdLYJKO73w7wojsiljd9+XyaexVrW7ZP7+wg=;
        b=GhgqetfW59uUU9KakIrfnYgQaCPzXIrK+ArUXwMnCjWQcbaHjju+Uj3StNaERXki7Sqwi6
        QqqDfsWDXa3gSDBiJ19eVVJKEHyTZsJb97TwclLIf/W6uFBbO5XSi0xw3HFCoJc6D2xNMM
        VuFsiuBfGcCK5akFO0fpM/pn+NIVZ+0=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-P3R7TGsMMDWoquXiqKFTrA-1; Mon, 13 Jul 2020 10:06:44 -0400
X-MC-Unique: P3R7TGsMMDWoquXiqKFTrA-1
Received: by mail-qt1-f197.google.com with SMTP id a52so10180632qtk.22
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2020 07:06:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cVAnTWhIdLYJKO73w7wojsiljd9+XyaexVrW7ZP7+wg=;
        b=dLGVqeAU7WBEc6hQpF0bRFSE49f1D/3Oq/9z2FG9KOn0vZ6ciqRnog/oFQykxVwq8f
         I+JboRzfdJKruJZ+95W8VjFU1RxfaMv2BKJYbA9oCp3/55ikxXGDIJZsLT6+lAOP6v7c
         6/fomBGkvF+Kgonf5nh8PqEegqy0awxk/OvDB1n85ZMLt9Sco9pfs//uPXrtZpMbBcVN
         hjApHxtWd5EI60lew3/5ZHAF2QrRE6lg4x312TTIE62LRDv6q0kTK/gVmw6BQUwlMmuL
         ElO5ayDLOz/BCDttJawzWRLn3mQlpBqFQlthVBeTFbDjxxU0AbL7LZ85n/fDqrgWMHxP
         Rbtg==
X-Gm-Message-State: AOAM5318qfOcz0OdObc0u/1K6bx/8LinosPqU+IIoiI3x7PmQ9+GN0mp
        5PmqWSlx4/D7fFjqb/XRX6rCG33wvnu0BTKuaOaajFVuZ1D1AYAQidolWioX1u8iEgkDVS4nv38
        +Nl1PUnI5nk4+12Cr0hdwonZl
X-Received: by 2002:ad4:57c3:: with SMTP id y3mr61518411qvx.38.1594649203768;
        Mon, 13 Jul 2020 07:06:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzc2v24kRRcIx9iU41389LXjIqZiB59Sm2o0YB8K6V71/qbHAgcbnd4J0M72wpearx39vRRHA==
X-Received: by 2002:ad4:57c3:: with SMTP id y3mr61518386qvx.38.1594649203525;
        Mon, 13 Jul 2020 07:06:43 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id m4sm20218627qtf.43.2020.07.13.07.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 07:06:42 -0700 (PDT)
From:   trix@redhat.com
To:     giovanni.cabiddu@intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, wojciech.ziemba@intel.com,
        karen.xiang@intel.com, bruce.w.allan@intel.com, bo.cui@intel.com,
        pingchaox.yang@intel.com
Cc:     qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] crypto: qat: fix double free in qat_uclo_create_batch_init_list
Date:   Mon, 13 Jul 2020 07:06:34 -0700
Message-Id: <20200713140634.14730-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tom Rix <trix@redhat.com>

clang static analysis flags this error

qat_uclo.c:297:3: warning: Attempt to free released memory
  [unix.Malloc]
                kfree(*init_tab_base);
                ^~~~~~~~~~~~~~~~~~~~~

When input *init_tab_base is null, the function allocates memory for
the head of the list.  When there is problem allocating other list
elements the list is unwound and freed.  Then a check is made if the
list head was allocated and is also freed.

Keeping track of the what may need to be freed is the variable 'tail_old'.
The unwinding/freeing block is

	while (tail_old) {
		mem_init = tail_old->next;
		kfree(tail_old);
		tail_old = mem_init;
	}

The problem is that the first element of tail_old is also what was
allocated for the list head

		init_header = kzalloc(sizeof(*init_header), GFP_KERNEL);
		...
		*init_tab_base = init_header;
		flag = 1;
	}
	tail_old = init_header;

So *init_tab_base/init_header are freed twice.

There is another problem.
When the input *init_tab_base is non null the tail_old is calculated by
traveling down the list to first non null entry.

	tail_old = init_header;
	while (tail_old->next)
		tail_old = tail_old->next;

When the unwinding free happens, the last entry of the input list will
be freed.

So the freeing needs a general changed.
If locally allocated the first element of tail_old is freed, else it
is skipped.  As a bit of cleanup, reset *init_tab_base if it came in
as null.

Fixes: b4b7e67c917f ("crypto: qat - Intel(R) QAT ucode part of fw loader")

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/crypto/qat/qat_common/qat_uclo.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 4cc1f436b075..bff759e2f811 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -288,13 +288,18 @@ static int qat_uclo_create_batch_init_list(struct icp_qat_fw_loader_handle
 	}
 	return 0;
 out_err:
+	/* Do not free the list head unless we allocated it. */
+	tail_old = tail_old->next;
+	if (flag) {
+		kfree(*init_tab_base);
+		*init_tab_base = NULL;
+	}
+
 	while (tail_old) {
 		mem_init = tail_old->next;
 		kfree(tail_old);
 		tail_old = mem_init;
 	}
-	if (flag)
-		kfree(*init_tab_base);
 	return -ENOMEM;
 }
 
-- 
2.18.1

