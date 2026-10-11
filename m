Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E30235C6B9;
	Sun, 11 Oct 2026 16:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791737336; cv=none; b=opEu3WVEPmHyWGpaEgVw26D3znIC68QZfVrZsKcBHVSWU8rnMJ99vtrqJTzrjyLFdHSV93Mjf6/BsdNqeOgGmlTwJFOQHYkklV7sfaxctYQAPVm3aKL6JQAXimCySj0ZO0ryB81WdZg/yHTlYqMLLnvwHEPc52rnmXBGxmj0Lzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791737336; c=relaxed/simple;
	bh=4AVWM59VLtvmpUhXLD3k6CE6N8WkKfIoXuxy1fwGR6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jITIma1z3/sXC7GoFCa+W2bsxmzY6abTkOe7T8nAjyhwuczRZltcG9G4t+W6+6XEL2EEOtF+gdk8LOZTZzDymyD5tVCbluSEAUPPecg8M2dKN3NW4IuWGzlIsWWkOka74PdhimRDqEdO7C+VX1wh+cfMDv3yCIfhDAHBJ7JkTEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AMrhOpLu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AMrhOpLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64E01F008A1;
	Sun, 11 Oct 2026 16:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791737335;
	bh=xOUdLHHUIHB/HIvdi12xcYiIz47QCfVHLCPJdO7pazA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AMrhOpLudjvPcA2zb/Ik6eWvH2UxTkhh5rJkgmTXOCV4DmAogJSBmQM6cllGB7zoK
	 fHIDyzvaqFa9uONUlPG2KT/rri+zCYVCwzh7ci++7AWaVWGHqrxp1jpWAcLBoHgZmS
	 4CU7I2xtd2IOcLQ7tE+g+XRJnRiG+V/JL2ur41kNxQtygz0qNY62JSabXMxSfAz2nG
	 zlhK0qXFaNqI1pzXV+s82Sf3658aVWJb4cJhyglhfv6iVocEJPNZBODgx+fa2YDtVv
	 wHrNGJilxg9Ae7iuOaaZUHp0UOZ4enpEcEPnFB2Nu1oENCH+x1yJ0hWJNSl2apZUoC
	 Dp75eMT39Zo0A==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6.18,6.12,6.6,6.1,5.15,5.10] crypto: drbg - Fix ineffective sanity check
Date: Sun, 11 Oct 2026 12:48:27 -0400
Message-ID: <2026-10-11-1-daily-reply-0020-drbg-sanity-check@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261010081720.17151-1-ebiggers@kernel.org>
References: <20261010081720.17151-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This commit doesn't matter for anything other than certification.  But
> it did have 'Cc stable' on it, and it failed to apply due to a trivial
> conflict.  So it might as well be backported as intended.

Queued for 6.18, 6.12, 6.6, 6.1, 5.15 and 5.10, thanks.

-- 
Thanks,
Sasha
