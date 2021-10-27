Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E30C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 09:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93D8560F56
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 09:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239675AbhJ0JWR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Oct 2021 05:22:17 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36066 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237410AbhJ0JWR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Oct 2021 05:22:17 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 249261FD40;
        Wed, 27 Oct 2021 09:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635326391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bhPjQBYSV2VM2z8yOyLJlYYa+eovsDUd19YVoXMsB/Y=;
        b=T1LkRo8y3uNfqIA8fPIIC69CtVMRDyW2wk7aTrAw/oW4kwGMaZg1t39oyF8VjLaKEUfqdi
        UPzdSn0zyTECSNYZOSP+5QNUvMVsrTkgf4BRsen9x16eHCHVHpZiHnPgCIK2pjsd9IY+jx
        FJQ2nt71O/XnW+h9MzN4lptCDSs18dQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635326391;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bhPjQBYSV2VM2z8yOyLJlYYa+eovsDUd19YVoXMsB/Y=;
        b=zFrHNO0EYnQZ9QOQ4GAccV3ZLnzy3XLWCTGhLjxqR687pTni4kv6Xa7vx3kqQ31DVI/3IP
        N5iHvMl79hbdTgDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D382813B69;
        Wed, 27 Oct 2021 09:19:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SfLtMbYZeWESJwAAMHmgww
        (envelope-from <nstange@suse.de>); Wed, 27 Oct 2021 09:19:50 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolai Stange <nstange@suse.de>, Torsten Duwe <duwe@suse.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] crypto: DRBG - make reseeding from get_random_bytes() synchronous
References: <20211025092525.12805-1-nstange@suse.de>
        <20211025092525.12805-5-nstange@suse.de>
        <7177269.TAkDSPn55A@positron.chronox.de>
Date:   Wed, 27 Oct 2021 11:19:50 +0200
In-Reply-To: <7177269.TAkDSPn55A@positron.chronox.de> ("Stephan
 \=\?utf-8\?Q\?M\=C3\=BCller\=22's\?\=
        message of "Tue, 26 Oct 2021 11:19:14 +0200")
Message-ID: <87sfwmrfih.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

Stephan M=C3=BCller <smueller@chronox.de> writes:

