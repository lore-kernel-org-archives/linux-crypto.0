Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52806C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 14:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237699AbhKVPCM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 10:02:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233427AbhKVPCM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 10:02:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637593145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sk7BFBCbKYZJ2jJnbUMcJfbKUen3vUYJmNdShhlxjn0=;
        b=cEdNrK4ZcDBYmNUPVIyfTewT/4dLyDW2DH3BbmOQO92RJldAjvDqODwg8mv01tryTwarIR
        6K3YV/QSyvvGPUjZ6syPI4nf3Puzj4kyyYKnm/lhrBxDAZC+wGzFG0qdIkO9ZBM95j30ou
        Os/uehHkqQa4oPqPrMLtEiW688mivaM=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-4T5_36THOemTnNRdHjvxNg-1; Mon, 22 Nov 2021 09:59:04 -0500
X-MC-Unique: 4T5_36THOemTnNRdHjvxNg-1
Received: by mail-qv1-f72.google.com with SMTP id j9-20020a05621419c900b003b815c01a54so16527039qvc.10
        for <linux-crypto@vger.kernel.org>; Mon, 22 Nov 2021 06:59:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=sk7BFBCbKYZJ2jJnbUMcJfbKUen3vUYJmNdShhlxjn0=;
        b=GqiE3ivv+JJFh7ITbO82a+UNfqfC8cEimJc09aKg4Do+A5rgG419lFdmdwTWe0EYJ1
         evPSPNt3mw6qgfcE0pMpegjyTprqYK48SBg2/sjt2rJWJ4n1mqKLqmRQorShQP+gRaMh
         TyxNNSDhGexJWYCrywwjh1dOozhc/TT2dj7PSbs+9Ju8MDloFmHdmJIFAXE9U530cZDm
         nGsl4F2P38RvToPjC0rosS/5Vm8qLAFou+yZADV7iKdOlym4ZQ5/erM/ySdHDB65yaPf
         88ZGroawelQHzn34kcJRQf8sUIF2vViMccyPAEvyMb/Ej/nI5aQwDMwwGDsk7AP+Zkq6
         8n3Q==
X-Gm-Message-State: AOAM5333NwILdWn9d6vxtsWbYCcTRt/78x94N646ydc7mRaaAH/bY52g
        AmUfykHqiNGqCfP/YBUMxUd8fQV27hZssCEF+fqQG9qADN0tjyeTcqrwTyRtG/lSUfsjSZqQrA4
        r1TtLNPCqc3iR2yuVNOprIkkm
X-Received: by 2002:ad4:5969:: with SMTP id eq9mr77549261qvb.4.1637593144043;
        Mon, 22 Nov 2021 06:59:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzE73nVSJPJ9NSL1qvqhsJNhTJ2dEHbz8x9DfS5SCRbaxOQhliNKDhxAmK2WklmGGj03dFoew==
X-Received: by 2002:ad4:5969:: with SMTP id eq9mr77549217qvb.4.1637593143784;
        Mon, 22 Nov 2021 06:59:03 -0800 (PST)
Received: from m8.users.ipa.redhat.com (cpe-158-222-141-151.nyc.res.rr.com. [158.222.141.151])
        by smtp.gmail.com with ESMTPSA id x4sm4630894qtw.44.2021.11.22.06.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 06:59:02 -0800 (PST)
Message-ID: <56d2da397bb53f71c0354b102c3b40940e9b4eda.camel@redhat.com>
Subject: Re: [PATCH v43 01/15] Linux Random Number Generator
From:   Simo Sorce <simo@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
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
Date:   Mon, 22 Nov 2021 09:59:01 -0500
In-Reply-To: <CAHmME9oaS4TOpk7rQ73BRKeVLjMUNyt6EFyeOX=hZSkFBPDu0g@mail.gmail.com>
References: <2036923.9o76ZdvQCi@positron.chronox.de>
         <4641592.OV4Wx5bFTl@positron.chronox.de>
         <CAHmME9oaS4TOpk7rQ73BRKeVLjMUNyt6EFyeOX=hZSkFBPDu0g@mail.gmail.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Jason,
have you previously produced a list of reasoned concerns with this
patchset and direction?

This specific email is not really useful to me to understand the
concerns as it does not contain actionable suggestion or critique.

I personally find the direction fine, and with my distribution hat on I
can say that FIPS is essential for us and any design must include an
option to be FIPS certifiable.

As NIST keeps improving their testing capabilities and rigorous
cryptographic design of the CSPRNGs as well as entropy sources the
kernel must also adapt.

Stephan is providing a path forward, and I haven't seen any other
proposal, let alone code, that provide improvements in this area.
I am pretty sure the design can be improved if there is detailed and
actionable feedback on what to change.

I hope the path forward can be one of collaboration rather then mere
opposition.

HTH,
Simo.

On Sun, 2021-11-21 at 23:42 +0100, Jason A. Donenfeld wrote:
> Hi Stephan,
> 
> You've posted it again, and yet I still believe this is not the
> correct design or direction. I do not think the explicit goal of
> extended configurability ("flexibility") or the explicit goal of being
> FIPS compatible represent good directions, and I think this introduces
> new problems rather than solving any existing ones. While there are
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
> 
> Jason
> 

-- 
Simo Sorce
RHEL Crypto Team
Red Hat, Inc




