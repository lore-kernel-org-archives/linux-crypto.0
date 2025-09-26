Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EE716EB42;
	Fri, 26 Sep 2025 00:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758846594; cv=none; b=kwPKDhzckFmkTilMVm3T0QFdCQpCL1piU0JGVKeuRB3sU/PHSfroW8iQo418dpA3H6IAKq0nP4rL6EFtJJkR1Pz+qAmeOa4sCfzi/UwLw0IOr+s8lIATa80kTo/QFkd4O5QnYFWcSca/LqBCm5qbgL+QF4XXuRrSanIgz44istQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758846594; c=relaxed/simple;
	bh=/XC/zVahOCmX58ZQZyzDamIZmL+2Kqqkp1WbuCPrboM=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=TIpqCyG/ogN0sT+WYPzoP31X43F1RTJjboPrXAMUnUFlcEL3alYJgzvtpzRQq7vxI2yKO1HtEikD4UaACO7ME02coasit5/QY1Y/VR2ntg7T4H3qjzrSepsAcyAyta7vMQVd9QDflo9MZ0/LB90Fh3wh0DJ2UJLqwkA4b/0SNjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=jF4cl3BW; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ReaOi6cO; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="jF4cl3BW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ReaOi6cO"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 35E0A140003A;
	Thu, 25 Sep 2025 20:29:51 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 25 Sep 2025 20:29:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm1; t=
	1758846591; x=1758932991; bh=+ExJ1KwuEBUexf1wy3yJQZtCOsWWucCcThP
	Bo+hTlZo=; b=jF4cl3BWFu4NEY5YLWKb+ygOHD9dskIagifgVedEMQSaiLYeIfL
	LIQQYRxblmlYTHA42792JRrFQ2hyTI0VnU28iSPyCp7gTRzXWwP+11ihpvfIc73v
	DPeuT/eKTWXbH4s+jycSxggH+hd8HT8KtPiLHAZ2XgyumZXlsHfTzbDQDfJ31gcv
	MBa572uECk8KMQhbjvYIkdQQo1Cw7LJ4LKCUTlmxYafSKhxdrDbTtEr8bsRuF4dF
	ujCSVtxUchpahkFbHPJF5z0qre4LlFIwYgnDEBWbQzazStMAQ8YcuCvtlj+8QBAI
	jeCC9IWUsqsDCUtVGg+Z5JUgHaOF9ksXZGQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1758846591; x=
	1758932991; bh=+ExJ1KwuEBUexf1wy3yJQZtCOsWWucCcThPBo+hTlZo=; b=R
	eaOi6cOlVc9n3gpqZypLCcMK2RnONTjCryKg6uOHrnR2cI3oltqpbhe3fl2UJCBk
	USNpctAf5OcCsPecSkmGlPnXOJHbMmdRSzd27y5LVH0P5GoCXHeKkEV69FnCu+Bl
	pzPtyVdBb23mPboZnGOcXIySYwa4rmK6AUdbToh4Xab5FqdjTDIFdxGaQRFwQF3v
	TKUQuUdE55Va+yNqqxuA4sKY7M+LKFTAKz0WML2jWSnrJ63QLugpbHckOYHQ/tAh
	sDQTpQck6x8R1D3xvee7LU1WxoCFxUl3d7Sq/eqxNDMh48XhE/2wDH1oGcTZfCZ4
	a47xAd19ZHuSvA9nOHypw==
X-ME-Sender: <xms:fd7VaMwxiwKpmSY1i9sUTerfzhJsZBEV02KooEpPcvIlpmFRM7cUrA>
    <xme:fd7VaD-9guvUJXUV1jlzWJye8kUJ9fAXV9AzwiGA93BdMxr1Moy91mGBy1jYEinyf
    A2e1hEeyVb9tipo0luDaH3bG4H0MWhbyESWGDdFp-5SxT_kFw>
X-ME-Received: <xmr:fd7VaIKIiB2rpvdRxb7op0XKjnPxNH71zT3PXv2dT8bNuoN50gq2p_IAeXVOF9LBFrnBxmUvxNv5x2df7Nb-okgv58KnWPaZrYBSqUfFXLHD>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeijeelfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpegtgfgghffvvefujghffffkrhesthhqredttddtjeenucfhrhhomheppfgvihhluehr
    ohifnhcuoehnvghilhgssehofihnmhgrihhlrdhnvghtqeenucggtffrrghtthgvrhhnpe
    eljedtfeegueekieetudevheduveefffevudetgfetudfhgedvgfdtieeguedujeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehnvghilhgsse
    hofihnmhgrihhlrdhnvghtpdhnsggprhgtphhtthhopeehpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehlihhnuhigqdgtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehtghhrrghfsehsuhhughdrtghhpdhrtghpthhtohephhgvrh
    gsvghrthesghhonhguohhrrdgrphgrnhgrrdhorhhgrdgruhdprhgtphhtthhopehmvghn
    ghhlohhnghekrdguohhnghesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:fd7VaBdbjLUotxXObVheAFspZfnDP6IBhveZBps5Cbyb7qmJsdV33w>
    <xmx:fd7VaP9BQ7iGFbSyMxTjgfnzqyFnM6hpLWn4-vAZ1PquyfCPObgAoQ>
    <xmx:fd7VaGpSMmolkP-7IotOT5x3SxLzVAHYzxugf0y7mDMDwZrYK7bVZA>
    <xmx:fd7VaMDJOGFnnf59gRS4k2siPXdqDlcs7J7mmnrNEpGTqop3sPlB5w>
    <xmx:f97VaHZoJzeWmAUAErRB557D_7SgaXMLDM3XON-k2MkgL1k5WvmFPcQg>
