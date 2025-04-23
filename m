Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E99C20D51E
	for <linux-crypto@vger.kernel.org>; Wed, 23 Apr 2025 12:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745412200; cv=none; b=twMOYhX8sEOs+FagI0uaylyIrPzp93enQ4D7Qo7BPYLjWwkp0RMEyBQAzxps8fPqbQqh1RM/gpIglfmNqMiqRvfg4RxqPUougwK8FQQQ7e8ulO46PntFgKc8JPkVqDRb5z1qRyOxdiCp/X9wbvlB73pGiaaIZfSimS65tkxXHJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745412200; c=relaxed/simple;
	bh=G+lFj8VEk+gKtEf5dw2Txm+/7UhKviEJT0Xi5sIrKEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=dd2rPSizGt1ClJg9hfDEMk8VWaBgukW5C6ogOB3aFkizy4FEiOfW7koLNp3v4goRxdSC3kKcOLNBnGoZ65i7lGqy/JPwVgJ4iK4/SXhPKHvkNMJoMQBxlxC4xsM/peqcMliU+2y0AH7+MDHeXwlPwg+GdS8J6zELS23Dnltinzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=BUAEFebr; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="BUAEFebr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1745411705; bh=G+lFj8VEk+gKtEf5dw2Txm+/7UhKviEJT0Xi5sIrKEY=;
	h=Date:Subject:To:References:Cc:From:In-Reply-To;
	b=BUAEFebrJPtytcdsEAAk/3lPgK4/KTlVh1c+zPhjsmilBm/Cr7pGwiEVMUYKyxWPg
	 ng8KVzyYru7MePhnnmMjkOpo6vAYwqQzrhs+xNiRh/XsiA22pTwotYJEBwWBhoEURu
	 Nk5riiWjwCrpfJJRiowGDEYWHyjOJbda1tWDow8GaeCZcmVpMHRbQfGAMM7WBMi16F
	 or7gePl+ubAzp1IixPhswg6bzCDXd2E59nEzPN5TEhYiB/Rdnn6Aspn+LEa3TtnM2a
	 p3x2vwa5//NpN1KLIsC6oklssE/+XOnxA8waK+x2+LcD5GDT8kfG1vAC+RWeew+3JX
	 LY293jZGmASmQ==
Message-ID: <979f4f6f-bb74-4b93-8cbf-6ed653604f0e@jvdsn.com>
Date: Wed, 23 Apr 2025 07:35:03 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: drbg_*pr_*_sha384 fips_allowed not set
To: Jeff Barnes <jeffbarnes@microsoft.com>
References: <BYAPR21MB1319D9FA2CA2455E1E393940C7BA2@BYAPR21MB1319.namprd21.prod.outlook.com>
Content-Language: en-US
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
From: Joachim Vandersmissen <joachim@jvdsn.com>
Autocrypt: addr=joachim@jvdsn.com; keydata=
 xjMEYFm2zhYJKwYBBAHaRw8BAQdAa0ToltLs88MRtcZT3AnfaX4y9z7tNuQumkFnraoacSrN
 KUpvYWNoaW0gVmFuZGVyc21pc3NlbiA8am9hY2hpbUBqdmRzbi5jb20+wosEExYIADMWIQTl
 ppuIImvmYHZckHHNOH6x9cuKxQUCYFm2zgIbAwULCQgHAgYVCAkKCwIFFgIDAQAACgkQzTh+
 sfXLisVD7wEAufvtZXIMlofHV5P3O4Cj+J/npvpmxnNPBqd+2AdJ8GAA+wS1j7TvvtPhTccG
 DYXZbrGlvTrCrGyGdTRdK0ZcTgQLzjgEYFm2zhIKKwYBBAGXVQEFAQEHQHUI004BPYxgvmBd
 PTzZYgyko/t3ZlPeWcSQen0JEOZ2AwEIB8J4BBgWCAAgFiEE5aabiCJr5mB2XJBxzTh+sfXL
 isUFAmBZts4CGwwACgkQzTh+sfXLisVlRQD/XXtpe2kyEJ4rkRHNxS/0yHi4B26uyyutGaZN
 t/aaUDQA/RweY9tHblOuDvCCMnRSI+HDambm+2OgKwe45MXNdssK
In-Reply-To: <BYAPR21MB1319D9FA2CA2455E1E393940C7BA2@BYAPR21MB1319.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jeff,

These DRBGs were originally disallowed by FIPS 140-3 Implementation 
Guidance D.R.

That IG has since been withdrawn (i.e., they are allowed again), but 
nobody has proposed a patch to enable them again.

Kind regards,
Joachim

On 4/23/25 7:31 AM, Jeff Barnes wrote:
> Hello,
>
> I noticed that the following algorithms don't have .fips_allowed enabled in testmgr.c. All of the other drbg algorithms have it enabled. I didn't see a git log entry explaining why.
>
> By not enabling .fips_allowed, the algorithms won't load when fips=1. What is the reason for this?
>
> Thanks
> Jeff Barnes
>
>          }, {
>                  /* covered by drbg_nopr_hmac_sha256 test */
>                  .alg = "drbg_nopr_hmac_sha384",
>                  .test = alg_test_null,
>          }, {
> ...
>         {
>                  /* covered by drbg_pr_hmac_sha256 test */
>                  .alg = "drbg_pr_hmac_sha384",
>                  .test = alg_test_null,
>          },
> ...
>          }, {
>                  /* covered by drbg_nopr_sha256 test */
>                  .alg = "drbg_nopr_sha384",
>                  .test = alg_test_null,
>          }, {
> ...
>          }, {
>                  /* covered by drbg_pr_sha256 test */
>                  .alg = "drbg_pr_sha384",
>                  .test = alg_test_null,
>          }, {
>
