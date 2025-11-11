Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF072BB17;
	Tue, 11 Nov 2025 07:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762847126; cv=none; b=ASrGhwUjv0/h8Ku6wJ3G6WOA3RohO5A9tJiyv3Jns953vbHtw14XgZVbJmGs/FJOcNJzWvNMwfriiHEawxSYc/g+Q/+lMBj8ISc6FMcuJVvJ+UgnHHSth8y8xh1CUS05/pUaqVbLNKbtQSCFpb2qXr1FeZMa2SnK2wV8oOcA9Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762847126; c=relaxed/simple;
	bh=kTmo2x6zuAhJQW95nab+9WiQ1laTWaIabF0YIpugNN8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T+P4g9nCz7CTfVvifZ0/SXLxVl1z3LrxxvIbK1P7qGiIWYnXp3hN+uVXEp8Gqv7bSKWDP62jzmEwuAXjarFZMN2Ar7Np2U6GqpGlbgtEG1mho3YudvAt88MFJMEzKEEeyGvXZ3rhIZonAvuuJ+NePvthaJWR3Nifw1Jdu336g6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=mt3k4Nld; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=mt3k4Nld; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="mt3k4Nld";
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="mt3k4Nld"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+xb/xGFV3+SOYW1VLDvSVDCTrOmrz1O3z37sbePsiVU=;
	b=mt3k4NldqM69rlxFsAGrZHPjNHv4YKnartDTFn45ZFYQZiGzXIul58Ve8eLPAxrNROEKcDzIK
	w7xGOYIWFiOmQqZzLfPFYxs3ElcUWK/L9PftaNWGQGngyruQO5js15CNLIu1wvdKQn6WPKL/qWE
	T9BSHhp1SLUTjEMHv0wM1E4=
Received: from canpmsgout04.his.huawei.com (unknown [172.19.92.133])
	by szxga01-in.huawei.com (SkyGuard) with ESMTPS id 4d5JTb3Rz9z1BFvc;
	Tue, 11 Nov 2025 15:44:51 +0800 (CST)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+xb/xGFV3+SOYW1VLDvSVDCTrOmrz1O3z37sbePsiVU=;
	b=mt3k4NldqM69rlxFsAGrZHPjNHv4YKnartDTFn45ZFYQZiGzXIul58Ve8eLPAxrNROEKcDzIK
	w7xGOYIWFiOmQqZzLfPFYxs3ElcUWK/L9PftaNWGQGngyruQO5js15CNLIu1wvdKQn6WPKL/qWE
	T9BSHhp1SLUTjEMHv0wM1E4=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4d5JRx1ZSjz1prLT;
	Tue, 11 Nov 2025 15:43:25 +0800 (CST)
Received: from kwepemh100007.china.huawei.com (unknown [7.202.181.92])
	by mail.maildlp.com (Postfix) with ESMTPS id A6E5B1402D0;
	Tue, 11 Nov 2025 15:45:04 +0800 (CST)
Received: from huawei.com (10.67.174.33) by kwepemh100007.china.huawei.com
 (7.202.181.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 11 Nov
 2025 15:45:04 +0800
From: Gu Bowen <gubowen5@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>, Lu Jialin
	<lujialin4@huawei.com>
Subject: Re: [GIT PULL] Crypto Fixes for 6.17
Date: Tue, 11 Nov 2025 15:57:39 +0800
Message-ID: <20251111075739.1649924-1-gubowen5@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aMzXm4zy8LARVMbk@gondor.apana.org.au>
References: <aMzXm4zy8LARVMbk@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemh100007.china.huawei.com (7.202.181.92)

Hi, 
On Fri, Sep 19, 2025 at 12:10:03PM +0800, Herbert Xu wrote:
> Herbert Xu (2):
>       crypto: af_alg - Set merge to zero early in af_alg_sendmsg

I have a question about this patch: is the "fixes" tag not quite
appropriate? In older kernel versions, such as v5.10, MSG_SPLICE_PAGES
is not yet supported, so there is no need for ctx->merge = 0. Perhaps
d3dccb0a487d ("crypto: af_alg - Fix merging of written data into spliced
pages") would be more suitable.

Best Regards,
Guber

