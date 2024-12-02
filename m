Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1452AD21;
	Mon,  2 Dec 2024 19:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733167627; cv=none; b=nB468ogS0gbfSluasROcTIBPmXJI993HnmVgl5rw/gkC3XuQjTI05BW8fwwSfBmwT8yE4EJY8t0LC5rEBBrpa4zATNFrSH5DpR9f8pTM2sZVjqkztd6tUUOvNkbmnFvo7kgVSTr5oHFYYfZM50RxlRlD+lfz6yjDAec64rxfo2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733167627; c=relaxed/simple;
	bh=XAPwpQqQiwcnoaUB40hRLc5pzo+e8dWNlOB+nAY8aRc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ipZzVf0v02oKpgCXtcNuFbr79Vhm57ddVnQKem8jPgWUBoH4Z4qPRcfnW/muOfovh+E4nneHB+4p2fbJei4UqBLG8R0C5kh0Bdbt8TVTKU6I/kHE/Pf0iJiAWYoc3oHU0IXsnOECKphfBS14hsy85T685+zcrbaI1BiA6kzBoWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H3Pe6LRr; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H3Pe6LRr"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3e916196023so2570189b6e.3;
        Mon, 02 Dec 2024 11:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733167625; x=1733772425; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y82eOTEhwmMyYbOhVYXDIlIEQdK/qSD3OtDPE8tkSD0=;
        b=H3Pe6LRryALFjzy9PpJJsXXyaJc3T2e/wAuu02RyBHCc0gRptYFZAymlt61DJPN9YL
         nbPSZt2lpQh3YHTvXGkeA/aDqg1b+F0swg589Br7rBpmF8Qqk8LJS97eAeY1ad2XCVcS
         7SmFaLI8n7IAEVETcR/+xG8yd//lGZCS4tJLrk9x/fZKNBc8gYoLzVZsadFK5yT/s/Qw
         VQ1uD74eaWuRFhw7kMSMHMi5kMDPMQQCe4hTwVO73I/SLWUmPIp/2HvfsFXeY50t6re/
         dz+fPjdyXwQJXMvCtHgqnTBrAIswTSTXv5uyDgtBqDWDeCL1UHusEnIAaDWVbXWF8+J+
         YFdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733167625; x=1733772425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y82eOTEhwmMyYbOhVYXDIlIEQdK/qSD3OtDPE8tkSD0=;
        b=akyDOaSWqMvngxRlviCkbuZBBwKR9LNa83v3gX+mMSWFMhCAAR9gMCvH+mELVZRnKO
         ZTyzjOh/i/PUkHkI/1ZlhJioeW0MH3PbYhqWxpSmYuqcf9K6N1aMr3IFBc59JPssXRMZ
         m2hMwx95n2uqT1YrCAHj0FkKeAM+2+rO3CD4mxJHea66EPV3v95+YExK+f1ZLr3jXFYv
         9EEs9DLqrVJEyssJGZHYL24ZCTYUVehj0oJwn8ytHieUYCPdCkywLXLcBz56zS1M7yl+
         5w5csZII4nq/bXrUfFAfq7wxNnJEbvkUlJcNgy4Y3GvIJv76t8C0n3IFI+AG0lzbXtzy
         NdSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHTvg/d5G4vrhcW5RvxZE5ks7MUn83j16FLretUv8cri8/tmFUo1Dtf2f4VAQt/v61md6JiXYoGqBfV2Q=@vger.kernel.org, AJvYcCVnLZhllueBK4mrC/Fc8UZpgkS4HJ/7Ql202ehKUl3+lugh8dnm7Nat9Yrm1k285nOjBCkHu4YLvmvFPOwA@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7uKwtIipChbMQb5nruhIPjVEHd+qXcB4UbmqgTNWZXV79EaaK
	k+hDi0rnnAGPlZkzYJfuRrAVrBuALt66lssGWZHGBHTm3LfK8MGW6es6L21r00r2z+21ZJF+/RS
	sB+MbiPPJEjtaxpYb/tioyx1FjXo=
X-Gm-Gg: ASbGncsYGIGHh+sSxmMffhhQC91x+TTxk6eyWaR8aCi6/Hu4hZXRKHBoJhkBUVo9NUW
	hvFycJigpj6Ia5K0Jfuiee1ypuEjPN7h8bhuMwxSQfkKYT94=
X-Google-Smtp-Source: AGHT+IEb0q1YzKrjqBN/l+hzvKaqv8aySTKWK83ko71V+ahoVrlVcAzoq3EPKEzVSgFNb+PZs+zg/F0X2N6fm47Wu4o=
X-Received: by 2002:a05:6808:14c7:b0:3e6:5792:2fb1 with SMTP id
 5614622812f47-3ea6dbb4b11mr19902682b6e.10.1733167625419; Mon, 02 Dec 2024
 11:27:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
 <20241123070127.332773-11-kanchana.p.sridhar@intel.com> <CAJD7tkb0WyLD3hxQ5fHWHogyW5g+eF+GrR15r0PjK9YbFO3szg@mail.gmail.com>
 <SJ0PR11MB56782CF74C6D6904DDDDAB95C92E2@SJ0PR11MB5678.namprd11.prod.outlook.com>
In-Reply-To: <SJ0PR11MB56782CF74C6D6904DDDDAB95C92E2@SJ0PR11MB5678.namprd11.prod.outlook.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 2 Dec 2024 11:26:54 -0800
Message-ID: <CAKEwX=Ppn-CKPNUJUMc48sU5uxkB6KS1HwFpvpty0nj+wL6rHg@mail.gmail.com>
Subject: Re: [PATCH v4 10/10] mm: zswap: Compress batching with Intel IAA in
 zswap_batch_store() of large folios.
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2024 at 1:54=E2=80=AFPM Sridhar, Kanchana P
<kanchana.p.sridhar@intel.com> wrote:
>
> There are some minimal "future-proofing" details such as:

I don't think they're minimal :)

>
> 1) The folio_batch: This is the most contentious, I believe, because it
>      is aimed toward evolving the zswap_batch_store() interface for
>      reclaim batching, while allowing the folio-error association for the
>      partial benefits provided by (2). As mentioned earlier, I can delete=
 this
>      in the next rev if the maintainers feel strongly about this.

Let's delete it, and focus on the low hanging fruit (large folio zswap stor=
ing).

> 2) int* error signature: benefit can be realized today due to the latency
>     optimization it enables from detecting errors early, localized cleanu=
p,
>     preventing unwinding state. That said, the same benefits can be reali=
zed
>     without making it a part of the interface.

This can be done in a separate patch/follow up. It's not related to this wo=
rk :)
