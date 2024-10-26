Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CC11384B3;
	Sat, 26 Oct 2024 08:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729933147; cv=none; b=mwert96RFfHdKDxKqIn/R7cofLQhAYmhkhoJQpIoOqXPzirWUiPjbHBhYUviT9TQJQCXjZyHW5fk5v4ugkG9826I04jHOWwLZS9MsW2Q6Q90FXOBzOIRqhXSCoMfNFi4zjZ76+bqWwmpfmz1ex9NiJGQS0yQ/R51djZLkWg1nak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729933147; c=relaxed/simple;
	bh=XpDACfcW5wf85mSvv95qq9HtbfUhovyLv+qjcN4pleI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eo/OmSi52gft+DWUOAhJ/EeyoKY22omA19bT0Lv5xdb/Nzv+YShOG5eI4t9rQ1Vi6ykOeypgnJlWjYop6YV+EfiK4xtbWxmYtoqq8mJxCAbMB0HJ+nBaZW218c1ebfjeNR9SW4PWICgtQgwCEL5Ry+/3mZtukS/vghOSJid+DwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=i0LFbYBe; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="i0LFbYBe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XbcrZjmVmh6VmKyR0gWsU21atBSf0oon2QYMuJoAF+c=; b=i0LFbYBeOYU56L9Ocy+q5sAMUO
	5r711VuCA/eoxoj27o3WABBl/WD+BfiTd5dQU/olzNrTZh4rXPE3pO7b4+PS2If3fqluaE5BPodmJ
	HIiE9BubwXzfZE50sytj1gKLpxcftcb2EcrAb9sAluF321G176CmJzNsOUvZ2ihetgdNS3zMtR3UY
	iRZWjBpTX8y64u8TwvAO8y0G9cUtpwHszTxWbv7eLAB0GO0Y4HeciK1mMOdqoFf0YJlb60X+lJkbx
	u7DF+JGCkeMOSL4zL81Ni6fKy8G53AkjlUpYcm0kfotZKBrOMzG+OAWzKyaVW0nTDZHgPr7hU/7B/
	8E4ERcVQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t4cdL-00CGnq-10;
	Sat, 26 Oct 2024 16:58:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 26 Oct 2024 16:58:55 +0800
Date: Sat, 26 Oct 2024 16:58:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "linwenkai (C)" <linwenkai6@hisilicon.com>
Cc: Chenghai Huang <huangchenghai2@huawei.com>, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	liulongfang@huawei.com, shenyang39@huawei.com, qianweili@huawei.com,
	wangzhou1@hisilicon.com
Subject: Re: [PATCH v2 1/2] crypto: hisilicon/sec2 - fix for aead icv error
Message-ID: <ZxyvT1PnY83Ilvyb@gondor.apana.org.au>
References: <20241018105830.169212-1-huangchenghai2@huawei.com>
 <20241018105830.169212-2-huangchenghai2@huawei.com>
 <ZxyMnWbTkf7JEnT7@gondor.apana.org.au>
 <02e70357-1a3a-44f4-b25d-0e8e7f430cb6@hisilicon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02e70357-1a3a-44f4-b25d-0e8e7f430cb6@hisilicon.com>

On Sat, Oct 26, 2024 at 03:50:58PM +0800, linwenkai (C) wrote:
>
> Hi, do you want me to remove this variable and use the old way to get the
> authsize?

The authsize parameter is meant to be constant throughout a single
encryption/decryption operation.  So saving a copy of it for the
duration of that operation makes no sense.

What is the actual problem that you're trying to fix?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
