Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444A11E674E
	for <linux-crypto@vger.kernel.org>; Wed,  7 Aug 2024 13:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.165
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723038314; cv=pass; b=lAI++j91whbHHchoU+7BoX0eostr8SbY+D7LzQDKIS/Y1R/8+0UshM+TALJY7rinjC2OFwYTJb+dQ95Nq1ja4RyACq9ERAeDodHQkSaKrSU4bcpoWd1qQmQ0FfeKPZivxqI3z1Zeo1agtgEsLjUYn/hwm9nUr0bN4q1O81Tr2Ic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723038314; c=relaxed/simple;
	bh=Fqkx7LyQoYNOGb/lr2QbqdmtNQCUXPRRcA8awGu7qao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PO9eTlfG2D/Jl/lapWABul7ZQlUGa9pK77dhNczxPegeVh9DieA0YOt6uPW7J8s+1GsmO6EQhCl/eZVWCXedzjH4tB+6jnZwiDnc/F3aFHmIfzp2aI44Sve/5XKjZUrZT0DKJFpHswQHaxc92ZcB/M1x9aYBUNcHNUNLehb4QBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chronox.de; spf=none smtp.mailfrom=chronox.de; dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b=NQKWG6ho; dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b=92rE7mvs; arc=pass smtp.client-ip=81.169.146.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chronox.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chronox.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="NQKWG6ho";
	dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b="92rE7mvs"
ARC-Seal: i=1; a=rsa-sha256; t=1723036866; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=qKcxbLAYBewu0qm1NaEtxJariHKm97h9H5zbywUymDhsGfuTYXAZLvdPMEhxVWUHeu
    UFGSD7Q5E9HChbQftLgum85F4n1a+pIy/m/TYmar98SHpLLlLQwlJ50aw6YbN6mYPJam
    JKfl8MA7o5wg5p0Hl3BsIt1tjfjIo2t6nblj4iGKkX1Zir2bZoinoWY24SC5eZMkBo0P
    mCLSz7clAkQXFR8RqLGyz20Hs54gdjqTzaRC5Wbe25kLFZZA5KFcCVx3xrOmfeEvyBpY
    tYUhOMQcxRG0+S7B5zhFJH1VQ1Jx4PP9Ys5hOcmYLxXMNFVERmlrO06AmxfbxUo1HR4e
    I9Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1723036866;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=qDHrlG1ILlUXk2DSlmGS0FXDVscbKmDpvUZGl7pCqIg=;
    b=UeN5AY0uYp9j9O90oMPpSXmLzbSJoJ9KF7mMOYDWNUgBPaddJdTfeWpzYcrWd2wab/
    YS/0BZ+j/0gVgtYZjXAZ34FsOFyvB/P/OgY8COjwIPNV0lAw8ai9HSsj3qC+P8hBtSHm
    yl8aHzZ5e6gGCS75qwcIG+vs8XOYBXtVtwOVYSo071nkdquAtvTrsJYCIWxYf+cxBsAM
    S6NfhNmLk67sVO0o50yQ7wVuiOi6ocNIMNVBJTfiwdPqyGhRPOU52PXKYVL3fZLUtDLg
    d41NlTaNdgHGHAHukSQSbDvMrcdz3xo5YlXL4jKCcvBI4CWttdgj9yRsfZxxmSLiPFDM
    jx6w==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1723036866;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=qDHrlG1ILlUXk2DSlmGS0FXDVscbKmDpvUZGl7pCqIg=;
    b=NQKWG6ho3IeODcOFFdz1n8FjcJjB7XLjsgGycC2Tb0e0BJn6bAW4SC7UgOsxNeLwss
    eZT0w+9anFm9rmcVFrKS1JDp1Di33YQUqf2H3uta3yWhoox8vi/NfAakvonATOkKy1nU
    P1OinnJq/QNxeonehh3FncNJPsOdBTgs4dz78QbmL/AFqnZ7A8WSWv6A3UAaTnYfow3N
    vSuwd93sWspmKyYMBgIsHV820C+Xr9JFU29sXsZ+u0wNOT9FvhbMWkUHTPHx/8lmbOu3
    IyQ9jiR1DrCapqdAM4Eg/UbuXjBBGkhXHW5X+JfSSHg3XgWUyNs/+6WDOd7CT1/uo6gy
    KGUA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1723036866;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=qDHrlG1ILlUXk2DSlmGS0FXDVscbKmDpvUZGl7pCqIg=;
    b=92rE7mvsbla9x75xVXzj/AqY6xUexvqEIpJHS4IEHIz++fBOS5I8YoqwTeYG/jjDSe
    36KE0bailPUqsZJDzLCg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzHHXDYJfSY+Zs="
