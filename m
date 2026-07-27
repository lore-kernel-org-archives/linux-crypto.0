Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F593803E8;
	Mon, 27 Jul 2026 22:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785190793; cv=none; b=QHGPssB7VX1iP6s9+a4OpSRoTLg6oETXnsQ+44xcMvp7uE13JmF87Uc0qt+H2SpnNs+/4+o38ytqdapSTjFq4i4RMCDkDDwZmkRF6a5x/A4cHNSQ6pwSkMZvmedWcpun8kS4q24sYMBlxKDdI03OqdYAYyNLXTI2CGZdeNXmFsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785190793; c=relaxed/simple;
	bh=JEUsnsfi9kb5oTSguNCctWIWoJ4rYUSGgvDD1t2ejgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQPfMYp5ZXeh9UouQ/2iqceo+WJ/5c8tJ9ekUT8HpPnSykROdIZNNTAawI99xYZkQ/9+D7Mv/k//uFARLBXK4p80UZgesTJ9SA74+eFmRE8NXOBHWfE8k42dNdTUW5JaGOZoEeLzkbs+0q2JBQILFOMhr3d/wOFuImr9HNLKm8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gyWIX1YR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gyWIX1YR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265C61F00A3F;
	Mon, 27 Jul 2026 22:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785190792;
	bh=c74sgb4MeFfAvga8LGPZczIT+S8ZsFfHkd9eThbp5FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gyWIX1YRMA4418Iig/AJqBMLLvGFRDdWNZRt6/tLqnPhvhGwLzfxaqw8+qlhyWfyg
	 X/Yg5PDkNNX1vN99kKc7b29M2VhHGreLLe4E0ne5cdToMCGe45QPIjvtcweGFGfcoL
	 mpovQxW8xEminORCGKYRLL+u4TXJhBVXqN5Jx0ebofHDq5U4JMtLw27oe8dxpa0UXP
	 wnZBPjjfSzEgds3+OWUoRjRLrNHV42aTXHXCCkB60+L0J2wKYh0mkv9PW3qqFBdVGU
	 8oTGdGKyutAIyMYgvG3qmG2m1ZpQDJnH5TEoEdhM6K2CqFvbXsUeX1JWCc6dlMxwBE
	 XRMarZJJJqdGQ==
From: Sasha Levin <sashal@kernel.org>
To: Doruk Tan Ozturk <doruk@0sec.ai>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ignat Korchagin <ignat@linux.win>,
	Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 6.1/6.6/6.12.y] crypto: rsa-pkcs1pad: Don't WARN on an empty digest
Date: Mon, 27 Jul 2026 18:19:38 -0400
Message-ID: <20260727202413.stable-0005@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <amczJhA6T8UcthZp@wunner.de>
References: <amczJhA6T8UcthZp@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Jul 27, 2026 at 12:29:58PM +0200, Lukas Wunner wrote:
>Reviewed-by: Lukas Wunner <lukas@wunner.de>

Thanks Lukas!

Queued for 6.1, 6.6 and 6.12, thanks.

-- 
Thanks,
Sasha
