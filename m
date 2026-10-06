Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC7C3FBEBB
	for <linux-crypto@vger.kernel.org>; Tue,  6 Oct 2026 20:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791318287; cv=none; b=r1aOwgZAVOR0C8L9SsleZ6Yc9e94/jFU3b5uxHhdvwRdUvbIgCwn6PtqOwKk8Kd4OvzCvFX1vAs/mfun+V4Lg/FwgZopxpZWnwbo2lZ/JxBrKRucUWwqPb/fpBPKygw5u72e3HicKBXgx2I1oZnJqfSVJFZ7xwc7UBdqK9DwCOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791318287; c=relaxed/simple;
	bh=ZMs1I0vHEJ58LnW7kl3Pxyj2r0+UXZyY7hpZLdur94U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vui9GJ/vtiq03XHqT2hiMzqpCiNSJebvcmYrAMOz9EYSXwsW/YlaTt/4JmO0hMISsypBNfHlmfvtA+p3uOI9luvvZrnozwaoSs7I6mLQ6oOSugOKMB9GzRbH7L2Z5ECaWvxzyn/JhmvzuK5tQ8mGaA8GuMU7n5QS/i+7ZWoNj/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--shansinha.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CwGxn/gu; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--shansinha.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CwGxn/gu"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e601800e58so4142825ad.2
        for <linux-crypto@vger.kernel.org>; Tue, 06 Oct 2026 13:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791318286; x=1791923086; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iP6xZp/taTTzoZCVyCIXKC0KFbdOjG51cDdoA/0MxQM=;
        b=CwGxn/gueoaO1C/MMRZGjnVY7WxlEwMbCtfPPAsbxQX72d7B7vjxwAd3KlOEeNBJyg
         GOKaFFlq3b+DJ23739iQ5CzQj3NJKZgQEEFzy+6YS/8Bro5LpT5dGTXlqykfsCtb+65e
         SIaM+QN32Q5A6vcK3BbyZHRqJ+9Ny2ZtQygmSdfmjc2vFE/qtXxH9kBZj7kMQAUtbxvP
         bBDlF9+8Xm88MeSqaR606xtZUZCsPgfawf5Bv16mhmbZYDcJ0iGEGY1N9D8ooPd6t+XE
         DFoHE7HsCJ0E85//L7cfIIsgKmlE2LUFyUDm6b72Ik0Ww24KNTz/fA1GUFaYEuBAe8cr
         1+hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791318286; x=1791923086;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iP6xZp/taTTzoZCVyCIXKC0KFbdOjG51cDdoA/0MxQM=;
        b=03+2wRfaPZbvgJqf7mW1GA3k42JD6hgiNinLDQ6+Zk1trk+5kyuysCw+NbSup8W8Q8
         QEMj3WLHL6dt4CI7Rsuc3iN3297bJnSPdnRXYfuI1SB5dTDP+i8+bHFsz2kcI/g8O+Ub
         HsTLqbdG1sAX77jpLaYnouR4Hbjc+rid/HJzJ9jzC1I0rZKwDT0X6PbrVfgxo+mP2Z8s
         g9FshAz38xof3ACktINJYtPaSNRvoX/ejV/rkEcv3bcUkbR2pc72xd/F9cZU5V3sG2qb
         WkJh2MbAhADwbF8e+9ChY/LP+lxM+dZyQrqaWE1GVRvquDP7sLq4XOy6YUFWioQ8SOQF
         SAKQ==
X-Forwarded-Encrypted: i=1; AKwUvBzcFn5Jnogw35EAc6IKdQ5IZTDjIdkq0rsFR2zhEzsVbjfPPlarHljdrwMkO7TsejdInvIWuu+TPIf5460=@vger.kernel.org
X-Gm-Message-State: AFq9FYIQgl7J1enLtKjMU49I0sG6hftEDXCkgsXqP1MdhIuhzoeM6QXO
	GKOjN3hshIrFflmFo/NJEbpxdzhqNU4RaFU7bBgB+3z6GLVf/KNrIjov7YX71BtzDekv4oSrXcj
	E+xHNlHZFWy/QHlAkGg==
X-Received: from plbli6.prod.google.com ([2002:a17:903:2946:b0:2e5:35ae:2a7a])
 (user=shansinha job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:b86:b0:2db:3d84:effc with SMTP id d9443c01a7336-2e5ffabc0c4mr4755845ad.6.1791318285725;
 Tue, 06 Oct 2026 13:24:45 -0700 (PDT)
Date: Tue,  6 Oct 2026 20:24:44 +0000
In-Reply-To: <35ce536c154380a2f8f3af9b2b50069ce16804d0.1791212077.git.prsampat@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <35ce536c154380a2f8f3af9b2b50069ce16804d0.1791212077.git.prsampat@amd.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261006202444.2676092-1-shansinha@google.com>
Subject: Re: [Patch v3 6/7] crypto/ccp: Register with fw_uploader and always fail
From: Shantanu Sinha <shansinha@google.com>
To: prsampat@amd.com, thomas.lendacky@amd.com
Cc: mcgrof@kernel.org, russ.weight@linux.dev, dakr@kernel.org, 
	ashish.kalra@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com, 
	aik@amd.com, tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com
Content-Type: text/plain; charset="UTF-8"

On 10/5/26 9:15 AM, Pratik R. Sampat wrote:
> +#ifdef CONFIG_FW_UPLOAD
[...]
> +#else	/* CONFIG_FW_UPLOAD */
> +static void register_sev_fw_uploader(struct sev_device *sev) { }
> +static void unregister_sev_fw_uploader(struct sev_device *sev) { }
> +#endif	/* CONFIG_FW_UPLOAD */

There's no Kconfig change in this patch. Should CRYPTO_DEV_SP_PSP select
FW_UPLOAD? It defaults to N, and the other fw_upload users select it.

Thanks,
Shantanu
