Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204383B3BE3;
	Wed, 24 Jun 2026 22:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782340763; cv=none; b=HjF3ZVvBMeoy2IOHGNJNUWfZpRLEgvYVv5fSZ4+9Z/vcgjtHmkWLL5FgD4qtEX2zkbZyEGY0yDoGXXT272wrPZ/U9ncbSUq4VEF0/EHlT/QvauowmFLxlBvFP/CrdRRFraqiOGq7n8CnvhURzXNRx717XBThIEISMR2Qxj1jQ+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782340763; c=relaxed/simple;
	bh=oCg8N9oJBXAtHVpbKtIbUGgD2pfQ/YvdYKKRBhC0/OQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PmsqNfCfxbfn/H/P2P1oqtIA73npH7OoXuQ+C0sh6KOhaFUlOergpRKex6wtZhgW6g7p2ghAMH3Iq/ZB1MDaolwe1ZJw8f0CoD1ncbp4EVIQY3NLQAw5r19yCVKdKFyywU99Kd980rnchvzqUdekUJog7jWptbrHzLjHmfwnwno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e7PBlpC7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e7PBlpC7"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2ADB71F000E9;
	Wed, 24 Jun 2026 22:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782340761;
	bh=XvuvId3+kiReEt5aam+tiYzwoKcojvmCf9QUJg4/SJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e7PBlpC7QMwCms51cxDvchQdCWM/SPhC35Y4CC5bVwxej8ZD9j5JBwGiHafFJVaq3
	 aSAZpkt/Smi9L/QB+wCBa5zdW3i5NC+9QaJNk8bpnsCbI5A0ElNFA9ClBnyn3iZlM+
	 rRigtNnLMg1qprDYu7v8j0CJLPrF5B5BUhqOHT2YuzPqdw1lAmJmrgjHK5ExYAHGMW
	 KFxRcnQZhzTCdioYWD/ZRMeQdmA2jZkqM8XhOTuoERlEEuKDeJPF0Moj1hGsDGd7cx
	 jGtd1ELSgZb8wjnJQz/GYYHKI723L7PLKEZRHg2EaLjmrzhJT0kFtIVFkxB0sqQiIS
	 c9DNxvv8rceBA==
Date: Thu, 25 Jun 2026 01:39:17 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Lukas Wunner <lukas@wunner.de>
Cc: azraelxuemo <eilaimemedsnaimel@gmail.com>, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, dhowells@redhat.com,
	Ignat Korchagin <ignat@linux.win>, keyrings@vger.kernel.org
Subject: Re: [PATCH] KEYS: asymmetric: fix OOB read in KEYCTL_PKEY_DECRYPT on
 zero-length message
Message-ID: <ajxclQWmF6jPDkxm@kernel.org>
References: <20260622025002.798934-1-xuemo@xuemo.com>
 <ajpRLY4unsqxS46e@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajpRLY4unsqxS46e@wunner.de>

On Tue, Jun 23, 2026 at 11:26:05AM +0200, Lukas Wunner wrote:
> [cc += Ignat, Jarkko, keyrings; start of thread is here:
> https://lore.kernel.org/r/20260622025002.798934-1-xuemo@xuemo.com
> ]
> 
> On Mon, Jun 22, 2026 at 02:50:02AM +0000, azraelxuemo wrote:
> > When ret is replaced with maxsize, the caller keyctl_pkey_e_d_s()
> > does copy_to_user(_out, out, ret) with ret = key_size (e.g. 256
> > for RSA-2048) on a buffer allocated with kmalloc(params.out_len),
> > which can be as small as 1 byte.  This reads key_size - out_len
> > bytes beyond the allocation.
> 
> It would probably make sense to tighten security in keyctl_pkey_e_d_s()
> by using kzalloc() instead of kmalloc() and by capping the amount of
> data copied with min(ret, params.out_len).
> 
> > Fixes: 63ba4d67594a ("KEYS: asymmetric: Use new crypto interface without scatterlists")
> > Signed-off-by: HanQuan <eilaimemedsnaimel@gmail.com>
> 
> Please add:
> 
> Cc: stable@vger.kernel.org # v6.5+
> 
> You don't need to cc that address when submitting the patch,
> but including the tag in the commit message helps stable
> maintainers identify patches that need backporting.
> 
> > +++ b/crypto/asymmetric_keys/public_key.c
> > @@ -358,7 +358,10 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
> >  		BUG();
> >  	}
> >  
> > -	if (!issig && ret == 0)
> > +	/* Decrypt may legitimately return 0 (zero-length message); only
> > +	 * replace ret with maxsize for encrypt, which returns 0 on success.
> > +	 */
> > +	if (!issig && ret == 0 && params->op == kernel_pkey_encrypt)
> >  		ret = crypto_akcipher_maxsize(tfm);
> 
> Given that out of 3 operations (encrypt, decrypt, sign),
> 2 already return the size, I think a better approach would be
> to let crypto_akcipher_sync_encrypt() return crypto_akcipher_maxsize()
> on success, i.e.:
> 
> 	return crypto_akcipher_sync_prep(&data) ?:
> 	       crypto_akcipher_sync_post(&data,
> -					 crypto_akcipher_encrypt(data.req));
> +					 crypto_akcipher_encrypt(data.req)) ?:
> +	       crypto_akcipher_maxsize(tfm);
> 
> and then remove the if-clause in software_key_eds_op() altogether
> which overwrites ret with the maxsize.
> 
> Do you agree?
> 
> Your patch wasn't cc'ed to all maintainers of this file.
> Please double-check that you've checked out Linus' current
> master when running scripts/get_maintainer.pl.
> 
> Thanks,
> 
> Lukas

Lukas, thank you for forwarding this, and with a quick sim I do.

Can this be next time be also CC'd to keyrings@vger.kernel.org, in
addition of me and rest? What I can then do is to look this in detail,
test the change, apply and eventually forward to Linus...

BR, Jarkko
