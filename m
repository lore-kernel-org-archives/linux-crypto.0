Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC82037C92B
	for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 19:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782241960; cv=pass; b=GwwgGthVhccBB+1B+InCg64loEFjig6eaE2lfHEv7Ho5wZ9a/CMIIld/M1fQPg0MOS4IQMJ2FDSQsQUapMErtThf5x08g8yY9C6Pcd+z+MnC4k4Iv3s6UlCGcVaeEOFtRk8IXlhmQzRU1BqXhrungawRjr5k4LxgJj+qpCElvsA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782241960; c=relaxed/simple;
	bh=ii6MvtTjLi70cljzH6vlCK19qdEyYEgO4Rik7cd/sMQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dBpfWXp00AZ7NTBbW1tp/dEHdrA0HN8XpkFtlXZ/KB42GEW6E9V/rq0g32PctXQ1BzGVkZ+9DoYwiyZJudt+cpbd9tQ4IVpiEV8Nqiysd9jn59iZ5it5L4VwrIf8ZqPERUSVwsZA9AedDNcGVI9L6cCg20KaVfRA9zeVQvzA89E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=muhNy7DX; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="muhNy7DX"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5aa68cf9123so188771e87.0
        for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 12:12:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782241957; cv=none;
        d=google.com; s=arc-20240605;
        b=XIHdbeqWoI2pvcmDEleuYYiVLD5NYgqLWIQOG81tSi3wJDxPTpovobJp0cZ1ikiEEZ
         MDPszc6hQLTZDjLm+NNv0HtRna1TKJTLShZV/5Eb9+dpbFZ0uR/xv0VGahtw8ckzEKYm
         JsxgXatOgbD4pTbgup7AFsTXI7VrLpZSFAH1ndRMElZS/EhtUjReu68H4a9n4uxHBhiF
         4nxcJ/XxRHc1G9sJBaiOV0mBD4649zws6X2lLV3weiRSaz0k1LolxCqjyg40QPU4Ysqr
         UN3XoFDpm8cJkTTqo23ZUQTJoQcfYeQUpzagWTQoV3C4lKmCiHEdMc4TXruci/2ibubf
         DBrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/vvDwAJenwF6coS01e9xCYrLEyTAVwYfnUT70JedLS0=;
        fh=yt8H/DFDaBdmJvX/TgJWio/bkNfGJadNuvqWYJpZXLE=;
        b=EZyCN4cZrOoAs2IQgCEROosNR5S1PcFMoFtlMnLUva58btw0e4WhRj4UA5rRGPa4sL
         eOVZcbgp7CHH4cKQRxBtS9tAPUPeilI3GBUwCB7ctsY/VxuKYTttxsqnuN5OxNUMbufa
         FurdOoku8CVGHs2FF7EtING8FbqHWQyNllGt8iD+oLPUvaTRI4JgaAqooslv9yozuE29
         oYm0T7yN8WnucyGtUM9GFawhYnRa+N7qHUTvh3Ddeyhqjj48e3XFmQ+FNwLaoB4bxzcH
         0VZfga8wkswI3q7A3K9wbo2mMW+PQ8oRk+1jn0n+lHylsEERbB1YpMTDzt3Cu11eYc/A
         K1Vw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1782241957; x=1782846757; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/vvDwAJenwF6coS01e9xCYrLEyTAVwYfnUT70JedLS0=;
        b=muhNy7DXA2jhxWRc7VjyBLC2W5K+vsw6ky4fhELzH5+mRCNYrMENNAMsiac1FFAwAN
         5Y7j8e33TdHsCW22GLfJnZxalkzwM7GZWN02MUoYYDLU91tQ91K3wGjQo9RiX+9NN9Ls
         al2Xadtgum6dohsjBdSHYFJm99lajb9XcLcpmLnhl+4ZzLY7YoDqjg+6+Z56p/czMQxo
         5DzqbALLVqR3t38rJOEeC+XAe6FvKLOnedaTm2N69vu+ZPlWy6eznEgmzxQP1DLGzai2
         lh4LkfW5orbRHtlQc57Hs7Y4xakKRD9UQaDbbmG4cuuSZ+WUomrh1AJkUW+YJZSrzlA/
         x7xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782241957; x=1782846757;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/vvDwAJenwF6coS01e9xCYrLEyTAVwYfnUT70JedLS0=;
        b=JMFwCMP1z1UoyomQaC6KqCld0ButaoRbSecmpZlOx9n0ht7N7+B5Q/lwxK3oW8c5f0
         EMykRtSFlaOhZ+3bennZRDuamPHIaiSK+Lmao1p70MHrYdzPp0Ia8QOoovVvWFlLQdZq
         ITWcIdX09C/if3EGOx+EsuQFN0AQXkPqhp/bCmL8TL9uGRotOlNpVefh2THa6v/4fNMi
         DoKvBw6cDxiYEKiEvr6Y+hDVLp4Zu0q0HeznQINmT3dNALZfz05M6G9/WQ0UVu4cqwt3
         GJbHcepam74Pc7Sb5GQFsgaUVMiKAjeFOankF69LhkAWvs0zkJAiheDIbxZqN7yfSpZX
         1LsA==
