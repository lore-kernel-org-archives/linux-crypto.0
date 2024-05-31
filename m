Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D998C13213A;
	Fri, 31 May 2024 09:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717148046; cv=none; b=qOWXJsJyQtGsJsvCZxU9GWMHtyXmLd/6fo43yFUOTqUm1b332nf1PzesxAw8WeSN/8s4KJ+ZzN/G7qdmEcZQzqHFehzT+5urjX6JJCeDVr6z4wi7s7Ey07o3nQavUBvCAk0x5i5uf+qBs92skqi9H46p5UsJ0iezf1sqtXossPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717148046; c=relaxed/simple;
	bh=WXpD4wzZsZ0tO9sHjjJP1k1ZOFd/a4IsigefPl8BtoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YoyqfEdmGBVT7YPz6CCQBiGv+3UhlclU5ikCDVcysdu3iJutLS563RlEPglmN/CVjP+GBcWWps7zfUzs/JfT/b4m/ZScsik/tvAF7RWvQmhDAhHtURlhMk0Cp6zOlEeE1F/2iieeN3OI5iGyA/cEQUHgFZ/cYQf54EnUKnJHjOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCye5-0049jT-0V;
	Fri, 31 May 2024 17:33:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 May 2024 17:33:59 +0800
Date: Fri, 31 May 2024 17:33:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, shenyang39@huawei.com,
	liulongfang@huawei.com, qianweili@huawei.com
Subject: Re: [PATCH 2/2] crypto: hisilicon/zip - optimize the address offset
 of the reg query function
Message-ID: <ZlmZh5d8RDo3C-HS@gondor.apana.org.au>
References: <20240506115953.2282155-1-huangchenghai2@huawei.com>
 <20240506115953.2282155-3-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240506115953.2282155-3-huangchenghai2@huawei.com>

On Mon, May 06, 2024 at 07:59:53PM +0800, Chenghai Huang wrote:
>
> @@ -807,6 +786,18 @@ static int hisi_zip_regs_show(struct seq_file *s, void *unused)
>  
>  DEFINE_SHOW_ATTRIBUTE(hisi_zip_regs);
>  
> +static void __iomem *get_zip_core_addr(struct hisi_qm *qm, int core_num)
> +{
> +	u32 zip_comp_core_num = qm->cap_tables.dev_cap_table[ZIP_CLUSTER_COMP_NUM_CAP_IDX].cap_val;
> +
> +	if (core_num < zip_comp_core_num)
> +		return qm->io_base + HZIP_CORE_DFX_BASE +
> +			(core_num + 1) * HZIP_CORE_ADDR_INTRVL;
> +
> +	qm->io_base + HZIP_CORE_DFX_DECOMP_BASE +
> +		(core_num - zip_comp_core_num) * HZIP_CORE_ADDR_INTRVL;
> +}
> +

This doesn't even build.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