Received: from tauon.atsec.com
    by smtp.strato.de (RZmta 51.1.0 DYNA|AUTH)
    with ESMTPSA id f5d0fe077DL5zCp
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 7 Aug 2024 15:21:05 +0200 (CEST)
From: Stephan Mueller <smueller@chronox.de>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Jeff Barnes <jeffbarnes@microsoft.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 Vladis Dronov <vdronov@redhat.com>,
 "marcelo.cerri@canonical.com" <marcelo.cerri@canonical.com>,
 Tyler Hicks <Tyler.Hicks@microsoft.com>,
 Shyam Saini <shyamsaini@microsoft.com>
Subject:
 Re: Intermittent EHEALTH Failure in FIPS Mode - jitterentropy
 jent_entropy_init() in Kernel 6.6.14
Date: Wed, 07 Aug 2024 15:21:04 +0200
Message-ID: <2143341.7H5Lhh2ooS@tauon.atsec.com>
In-Reply-To:
 <DM4PR21MB360932816FA7B848D7D8F7B0C7B82@DM4PR21MB3609.namprd21.prod.outlook.com>
References:
 <DM4PR21MB360932816FA7B848D7D8F7B0C7B82@DM4PR21MB3609.namprd21.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Am Mittwoch, 7. August 2024, 14:50:32 MESZ schrieb Jeff Barnes:

Hi Jeff,

> Hello,
> 
> We are currently migrating to kernel 6.6.14 and encountering intermittent
> EHEALTH errors that cause a kernel panic in initrd (FIPS mode). The error
> occurs in the following section of the code:
> 
> crypto/jitterentropy.c
> 722                 /* Validate health test result */
> 723                 if (jent_health_failure(&ec))
> 724                         return JENT_EHEALTH;
> 
> This is called from jent_mod_init():
> 
> 337         ret = jent_entropy_init(desc);
> 338         shash_desc_zero(desc);
> 339         crypto_free_shash(tfm);
> 340         if (ret) {
> 341                 /* Handle permanent health test error */
> 342                 if (fips_enabled)
> 343                         panic("jitterentropy: Initialization failed with
> host not compliant with requirements: %d\n", ret);
> 
> We are experiencing up to a 90% failure rate.
> 
> In my troubleshooting efforts, I followed the call to jent_condition_data()
> and attempted to increase the SHA3_HASH_LOOP to give the CPU more work,
> hoping to collect more entropy:

The proper way to handle it is the following: set 
CONFIG_CRYPTO_JITTERENTROPY_OSR to a higer value as it is - like 3 (the 
default is 1). The higher you set it the slower the collection will get as 
more samples are collected.
> 
> 356
> -#define SHA3_HASH_LOOP (1<<3)
> +#define SHA3_HASH_LOOP (1<<4)
> 
> This adjustment reduced the failure rate to 40-50%, but the issue persists.
> It is intermittent. It is also intermittent without the change. Sometimes I
> get a 90% failure rate on 10 reboots, sometimes 0%.
> 
> Given the difficulty in reproducing the kernel panic consistently, is there
> a more effective workaround or solution for this problem?
> 
> Your assistance is greatly appreciated.
> 
> Best regards,
> Jeff Barnes


Ciao
Stephan


