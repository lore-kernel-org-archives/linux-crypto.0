Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 085E7C6FD1C
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Mar 2023 16:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjCKQWS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Mar 2023 11:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjCKQWR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Mar 2023 11:22:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C68103387
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 08:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678551688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cjwbbGdNjwEE3PeL3PIWv9RC3eljWWjNEdskHWmi30k=;
        b=aNwibVdXNCRFSC7X2kVFOh4B5zt1GySMyjFmZWxgNTumAiFgKf8/2R0koQNn5/wkn0Z2gR
        /OkFD1egiGftiU/V/Wi9CMq63nssGCgXYg9hbk1eLuPor4lI5QdA4uNWkIZLVDPxdkhPH8
        tfZ/oB/zwjkDcojAyrX2LdMXbmf67ns=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-4VfkA-yFPByxkYaMXbhynQ-1; Sat, 11 Mar 2023 11:21:27 -0500
X-MC-Unique: 4VfkA-yFPByxkYaMXbhynQ-1
Received: by mail-ed1-f72.google.com with SMTP id p36-20020a056402502400b004bb926a3d54so11463474eda.2
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 08:21:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678551686;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cjwbbGdNjwEE3PeL3PIWv9RC3eljWWjNEdskHWmi30k=;
        b=golScBm+SoU6PanhN3eM5y/ONTVpnWHa0GQ+Tszd8ktQKIjzSPA+HD6gNn8TEwqbMt
         QCyTVaM++R908cMmM/g9HPkHLYN3Mj+VaXLgtZiUwsmA70HY9Zn0bGT2rHYoi5gCr4ci
         W1m4yAbvIq6KbPNHdlnDBUWo9DmoP/QTG49HOjsW6mQCe8hmNie/cx2gorixH4MGcvxD
         vQ4vNTTLsB8V1F6OGmdN0maYkDZJeYcRHBkwDpGHdmk/jl0VwF0IirSsW0xPOxXhuWPC
         3y4CeJmXltCzXd1zBxoO7Nxc8YWNQkNnJwHVU+fcFevX6Zrl6kVCNDVwl4eHGE25Y9JP
         tuqg==
X-Gm-Message-State: AO0yUKUlWknPKTNL9BKI18gJF55Kvbfo+mptUjwb5veF3Ln9rcNT5X7j
        zNh0JLxFNcvFrG/IL1nVZTNTT1f7bBcITAyhoUlP1+jrpLMQdjvkZH9Y2uZ4w6zeNgz0kRTnN+1
        q6BzIa0jv4uo9oYP3nWpLBEvako+Ipi8t
X-Received: by 2002:a05:6402:150d:b0:4fb:5291:13bb with SMTP id f13-20020a056402150d00b004fb529113bbmr272701edw.39.1678551685712;
        Sat, 11 Mar 2023 08:21:25 -0800 (PST)
X-Google-Smtp-Source: AK7set+353apJunFwL0exwW9m3vOvXI2eTOsxeZ6GDq6KD1VsnKPnSsMdD1l5MIgjMWO71bawAu0ew==
X-Received: by 2002:a05:6402:150d:b0:4fb:5291:13bb with SMTP id f13-20020a056402150d00b004fb529113bbmr272676edw.39.1678551685047;
        Sat, 11 Mar 2023 08:21:25 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k15-20020a50ce4f000000b004d8287c775fsm1369950edj.8.2023.03.11.08.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 08:21:23 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A653F9E2872; Sat, 11 Mar 2023 17:21:21 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Mathew McBride <matt@traverse.com.au>,
        linux-crypto@vger.kernel.org
Subject: Re: Hitting BUG_ON in crypto_unregister_alg() on reboot with
 caamalg_qi2 driver
In-Reply-To: <ZAw16S7OQyYCAK90@gondor.apana.org.au>
References: <87r0tyq8ph.fsf@toke.dk> <ZAqwTqw3lR+dnImO@gondor.apana.org.au>
 <87ilf8rakq.fsf@toke.dk> <ZAw16S7OQyYCAK90@gondor.apana.org.au>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 11 Mar 2023 17:21:21 +0100
Message-ID: <87h6urqmwu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Fri, Mar 10, 2023 at 02:37:57PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>>
>> Also, absent of a fixed driver (which doesn't sound like it's a trivial
>> fix?), how do I prevent the system from crashing on shutdown? The
>> BUG_ON() seems a bit heavy-handed, could it be replaced with a WARN_ON?
>
> Yes I think that's probably OK.  Could you please send a patch?

Sure, can do! :)

-Toke

