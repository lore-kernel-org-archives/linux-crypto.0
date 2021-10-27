Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D276AC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 18:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B52E861039
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 18:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243619AbhJ0SrM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Oct 2021 14:47:12 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:29212 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243621AbhJ0SrM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Oct 2021 14:47:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1635360285;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=iJJUNvnaI4SD3EiPwT/SnvetOfj6WMDqICrw5bq7uH8=;
    b=KTBdE7kAyOsyYb6WzdDEwfZ8zWsAC0/X3LNPg3h6+V6r7xc+Lvd7Lvym90iuGgtOvW
    vV3V6TwloI/GfSD1xrQSImze7v8vgV0SZoQdFKNjKuSgucJu2yUJq81GY+scnpjIbi0w
    MegMx/F+VUZO5bSQqyyQDHZ+JnLHDpkf3ZcLdjiPFaNADdVPteVLke2VYYO97Q6AhZ/q
    TNnon0JOglW9ZCd06YWBX1z0lIyl3KXCvUhLf+Af2zLhvdt1rTKIAQFxQHLwFhBkbEpY
    z9cmIUa6+0FjIPMZBqo56Yk038VEmr/jkyNjLP324xjva8VpcEpeoQiIIQTL8iCXsVjY
    Jw9w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xm0dNS3JdRcQGaevZhmp"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.34.1 DYNA|AUTH)
    with ESMTPSA id n020a8x9RIiiA1m
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 27 Oct 2021 20:44:44 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Nicolai Stange <nstange@suse.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolai Stange <nstange@suse.de>, Torsten Duwe <duwe@suse.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] crypto: DRBG - make reseeding from get_random_bytes() synchronous
Date:   Wed, 27 Oct 2021 20:44:44 +0200
Message-ID: <1961459.DM5OXT6fzB@positron.chronox.de>
In-Reply-To: <87sfwmrfih.fsf@suse.de>
References: <20211025092525.12805-1-nstange@suse.de> <7177269.TAkDSPn55A@positron.chronox.de> <87sfwmrfih.fsf@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Mittwoch, 27. Oktober 2021, 11:19:50 CEST schrieb Nicolai Stange:

Hi Nicolai,

