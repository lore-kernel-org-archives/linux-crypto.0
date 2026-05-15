Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C362F44DB95
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 10:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778841768; cv=none; b=KRrLjg65YJptjJZ/TwAoVZrkMkfARdpGFwln/QyFiJZeCIvkmY7rQtaJxKr1kge+uz11cTd2qDL6Tb3fz+nVXErWaD1viThuTAVwHCOCmiccKisSn7Mj53XCIYKV9Vbbn19toql0mdVKn4dwZMp14oeG3lCv59z5qrAx67nj98s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778841768; c=relaxed/simple;
	bh=StWnblT7YN0bi6xYGC6zMDeCmOSsNVQa6N4egBwl1UM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=lpDWhTkOOZuWDsr4eaJzRnAY14scWjP2CkxVwsswn5nVEyzD2xtHyaE7K7x9X1bn/vWO9+tSh4+dCrUVMtpdiXANArmWp76vZlV5il8UdI/aoZ5ybg90rYswT4rDeRcr/G1KcdLwXKJdowjvuBj8cOS/1KInpFZib3rZXwkNZ4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=aEd2i0/h; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="aEd2i0/h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:To:
	Content-Type; bh=eNbiQcgmH+MjrMtsYqSjYk0ftSKMmPeV73kyzAk+1yU=;
	b=aEd2i0/hyeZ5OaYDEK4I86tyagS+rDKmDeqvyHK35ESoWbPZMHmfS6+7N9mX/1
	SNiT0wpSsH9oWxwprta4A8wNFnlZ+g3Lai5857JSwWkDUKI7YVQgnBt628bNDg8D
	8WN9ROOL5UcMXBMGxfP5ETWGF/9BXhcPS19g51CoIWMCQ=
Received: from [127.0.0.1] (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgDH6qJ0+AZqdErWDg--.1648S2;
	Fri, 15 May 2026 18:41:57 +0800 (CST)
Message-ID: <4e9aee15-62e6-4d71-a836-250c5376a8fd@163.com>
Date: Fri, 15 May 2026 18:41:56 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] authencesn: Refactor in-place decryption
From: Scott Guo <scott_gzh@163.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, Scott GUO <scottzhguo@tencent.com>
References: <20260515083645.4024574-1-scott_gzh@163.com>
In-Reply-To: <20260515083645.4024574-1-scott_gzh@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgDH6qJ0+AZqdErWDg--.1648S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFyrArW3KF4xXr1UJr15CFg_yoWxtFg_Xa
	yvvF9xJ34DXFs7Ja45Ar1kJ34UGr47XFyrCanFgrWfXFy7GrWDuFn2qr9rZrnruFWUGw1U
	G3W5JryfJr17ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xREqXd7UUUUU==
X-CM-SenderInfo: hvfr33hbj2xqqrwthudrp/xtbCxBV3FWoG+HWYLAAA3m

BTW, this should fix the Fragnesia vulnerability.

在 2026/5/15 16:36, scott_gzh@163.com 写道:
> From: Scott GUO <scottzhguo@tencent.com>
> 
> This patch set introduced the sglist_shift_{left,right} helper
> and refactor the sequence number handling for authencesn
> decryption. Avoiding write to the auth part of the sg list.
> 
> Scott GUO (2):
>    scatterlist: Introduce sglist_shift_{left,right} helpers
>    authencesn: Refactor inplace-decryption with sglist shift helper
> 
>   crypto/authencesn.c          | 38 ++++++-----------
>   crypto/scatterwalk.c         | 79 ++++++++++++++++++++++++++++++++++++
>   include/crypto/scatterwalk.h |  6 +++
>   3 files changed, 97 insertions(+), 26 deletions(-)
> 

