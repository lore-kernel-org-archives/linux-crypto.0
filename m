Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A24C64EC4
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Mar 2023 13:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjCJNiv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Mar 2023 08:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjCJNiu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Mar 2023 08:38:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EEC132CD
        for <linux-crypto@vger.kernel.org>; Fri, 10 Mar 2023 05:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678455481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fQBGbJjgaLk8frNmhF457eNNSWcksiHp6zG+s8bL6ks=;
        b=ikxknUjvZcqZO0TvoEKXOhbQ+q1MHiwftvvQZeT6E6u5BNJgQkYg7gtUuWUwaQrWQC+0mP
        q3xNBcK3kUqfPn4h92g6Ksj65TFKDBDF7tHzOEUzILGGb6p68/LMN+RA4WzYKnojvtxiVl
        g2fMgaUiMuGHev4HWnlzyIP1bqjamIE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-RGrQUy1aPqG0s0ZphR1hfw-1; Fri, 10 Mar 2023 08:38:00 -0500
X-MC-Unique: RGrQUy1aPqG0s0ZphR1hfw-1
Received: by mail-ed1-f72.google.com with SMTP id ev6-20020a056402540600b004bc2358ac04so7814213edb.21
        for <linux-crypto@vger.kernel.org>; Fri, 10 Mar 2023 05:38:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678455479;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fQBGbJjgaLk8frNmhF457eNNSWcksiHp6zG+s8bL6ks=;
        b=ghhjdYesXmlvK8lIWl/dweqgBXbn3hoaOR9qnjQM3SoQlWjF/xXT9guEibJ+J+D5AZ
         QZ5WXb3O/sZ2UvdTPTRwaSt+fkrFBvffTkKf3MtaIHYsxQ74qlq5PUgnh36LXIa4pWA0
         AV8HrbfYDwww7ZqdZzwepeGmiDCpJw1U14qMCv3xviYXwnAkAuNNdTTxYsYb411QKgtG
         9K9og6GUw8JJdjQzEuSl+MuXUVmMia91S0jejbssiNwEk0hw2a6/d7wnohTRUkKrxJQP
         aEQFQhUV8q3e39dJYswsf2dDk/FO0BIRqHmQk+2Te4jVV1QddLj0wVzY8j5j7PD1j4uK
         +WhQ==
X-Gm-Message-State: AO0yUKVfQ84WU9EV4/l9XC3CygJP24mnieEKKB+fjRnRXPzsr/aPHla1
        34Y4sc4KIeaIshhLrBRrObxQKiYHQmV3fSs9itI+IGyUpAHNLvkBXQBSHBpFNyFae6E54E3fMuV
        T09dZubA4/m45+Phvy1Mb+QUo
X-Received: by 2002:a17:907:6c16:b0:8b1:7fe8:1c38 with SMTP id rl22-20020a1709076c1600b008b17fe81c38mr26117283ejc.43.1678455479309;
        Fri, 10 Mar 2023 05:37:59 -0800 (PST)
X-Google-Smtp-Source: AK7set/8005G0zE0HYXEMHFoB55pYZJ1/lEZ4gvFFcjQE9JUKB8Ab8YRXy+T1UG0le3hLHZOAWPDpA==
X-Received: by 2002:a17:907:6c16:b0:8b1:7fe8:1c38 with SMTP id rl22-20020a1709076c1600b008b17fe81c38mr26117257ejc.43.1678455478975;
        Fri, 10 Mar 2023 05:37:58 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id b13-20020a170906d10d00b008be5b97ca49sm966738ejz.150.2023.03.10.05.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 05:37:58 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8C2EF9E263E; Fri, 10 Mar 2023 14:37:57 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Mathew McBride <matt@traverse.com.au>,
        linux-crypto@vger.kernel.org
Subject: Re: Hitting BUG_ON in crypto_unregister_alg() on reboot with
 caamalg_qi2 driver
In-Reply-To: <ZAqwTqw3lR+dnImO@gondor.apana.org.au>
References: <87r0tyq8ph.fsf@toke.dk> <ZAqwTqw3lR+dnImO@gondor.apana.org.au>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 10 Mar 2023 14:37:57 +0100
Message-ID: <87ilf8rakq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Thu, Mar 09, 2023 at 03:51:22PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Hi folks
>>=20
>> I'm hitting what appears to be a deliberate BUG_ON() in
>> crypto_unregister_alg() when rebooting my traverse ten64 device on a
>> 6.2.2 kernel (using the Arch linux-aarch64 build, which is basically an
>> upstream kernel).
>>=20
>> Any idea what might be causing this? It does not appear on an older
>> (5.17, which is the newest kernel that works reliably, for unrelated
>> reasons).
>
> On the face of it this looks like a generic issue with drivers
> and the Crypto API.  Historically crypto modules weren't meant
> to be removed/unregistered until the last user has freed the tfm.
>
> Obviously with drivers that start unregistering the algorithms when
> the hardware goes away this paradigm breaks.  What should happen is
> that the driver continues to hold onto the crypto algorithm registration
> even when the hardware has gone away.
>
> Some work has to be done in the driver to actually make this safe
> (all the drivers I've looked at are broken in this way).

Hmm, okay; any idea why this started happening with the newer kernel
version? I don't see any changes to the driver that could have caused
this; so is it some core-kernel change that has changed the
order of driver removal on shutdown or something?

Also, absent of a fixed driver (which doesn't sound like it's a trivial
fix?), how do I prevent the system from crashing on shutdown? The
BUG_ON() seems a bit heavy-handed, could it be replaced with a WARN_ON?

-Toke

