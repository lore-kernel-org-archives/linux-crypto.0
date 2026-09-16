Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1462737DAD7;
	Wed, 16 Sep 2026 12:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789563197; cv=none; b=R2r5N3FDD/sUs4civ1fykmwLI2r/dsVqdku1dPVahcVFiKWnB1ovijN0e7zk3k6lNeRO8AL05qVF6uE2U5gxeP+avPxJ0n7QoIlg++Ujul4fE8WZSOFhK10NE5gantGGsC1PpWEiRiLk2IndsrPRKvGgXpRM1fetFmr/k5AFN/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789563197; c=relaxed/simple;
	bh=SDEuKJWFUu4rxwRXql92imyjaRjmcdWpg/QNpjRH5WU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bunt0sgB5XZnERjYkRfaU26u+iWrLCLm6xpXGFyxYt2hLQDKVbpm8Z3pJhrIC6Hr91pJ+NivVWRNim/L1QS3ktXeA9uphJdmySNADjwU02EKTKQtNNh06av0W+plgNg0rRPjH95c0OcQVwDIA1+tIYN82nAkWtF8V4Jc9WMEyxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=AbsZtPNP; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="AbsZtPNP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=frmbW3ytDefx8E7jzaxczuNaM+HvVXs4OMdHP3+s2zw=; 
	b=AbsZtPNPn7sQ5LMeXpHv4RX+w9iQGCC0JgzGNGk2a7M77zwhAC3Qevl8Rv9CPXGhug3F9amN4M9
	GwdnNbaKG5pkMs75Fxve7qpBAjV9CFkiyzkdnQ0kZCfQmPQbl4HLvAinEWdMGSfK3JO90lcj0ivZS
	N4j5K/kZvvyi5+/EQ9ql9AhQNlbDUZtoYsUVL6qJ8iZBUpP7p9whGnsNG6Cg2/bDlwl4LI8ycWYgb
	EPyMDhtzfL8onagp563ZvNm1kZVq3F2Z3FsW5gqxtca55UydQpfkQtVO7f7C4xBjPTES9qe6R+/mf
	jfv/vRg5ltZTxWkpWhQBrvD3Gqn1h7RGnGrw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x6p8Q-0000000EcXc-29Fr;
	Wed, 16 Sep 2026 20:53:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Sep 2026 22:53:10 +1000
Date: Wed, 16 Sep 2026 22:53:10 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: ccp: use named initializers for
 acpi_device_id
Message-ID: <aqqRNnSNAcM-kocL@gondor.apana.org.au>
References: <20260903-acpi-crypto-v1-0-253cc6fd9836@thegoodpenguin.co.uk>
 <20260903-acpi-crypto-v1-1-253cc6fd9836@thegoodpenguin.co.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903-acpi-crypto-v1-1-253cc6fd9836@thegoodpenguin.co.uk>

On Thu, Sep 03, 2026 at 04:42:16PM +0100, Pawel Zalewski (The Capable Hub) wrote:
> Use a named initializer for the acpi_device_id fields which
> makes the code more readable and consistent with how lists
> are initialized in the rest of the kernel code base.
> 
> While we are at it - unify the list terminator to have
> a single space between the brackets and no trailing
> comma.
> 
> Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>
> ---
>  drivers/crypto/ccp/sp-platform.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
