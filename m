Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78AF7C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 17:25:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40BC9207F7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 17:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgH0RZe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 13:25:34 -0400
Received: from gw.c-home.cz ([89.24.150.100]:41048 "EHLO dmz.c-home.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgH0RZe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 13:25:34 -0400
Received: from dmz.c-home.cz (localhost [127.0.0.1])
        by dmz.c-home.cz (8.14.4+Sun/8.14.4) with ESMTP id 07RHN0fg019155;
        Thu, 27 Aug 2020 19:23:05 +0200 (CEST)
Received: from localhost (martin@localhost)
        by dmz.c-home.cz (8.14.4+Sun/8.14.4/Submit) with ESMTP id 07RHMrKp019152;
        Thu, 27 Aug 2020 19:22:53 +0200 (CEST)
X-Authentication-Warning: dmz.c-home.cz: martin owned process doing -bs
Date:   Thu, 27 Aug 2020 19:22:53 +0200 (CEST)
From:   Martin Cerveny <martin@c-home.cz>
Reply-To: Martin Cerveny <M.Cerveny@computer.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
cc:     Martin Cerveny <M.Cerveny@computer.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [SOLVED] Re: PROBLEM: SHA1 on Allwinner V3s failed
In-Reply-To: <20200826115209.GA830@Red>
Message-ID: <alpine.GSO.2.00.2008271922190.19151@dmz.c-home.cz>
References: <alpine.GSO.2.00.2008260919550.23953@dmz.c-home.cz> <20200826090738.GA6772@Red> <alpine.GSO.2.00.2008261256100.29556@dmz.c-home.cz> <20200826115209.GA830@Red>
User-Agent: Alpine 2.00 (GSO 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Ok. I will send patch ASAP.

Regards, Martin

On Wed, 26 Aug 2020, Corentin Labbe wrote:

> On Wed, Aug 26, 2020 at 01:33:20PM +0200, Martin Cerveny wrote:
>> Hello.
>>
>> On Wed, 26 Aug 2020, Corentin Labbe wrote:
>>> On Wed, Aug 26, 2020 at 09:52:30AM +0200, Martin Cerveny wrote:
>>>> Hello.
>>>>
>>>> [1.] One line summary of the problem:
>>>>
>>>> SHA1 on Allwinner V3s failed
>>>>
>>> Since only SHA1 is failling, could you try to use the "allwinner,sun8i-a33-crypto", just in case V3s has the same SHA1 HW quirck than A33.
>>
>> Yes. This do the trick. All startup verification passes now.
>> Performance (SHA1 with sha1-sun4i-ss) "tcrypt mode=303 sec=1" test output attached.
>> So, all seems to be working now. Released new patch with possibility to merge.
>>
>> https://github.com/mcerveny/linux/commit/e3c76436de3d8cd2b2ddaeadef879a4a4d723bf4
>>
>> Regards, Martin
>
> For proper solution, a new compatible "allwinner,sun8i-v3s-crypto" should be added instead.
> Furthermore it should be added in sun4i-ss-core.s along with a new variant for v3s with .sha1_in_be = True.
>
> The new compatible should also be added in Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
>
> Regards
>
