Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B41208DA
	for <linux-crypto@vger.kernel.org>; Thu,  8 Aug 2024 05:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723094236; cv=none; b=ik5w1zf1IvqFmo79tGch9nIJdPe5foFAYcnU2NtMvht7uk49xKnV9wgX+LAFfiEPoDWN0uJ7UNqDFNPnKsNwXrsbeJvccvTVyYuZf7BD9A9beZ9gvA8umca0CAGzVRYaCQlnPzIbe9ZiJ1RwXtyzsTA9vueKYFj0RemRA/AcBfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723094236; c=relaxed/simple;
	bh=u1r6eTfjkeV+udhXu/gjDPEPQhH+r+aYy5m3u6/Zebk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=grGz5kyzeYHt3DJlIGzZYcED4IcOJ22ypfds9ZG9/CCvhChxj5Fykl/+7LXxKykDBvWLHP6IMbExaUc6aZOHZE9//e/2VXUp4fIGVm8Vv106UQc47oybUNy7dD/Qjue+pz4FAlyBqvenwJJQW0e1jF9abHoy/mMpOTb2E03xZL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sbvNo-003EAr-2I;
	Thu, 08 Aug 2024 13:17:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Aug 2024 13:17:01 +0800
Date: Thu, 8 Aug 2024 13:17:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Jeff Barnes <jeffbarnes@microsoft.com>,
	Vladis Dronov <vdronov@redhat.com>,
	"marcelo.cerri@canonical.com" <marcelo.cerri@canonical.com>,
	Tyler Hicks <Tyler.Hicks@microsoft.com>,
	Shyam Saini <shyamsaini@microsoft.com>
Subject: Re: Intermittent EHEALTH Failure in FIPS Mode - jitterentropy
 jent_entropy_init() in Kernel 6.6.14
Message-ID: <ZrRUzaPVqoDAcRLk@gondor.apana.org.au>
References: <DM4PR21MB360932816FA7B848D7D8F7B0C7B82@DM4PR21MB3609.namprd21.prod.outlook.com>
 <2143341.7H5Lhh2ooS@tauon.atsec.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2143341.7H5Lhh2ooS@tauon.atsec.com>

On Wed, Aug 07, 2024 at 03:21:04PM +0200, Stephan Mueller wrote:
>
> The proper way to handle it is the following: set 
> CONFIG_CRYPTO_JITTERENTROPY_OSR to a higer value as it is - like 3 (the 
> default is 1). The higher you set it the slower the collection will get as 
> more samples are collected.

Stephan, it's not acceptable to rely on adjusting a Kconfig knob
to obtain a working system.  This needs to work out of the box.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
