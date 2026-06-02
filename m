Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EFF1B87C0;
	Tue,  2 Jun 2026 19:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780428650; cv=none; b=GzUlNMAp6fzimZ/zP4BgSQ+FjKGUWn5XN1z5h7Ho9tl7r9098/up56lWOpo4gwMSkZ8RR45nK3MO0z2+0uBmcmTnl5MZzY36n3CmcXVs3Mon3IWWG75RjQxDoSZMjjnHyCSovuAvxiG7TfKkrtX51faxgKC3O8elCPS4H11HuIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780428650; c=relaxed/simple;
	bh=bGaCyEFj6KGukhVKJu82T6LpUzP8XtXS5qeq7ejol0I=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=UTSBF6sQNUXRKWsPuOQtJfDREkCrWT1GBZ8cU82RWsX27+1Be7NRHhyoNMZ5Fm2V42UDJSYChlXM+i+OJxT/232DdeL0wDVyOuC9rzRADtTlbYHkvYT7yskUC076Ww1J7IkbU+J04FE6619+A/5hAYqX3NXjDizAk8z2aYrYytI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=NsB6cgHX; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="NsB6cgHX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1780428646; x=1781033446; i=markus.elfring@web.de;
	bh=bGaCyEFj6KGukhVKJu82T6LpUzP8XtXS5qeq7ejol0I=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=NsB6cgHXSgX4HO73rrSNzMYVOqVXcvC6FiW5D+Z22zMaNOVo3mh5WTsEjg+kf+W4
	 5eqwDe+kDpXkZPF7GakqlyKd7NQeiOfVjscDwoVY1Zmy7HiqVMdU1Tdm3TJq7OMbZ
	 qtQoENIhRi94lqYGCVgGIi2DFIAxKRWn/2+dcyhU4oC24NTurgCrrAiYc0LLqWz0K
	 suFB1aLtTftY6JsWhgVbF0a6DkJEJIsXys9TwTdTascTvChJUwJyJ9c4TSaIefADp
	 KUCb5aBMzBPvEc43LtdTwrk24r2RwnHdrDRXsRsHO1/DjA7pFHhSEGNm8G1iJyoav
	 u8UIHYkryjZfaYLVaQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Ml46y-1x9HgI0ivk-00m938; Tue, 02
 Jun 2026 21:30:46 +0200
Message-ID: <1441c701-5b51-4122-9810-9d620bd0d5af@web.de>
Date: Tue, 2 Jun 2026 21:30:41 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Felix Gu <ustc.gu@gmail.com>, linux-crypto@vger.kernel.org,
 David Daney <david.daney@cavium.com>, "David S. Miller"
 <davem@davemloft.net>, George Cherian <gcherian@marvell.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
 George Cherian <george.cherian@cavium.com>
References: <20260602-cptvf-v1-1-d68e58e59173@gmail.com>
Subject: Re: [PATCH] crypto: cavium/cpt - fix DMA cleanup using wrong loop
 index
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260602-cptvf-v1-1-d68e58e59173@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:FOrr/eU0RRq/8bTvy5h2T3Lnc2t7/TtQKL1rsZsC5/1+KD1bgbg
 6NSK0sLA3mcUR62RtiQHRF8yDWqFh0Y0Zf210sRvFKr5KvsQf8IvpgwK6jmx/7bJl46+a8P
 dWQEUqrjSL1DpHdNZ6ycP5I9/3UvAuDGWQg7XUNQ1OLdSwJ6rJH5Iy2sFlscC2OdBUuhOPT
 HqIAznp7ecL5GOpTI1f6w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:VonjZFflQJ8=;Q2OFWRc65xEHbrqamEZWQZ1ffRa
 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
 XMEEt3voMexUTcQNTiyKaqUb3gc=

> The sg_cleanup error path used list[i] instead of list[j] when unmapping
> DMA buffers, leaking successfully mapped entries and repeatedly unmapping
> the failed one.

See also once more:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v7.1-rc6#n94

Regards,
Markus
