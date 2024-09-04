Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8414317B
	for <linux-crypto@vger.kernel.org>; Wed,  4 Sep 2024 03:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725420584; cv=none; b=p0YE7k1MJ7ekZqu6rfyiKkDUE+8MdaZL6swE7o1r1VS3bRkQCrWijkplUU7zcqMp0w1IMGih5aty56h53oYQH4Pfg+JYJzRrzQqopG7v3ZUYXQMVLPf0yUc5AnJ5ELV0BbP9o6KJWu6AdAWVD+7iM4KeCdzAT/ufVVFLUfkYPD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725420584; c=relaxed/simple;
	bh=hE+7QsLxsSJBqP/XjBr+yfiIe7bEqH7+qH5gI/GrP7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FJWPp2lkKUTH3efZwk8J4RsEwpzk6PruCps/Ht1X/Ja0dl8XLykfP69NbcL1zs1Yn0GZjFIXLzPXKFbbWsL2agLb/QEj5JR7AdsN+xVlsCE9JjbugJFltqnIX+iatYupqcZvtEaLy/XoPTPVrjtjk3aEDDc6xDZ3syaP9vLhQC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=EsPq7J3t; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="EsPq7J3t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xPCpq5JR+5Iq2+ArK/GAvTtCHMk7AR9Dk4HW+LSI+WU=; b=EsPq7J3tLisa3bmp+t6HqlE76B
	+VmpB1Vz8L7pqdJS7OiOZSOwEyWuBZMOzgSZnkEn6pfBtQVleyyHWl06nUlVOH/+Hr12v2lpG7Ph8
	qDd5L5vzZTFdZgoF/ZHTU/1l34r/KBj4QthZ/GnBChqQORFBT7AH3Ue1b8VyWmXRZgUJ7XBheeWcz
	5Ttjl9v7kVoCryGxqQvyOXc0zDKEd99nwIIRIGd2c6SlqUBK1gNJyHJ717cL8l2U87JnV3UDnKUqz
	4eih1a13sMlzCpBeUVNkD4ZJ58xlc1fjODGSwkvXT4MIYwvzH0jF3HwHBmVbMUAerNioqqycKXDRr
	Us1Dy9cg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1slgi7-009WKH-2P;
	Wed, 04 Sep 2024 11:29:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 04 Sep 2024 11:29:35 +0800
Date: Wed, 4 Sep 2024 11:29:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: Rob Herring <robh@kernel.org>, linux-crypto@vger.kernel.org,
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v7 0/6] Add SPAcc Crypto Driver Support
Message-ID: <ZtfUH0l-bDzLaj25@gondor.apana.org.au>
References: <20240729041350.380633-1-pavitrakumarm@vayavyalabs.com>
 <ZrcHGxcYnsejQ7H_@gondor.apana.org.au>
 <20240903172509.GA1754429-robh@kernel.org>
 <ZteU3EvBxSCTeiBY@gondor.apana.org.au>
 <CALxtO0=PTBk3Va-LcRfTKUb4JCSDB0ac6DBcGin+cwit_LDCDg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALxtO0=PTBk3Va-LcRfTKUb4JCSDB0ac6DBcGin+cwit_LDCDg@mail.gmail.com>

On Wed, Sep 04, 2024 at 08:24:42AM +0530, Pavitrakumar Managutte wrote:
>   I am pushing the incremental patch. Please review it if the driver
> it not reverted yet.

Sorry, the driver has already been reverted so you will need to
repost the whole thing with bindings.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
