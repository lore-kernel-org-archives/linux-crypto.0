Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B262383C6F
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 08:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778834298; cv=none; b=GhAdO0lOnnki7/jqZs54S12qn08/Nup/4YRFAqL0WhIcg7LjxJT52IR2h20iyuOJjLKUvZX6IrbukGHL3XbRvUNTD8nCEg6CoW/PHE0K13/GnDixTO1WRnhylv+/DAtTFLmTb1HL+0RbG6sMaSwBCAk8RHrR7WItlgyJA/rUeHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778834298; c=relaxed/simple;
	bh=0YBeQfUOAa/82C9WoG4FKWMq0qWHC3F3495EXSeWvzo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hs9gY6nTn68fBhBU/o0o9PYGqmQOh7fkxP09+NMWPjMkJsygh6GfqzVarTHlpfG/+GE7qAEeu2dwITqbUchhPthJl3JZQg/eWJvB7S9xDazaPpVtWiQYGJVtBmNk6BAH8aH074kSxL1mnkusbboA5kBWT16futjb67GCfer0g2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=D3Od1wQu; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="D3Od1wQu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=T5
	JV2GGCo+zxDpNaE2GN8CIxHVWQBBYVWO7sP+h9XNk=; b=D3Od1wQuCSXHJHNBU3
	sR0ZWwJtqu74KNjB1ZJvKq0lrP/gj2tCYn0pjUJtNBSXrqMU4VZ+j3RIlr1xztEy
	j7Tuey2Jtwv389C0t4/bn7kdXFWuFY3KUh4+ftMdeipOGgBHtJVcAu0Yvyj9bdB6
	Q/hZA04oP7PRmLMQvLC2T/+9Y=
Received: from localhost.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgDHlOFC2wZq4mXLDg--.24792S2;
	Fri, 15 May 2026 16:37:24 +0800 (CST)
From: scott_gzh@163.com
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	Scott GUO <scottzhguo@tencent.com>
Subject: [PATCH 0/2] authencesn: Refactor in-place decryption
Date: Fri, 15 May 2026 16:36:43 +0800
Message-ID: <20260515083645.4024574-1-scott_gzh@163.com>
X-Mailer: git-send-email 2.41.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgDHlOFC2wZq4mXLDg--.24792S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxU5lkVUUUUU
X-CM-SenderInfo: hvfr33hbj2xqqrwthudrp/xtbCwwQkwWoG20RynwAA38

From: Scott GUO <scottzhguo@tencent.com>

This patch set introduced the sglist_shift_{left,right} helper
and refactor the sequence number handling for authencesn
decryption. Avoiding write to the auth part of the sg list.

Scott GUO (2):
  scatterlist: Introduce sglist_shift_{left,right} helpers
  authencesn: Refactor inplace-decryption with sglist shift helper

 crypto/authencesn.c          | 38 ++++++-----------
 crypto/scatterwalk.c         | 79 ++++++++++++++++++++++++++++++++++++
 include/crypto/scatterwalk.h |  6 +++
 3 files changed, 97 insertions(+), 26 deletions(-)

-- 
2.41.3

