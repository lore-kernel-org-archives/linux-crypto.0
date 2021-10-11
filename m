Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D283C433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Oct 2021 08:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4362B60EE3
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Oct 2021 08:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234936AbhJKIgP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Oct 2021 04:36:15 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36500 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbhJKIgN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Oct 2021 04:36:13 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4C3E221D77;
        Mon, 11 Oct 2021 08:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633941252; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vjTMnaMIidSncADrmKdnZ9CHj/C5fBzKzF+5i0zBF2I=;
        b=LNS2/fNBuU9QILyRScW4Eyh/vQhKN6X44seMw6vtodFuNnE4QRd6RQkcIZo/kz4KWMbDD1
        t3FrAVRJ72pk5gC0s8O1NU9UzCUgpV1XuDofbJUwQgPXpFLr4mPuw337/lPN2+YfFwHABi
        j1i3GobXlh7JFJASs5psL9L4RF4VpOo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633941252;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vjTMnaMIidSncADrmKdnZ9CHj/C5fBzKzF+5i0zBF2I=;
        b=MqkmZl5fy0w3Ul5pEvmvpY4Sz3jeN8BIlad5cyNiwImS+PJEQkOuYL578yE4CVG5AHNU98
        6Bzn95gRq6KkNcDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F2B3513C41;
        Mon, 11 Oct 2021 08:34:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bvt2OQP3Y2GaewAAMHmgww
        (envelope-from <nstange@suse.de>); Mon, 11 Oct 2021 08:34:11 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Nicolai Stange <nstange@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>,
        Torsten Duwe <duwe@suse.de>
Subject: Re: [PATCH 8/8] crypto: api - make the algorithm lookup priorize non-larvals
References: <20211003181413.12465-1-nstange@suse.de>
        <20211003181413.12465-9-nstange@suse.de>
        <20211008115432.GC26495@gondor.apana.org.au>
Date:   Mon, 11 Oct 2021 10:34:11 +0200
In-Reply-To: <20211008115432.GC26495@gondor.apana.org.au> (Herbert Xu's
        message of "Fri, 8 Oct 2021 19:54:32 +0800")
Message-ID: <87lf30rmd8.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Sun, Oct 03, 2021 at 08:14:13PM +0200, Nicolai Stange wrote:
>> crypto_alg_mod_lookup() invokes the crypto_larval_lookup() helper
>> to run the actual search for matching crypto_alg implementation and
>> larval entries. The latter is currently considering only the individual
>> entries' relative ->cra_priority for determining which one out of multip=
le
>> matches to return. This means that it would potentially dismiss a matchi=
ng
>> crypto_alg implementation in working state in favor of some pending
>> testing larval of higher ->cra_priority. Now, if the testmgr instance
>> invoked asynchronously on that testing larval came to the conclusion that
>> it should mark the tests as failed, any pending crypto_alg_mod_lookup()
>> waiting for it would be made to fail as well with -EAGAIN.
>>=20
>> In summary, crypto_alg_mod_lookup() can fail spuriously with -EAGAIN even
>> though an implementation in working state would have been available, nam=
ely
>> if the testmgr asynchronously marked another, competing implementation of
>> higher ->cra_priority as failed.
>>=20
>> This is normally not a problem at all with upstream, because the situati=
on
>> where one algorithm passed its tests, but another competing one failed to
>> do so, would indicate a bug anyway.
>>=20
>> However, for downstream distributions seeking FIPS certification, simply
>> amending the list in crypto/testmgr.c with ->fips_allowed =3D 0 entries
>> matching on ->cra_driver_name would provide a convenient way of
>> selectively blacklisting implementations from drivers/crypto in fips
>> mode. Note that in this scenario failure of competing crypto_alg
>> implementations would become more common, in particular during device
>> enumeration. If the algorithm in question happened to be needed for e.g.
>> module signature verification, module loading could spuriously fail duri=
ng
>> bootup, which is certainly not desired.
>>=20
>> For transparency: this has not actually been observed, I merely came to
>> the conclusion that it would be possible by reading the code.
>>=20
>> Make crypto_alg_lookup() run an additional search for non-larval matches
>> upfront in the common case that the request has been made for
>> CRYPTO_ALG_TESTED instances.
>>=20
>> Signed-off-by: Nicolai Stange <nstange@suse.de>
>> ---
>>  crypto/api.c | 21 ++++++++++++++++++++-
>>  1 file changed, 20 insertions(+), 1 deletion(-)

Hi Herbert,

> It's not clear that this new behaviour is desirable.  For example,
> when we construct certain complex algorithms, they may depend on a
> generic version of that same algorithm as a fallback.  We do not
> want users to get the generic version while the better version is
> being tested.

Ah I see, you mean something like having 3+ providers of "algXY",
 - algXY_driver0, ->cra_priority =3D 100
 - algXY_driver1, ->cra_priority =3D 200
 - algXY_driver1, ->cra_priority =3D 300
where the latter needs a different "algXY" as a fallback?

Hmm yes, I haven't thought of this and my patch here would indeed break
it.


> Can you please explain what your failure scenario and perhaps we
> can come up with another way of resolving your problem?

In order to keep a FIPS certification manageable in terms of scope,
we're looking for a way to disable everything under drivers/crypto iff
fips_enabled =3D=3D 1. The most convenient way to achieve this downstream
would be to add dummy entries to testmgr.c like so:

static int alg_test_nop(const struct alg_test_desc *desc, const char *drive=
r,
			u32 type, u32 mask)
{
	/* Succeed in non-FIPS mode. */
	return 0;
}

static const struct alg_test_desc alg_test_descs[] =3D {
	...,
	{
		.alg =3D "sha256-padlock-nano",
		.test =3D alg_test_nop,
		.fips_allowed =3D 0,
	},
        ...
};

The concern is about e.g the following sequence of events during boot:
- "sha256-padlock-nano" gets registered, the test gets scheduled.
- An unrelated modprobe is getting invoked. The signature verification
  code, e.g pkcs7_digest(), requests "sha256", finds the pending
  "sha256-padlock-nano" testing larval and puts itself in a wait for it.
- The scheduled "sha256-padlock-nano" test gets to run and, as per
  ->fips_allowed =3D=3D 0, is forced to fail with -EINVAL.
- pkcs7_digest() wakes up and fails with -EAGAIN due to the "failed"
  testing larval.
- The unrelated modprobe fails even though sha256-generic would
  have been available all the time.

FWIW, I picked sha256-padlock-nano and modprobe at random for the sake
of providing an example here -- I haven't checked in detail, but I guess
that e.g. the combination of dm-crypt + a number of different FIPS
approved algorithms could be similarly susceptible, too.

So to recap, my initial approach for working around the above was to
make crypto_alg_lookup() to skip over testing larvals in an additional,
first search. As you said, this would break the "fallback" scenario
though.

As an alternative, how about not doing the additional search for
non-larvals upfront, but only as a resort in case crypto_larval_wait()
returned failure instead?

But granted, the scenario above is not an issue at all for upstream with
a pristine testmgr.c and it would be quite relatable if you wouldn't
like to get bothered with any of this. I'm only bringing it up because
others might perhaps come across this as well...


Thanks!

Nicolai

--=20
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, G=
ermany
(HRB 36809, AG N=C3=BCrnberg), GF: Felix Imend=C3=B6rffer
