Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE4639EF0C;
	Wed, 16 Sep 2026 12:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789563249; cv=none; b=W0bV6sdiH7iCSghaHX8v216zAdLHqNJpGIxNFMbAFGrihnn1xssXOiQuelo9DXhxWrVnjqqh0ZT96RhuaArDzGTZLY+JDfk31G6Igokr5pjn/UBxINFKAhe74sy8KWikotDXXr9bCOhDJGGHQX4Eglu3AiDGFzQ6m1mjsa6DKDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789563249; c=relaxed/simple;
	bh=qi9hSWZ6pQtMv2ITMhJ+22txi5bnLR/UXL8VyPgeazg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IqYuxHsQMJmSx/A5vNygsgKYGWEA6C6lHx1lL3kVqZMSDhA+P4hTNX5BQ7dFz3ODG59ZFj0+55Bt2blhNapUDWb9pLe2XYMWhN87KDvK08JA9Z8ASbh23/86n8TApUfNRko7oXi3lMtRa9lAVJ2TEgsd3CbzQCItmGzvilWCOrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=HTLJ7hRp; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="HTLJ7hRp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=EBVUxlSNo11Lgr399BD7jHaaxobaBiihDd/R1wc1L18=; 
	b=HTLJ7hRpWYO04EvryGXe/gg4N8PZnAJwM4B0Nt96udaM+a792z7k9fQ8l4bfb6vBzt2S/O37v09
	H/dN9E6q88ErSFJuBT2OLRE1DxFyqVqPYxMoAn+fQYlmB9a6o3y2BSK2dbw4CNY7KwLJ6QfIJV8n7
	J0b3VQuaG3GID8BW64Rj4kMs8h9vaiOvIpLgIZqZQSf2c4kyzy7MzWA4oPmyDfnfzsT5BhlDsADuG
	BzY1vQsBmreX1IdJE5Zk7mSnlprckT11fTRfVUyV1/QIMNvnEvU5CyKNgH40xnnZR6whfgsMOa/kg
	ciuHlDnsrbawezUNmo3iv4REGMu3tncvYhWw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x6p8z-0000000EcZ3-130w;
	Wed, 16 Sep 2026 20:53:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Sep 2026 22:53:45 +1000
Date: Wed, 16 Sep 2026 22:53:45 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Weiming Shi <bestswngs@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	"David S . Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>,
	James Morris <james.morris@microsoft.com>,
	Denis Kenzior <denkenz@gmail.com>, Xiang Mei <xmei5@asu.edu>,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] asymmetric_keys: reject trust keys without IDs
Message-ID: <aqqRWabeFlBkM3Qw@gondor.apana.org.au>
References: <20260502163328.696098-2-bestswngs@gmail.com>
 <20260906110152.240426-2-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260906110152.240426-2-bestswngs@gmail.com>

On Sun, Sep 06, 2026 at 07:01:53PM +0800, Weiming Shi wrote:
> The PKCS#8 parser deliberately leaves the asym_key_ids payload slot
> empty. key_or_keyring_common() unconditionally dereferences that slot
> when a PKCS#8 key is supplied to a key_or_keyring restriction. Both the
> plain and :chain forms reach this branch, allowing an unprivileged caller
> to trigger a NULL pointer dereference through KEYCTL_RESTRICT_KEYRING
> followed by add_key().
> 
>  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000
>  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>  RIP: 0010:key_or_keyring_common (crypto/asymmetric_keys/restrict.c:205 crypto/asymmetric_keys/restrict.c:279)
>  Call Trace:
>   <TASK>
>   __key_create_or_update (security/keys/key.c:884)
>   key_create_or_update (security/keys/key.c:1021)
>   __do_sys_add_key (security/keys/keyctl.c:134)
>   do_syscall_64 (arch/x86/entry/common.c:52 arch/x86/entry/common.c:83)
>   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
>   </TASK>
>  Kernel panic - not syncing: Fatal exception
> 
> Reject an asymmetric restriction key without key IDs. A PKCS#8 private
> key cannot identify the signer of a candidate certificate and is not a
> valid trust anchor.
> 
> Fixes: 3c58b2362ba8 ("KEYS: Implement PKCS#8 RSA Private Key parser [ver #2]")
> Cc: stable@vger.kernel.org
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Link: https://lore.kernel.org/r/20260429181629.110802-2-bestswngs@gmail.com
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
> Changes in v3:
> - Drop the unnecessary find_asymmetric_key() check.
> - Reject a trust key without IDs instead of continuing the chain lookup.
> - Use the PKCS#8 parser commit as the Fixes target.
> 
>  crypto/asymmetric_keys/restrict.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
