Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE47C43217
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Mar 2022 20:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236189AbiCCUOL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Mar 2022 15:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236187AbiCCUOJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Mar 2022 15:14:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E059CC9A22;
        Thu,  3 Mar 2022 12:13:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FB8AB826D9;
        Thu,  3 Mar 2022 20:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C32C340F1;
        Thu,  3 Mar 2022 20:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646338400;
        bh=z3/R9w70Bu9dBfiawHudSlINUX1Tv3ukTkQdVZxpKko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b65dP9xSQ7Fuff/lcNr6j4QM/x9FowDNeQfK+XRKSj/e+mn6WmpIGEXTndsVzx6eR
         MHKeJen8M8NG7GcS65GVUXhr9tbjzNxVSU77J3SDlN2dfkTZB6Aw6qQoHgmJ+MdT8X
         P4ZxXZTJkRrRdfM8iXiY63HU5CavQsChZf4oWVpheBsMxFEER1n/OSREAsQ7mFU0+V
         QMwz0M+hzGEuSHpzTL5U+fk7FpxCt6CliC4YZbzyEpZAbQ+lvyuKnr5aWIsvE7BVTf
         jMxptSG9ojNA+JF7+lVhvL/9sAMKrzl4rW/HpP4VDmbIzzo40/fpE/mzqPn3nzoYkh
         ZLnezYAavzkUQ==
From:   Keith Busch <kbusch@kernel.org>
To:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
        Keith Busch <kbusch@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCHv4 4/8] linux/kernel: introduce lower_48_bits function
Date:   Thu,  3 Mar 2022 12:13:08 -0800
Message-Id: <20220303201312.3255347-5-kbusch@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20220303201312.3255347-1-kbusch@kernel.org>
References: <20220303201312.3255347-1-kbusch@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Recent data integrity field enhancements allow reference tags to be up
to 48 bits. Introduce an inline helper function since this will be a
repeated operation.

Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/kernel.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 33f47a996513..3877478681b9 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -63,6 +63,15 @@
 }					\
 )
 
+/**
+ * lower_48_bits() - return bits 0-47 of a number
+ * @n: the number we're accessing
+ */
+static inline u64 lower_48_bits(u64 n)
+{
+	return n & ((1ull << 48) - 1);
+}
+
 /**
  * upper_32_bits - return bits 32-63 of a number
  * @n: the number we're accessing
-- 
2.25.4

