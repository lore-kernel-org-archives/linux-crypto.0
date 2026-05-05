Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C5530BB91;
	Tue,  5 May 2026 09:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777973666; cv=none; b=tERxmXAGguEq0GV3QQ97TMoB2/vdm+qXgX6GG/4FxSwBXSatvTiM3JfAuXStnHOtdq10I984CQ8HDiNL02TtpqmitFgvnrrdmVLdMIwM/ENPnj8U0u+bOgw+Xq3XqkVBoKs7qNhEYJr5ZmqJxUuVCaZgEeq7RT6Uphpy4dahXhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777973666; c=relaxed/simple;
	bh=m3xuei7QEO3BdWh2AVG4O5jLXHx0ii9UR2cx9wz5MaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mtoKXU7En8Jq74vweR6IIVvxGADN548wWrwnnS/+K8oAoL3TCRoqvU27crEAbZnR3hxZbQfLYsHB4inAv3YBxLJlrtKSFf2sNqej7XXO6cQpxFiqz0FlzmfC+wQSgC6TKUNno/SbWWjRz/bdfaMfgofenCYCQTOGJd+VvbBwFFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=H1Bi44I0; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="H1Bi44I0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=19oxxEfEgeVcmULINNrHzCxUZfxu7gYS2kOyozmBmVw=; 
	b=H1Bi44I0OMMUu6iU0to92pgaU+40XB5tcoTmZDDnhajeE5VA6Sl1tAyEGD06Pnzoxf0Pw7yvODV
	/QbYAxhbAjRQskcG9NaSyVgPLJJ3Ggxku78IcqvMjtRgvGRZxU3T4tT5So9MeV++AeWmdlfHkGnDA
	RStOgXeqx+XesZxYm5y05/tB2Ov7fQ3gHScYRUuNhk0R6Gj1Bz83+wE1Zwkd9EH1ZEVQbRWW5XOIm
	1xFXcLuybgyzg5SUAFv1G6CyzfRq6c2Uk2ntEm4EeJ0bVUdvGNOp34cL0TDPJ1Dz5Ft1YdhmBEksC
	+vpuEh3u4dPJ2jPYHU9mHTz64ydxQ8Sm3v3g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wKCAJ-00BO8c-0I;
	Tue, 05 May 2026 17:34:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 17:34:07 +0800
Date: Tue, 5 May 2026 17:34:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Weiming Shi <bestswngs@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	"David S . Miller" <davem@davemloft.net>,
	Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH v2] asymmetric_keys: check asymmetric_key_ids() for NULL
 before dereference
Message-ID: <afm5jwh7jzm-5mI2@gondor.apana.org.au>
References: <20260502163328.696098-2-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260502163328.696098-2-bestswngs@gmail.com>

On Sat, May 02, 2026 at 09:33:29AM -0700, Weiming Shi wrote:
> asymmetric_key_ids() returns key->payload.data[asym_key_ids], which can
> be NULL for keys parsed by the PKCS#8 parser (pkcs8_parser.c explicitly
> stores NULL in prep->payload.data[asym_key_ids]).
> 
> key_or_keyring_common() in restrict.c and find_asymmetric_key() in
> asymmetric_type.c both dereference this return value without checking
> for NULL. An unprivileged user can trigger a NULL pointer dereference
> in key_or_keyring_common() by creating a PKCS#8 key, restricting a
> keyring with key_or_keyring:<pkcs8_serial>, and adding an X.509 cert
> to the restricted keyring. CONFIG_PKCS8_PRIVATE_KEY_PARSER=y is
> required.
> 
> The following bash script can reproduce the issue:
> 
>   #!/bin/bash
>   modprobe pkcs8_key_parser 2>/dev/null
>   openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:1024 \
>       -out /tmp/poc.pem 2>/dev/null
>   openssl pkcs8 -topk8 -nocrypt -in /tmp/poc.pem \
>       -outform DER -out /tmp/poc.p8
>   openssl req -new -x509 -key /tmp/poc.pem -outform DER \
>       -out /tmp/poc.der -days 365 -subj "/CN=Test" \
>       -addext "subjectKeyIdentifier=hash" \
>       -addext "authorityKeyIdentifier=keyid:always" 2>/dev/null
>   PKCS8_ID=$(keyctl padd asymmetric pkcs8key @s < /tmp/poc.p8)
>   KR=$(keyctl newring test_kr @s)
>   keyctl restrict_keyring $KR asymmetric "key_or_keyring:$PKCS8_ID"
>   keyctl padd asymmetric trigger $KR < /tmp/poc.der
>   rm -f /tmp/poc.pem /tmp/poc.p8 /tmp/poc.der
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
> Add a NULL check in find_asymmetric_key(), mirroring the existing
> pattern in asymmetric_match_key_ids() and asymmetric_key_describe().
> In key_or_keyring_common(), skip the trusted key matching when it
> has no key IDs and fall through to the check_dest path.
> 
> Fixes: 7d30198ee24f ("keys: X.509 public key issuer lookup without AKID")
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
> v2: add bash reproducer to commit message (Ignat)
> 
>  crypto/asymmetric_keys/asymmetric_type.c | 2 ++
>  crypto/asymmetric_keys/restrict.c        | 9 +++++++--
>  2 files changed, 9 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
