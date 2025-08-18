Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B5E3218D7;
	Mon, 18 Aug 2025 12:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521331; cv=none; b=Voss9xX+jmMostUtqxG0cH0StlKTxS0ae8dFO+WJbveNu17GCz/e8FmNoWbZCLnCerey2+Ng4gAEuAa0kJN1466H3hlTq9ODkiIs/IAyRXFzjYM+ZfHol+44zmf+5pFa/JRvTV17g+TdeC+u6GKTke1WBx9VNU7BBaAyr5N4to8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521331; c=relaxed/simple;
	bh=4IB1tgKEiqeCPz5V53tVO/SIhyw2+to9wxscoO9Kil0=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=h4rtRuiSiWJaD6ddu3IyU82Cs7i4RbJeTfjgV85sYDdtE/QYeolFFTl1mldhOPmwPLC64HfDDj8w1qZ/T1coZCGWIQ648mBf+7x2xOx0DaHOw+Piksd/uh4JdwYBkEq0ozbuNooBPqUULDK/f/OJ1O+HWpGLYau11J1i7eY4CsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=mfJ49oK/; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="mfJ49oK/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1755521018; bh=4IB1tgKEiqeCPz5V53tVO/SIhyw2+to9wxscoO9Kil0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mfJ49oK/cZuA+Cv9Vq2xNGKj2ggr0bH+LkY1IUxF54LmK7xHwChKuHI2jQBUuCgSo
	 1FSfPGb7eySG4GHYSmBWmYED3qybBsuiuz+Veyp+zAWON//DAQB8nv1z0FqwLpCSl5
	 sbwQgqZdMJfwbuDtFOObdwgwgo+5EujSMxE7GJiI=
Received: from pek-lxu-l1.corp.ad.wrs.com ([111.198.230.220])
	by newxmesmtplogicsvrsza56-0.qq.com (NewEsmtp) with SMTP
	id AE3B12E0; Mon, 18 Aug 2025 20:43:35 +0800
X-QQ-mid: xmsmtpt1755521015t8giv81oj
Message-ID: <tencent_F8BAB8BB23338A9E2C1B4F4BD11BD9252E08@qq.com>
X-QQ-XMAILINFO: MyirvGjpKb1jvIfe0ZQPtffA1xM9u7Fz9RjGgPhMazjFVb/oLtXmsu2uu/1Ir2
	 2mnRWGly+vnIqATp/Wo2B8NM6MegoMfCpUzG7CBCvg4u4nyRPuYCciaohTOTKPudln5uxf/V6mV4
	 LeSv3Tz2FDY6sYfveRZUlfkMYTXaRO1yoyVuZJ77mf8q26ys2h8h70Yagjdlgm3nxgFApV9KoqzR
	 5bFFoKq7HT07X5JIHf7fbElT66SPPOCEPwU4NlmV3mvGz7ikmBJECiUNZCKdUvdMQX3+YZ8MSfO7
	 TRvcSp5TPyIUG12o6zb9GM7qiV/u9rH7Cly8PK9dQtYxPHw3wJ6D+jy9xBYSSetVD3+nroW5gVhG
	 hFdVttLMNgEo98y6ysN3IW4Q4QV4mRKuNEal/VOtVCIq7mpUFTWMhKZ93N9jYp216iXNGI88nKA/
	 5QSy7Pmoqo050a+R3X/4L2fMxi/8CU3ReHnj2S1cgrqY0XuXdR3H13U05nXCB6kH6Vsq0eJMUqJn
	 5SBB7y3EOjRXbYZmbEiIevM04MUuDfOD2+keFK44omLueTovYXYYW3ivg5EWFxZJXkK/U78Hp2vp
	 P1+EqWK9wjiZ3tg5ODZ7QKmoUElU+qMt+l86jZ+C0qIlMqAk/7Cs9gxHuB+wfi5ZmckPY3KXQ/3w
	 cxXfufgEpDdDiVlhewt5HwqDOkbaboqL+xQN9EUBAO2Y4p4x89Q1fYdapgzXnAhOapVvp5GFwynv
	 tIZOGEcShygCzAAknr/q8xxCs0vs2B36lRG/kNj4Oi4sobhFLQmxKuiFWLTLdiZrE0ukAeyhCOOw
	 W5x8M3J3zXUjSBhvrQ2TL4FhMya7RBkARDvcOJEd95yzhGCUuPUHk36cdrF5/rny6GgDBmtUv25N
	 KPef0OxvZkWb/fZTn98019xv4+GM2fo8kZKfwTnnOQeRR5U23crNMrtSfVgVSMez3kZ0RJ2vT54H
	 R9DLwNhTWGlo2orfyQY2vHmEC3iezR0WRdSxpUwGj7GX/ThIQA0WJFjHJxHviI
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
From: Edward Adam Davis <eadavis@qq.com>
To: smueller@chronox.de
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	eadavis@qq.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH V2] crypto: Mark intermediary memory as clean
Date: Mon, 18 Aug 2025 20:43:36 +0800
X-OQ-MSGID: <20250818124335.470340-2-eadavis@qq.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <aKMc5amKH9CLbKL8@gondor.apana.org.au>
References: <aKMc5amKH9CLbKL8@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 18 Aug 2025 20:30:29 +0800, Herbert Xu wrote:
> Their values are equal, so why use sizeof to calculate?
> Similarly, "if (sizeof(intermediary) != crypto_shash_digestsize(desc->tfm)) {",
> why not just use SHA3_256_DIGEST_SIZE?
Hi Stephan Mueller, can you explain it?

BR,
Edward

