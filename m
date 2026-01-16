Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6253195E6
	for <linux-crypto@vger.kernel.org>; Fri, 16 Jan 2026 11:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768563823; cv=none; b=TrU2WOZ/mNuYewbvJxzw5NGrXlN9/1iYUIwVHaXtbclCIAA1R3+ehp0tO6kAqh/EiF6Rll2thA2PDUL1+KYOHqAJVaiiW3Vl8qus+T8AUXaLiIO69rDDjjFQjHX5FhGFAfrYp6Q030Fkc38kQ/zbLeDAWw4z4UQ5v3Lk51vexf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768563823; c=relaxed/simple;
	bh=Uxh4PCNLxvSNcAe09/LfKBCpYwUFo0aL1qSbCl3Ru9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sOQEuZ7IW0kHsvy+OY0uCM5BhCZBcjwZ1Qq+VJ30D+8ugotFenr6xRoo3uDoeuRIwhhl9Sta8iZJqAmUu7Lp3syTrSIdE8Ifcy89BP0LZ0s9/AsGeBYZqob34GfDId2KN8Zqr9jrfrns4o9LHoEfxwW9zWD3mR+F5pFmA4Ev/kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-40429b1d8baso653882fac.0
        for <linux-crypto@vger.kernel.org>; Fri, 16 Jan 2026 03:43:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768563820; x=1769168620;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B4DvIM0JkjbKrKijztnVW5O+lZvfkuerqdbvyuKWmwg=;
        b=rNXlKWGo7nJS2QC7PhP1yUf408WUbpSt5v1eB7KAGsYXehw4kWe4zMg4D7/NtjN3vd
         x4F/zHIuuK+vhDWon+xbKsT7lCJJkfZxfVpayE3cDw2qt7jj/4A5Azg3X6PRKRPYtHjP
         IyX1cwcbR/T9cPXcxypy1EoKYesEtR07XEwknuH4PU1/FwKoZCVjbSAMbLviZUFEnT5B
         YPnmhzoSaS6L2IqFal0QBmMNJol1rULkeQMaX3WrM/aKfqCcu95X0pY6AdhwJ4TGlPpg
         sDLcC9ZL5yzB9YeixVbKHb3JjYztUJijEgLhy0YJJYsFzgBR6A73SRxc1F708/txNETA
         NI7Q==
X-Forwarded-Encrypted: i=1; AJvYcCU3Tk+7xcudhiZN/LpAzxCIU5Yzv2f0O1t8/AFV6B3CglKu6QOu7ByYTN6BmWMUSzSKEE7BvwzCVibWjLw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLyMMgrYiNSF0fobdPMljgAWeWVWOA/NM1RO+dWq0rIXgrWnoH
	a46fQFjjmaRPrj9QFh3QkCThXSqr59qzbNkvv2eWyVKlgbT23Ny7t8ka
X-Gm-Gg: AY/fxX6wxJqPXtE+kO00RrCwN7vQ/jWFdZ6DPk/6bxYUahuT+tUKJuo8JhvfgwMUxHc
	BZxAfZXrHg6zsuiQzMN0z1BosKOVp3VTO/jm1yMnFINg0AeNFJg4mgB/7s17p4w8L8rJhwDlXjV
	dl8icjPq7DLhGS4M+r3YvoUt/oMsB9vpNSCvhD/LumacZZ9t1bKKZlectHMPuO93M9ABmsbr6sh
	soFwg39AbbKPQpjR55MiXuXrZkdxAkgnaUzabAUwiowmylWHpDif9naOMm4diaU3Am18VQEiOLQ
	aMis534VI9MqWr0rVUgXESpe41A3fJE+ILxNCjP2oy6E4Wxtv+BeKYGqjwLj7m6tkPHVramrPzJ
	7tfwJp2MMeo2qWvSOYKCAWBp4unl6u/U6dgjKUTxArNzCipK67YFskSt71m/8nrPsXi/buSopad
	Cp
X-Received: by 2002:a05:6871:28c:b0:3e0:de76:31e5 with SMTP id 586e51a60fabf-4044c2306ccmr1329018fac.25.1768563820287;
        Fri, 16 Jan 2026 03:43:40 -0800 (PST)
