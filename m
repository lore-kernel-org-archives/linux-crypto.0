Return-Path: <SRS0=2CiZ=QS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73AA6C169C4
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 17:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 442C02229E
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 17:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549906218;
	bh=NcltexyXWGdIQ4BZfnV6dZQ6a1C+toQk88Vjh5zZjCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ldmDWMAGsdrBcg9/pmj48tdiXlQZ6eewUdoM3/jVlFEdMzseVvWG9ZpHewbvzTV5t
	 KoOALSf5pKw6QHeQWHBP7RW7vWzdc3K8suBHuGptP8i3xJWTYtLm4GWe0Hm/7lQL77
	 007238IOKRmMjt4J+N7o7U+1VV1TROKcY0nYcXcc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbfBKRaH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Feb 2019 12:30:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:46552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730798AbfBKR3q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Feb 2019 12:29:46 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 645FA222B4;
        Mon, 11 Feb 2019 17:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549906185;
        bh=NcltexyXWGdIQ4BZfnV6dZQ6a1C+toQk88Vjh5zZjCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H9v6E+NdLP98dYTOi/gWoPL1FXVd2OPiLF8Zm1gf22qqcrB5eb/bFQTzExlKbAcac
         Wsl1ECxeuA9sqILlPpa78wPi2VoFEqE1CkXRPCt7mySCjqyQ1bDJoO1kp+sM1SjDmw
         XKPT0yz9cyJ3qPpvulI8kf4OWnHk87hBm774bXnA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-api@vger.kernel.org,
        keyrings@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [RFC PATCH v2 19/20] ubifs: wire up new fscrypt ioctls
Date:   Mon, 11 Feb 2019 09:27:37 -0800
Message-Id: <20190211172738.4633-20-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190211172738.4633-1-ebiggers@kernel.org>
References: <20190211172738.4633-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Wire up the new ioctls for adding and removing fscrypt keys to/from the
filesystem, and the new ioctl for retrieving v2 encryption policies.

For more details see Documentation/filesystems/fscrypt.rst, as well as
the fscrypt patches that added the implementation of these ioctls.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ubifs/ioctl.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/ubifs/ioctl.c b/fs/ubifs/ioctl.c
index 0f9c362a3402..5f4c4620f9c4 100644
--- a/fs/ubifs/ioctl.c
+++ b/fs/ubifs/ioctl.c
@@ -197,13 +197,21 @@ long ubifs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return -EOPNOTSUPP;
 #endif
 	}
-	case FS_IOC_GET_ENCRYPTION_POLICY: {
-#ifdef CONFIG_FS_ENCRYPTION
+
+	case FS_IOC_GET_ENCRYPTION_POLICY:
 		return fscrypt_ioctl_get_policy(file, (void __user *)arg);
-#else
-		return -EOPNOTSUPP;
-#endif
-	}
+
+	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
+		return fscrypt_ioctl_get_policy_ex(file, (void __user *)arg);
+
+	case FS_IOC_ADD_ENCRYPTION_KEY:
+		return fscrypt_ioctl_add_key(file, (void __user *)arg);
+
+	case FS_IOC_REMOVE_ENCRYPTION_KEY:
+		return fscrypt_ioctl_remove_key(file, (const void __user *)arg);
+
+	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
+		return fscrypt_ioctl_get_key_status(file, (void __user *)arg);
 
 	default:
 		return -ENOTTY;
@@ -222,6 +230,10 @@ long ubifs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		break;
 	case FS_IOC_SET_ENCRYPTION_POLICY:
 	case FS_IOC_GET_ENCRYPTION_POLICY:
+	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
+	case FS_IOC_ADD_ENCRYPTION_KEY:
+	case FS_IOC_REMOVE_ENCRYPTION_KEY:
+	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
 		break;
 	default:
 		return -ENOIOCTLCMD;
-- 
2.20.1

