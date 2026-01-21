Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D504418F8
	for <linux-crypto@vger.kernel.org>; Wed, 21 Jan 2026 08:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768983126; cv=pass; b=cB52jPTPeEwUprZtUqNs6KPBGXNRVPvNzVqqkRMSaOhasuT1N8wceqPDANkZ/5/tk+c+ik7z0oQ7YVIJRl7c9iMzoqSd4jVC2UHmOOVdWhWXTE0jDuWy5kzHbBt/7vL4w4ASoK7wRyGK+wRtmdIJ1svNoh3TS8prdI/eIdwS8G8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768983126; c=relaxed/simple;
	bh=NcPcHijqCx7t3zPi3d2W+9QUjcbq1aI+GVwFFFeFbq4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dpExtbEDMocdfckdts4UtNdv15IPNkkJNWcTrrKa7B7RW5IMqBqVwXDv6s+BHngWebHJBGoEw/7j/msQAGn+KjGe6SCZZCa33FBxrOwow1Y/pCJYnnn9rQz1QzWZZWSjNZ2tD41kQckLSeX4mKceBtNKgMRbiUg2fYfuXWb0PPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=ZdVhO9OQ; arc=pass smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="ZdVhO9OQ"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59b76844f89so6102759e87.1
        for <linux-crypto@vger.kernel.org>; Wed, 21 Jan 2026 00:12:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768983123; cv=none;
        d=google.com; s=arc-20240605;
        b=H/S7VuJFCo7H2gNDQKE2XWDIOxNau5p82xbZxfJ41OYNOy/eQp0FA8q/eqPy0jAot9
         Wcy/oI3WcdYY152bkZRvnOECuGU8wA73kjwXJYSnJ8QV2JOnozWxhTVPwAgPjimcI42q
         iIxOLgkxETBmuEset1D3dHv/tyYJc2nfVgccYDNVjFOjeDYg+BCft5+sXFI83xW9ivXk
         tWgSSpuUl0m9tZCJBYJK33aIpwE3vw8jBIV0evFjGG/qbefTFGarNBXlDuJQER2gSANP
         f7qzZNvrig8fgSrygAEfyMDHS8KFfViu1WFyjAdt6eryXQlJXC6OtiCIqnVJZ8nJUfYy
         kymg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7fXCBugNbG8UpDEmEOBmP8ra4Bif5NvnVW2PAsTZKdM=;
        fh=LpvceIx5u5xZX41Hrgxuqbcp6DSu0YeawH40ccTtj28=;
        b=Xj8AGUWKB90fOS04+5IIdX4F8234s8JiVGGjF1DEG9sCUuyfdOYJdvDzEstaysfj8O
         plhYaW+eObJEcY/VtGZ+uRakS/pw02cCCgwN/d6RNT9xztHJB0UqdmZ9x57KfBjjx3F0
         rD4CCRvGetf06H+h2F0AgJJ/zyY+ZP00u3xMnWgE8c8VUufkxB+KJRikf3HThZNYt4Cj
         VS4hRyZooL3Pr0tZZUv8DiCbBbVc2O0SlWXGJNnClEQlaxi9qsm75qJUQNjoxic6M2S3
         FlULB6/4qUlaFQFipk0tGkCW/rq4OnFTIGtL/W5fr0XBv645u8J+mjye9iYZkmfJMKR8
         7/1Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1768983123; x=1769587923; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7fXCBugNbG8UpDEmEOBmP8ra4Bif5NvnVW2PAsTZKdM=;
        b=ZdVhO9OQUc0wiKmBFlmD8k8TUGqsMUSipCPOvNPYADDKeiTc6sa99VIgDi2FHKkZ/U
         Awkh2QH5dLTlkwim2U0tmBzoezXZIt391oDRSB8q2+eF46TUcVLaE5lyHBezcI0rGyGX
         3gRH2QPt/ybJ8oj79BkHF/V87RMdLtTZx/m3mQPAaxSwc3316N9I+ufcZQa/FAOHBKrx
         KkDqoxXHMtVYME+lgECQbFbuNoTnZztld4VI8sgtKWgUzM01s/I6jl0t28uH8S7NCGDj
         cKdh0oboHRLvXVG6ac6s4kUaodyOt0hTQG5dVDS3n4mumRZ3/0/OgbiW1TKMj8abHGzo
         z98Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768983123; x=1769587923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7fXCBugNbG8UpDEmEOBmP8ra4Bif5NvnVW2PAsTZKdM=;
        b=F7+UvRfBAQRWJ6QxKOQBzHu67uoTOjM4j3kIn6bn6yFo8977uLSMqgN320BmhIpG6/
         A53lS85gcwviIuQxG1HlL82xZ1M3/aJ9oEJuOpW7IXvuyEOTiggC1rH9/tvltxSrt3a+
         XPlcxwWkxD43JzYEULa4wuRx9rfKB4N2MVHJ6wJyVOuEPgl4QZNTD/YBx3lIzbtJp2Qd
         KTDieHeIVZdMfVwLLuYX8e1W94zOPIbxdRJC1vHlgKircuxfc7UdifP3Vgz++Ku/dc+a
         COUt0rF1WuJH491J2jaFHTgllKjxNXKUPu0A6WW2WPyFdH/ci0kCAZVP/P/Rfeswp6QD
         6dtA==
