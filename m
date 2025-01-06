Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703491D7999
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jan 2025 17:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736183888; cv=none; b=WJDp7PQbJV9dK5EajUkTcB67HQ9+PL+RWenn/A6R/brZSuzeS8QjvxHnkncn4ExTxrQL9ym4AgS3pk5RNOAKzqM2Zvjm+wQUGIbE1DfbNdwoMuBgeJu5QvQKBGMOGq58UtE28wZJzdpx/Ajv0ypFBwCgi2n1o1elMxPlTmHxrmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736183888; c=relaxed/simple;
	bh=qXFqgqxAqyUeWVPBcafW/WpP7kiQQk/e+qd5C+KpIfU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=maurJGqVgXzHmqgwyDjMVAysajK3PIvtpTy5I98XTclHnNYPrzIVes/hGc0nzSo9MHtib8J/5HFPCxo4ZG9qpk6H57DRxKBVb7bgGvObuwgW8j53aZ+TK5oyOWydnD8P0uDFeDhuJTZxmm1UM0t+lAwqn4ioiynFfo6HB2RNttA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p41AdQMO; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p41AdQMO"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-aa67ac42819so2103413066b.0
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jan 2025 09:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736183885; x=1736788685; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qXFqgqxAqyUeWVPBcafW/WpP7kiQQk/e+qd5C+KpIfU=;
        b=p41AdQMOHuVrxZpkejKn5c10cGK8XlVRdwlKTgfoUoZrSYEBSiAOKoxiIgV5wc8/3W
         a1NEpIEQ2c04eVwyfAgnt+qRQjdh/GAbB+zz0Kxuj7UFTx2Z2wMusWx+IEfriXRL8ME1
         l6TqH4QeDWdfpQTmsk2IVgMOjB2vRQ0yG/MYdyJO9TJp8B+ic66ykOPWFJIyWp5rp5Xa
         kaMwnRASy9CVaJUw4Vz0Iufw0aC9S1CarlAeUdj1/zR3ng2Zc1bGAdu2ZXtBWNk6nGmv
         /R2s0HEq2F02ZHGuyxfwmUCsSmMMmw8s8eOxpCriqooG8Vy/31dfDb8JTNI63eOLNveM
         okNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736183885; x=1736788685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qXFqgqxAqyUeWVPBcafW/WpP7kiQQk/e+qd5C+KpIfU=;
        b=GiawkQKaiCNa+gSIHv/qxdWey7eEkQsQCqxQ+PtIOuV0051L6gwc/aXQj3eCrH05t3
         XPYFBSNo/f0j1JvlPNJeH5ZEcicDRMDQ0nUJzTH+AUeQFKPJs50D0VmiY6/wAj9iDFWh
         51NRUu4Oe+LaxgGH0eyDDJw0IMAqtW2o1Ed6SauTjk8aTfauCrRDbt/M0WQiElgJCzQN
         lAE5biR26/HshX4eewRLbZTa1hNlULrYJ7N9Sym60jHbs/x47fPTGsI2pIODwIcq5cZu
         QZth3hA29bEPsHy7bB63p/ic+Nxq6qKfaOWf2SvtEMgcoMwE+kjt2BLEWl3Ywoe9fc2J
         +4Kw==
X-Forwarded-Encrypted: i=1; AJvYcCV8OlkuU2sNknLrURvA0bF1uyXxAAP1SnOtwHPluUF64fcVzQqmubPppirgYlrlZ26uPQoa2nC88HDxk+E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyi1CsqaL/TtmPQPPh9cGtrElEKmR1UjezgQqWqQCemIt3/+sLz
	trUVnLYUqAtgOlSXY4Nqvx7/oloFl3ROr/BsMcyEGPdMRFkzKnP1fIHE8g5oJ8UHqaQEb/xlSP4
	sLwlnzIOaa1W1XTDvmH5K0sZpvqvbcnNjtIE/
X-Gm-Gg: ASbGncvNAztYSBiQHEllG5Kl2x6LLqjWzFFvHoBkszQlg6HjXi6ntk9E9q5nJpaeY9y
	MxyfmSD7oPoKEz06iviL5nAHnM15Ltv2pmTy0zGbOQw4tgMsdvrerj7sGSLMOoUPrNaDMGQh1
X-Google-Smtp-Source: AGHT+IH4zhvWlbTKOD8lvP8RMMKJA0yWR5I3TDvRZlab6xY+9KB36ULJffWZ6mcFIjwUzAEqY3NRwnlWiKUO7EH3Sjg=
X-Received: by 2002:a17:907:96ac:b0:aa6:59ee:1a19 with SMTP id
 a640c23a62f3a-aac348c4720mr4648129566b.60.1736183884594; Mon, 06 Jan 2025
 09:18:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1735931639.git.ashish.kalra@amd.com> <707efae1123d13115bd8517324b58c763e9377d8.1735931639.git.ashish.kalra@amd.com>
In-Reply-To: <707efae1123d13115bd8517324b58c763e9377d8.1735931639.git.ashish.kalra@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Mon, 6 Jan 2025 09:17:53 -0800
X-Gm-Features: AbW1kvYrCxcJi7iB4tiG8Ua04Oabv3b6MoW0bEbHV4EKkOFCLYtAjLUDnY9Vig8
Message-ID: <CAAH4kHb6-us9a-GZhXEs2Ah0aQp5YwSniHVvJ=QtuiJF5LTrAA@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] crypto: ccp: Move dev_info/err messages for
 SEV/SNP initialization
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 3, 2025 at 11:59=E2=80=AFAM Ashish Kalra <Ashish.Kalra@amd.com>=
 wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Remove dev_info and dev_err messages related to SEV/SNP initialization

I don't see any "remove" code in this patch.



--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)
