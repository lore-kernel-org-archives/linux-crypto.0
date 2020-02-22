Return-Path: <SRS0=tFxg=4K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B5DC35671
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Feb 2020 19:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9790420707
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Feb 2020 19:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582398173;
	bh=DpUM/OsF1FK0wRQ2NhZ1OXxzKYvkGiF6L8aCVgMDtOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=19ftU4RUFIV2NP65snVwjD7FmWWCg+YdcGBlnFZkwa/j3v+IQSMPr92jUyp2VsMMt
	 kAZQZ9YF9Fdij4vXDQuATVLT6QXv6h8gUySbPalE2H4UQb2gB8ovkbDmtj2MeORpnP
	 chZQ7v6V3CXeokJeKlKA4MeLjvg20HdmOAXCTC3A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgBVTCx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Feb 2020 14:02:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbgBVTCw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Feb 2020 14:02:52 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4A4F206EF;
        Sat, 22 Feb 2020 19:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582398172;
        bh=DpUM/OsF1FK0wRQ2NhZ1OXxzKYvkGiF6L8aCVgMDtOA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JrBLp1qVxkmorY9bHIuXnzxPpJ2ddR19kuinzPOhnrx4Sv2AUO2/0tWyPo6G9QsBo
         o5A+L75o4/+JRQfRlXWnGZg8RwZ+Om2MH+L63l2bh4zP4Lm6fgaVyZ/fMvemTn/aTq
         Cz6l5TryGnnh0fHEM6nZIA5Qi5nuUUeR35iSavuk=
Date:   Sat, 22 Feb 2020 14:02:50 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 4.19 061/191] padata: always acquire cpu_hotplug_lock
 before pinst->lock
Message-ID: <20200222190250.GD26320@sasha-vm>
References: <20200221072250.732482588@linuxfoundation.org>
 <20200221072258.745173144@linuxfoundation.org>
 <20200222000045.cl45vclfhvkjursm@ca-dmjordan1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200222000045.cl45vclfhvkjursm@ca-dmjordan1.us.oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 21, 2020 at 07:00:45PM -0500, Daniel Jordan wrote:
>On Fri, Feb 21, 2020 at 08:40:34AM +0100, Greg Kroah-Hartman wrote:
>> From: Daniel Jordan <daniel.m.jordan@oracle.com>
>>
>> [ Upstream commit 38228e8848cd7dd86ccb90406af32de0cad24be3 ]
>>
>> lockdep complains when padata's paths to update cpumasks via CPU hotplug
>> and sysfs are both taken:
>>
>>   # echo 0 > /sys/devices/system/cpu/cpu1/online
>>   # echo ff > /sys/kernel/pcrypt/pencrypt/parallel_cpumask
>>
>>   ======================================================
>>   WARNING: possible circular locking dependency detected
>>   5.4.0-rc8-padata-cpuhp-v3+ #1 Not tainted
>>   ------------------------------------------------------
>>   bash/205 is trying to acquire lock:
>>   ffffffff8286bcd0 (cpu_hotplug_lock.rw_sem){++++}, at: padata_set_cpumask+0x2b/0x120
>>
>>   but task is already holding lock:
>>   ffff8880001abfa0 (&pinst->lock){+.+.}, at: padata_set_cpumask+0x26/0x120
>>
>>   which lock already depends on the new lock.
>
>I think this patch should be dropped from all stable queues (4.4, 4.9, 4.14,
>4.19, 5.4, and 5.5).
>
>The main benefit is to un-break lockdep for testing with future padata changes,
>and an actual deadlock seems unlikely.
>
>These stable versions don't fix the ordering in padata_remove_cpu() either
>(nothing calls it though).
>
>I tried the other stable padata patch in this cycle ("padata: validate cpumask
>without removed CPU during offline"), it passed my tests and should stay in.

I've dropped it, thanks.

-- 
Thanks,
Sasha
