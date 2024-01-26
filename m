Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2BBBE65
	for <linux-crypto@vger.kernel.org>; Fri, 26 Jan 2024 06:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706249590; cv=none; b=NgghGuluT05CvHBwOebUL60PgEzdX1y/rh1lZOSGh69XWjeNvyUKi3Yu3nQ2drQSgFfWT1Beqkmfw34nxIzAMMmXi1FqgWW7kS5IbfJgzUBTRKkJDhppCzaj7PWozw9MTyOb5tudphtz/QDYm+Nc2qe46A2agOFAoTdOYD7h+VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706249590; c=relaxed/simple;
	bh=pXO9bmd7s3XRMWB3J0KjhHGGtIDYTGw3RaJ8EEuMvKg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=ED8xAtYO98eB78kzEQKC1FWwwdQQ3XQhrN63n14Fu7QbOhMwgsoPbc0Q9osozAHZ47fLTxf+s1UNxla6NqGZZKOoV1ff06LgHi9y0gFuLu2EH+Lxepl5UTysHnsGpxxpF45lAaFUfNql83L62gmCEx9khKbmVPutDrighQbEySI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=7dZap3Ml; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="7dZap3Ml"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1706249582; bh=pXO9bmd7s3XRMWB3J0KjhHGGtIDYTGw3RaJ8EEuMvKg=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=7dZap3MlqLJTqXYNExjKJzQDrgs3JUeR1exAQtXp7feapH6OJD2syZDg9XqYAe2ni
	 4PROaRZAotppufnAKrbhWmERcMgYA+Z4n0vSyooTd6vPJnzGQrAy2xTNcFUf0dYt0H
	 iCEPeb4+Ve0MfroyeI1RiPYw5OFjSBdlQy8dH3vxI/2YC17PwTxwjwHCOW8EoBPRjj
	 etuecqw1xi/c3KWLBtA6dHuJ27w8g/EPH9b883V/KskbRYwDeyKom6HuZWw01AMYBI
	 m9qAG5DTAzhCW8jbpGtv05wCBn7tN7tQZMKBQwdDZkHS9nLaf2w5eoVXqFMFwdCXPr
	 D7aJsmW8ySL1Q==
Message-ID: <b2dc028f-54e5-4992-8f8b-32cbfd072f73@jvdsn.com>
Date: Fri, 26 Jan 2024 00:13:00 -0600
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Joachim Vandersmissen <git@jvdsn.com>
Subject: Re: [PATCH] crypto: rsa - restrict plaintext/ciphertext values more
 in FIPS mode
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
References: <20240121194901.344206-1-git@jvdsn.com>
 <ZbNKHGDiGOyIB5+S@gondor.apana.org.au>
Content-Language: en-US
In-Reply-To: <ZbNKHGDiGOyIB5+S@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Herbert,

On 1/25/24 23:58, Herbert Xu wrote:
> On Sun, Jan 21, 2024 at 01:49:00PM -0600, Joachim Vandersmissen wrote:
>>   static int _rsa_enc(const struct rsa_mpi_key *key, MPI c, MPI m)
>>   {
>> +	/* For FIPS, SP 800-56Br2, Section 7.1.1 requires 1 < m < n - 1 */
>> +	if (fips_enabled && rsa_check_payload_fips(m, key->n))
>> +		return -EINVAL;
>> +
>>   	/* (1) Validate 0 <= m < n */
>>   	if (mpi_cmp_ui(m, 0) < 0 || mpi_cmp(m, key->n) >= 0)
>>   		return -EINVAL;
> I think this check makes sense in general, so why not simply
> replace the second check above with the new check?

Yes, mathematically speaking the values 1 and n - 1 aren't suitable for 
RSA (they will always be fixed points). I simply didn't want to 
introduce a breaking change. If you think a breaking change is 
acceptable, I can update the patch to replace the RFC3447 check with the 
stricter check.

>
> Thanks,