X-Gm-Message-State: AOJu0Yz7q6EWC/Q7zDrjmUDfKB9DsX3LDXhwD0e5mYq94Xv4F/3cVGuV
	pCBHjQXf92oRDnV6f7PWUl6Hy/GniK6bkoE+xcQlD2J+K8qV8hz7GrHEkZHsAr0tCWwXmXBTYRW
	t8a90VgyuLeoEgkwvI6FxZZtL30Zq5U0D2oF4bm2Q
X-Gm-Gg: AfdE7clABCfS+kbADnnvgFlcTPiLNSMkkayBHIrmeeS5DiFCTWcTuCYfxxOZVZcexRX
	KlRnGm+KEIP4OCCjZaehgGpUFYzsmj3wi7XV5LbrqtQZfq3oZPeQumSTwloV7OXliqgI4cTUKUl
	vEcOjg91V+AQAy5Zjo/Y95BZgWUhV+G9yJnI4hcSiVj9X7gk5f3D/lYLdw+vXHgzCU/m1uwaKn2
	K/X7SQRMzs5yAbfKs6lMZq98esRm4GF23tYdtSb9s8E8dNMc+3LIumF7Vll8CJX4vAsl/uO
X-Received: by 2002:ac2:44d4:0:b0:5aa:8822:b874 with SMTP id
 2adb3069b0e04-5ad5771ec41mr4233175e87.46.1782241957214; Tue, 23 Jun 2026
 12:12:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260622234803.6982-1-ebiggers@kernel.org>
In-Reply-To: <20260622234803.6982-1-ebiggers@kernel.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 23 Jun 2026 12:12:24 -0700
X-Gm-Features: AVVi8CdurCE0Z4nmJzTanxEgxUT-VwvR4nCHq2kkCJY0BXv2CrDitgelAGd8YoA
Message-ID: <CALCETrXPj0u=FZ=aFcZAHk3fFZa7rCuPEjx6cOMXmT3sdkC7SA@mail.gmail.com>
Subject: Re: [PATCH] crypto: af_alg - Add af_alg_restrict sysctl, defaulting
 to 1
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, iwd@lists.linux.dev, 
	linux-hardening@vger.kernel.org, Milan Broz <gmazyland@gmail.com>, 
	Demi Marie Obenour <demiobenour@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 22, 2026 at 4:49=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> AF_ALG is a frequent source of vulnerabilities and a maintenance
> nightmare.  It exposes far more functionality to userspace than ever
> should have been exposed, especially to unprivileged processes.  Recent
> exploits have targeted kernel internal implementation details like
> "authencesn" that have zero use case for userspace access.
>
> Fortunately, AF_ALG is rarely used in practice, as userspace crypto
> libraries exist.  And when it is used, only some functionality is known
> to be used, and many users are known to hold capabilities already.
> iwd for example requires CAP_NET_ADMIN and has a known algorithm list
> (https://lore.kernel.org/linux-crypto/bcbbef00-5881-421b-8892-7be6c04b832=
d@gmail.com/).
>
> Thus, let's restrict the set of allowed algorithms by default, depending
> on the capabilities held.
>
> Add a sysctl /proc/sys/crypto/af_alg_restrict with meaning:
>
>     0: unrestricted
>     1: limited functionality
>     2: completely disabled
>
> Set the default value to 1, which enables an algorithm allowlist for
> unprivileged processes and a slightly longer allowlist for privileged
> processes.

In our brave new world of containers, this is a bit awkward.  The
admin is sort of asking two separate questions:

1. Is the actual running distro and its privileged components capable
of working without AF_ALG or with only the parts marked as being
unprivileged?

2. Is the system running contains that need the unprivileged parts?
(Which is maybe just sha1 for ip?  I really don't know.)

Should there maybe be two separate options so that all options are
available?  Or maybe something between 2 and 3 that means "limited
functionality and privileged modes are completely disabled"?
