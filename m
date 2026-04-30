Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDE3427A19;
	Thu, 30 Apr 2026 16:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777565280; cv=none; b=nwLFMnwm+V6gyo2uhUL4z8NSsCgNFWa3gnrDhpTkE4wt1WzmwTWlNPPuapQzF+ouehXsxHRgxMorWkihetRM6G8q+JVKvm53rbHQmD2ejXRo+mGLRjJ8g+nSgaPoj5jXy2rpA8WvqjIl7IZPpXjTiNj/SYI3BNprMr+hCYP2jCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777565280; c=relaxed/simple;
	bh=viA7IvKLlkqIHNTTdu/299WLWA2xamwda1MPL1g/yC4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wr8hRs0al4aT8PNCxjiHnrB5oMSdNP+iZAOaMjTO0o2fazhYTIJtFAJJvtuEhzDmP39o9h2aRPSxAzTFLPv8DImJLs8vYgXkPzKaHkE7LmBtyIn3eVyVghxS85vlTP2477SNQict5GCmVjySBoNE9ieNtooaNM4lVlryc+LHjYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l6h8g2Ha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l6h8g2Ha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E17C2BCB3;
	Thu, 30 Apr 2026 16:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777565280;
	bh=viA7IvKLlkqIHNTTdu/299WLWA2xamwda1MPL1g/yC4=;
	h=From:To:Cc:Subject:Date:From;
	b=l6h8g2HaSQAn0JoW97WDFVjWcnVoMFy284IvL4rJVAYwgF2YZbu6EwLdLijlKg8rx
	 cb9+cRq7a6gbJZnjbFOt8kfH4VESTowh03YRaDxgBYQC11PqL2Kte3oSfd6FAcd03g
	 Qd2pBV6imDajKKNG1UzyCJaCrEZSF43Ylf0pPbIDDD4djbbRge591Ut9KJk7QTjYsP
	 Qtq2pWvnuwASYbFpviy8mdoh4ZeyRiGR78lCb6HN5D7XcVSdAEXdychz860EtZiaeP
	 gISQxeUlcWvO9BisdBtZAqRgVcJvRE3Er8glTu7oVqdnrgBPudzV7R/z4Ic/1lNpCk
	 3D8qqFxBxqvPw==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Kim Phillips <kim.phillips@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Pratik R. Sampat" <prsampat@amd.com>,
	Michael Roth <michael.roth@amd.com>
Subject: [RFC v1 0/6] Implement SNP DOWNLOAD_FIRMWARE_EX support
Date: Thu, 30 Apr 2026 10:07:10 -0600
Message-ID: <20260430160716.1120553-1-tycho@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

Here is an implementation of the SEV-SNP firmware's DOWNLOAD_FIRMWARE_EX
command. The core difference between this and the previous implementation
https://lore.kernel.org/lkml/20241112232253.3379178-7-dionnaglaze@google.com/
is that it relies on the SEV firmware's state (WORKING) to indicate that there
are legacy VMs running instead of tracking things explicitly via ASID.

There is a race condition in slide 18 of
https://pretalx.com/media/kvm-forum-2025/submissions/TAMRR8/resources/SEV_FW_Hotl_zfT5e9Y.pdf
which this series does not address, I am still trying to understand what the
best way to fix that is.

Also note that patch 1 is a duplicate of
https://lore.kernel.org/all/20260416232329.3408497-2-seanjc@google.com/
so it can be dropped when that is applied.

Thanks,

Tycho

Tycho Andersen (AMD) (6):
  crypto/ccp: Hoist kernel part of SNP_PLATFORM_STATUS
  crypto/ccp: Allow snp_get_platform_data() after SNP init
  crypto/ccp: Add DOWNLOAD_FIRMWARE_EX message struct
  crypto/ccp: Reclaim command buffer when the PSP dies
  crypto/ccp: Register with fw_uploader and always fail
  crypto/ccp: Implement SNP firmware live update

 drivers/crypto/ccp/sev-dev.c | 416 +++++++++++++++++++++++++++++++----
 drivers/crypto/ccp/sev-dev.h |   3 +
 include/linux/psp-sev.h      |  20 ++
 3 files changed, 393 insertions(+), 46 deletions(-)


base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.54.0