> Am Montag, 25. Oktober 2021, 11:25:23 CEST schrieb Nicolai Stange:
>
>> get_random_bytes() usually hasn't full entropy available by the time DRBG
>> instances are first getting seeded from it during boot. Thus, the DRBG
>> implementation registers random_ready_callbacks which would in turn
>> schedule some work for reseeding the DRBGs once get_random_bytes() has
>> sufficient entropy available.
>>=20
>> For reference, the relevant history around handling DRBG (re)seeding in
>> the context of a not yet fully seeded get_random_bytes() is:
>>=20
>>   commit 16b369a91d0d ("random: Blocking API for accessing
>>                         nonblocking_pool")
>>   commit 4c7879907edd ("crypto: drbg - add async seeding operation")
>>=20
>>   commit 205a525c3342 ("random: Add callback API for random pool
>>                         readiness")
>>   commit 57225e679788 ("crypto: drbg - Use callback API for random
>>                         readiness")
>>   commit c2719503f5e1 ("random: Remove kernel blocking API")
>>=20
>> However, some time later, the initialization state of get_random_bytes()
>> has been made queryable via rng_is_initialized() introduced with commit
>> 9a47249d444d ("random: Make crng state queryable"). This primitive now
>> allows for streamlining the DRBG reseeding from get_random_bytes() by
>> replacing that aforementioned asynchronous work scheduling from
>> random_ready_callbacks with some simpler, synchronous code in
>> drbg_generate() next to the related logic already present therein. Apart
>> from improving overall code readability, this change will also enable DR=
BG
>> users to rely on wait_for_random_bytes() for ensuring that the initial
>> seeding has completed, if desired.
>>=20
>> The previous patches already laid the grounds by making drbg_seed() to
>> record at each DRBG instance whether it was being seeded at a time when
>> rng_is_initialized() still had been false as indicated by
>> ->seeded =3D=3D DRBG_SEED_STATE_PARTIAL.
>>=20
>> All that remains to be done now is to make drbg_generate() check for this
>> condition, determine whether rng_is_initialized() has flipped to true in
>> the meanwhile and invoke a reseed from get_random_bytes() if so.
>>=20
>> Make this move:
>> - rename the former drbg_async_seed() work handler, i.e. the one in char=
ge
>>   of reseeding a DRBG instance from get_random_bytes(), to
>>   "drbg_seed_from_random()",
>> - change its signature as appropriate, i.e. make it take a struct
>>   drbg_state rather than a work_struct and change its return type from
>>   "void" to "int" in order to allow for passing error information from
>>   e.g. its __drbg_seed() invocation onwards to callers,
>> - make drbg_generate() invoke this drbg_seed_from_random() once it
>>   encounters a DRBG instance with ->seeded =3D=3D DRBG_SEED_STATE_PARTIA=
L by
>>   the time rng_is_initialized() has flipped to true and
>> - prune everything related to the former, random_ready_callback based
>>   mechanism.
>>=20
>> As drbg_seed_from_random() is now getting invoked from drbg_generate() w=
ith
>> the ->drbg_mutex being held, it must not attempt to recursively grab it
>> once again. Remove the corresponding mutex operations from what is now
>> drbg_seed_from_random(). Furthermore, as drbg_seed_from_random() can now
>> report errors directly to its caller, there's no need for it to temporar=
ily
>> switch the DRBG's ->seeded state to DRBG_SEED_STATE_UNSEEDED so that a
>> failure of the subsequently invoked __drbg_seed() will get signaled to
>> drbg_generate(). Don't do it then.
>
> The code change in general looks good. But the code change seems to now i=
mply=20
> that the DRBG only gets fully seeded when its internal reseed operation i=
s=20
> invoked again - during boot time this is after the elapse of 50 generate=
=20
> operations (or in your later patch after the elapse of 5 minutes). I.e. i=
t is=20
> not immediately reseeded when random.c turns to fully seeded and=20
> rng_is_initialized() would turn true.

I would argue that the DRBGs don't get immediately reseeded before this
patch, because there's no guarantee on when the drbg_async_seed() work
eventually gets to run.

I.e. something like the following would be possible:

						wait_for_random_bytes() {
  crng_reseed() {
    crng_init =3D 2;
    process_random_ready_list() {
      drbg_schedule_async_seed();
    }
    wake_up_interruptible(&crng_init_wait);
  }
						}
						crypto_rng_generate() {
						  drbg_generate();
						}
  drbg_async_seed(); /* <-- too late */


The wait_for_random_bytes() has been added only for demonstration
purposes here, right now there aren't any DRBG users invoking it,
AFAICT. Note that even in the presence of a hypothetical
wait_for_random_bytes() barrier, it would still be possible for a
subsequent drbg_generate() to run on a not yet reseeded DRBG.

After this patch OTOH, the drbg_generate() would invoke a reseed by
itself once it observes the crng_init =3D=3D 2, i.e. once
rng_is_initialized() flips to true.

So yes, you're right, the DRBGs don't get reseeded immediately once
get_random_bytes() becomes ready, but more in a "lazy fashion" when
accessed the next time. However, it's now guaranteed that
drbg_generate() won't operate on a not yet updated DRBG state when
rng_is_initialized() is true (at function entry).

> So, the DRBG seems to run still=20
> partially seeded even though it could already be fully seeded, no?

Assuming that by "run" you mean drbg_generate(), then no, I don't think
so. Or at least that has not been my intention and would be a bug in the
patch. For reference, I'll mark the spot in the quoted code below which
is supposed to make drbg_generate() reseed the DRGB once
rng_is_initialized() has flipped to true.


>>=20
>> Signed-off-by: Nicolai Stange <nstange@suse.de>
>> ---
>>  crypto/drbg.c         | 64 +++++++++----------------------------------
>>  include/crypto/drbg.h |  2 --
>>  2 files changed, 13 insertions(+), 53 deletions(-)
>>=20
>> diff --git a/crypto/drbg.c b/crypto/drbg.c
>> index 6aad210f101a..d9f7dddfd683 100644
>> --- a/crypto/drbg.c
>> +++ b/crypto/drbg.c
>> @@ -1087,12 +1087,10 @@ static inline int drbg_get_random_bytes(struct
>> drbg_state *drbg, return 0;
>>  }
>>=20
>> -static void drbg_async_seed(struct work_struct *work)
>> +static int drbg_seed_from_random(struct drbg_state *drbg)
>>  {
>>  	struct drbg_string data;
>>  	LIST_HEAD(seedlist);
>> -	struct drbg_state *drbg =3D container_of(work, struct drbg_state,
>> -					       seed_work);
>>  	unsigned int entropylen =3D drbg_sec_strength(drbg->core->flags);
>>  	unsigned char entropy[32];
>>  	int ret;
>> @@ -1103,23 +1101,17 @@ static void drbg_async_seed(struct work_struct
>> *work) drbg_string_fill(&data, entropy, entropylen);
>>  	list_add_tail(&data.list, &seedlist);
>>=20
>> -	mutex_lock(&drbg->drbg_mutex);
>> -
>>  	ret =3D drbg_get_random_bytes(drbg, entropy, entropylen);
>>  	if (ret)
>> -		goto unlock;
>> -
>> -	/* Reset ->seeded so that if __drbg_seed fails the next
>> -	 * generate call will trigger a reseed.
>> -	 */
>> -	drbg->seeded =3D DRBG_SEED_STATE_UNSEEDED;
>> -
>> -	__drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
>> +		goto out;
>>=20
>> -unlock:
>> -	mutex_unlock(&drbg->drbg_mutex);
>> +	ret =3D __drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
>> +	if (ret)
>> +		goto out;
>
> Is this last check for ret truly needed considering the goto target is th=
e=20
> next line?

Darn, no. I'll wait a few more days for further review and send a v2
with this fixed up.


>> +out:
>>  	memzero_explicit(entropy, entropylen);
>> +	return ret;
>>  }
>>=20
>>  /*
>> @@ -1422,6 +1414,11 @@ static int drbg_generate(struct drbg_state *drbg,
>>  			goto err;
>>  		/* 9.3.1 step 7.4 */
>>  		addtl =3D NULL;
>> +	} else if (rng_is_initialized() &&
>> +		   drbg->seeded =3D=3D DRBG_SEED_STATE_PARTIAL) {
>> +		len =3D drbg_seed_from_random(drbg);
>> +		if (len)
>> +			goto err;
>>  	}

As mentioned above, this here is the change that is supposed to make
drbg_generate() reseed itself once rng_is_initialized() has flipped to
true.

Thanks,

Nicolai


>>=20
>>  	if (addtl && 0 < addtl->len)
>> @@ -1514,45 +1511,15 @@ static int drbg_generate_long(struct drbg_state
>> *drbg, return 0;
>>  }
>>=20
>> -static void drbg_schedule_async_seed(struct random_ready_callback *rdy)
>> -{
>> -	struct drbg_state *drbg =3D container_of(rdy, struct drbg_state,
>> -					       random_ready);
>> -
>> -	schedule_work(&drbg->seed_work);
>> -}
>> -
>>  static int drbg_prepare_hrng(struct drbg_state *drbg)
>>  {
>> -	int err;
>> -
>>  	/* We do not need an HRNG in test mode. */
>>  	if (list_empty(&drbg->test_data.list))
>>  		return 0;
>>=20
>>  	drbg->jent =3D crypto_alloc_rng("jitterentropy_rng", 0, 0);
>>=20
>> -	INIT_WORK(&drbg->seed_work, drbg_async_seed);
>> -
>> -	drbg->random_ready.owner =3D THIS_MODULE;
>> -	drbg->random_ready.func =3D drbg_schedule_async_seed;
>> -
>> -	err =3D add_random_ready_callback(&drbg->random_ready);
>> -
>> -	switch (err) {
>> -	case 0:
>> -		break;
>> -
>> -	case -EALREADY:
>> -		err =3D 0;
>> -		fallthrough;
>> -
>> -	default:
>> -		drbg->random_ready.func =3D NULL;
>> -		return err;
>> -	}
>> -
>> -	return err;
>> +	return 0;
>>  }
>>=20
>>  /*
>> @@ -1646,11 +1613,6 @@ static int drbg_instantiate(struct drbg_state *dr=
bg,
>> struct drbg_string *pers, */
>>  static int drbg_uninstantiate(struct drbg_state *drbg)
>>  {
>> -	if (drbg->random_ready.func) {
>> -		del_random_ready_callback(&drbg->random_ready);
>> -		cancel_work_sync(&drbg->seed_work);
>> -	}
>> -
>>  	if (!IS_ERR_OR_NULL(drbg->jent))
>>  		crypto_free_rng(drbg->jent);
>>  	drbg->jent =3D NULL;
>> diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
>> index 3ebdb1effe74..a6c3b8e7deb6 100644
>> --- a/include/crypto/drbg.h
>> +++ b/include/crypto/drbg.h
>> @@ -137,12 +137,10 @@ struct drbg_state {
>>  	bool pr;		/* Prediction resistance enabled? */
>>  	bool fips_primed;	/* Continuous test primed? */
>>  	unsigned char *prev;	/* FIPS 140-2 continuous test value */
>> -	struct work_struct seed_work;	/* asynchronous seeding support */
>>  	struct crypto_rng *jent;
>>  	const struct drbg_state_ops *d_ops;
>>  	const struct drbg_core *core;
>>  	struct drbg_string test_data;
>> -	struct random_ready_callback random_ready;
>>  };
>>=20
>>  static inline __u8 drbg_statelen(struct drbg_state *drbg)

--=20
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, G=
ermany
(HRB 36809, AG N=C3=BCrnberg), GF: Felix Imend=C3=B6rffer
