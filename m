Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE65C001DB
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Aug 2023 13:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjHENE0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Aug 2023 09:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjHENEZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Aug 2023 09:04:25 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4632CE70;
        Sat,  5 Aug 2023 06:04:24 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1qSGx9-0006Nn-V8; Sat, 05 Aug 2023 15:04:20 +0200
Message-ID: <0ca063c6-eaa2-0123-21cb-65d4a33550f4@leemhuis.info>
Date:   Sat, 5 Aug 2023 15:04:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: [PATCH] crypto: caam - adjust RNG timing to support more devices
Content-Language: en-US, de-DE
To:     Bastian Krause <bst@pengutronix.de>, meenakshi.aggarwal@nxp.com,
        horia.geanta@nxp.com, V.sethi@nxp.com, pankaj.gupta@nxp.com,
        gaurav.jain@nxp.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Victoria Milhoan <vicki.milhoan@freescale.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Vipul Kumar <vipul_kumar@mentor.com>, kernel@pengutronix.de,
        Linux kernel regressions list <regressions@lists.linux.dev>
References: <20230612082615.1255357-1-meenakshi.aggarwal@nxp.com>
 <e1f3f073-9d5e-1bae-f4f8-08dc48adad62@pengutronix.de>
From:   "Linux regression tracking #adding (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
In-Reply-To: <e1f3f073-9d5e-1bae-f4f8-08dc48adad62@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1691240664;c7d254f9;
X-HE-SMSGID: 1qSGx9-0006Nn-V8
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

[CCing the regression list, as it should be in the loop for regressions:
https://docs.kernel.org/admin-guide/reporting-regressions.html]

[TLDR: I'm adding this report to the list of tracked Linux kernel
regressions; the text you find below is based on a few templates
paragraphs you might have encountered already in similar form.
See link in footer if these mails annoy you.]

On 17.07.23 14:43, Bastian Krause wrote:
> On 6/12/23 10:26, meenakshi.aggarwal@nxp.com wrote:
>> From: Victoria Milhoan <vicki.milhoan@freescale.com>
>>
>> Adjust RNG timing parameters to support more i.MX6 devices.
>>
>> Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
>> Signed-off-by: Dan Douglass <dan.douglass@nxp.com>
>> Signed-off-by: Vipul Kumar <vipul_kumar@mentor.com>
>> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
>> ---
>>   drivers/crypto/caam/ctrl.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> This patch seems to breaks CAAM RNG instantiation on an i.MX8MM at my end:
> [...]

Thanks for the report. I see that people are working on it already. But
to be sure the issue doesn't fall through the cracks unnoticed, I'm
adding it to regzbot, the Linux kernel regression tracking bot:

#regzbot ^introduced ef492d08030
#regzbot title crypto: broke CAAM RNG instantiation on an i.MX8MM
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Developers: When fixing the issue, remember to add 'Link:' tags pointing
to the report (the parent of this mail). See page linked in footer for
details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.

