Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD1CC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Feb 2022 13:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240803AbiBWNP0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Feb 2022 08:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240811AbiBWNPZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Feb 2022 08:15:25 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC79A9E3C
        for <linux-crypto@vger.kernel.org>; Wed, 23 Feb 2022 05:14:56 -0800 (PST)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 2AE14405D7
        for <linux-crypto@vger.kernel.org>; Wed, 23 Feb 2022 13:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645622095;
        bh=luA2pGmBUiuoHCIdDEpQqIZrDzzhrlzhl8j+UonA2Ac=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=mW66cIedSAsuDjnUgGaNyqbdPCSTZuJdByBbh9V/bzHVbU0KWAJq/FqywIBT3gLBA
         A+waDQZWEO8OWvlVWm6cKTm7DX/2BeArZAf9hsDdzAS10qJ7qwcAUsfNp8gwduwE9x
         9qT75kNsh/1LAbv9fVgf/NjX1/KKiA5h7EWvyRO0Fw8sQl7Kj8/k3Duy2PcqAHZW7C
         SO5QWEprYJo5Ixl2XAhk/bHZcMwRqVhvG4WuWBKbBUf0i8THRtk9ZHafIElimJz3I+
         MObd4AGfRhTyCMBp8nHGIYwsFj2SFeOG3eX6/5UZB69R5pONa8Oqhpo1IiSgPjHwTP
         PsM1mmtM/Wp2w==
Received: by mail-ej1-f71.google.com with SMTP id i20-20020a17090671d400b006d0ed9c68c1so3816757ejk.14
        for <linux-crypto@vger.kernel.org>; Wed, 23 Feb 2022 05:14:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=luA2pGmBUiuoHCIdDEpQqIZrDzzhrlzhl8j+UonA2Ac=;
        b=QkV/ZapXTAozNlpqF0DbWONPmn6ObYuZKTlvw6walvAyGdUX82tD19ZAyJBXokJNee
         P4q1LBuu0+ppaEiB8xfti/nCFeQiftrq4x7zYhmyJAQkY32Q99Shm2Jla3HFVDE2Yk81
         y+B/5Rv40662O/JeRUPS8XYUE0yJ8rtcpKwXIHPGOac+4MYNPdE8JthilIyHvnywEvzv
         buehT1rUVj7Vs355on/Y/URn5+5zRwVSRd9He+Ze8LiMzS6O1p8sWVAxi2BBjEuQCh4W
         Fya0UbWoCK+b/66pxxvCLNgD0QNPATactBubGcWQ9yhYF7G1Y/Xz3D0+K3+K3GvrEHHG
         aFhQ==
X-Gm-Message-State: AOAM532yG5WqCXIhLx6eCbsRXQw1mROY8KxX4MTa1f/N8AuxQoHEZrEU
        zvR8abtP55IKK9UUG7KLBoT/Qf2nxbK4H1efuW8AJizDyhvDEeS2KYN3z1qGCE5zJNYP656crwe
        UPXZsoZx8+/qeQ9IyO745Qu0FBcM6kOqhPHAFHcnp9g==
X-Received: by 2002:a17:906:af79:b0:6ce:61d3:7e9b with SMTP id os25-20020a170906af7900b006ce61d37e9bmr23250133ejb.191.1645622094743;
        Wed, 23 Feb 2022 05:14:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzPXOdScuO9l5oh+CHacL1L0JeFIZjGDBcMotv+/pc0BsZ6IXhLfsZQvcbVqSbjklwZ5f51Fg==
X-Received: by 2002:a17:906:af79:b0:6ce:61d3:7e9b with SMTP id os25-20020a170906af7900b006ce61d37e9bmr23249825ejb.191.1645622089612;
        Wed, 23 Feb 2022 05:14:49 -0800 (PST)
Received: from [192.168.0.125] (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id z13sm603406edb.54.2022.02.23.05.14.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 05:14:49 -0800 (PST)
Message-ID: <99c673e7-09ea-ce0f-f8b7-b03ca35e8740@canonical.com>
Date:   Wed, 23 Feb 2022 14:14:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3] dt-bindings: crypto: convert rockchip-crypto to yaml
Content-Language: en-US
To:     LABBE Corentin <clabbe@baylibre.com>,
        Johan Jonker <jbx6244@gmail.com>
Cc:     heiko@sntech.de, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        robh+dt@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net
References: <20220211115925.3382735-1-clabbe@baylibre.com>
 <f078ac6f-5605-7b86-5734-cbbf7dc52c71@gmail.com> <YhYxLmBYa+DMCnuz@Red>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <YhYxLmBYa+DMCnuz@Red>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 23/02/2022 14:05, LABBE Corentin wrote:
> Le Tue, Feb 15, 2022 at 03:07:56PM +0100, Johan Jonker a écrit :
>> Hi Heiko,
>>
>> On 2/11/22 12:59, Corentin Labbe wrote:
>>> Convert rockchip-crypto to yaml
>>>
>>> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
>>> ---
>>> Changes since v1:
>>> - fixed example
>>> - renamed to a new name
>>> - fixed some maxItems
>>>
>>> Change since v2:
>>> - Fixed maintainers section
>>>
>>>  .../crypto/rockchip,rk3288-crypto.yaml        | 66 +++++++++++++++++++
>>>  .../bindings/crypto/rockchip-crypto.txt       | 28 --------
>>>  2 files changed, 66 insertions(+), 28 deletions(-)
>>>  create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
>>
>> rockchip,crypto.yaml
> 
> 
> Hello
> 
> DT maintainer asked for rockchip,rk3288-crypto, so I will keep it.

I don't insist on keeping rk32880crypto name. It depends whether the
bindings are for a family of devices or rather specific one or few
devices. Based on comments here, it is quite possible that all Rockchip
crypto blocks will fit into this bindings, so the name could be generic.

Having a specific name, even if it contains multiple devices, is also fine.

What I would prefer to avoid is to have a generic name
"rockchip,crypto.yaml" and then in two months one more generic
"rockchip,crypto2.yaml", and then add third...

> 
>>
>>>  delete mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
>>> new file mode 100644
>>> index 000000000000..2e1e9fa711c4
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
>>> @@ -0,0 +1,66 @@
>>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>>> +%YAML 1.2
>>> +---
>>> +$id: http://devicetree.org/schemas/crypto/rockchip,rk3288-crypto.yaml#
>>
>> rockchip,crypto.yaml
>>
>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>> +
>>> +title: Rockchip Electronics And Security Accelerator
>>> +
>>> +maintainers:
>>> +  - Heiko Stuebner <heiko@sntech.de>
>>> +
>>> +properties:
>>> +  compatible:
>>
>>     oneOf:
>>       - const: rockchip,rk3288-crypto
>>       - items:
>>           - enum:
>>               - rockchip,rk3228-crypto
>>               - rockchip,rk3328-crypto
>>               - rockchip,rk3368-crypto
>>               - rockchip,rk3399-crypto
>>           - const: rockchip,rk3288-crypto
>>
>> rk3288 was the first in line that had support, so we use that as fall
>> back string.
> 
> I will dont add compatible which are not handled by the driver unless DT maintainer said I should.

They could be added for completeness because bindings describe rather
hardware, not Linux driver state, but there is no such must. It can also
be added later by another contributor.


Best regards,
Krzysztof
