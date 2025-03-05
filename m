Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1044A1D
	for <linux-crypto@vger.kernel.org>; Wed,  5 Mar 2025 01:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741139208; cv=none; b=VIV+S4q3SI6W3Pbzm1KDgT7+fPTP86IsWzhhr8ovrd8DpbIGcmt/QKBer/3ruRonHXexUhTTjU1q9XVWzYgkBGbvUc/xX0kxYkm9JtqrA2mjQmzaBqXFPMLmbdSGcxEPCYQLe4BuDYMudSu7GNJNWGHYFXPFfciKe5HD6k0RQSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741139208; c=relaxed/simple;
	bh=0s6RwgnleuUYX5XEA/Rxvh9opXaMoIInD2x/r8Md4lU=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=saa6PSFZ+Tz4uFQFaAMdBFn4/G1Xi6J/aokEMZFLOo1/iUt7NlSHwUb3j1pOsmfibG43TtdVLNC9j2g/7faEBy6Q3JXQN97sd3LilYJH993e7k65cQ+cGt40W88zJBCtsZWzd/J08rGPysT72Z3rebn4DsK48BeotOclNMQKI0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Z6wLn5tr7z6M4hQ;
	Wed,  5 Mar 2025 09:43:45 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 5A42D14011D;
	Wed,  5 Mar 2025 09:46:42 +0800 (CST)
Received: from localhost (10.96.237.92) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 5 Mar
 2025 02:46:40 +0100
Date: Wed, 5 Mar 2025 09:46:36 +0800
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	<linux-mm@kvack.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, Kanchana P Sridhar
	<kanchana.p.sridhar@intel.com>
Subject: Re: [v2 PATCH 0/7] crypto: acomp - Add request chaining and virtual
 address support
Message-ID: <20250305094636.000067b4@huawei.com>
In-Reply-To: <cover.1741080140.git.herbert@gondor.apana.org.au>
References: <cover.1741080140.git.herbert@gondor.apana.org.au>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 04 Mar 2025 17:25:01 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> This patch series adds reqeust chaining and virtual address support
fwiw "request"

> to the crypto_acomp interface.
