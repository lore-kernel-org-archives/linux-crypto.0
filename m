Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB859C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 05:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhKVFjM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 00:39:12 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:12322 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbhKVFjL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 00:39:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1637559287;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=i7W+1Ainme/lgyEWP1ffFGfij4ISOJoBz/F7UBXS9sw=;
    b=sXSjU4exn0Iolbg/MfP7GdUjWb+2juATn6mfFPSknQk1iwOZhskJ84WAjHCVFrUJnd
    rWQ3k8OoQXlwLFfMbKQ9OWbR3Ne5KhotpXwkHMxBOuFgQgq4bqIoOfxcFd4oukB5fKqx
    cDv9bdTzvOeJlfklTvSdxHebiN98mejF9olqCInsc1LA2SZI4xb7gN8tANZYiXvqeZVQ
    gL9csV1HzTEgNDlXmvBi7pcUDRs+OrVBdJ1X9BZQ5juJnuG63WtrdRUDt/9MC534VFpb
    jRHCA6EnkoS8eTKutAJkTQHjxgfyCG94ujJ7dRk4E/HAb0Z+SulQjCAm3+Qb3XPwsh4i
    Tfew==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZIfSfAhhe"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.34.5 DYNA|AUTH)
    with ESMTPSA id U02dfbxAM5Yh4Wa
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 22 Nov 2021 06:34:43 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Tso Ted <tytso@mit.edu>, linux-crypto@vger.kernel.org,
        Willy Tarreau <w@1wt.eu>, Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Petr Tesarik <ptesarik@suse.cz>,
        John Haxby <john.haxby@oracle.com>,
        Alexander Lobakin <alobakin@mailbox.org>,
        Jirka Hladky <jhladky@redhat.com>
Subject: Re: [PATCH v43 01/15] Linux Random Number Generator
Date:   Mon, 22 Nov 2021 06:34:43 +0100
Message-ID: <2560758.ogP2UNPRoF@tauon.chronox.de>
In-Reply-To: <CAHmME9oaS4TOpk7rQ73BRKeVLjMUNyt6EFyeOX=hZSkFBPDu0g@mail.gmail.com>
References: <2036923.9o76ZdvQCi@positron.chronox.de> <4641592.OV4Wx5bFTl@positron.chronox.de> <CAHmME9oaS4TOpk7rQ73BRKeVLjMUNyt6EFyeOX=hZSkFBPDu0g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Sonntag, 21. November 2021, 23:42:33 CET schrieb Jason A. Donenfeld:

Hi Jason,

> Hi Stephan,
> 
> You've posted it again, and yet I still believe this is not the
> correct design or direction. I do not think the explicit goal of
> extended configurability ("flexibility") or the explicit goal of being
> FIPS compatible represent good directions, and I think this introduces
> new problems rather than solving any existing ones.

The members from the Linux distributions that are on copy on this may tell you 
a different story. They all developed their own downstream patches to somehow 
add the flexibility that is needed for them. So, we have a great deal of 
fragmentation at the resting-foundation of Linux cryptography.

Then the implementation of the flexibility in the LRNG is done such that 
irrespecitve of which options are selected, the LRNG operates always at a 
secure state.


> While there are
> ways the current RNG could or even should be improved -- or rewritten
> -- this approach is still not that, no matter how many times you post
> it. It is almost as though you hope this somehow gets accepted through
> a general apathy that might develop by the 1000th revision, when
> cranks like me and others no longer have the motivation to keep
> responding with the same thing. But here we are again.
> 
> My own experience pushing something that didn't have substantial
> enough buy-in from existing maintainers (the Zinc crypto library)
> ultimately led me to stop pushing in order to not alienate folks, step
> back, and listen a bit. Eventually somebody reached out to work with
> me (Ard) and we submitted a good compromise collaboration that we all
> generally felt better about. In this case, your cryptographic design
> tastes are sufficiently divergent from mine that I'm not sure how far
> such a thing would go, but it also seems to me that continually
> pushing the same thing over and over isn't winning you any points here
> either. Submission by attrition is not an outcome anybody should want.
> 
> Sorry to be so blunt. It's just that my, "I don't like this" is the
> same as it was the last time, and I'm not aware of anything
> significant in that area changing this time.

I have received numerous technical comments from various Linux developers. All 
were integrated. None of these comments hinted to requestes in changing the 
design.

That said, even when you refer to already suggested architectural differnces, 
I yet have to first receive them,
> 
> Jason


Ciao
Stephan