Feedback-ID: iab3e480c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 25 Sep 2025 20:29:47 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Menglong Dong" <menglong8.dong@gmail.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, tgraf@suug.ch,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rhashtable: add likely() to __rht_ptr()
In-reply-to:
 <CADxym3ZA7FsdeA3zz34V7mHHjBC358UoJjrpV6wieZ1LF2aFxA@mail.gmail.com>
References: <20250923060614.539789-1-dongml2@chinatelecom.cn>,
 <aNI_-QHAzwrED-iX@gondor.apana.org.au>,
 <CADxym3YMX063-9S7ZgdMH9PPjmRXj9WG0sesn_och5G+js-P9A@mail.gmail.com>,
 <175862707333.1696783.11988392990379659217@noble.neil.brown.name>,
 <CADxym3ZA7FsdeA3zz34V7mHHjBC358UoJjrpV6wieZ1LF2aFxA@mail.gmail.com>
Date: Fri, 26 Sep 2025 10:29:46 +1000
Message-id: <175884658630.1696783.7712739490823387474@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Wed, 24 Sep 2025, Menglong Dong wrote:
> On Tue, Sep 23, 2025 at 7:31=E2=80=AFPM NeilBrown <neilb@ownmail.net> wrote:
> >
> > On Tue, 23 Sep 2025, Menglong Dong wrote:
> > > On Tue, Sep 23, 2025 at 2:36=E2=80=AFPM Herbert Xu <herbert@gondor.apan=
a.org.au> wrote:
> > > >
> > > > Menglong Dong <menglong8.dong@gmail.com> wrote:
> > > > > In the fast path, the value of "p" in __rht_ptr() should be valid.
> > > > > Therefore, wrap it with a "likely". The performance increasing is t=
iny,
> > > > > but it's still worth to do it.
> > > > >
> > > > > Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
> > > > > ---
> > > > > include/linux/rhashtable.h | 5 +++--
> > > > > 1 file changed, 3 insertions(+), 2 deletions(-)
> > > >
> > > > It's not obvious that rht_ptr would be non-NULL.  It depends on the
> > > > work load.  For example, if you're doing a lookup where most keys
> > > > are non-existent then it would most likely be NULL.
> > >
> > > Yeah, I see. In my case, the usage of the rhashtable will be:
> > > add -> lookup, and rht_ptr is alway non-NULL. You are right,
> > > it can be NULL in other situations, and it's not a good idea to
> > > use likely() here ;)
> >
> > Have you measured a performance increase?  How tiny is it?
> >
> > It might conceivably make sense to have a rhashtable_lookup_likely() and
> > rhashtable_lookup_unlikely(), but concrete evidence of the benefit would
> > be needed.
>=20
> I made a more accurate bench testing:  call the rhashtable_lookup()
> 100000000 times.
>=20
> Without the likely(), it cost  123697645ns. And with the likely(), only
> 84507668ns.

a 30% speedup is impressive, even though it is a micro-benchmark.

>=20
> I add the likely() not only to the __rht_ptr(), but also rht_for_each_rcu_f=
rom()
> and rhashtable_lookup().

I suggest you create a patch which adds rhashtable_lookup_likely(),
__rhashtable_lookup_likely(), rht_for_each_rcu_from_likely(),=20
rht_ptr_rcu_likely() etc.
So that no existing code changes, but the new function uses likely
everywhere that you think is important.

I had a bit of a look at callers of rhashtable_lookup().  Some return
-EEXIST if they find something. Other return -ENOENT if they don't.
Using rhasthable_lookup_likely() for those that return -ENOENT probably
makes sense.

Thanks,
NeilBrown


>=20
> Below is the part code of the testing:
>=20
>     for (i =3D 0; i < num_elems; i++) {
>         objs[i] =3D kmalloc(sizeof(**objs), GFP_KERNEL);
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, objs[i]);
>         objs[i]->key =3D i;
>         INIT_RHT_NULLS_HEAD(objs[i]->node.next);
>         ret =3D rhashtable_insert_fast(&ht, &objs[i]->node, bench_params);
>         KUNIT_ASSERT_EQ(test, ret, 0);
>     }
>=20
>     /* for CPU warm up */
>     for (i =3D 0; i < 1000000000; i++) {
>         u32 key =3D 0;
>         struct bench_obj *found;
>=20
>         found =3D rhashtable_lookup(&ht, &key, bench_params);
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, found);
>         KUNIT_ASSERT_EQ(test, found->key, key);
>     }
>=20
>     rcu_read_lock();
>     t0 =3D ktime_get();
>     for (i =3D 0; i < 100000000; i++) {
>         u32 key =3D 0;
>         struct bench_obj *found;
>=20
>         found =3D rhashtable_lookup(&ht, &key, bench_params);
>         if (unlikely(!found)) {
>             pr_info("error!\n");
>             break;
>         }
>     }
>     t1 =3D ktime_get();
>     rcu_read_unlock();
>=20
> >
> > Thanks,
> > NeilBrown
>=20

