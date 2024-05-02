Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC0A1635DB
	for <linux-crypto@vger.kernel.org>; Thu,  2 May 2024 21:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.117.254.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714683648; cv=none; b=UZPDcoIwIpCCExG7ZihAn527AZZK5ubJ1aaYVKdRPzVr6A6ew9+x53Bc4yyAKGdndOsrSBLm0zwYrw7xUU6gtKAilhXgVQqBMd36QIP8QrFzNL8Hqik3U32hRAHEHnLBym0PoY2+FvD9QgcamQa27XYhli5I8nPCzDWP2ASURts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714683648; c=relaxed/simple;
	bh=G2G5Fdd8L1eMCVpoJCoNvgyMBlb75rzt+1FCyv2puVo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BmZ1ArA9KY3+2hstxvbzyyDTFY3f05N8vcKo6sMcItk8jVjRhLNNaBtEv0U52CP24mlcv55FN8KxKlq+xUYu93lvBbZP3HVbyxxUm2n+wFQErTt8FL4BfbS6HUf3QfPZJQLoraXC3NM+hb8SG7bf/aW/n9xDkR/S18oJ/zkzFNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com; spf=pass smtp.mailfrom=sang-engineering.com; dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b=kTsD4wzs; arc=none smtp.client-ip=194.117.254.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b="kTsD4wzs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	sang-engineering.com; h=from:to:cc:subject:date:message-id
	:mime-version:content-transfer-encoding; s=k1; bh=vbLbGnRrGB7osk
	150qN2jGrCzd2fjB5/oPHzyxdfjfo=; b=kTsD4wzsqhNs625k+/D3X4EveeW156
	xolafYJZMXNmURAxMJW+VCLt7kkK/pfWh2TyUZJtR73Ex3q5/LaM1fhnVKbCX0aN
	b8rtHgKHqNEYKNyEek6k/+5QdVpHHqQktdrahFswrIQTyhyvybT+u7muQTF6V7k2
	okY7OPAqkeEcHpRbDcjKWizio5tXyGMtpPVSoxyAOfmDem7pXlZNfryFbn4eJL37
	pDKgHZuI/OHUy4RJHE11vBQMPxIKJJs8Ejee3756yPKLKjJeV6a3yJzdOClXcWqL
	4bjpmX2ztPBpJNGAGAKUEFzNjoKlI3+AjX4W5pTIydSSd11Hv+LgxGnQ==
Received: (qmail 3365792 invoked from network); 2 May 2024 23:00:40 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 2 May 2024 23:00:40 +0200
X-UD-Smtp-Session: l3s3148p1@ZIs/5X4XVopehhrT
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-crypto@vger.kernel.org
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-fpga@vger.kernel.org,
	Michal Simek <michal.simek@amd.com>,
	Moritz Fischer <mdf@kernel.org>,
	Wu Hao <hao.wu@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: [PATCH 0/2] fpga: use 'time_left' instead of 'timeout' with wait_for_*() functions
Date: Thu,  2 May 2024 23:00:35 +0200
Message-ID: <20240502210038.11480-1-wsa+renesas@sang-engineering.com>
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

Wolfram Sang (2):
  fpga: socfpga: use 'time_left' variable with
    wait_for_completion_interruptible_timeout()
  fpga: zynq-fpga: use 'time_left' variable with
    wait_for_completion_timeout()

 drivers/fpga/socfpga.c   | 7 ++++---
 drivers/fpga/zynq-fpga.c | 8 ++++----
 2 files changed, 8 insertions(+), 7 deletions(-)

-- 
2.43.0

