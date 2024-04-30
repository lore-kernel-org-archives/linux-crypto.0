Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD25113D273
	for <linux-crypto@vger.kernel.org>; Tue, 30 Apr 2024 12:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.117.254.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714479288; cv=none; b=cR/K7NZaP/fDPnDBp12FHaVefYsjJ91JQisO26QwcH5EI7N9P1P426oHTZYq/7DflTZ8P29XENS23Wg5kFGb/G4eJOyqwvP++ouvV57zh146fJcanbOpCtJsXhRWqVez5e3XQCSf87zb4h00Lds5p88SrMXNM/uf5qTA5rfK1HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714479288; c=relaxed/simple;
	bh=cA0r+dLA1sQJPEpW4g/4pxRmcB5XcpCzgfZKe7lIN00=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S8vtUjHg+pZ4cOpOa1rYe6sKiuUbHwL8nFUNUVuu3rSte5g1XkAefm7LD6gqqDng2pOQtRjLk2M+BzgItUQBB5daVHujTOpuX3kpU9y2YJN0Mf8m6eC/+VFqXkE9ffQcZwtoHBQz6Kt+EZEYovs9jpHVqPAoBiqsQq5ZsS7QxuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com; spf=pass smtp.mailfrom=sang-engineering.com; dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b=LRlFu+ye; arc=none smtp.client-ip=194.117.254.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b="LRlFu+ye"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	sang-engineering.com; h=from:to:cc:subject:date:message-id
	:mime-version:content-transfer-encoding; s=k1; bh=qv3V9v04XImJ7R
	SA6mxDg9I+SyYmu2l8iNOgau7ZTcc=; b=LRlFu+yeQxIZl2p3A9vuGmP8JFREUU
	iaXTCG9PIND+0/e9gOIs3+5HtjzRDCRgh17rXgkF7d5mHM6Xpt07W5ibCFyL2JK6
	MnOaD6BLmu600/gOUctC9Q9bt01Ru32E/mnhYxKauWzqYvj/JmR70lewQuhK0tF+
	LNz2oFshY+tn+fORApWK7g24dgJZsDoFuAATo+/LU+jvO01STfSx1PDfUsw0LdGL
	DcEaZkJLeVIlbPma9rk2B35advAOKx31H5fszpMEw7NGeJQP6wEc39VyGqnAAD6i
	oRumpBEzt1SYdRD0NjiCh8qmsPaREk6/yn0vIi63I4iPoepTHT9W1tug==
Received: (qmail 2627840 invoked from network); 30 Apr 2024 14:14:43 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 30 Apr 2024 14:14:43 +0200
X-UD-Smtp-Session: l3s3148p1@+p6mUE8Xsuxehhrb
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-crypto@vger.kernel.org
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/1] crypto: use 'time_left' instead of 'timeout' with wait_for_*() functions
Date: Tue, 30 Apr 2024 14:14:41 +0200
Message-ID: <20240430121443.30652-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a confusing pattern in the kernel to use a variable named 'timeout' to
store the result of wait_for_*() functions causing patterns like:

        timeout = wait_for_completion_timeout(...)
        if (!timeout) return -ETIMEDOUT;

with all kinds of permutations. Use 'time_left' as a variable to make the code
obvious and self explaining.

This is part of a tree-wide series. The rest of the patches can be found here
(some parts may still be WIP):

git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/time_left

Because these patches are generated, I audit them before sending. This is why I
will send series step by step. Build bot is happy with these patches, though.
No functional changes intended.

Wolfram Sang (1):
  crypto: api: use 'time_left' variable with
    wait_for_completion_killable_timeout()

 crypto/api.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.43.0

