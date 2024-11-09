Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE721C27;
	Sat,  9 Nov 2024 02:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731117682; cv=none; b=ZpCir9pacsX79Z4iED2lG5LW9tgdg7SIvIA2zLbJdS3imeuOArGgzWAuanFJALMxDDyBoLORVsFRjUGLNr3aYZnSSIsrXGfYQm1ypiOUsi33432NAqoxnYRMGJ0s9O6+7xzaj4mukpUW/oOdzeGFbayrieVHqoxLiheg9feKK+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731117682; c=relaxed/simple;
	bh=s3QMBa/ZBDXWVisRK+cBDAz6JxSt3Vvp543ZdW/7hh4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KNwIZu61iy6yk2Ej5yYn2/MeKVCMAGYrnCAlOswlbnJ9sAfhQhePSVZZClzGss8edoS9OM4pUsE+hYFw3cPryFzYFTkt6BRd4+Klm04y2+lSs5GpnVkhh8O+GcuWkhVCXc8UjkdgjqpYR1ygnfVwvNjusUZfESc2HSKDDpH2BKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C76xhFO4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C76xhFO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544E7C4CECD;
	Sat,  9 Nov 2024 02:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731117682;
	bh=s3QMBa/ZBDXWVisRK+cBDAz6JxSt3Vvp543ZdW/7hh4=;
	h=From:To:Cc:Subject:Date:From;
	b=C76xhFO45ciYI4z/478GGmUEdbsJUwu3lS9nRBxD9BeyaL7/p1jXz7Wq30/4BXbMJ
	 /Z6gTejfO2eIt7J2tdkVCWqYdYHkjvklCTzF8lBB10NJyuqM/PG8RWyjGypIIpXFa3
	 aBMgpcN9Jhhzi+axSs4sxGpdkxsxD/aMTxYYEuOJrlT59fbgginghYqPmrczfx6HkX
	 92wlXnmgejKCSmGX9vWPYj+4dkrPfum7F+P4JxqHnOKk8Qq1B5zg5hctZQFMaIosvz
	 twryWzJAAJ2JQWzvcYRdqXRVWxVcThf+M22pE6/EFkzCypuEHqdDzsunVWZNzRy/gl
	 npTmtr7EPBdxA==
From: Mario Limonciello <superm1@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH] crypto: ccp: Use scoped guard for mutex
Date: Fri,  8 Nov 2024 20:00:54 -0600
Message-ID: <20241109020054.3877377-1-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

Using a scoped guard simplifies the cleanup handling.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/crypto/ccp/dbc.c | 48 +++++++++++++++-------------------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/ccp/dbc.c b/drivers/crypto/ccp/dbc.c
index 5b105a23f6997..3617e6eabab14 100644
--- a/drivers/crypto/ccp/dbc.c
+++ b/drivers/crypto/ccp/dbc.c
@@ -7,6 +7,8 @@
  * Author: Mario Limonciello <mario.limonciello@amd.com>
  */
 
+#include <linux/mutex.h>
+
 #include "dbc.h"
 
 #define DBC_DEFAULT_TIMEOUT		(10 * MSEC_PER_SEC)
@@ -137,62 +139,48 @@ static long dbc_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return -ENODEV;
 	dbc_dev = psp_master->dbc_data;
 
-	mutex_lock(&dbc_dev->ioctl_mutex);
+	guard(mutex)(&dbc_dev->ioctl_mutex);
 
 	switch (cmd) {
 	case DBCIOCNONCE:
-		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_nonce))) {
-			ret = -EFAULT;
-			goto unlock;
-		}
+		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_nonce)))
+			return -EFAULT;
 
 		ret = send_dbc_nonce(dbc_dev);
 		if (ret)
-			goto unlock;
+			return ret;
 
-		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_nonce))) {
-			ret = -EFAULT;
-			goto unlock;
-		}
+		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_nonce)))
+			return -EFAULT;
 		break;
 	case DBCIOCUID:
-		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_setuid))) {
-			ret = -EFAULT;
-			goto unlock;
-		}
+		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_setuid)))
+			return -EFAULT;
 
 		*dbc_dev->payload_size = dbc_dev->header_size + sizeof(struct dbc_user_setuid);
 		ret = send_dbc_cmd(dbc_dev, PSP_DYNAMIC_BOOST_SET_UID);
 		if (ret)
-			goto unlock;
+			return ret;
 
-		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_setuid))) {
-			ret = -EFAULT;
-			goto unlock;
-		}
+		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_setuid)))
+			return -EFAULT;
 		break;
 	case DBCIOCPARAM:
-		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_param))) {
-			ret = -EFAULT;
-			goto unlock;
-		}
+		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_param)))
+			return -EFAULT;
 
 		*dbc_dev->payload_size = dbc_dev->header_size + sizeof(struct dbc_user_param);
 		ret = send_dbc_parameter(dbc_dev);
 		if (ret)
-			goto unlock;
+			return ret;
 
-		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_param)))  {
-			ret = -EFAULT;
-			goto unlock;
-		}
+		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_param)))
+			return -EFAULT;
 		break;
 	default:
 		ret = -EINVAL;
 
 	}
-unlock:
-	mutex_unlock(&dbc_dev->ioctl_mutex);
 
 	return ret;
 }
-- 
2.43.0

