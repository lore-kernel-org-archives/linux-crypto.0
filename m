From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v3] dm: switch dm-verity to async hash crypto API
Date: Mon, 20 Feb 2017 13:51:24 +0100
Message-ID: <1e21d973-b345-54a9-8115-cc3e30364051@gmail.com>
References: <1487508367-16036-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, gilad.benyossef@arm.com,
        Ofir Drang <ofir.drang@arm.com>,
        Eric Biggers <ebiggers3@gmail.com>,
        =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?=
        <omosnacek+linux-crypto@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com,
        Alasdair Kergon <agk@redhat.com>,
        MIKE Snitzer <snitzer@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33836 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751330AbdBTMv1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Feb 2017 07:51:27 -0500
Received: by mail-wm0-f66.google.com with SMTP id c85so14214848wmi.1
        for <linux-crypto@vger.kernel.org>; Mon, 20 Feb 2017 04:51:26 -0800 (PST)
In-Reply-To: <1487508367-16036-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/19/2017 01:46 PM, Gilad Ben-Yossef wrote:
> Use of the synchronous digest API limits dm-verity to using pure
> CPU based algorithm providers and rules out the use of off CPU
> algorithm providers which are normally asynchronous by nature,
> potentially freeing CPU cycles.
> 
> This can reduce performance per Watt in situations such as during
> boot time when a lot of concurrent file accesses are made to the
> protected volume.
> 
> Move DM_VERITY to the asynchronous hash API.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> CC: Eric Biggers <ebiggers3@gmail.com>
> CC: Ondrej Mosnáček <omosnacek+linux-crypto@gmail.com>
> CC: Milan Broz <gmazyland@gmail.com>
> ---
> 
> The patch was tested on an Armv7 based dual core Zynq ZC706 development
> board with SHA256-asm, SHA256-neon synchronous providers with no visible
> degradation of performance, with cryptd based asynchronous versions of the 
> same and with an off tree Arm CryptoCell asynchronous provider.
> 
> Changes from v2:
> 
> - Use completion to potentially wait also on crypto_ahash_init() as it
>   may finish asynchronously as well in some drivers, such as cryptd, as
>   discovered by Milan Broz.

This version survived my simple veritysetup test (in cryptsetup package)
with forced async path so I think it is ok for 4.12 queue...

Thanks,
Milan


> - Use sg_init_one() where apropriate as pointed out by Milan Broz.
> 
> Changes from v1:
> 
> - Use a 0 mask to allocate crypto alg indicating we welcome async algo 
>   providers, as suggested by Ondrej Mosnáček.
> - Fix use of un-initialized completion when using async provider for IO
>   blocks hashing
> - Pass flag indicating we are OK with crypto provider backlog
> - Re-factor checking for need to wait into a common function
> 
