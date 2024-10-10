Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92B31BD017;
	Thu, 10 Oct 2024 09:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728550817; cv=none; b=EBmHHqYViW0kfpTFxnZrkbCqMtztfdGtNR5Nb6ygSTY/azy2EuIjk3Z4PPQqbdV1wcMBd/J2sglPy/ttx+40DI/qxgseKG7049QAeXHtCXPEgRkrR0vDgDm1U3MTqMIM6cJmbC4bUQCbpGCA+e9io7o8+aoiRYPCZGEhGRp8ay0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728550817; c=relaxed/simple;
	bh=U8SxVnAVHzuRY7VCMPeQCfJNpXkVSrJ97x+DqFONmsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Il2qWS53vZQUaaUzd+ksBQG3O5hMMvIhXUDBmDWa6qFljzPOVZORbYskP6xcUmvrn0Puz0etihjeC46rIATe+vjo58kk9un0HlLWXAcQeZk5b+ryxb2YM90/vOahkxlxIzEu5LR1/2jiOvZVms4HyC8Io/eOVCjhzNH7MM8LyfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TqgDlZx6; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TqgDlZx6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZCBSjUnQFjWSKeoJh1UwM6CIv3oysyownOhSGE3HrQw=; b=TqgDlZx6vZQCLByGZuSemZcjDl
	VFfB4j5hYmClSnovZpkMGwa0s4/SPIbu734NyqVCcNG4fAOiFqqndZvU3YBtyEiYn46Y8jHyVc8RP
	28lSwE3J+fTgi8J9Yjp6GKEf496ZJkmfamvH5HE5YJPJdwXPJE3+HbvDK4FpufLOmRbnNQuCsKu5O
	mqYKwi9KAADymijXUO6S7kvS7J1XUMaLKJKUxQ6qOUJoJahzu+zGEiHY+lPOivfdiSAen89Ip0xGK
	t4OMbK3G0RCi+hDS8vRBsNYBAvaJqUqh9vLcjcjZLuWLmN2nHdae7biE6c0d5g3xR0VZWGXlv8l6Z
	5k8naDqA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1syorm-008HuP-2I;
	Thu, 10 Oct 2024 17:00:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Oct 2024 17:00:04 +0800
Date: Thu, 10 Oct 2024 17:00:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev
Subject: Re: [v2] crypto: lib/mpi - Extend support for scope-based resource
 management
Message-ID: <ZweXlC7G8rEK9rB7@gondor.apana.org.au>
References: <bc5ce9ad-acbd-4f3b-91d6-10cf62bf5afc@web.de>
 <202409180725.ZV8DCvII-lkp@intel.com>
 <91d10516-4ba9-4fe0-8f63-86205cc4f88c@web.de>
 <ZwDPp4bU1J5uEgQe@gondor.apana.org.au>
 <9ddc71e7-e98a-4fa8-b140-4035dd2874b6@web.de>
 <ZweTCO8cFtP_pvOu@gondor.apana.org.au>
 <4aef34ca-4665-4e92-8ce8-8a8a2fb472c9@web.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4aef34ca-4665-4e92-8ce8-8a8a2fb472c9@web.de>

On Thu, Oct 10, 2024 at 10:58:26AM +0200, Markus Elfring wrote:
>
> Do you find the proposed software extension generally reasonable?
> 
> Can any more source code places benefit from such a programming interface adjustment?
> https://elixir.bootlin.com/linux/v6.12-rc2/A/ident/mpi_free

Please submit actual patches using this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
