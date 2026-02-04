Received: from devnull.danielhodges.dev (vps-2f6e086e.vps.ovh.us [135.148.138.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D12D221F17;
	Wed,  4 Feb 2026 14:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=135.148.138.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216473; cv=none; b=Sgyqxzy3cAm2HhSb/nFWuExtMI60rJHt3jXfu9J1z4yc0l7any0NlDCKI1tCLfXdcw5Gx2vy/0o2+eigh5sLD8f+AY4PJ/XrNCRt70R0x3OIOcN64Y6bgADTQo8VFRfnshPK43D/COdrJ42qNNkAtUtExPiq16uw2jL72B12qgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216473; c=relaxed/simple;
	bh=cVT8WHJfGk4nWcdIZW1SwkZ+I/WqqtloyVvg5OJj7F0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LN2zQjpJ1s0CLQH7PS/oG1jSWk5NfHW+akkd1dG7Nn7bL5p4JW07PHV++bSGIz1vDPJ4+zfL0YU2v0x+0Ce73RX4etxFDqOk+LZw/OEmrG5MQtWGNNvXIJndgB3YX1pp2aPF8VZmSoICA092mRdsrvqc8Kdp1+mvQolgSkayp6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev; spf=pass smtp.mailfrom=danielhodges.dev; dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=GJ+gReji; dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=mQLgS5BF; arc=none smtp.client-ip=135.148.138.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="GJ+gReji";
	dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="mQLgS5BF"
DKIM-Signature: v=1; a=rsa-sha256; s=202510r; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1770216444; bh=Nd0aRRqAD41vHNXvjIxkaZr
	PI0JaUhJaiMQx5lXea8s=; b=GJ+gRejiEzUS7gbWSS2RTGHstaVD8poePmqxz9av4bpAbMIawF
	zsZcQt2SSSxWj0Je7KVWPB0nUYXU3QsnzhPQ7hcWYD3qHLTzwOoFnRdKW9WCyXKaROZ0HCNmH1l
	yfIFt6OrdNgCTIh6GmojCcX7K0+FQh+RHsZ7pWBT71wjrtPC98LUv+jGBepmDDTDyruLo6pz8/x
	RbCOdP5N/6QA9GUwjx6KSNeGBwWkcfxjIk1GyY1lsJa/Xh5eB+1vUx3FHNn2MzzGxgF1IdtZYg7
	/TcPM1EAT45QVYBQLQrEFhP9NKEUbo61f3bPoTfGsmW5ugQDg7S56gtgMu24PdbVkjQ==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202510e; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1770216444; bh=Nd0aRRqAD41vHNXvjIxkaZr
	PI0JaUhJaiMQx5lXea8s=; b=mQLgS5BF6o5ZzdbTQW3NXQdfWy1Ex26DeHgffPaYihoDvvnzgb
	iQu6G80+yBGcinNoNwhdX2nlOS5hCePU30BA==;
Date: Wed, 4 Feb 2026 09:47:24 -0500
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
Subject: Re: [PATCH bpf-next v7 3/4] bpf: Add signature verification kfuncs
Message-ID: <ow6qiz7tusazk4gb4it3qvilwygk7qroifuwbtruao4rww4ddl@orh4uw5dz3st>
References: <20260202144749.22932-1-git@danielhodges.dev>
 <20260202144749.22932-4-git@danielhodges.dev>
 <CAADnVQJKjv5fZ0suJkOKtybMNsrDr9d+Au8T08AvHCPzP3z8sw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQJKjv5fZ0suJkOKtybMNsrDr9d+Au8T08AvHCPzP3z8sw@mail.gmail.com>

On Tue, Feb 03, 2026 at 10:44:05AM -0800, Alexei Starovoitov wrote:
> On Mon, Feb 2, 2026 at 6:48 AM Daniel Hodges <git@danielhodges.dev> wrote:
> >
> > Add a bpf_crypto_sig module that registers signature verification
> > algorithms with the BPF crypto type system. This enables signature
> > operations (like ECDSA) to use the unified bpf_crypto_ctx structure.
> >
> > The module provides:
> >    - alloc_tfm/free_tfm for crypto_sig transform lifecycle
> >    - has_algo to check algorithm availability
> >    - setkey for public key configuration
> >    - verify for signature verification
> >    - get_flags for crypto API flags
> >
> > Introduce bpf_sig_verify, bpf_sig_keysize, bpf_sig_digestsize,
> > and bpf_sig_maxsize kfuncs enabling BPF programs to verify digital
> > signatures using the kernel's crypto infrastructure.
> >
> > Add enum bpf_crypto_type_id for runtime type checking to ensure
> > operations are performed on the correct crypto context type. The enum
> > values are assigned to all crypto type modules (skcipher, hash, sig).
> >
> > The verify kfunc takes a crypto context (initialized with the sig
> > type and appropriate algorithm like "ecdsa-nist-p256"), a message
> > digest, and a signature. These kfuncs support any signature algorithm
> > registered with the crypto subsystem (e.g., ECDSA, RSA).
> >
> > Signed-off-by: Daniel Hodges <git@danielhodges.dev>
> > ---
> >  MAINTAINERS                |   1 +
> >  crypto/Makefile            |   3 +
> >  crypto/bpf_crypto_sig.c    |  89 ++++++++++++++++++++++++++++
> >  include/linux/bpf_crypto.h |   4 ++
> >  kernel/bpf/crypto.c        | 117 +++++++++++++++++++++++++++++++++++++
> >  5 files changed, 214 insertions(+)
> >  create mode 100644 crypto/bpf_crypto_sig.c
> 
> Other than the issue spotted by AI the patches look fine,
> but we need Ack from crypto maintainers.

Sounds good, I'll wait to hear from them before sending anything else.
