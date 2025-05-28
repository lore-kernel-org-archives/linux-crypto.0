Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F32244678
	for <linux-crypto@vger.kernel.org>; Wed, 28 May 2025 07:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748418158; cv=none; b=XAJBN55Sz0adTIXMHNPQbzOliSvi5AQ2qheduew8TdT7yhqfOKq0z4P1h1BwECfQH55jWHZQZQOtZnUbZTfaTcopLEWCnIfnJm/IRfd4Yf+jPOcBYjNJlDs/xYqMq3BgJXFGo2Jp4Q9f912dIICaXXOgETbUI+hHzG6n49EL6pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748418158; c=relaxed/simple;
	bh=xYJevYiGKI0K7avOKmDDQjjiD0+OYWRjkuns92h5r1U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LVuCcahUv4tCkx2mZUZZ0D0Xh1KFdMLWdt96FXWKg3WjZg57s7dHh3O7QeHjE7Ltq30OqEa4rUytHos/JWfeGLV10JtMVqjG+QwfXlBa+cCenGHKQF9kLew5zbNeZ2LqoYpmXvV6Iay+PxhxpkK47v6cLqmyGpaRzwVbqV5dHfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FUN/QgMS; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FUN/QgMS"
Message-ID: <edd25df6-47a0-410d-ab48-54a0660c6149@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748418144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XWpUHx95xVQCUGTqWlHukBzLJnxxv1s1PMTNi6sAZco=;
	b=FUN/QgMSNmz/dsJyLSQ9iduOvw6nDteuE2lDMs+7mz6z+byomfgosG2T1MsoPBeBuVGhR3
	DBo5chzKTeQei5Z+/poQJRfeZGsrvUQPYNRBP56S3w7sjU3iWWntUmD91zAaH5rj//wrCs
	WazTaJjqCQLRdwYSootlfyykjyxhnlA=
Date: Wed, 28 May 2025 15:42:07 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v10 0/5] Add Loongson Security Engine chip driver
To: Huacai Chen <chenhuacai@kernel.org>, Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: lee@kernel.org, herbert@gondor.apana.org.au, jarkko@kernel.org,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 davem@davemloft.net, linux-crypto@vger.kernel.org, peterhuewe@gmx.de,
 jgg@ziepe.ca, linux-integrity@vger.kernel.org
References: <20250528065944.4511-1-zhaoqunqin@loongson.cn>
 <CAAhV-H7hBksA2P+vfMbpDVnbjW1Mo09Out_wOQLgLRXPLaFCfA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yanteng Si <si.yanteng@linux.dev>
In-Reply-To: <CAAhV-H7hBksA2P+vfMbpDVnbjW1Mo09Out_wOQLgLRXPLaFCfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 5/28/25 3:17 PM, Huacai Chen 写道:
> Hi, Qunqin,
> 
> As I said before, why the patch "MAINTAINERS: Add entry for Loongson
> Security Module driver" is missing?

Similar issues widely exist in the Loongarch mailing list.
The cause should be attributed to the mail server of Loongson.

It seems that Loongson Mail can only send no more than five
emails at a time. I suggest abandoning the use of Loongson Mail.


Thanks,
Yanteng
