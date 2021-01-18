Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0269BC433DB
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Jan 2021 07:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9783223E4
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Jan 2021 07:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731471AbhARHMa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Jan 2021 02:12:30 -0500
Received: from linux.microsoft.com ([13.77.154.182]:54366 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbhARHM3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Jan 2021 02:12:29 -0500
Received: from [192.168.0.114] (unknown [49.207.196.48])
        by linux.microsoft.com (Postfix) with ESMTPSA id C164420B7192;
        Sun, 17 Jan 2021 23:11:39 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C164420B7192
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1610953908;
        bh=V0aE8EFUyP+cRHKEGBZKB3N9pQMGLB+GauNbKYpryGM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=onZZkLEwbqcSVkIiu80wnBdOjg1oMz34fTyp9AadBIPBFOlkNmZhdqzZOoew0UWUB
         1MDe14FYNWYBi2KB6keTBrIjQKe/GbUIeDDEe4fawYqZyxTnheYg1iYqTEcNqkT1kh
         hs9yeHxcILe9+i/L5pi6dsakpJvF01uEaVqAYrX8=
Subject: Re: [PATCH v3 14/19] crypto: qat: convert tasklets to use new
 tasklet_setup() API
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Allen Pais <allen.lkml@gmail.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
        ludovic.desroches@microchip.com, jesper.nilsson@axis.com,
        lars.persson@axis.com, horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        gcherian@marvell.com, thomas.lendacky@amd.com, john.allen@amd.com,
        gilad@benyossef.com, bbrezillon@kernel.org, arno@natisbad.org,
        schalla@marvell.com, matthias.bgg@gmail.com, jamie@jamieiles.com,
        heiko@sntech.de, krzk@kernel.org, vz@mleia.com,
        k.konieczny@samsung.com, linux-crypto@vger.kernel.org,
        linux-mediatek@lists.infradead.org, qat-linux@intel.com,
        linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Romain Perier <romain.perier@gmail.com>
References: <20210112014650.10887-1-allen.lkml@gmail.com>
 <20210112014650.10887-15-allen.lkml@gmail.com>
 <20210114175109.GA8629@silpixa00400314>
From:   Allen Pais <apais@linux.microsoft.com>
Message-ID: <94926b18-2e1e-0b85-41b2-a7e894d21998@linux.microsoft.com>
Date:   Mon, 18 Jan 2021 12:41:36 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210114175109.GA8629@silpixa00400314>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



>>
>> In preparation for unconditionally passing the
>> struct tasklet_struct pointer to all tasklet
>> callbacks, switch to using the new tasklet_setup()
>> and from_tasklet() to pass the tasklet pointer explicitly.
> 
> I have two minor comments:
>    * Patches to the qat driver have the following headline
>          crypto: qat -
>    * Checkpatch reports two alignment checks when it is run with --strict:
>          CHECK: Alignment should match open parenthesis
>          #33: FILE: drivers/crypto/qat/qat_common/adf_isr.c:248:
>          +               tasklet_setup(&priv_data->banks[i].resp_handler,
>          +                            adf_response_handler);
> 
>          CHECK: Alignment should match open parenthesis
>          #62: FILE: drivers/crypto/qat/qat_common/adf_sriov.c:57:
>          +               tasklet_setup(&vf_info->vf2pf_bh_tasklet,
>          +                            adf_vf2pf_bh_handler);
> 
>          total: 0 errors, 0 warnings, 2 checks, 83 lines checked
> 
> If you prefer I can resubmit this patch with these two changes.

Thank you. I will fix them and re-submit.
