Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A9AEE4993
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Aug 2023 11:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbjHULXs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Aug 2023 07:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbjHULXr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Aug 2023 07:23:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F7BD8;
        Mon, 21 Aug 2023 04:23:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00F016100B;
        Mon, 21 Aug 2023 11:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0EFC433C8;
        Mon, 21 Aug 2023 11:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692617025;
        bh=v4yx1jU68ILujJ9Flvf3NQrZH6ekak8E8uv+0YCIRjk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=osKG4OpylgJrXV6nktjlRCaGsfMdp5qEq0SFhzKunOWwS8T26Ar+H87wl7UjUf8LY
         KukTl4j4PPMqsJGAGDloN8Zc1Vw4oV5zj7XghPq/rn6PiwzJP2ZxhgS9VCz93HNaAh
         fPStFfWIc578y09Gl86Qfi7HDhbznVqm66x4rGMKJ7a2JplF8Y5v+qg7GgbF20BozV
         n4MGcoj9Y/REeNWKwa/dtv6Qa6yF8sKhCvsSRHCT1xeEwOaXyEpjvawOJqAh+oAu9l
         95scwyVykPL9Q5GG5IltfF/wlaqS5RBdbef+1BRU1a+SavPIRgg2hvbNS1tvZWS4Fz
         m6XogVB1qC8xQ==
Message-ID: <c750428f-cbeb-53f5-5865-fa0af263b15e@kernel.org>
Date:   Mon, 21 Aug 2023 13:23:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH] linux/container_of.h: Add memberof()
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     qat-linux@intel.com, Alejandro Colomar <alx.manpages@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
References: <ZN8v/2McQboR3dIu@smile.fi.intel.com>
 <20230820195222.279069-1-alx@kernel.org>
 <ZONIFMSmLZMeFPOY@smile.fi.intel.com>
Content-Language: en-US
From:   Alejandro Colomar <alx@kernel.org>
Organization: Linux
In-Reply-To: <ZONIFMSmLZMeFPOY@smile.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Andy,

On 2023-08-21 13:18, Andy Shevchenko wrote:
> On Sun, Aug 20, 2023 at 09:52:22PM +0200, Alejandro Colomar wrote:
>>  
>> -#define typeof_member(T, m)	typeof(((T*)0)->m)
>> +
>> +#define memberof(T, member)  ((T){}.member)
> 
> I'm not sure. This seems to me utilization of compound literal, while above
> uses direct struct member pointer calculations.

Both can be used in most cases.  The only exception is offsetof(3), where
you need the pointer calculation.  The good thing about the compound
literal is that it's farther away from causing UB, but if that's not a
concern --using sizeof() or typeof() will usually make things safe from
UB, as there's really no dereference, but just to be a little paranoic--,
I could change the definition of memberof() to use the pointer thing.

Should I send a v2 with the pointer thing?

[I'll take some time, as I need to restore my USB with keys, which just
died yesterday.  I didn't sign this email due to that.]

Cheers,
Alex

> 
>> +#define typeof_member(T, m)  typeof(memberof(T, m))
> 

-- 
<http://www.alejandro-colomar.es/>
GPG key fingerprint: A9348594CE31283A826FBDD8D57633D441E25BB5