X-Forwarded-Encrypted: i=1; AJvYcCWfAgg7stIel3fW90WjNMM+jUX1husOJgKz8wf0k+n1rfr1DkPo9TqDCfXHq3ocMuffhfB5feiiqByGjMg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhpFWoHkV16IQlQ4t0Jtp4rn7vN6wIKfduzS77FhrLy7jqbGGs
	tSspuGLO22CrR91FJyT5aZg30D5a87BqAEpVWtB23xasBVddFMzHexqEYP/aYf9F9Fa0uU6rQh7
	OMw8sPSA6fmiFm5nrEK0xsNUsAlvEi2rDMFUPQv5xSQ==
X-Gm-Gg: AZuq6aI6YS8kEw5oo+7GULldeaPQeSinYCKKZgfxft9jcZYAdsxTtTHrkBYO4dTHTWq
	bckouGH21vQFG/ZqSNOaVFzzZHT07R2d26F/sFYgQtbHWs81IaqFs+ETJg3Mplxxa8KkWkS4pl7
	SD+YVMWIgo2blrAQ5rbj6fBsWVuxw3pBOKieKUFmAHFhx+F+w53pK6PikDwMZNIf18guXY12jpB
	YAyXdvrA0eKXMXequsGoVFUyhowuwIzQcFYG6ox7fQvs+WU18Pkk/tzLxZe6ZsB6yfylmqzPT2N
	F9YI1d4rSYM62aiGVC0npkAAOGYF
X-Received: by 2002:a05:6512:138f:b0:59a:183c:4863 with SMTP id
 2adb3069b0e04-59baeeb1d8cmr5444078e87.8.1768983122854; Wed, 21 Jan 2026
 00:12:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260120224108.GC6191@quark> <20260120145103.1176337-1-dhowells@redhat.com>
 <20260120145103.1176337-8-dhowells@redhat.com> <1416722.1768950957@warthog.procyon.org.uk>
 <20260120233617.GA10653@quark>
In-Reply-To: <20260120233617.GA10653@quark>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Wed, 21 Jan 2026 08:11:51 +0000
X-Gm-Features: AZwV_QiRbs3OO4qM3uwaFGGNt_nfptg6k5-iiQUJvwUGMqgS-PCFW0-TncfBeF8
Message-ID: <CALrw=nGHEf3zT0yb2ybpH58ah4dT4_H11TseDL7Fs-w7RBY6hQ@mail.gmail.com>
Subject: Re: [PATCH v13 07/12] crypto: Add RSASSA-PSS support
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>, Stephan Mueller <smueller@chronox.de>, 
	linux-crypto@vger.kernel.org, keyrings@vger.kernel.org, 
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tadeusz Struk <tadeusz.struk@intel.com>, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 20, 2026 at 11:36=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> On Tue, Jan 20, 2026 at 11:15:57PM +0000, David Howells wrote:
> > Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > > As I mentioned in another reply, error-prone string parsing isn't a
> > > great choice.  C has native support for function parameters.
> >
> > But is constrained that it has to work with KEYCTL_PKEY_VERIFY's info
> > parameter.
>
> The cover letter of this patchset summarizes it as "These patches add
> ML-DSA module signing and RSASSA-PSS module signing."  Adding
> KEYCTL_PKEY_VERIFY support for these algorithms would be a significant
> new UAPI feature that would need its own justification and its own
> documentation and test updates.
>
> However, it was established pretty clearly in past discussions that
> KEYCTL_PKEY_* are a mistake and basically exist only for backwards
> compatibility with iwd.

I disagree that it was "established". It is some folks opinion here,
but I find it quite useful and hope it would be actually extended by
good algorithm support.

> So I don't understand why you're advocating for adding new features to
> them.
>
> - Eric
