Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B75C54EAA
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Jan 2023 12:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjA3MyW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Jan 2023 07:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjA3MyV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Jan 2023 07:54:21 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B19310E3;
        Mon, 30 Jan 2023 04:54:21 -0800 (PST)
Received: from [2a02:8108:963f:de38:4bc7:2566:28bd:b73c]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pMTfs-0000cR-QZ; Mon, 30 Jan 2023 13:54:16 +0100
Message-ID: <d018d4ba-802d-76f4-0892-97b033fbc7bb@leemhuis.info>
Date:   Mon, 30 Jan 2023 13:54:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [Bug 216888] New: "sysfs: cannot create duplicate filename
 /dma/dma0chan0" with 68dbe80f ("crypto: ccp - Release dma channels before
 dmaengine unrgister")
Content-Language: en-US, de-DE
From:   "Linux kernel regression tracking (#update)" 
        <regressions@leemhuis.info>
To:     Bjorn Helgaas <helgaas@kernel.org>, Koba Ko <koba.ko@canonical.com>
Cc:     vsd@suremail.info, Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        regressions@lists.linux.dev
Reply-To: Thorsten Leemhuis <regressions@leemhuis.info>,
          Linux regressions mailing list 
          <regressions@lists.linux.dev>
References: <20230105174736.GA1154719@bhelgaas>
 <7b38ae22-b13d-64af-7c79-a56cdba26754@leemhuis.info>
In-Reply-To: <7b38ae22-b13d-64af-7c79-a56cdba26754@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1675083261;c0db296e;
X-HE-SMSGID: 1pMTfs-0000cR-QZ
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

[TLDR: This mail in primarily relevant for Linux kernel regression
tracking. See link in footer if these mails annoy you.]

On 06.01.23 09:38, Linux kernel regression tracking (#adding) wrote:
> On 05.01.23 18:47, Bjorn Helgaas wrote:
>> Per the report, this is a regression and reverting 68dbe80f5b51
>> ("crypto: ccp - Release dma channels before dmaengine unrgister"),
>> which appeared in v6.1, avoids the problem.
>>
>> The bugzilla is assigned to PCI, and I know PCI does have similar
>> sysfs duplicate filename issues, but I don't know whether this
>> instance is related to 68dbe80f5b51 or to the PCI core.
>>
>> On Thu, Jan 05, 2023 at 03:12:26PM +0000, bugzilla-daemon@kernel.org wrote:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=216888

#regzbot fix: crypto: ccp - Failure on re-initialization due to
duplicate sysfs filename

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.

#regzbot ignore-activity
