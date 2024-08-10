Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C42166F21;
	Sat, 10 Aug 2024 17:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723311921; cv=none; b=LwdJRcSJEhG2lvLxZaZOlNRTgpcoOyFMEyS1/hHZXNNJNsbUi7Xkb+sFDpXAJJe8v/Fp82m1z58PNIjfVQpFAV0chiX/O9/7GvQMKeqURqIKrKAt5HLSnbVWAHAW4WG43g7wzQuv3Yrrl9APDR4rb2JVmFEd9rjv2EOeBNQi3LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723311921; c=relaxed/simple;
	bh=cFTCSWFQe/+IR1CW82SHHVsPjnLcBFckQ5Bo+52TQSE=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pep0WJTkh7Whmxz3z5RYVUA1sGM4DlaaKwf/dgRItCQ9fon5g/tfyKVmmF+BhWvYTQQvo9exV9AjaykMKdG5BOsawKZkS15d+69b8npZKIFmXmhwUlROdXxpqTghlCi3UmGE48rPasCtEwlnL8yQK5XJLtF8q/G7HlAeBLPgVyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=rSeMNaIC; arc=none smtp.client-ip=198.47.23.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="rSeMNaIC"
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 47AHj0fu017978;
	Sat, 10 Aug 2024 12:45:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1723311900;
	bh=g9Y9wP/9cK6ztXhUCkhRXn1bzVTr/5G3RhlgTpbvTdg=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=rSeMNaIC/KMcjsFbuVEJX1BLEXWDEc/HqA2P1OBWS4qvolnpBplk9bRopQaj68mCT
	 BiBKP7vEfaOGI6IGrvZU0dX9GHnwQh0thOgwvyV0n7PmY1vZm1Yg7P9kcBxYUlJwTP
	 nooWgEBaLJ1SnP7mMJQrvPwr3Yg+V2FiMTMYvGx0=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 47AHj0iF039751
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 10 Aug 2024 12:45:00 -0500
Received: from flwvowa02.ent.ti.com (10.64.41.53) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Sat, 10
 Aug 2024 12:44:59 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by flwvowa02.ent.ti.com
 (10.64.41.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2507.34; Sat, 10 Aug
 2024 12:44:59 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Sat, 10 Aug 2024 12:44:59 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 47AHiwI1025308;
	Sat, 10 Aug 2024 12:44:59 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: Waiman Long <longman@redhat.com>,
        Steffen Klassert
	<steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Waiman
 Long" <longman@redhat.com>
Subject: Re: [PATCH] padata: Fix possible divide-by-0 panic in
 padata_mt_helper()
In-Reply-To: <20240806174647.1050398-1-longman@redhat.com>
References: <20240806174647.1050398-1-longman@redhat.com>
Date: Sat, 10 Aug 2024 23:14:58 +0530
Message-ID: <87jzgonug5.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

Waiman Long <longman@redhat.com> writes:

> We are hit with a not easily reproducible divide-by-0 panic in padata.c
> at bootup time.
>
>   [   10.017908] Oops: divide error: 0000 1 PREEMPT SMP NOPTI
>   [   10.017908] CPU: 26 PID: 2627 Comm: kworker/u1666:1 Not tainted 6.10.0-15.el10.x86_64 #1
>   [   10.017908] Hardware name: Lenovo ThinkSystem SR950 [7X12CTO1WW]/[7X12CTO1WW], BIOS [PSE140J-2.30] 07/20/2021
>   [   10.017908] Workqueue: events_unbound padata_mt_helper
>   [   10.017908] RIP: 0010:padata_mt_helper+0x39/0xb0
>     :
>   [   10.017963] Call Trace:
>   [   10.017968]  <TASK>
>   [   10.018004]  ? padata_mt_helper+0x39/0xb0
>   [   10.018084]  process_one_work+0x174/0x330
>   [   10.018093]  worker_thread+0x266/0x3a0
>   [   10.018111]  kthread+0xcf/0x100
>   [   10.018124]  ret_from_fork+0x31/0x50
>   [   10.018138]  ret_from_fork_asm+0x1a/0x30
>   [   10.018147]  </TASK>
>
> Looking at the padata_mt_helper() function, the only way a divide-by-0
> panic can happen is when ps->chunk_size is 0. The way that chunk_size is
> initialized in padata_do_multithreaded(), chunk_size can be 0 when the
> min_chunk in the passed-in padata_mt_job structure is 0.
>
> Fix this divide-by-0 panic by making sure that chunk_size will be at
> least 1 no matter what the input parameters are.
>
> Fixes: 004ed42638f4 ("padata: add basic support for multithreaded jobs")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/padata.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/kernel/padata.c b/kernel/padata.c
> index 53f4bc912712..0fa6c2895460 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -517,6 +517,13 @@ void __init padata_do_multithreaded(struct padata_mt_job *job)
>  	ps.chunk_size = max(ps.chunk_size, job->min_chunk);
>  	ps.chunk_size = roundup(ps.chunk_size, job->align);
>  
> +	/*
> +	 * chunk_size can be 0 if the caller sets min_chunk to 0. So force it
> +	 * to at least 1 to prevent divide-by-0 panic in padata_mt_helper().`
> +	 */
Thanks for the patch and detailed comment.
> +	if (!ps.chunk_size)
> +		ps.chunk_size = 1U;
> +
could it be
        ps.chunk_size = max(ps.chunk_size, 1U);
        
or can be merged with earlier max()
  	ps.chunk_size = max(ps.chunk_size, max(job->min_chunk, 1U));
  	ps.chunk_size = roundup(ps.chunk_size, job->align);

sits well with how entire file is written and compiler is optimizing
them to same level.

Kamlesh

>  	list_for_each_entry(pw, &works, pw_list)
>  		if (job->numa_aware) {
>  			int old_node = atomic_read(&last_used_nid);
> -- 
> 2.43.5
