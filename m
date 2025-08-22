Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9534F1D5174;
	Fri, 22 Aug 2025 21:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755899322; cv=none; b=pXSkEZJOk+pZxOaDrQlt6fKJrkiXYNPVNYjD1VJD5grzFVRtEmKx6PD9+s89Cjk7fsJyloVh1xxy5+ajwgYvVT8GuqX7SCe6TeIAJ97u03qHruPIpXUMtiKx50lz2dX/2pV6P4jpi7CE3n/TxrKfgdSr4AAcLNXI77anS2c+Hz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755899322; c=relaxed/simple;
	bh=mMWcltJn2QYRWZ4InLR+7kan5cJpSrR1RP1DgdLIhXQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ewBpkDXU7KRfDkQ0ESpMKLIHgt+aa8at9LbU3gWw49MOdI54W3k5BM3USrzcTmjNtGMWfeN+89MmOkaiMVBP5hu6UsgZ4lvmhxLmxOzzCG36e33tO9MU1VDDl+6OoAdGdPqtnzLvImWJdtK0iAnqMDhcnSYKkLh26RJBPZkoSPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F4R/egQr; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F4R/egQr"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3e67e6a1cc8so14156325ab.1;
        Fri, 22 Aug 2025 14:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755899318; x=1756504118; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KAIEX27cljqcvEISCgHpGYN/71b+wZUhIVArwfYHUjE=;
        b=F4R/egQrRaXrI5vzKEVKI5s3QzgFPcgDjzSLoWJWa31j04pQAoFajO1GQARRO1MydN
         zYioP5acrOrkFe70HIpAsV0jq4OzKh1DSqmudp0+qaNOjRmWGJE3sKQJEQjt/MY9QHrh
         eUCbpgNguoQtXyQDD2ahE0bWMcRerU69t6rnK2ZxWSOH70dEYsK7EGXTBLgvOw7DShwu
         SGBIsyaf7+J6ShO0KZ88gGvz6seTK2CqloKVEVb8KFbiy17gd440ZXhiYQ+h2PXCtCbr
         tft3LswU+/Bq9rxAvBKg2OFcPRCBoc7+m0rlsPNYxX7cAfHITkwYQDvgEqDCsIxzFZZG
         +qcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755899319; x=1756504119;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KAIEX27cljqcvEISCgHpGYN/71b+wZUhIVArwfYHUjE=;
        b=KE2capO7U721Oq9reVEQkb6Q0lT09SRKJz/PQ9KynHHjo6bLGEojD2ohmG1IHl4Del
         mfo3jmB3+xdYyWplW2Vm5tNtz2sjlz0aNbcp5Nt+gFcp3e6tkdbvocS04Nj/q9VCNpZs
         NjuqFIlPKIMZ78ne/1vm2rGsSiAyfslIvaI5JiFwtsrUsV8XwLJ8m5vdTtoNuJxr85DJ
         Plc/KBYAaU2ao5UMugOFkkiOt2Mzm6ef0CBosVhy4gzvlFjJnuGLoQHqqiAuQczgprEo
         MnPHaijq9vUYO8WOi6yHcdNYW/oQ4956ujSR3VuEUQPv+kRzKv9Lnfbs43zhSE2qZfp5
         qvAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUamLaUdd3grl7JkFAqkWaIhb4GWLhOMqEibBKiUcqIR7CXT6SKHNdssMQfjxvzxK7hfod4ffh1s2apdPsD@vger.kernel.org, AJvYcCW7ghglTtovqpbrZHUmllrXWYEx50QljZhfBz143M0kXNnhH2HhIJfukgvF7uJCdbO7SSYM9s3XE6LK6GM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNoE96h5Fa4q8zNVPbP2Yvj9X/L/xK1TpSPWgeMPRlFbpihoRv
	frMBnNkWG16DNMhaeZI4tB2UyNLSQzCpBsZn5f/EVE//2uZQlYDzdkKZTI7XknvyFU0qdwDihMc
	R2G5iniyxwt+LEu85OHP8Px26Jn9t5ao=
