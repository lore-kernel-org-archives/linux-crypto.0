Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE0F2C2366;
	Sat, 22 Nov 2025 02:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763780148; cv=none; b=HYJ5kwyneQd9z+SEhSFWPhpTqTnUwJVwkOS1SP5FSNpc7WQCYM5/vBkkTeVpoRO7pKxUcNCw8mhzXQSraFvJ27OAFUVJdQKRfUezdLbcWSmmXsT01SmAKggzGE+tmQJFkhrvlSHL0YJBhH/OUgl930LjEG5P+i/gwbBUReDhyZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763780148; c=relaxed/simple;
	bh=Ji2WFefzU6i8tHfifoYC259MfWrd0/r/C8sBvf2flRA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PIBW88AbLPjXeFasAMDLfkucZrZO/QTErsbU3bq7kCdWLOLZ3V6o4VkpKHLZmWoa3hthW+gEZjufzQa+qJr0JHDfmxv5wiOGMhe2SoYF5CFFONk39KSYlOV8+5MKJYjItb8IxmRsKe0j2Kfhv2LzWXYh0cMZiNwBtrv7BuHyck8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=mg4IKBCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="mg4IKBCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07324C4CEF1;
	Sat, 22 Nov 2025 02:55:46 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="mg4IKBCY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1763780145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SUi+Wp28epOIzK1l47n3gZAxpQNKD9KJG39gp5+3IUU=;
	b=mg4IKBCYMGPrPm6k2YDLYogKsMR+R5M1yQN5xByoIU0wETtLOjIM1Dyxn0+MbO/H1wLjiD
	telGbEC1h9jf+tBf0ygGDmJxn7MKyejDsv3h3pIMdemN8teLRxgL8rtBAvYC3Lpax3xUeS
	a0bgPt1iFKav7GvzRwPUZvnF1N7i50o=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 05e0fdb7 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sat, 22 Nov 2025 02:55:45 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH libcrypto v3 1/3] wifi: iwlwifi: trans: rename at_least variable to min_mode
Date: Sat, 22 Nov 2025 03:55:09 +0100
Message-ID: <20251122025510.1625066-2-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The subsequent commit is going to add a macro that redefines `at_least`
to mean something else. Given that the usage here in iwlwifi is the only
use of that identifier in the whole kernel, just rename it to a more
fitting name, `min_mode`.

Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
Changes v2->v3:
- Added Ard's ack.

 drivers/net/wireless/intel/iwlwifi/iwl-trans.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 5232f66c2d52..cc8a84018f70 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -129,7 +129,7 @@ static enum iwl_reset_mode
 iwl_trans_determine_restart_mode(struct iwl_trans *trans)
 {
 	struct iwl_trans_dev_restart_data *data;
-	enum iwl_reset_mode at_least = 0;
+	enum iwl_reset_mode min_mode = 0;
 	unsigned int index;
 	static const enum iwl_reset_mode escalation_list_old[] = {
 		IWL_RESET_MODE_SW_RESET,
@@ -173,11 +173,11 @@ iwl_trans_determine_restart_mode(struct iwl_trans *trans)
 	}
 
 	if (trans->restart.during_reset)
-		at_least = IWL_RESET_MODE_REPROBE;
+		min_mode = IWL_RESET_MODE_REPROBE;
 
 	data = iwl_trans_get_restart_data(trans->dev);
 	if (!data)
-		return at_least;
+		return min_mode;
 
 	if (!data->backoff &&
 	    ktime_get_boottime_seconds() - data->last_error >=
@@ -194,7 +194,7 @@ iwl_trans_determine_restart_mode(struct iwl_trans *trans)
 		data->backoff = false;
 	}
 
-	return max(at_least, escalation_list[index]);
+	return max(min_mode, escalation_list[index]);
 }
 
 #define IWL_TRANS_TOP_FOLLOWER_WAIT	180 /* ms */
-- 
2.52.0

