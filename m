Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383C323F36D;
	Sun,  2 Mar 2025 06:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740897663; cv=none; b=asCB3MflncCyLdpci124twkKaVtjR+NVp1/ASLgzxynqHqM47DG0k60X3imvt6mAUUH+JPcx6SK0Wos+uVu/qeFnqNI9CQF/llEjoALT+PqvGFsQfI7UnHoeTa4xTGDLPF4EVpPNMSHJnX5F12vMGmGhOH4Bq92035TZCr8UPac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740897663; c=relaxed/simple;
	bh=yxq4X3IfJINbbbYLJR6PKFBSfpb5xyESOM5xNISaKZE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=dz0TNH/MYShN1oq9wIYJjmuO2eDJkg51Wx19X4DngMfohoylrV4mkzEvDdcQqrBRZKD9KC7Ud8XHDmGQ5ANjSQJO4aiVgN0nknyGMFVsE71Bx7cObgdI5s5CdZT3LhWDLxVEXhFILMiYRtu+3w4bXiB1Gwa7urTUny4sQuEBDZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=f/oMS9Qc; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="f/oMS9Qc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=oJ6rtl0wk9Sb31dv82nKyLaT80n6BvewvPmU67I/T9A=; b=f/oMS9QcItfgmEptN+PliM+xk8
	iUoZA2+Fp5cVMNLb1sipyBxkuqgfRUudFsszwQ76woXKTtjwrKUftDTo7kP8/eEYRiQplU63db0sD
	AzK38m4Kvc/sjQKX+uMMe2VgM1RkALHjm4OzJuXqha79ifg1eHdkGU3BOp3qUp/K98UrOOSOXQ/fB
	I9HxTOdm1NIcqn88KRZiwXaU7FXiixzAJudn75HHqVCT64sf15hIbp7t9qc8VK8UhQjXPy09kV221
	/8oWe+HF3pjCK6z8pfCv+8o67/g0n/1S37teA/F/fJJal9RIzLgqrlalWQfe/NQ0TtHS3jHlHosgj
	QZd1PgVg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tod0S-002zYy-0G;
	Sun, 02 Mar 2025 14:40:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 02 Mar 2025 14:40:56 +0800
Date: Sun, 2 Mar 2025 14:40:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Akinobu Mita <akinobu.mita@gmail.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH v3 04/19] crypto: scatterwalk - add new functions for
 copying data
Message-ID: <Z8P9eIGDlT3fs1gS@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219182341.43961-5-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel,apana.lists.os.linux.netdev

Eric Biggers <ebiggers@kernel.org> wrote:
>
> +void memcpy_from_sglist(void *buf, struct scatterlist *sg,
> +                       unsigned int start, unsigned int nbytes)
> {
>        struct scatter_walk walk;
> -       struct scatterlist tmp[2];
> 
> -       if (!nbytes)
> +       if (unlikely(nbytes == 0)) /* in case sg == NULL */
>                return;
> 
> -       sg = scatterwalk_ffwd(tmp, sg, start);
> +       scatterwalk_start_at_pos(&walk, sg, start);
> +       memcpy_from_scatterwalk(buf, &walk, nbytes);
> +}
> +EXPORT_SYMBOL_GPL(memcpy_from_sglist);
> +
> +void memcpy_to_sglist(struct scatterlist *sg, unsigned int start,
> +                     const void *buf, unsigned int nbytes)

These functions duplicate sg_copy_buffer.  Of course scatterwalk
in general duplicates SG miter which came later IIRC.

What's your plan for eliminating this duplication?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
