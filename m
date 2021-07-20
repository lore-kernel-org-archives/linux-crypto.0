Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5147C07E95
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 15:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3471610FB
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 15:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239902AbhGTOVn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jul 2021 10:21:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49425 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239618AbhGTOOp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jul 2021 10:14:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626792910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hfTy+/pS/KzMBH2y9VMJnUs0qvlciTECo+EvOT9Ucu0=;
        b=N4+jj7bjV8aPf1pY1kl3lXFXTz7Gl05JAyjuLo/3IfDh5KpguP5VWQzo1dQ6SB31CMBGs7
        jQm05ONXLPWW3A23RayD5fY8w7mvxICy4sMk/JyE6b1Nm1P3JBh49ZKKbke8FRVAXX8mKK
        ZSyFmAUTgXn6atoHTexhi+5lqLulI+Y=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-CUM2eDbiOaWgwS1P2Oq0aw-1; Tue, 20 Jul 2021 10:45:01 -0400
X-MC-Unique: CUM2eDbiOaWgwS1P2Oq0aw-1
Received: by mail-ed1-f72.google.com with SMTP id g23-20020aa7c8570000b02903954c05c938so5391149edt.3
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jul 2021 07:45:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=hfTy+/pS/KzMBH2y9VMJnUs0qvlciTECo+EvOT9Ucu0=;
        b=jI42ql+RmxBSOOqYhv5lXpPmNQywBNZ+7Xgj+USC5SmptCpqWt3L5OM/B+j3lpayPu
         G4QRLztDlMNAMjrb4Og3ZSO+UZpSjXaSvV5jZT5Wp68ghUlowa0kNYfmpxVYFh0vZaiN
         QhVzK+ptJt/uSHMoATKh8wXEb/bdP4lkUHlPoC3u3lJYLu5wSxrkYLc6VAoz0TnwV1C5
         N6BA/ekdVEcJFFvBM36x+6o+mepf2Jqlw5l137sb79BmwbsFasDDW8ae3fBCrr/fIiOK
         f6emYb7cAk0TbE0i+PfiZEHs7XWDlPW84HFJ5nHblseF505RXtrJhFPMl9K3xICYHSWM
         ifsg==
X-Gm-Message-State: AOAM531cUeERpDYeGTVFWJ/z9VP9en3H4C3hW2P0nSdOwKMQfTjpBQWB
        Wu1omoi7oujACJjS51R4fYunRf7rGlDrTq9eRKy92hwWZzFj1ISIqI6lbr2Hw4gR8Hd3QYG/2r+
        Mg5C8ZOc/akMD5ECdvlYl5P+c
X-Received: by 2002:a05:6402:1a25:: with SMTP id be5mr41478456edb.123.1626792299931;
        Tue, 20 Jul 2021 07:44:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwZb2w4R3+PQAgLZhB4esRR1ex3IgU8wV7HFBjL/IETvaJklgYg1N8nXPDCD9YqDnDyM5jgQ==
X-Received: by 2002:a05:6402:1a25:: with SMTP id be5mr41478431edb.123.1626792299801;
        Tue, 20 Jul 2021 07:44:59 -0700 (PDT)
Received: from m8.users.ipa.redhat.com ([93.56.160.10])
        by smtp.gmail.com with ESMTPSA id r17sm9395099edt.33.2021.07.20.07.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 07:44:59 -0700 (PDT)
Message-ID: <5ec6c8d5a0259a2d632589c154093ebfbbcdb47b.camel@redhat.com>
Subject: Re: [PATCH 09/11] nvmet: Implement basic In-Band Authentication
From:   Simo Sorce <simo@redhat.com>
To:     Hannes Reinecke <hare@suse.de>,
        Stephan Mueller <smueller@chronox.de>,
        Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Date:   Tue, 20 Jul 2021 10:44:58 -0400
In-Reply-To: <4cd673a8-a503-c29a-85f6-3c2703558181@suse.de>
References: <20210716110428.9727-1-hare@suse.de>
         <2510347.locV8n3378@positron.chronox.de>
         <a4d4bda0-2bc8-0d0c-3e81-55adecd6ce52@suse.de>
         <6538288.aohFRl0Q45@positron.chronox.de>
         <59695981-9edc-6b7a-480a-94cca95a0b8c@suse.de>
         <463a191b9896dd708015645cfc125988cd5deaef.camel@chronox.de>
         <2af95a8e-50d9-7e2d-a556-696e9404fee4@suse.de>
         <740af9f7334c294ce879bef33985dfab6d0523b3.camel@chronox.de>
         <1eab1472-3b7b-307b-62ae-8bed39603b96@suse.de>
         <24d115c9b68ca98a3cf363e1cfcb961cc6b38069.camel@chronox.de>
         <aac9448e-29e9-6d03-1077-148be3c10f50@suse.de>
         <11ab4001f580a6b2c3cce959282259c1f9095f63.camel@redhat.com>
         <4cd673a8-a503-c29a-85f6-3c2703558181@suse.de>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 2021-07-20 at 13:31 +0200, Hannes Reinecke wrote:
