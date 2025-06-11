Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE624C80;
	Wed, 11 Jun 2025 03:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.194.254.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749612924; cv=none; b=jK1G72NbWxepyLTC/6iicT2jyAoYCnTBTKfKw181wapsBXE1MJ4Zx1D6hsKhjq8OuE51SliAj/bMR7Tlx/kjwUsQo7H2SMEIyhu3t4yu6gzafgWZZ6/5U0o0cSWFgr5PD081gixrOKm8HlBsyEgZByNxWfso8dQENWBCTv7KJ0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749612924; c=relaxed/simple;
	bh=GIOvAdONo3giuCuiYYOgYOdZvqQ4pqznEg2OF2nbEj0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nJJ5V7XgkFY66LmNflMdvn+jtDfk6QoG5F0ZWsCvoql3KDn0WPsHXkPFPLLdNf6JQK9fnAgiLgu1rHIg1+VLy+SO2RYsZ8nYxTDDqo9Ia6xGgAFPJLftHmfdMa7+r/NuqnTeI4zBZfxCMmS+ubGste6vrGfv22HdSPki6pVQiaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=k4kVxt0T; arc=none smtp.client-ip=18.194.254.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="k4kVxt0T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1749612835;
	bh=GIOvAdONo3giuCuiYYOgYOdZvqQ4pqznEg2OF2nbEj0=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=k4kVxt0T0prmNuo756U9l/qt2bpLPZQFKMLCpdJiro1FTf6i/kjAfqXNWDpHKL9Um
	 ealRCFk4FqqWy9IIBAbkqrwsj/rRZFkqqp+v6uQM+FW8Z4/HzTKaPhYg1ncMZ4he2x
	 3hZXa8I5BglkFvQ9VomP8snDz6Ww+yCBUV6LWIwM=
X-QQ-mid: zesmtpip4t1749612809t4e55caaf
X-QQ-Originating-IP: ON06+p2z7ajBsHtTdhKKjRdfk+LHHEEfwBn+jfm4cx0=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 11 Jun 2025 11:33:27 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9867551432162374771
EX-QQ-RecipientCnt: 12
From: =?UTF-8?q?=E2=80=9CChengZhenghan=E2=80=9D?= <chengzhenghan@uniontech.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86 <x86@kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Cc: "H . Peter Anvin" <hpa@zytor.com>,
	ChengZhenghan <chengzhenghan@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>
Subject: Re: [PATCH] x86_crypto: Fix build warnings about export.h
Date: Wed, 11 Jun 2025 11:33:27 +0800
Message-Id: <20250611033327.27640-1-chengzhenghan@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-QQ-XMAILINFO: MNC03nSNDndtqbhrF/xfPTjHcaoP8/xKMYYzVrYAAebqMS+e9Esb8hKH
	n0fn4SVL+xgrEVsuN6q9aqBuxJKJ8NYqMendh8FCEsy1cDQurdYKSvJy6B33qNpP1twAkhv
	pKRjs+bkVqoQ/0/MCIT0cyWak4fLAxLfON6EtHE4F48WHeFC0f/8NE2srOjGBgvwA0FrB/m
	UoCj4Ewu4OgKmJKHBKVJpEMoUd2i2ajN1T1IlnHWmREkGCQX7jAj0+bceSmRtzw7o79aQLA
	zXCWQSsiG7LCGvQmmO6J9iTPd+R5aUNHLAmsaMlSZPPld6+u5E3zjLSNmKvVXV9WWO+JroI
	EB6fjdcfx6F7yAk2UqhWSN83E2JpFAbgLg2Umc99bkykL5DXJc4NTQGDtyucwDhoWYCEryS
	fp/aRXFuVe+bphs3Tgas0YRT6rl1s3uklyR9J1/E7yHbukQ/sapKDGm49WTdhFbdNs6Fnry
	Kk1pQX4jOpXtyZkyaEeALgqwDvVCM88ULXehyE5WGb1jWGUqRRD0Eeoe+Xu1M3J5goAiHRA
	k42yylwtMlYU74SkGK2OYFaadrMdlmrhzGOl3QHhdyeiN56laUHJQes/z+cLCitXCZikxZw
	8tOatMieNsslNRCiIw27yXlu7zwVQlwTe2Js4AI5VgD/2j5B00bfYFFqLRrj0MssHnT6pP6
	7T/l+xqDaJIXz54LAnns7RXT09hq1S22dVBbXjvT2YOUWC1askZ5TPDtbM0eZbCqgxCc3nq
	2TXk4yldgVF9HGeD0fkw0n7pCOw4SBumRNm7qK16DmVMdvTtQyhx2wTBLtRDum0RB8T3qzA
	Y5HNzG2uh9jz0S2RgM5/Hb+F3cAidDfIC0pUinXzCHRddl6L490G6+r29ktq1QrPxbhgvtQ
	38WaUsPzUr1SFUnqhgBU+nzgMbKtNsW41edlE+WGTNWIaM1ye41enpOJ8s7nGJGsKdcXrfn
	2bWE/zDmOGTYHaq4V8IMV7Acc/U73AYtH+i5gQXDa7wo+/4QOpo/ouGVdOqEaAGcVXPYGdh
	ggwpdKRyM1FrycT3LmVVr6VlgJbsA5E7Bmj4Qx0CUhNAcS/YTLRtEYduupfoMolvg2JTq5z
	w==
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
X-QQ-RECHKSPAM: 0

Dear Herbert Xu,

I hope this email finds you well.

My patch aims to resolve the issue where indirect header inclusion fails to work when the compiler warning level is set to W=1. Under W=1, this warning appears.

A similar patch addressing a related issue can be found here:
https://lore.kernel.org/linux-kbuild/CAK7LNARQFBuUY2YzUnPuyEdTAVy=B91L5NyYGzhY-kAr3SYsRQ@mail.gmail.com/T/#mbc002a0dcd1607c273295caedecfd827fb2da54e

Thank you for your time and consideration!

Best regards,
Cheng Zhenghan
