Received: from devnull.danielhodges.dev (vps-2f6e086e.vps.ovh.us [135.148.138.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85173C17;
	Sun, 25 Jan 2026 12:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=135.148.138.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769344545; cv=none; b=qUxMkZSP1TTeG0Ata4TjUduuBRe9r8MOtLYEDwGogoxJ6AW5x3Xa49ihRfF+7pLn08/1ucWUTNmdX4+gQsw/L7N6iwUxPwCGB4bxdVKlQ26Rugcpd7rPiQIyISFQpI73zvYIEFYNCUfIAqlkWd0mEiE54v28JU0/FtYWX8gOAeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769344545; c=relaxed/simple;
	bh=AdO9Ky1jH1UZBMml3ZkhvJLmWNgr0lSnD20567FTk7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sObVpgmENqtylMzf+loGeIIg1sZ54OitFXBuIJQsFUZlX8msOk1Q3R8S2OSBDzcZyKFgFhX1yVNk0geFE7MsE8QVQ7IhmQV3sO41v1iTAxtTCvtmR8ub7d+otEQjpJ33Mry5JZWI4DOem24HheEyjg2R0XGihxxt0MAAMVsyK6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev; spf=pass smtp.mailfrom=danielhodges.dev; dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=eQrpjNu2; dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=cCh/uV4m; arc=none smtp.client-ip=135.148.138.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="eQrpjNu2";
	dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="cCh/uV4m"
DKIM-Signature: v=1; a=rsa-sha256; s=202510r; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1769344498; bh=XADZthbr48JgjrdwuL81M9F
	r5NCF871XhmhImP4amhA=; b=eQrpjNu2ly68uVfsAz9ToAqV6P4L90q46vqsjPUdM05NWhXyeW
	flv9Wx2Qp3vdRUoE+CPXdeB55j4LelylQmqu8MZOX2z4NXsed4i7zzOjWIxvND9QaEmDphDKAI2
	WyboGyYBEDHr0qSmoskQLAPt+fcNxCFDHWWKVMmTz/6hsQEWIvESaNJLPRi2O6JdOmQazvo+4tl
	MXp84vzK/73BdQgs7Cy9MAcMyBlUgMchVMHnlGCu0O9GGjbcuoWL36pcWUlrfCx18Knoioj90fq
	gcNOkksuOj0gl9oIF1tpPWxvIrFy9kdNKPuwMCl31wEg36DzDiMlwjYY9+IC9F7vqwg==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202510e; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1769344498; bh=XADZthbr48JgjrdwuL81M9F
	r5NCF871XhmhImP4amhA=; b=cCh/uV4mlVLFkJ4I56fqZgOS0EOCR3VTFvONKK/BMv8ygIaZ+G
	d4r5xPb3HApCh9uyGyJGKXuWCtmZoTGvslCw==;
Date: Sun, 25 Jan 2026 07:34:57 -0500
From: Daniel Hodges <daniel@danielhodges.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Daniel Hodges <git@danielhodges.dev>, bpf <bpf@vger.kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Vadim Fedorenko <vadim.fedorenko@linux.dev>, 
	Song Liu <song@kernel.org>, Mykyta Yatsenko <yatsenko@meta.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard <eddyz87@gmail.com>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, 
	Yonghong Song <yonghong.song@linux.dev>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next v6 4/4] selftests/bpf: Add tests for signature
 verification kfuncs
Message-ID: <hk2e2og5v347kmuyyegilgejktgafjgvbxopfk4a2lippmggch@nzuoznk376s3>
References: <20260124174349.16861-1-git@danielhodges.dev>
 <20260124174349.16861-5-git@danielhodges.dev>
 <CAADnVQJQsC0cQZPJpyofY4Othi5+j7xjAY+xbNRkX0p9wA7Khg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJQsC0cQZPJpyofY4Othi5+j7xjAY+xbNRkX0p9wA7Khg@mail.gmail.com>

> > Signed-off-by: Daniel Hodges <git@danielhodges.dev>
> > ---
> >  MAINTAINERS                                   |   2 +
> >  .../selftests/bpf/prog_tests/sig_verify.c     | 163 ++++++++++
> >  .../selftests/bpf/progs/crypto_common.h       |   6 +
> >  .../testing/selftests/bpf/progs/sig_verify.c  | 286 ++++++++++++++++++
> >  4 files changed, 457 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/sig_verify.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/sig_verify.c
> 
> It's a v6 already, but your new selftests are still failing in CI.
> 
> Error: #385 sig_verify
> Error: #385/1 sig_verify/verify_valid_signature
> Error: #385/3 sig_verify/size_queries
> Error: #385/6 sig_verify/zero_len_msg
> Error: #385/7 sig_verify/zero_len_sig
> 
> Please make sure CI is green before submitting v7.
> No one is reviewing the patches when they don't pass their own tests.

Noted, sorry about that. I think my local vm has some different config:

vng -- ./tools/testing/selftests/bpf/test_progs -t sig_verify
WARNING! Selftests relying on bpf_testmod.ko will be skipped.
Can't find bpf_testmod.ko kernel module: -2
#385/1   sig_verify/verify_valid_signature:OK
#385/2   sig_verify/verify_invalid_signature:OK
#385/3   sig_verify/size_queries:OK
#385/4   sig_verify/ecdsa_on_hash_ctx:OK
#385/5   sig_verify/ecdsa_keysize_on_hash_ctx:OK
#385/6   sig_verify/zero_len_msg:OK
#385/7   sig_verify/zero_len_sig:OK
#385     sig_verify:OK
Summary: 1/7 PASSED, 0 SKIPPED, 0 FAILED

I'll figure it out properly, thanks for the direction!
