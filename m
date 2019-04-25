Return-Path: <SRS0=5M5o=S3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5243DC43219
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 20:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 585BF2077C
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 20:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556223178;
	bh=88RpeUBzb0X1D03/gg6kKwn4xLH8iqQsz0Sllw+D5TQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=gMGcDQ0oY3nuh90eyhUzmWPjxSrf1pwXIeTEQ2C24Dp0YBpJZEMMFk9kB9PGmjeyi
	 7O8zNcOudGbuFQuNg4UNkhj3lnbXaEz8vPhiK/UehZkz7fTOMucsFsI89rcggKEjHF
	 rtL3Bcm7cEXdK0hctyjDVH22bRObOTw8uagKEMsc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbfDYUM5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Apr 2019 16:12:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbfDYUM4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Apr 2019 16:12:56 -0400
Received: from localhost (62-193-50-229.as16211.net [62.193.50.229])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA71720717;
        Thu, 25 Apr 2019 20:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556223176;
        bh=88RpeUBzb0X1D03/gg6kKwn4xLH8iqQsz0Sllw+D5TQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=exR8pLk4Vz7pcfsTDSson1gAT5LG70NZbynyKGrMl3s3PRBMmWbkUmoKlzIY3q9Mh
         tIA+mjIGU6WxSNtWxnEkbxbocBnNa4jAF4zktKu4feJi0IL3fmQIuQ3tr3nUaQfkoc
         nE4MhcQGjWshDVORN+Mf/gPYGPLAyrf8APngKCBY=
Date:   Thu, 25 Apr 2019 22:12:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kimberly Brown <kimbrownkd@gmail.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] kobject: Add default group support to kobj_type
 and replace subsystem uses
Message-ID: <20190425201253.GA12131@kroah.com>
References: <20190322201440.GA30814@ubu-Virtual-Machine>
 <cover.1554151487.git.kimbrownkd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1554151487.git.kimbrownkd@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 01, 2019 at 10:51:10PM -0400, Kimberly Brown wrote:
> This patchset adds support for default attribute groups to kobj_type.
> Also, the uses of kobj_type's default_attrs field are replaced with
> default_groups in the following subsystems:
>  - samples
>  - block
>  - net
>  - irq
>  - padata
>  - cpufreq
>  - livepatch
> 
> The subsystem maintainers and lists will be copied on the subsystem
> patches.
> 
> The uses of kobj_type's default_attrs field in the other subsystems will
> be replaced in future patchsets.

Thanks for all of these, now queued up.  Patches to fix up the other
subsystems are always welcome :)

greg k-h