> Hi Stephan,
>=20
> Stephan M=FCller <smueller@chronox.de> writes:
> > Am Montag, 25. Oktober 2021, 11:25:23 CEST schrieb Nicolai Stange:
> >> get_random_bytes() usually hasn't full entropy available by the time D=
RBG
> >> instances are first getting seeded from it during boot. Thus, the DRBG
> >> implementation registers random_ready_callbacks which would in turn
> >> schedule some work for reseeding the DRBGs once get_random_bytes() has
> >> sufficient entropy available.
> >>=20
> >> For reference, the relevant history around handling DRBG (re)seeding in
> >>=20
> >> the context of a not yet fully seeded get_random_bytes() is:
> >>   commit 16b369a91d0d ("random: Blocking API for accessing
> >>  =20
> >>                         nonblocking_pool")
> >>  =20
> >>   commit 4c7879907edd ("crypto: drbg - add async seeding operation")
> >>  =20
> >>   commit 205a525c3342 ("random: Add callback API for random pool
> >>  =20
> >>                         readiness")
> >>  =20
> >>   commit 57225e679788 ("crypto: drbg - Use callback API for random
> >>  =20
> >>                         readiness")
> >>  =20
> >>   commit c2719503f5e1 ("random: Remove kernel blocking API")
> >>=20
> >> However, some time later, the initialization state of get_random_bytes=
()
> >> has been made queryable via rng_is_initialized() introduced with commit
> >> 9a47249d444d ("random: Make crng state queryable"). This primitive now
> >> allows for streamlining the DRBG reseeding from get_random_bytes() by
> >> replacing that aforementioned asynchronous work scheduling from
> >> random_ready_callbacks with some simpler, synchronous code in
> >> drbg_generate() next to the related logic already present therein. Apa=
rt
> >> from improving overall code readability, this change will also enable
> >> DRBG
> >> users to rely on wait_for_random_bytes() for ensuring that the initial
> >> seeding has completed, if desired.
> >>=20
> >> The previous patches already laid the grounds by making drbg_seed() to
> >> record at each DRBG instance whether it was being seeded at a time when
> >> rng_is_initialized() still had been false as indicated by
> >> ->seeded =3D=3D DRBG_SEED_STATE_PARTIAL.
> >>=20
> >> All that remains to be done now is to make drbg_generate() check for t=
his
> >> condition, determine whether rng_is_initialized() has flipped to true =
in
> >> the meanwhile and invoke a reseed from get_random_bytes() if so.
> >>=20
> >> Make this move:
> >> - rename the former drbg_async_seed() work handler, i.e. the one in
> >> charge
> >>=20
> >>   of reseeding a DRBG instance from get_random_bytes(), to
> >>   "drbg_seed_from_random()",
> >>=20
> >> - change its signature as appropriate, i.e. make it take a struct
> >>=20
> >>   drbg_state rather than a work_struct and change its return type from
> >>   "void" to "int" in order to allow for passing error information from
> >>   e.g. its __drbg_seed() invocation onwards to callers,
> >>=20
> >> - make drbg_generate() invoke this drbg_seed_from_random() once it
> >>=20
> >>   encounters a DRBG instance with ->seeded =3D=3D DRBG_SEED_STATE_PART=
IAL by
> >>   the time rng_is_initialized() has flipped to true and
> >>=20
> >> - prune everything related to the former, random_ready_callback based
> >>=20
> >>   mechanism.
> >>=20
> >> As drbg_seed_from_random() is now getting invoked from drbg_generate()
> >> with
> >> the ->drbg_mutex being held, it must not attempt to recursively grab it
> >> once again. Remove the corresponding mutex operations from what is now
> >> drbg_seed_from_random(). Furthermore, as drbg_seed_from_random() can n=
ow
> >> report errors directly to its caller, there's no need for it to
> >> temporarily
> >> switch the DRBG's ->seeded state to DRBG_SEED_STATE_UNSEEDED so that a
> >> failure of the subsequently invoked __drbg_seed() will get signaled to
> >> drbg_generate(). Don't do it then.
> >=20
> > The code change in general looks good. But the code change seems to now
> > imply that the DRBG only gets fully seeded when its internal reseed
> > operation is invoked again - during boot time this is after the elapse =
of
> > 50 generate operations (or in your later patch after the elapse of 5
> > minutes). I.e. it is not immediately reseeded when random.c turns to
> > fully seeded and
> > rng_is_initialized() would turn true.
>=20
> I would argue that the DRBGs don't get immediately reseeded before this
> patch, because there's no guarantee on when the drbg_async_seed() work
> eventually gets to run.
>=20
> I.e. something like the following would be possible:
>=20
> 						wait_for_random_bytes() {
>   crng_reseed() {
>     crng_init =3D 2;
>     process_random_ready_list() {
>       drbg_schedule_async_seed();
>     }
>     wake_up_interruptible(&crng_init_wait);
>   }
> 						}
> 						crypto_rng_generate() {
> 						  drbg_generate();
> 						}
>   drbg_async_seed(); /* <-- too late */
>=20
>=20
> The wait_for_random_bytes() has been added only for demonstration
> purposes here, right now there aren't any DRBG users invoking it,
> AFAICT. Note that even in the presence of a hypothetical
> wait_for_random_bytes() barrier, it would still be possible for a
> subsequent drbg_generate() to run on a not yet reseeded DRBG.
>=20
> After this patch OTOH, the drbg_generate() would invoke a reseed by
> itself once it observes the crng_init =3D=3D 2, i.e. once
> rng_is_initialized() flips to true.
>=20
> So yes, you're right, the DRBGs don't get reseeded immediately once
> get_random_bytes() becomes ready, but more in a "lazy fashion" when
> accessed the next time. However, it's now guaranteed that
> drbg_generate() won't operate on a not yet updated DRBG state when
> rng_is_initialized() is true (at function entry).
>=20
> > So, the DRBG seems to run still
> > partially seeded even though it could already be fully seeded, no?
>=20
> Assuming that by "run" you mean drbg_generate(), then no, I don't think
> so. Or at least that has not been my intention and would be a bug in the
> patch. For reference, I'll mark the spot in the quoted code below which
> is supposed to make drbg_generate() reseed the DRGB once
> rng_is_initialized() has flipped to true.
>=20
> >> Signed-off-by: Nicolai Stange <nstange@suse.de>
> >> ---
> >>=20
> >>  crypto/drbg.c         | 64 +++++++++----------------------------------
> >>  include/crypto/drbg.h |  2 --
> >>  2 files changed, 13 insertions(+), 53 deletions(-)
> >>=20
> >> diff --git a/crypto/drbg.c b/crypto/drbg.c
> >> index 6aad210f101a..d9f7dddfd683 100644
> >> --- a/crypto/drbg.c
> >> +++ b/crypto/drbg.c
> >> @@ -1087,12 +1087,10 @@ static inline int drbg_get_random_bytes(struct
> >> drbg_state *drbg, return 0;
> >>=20
> >>  }
> >>=20
> >> -static void drbg_async_seed(struct work_struct *work)
> >> +static int drbg_seed_from_random(struct drbg_state *drbg)
> >>=20
> >>  {
> >> =20
> >>  	struct drbg_string data;
> >>  	LIST_HEAD(seedlist);
> >>=20
> >> -	struct drbg_state *drbg =3D container_of(work, struct drbg_state,
> >> -					       seed_work);
> >>=20
> >>  	unsigned int entropylen =3D drbg_sec_strength(drbg->core->flags);
> >>  	unsigned char entropy[32];
> >>  	int ret;
> >>=20
> >> @@ -1103,23 +1101,17 @@ static void drbg_async_seed(struct work_struct
> >> *work) drbg_string_fill(&data, entropy, entropylen);
> >>=20
> >>  	list_add_tail(&data.list, &seedlist);
> >>=20
> >> -	mutex_lock(&drbg->drbg_mutex);
> >> -
> >>=20
> >>  	ret =3D drbg_get_random_bytes(drbg, entropy, entropylen);
> >>  	if (ret)
> >>=20
> >> -		goto unlock;
> >> -
> >> -	/* Reset ->seeded so that if __drbg_seed fails the next
> >> -	 * generate call will trigger a reseed.
> >> -	 */
> >> -	drbg->seeded =3D DRBG_SEED_STATE_UNSEEDED;
> >> -
> >> -	__drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
> >> +		goto out;
> >>=20
> >> -unlock:
> >> -	mutex_unlock(&drbg->drbg_mutex);
> >> +	ret =3D __drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
> >> +	if (ret)
> >> +		goto out;
> >=20
> > Is this last check for ret truly needed considering the goto target is =
the
> > next line?
>=20
> Darn, no. I'll wait a few more days for further review and send a v2
> with this fixed up.
>=20
> >> +out:
> >>  	memzero_explicit(entropy, entropylen);
> >>=20
> >> +	return ret;
> >>=20
> >>  }
> >> =20
> >>  /*
> >>=20
> >> @@ -1422,6 +1414,11 @@ static int drbg_generate(struct drbg_state *drb=
g,
> >>=20
> >>  			goto err;
> >>  	=09
> >>  		/* 9.3.1 step 7.4 */
> >>  		addtl =3D NULL;
> >>=20
> >> +	} else if (rng_is_initialized() &&
> >> +		   drbg->seeded =3D=3D DRBG_SEED_STATE_PARTIAL) {
> >> +		len =3D drbg_seed_from_random(drbg);
> >> +		if (len)
> >> +			goto err;
> >>=20
> >>  	}
>=20
> As mentioned above, this here is the change that is supposed to make
> drbg_generate() reseed itself once rng_is_initialized() has flipped to
> true.

I agree with your explanation above and the description here. I have no=20
objections.

Thanks
Stephan
>=20
> Thanks,
>=20
> Nicolai
>=20
> >>  	if (addtl && 0 < addtl->len)
> >>=20
> >> @@ -1514,45 +1511,15 @@ static int drbg_generate_long(struct drbg_state
> >> *drbg, return 0;
> >>=20
> >>  }
> >>=20
> >> -static void drbg_schedule_async_seed(struct random_ready_callback *rd=
y)
> >> -{
> >> -	struct drbg_state *drbg =3D container_of(rdy, struct drbg_state,
> >> -					       random_ready);
> >> -
> >> -	schedule_work(&drbg->seed_work);
> >> -}
> >> -
> >>=20
> >>  static int drbg_prepare_hrng(struct drbg_state *drbg)
> >>  {
> >>=20
> >> -	int err;
> >> -
> >>=20
> >>  	/* We do not need an HRNG in test mode. */
> >>  	if (list_empty(&drbg->test_data.list))
> >>  =09
> >>  		return 0;
> >>  =09
> >>  	drbg->jent =3D crypto_alloc_rng("jitterentropy_rng", 0, 0);
> >>=20
> >> -	INIT_WORK(&drbg->seed_work, drbg_async_seed);
> >> -
> >> -	drbg->random_ready.owner =3D THIS_MODULE;
> >> -	drbg->random_ready.func =3D drbg_schedule_async_seed;
> >> -
> >> -	err =3D add_random_ready_callback(&drbg->random_ready);
> >> -
> >> -	switch (err) {
> >> -	case 0:
> >> -		break;
> >> -
> >> -	case -EALREADY:
> >> -		err =3D 0;
> >> -		fallthrough;
> >> -
> >> -	default:
> >> -		drbg->random_ready.func =3D NULL;
> >> -		return err;
> >> -	}
> >> -
> >> -	return err;
> >> +	return 0;
> >>=20
> >>  }
> >> =20
> >>  /*
> >>=20
> >> @@ -1646,11 +1613,6 @@ static int drbg_instantiate(struct drbg_state
> >> *drbg,
> >> struct drbg_string *pers, */
> >>=20
> >>  static int drbg_uninstantiate(struct drbg_state *drbg)
> >>  {
> >>=20
> >> -	if (drbg->random_ready.func) {
> >> -		del_random_ready_callback(&drbg->random_ready);
> >> -		cancel_work_sync(&drbg->seed_work);
> >> -	}
> >> -
> >>=20
> >>  	if (!IS_ERR_OR_NULL(drbg->jent))
> >>  =09
> >>  		crypto_free_rng(drbg->jent);
> >>  =09
> >>  	drbg->jent =3D NULL;
> >>=20
> >> diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
> >> index 3ebdb1effe74..a6c3b8e7deb6 100644
> >> --- a/include/crypto/drbg.h
> >> +++ b/include/crypto/drbg.h
> >> @@ -137,12 +137,10 @@ struct drbg_state {
> >>=20
> >>  	bool pr;		/* Prediction resistance enabled? */
> >>  	bool fips_primed;	/* Continuous test primed? */
> >>  	unsigned char *prev;	/* FIPS 140-2 continuous test value */
> >>=20
> >> -	struct work_struct seed_work;	/* asynchronous seeding support */
> >>=20
> >>  	struct crypto_rng *jent;
> >>  	const struct drbg_state_ops *d_ops;
> >>  	const struct drbg_core *core;
> >>  	struct drbg_string test_data;
> >>=20
> >> -	struct random_ready_callback random_ready;
> >>=20
> >>  };
> >> =20
> >>  static inline __u8 drbg_statelen(struct drbg_state *drbg)


Ciao
Stephan


