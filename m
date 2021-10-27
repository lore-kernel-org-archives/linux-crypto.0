Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 723B3C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 08:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51C1861075
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 08:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239450AbhJ0Imk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Oct 2021 04:42:40 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:41484 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239439AbhJ0Imj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Oct 2021 04:42:39 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7F276218F0;
        Wed, 27 Oct 2021 08:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635324013; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GMgN2A9bmbMdtRlwQcHYangnfGuiIHJ49tFSvs6PWNU=;
        b=Jeb72/Mj+bAi+4FBH876ysPMOc8EOW235meNyAYbu2TNosqxTWyPg8OvtWA/XuOIuWYC1h
        yxTsnV5s26nWKZZyia/D3TiEc4GtGUvKfLYbKRZMCp5X0mXyA6XYg8IqO8DLfOurwA0Vm9
        /3M7xaE3cNxeLWlW+SUqt5Ll8brNAgg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635324013;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GMgN2A9bmbMdtRlwQcHYangnfGuiIHJ49tFSvs6PWNU=;
        b=6HdkBqs9l+N0CGtaF0ZehpcbP7GX36GexBMXr06DOIB+2b6hoZEg4jOXUvcFBTiNsA+iNe
        s4eAooRPPMM159DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3806713A2C;
        Wed, 27 Oct 2021 08:40:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MUjTC20QeWEMFAAAMHmgww
        (envelope-from <nstange@suse.de>); Wed, 27 Oct 2021 08:40:13 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolai Stange <nstange@suse.de>, Torsten Duwe <duwe@suse.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] crypto: DRBG - improve 'nopr' reseeding
References: <20211025092525.12805-1-nstange@suse.de>
        <2120606.3HGXcN3vsr@positron.chronox.de>
Date:   Wed, 27 Oct 2021 10:40:12 +0200
In-Reply-To: <2120606.3HGXcN3vsr@positron.chronox.de> ("Stephan
 \=\?utf-8\?Q\?M\=C3\=BCller\=22's\?\=
        message of "Tue, 26 Oct 2021 10:33:05 +0200")
Message-ID: <87zgqurhcj.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

first of all, many thanks for your prompt review!

Stephan M=C3=BCller <smueller@chronox.de> writes:

> Am Montag, 25. Oktober 2021, 11:25:19 CEST schrieb Nicolai Stange:
>
>
>> - Replace the asynchronous random_ready_callback based DRBG reseeding
>>   logic with a synchronous solution leveraging rng_is_initialized().
>
> Could you please help me why replacing an async method with a sync method=
 is=20
> helpful? Which problems do you see with the async method that are allevia=
ted=20
> with the swtich to the sync method? In general, an async method is more=20
> powerful, though it requires a bit more code.

There is no problem with the async method (*), I just don't see any
advantage over the less complex approach of doing all reseeding
work synchronously from drbg_generate().

Before the change, there had been two sites taking care of reseeding:
the drbg_async_seed() work handler scheduled from the
random_ready_callback and drbg_generate().

After the change, all reseeding is handled at a single place only, namely
drbg_generate(), which, in my opinion, makes it easier to reason about.
In particular, in preparation for patch 6/6 from this series introducing
yet another condition for triggering a reseed...

Thanks,

Nicolai

(*) Except for that a wait_for_random_bytes() issued by DRBG users won't
    give any guarantees with respect to a subsequent drbg_generate()
    operation, c.f. my other mail in reply to your review on 3/6 I'm
    about to write in a second. As of now, there aren't any DRBG users
    invoking wait_for_random_bytes(), but one might perhaps consider
    changing that in the future.

>>   This
>>   move simplifies the code IMO and, as a side-effect, would enable DRBG
>>   users to rely on wait_for_random_bytes() to sync properly with
>>   drbg_generate(), if desired. Implemented by patches 1-5/6.
>> - Make the 'nopr' DRBGs to reseed themselves every 5min from
>>   get_random_bytes(). This achieves at least kind of a partial prediction
>>   resistance over the time domain at almost no extra cost. Implemented
>>   by patch 6/6, the preceding patches in this series are a prerequisite
>>   for this.

--=20
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, G=
ermany
(HRB 36809, AG N=C3=BCrnberg), GF: Felix Imend=C3=B6rffer
