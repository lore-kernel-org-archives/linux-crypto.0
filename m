Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABC91779B8;
	Wed, 11 Jun 2025 02:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749608317; cv=none; b=qAyAbmmpI7l5ZztvfbGiGmUrm++EK9k0kaeSKQu2ljAxO+AuP57nyZxKtvORaQg16sc+GI6kbufT6B96wK4LqeXPqvRi5Cg3Ki7ApEqf9D9lsLLGOhKmg/NwwVr1CuRRnnLy8Omh3291Wk/32Nqh/2fJRKqH+xNEixbRtCKi2YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749608317; c=relaxed/simple;
	bh=nJg3fXUbanYONt65/Z46lxZ+uzpCMjnN9glGRCq6Zjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oZGorSCc1ekXCI+yUN66yiV7DTnA9ixgZwZacMWD6lDKqpBsP+GQoZdlHDDuQIIwr1kOYsXxcz5s8hJHl7lU6cTR/UwpZPBpJI1zVh1/C3ZlhmBauSbXGjNSkmMNOYJV1Y11KjB9lbRrm5OA+keTLWeRU0UPKsQmb9bll/NUc1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=kN/3bCIW; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="kN/3bCIW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IuJnBGEYZBtUaLzm2eemejs/8BeVNWawSMjHXM7ac88=; b=kN/3bCIW6AY93L70XwzPH7HP7r
	wZMCRsITAyj5WrFsPNQ0f/iodF0cOs8EERsIV2OnWLKw4JtfrmhYkmCIx3rWudv434CuQi8qdL8L0
	L7q3IUy4FEKN9cECKnKPOdRMbNkDx8kRlW4AcPUmYty9U+IPMuBXk8XT4VGH2PTBu/T/ZWO7P+jRv
	zzMiXEkBMFpCf7lDjOBQLOo5NX6zTHV0FF0tmLeFrTeVJyITAqLMXEh/+6hIZnf9zdHW2mlG9nPmj
	8It70Uk4QG/bRISzrSjgJ0BcXT7wrY/gIqbR2IBtJS3rZ5uN3jCanVSQI68EWbK4QpTrhXpXv6p6B
	VXUJQfTg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uPB2j-00CEh7-1S;
	Wed, 11 Jun 2025 10:18:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Jun 2025 10:18:21 +0800
Date: Wed, 11 Jun 2025 10:18:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Kristen Accardi <kristen.c.accardi@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: iaa - Fix race condition when probing IAA devices
Message-ID: <aEjnbdoqzLoMifRn@gondor.apana.org.au>
References: <20250603235531.159711-1-vinicius.gomes@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250603235531.159711-1-vinicius.gomes@intel.com>

On Tue, Jun 03, 2025 at 04:55:31PM -0700, Vinicius Costa Gomes wrote:
>
> diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
> index 23f585219fb4..2185c101bef3 100644
> --- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
> +++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
> @@ -35,28 +35,39 @@ static unsigned int cpus_per_iaa;
>  
>  /* Per-cpu lookup table for balanced wqs */
>  static struct wq_table_entry __percpu *wq_table;
> +static DEFINE_SPINLOCK(wq_table_lock);

This can be called in BH context so you need to disable BH when
taking the spinlock.

>  static struct idxd_wq *wq_table_next_wq(int cpu)
>  {
> -	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
> +	struct wq_table_entry *entry;
> +	struct idxd_wq *wq;
> +	int id;
> +
> +	guard(spinlock)(&wq_table_lock);
> +
> +	entry = per_cpu_ptr(wq_table, cpu);

You're taking a global spinlock around a per-cpu variable.  In that
case you might as well get rid of the per-cpu variable and use the
spinlock only.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
