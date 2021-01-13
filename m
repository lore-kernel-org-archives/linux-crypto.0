Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E5DC433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Jan 2021 13:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 916E32342C
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Jan 2021 13:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbhAMNF3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Jan 2021 08:05:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29850 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725681AbhAMNF3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Jan 2021 08:05:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610543042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5e4skfGyhzhqHoZS57vTcqyCiFx434Q2RXOk76VK6sY=;
        b=YLhgaPGogJELx1tJOIO90whiASw/R2zug+YDIbcpl8apJhJRf6kUug1Gcw6ggi4Q18e5bV
        +acLVnjr4DMpiCyPAIBMJaKSGHY9GjXcW2Rio5V4Gbf6P5/KC48cDcPyM+ctbH5HgxsGuK
        iLEByidqbnJTzy7tBAxbndm2CJY2oqw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-YBeO2Qx_NqOfzK_awOm4EA-1; Wed, 13 Jan 2021 08:04:00 -0500
X-MC-Unique: YBeO2Qx_NqOfzK_awOm4EA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04F4B192D786;
        Wed, 13 Jan 2021 13:03:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-8.rdu2.redhat.com [10.10.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2FF8D19C47;
        Wed, 13 Jan 2021 13:03:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] X.509: Fix crash caused by NULL pointer
From:   David Howells <dhowells@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     stable@vger.kernel.org#v5.10+,
        Tobias Markus <tobias@markus-regensburg.de>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        dhowells@redhat.com, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 13 Jan 2021 13:03:56 +0000
Message-ID: <161054303634.2657259.11011286561405860797.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

On the following call path, `sig->pkey_algo` is not assigned
in asymmetric_key_verify_signature(), which causes runtime
crash in public_key_verify_signature().

  keyctl_pkey_verify
    asymmetric_key_verify_signature
      verify_signature
        public_key_verify_signature

This patch simply check this situation and fixes the crash
caused by NULL pointer.

Fixes: 215525639631 ("X.509: support OSCCA SM2-with-SM3 certificate verification")
Cc: stable@vger.kernel.org # v5.10+
Reported-by: Tobias Markus <tobias@markus-regensburg.de>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-and-tested-by: Toke Høiland-Jørgensen <toke@redhat.com>
---

 crypto/asymmetric_keys/public_key.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 8892908ad58c..788a4ba1e2e7 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -356,7 +356,8 @@ int public_key_verify_signature(const struct public_key *pkey,
 	if (ret)
 		goto error_free_key;
 
-	if (strcmp(sig->pkey_algo, "sm2") == 0 && sig->data_size) {
+	if (sig->pkey_algo && strcmp(sig->pkey_algo, "sm2") == 0 &&
+	    sig->data_size) {
 		ret = cert_sig_digest_update(sig, tfm);
 		if (ret)
 			goto error_free_key;


