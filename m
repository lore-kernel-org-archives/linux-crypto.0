Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [176.9.242.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8643D6F;
	Sat, 20 Sep 2025 12:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.9.242.62
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758372473; cv=none; b=WLXptzAFgOE2BjX/o/UoS32NbajIQOW/gVvzgVKKk3T22E+BAL4/9F0Iu/6WsWH5JIEptOSusAlhIsSPx85nLH/k2zInZroeviHmGjVPY/YZyyfzGR4HJ80H4MD7I67mvVxs7Re+eF9yhklbTWAQJZz+UASxhZ/Td4eQBZ5mnVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758372473; c=relaxed/simple;
	bh=rUIgjqaHNOc+FdBJons8gNaDwdujH/lsR2saMqvJhvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TLZhzARuUAhN20pYIhQXwgJ00+HHvcfhXD7ms84mb45gPmvfAAc/RbDODUsl2uBeK5O55WKZRhC7CqZx9E/zXcQq3GLHZ9bBt5sLUTf63/g1nUYWx0DxNOYZgUQDByVa8bLwljgWOMp/eSnfraFQfRUlm83OXZ2oYl5GYmPPGxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=176.9.242.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout3.hostsharing.net (Postfix) with ESMTPS id 08EC22C051DD;
	Sat, 20 Sep 2025 14:47:41 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id C3C4E5D31C; Sat, 20 Sep 2025 14:47:40 +0200 (CEST)
Date: Sat, 20 Sep 2025 14:47:40 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Alexander Potapenko <glider@google.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
	Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com,
	andreyknvl@gmail.com, andy@kernel.org, brauner@kernel.org,
	brendan.higgins@linux.dev, davem@davemloft.net, davidgow@google.com,
	dhowells@redhat.com, dvyukov@google.com, elver@google.com,
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz,
	jannh@google.com, johannes@sipsolutions.net,
	kasan-dev@googlegroups.com, kees@kernel.org,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, rmoar@google.com,
	shuah@kernel.org, sj@kernel.org, tarasmadan@google.com
Subject: Re: [PATCH v2 08/10] drivers/auxdisplay: add a KFuzzTest for
 parse_xy()
Message-ID: <aM6ibO75IidHOO3m@wunner.de>
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
 <20250919145750.3448393-9-ethan.w.s.graham@gmail.com>
 <CAHp75VdyZudJkskL0E9DEzYXgFeUwCBEwXEVUMuKSx0R9NUxmQ@mail.gmail.com>
 <CAG_fn=XTcPrsgxg+MpFqnj9t2OoYa=SF1ts8odHFaMqD+YpZ_w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG_fn=XTcPrsgxg+MpFqnj9t2OoYa=SF1ts8odHFaMqD+YpZ_w@mail.gmail.com>

On Sat, Sep 20, 2025 at 02:08:01PM +0200, Alexander Potapenko wrote:
> On Sat, Sep 20, 2025 at 12:54 PM Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> > On Fri, Sep 19, 2025 at 5:58 PM Ethan Graham <ethan.w.s.graham@gmail.com> wrote:
> > > +++ b/drivers/auxdisplay/charlcd.c
> > > @@ -682,3 +682,11 @@ EXPORT_SYMBOL_GPL(charlcd_unregister);
> > >
> > >  MODULE_DESCRIPTION("Character LCD core support");
> > >  MODULE_LICENSE("GPL");
> > > +
> > > +/*
> > > + * When CONFIG_KFUZZTEST is enabled, we include this _kfuzz.c file to ensure
> > > + * that KFuzzTest targets are built.
> > > + */
> > > +#ifdef CONFIG_KFUZZTEST
> > > +#include "tests/charlcd_kfuzz.c"
> > > +#endif /* CONFIG_KFUZZTEST */
> >
> > No, NAK. We don't want to see these in each and every module. Please,
> > make sure that nothing, except maybe Kconfig, is modified in this
> > folder (yet, you may add a _separate_ test module, as you already have
> > done in this patch).
> 
> This is one of the cases in which we can't go without changing the
> original code, because parse_xy() is a static function.
> Including the test into the source is not the only option, we could as
> well make the function visible unconditionally, or introduce a macro
> similar to VISIBLE_IF_KUNIT.
> Do you prefer any of those?

Just add something like this to drivers/auxdisplay/Makefile:

ifeq ($(CONFIG_KFUZZTEST),y)
CFLAGS_charlcd.o := -include $(src)/tests/charlcd_kfuzz.c
endif

Alternatively, if the file in tests/ always has the same name
as the source file but with "_kfuzz.c" suffix, consider amending
scripts/Makefile.build to always include the "_kfuzz.c" file
if it exists and CONFIG_KFUZZTEST=y, thus avoiding the need
to amend all the individual Makefiles in the tree.

Thanks,

Lukas
