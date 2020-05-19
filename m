Return-Path: <SRS0=SwA+=7B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71469C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 19:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 576FB206C3
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 19:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589914941;
	bh=v7efvTu5talMRkBl/oTTM5IxNW02Zbh7QqxiZtAVavI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hRn+SpNX4GUEdlpQIFt54CKvPjU0hHcBrqDKzSmuvvh6RAfGl7fGEedM3UJtrk5iq
	 KlBxs9AAH6umNf9GCzdMoWwpmVs/uJSkJWYyXXfU2v6OKCcIC1y3U0+4e9oJtn9iqB
	 /+vUCrNNjnHOP6vlJWjZOIRzbFs0JGUQsfSqZr28=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgESTCU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 May 2020 15:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbgESTCU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 May 2020 15:02:20 -0400
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC62A20823;
        Tue, 19 May 2020 19:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589914940;
        bh=v7efvTu5talMRkBl/oTTM5IxNW02Zbh7QqxiZtAVavI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WhS89Qeu7ptX2jdVKD4tcmN3g/CYlVXoYJdb0drZVjoYXiey5TOAOhJQMmRdNOWKt
         B9hfiCjQB2FsiIJ2RFxNDZ1Wsint6i1o8GrHBwqrR6rEYIjWhEJa3nt64BYpGL8n5P
         mJqipMEAg86LrSHk3Y15DHcEbzXYiyY3+/Ls668E=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: [RFC/RFT PATCH 2/2] crypto: testmgr - add output IVs for AES-CBC with ciphertext stealing
Date:   Tue, 19 May 2020 21:02:11 +0200
Message-Id: <20200519190211.76855-3-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200519190211.76855-1-ardb@kernel.org>
References: <20200519190211.76855-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add some test vectors to get coverage for the IV that is output by CTS
implementations.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/testmgr.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index d29983908c38..d45fa1ad91ee 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -31041,6 +31041,8 @@ static const struct cipher_testvec cts_mode_tv_template[] = {
 		.ctext	= "\xc6\x35\x35\x68\xf2\xbf\x8c\xb4"
 			  "\xd8\xa5\x80\x36\x2d\xa7\xff\x7f"
 			  "\x97",
+		.iv_out	= "\xc6\x35\x35\x68\xf2\xbf\x8c\xb4"
+			  "\xd8\xa5\x80\x36\x2d\xa7\xff\x7f",
 	}, {
 		.klen	= 16,
 		.key    = "\x63\x68\x69\x63\x6b\x65\x6e\x20"
@@ -31054,6 +31056,8 @@ static const struct cipher_testvec cts_mode_tv_template[] = {
 			  "\xd4\x45\xd4\xc8\xef\xf7\xed\x22"
 			  "\x97\x68\x72\x68\xd6\xec\xcc\xc0"
 			  "\xc0\x7b\x25\xe2\x5e\xcf\xe5",
+		.iv_out	= "\xfc\x00\x78\x3e\x0e\xfd\xb2\xc1"
+			  "\xd4\x45\xd4\xc8\xef\xf7\xed\x22",
 	}, {
 		.klen	= 16,
 		.key    = "\x63\x68\x69\x63\x6b\x65\x6e\x20"
@@ -31067,6 +31071,8 @@ static const struct cipher_testvec cts_mode_tv_template[] = {
 			  "\xbe\x7f\xcb\xcc\x98\xeb\xf5\xa8"
 			  "\x97\x68\x72\x68\xd6\xec\xcc\xc0"
 			  "\xc0\x7b\x25\xe2\x5e\xcf\xe5\x84",
+		.iv_out	= "\x39\x31\x25\x23\xa7\x86\x62\xd5"
+			  "\xbe\x7f\xcb\xcc\x98\xeb\xf5\xa8",
 	}, {
 		.klen	= 16,
 		.key    = "\x63\x68\x69\x63\x6b\x65\x6e\x20"
@@ -31084,6 +31090,8 @@ static const struct cipher_testvec cts_mode_tv_template[] = {
 			  "\x1b\x55\x49\xd2\xf8\x38\x02\x9e"
 			  "\x39\x31\x25\x23\xa7\x86\x62\xd5"
 			  "\xbe\x7f\xcb\xcc\x98\xeb\xf5",
+		.iv_out	= "\xb3\xff\xfd\x94\x0c\x16\xa1\x8c"
+			  "\x1b\x55\x49\xd2\xf8\x38\x02\x9e",
 	}, {
 		.klen	= 16,
 		.key    = "\x63\x68\x69\x63\x6b\x65\x6e\x20"
@@ -31101,6 +31109,8 @@ static const struct cipher_testvec cts_mode_tv_template[] = {
 			  "\x3b\xc1\x03\xe1\xa1\x94\xbb\xd8"
 			  "\x39\x31\x25\x23\xa7\x86\x62\xd5"
 			  "\xbe\x7f\xcb\xcc\x98\xeb\xf5\xa8",
+		.iv_out	= "\x9d\xad\x8b\xbb\x96\xc4\xcd\xc0"
+			  "\x3b\xc1\x03\xe1\xa1\x94\xbb\xd8",
 	}, {
 		.klen	= 16,
 		.key    = "\x63\x68\x69\x63\x6b\x65\x6e\x20"
@@ -31122,6 +31132,8 @@ static const struct cipher_testvec cts_mode_tv_template[] = {
 			  "\x26\x73\x0d\xbc\x2f\x7b\xc8\x40"
 			  "\x9d\xad\x8b\xbb\x96\xc4\xcd\xc0"
 			  "\x3b\xc1\x03\xe1\xa1\x94\xbb\xd8",
+		.iv_out	= "\x48\x07\xef\xe8\x36\xee\x89\xa5"
+			  "\x26\x73\x0d\xbc\x2f\x7b\xc8\x40",
 	}
 };
 
-- 
2.20.1

