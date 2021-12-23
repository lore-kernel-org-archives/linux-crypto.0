Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD2B1C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Dec 2021 08:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347071AbhLWIVT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Dec 2021 03:21:19 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:49170 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235068AbhLWIVR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Dec 2021 03:21:17 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5178B1F38A;
        Thu, 23 Dec 2021 08:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1640247675;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hkp4oq/GTlT3C2w2FcpXm9BbAR1EEooPyBUeE3/RCKw=;
        b=CeNO+1U4fEIDGBQqZxaIfIJW3rFoe/QT6Dg6oMWUtczsB63EKd5hvR4N8ZEv8m6u+mXREp
        rPpPYb6bZvt2tJX7EQIQfptyqADwarJPUTcNfH033Sw9zpPO3HjGhPNWDWoRUvvik3z0kg
        d+HfcorjAMisYeNyIF4LtjHDW6jSBzE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1640247675;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hkp4oq/GTlT3C2w2FcpXm9BbAR1EEooPyBUeE3/RCKw=;
        b=JkraYgQfjsZ0tcFnvBjpo6r1HcN19hjjU5nSjmgILg6fWCTLofopPEPG0RRzCYeiRaYaFl
        SQXwFYZgiULDycBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0F79813E82;
        Thu, 23 Dec 2021 08:21:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Iav8AHsxxGH/YAAAMHmgww
        (envelope-from <pvorel@suse.cz>); Thu, 23 Dec 2021 08:21:15 +0000
Date:   Thu, 23 Dec 2021 09:21:13 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, Cyril Hrubis <chrubis@suse.cz>
Subject: Re: ELIBBAD vs. ENOENT for ciphers not allowed by FIPS
Message-ID: <YcQxeW/hzS7cCUCs@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <YcN4S7NIV9F0XXPP@pevik>
 <YcOh6jij1s6KA2ee@gondor.apana.org.au>
 <YcOlw1UJizlngAEG@quark>
 <YcOnRRRYbV/MrRhO@gondor.apana.org.au>
 <YcOqoGOLfNTZh/ZF@quark>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcOqoGOLfNTZh/ZF@quark>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert, Eric,

[ Cc Cyril ]

> On Thu, Dec 23, 2021 at 09:31:33AM +1100, Herbert Xu wrote:
> > On Wed, Dec 22, 2021 at 04:25:07PM -0600, Eric Biggers wrote:

> > > Isn't it just an implementation detail that !fips_allowed is handled by the
> > > self-test?  Wouldn't it make more sense to report ENOENT for such algorithms?

> > ELIBBAD does not necessarily mean !fips_allowed, it could also
> > mean a specific implementation (or hardware) failed the self-test.
Herbert, Thanks for confirmation this was intended.

> > Yes, we could change ELIBBAD to something else in the case of
> > !fips_allowed, but it's certainly not a trivial change.

> > Please give a motivation for this.

> > Thanks,

> Some of the LTP tests check for ENOENT to determine whether an algorithm is
> intentionally unavailable, as opposed to it failing due to some other error.
> There is code in the kernel that does this same check too, e.g.
> fs/crypto/keysetup.c and block/blk-crypto-fallback.c.

> The way that ELIBBAD is overloaded to mean essentially the same thing as ENOENT,
> but only in some cases, is not expected.

> It would be more logical for ELIBBAD to be restricted to actual test failures.

> If it is too late to change, then fine, but it seems like a bug to me.

Not sure if it's a bug or not. With ENOENT everybody would understand missing
algorithm (no fix needed in the software). OTOH ELIBBAD allow to distinguish the
reason (algorithm was there, but disabled).

Kind regards,
Petr

> - Eric