Received: from gmail.com ([2a03:2880:10ff:9::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044baf5402sm1564987fac.4.2026.01.16.03.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 03:43:39 -0800 (PST)
Date: Fri, 16 Jan 2026 03:43:37 -0800
From: Breno Leitao <leitao@debian.org>
To: "Chang, Jianpeng (CN)" <Jianpeng.Chang.CN@windriver.com>
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, kuba@kernel.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam: fix netdev memory leak in dpaa2_caam_probe
Message-ID: <aijerp5ovv7m5mk2xrfn5rjgkufcynu7vikejqityxloeqnreo@jdnoev2yvfvy>
References: <20260116014455.2575351-1-jianpeng.chang.cn@windriver.com>
 <4h7joiwvamq3sgrkhyemtug4lucyicnx7beuik3i5foydwb256@iemjvkrs7h2d>
 <4a5b1ada-0602-4f43-b09b-ba1a8da26f21@windriver.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a5b1ada-0602-4f43-b09b-ba1a8da26f21@windriver.com>

Hello Jianpeng,

On Fri, Jan 16, 2026 at 06:14:37PM +0800, Chang, Jianpeng (CN) wrote:
> On 1/16/2026 5:46 PM, Breno Leitao wrote:
> > CAUTION: This email comes from a non Wind River email account!
> > Do not click links or open attachments unless you recognize the sender and know the content is safe.
> > 
> > On Fri, Jan 16, 2026 at 09:44:55AM +0800, Jianpeng Chang wrote:
> > > When commit 0e1a4d427f58 ("crypto: caam: Unembed net_dev structure in
> > > dpaa2") converted embedded net_device to dynamically allocated pointers,
> > > it added cleanup in dpaa2_dpseci_disable() but missed adding cleanup in
> > > dpaa2_dpseci_free() for error paths.
> > > 
> > > This causes memory leaks when dpaa2_dpseci_dpio_setup() fails during probe
> > > due to DPIO devices not being ready yet. The kernel's deferred probe
> > > mechanism handles the retry successfully, but the netdevs allocated during
> > > the failed probe attempt are never freed, resulting in kmemleak reports
> > > showing multiple leaked netdev-related allocations all traced back to
> > > dpaa2_caam_probe().
> > > 
> > > Fix this by preserving the CPU mask of allocated netdevs during setup and
> > > using it for cleanup in dpaa2_dpseci_free(). This approach ensures that
> > > only the CPUs that actually had netdevs allocated will be cleaned up,
> > > avoiding potential issues with CPU hotplug scenarios.
> > > 
> > > Fixes: 0e1a4d427f58 ("crypto: caam: Unembed net_dev structure in dpaa2")
> > > Signed-off-by: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
> > > ---
> > >   drivers/crypto/caam/caamalg_qi2.c | 31 ++++++++++++++++---------------
> > >   drivers/crypto/caam/caamalg_qi2.h |  2 ++
> > >   2 files changed, 18 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
> > > index 107ccb2ade42..a66c62174a0f 100644
> > > --- a/drivers/crypto/caam/caamalg_qi2.c
> > > +++ b/drivers/crypto/caam/caamalg_qi2.c
> > > @@ -4810,6 +4810,17 @@ static void dpaa2_dpseci_congestion_free(struct dpaa2_caam_priv *priv)
> > >        kfree(priv->cscn_mem);
> > >   }
> > > 
> > > +static void free_dpaa2_pcpu_netdev(struct dpaa2_caam_priv *priv, const cpumask_t *cpus)
> > c> +{
> > > +     struct dpaa2_caam_priv_per_cpu *ppriv;
> > > +     int i;
> > > +
> > > +     for_each_cpu(i, cpus) {
> > > +             ppriv = per_cpu_ptr(priv->ppriv, i);
> > > +             free_netdev(ppriv->net_dev);
> > > +     }
> > > +}
> > 
> > Why is the function being moved here? Please keep code movement separate
> > from functional changes, or at minimum explain why the move is necessary
> > in the commit message.
> Thank you for the feedback.
> 
> I moved the function because I thought reusing existing code would be
> cleaner in dpaa2_dpseci_free. I will add the explain in commit message.
> 
> For future reference, what's the preferred approach when needing to reuse a
> simple function (4-line loop) defined later in the file - forward
> declaration, move it with a separate change or just implement directly?

It is fine to implement directly, but, I am a bit confused with the
solution, let me back up a bit. 

First, it seems the problem is real and thanks for fixing it.

Regarding the solution, I am wondering if it is not simpler to iterate
the priv->num_pairs and kfreeing them in dpaa2_dpseci_free(), similarly
to dpaa2_dpseci_disable().