X-Gm-Gg: ASbGnctyplrQqBTZLSdPMy5ScNAJfUwFWXmV82H9nsNgBjugSrQQzXcnuoml3+BMJ9Y
	hX7njflgyVLbbxoojrg7qzS3SzZSl3W4Y3D4xKcsyq9viecxMWuSci9sckZtJ2ze8d12+wD7rSB
	D/1lIK9vfAc3+PaqQx+26DxgyS3AhKKD2HqMM843YD7AAtrR+eMMo9kLxBTWbMWHLQvXY0Qg3rq
	22f8Es=
X-Google-Smtp-Source: AGHT+IFfbgSDdnSYcbN+8LjYRoerwSuYliGkWYiz8XOJtJi017qiYSnfomfKss31HGiJ8+cI3oMP28PIFron2nX1K9I=
X-Received: by 2002:a05:6e02:1d89:b0:3e5:41a2:d71f with SMTP id
 e9e14a558f8ab-3e921a5c909mr68305415ab.14.1755899318504; Fri, 22 Aug 2025
 14:48:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-19-kanchana.p.sridhar@intel.com> <aJ7Fk6RpNc815Ivd@gondor.apana.org.au>
 <PH7PR11MB81210ABFD0BF9F73214080E8C93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB81210ABFD0BF9F73214080E8C93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 22 Aug 2025 14:48:27 -0700
X-Gm-Features: Ac12FXzqUx4hJnuCRyNUz_zHahXkhP9hKAQsHKGI5_cWZzqkZgjo1ddcP3KfUPk
Message-ID: <CAKEwX=M2HCsPZVmXpvpAuF2N=4BXbXAMQMrLLRp7nCdotb=abA@mail.gmail.com>
Subject: Re: [PATCH v11 18/24] crypto: acomp - Add crypto_acomp_batch_size()
 to get an algorithm's batch-size.
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 22, 2025 at 12:31=E2=80=AFPM Sridhar, Kanchana P
<kanchana.p.sridhar@intel.com> wrote:
>
>
> > -----Original Message-----
> > From: Herbert Xu <herbert@gondor.apana.org.au>
> > Sent: Thursday, August 14, 2025 10:29 PM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; yosry.ahmed@linux.dev; nphamcs@gmail.com;
> > chengming.zhou@linux.dev; usamaarif642@gmail.com;
> > ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > senozhatsky@chromium.org; linux-crypto@vger.kernel.org;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.co=
m>;
> > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v11 18/24] crypto: acomp - Add
> > crypto_acomp_batch_size() to get an algorithm's batch-size.
> >
> > On Thu, Jul 31, 2025 at 09:36:36PM -0700, Kanchana P Sridhar wrote:
> > >
> > > diff --git a/include/crypto/internal/acompress.h
> > b/include/crypto/internal/acompress.h
> > > index ffffd88bbbad3..2325ee18e7a10 100644
> > > --- a/include/crypto/internal/acompress.h
> > > +++ b/include/crypto/internal/acompress.h
> > > @@ -28,6 +28,8 @@
> > >   *
> > >   * @compress:      Function performs a compress operation
> > >   * @decompress:    Function performs a de-compress operation
> > > + * @get_batch_size:        Maximum batch-size for batching
> > compress/decompress
> > > + *                 operations.
> > >   * @init:  Initialize the cryptographic transformation object.
> > >   *         This function is used to initialize the cryptographic
> > >   *         transformation object. This function is called only once =
at
> > > @@ -46,6 +48,7 @@
> > >  struct acomp_alg {
> > >     int (*compress)(struct acomp_req *req);
> > >     int (*decompress)(struct acomp_req *req);
> > > +   unsigned int (*get_batch_size)(void);
> >
> > I can't imagine a situation where this needs to be dynamic.
> > Please just make it a static value rather than a callback function.
>
> Hi Herbert,
>
> I am not sure I understand.. Kernel users such as zswap/zram need to quer=
y
> the algorithm to get the maximum supported batch-size so they can allocat=
e
> resources for dst buffers. The get_batch_size() callback and associated
> crypto_acomp_batch_size() wrapper help accomplish this.

I think he meant stored it as a static unsigned int field, rather than
a function pointer (i.e dynamic) like this.

Does batch size ever change at runtime?