> On 7/20/21 12:49 PM, Simo Sorce wrote:
> > On Tue, 2021-07-20 at 12:14 +0200, Hannes Reinecke wrote:
> > > On 7/19/21 1:52 PM, Stephan Mueller wrote:
> > > > Am Montag, dem 19.07.2021 um 13:10 +0200 schrieb Hannes Reinecke:
> > > > > On 7/19/21 12:19 PM, Stephan Mueller wrote:
> > > > > > Am Montag, dem 19.07.2021 um 11:57 +0200 schrieb Hannes Reinecke:
> > > > > > > On 7/19/21 10:51 AM, Stephan Mueller wrote:
> > > [ .. ]
> > > > > > > > 
> > > > > > > > Thank you for clarifying that. It sounds to me that there is no
> > > > > > > > defined protocol (or if there, I would be wondering how the code would have
> > > > > > > > worked
> > > > > > > > with a different implementation). Would it make sense to first specify
> > > > > > > > a protocol for authentication and have it discussed? I personally think
> > > > > > > > it is a bit difficult to fully understand the protocol from the code and
> > > > > > > > discuss protocol-level items based on the code.
> > > > > > > > 
> > > > > > > Oh, the protocol _is_ specified:
> > > > > > > 
> > > > > > >  
> > > > > > > https://nvmexpress.org/wp-content/uploads/NVM-Express-Base-Specification-2_0-2021.06.02-Ratified-5.pdf
> > > > > > > 
> > > > > > > It's just that I have issues translating that spec onto what the kernel
> > > > > > > provides.
> > > > > > 
> > > > > > according to the naming conventions there in figures 447 and following:
> > > > > > 
> > > > > > - x and y: DH private key (kernel calls it secret set with dh_set_secret
> > > > > > or
> > > > > > encoded into param.key)
> > > > > > 
> > > > > 
> > > > > But that's were I got confused; one needs a private key here, but there
> > > > > is no obvious candidate for it. But reading it more closely I guess the
> > > > > private key is just a random number (cf the spec: g^y mod p, where y is
> > > > > a random number selected by the host that shall be at least 256 bits
> > > > > long). So I'll fix it up with the next round.
> > > > 
> > > > Here comes the crux: the kernel has an ECC private key generation function
> > > > ecdh_set_secret triggered with crypto_kpp_set_secret using a NULL key, but it
> > > > has no FFC-DH counterpart.
> > > > 
> > > > That said, generating a random number is the most obvious choice, but not the
> > > > right one.
> > > > 
> > > > The correct one would be following SP800-56A rev 3 and here either section
> > > > 5.6.1.1.3 or 5.6.1.1.4.
> > > > 
> > > Hmm. Okay. But after having read section 5.6.1.1.4, I still do have some
> > > questions.
> > > 
> > > Assume we will be using a bit length of 512 for FFDHE, then we will
> > > trivially pass Step 2 for all supported FFDHE groups (the maximum
> > > symmetric-equivalent strength for ffdhe8192 is 192 bits).
> > 
> > N = 512 is not a good choice, minimum length these days for DH should
> > be 2048 or more.
> > 
> 
> According to RFC7919:
> Peers using ffdhe8192 that want to optimize their key exchange with a
> short exponent (Section 5.2) should choose a secret key of at least
> 400 bits.
> 
> So what is wrong with 512 bits?


RFC7519 is TLS Specific.
I do not know if short-exponents are safe to use in all use cases.

If it is safe, your choice is fine and your arguments will follow, but
then a comment that explains the choice and warns about key checks if
it is changed would be a good idea.

Otherwise the default should be to use N = len(q), which implies the
proper checks need to be applied.

Simo.

> > > From my understanding, the random number generator will fill out all
> > > available bytes in the string (and nothing more), so we trivially
> > > satisfy step 3 and 4.
> > > 
> > > And as q is always larger than the random number, step 6 reduces to
> > > 'if (c > 2^N - 2)',
> > 
> > Where is this coming from ?
> > It seem you assume M = 2^N but M = min(2^N, q)
> > 
> > The point here is to make sure the number X you return is:
> > 0 < X < (q-1)
> > 
> 
> Which is what I've tried to argue. For 512 bits private key and the
> smallest possible FFDHE group (which has 2048 bits, with the top bit
> non-zero) 2^N is always smaller than (q - 1).
> As the other FFHDE groups are using even larger 'q' values, this is true
> for all FFHDE groups.
> 
> > >  ie we just need to check if the random number is a
> > > string of 0xff characters. Which hardly is a random number at all, so
> > > it'll be impossible to get this.
> > > 
> > > Which then would mean that our 'x' is simply the random number + 1,
> > 
> > This is an artifact due to the random number being 0 <= c < 2^N - 1,
> > therefore 1 needs to be added to make sure you never return 0.
> > 
> 
> And my argument here is that all zeros (and all ones) are not a value I
> would expect from our RNG.
> 
> > > which arguably is slightly pointless (one more than a random number is
> > > as random as the number itself), so I do feel justified with just
> > > returning a random number here.
> > > 
> > > Am I wrong with that reasoning?
> > 
> > Looks to me you are not accounting for the fact that N = 512 is too
> > small and a random number falling in the interval (q - 2) < X < 2^N is
> > unsuitable?
> > 
> 
> Only if (q - 2) < 2^N. And my point is that it's not.
> 
> Cheers,
> 
> Hannes

-- 
Simo Sorce
RHEL Crypto Team
Red Hat, Inc




