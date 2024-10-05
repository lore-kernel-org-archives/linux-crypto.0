Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FE836B0D;
	Sat,  5 Oct 2024 05:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728106834; cv=none; b=npAGZan1BRulUguZ/DPkt/ZMHsSykcPLRnIZx+kU48OSskucD83HQlXdt68GdZVpyuoQi0gMdOMrCQEqu95Ovjp/nN5jtXkAMTAq/t0v0U0qnHp2hgGEF1rQrIwfvN5zMH0Rnp5i+Tfn3ISDJuAFEeLaDH8cp1jKLgg/VtAhKbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728106834; c=relaxed/simple;
	bh=leDR1ASxlHLSN1MyjUM/7VkD3rHTOKjFcHOdwuQJi8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KPBk+9Lfclk7KvYcd147ISO0N797P982LaGh1M7QJrn26BMjxgu94cPTn1wY8JVsdU8Hy0TBYjdGg1rI4K1idnt2hDgHWVLpbhEtZVCdpCXnEQWozHoTzyRB0AyDkUJictcCiVkXt3h/vyqOIF9g0nTnGsoGJobHIV/iq5975z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JZdyPUwO; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JZdyPUwO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zbv4rqZt8nPpZwKYqU1gXSuhasgl/AkFbu9ZivIGO4Q=; b=JZdyPUwOWBA8AOD28YCHOi3LhT
	vt4KApw0xXlGSgyw0sKYVlx5JvANhfTlx5IsC43v81cxtx9EgdXQ6IXQx/tn4PHQULmMSY0QTROPG
	9pcXLWBrcuJeQD3qZgKJfJh0tSienikHJrNQtM0tsnXLmHXVflLH+IlwFqjFzhBxCD00Yqp4J4iB/
	5O9AXxHFvQmBlxQczYzS837S4bftUawcbWtQGsWGNcy+U61qdFtk/CioOT8MXv+6mPdzJ3AbK6oqC
	gppGhgn9e2UESUvy3ioX7OtHr1G3BU174mIhWEKbxy4LY9joAoTNP6SnklCioyc01Lktjvc8HQuJj
	feaLB35A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1swxMp-0071eU-2N;
	Sat, 05 Oct 2024 13:40:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2024 13:40:25 +0800
Date: Sat, 5 Oct 2024 13:40:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, liulongfang@huawei.com,
	shenyang39@huawei.com, qianweili@huawei.com,
	linwenkai6@hisilicon.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH] crypto: hisilicon/qm - fix the coding specifications
 issue
Message-ID: <ZwDRSaT26p68x8gn@gondor.apana.org.au>
References: <20240929112657.863594-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240929112657.863594-1-huangchenghai2@huawei.com>

On Sun, Sep 29, 2024 at 07:26:57PM +0800, Chenghai Huang wrote:
> Ensure that the inline function contains no more than 10 lines.
> move q_num_set() from hisi_acc_qm.h to qm.c.
> 
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/crypto/hisilicon/hpre/hpre_main.c |  2 +-
>  drivers/crypto/hisilicon/qm.c             | 31 +++++++++++++++++++++
>  drivers/crypto/hisilicon/sec2/sec_main.c  |  2 +-
>  drivers/crypto/hisilicon/zip/zip_main.c   |  2 +-
>  include/linux/hisi_acc_qm.h               | 33 ++---------------------
>  5 files changed, 36 insertions(+), 34 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
