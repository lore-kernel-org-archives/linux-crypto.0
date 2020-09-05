Return-Path: <SRS0=hz3R=CO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD48C433E2
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Sep 2020 15:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B54FC2078E
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Sep 2020 15:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgIEPyp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Sep 2020 11:54:45 -0400
Received: from gw.c-home.cz ([89.24.150.100]:41854 "EHLO dmz.c-home.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgIEPym (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Sep 2020 11:54:42 -0400
Received: from dmz.c-home.cz (localhost [127.0.0.1])
        by dmz.c-home.cz (8.14.4+Sun/8.14.4) with ESMTP id 085Fpslm003231;
        Sat, 5 Sep 2020 17:51:59 +0200 (CEST)
Received: from localhost (martin@localhost)
        by dmz.c-home.cz (8.14.4+Sun/8.14.4/Submit) with ESMTP id 085FpmfW003227;
        Sat, 5 Sep 2020 17:51:48 +0200 (CEST)
X-Authentication-Warning: dmz.c-home.cz: martin owned process doing -bs
Date:   Sat, 5 Sep 2020 17:51:48 +0200 (CEST)
From:   Martin Cerveny <martin@c-home.cz>
Reply-To: Martin Cerveny <M.Cerveny@computer.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
cc:     Maxime Ripard <maxime@cerno.tech>,
        Martin Cerveny <m.cerveny@computer.org>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v2 1/3] dt-bindings: crypto: add new compatible for V3s
In-Reply-To: <20200902062824.GA17544@Red>
Message-ID: <alpine.GSO.2.00.2009051749080.3102@dmz.c-home.cz>
References: <20200831073101.3608-1-m.cerveny@computer.org> <20200831073101.3608-2-m.cerveny@computer.org> <20200901093249.orwyc5sr3z2y43fz@gilmour.lan> <20200901105719.GA2639@Red> <20200901114015.qivovvjqvmhkicdl@gilmour.lan> <20200902062824.GA17544@Red>
User-Agent: Alpine 2.00 (GSO 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On Wed, 2 Sep 2020, Corentin Labbe wrote:
> On Tue, Sep 01, 2020 at 01:40:15PM +0200, Maxime Ripard wrote:
>> On Tue, Sep 01, 2020 at 12:57:19PM +0200, Corentin Labbe wrote:
>>> On Tue, Sep 01, 2020 at 11:32:49AM +0200, Maxime Ripard wrote:
>>>> On Mon, Aug 31, 2020 at 09:30:59AM +0200, Martin Cerveny wrote:
>>>>> Like A33 "sun4i-ss" has a difference, it give SHA1 digest
>>>>> directly in BE. So add new compatible.
>>>>>
>>>>> Tested-by: Martin Cerveny <m.cerveny@computer.org>
>>>>
>>>> The Tested-by tag is for the other developpers. You're very much
>>>> expected to have tested your patch before contributing it.
>>>>
>>>>> Signed-off-by: Martin Cerveny <m.cerveny@computer.org>
>>>>> ---
>>>>>  .../bindings/crypto/allwinner,sun4i-a10-crypto.yaml          | 5 ++++-
>>>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
>>>>> index fc823572b..180efd13a 100644
>>>>> --- a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
>>>>> +++ b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
>>>>> @@ -25,6 +25,7 @@ properties:
>>>>>            - const: allwinner,sun4i-a10-crypto
>>>>>        - items:
>>>>>            - const: allwinner,sun8i-a33-crypto
>>>>> +      - const: allwinner,sun8i-v3s-crypto
>>>>
>>>> If it's compatible with the A33, why do we need to introduce a new compatible?
>>>>
>>>>>
>>>>>    reg:
>>>>>      maxItems: 1
>>>>> @@ -59,7 +60,9 @@ if:
>>>>>    properties:
>>>>>      compatible:
>>>>>        contains:
>>>>> -        const: allwinner,sun6i-a31-crypto
>>>>> +        oneOf:
>>>>> +          - const: allwinner,sun6i-a31-crypto
>>>>> +          - const: allwinner,sun8i-v3s-crypto
>>>>
>>>> I guess the A33 compatible should be on that list as well?
>>>
>>> This is the list of "need reset".
>>> So we cannot use allwinner,sun8i-a33-crypto
>>> Probably this explanation should be in the commit message.
>>
>> But the A33 has a reset in the DTSI
>>
>
>
> Oh right so I need to send a fix for that and Martin Cerveny could simply use the "allwinner,sun8i-a33-crypto" (and so keep only patch #1(DTS))
>
> Regards
>

What is "right" solution for DTSI ?
- compatible = "allwinner,sun8i-a33-crypto";
OR
- compatible = "allwinner,sun8i-v3s-crypto", "allwinner,sun8i-a33-crypto";
(but unimplemented "allwinner,sun8i-v3s-crypto")

Regards
