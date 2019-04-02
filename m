Return-Path: <SRS0=5Ot1=SE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A607EC43381
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Apr 2019 06:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68A062084C
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Apr 2019 06:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554186599;
	bh=3cdCwFG0qB3EXDXlA1qQ+fiqjqIrsqWKYpZKPFmq3NY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=l/Bcu3fXDjVnb3XVXzR0XfoceHd8pcKelpFn48nycVPft1+abQrYeBTuiP4ot+O4E
	 zQG4h3F0c6JacoTCjP4dnrbEICx8cv0qwCPS6h+RG5vorq+WR8OksEbnJwDTzeI+Z1
	 hd0fC7QiZQdiEJ1eW0XO0IJOyhXWSAY3TMkIX9F0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfDBG36 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Apr 2019 02:29:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbfDBG36 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Apr 2019 02:29:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97FA1206B7;
        Tue,  2 Apr 2019 06:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554186597;
        bh=3cdCwFG0qB3EXDXlA1qQ+fiqjqIrsqWKYpZKPFmq3NY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VRsMnf/qtqWRAr5kYLGAXOVw4JvfRl80f2zA0bV529qaUA9njPwps85sDunN+Qf+k
         wBk6V45E/Ry70g8L1H05dZ0Rzo0AZsdp/NGn33VghiFPJWA/5+nbxmtawL8J+mzwj7
         g8OUlsSxJQ9HufqSnPLcuuDJVwjrAHVu88Lw137A=
Date:   Tue, 2 Apr 2019 08:29:50 +0200
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
Message-ID: <20190402062950.GA7218@kroah.com>
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
> 
> Changes in v2:
>  - Patch 1 is not changed.
>  - Patches 2-8 are new.

Thanks so much for doing this.

As all of the different subsystems depend on the first patch, I'll be
glad to merge them all through my driver-core tree, or apply the first
one and wait a release cycle so that the others can go through the
individual subsystem's tree, depending on what the subsystem maintainer
is comfortable with.

thanks,

greg k-h
