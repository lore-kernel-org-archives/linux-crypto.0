Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6484113B7BC;
	Sun, 10 Nov 2024 03:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731211049; cv=none; b=CYE+ajjv4qH6IoMWaD3QIDly3di+KHlj+sl81xxl4UaeJUZZyTHmjPNGvIGM9GPqpSpBWGJzurEe0GIUL5UGYTstvmqCex4LVyHc/FS2UFI+wpaaW1Sp+tQl5O1KeI6v7qolwZl7jzjfOniNSa4Pb82wzUd4c+FY0KpW43vSwSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731211049; c=relaxed/simple;
	bh=cwymxSeRv7PHHOiKioNqrLXuediIMSop+VPf0eMp9Cw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=XUqkJElmUwzb29LTZUkEFPHrzVNYBaVE0paAYiielI/Qe8DNzUl93Byy9LtLS6+uuFJCNzkbKmSNKks3YOgISTPVmPCcamUdws22oV02i0Wu+gZcqF2JESKA1zclD1mKXFFL/TWByXvsbLOsBWtahQWYgsPWFVV3yj5LgOwRgl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=eYtJXhhk; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="eYtJXhhk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=xiMhtAu7jmFRSBfbEOiJ9g9MDwdAdeUwoO5tS+Rzo9o=; b=eYtJXhhku9DxHaZTM0xMRKuZzP
	/2JT5UBo7Uq6uZX6enRjJtYBCcVmwGXwSefZnUJwVaxLbC6LqkGuFv0km3m9unGt7G68Gy87aShB3
	JRmrhpnmWBEmlrk3ZON+ge2Vm/tXT8fl5BaKaygNGb9wZi7pmZNJH/tIp/yotfNFVASC5DW+qBAne
	2RdXYzvhJUSAwoGPo8cG0TLkTWXxvyxFVIWSJ/6GXBypsfm1Daq/ujnn0fKwQUvX+BA1Stap7oi+J
	pfJIT10zIpnc2+mvB8ZaNB+gMUJWxWCdoHJkWYI/b5VOmq07jti6eILBYUknYIVj0dh/23zkRIAp6
	9tDiteMw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t9z4d-00FkG2-1r;
	Sun, 10 Nov 2024 11:57:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 10 Nov 2024 11:57:15 +0800
Date: Sun, 10 Nov 2024 11:57:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Zicheng Qu <quzicheng@huawei.com>
Cc: steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	tanghui20@huawei.com, zhangqiao22@huawei.com,
	judy.chenhui@huawei.com, quzicheng@huawei.com
Subject: Re: [PATCH] padata: Clean up in padata_do_multithreaded()
Message-ID: <ZzAvG-s9tqmLfT7E@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241101091324.2372626-1-quzicheng@huawei.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Zicheng Qu <quzicheng@huawei.com> wrote:
> In commit 24cc57d8faaa ("padata: Honor the caller's alignment in case of
> chunk_size 0"), the line 'ps.chunk_size = max(ps.chunk_size, 1ul)' was
> added, making 'ps.chunk_size = 1U' redundant and never executed.
> 
> Signed-off-by: Zicheng Qu <quzicheng@huawei.com>
> ---
> kernel/padata.c | 7 -------
> 1 file changed, 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
