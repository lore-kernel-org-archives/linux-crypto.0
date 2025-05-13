Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D3F1ADC7B;
	Tue, 13 May 2025 02:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747102925; cv=none; b=DTL+iVhH+609OLqpiaqgNn54T7gaOvpWTUOPsjqJ5NeIFt2gJBFE/rjkNFXsWNd6OqwJfywIL8h6IdFO4TT8y2dzbeIGk6Zj2B2CkYAnF8XmhS6M8YCqHNrg1kOgS/ixGama5hy7fvLJ40qj4w9620exHOyCBSXXYLZsXqOb4YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747102925; c=relaxed/simple;
	bh=FGVKGRCRWFRrt7YM9cMW+5TsjRx+U8B96ORS1mkNgWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcuVRBJX+zZ2FidWc7Wf7YXxj4hvfqpYnvQakUe4mpWCmRv1gQNQeDUc49QfttoUNyuMx3fQyhkC43QvyGzypn9JRyDBcvJA598OpgUhE05a9FozczoO+4HrD866ncX4/5zhrofMoexyt7V1VelKC+XwLSdgzdRVQizyIlAPmMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=slndntNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="slndntNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51705C4CEF1;
	Tue, 13 May 2025 02:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747102924;
	bh=FGVKGRCRWFRrt7YM9cMW+5TsjRx+U8B96ORS1mkNgWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=slndntNzj+GBxIRe0tkwuf2RsDdwTnePoYn1nNihJaiq0EudzsqQ6KjxXu4lM4e+2
	 DqRtNtj7b3AEaFf6lyFAoF5MRmc44ry2u4fgiba86e8AJs+mMJHOd2lqZpGVNM9b5Z
	 IOXK6dBchbJJBFAjRugA4SEl0ENNOEJjq9D924elksSKc6vTg7RNsqr8JlGHx24zW7
	 BBNxjfxUkFSY/etYTrZMbH6y9APigML+XUV2s75tL8A1Z7e6dXWwzzBu+CZX4xAzp/
	 GTNGZUz8emtCkeues3oU3vjFhePUtTg63mo0xJyAm82oqdg5s8IdjQvtYb9MCHru2Y
	 O5GnOir7wEpDg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 1/2] w1: ds2406: use crc16() instead of crc16_byte() loop
Date: Mon, 12 May 2025 19:21:14 -0700
Message-ID: <20250513022115.39109-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250513022115.39109-1-ebiggers@kernel.org>
References: <20250513022115.39109-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Instead of looping through each byte and calling crc16_byte(), instead
just call crc16() on the whole buffer.  No functional change.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/w1/slaves/w1_ds2406.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/w1/slaves/w1_ds2406.c b/drivers/w1/slaves/w1_ds2406.c
index 1cae9b243ff8..76026d615111 100644
--- a/drivers/w1/slaves/w1_ds2406.c
+++ b/drivers/w1/slaves/w1_ds2406.c
@@ -27,12 +27,10 @@ static ssize_t w1_f12_read_state(
 	const struct bin_attribute *bin_attr,
 	char *buf, loff_t off, size_t count)
 {
 	u8 w1_buf[6] = {W1_F12_FUNC_READ_STATUS, 7, 0, 0, 0, 0};
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
-	u16 crc = 0;
-	int i;
 	ssize_t rtnval = 1;
 
 	if (off != 0)
 		return 0;
 	if (!buf)
@@ -45,13 +43,11 @@ static ssize_t w1_f12_read_state(
 		return -EIO;
 	}
 
 	w1_write_block(sl->master, w1_buf, 3);
 	w1_read_block(sl->master, w1_buf+3, 3);
-	for (i = 0; i < 6; i++)
-		crc = crc16_byte(crc, w1_buf[i]);
-	if (crc == 0xb001) /* good read? */
+	if (crc16(0, w1_buf, sizeof(w1_buf)) == 0xb001) /* good read? */
 		*buf = ((w1_buf[3]>>5)&3)|0x30;
 	else
 		rtnval = -EIO;
 
 	mutex_unlock(&sl->master->bus_mutex);
@@ -64,12 +60,10 @@ static ssize_t w1_f12_write_output(
 	const struct bin_attribute *bin_attr,
 	char *buf, loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 	u8 w1_buf[6] = {W1_F12_FUNC_WRITE_STATUS, 7, 0, 0, 0, 0};
-	u16 crc = 0;
-	int i;
 	ssize_t rtnval = 1;
 
 	if (count != 1 || off != 0)
 		return -EFAULT;
 
@@ -81,13 +75,11 @@ static ssize_t w1_f12_write_output(
 	}
 
 	w1_buf[3] = (((*buf)&3)<<5)|0x1F;
 	w1_write_block(sl->master, w1_buf, 4);
 	w1_read_block(sl->master, w1_buf+4, 2);
-	for (i = 0; i < 6; i++)
-		crc = crc16_byte(crc, w1_buf[i]);
-	if (crc == 0xb001) /* good read? */
+	if (crc16(0, w1_buf, sizeof(w1_buf)) == 0xb001) /* good read? */
 		w1_write_8(sl->master, 0xFF);
 	else
 		rtnval = -EIO;
 
 	mutex_unlock(&sl->master->bus_mutex);
-- 
2.49.0

