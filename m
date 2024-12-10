Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6248AA94D;
	Tue, 10 Dec 2024 05:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809761; cv=none; b=NipMYE3Z5zsa7q2Q5d0FwB/BZeutHG8+o4Hn2Ugs4i1Ui10+276W90rrath3BbLVsSf2WYSHUwrrgfk8wE8ijrsUgcyPePHBXNrNxyBx8ChzeRlSMInuK7mMSJUTrJPe7l/6W5o1L++XYqUgrJAKMYpRedJIEmnFY/zU3wbJK9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809761; c=relaxed/simple;
	bh=UMhfSGvDAo2n3fT6khkxZqhHqGzwcOztP3JLwFstvGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QRrpl6Uk1cXiTncSo8XddAT9Fyh/Svjvf5a+I1aLUk9fZe3EJKziZicFYs6fRyXfvVkzJ9IMGVj+c2Jxv0r5CCFpAZaqNc2yVHFzT4A9kflZPXrl1S1Np9G3vW1cny7hj8sSH3/xg7MOfLCvAdmqYpRuRH4DokxCkwzIE/JCluQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=T5d0IlT8; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="T5d0IlT8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nGSMm76vfOUFKovXKofALU2UQdEMkJR9usNJFgfsWtY=; b=T5d0IlT8mdglKRjur8L54NdmvR
	gliZRn0VskMByB4804oVHyx8yaUWIpCoPtd86H6jRR84EVeBzZc8Vme6xIs/88GjsDkW/SLZ/E8y9
	oHRDfGjhvAgT4HdHtCXclOnfl9pZVB5ZJdwHS40vgMzvUX5WnEnzh478Vu475wbqY8aHxnhqHRIgf
	aFXiOE3XPjQ6P82j+1q6ysjxxXFq5/fWWNSat+xn362vTCNlJWAzKhlNbhFd2NKEkUWEOxuR+TYZ3
	3ryT/VhDD7tdanKXn1HllXkASMuyCDGzpEMfOivBbp+G/J5chrdiZKP2vPsA7/qi6jHB+bUFwgoLi
	BnSJyeLA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tKsuZ-000OE2-0W;
	Tue, 10 Dec 2024 13:49:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 10 Dec 2024 13:49:15 +0800
Date: Tue, 10 Dec 2024 13:49:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, qianweili@huawei.com,
	wangzhou1@hisilicon.com
Subject: Re: [PATCH] crypto: hisilicon/debugfs - fix the struct pointer
 incorrectly offset problem
Message-ID: <Z1fWWw7RuyyADQU3@gondor.apana.org.au>
References: <20241130080131.906598-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241130080131.906598-1-huangchenghai2@huawei.com>

On Sat, Nov 30, 2024 at 04:01:31PM +0800, Chenghai Huang wrote:
> Offset based on (id * size) is wrong for sqc and cqc.
> (*sqc/*cqc + 1) can already offset sizeof(struct(Xqc)) length.
> 
> Fixes: 15f112f9cef5 ("crypto: hisilicon/debugfs - mask the unnecessary info from the dump")
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/crypto/hisilicon/debugfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
