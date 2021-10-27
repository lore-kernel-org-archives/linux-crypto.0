Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A80BC433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 10:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74355610A3
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 10:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238986AbhJ0KC2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Oct 2021 06:02:28 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:37928 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241492AbhJ0KBx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Oct 2021 06:01:53 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 92A061FD3B;
        Wed, 27 Oct 2021 09:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635328767; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kNuMns/lFc+q5NdSRt/8ucNrQbkjmOfQfueI5a2yskA=;
        b=0KMoiY6s0n2PppbCIKhx/5C3wQwGa6OkfqmzMcFPWlR9HVgXVwQTkbUorEkX8WdNu+gFK2
        WZ8WgPYkRvWTLnPwxRMCWxcNtw8DGb0GTIrLMIsDCGbFELDWCKQd0pMTVes2G0XtSjvQyw
        3AeQobChNP7Cx4IvSRwm3BtKT1iINW4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635328767;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kNuMns/lFc+q5NdSRt/8ucNrQbkjmOfQfueI5a2yskA=;
        b=jCiJfcO+yLcv9BvSFfARVqgQ4WvXDjGPojg/QfVKSCB89f0dpHNsAV44BKas+1e2Sgir4v
        lJ3BAa8BGyKt/GBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4A22213B85;
        Wed, 27 Oct 2021 09:59:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id iGZDEP8ieWHaOgAAMHmgww
        (envelope-from <nstange@suse.de>); Wed, 27 Oct 2021 09:59:27 +0000
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
        <20211008115432.GC26495@gondor.apana.org.au> <87lf30rmd8.fsf@suse.de>
        <20211022115146.GA27997@gondor.apana.org.au>
Date:   Wed, 27 Oct 2021 11:59:26 +0200
In-Reply-To: <20211022115146.GA27997@gondor.apana.org.au> (Herbert Xu's
        message of "Fri, 22 Oct 2021 19:51:46 +0800")
Message-ID: <87zgqupz41.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Mon, Oct 11, 2021 at 10:34:11AM +0200, Nicolai Stange wrote:
>>
>> In order to keep a FIPS certification manageable in terms of scope,
>> we're looking for a way to disable everything under drivers/crypto iff
>> fips_enabled =3D=3D 1. The most convenient way to achieve this downstream
>> would be to add dummy entries to testmgr.c like so:
>
> How about testing based on the flag CRYPTO_ALG_KERN_DRIVER_ONLY?
> That flag is meant to correspond to pretty much exactly
> drivers/crypto.

Hmm, I checked a couple of crypto/drivers and it seems like not all are
setting this flag: random examples would include cavium/nitrox/,
chelsio/, padlock*.c, vmx/, ...

Many thanks!

Nicolai

--=20
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, G=
ermany
(HRB 36809, AG N=C3=BCrnberg), GF: Felix Imend=C3=B6rffer
