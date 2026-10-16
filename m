Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD632E282B
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 01:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792113749; cv=none; b=LPv9oLW7DWzZ08N2f1BnXpAUeIAcwCMzCr9xPZ4qd2FRIAnal2QHLSnD1ablyILxniXj/+UOxafAh/ESC2v066eDN8VSFMX1LzCw3P1Bgfv4IpNz0RE3c2R6LaefAUxXI49F5Iu6y+yODL3gKc1Uu84tTUxGlrLnLQJdKDidJsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792113749; c=relaxed/simple;
	bh=rDb5goVKNdHW+xAPg1TqVSjOt7aW12nFHUOXrwpErSM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tx8OjnWTTlQ7c/RyEZPcynLeVKMCAGN5CUpCpH0wgnmLGOQ8PJd+zU+a9s2xOMcDicN7qyYXHy/wLk4ITaJeN7HwIMjDb35/ejCuGb6o/wQYG6FKqav0GsFSryPqWe1Fzk0w65Kr46xQFnduY5oTFq1lKYOWrtXo+vSHjeS+osI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--shansinha.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E5w7Ft+t; arc=none smtp.client-ip=209.85.216.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--shansinha.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E5w7Ft+t"
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ab7f1efe5dso5121446a91.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 18:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792113747; x=1792718547; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MS4gSCkqGtBHDPJdK563wHc/5/xO1UWE5Dvgu8PJM9A=;
        b=E5w7Ft+tYtbLUcsdO2hUtxtFPhiNLdbMJUf/5KivqMHsqZlL7GsBduI/GybBYIbMsn
         fscWIhUGtKb5owwVFNNu1h/H2nYEUN8iXmU4Tf9FYnFnzqiO8daEQ9B0v2kTiS+3BORb
         YOO8iV6S9XEANp2BhErhLecm4T3XDF+/EHPLpj0cfbXyIkXpuXUgPzaEwCGMiUssyvkP
         oC/NuDQ10kvxa+1YGk6L1IMtI5NrWSCFHPjt4/fh1mCfnI2VBt8scnmMlaVrx/FEiGN+
         4ZyuJ4mMfM6wpDYjPgsVrrazqKP1XFzPMO7yNSoihJtYBJ/6RFxZxFGUkXTX9hR1Q46U
         okVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792113747; x=1792718547;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MS4gSCkqGtBHDPJdK563wHc/5/xO1UWE5Dvgu8PJM9A=;
        b=hHbOZnwQ6p6Llh/rHyozP1n9pkLieA2AXrMiczkdaO4wJMVHtxVgo6kLOreOWoOE/D
         /i4vwPoYFuXjyII6aUgG8Gtv9woR9ae+LXmUTZWGMO/sU2yy2JmR22aQwYSw1uk06uwM
         LnWmbluNh+AjhqbWfq1ji1fb0SALYKeoPvJFY5Tq0TM48UowpCfZjMl50O0t4yoF9ZBl
         /Mz6jbmDbC+PGTUlBZhfnvrHDnl+eqEXi4L4MSmP+sRPC5Tq4uJNTVLP3OyFNIEJtPcj
         wtDRM9kv4Eqz4EnQOdvZbA773FN1ZYmlnh2t4a3C2V4dmTaAMwjP4IdMLHxgJjcabjp2
         kjQw==
X-Forwarded-Encrypted: i=1; AKwUvBwT4vrKz0MHH9QcUpUXIUq9y4SRxI54DTL8ziG9wdXizzXL8SuNWyRkq6KDxjklUk4cgB9OfPIVgM7/MB8=@vger.kernel.org
X-Gm-Message-State: AFq9FYLeePXgGMUDnUkDBRI6R/SXxICDk/RRC+nltIOEww1t9PxCri8Q
	5xCFlRT6Z94mjWfS10z/C+M6jzpcjAcjnzj0uMRyGMbKxkPPHdmNcxbCYUmiQFiaOHEFCrN1m3q
	FCeVSsHkNvuDHc2T8DQ==
X-Received: from pjbgp15.prod.google.com ([2002:a17:90a:df0f:b0:3ac:3bb4:e960])
 (user=shansinha job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:4ce3:b0:3ab:a188:b8b7 with SMTP id 98e67ed59e1d1-3aba188beb4mr9134720a91.22.1792113747146;
 Thu, 15 Oct 2026 18:22:27 -0700 (PDT)
Date: Fri, 16 Oct 2026 01:22:08 +0000
In-Reply-To: <267f5e92-651a-4874-936e-70f3fbfe1e16@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1792014060.git.prsampat@amd.com> <55c189e9130a7d22c0b756440f10a056415404e5.1792014060.git.prsampat@amd.com>
 <atElnAcDQFTnmdVr@tycho.pizza> <267f5e92-651a-4874-936e-70f3fbfe1e16@amd.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261016012208.3220126-1-shansinha@google.com>
Subject: Re: [Patch v4 7/7] crypto/ccp: Implement SNP Download Firmware EX
From: Shantanu Sinha <shansinha@google.com>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: Tycho Andersen <tycho@kernel.org>, mcgrof@kernel.org, russ.weight@linux.dev, 
	dakr@kernel.org, ashish.kalra@amd.com, thomas.lendacky@amd.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com, 
	aik@amd.com, nikunj@amd.com, michael.roth@amd.com, shansinha@google.com
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 15, 2026 at 05:09:38PM -0400, Pratik R. Sampat wrote:
> On 10/15/26 3:38 PM, Tycho Andersen wrote:
> >> +	/*
> >> +	 * Firmware either just requested a rollback or a rollback attempt
> >> +	 * failed. Keep the PSP dead for all other commands, only another
> >> +	 * DLFW_EX attempt is allowed through.
> >> +	 */
> >> +	if (sev->fwl_rollback_required) {
> >> +		psp_dead = true;
> >> +		if (fwl_ret != FW_UPLOAD_ERR_HW_ERROR)
> >> +			fwl_ret = FW_UPLOAD_ERR_RW_ERROR;
> >
> > I think this error switcharoo could use a comment (or maybe just be
> > dropped?). e.g. if the user does something to set
> > ->fwl_rollback_required and then tries another firmware upload that is
> > the wrong size, ERR_INVALID_SIZE -> ERR_RW_ERROR, which seems
> > misleading to me.
> >
> > I saw some discussion about all this:
> > https://lore.kernel.org/lkml/20260924213737.3833625-1-shansinha@google.com/
> > but it's not clear to me why you need to reset the error code here.
> >
>
> My understanding from that discussion was that userspace errors should
> fall into clean buckets. read-write-error would mean "roll back",
> whether it came from the first failure or a later rollback attempt,
> since a failed rollback still leaves the PSP dead and needing a
> rollback. dmesg would still log the exact reason for the failure.
>
> That said, I see how it can be misleading, and I'm fine with dropping
> the override or putting a comment and re-spinning this.

I do see how it can be misleading.

I think dropping it makes sense. When I suggested the changes for v2,
psp_ret was only logged via dev_dbg(), so the sysfs error was the only
clean signal userspace had. Since the error code is reported in dmesg
now, I think it's fine to keep the original error and have the sysfs
error reflect what happened on the upload rather than the action
tooling should take.

Thanks,
Shantanu
